open Import

module Http_client = struct
  module Headers = Cohttp.Header
  module Body = Cohttp_lwt.Body

  module Response = struct
    include Cohttp.Response

    let status resp = Cohttp.Code.code_of_status (Cohttp.Response.status resp)
  end

  include Cohttp_lwt_unix.Client
end

module Acme = Letsencrypt.Client.Make (Http_client)

let gen_rsa ?seed () =
  X509.Private_key.generate
    ?seed:(Option.map Cstruct.of_string seed)
    ~bits:4096
    `RSA
(* Mirage_crypto_pk.Rsa.generate ?g ~bits:4096 () *)

let csr key host =
  match host with
  | None ->
    failwith "no hostname provided"
  | Some host ->
    (match Domain_name.of_string host with
    | Error (`Msg err) ->
      Logs.err (fun m -> m "invalid hostname provided %s" err);
      failwith "invalid hostname"
    | Ok _ ->
      let cn =
        X509.
          [ Distinguished_name.(Relative_distinguished_name.singleton (CN host))
          ]
      in
      X509.Signing_request.create cn key)

let tokens = Hashtbl.create 1

let solver _host ~prefix:_ ~token ~content =
  Hashtbl.replace tokens token content;
  Lwt.return (Ok ())

let handler request =
  let path = Dream.target request in
  match Astring.String.cuts ~sep:"/" ~empty:false path with
  | [ _well_known; _acme; token ] ->
    (match Hashtbl.find_opt tokens token with
    | Some data ->
      let headers = [ "content-type", "application/octet-stream" ] in
      Dream.respond ~headers ~status:`OK data
    | None ->
      Dream.not_found request)
  | _ ->
    Dream.not_found request

let router = Dream.router [ Dream.get "/.well-known/acme-challenge/**" handler ]

let provision_certificate ?email ?seed ?cert_seed ?hostname ~staging () =
  let endpoint =
    if staging then
      Letsencrypt.letsencrypt_staging_url
    else
      Letsencrypt.letsencrypt_production_url
  in
  let priv = gen_rsa ?seed:cert_seed () in
  match csr priv hostname with
  | Error (`Msg err) ->
    Logs.err (fun m -> m "couldn't create signing request %s" err);
    failwith "err"
  | Ok csr ->
    let open Lwt_result.Syntax in
    let* le = Acme.initialise ~endpoint ?email (gen_rsa ?seed ()) in
    let sleep sec = Lwt_unix.sleep (float_of_int sec) in
    let solver = Letsencrypt.Client.http_solver solver in
    let+ certs = Acme.sign_certificate solver le sleep csr in
    `Single (certs, priv)

let save_certificate_files
    ~certificate_file_path
    ~private_key_file_path
    (certificate : X509.Certificate.t list)
    (private_key : X509.Private_key.t)
  =
  let write_file_with_mkdir f s =
    let dirname = Filename.dirname f in
    if not (Sys.file_exists dirname && Sys.is_directory dirname) then
      Unix.mkdir_p dirname;
    Unix.write_file f s
  in
  let certificate_s =
    X509.Certificate.encode_pem_multiple certificate |> Cstruct.to_string
  in
  Logs.info (fun m ->
      m
        "saving certificate file with content %s to %s"
        certificate_s
        certificate_file_path);
  write_file_with_mkdir certificate_file_path certificate_s;
  let private_key_s =
    X509.Private_key.encode_pem private_key |> Cstruct.to_string
  in
  Logs.info (fun m ->
      m
        "saving certificate file with content %s to %s"
        private_key_s
        certificate_file_path);
  write_file_with_mkdir private_key_file_path private_key_s

let has_expired certs =
  List.map
    (fun c ->
      let _form, until = X509.Certificate.validity c in
      Ptime.is_earlier ~than:(Ptime_clock.now ()) until)
    certs
  |> List.exists (fun x -> x)

let provision_and_save
    ?email
    ?seed
    ?cert_seed
    ~hostname
    ~staging
    ~certificate_file_path
    ~private_key_file_path
    ()
  =
  let open Lwt.Syntax in
  let+ certificates, private_key =
    let+ certs_result =
      provision_certificate ?email ?seed ?cert_seed ~hostname ~staging ()
    in
    match certs_result with
    | Ok (`Single x) ->
      x
    | Error (`Msg err) ->
      failwith
        (Printf.sprintf "Could not get the certificate from letsencrypt %s" err)
  in
  save_certificate_files
    ~certificate_file_path
    ~private_key_file_path
    certificates
    private_key

let load_certificates
    ~certificate_file_path
    ~private_key_file_path
    ~hostname
    ~staging
    ?email
    ?seed
    ?cert_seed
    ()
  =
  let open Lwt.Syntax in
  if
    Sys.file_exists certificate_file_path
    && Sys.file_exists private_key_file_path
  then (* TODO(tmattio): Make sure the certificates are valid *)
    let certs =
      X509.Certificate.decode_pem_multiple
        (Cstruct.of_string (Unix.read_file certificate_file_path))
    in
    let private_key =
      X509.Private_key.decode_pem
        (Cstruct.of_string (Unix.read_file private_key_file_path))
    in
    match certs, private_key with
    | Ok certs, _private_key when not (has_expired certs) ->
      Lwt.return (certificate_file_path, private_key_file_path)
    | _ ->
      let+ () =
        provision_and_save
          ?email
          ?seed
          ?cert_seed
          ~hostname
          ~staging
          ~certificate_file_path
          ~private_key_file_path
          ()
      in
      certificate_file_path, private_key_file_path
  else
    let+ () =
      provision_and_save
        ?email
        ?seed
        ?cert_seed
        ~hostname
        ~staging
        ~certificate_file_path
        ~private_key_file_path
        ()
    in
    certificate_file_path, private_key_file_path

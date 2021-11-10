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

let rec mkdir_p ?perm dir =
  match dir with
  | "." | ".." ->
    ()
  | _ ->
    let mkdir_idempotent ?(perm = 0o755) dir =
      match Unix.mkdir dir perm with
      | () ->
        ()
      (* [mkdir] on MacOSX returns [EISDIR] instead of [EEXIST] if the directory
         already exists. *)
      | (exception Unix.Unix_error ((EEXIST | EISDIR), _, _))
      | (exception Sys_error _) ->
        ()
    in
    (match mkdir_idempotent ?perm dir with
    | () ->
      ()
    | exception (Unix.Unix_error (ENOENT, _, _) as exn) ->
      let parent = Filename.dirname dir in
      if String.equal parent dir then
        raise exn
      else (
        mkdir_p ?perm parent;
        mkdir_idempotent ?perm dir))

let write_to_file ~filename s =
  let dirname = Filename.dirname filename in
  if not (Sys.is_directory dirname) then mkdir_p dirname;
  let oc = open_out filename in
  output_string oc s;
  close_out oc

let save_certificate_files
    ~certificate_file_path
    ~private_key_file_path
    (certificate : X509.Certificate.t list)
    (private_key : X509.Private_key.t)
  =
  X509.Certificate.encode_pem_multiple certificate
  |> Cstruct.to_string
  |> write_to_file ~filename:certificate_file_path;
  X509.Private_key.encode_pem private_key
  |> Cstruct.to_string
  |> write_to_file ~filename:private_key_file_path

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
  if
    Sys.file_exists certificate_file_path
    && Sys.file_exists private_key_file_path
  then (* TODO(tmattio): Make sure the certificates are valid *)
    Lwt.return (certificate_file_path, private_key_file_path)
  else
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
          (Printf.sprintf
             "Could not get the certificate from letsencrypt %s"
             err)
    in
    save_certificate_files
      ~certificate_file_path
      ~private_key_file_path
      certificates
      private_key;
    certificate_file_path, private_key_file_path

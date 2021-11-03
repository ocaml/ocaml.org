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

let prefix = ".well-known", "acme-challenge"

let tokens = Hashtbl.create 1

let solver _host ~prefix:_ ~token ~content =
  Hashtbl.replace tokens token content;
  Lwt.return (Ok ())

let dispatch request =
  let path = Dream.target request in
  Logs.info (fun m -> m "let's encrypt dispatcher %s" path);
  match Astring.String.cuts ~sep:"/" ~empty:false path with
  | [ p1; p2; token ]
    when String.equal p1 (fst prefix) && String.equal p2 (snd prefix) ->
    (match Hashtbl.find_opt tokens token with
    | Some data ->
      let headers = [ "content-type", "application/octet-stream" ] in
      Dream.respond ~headers ~status:`OK data
    | None ->
      Dream.not_found request)
  | _ ->
    Dream.not_found request

let provision_certificate ~production ~email ~seed ~cert_seed ~hostname ~ctx =
  let open Lwt_result.Infix in
  let endpoint =
    if production then
      Letsencrypt.letsencrypt_production_url
    else
      Letsencrypt.letsencrypt_staging_url
  in
  let priv = gen_rsa ?seed:cert_seed () in
  match csr priv hostname with
  | Error (`Msg err) ->
    Logs.err (fun m -> m "couldn't create signing request %s" err);
    failwith "err"
  | Ok csr ->
    Acme.initialise ~ctx ~endpoint ?email (gen_rsa ?seed ()) >>= fun le ->
    let sleep sec = Lwt_unix.sleep (float_of_int sec) in
    let solver = Letsencrypt.Client.http_solver solver in
    Acme.sign_certificate ~ctx solver le sleep csr >|= fun certs ->
    `Single (certs, priv)

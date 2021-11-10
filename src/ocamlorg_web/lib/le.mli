(* Module to handle Let's Encrypt certificate generation and loading.

   The [load_certificates] function loads the certificates from the filesystem
   if they are found, otherwise, it will send a request to let's encrypt to
   generate a new certificate.

   To verify the identity of the certificate, let's encrypt will send a request
   to a specific endpoint ([/.well-known/acme-challenge/{token}]). The handler
   for this handpoint is the [handler function]. You can add the router [router]
   to your application to dispatch the let's encrypt request correctly. *)

val handler : Dream.handler

val router : Dream.middleware

val load_certificates
  :  certificate_file_path:string
  -> private_key_file_path:string
  -> hostname:string
  -> staging:bool
  -> ?email:string
  -> ?seed:string
  -> ?cert_seed:string
  -> unit
  -> (string * string) Lwt.t

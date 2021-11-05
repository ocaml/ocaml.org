val dispatch : Dream.request -> Dream.response Lwt.t

val provision_certificate
  :  ?email:string
  -> ?seed:string
  -> ?cert_seed:string
  -> ?hostname:string
  -> unit
  -> ( [> `Single of X509.Certificate.t list * X509.Private_key.t ]
     , [> `Msg of string ] )
     Lwt_result.t

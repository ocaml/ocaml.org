---
packages:
- name: "dream"
  tested_version: "1.0.0~alpha8"
  used_libraries:
  - dream
- name: "base64"
  tested_version: "3.5.1"
  used_libraries:
  - base64
discussion: |
  This example uses Dream, a simple and type-safe web framework for OCaml.
---

(* This OCaml program uses the `Dream` web framework to run a simple web server with Basic Authentication. It defines a list of mock users and checks incoming HTTP requests for a valid Authorization header. If the credentials (encoded in Base64) match a user in the list, access to the protected `/dashboard` route is granted. Otherwise, the server responds with a `401 Unauthorized` status and a `WWW-Authenticate` header to prompt the browser for login.*)

let mock_authorized_users = [
  ("admin", "password");
  ("joy", "secret123");
]

let check_credentials username password =
  List.exists (fun (u, p) -> u = username && p = password) mock_authorized_users

let basic_auth_middleware handler request =
  match Dream.header request "authorization" with
  | Some auth_header ->
      let prefix = "Basic " in
      if String.starts_with ~prefix auth_header then
        let encoded = String.sub auth_header (String.length prefix) (String.length auth_header - String.length prefix) in
        match Base64.decode encoded with
        | Ok credentials ->
            (match String.split_on_char ':' credentials with
            | [username; password] ->
                if check_credentials username password then
                  handler request
                else
                  Dream.respond ~status:`Unauthorized "Invalid username or password"
            | _ ->
                Dream.respond ~status:`Bad_Request "Bad credentials")
        | Error _ ->
            Dream.respond ~status:`Bad_Request "Could not decode credentials"
      else
        Dream.respond ~status:`Unauthorized "Wrong credentials"
  | None ->
      Dream.respond ~status:`Unauthorized
        ~headers:[("WWW-Authenticate", "Basic realm=\"Access Secret Dashboard\"")]
        "Authentication required"

let protected_route_handler _ =
  Dream.html "Welcome to the protected Dashboard"

let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router [
    Dream.get "/" (fun _ -> Dream.html "Welcome to the public Home Page");
    Dream.get "/dashboard" (basic_auth_middleware protected_route_handler);
  ]
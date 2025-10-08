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

(* 
   ⚠️  WARNING: DO NOT USE THIS IN PRODUCTION! ⚠️
   
   This is a DEMONSTRATION ONLY showing basic HTTP authentication concepts.
   
   This code has SERIOUS SECURITY FLAWS:
   - Passwords stored in plain text
   - No password hashing
   - Vulnerable to timing attacks
   - No rate limiting
   - No HTTPS enforcement
   - Improper credential validation
   
   For production use:
   - Consult OWASP Authentication Cheat Sheet
   - Use established authentication frameworks and schemes (e.g. passwordless, phishing-resistant passkey auth like [WebAuthn](https://ocaml.org/p/webauthn))
   - Implement proper password hashing (bcrypt, argon2)
   - Use HTTPS only
   - Consider OAuth 2.0, JWT, or session-based auth
   - Add rate limiting and account lockout
   
   Learn more: https://cheatsheetseries.owasp.org/
*)

(* Simple demo users - NEVER do this in real apps! *)
let users = [("admin", "password")]

(* Check if credentials match *)
let is_valid username password =
  List.exists (fun (u, p) -> u = username && p = password) users

(* Basic auth middleware *)
let auth_check handler request =
  match Dream.header request "authorization" with
  | Some auth ->
      if String.starts_with ~prefix:"Basic " auth then
        let encoded = String.sub auth 6 (String.length auth - 6) in
        (match Base64.decode encoded with
        | Ok creds ->
            (match String.split_on_char ':' creds with
            | [username; password] when is_valid username password ->
                handler request
            | _ ->
                Dream.respond ~status:`Unauthorized "Invalid credentials")
        | Error _ ->
            Dream.respond ~status:`Bad_Request "Bad encoding")
      else
        Dream.respond ~status:`Unauthorized "Invalid auth header"
  | None ->
      Dream.respond ~status:`Unauthorized
        ~headers:[("WWW-Authenticate", "Basic realm=\"Demo\"")]
        "Login required"

(* Routes *)
let () =
  Dream.run
  @@ Dream.router [
    Dream.get "/" (fun _ -> Dream.html "Public page");
    Dream.get "/secret" (auth_check (fun _ -> Dream.html "Secret page"));
  ]
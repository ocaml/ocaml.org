---
packages:
- name: "dream"
  tested_version: "1.0.0~alpha8"
  used_libraries:
  - dream
discussion: |
  This example uses Dream, a simple and type-safe web framework for OCaml.
---
(* The server:
  - Handles any incoming request on port 8080
  - Logs requests
  - Responds with a static `Hello world` message
  - Returns 404 error for other routes *)

let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router [
    Dream.get "/" (fun _ -> Dream.html "Hello World!");
    Dream.any "/" (fun _ -> Dream.empty `Not_Found);
  ]

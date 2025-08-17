---
packages:
- name: "dream"
  tested_version: "1.0.0~alpha8"
  used_libraries:
  - dream
discussion: |
  This example uses Dream, a simple and type-safe web framework for OCaml.
  To avoid errors, the file name should end with `.eml.ml`.
  Set the dune file following the guide here:
  [Dream Template](https://aantron.github.io/dream/#templates)
---

(* The server:
  - Handles any incoming request on port 8080
  - Logs requests
  - Responds with a static HTML template that displays "Hello World!"
  - Returns 404 error for other routes *)

let template =
  <!DOCTYPE html>
  <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Template Page</title>
    </head>
    <body>
      <h1>Hello World!</h1>
    </body>
  </html>

let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router [
    Dream.get "/" (fun _ -> Dream.html template);
    Dream.any "/" (fun _ -> Dream.empty `Not_Found);
  ]

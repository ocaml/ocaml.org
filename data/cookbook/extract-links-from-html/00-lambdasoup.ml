---
packages:
  - name: "lambdasoup"
    tested_version: "1.0.0"
    used_libraries:
      - lambdasoup
discussion: |
  - **Refernce:** The lambdasoup package provides a robust toolset for working with HTML. [github.com/lambdasoup](https://github.com/aantron/lambdasoup?tab=readme-ov-file)
---

(*

`find_links` accepts an argument `html_content` of type string that contains our HTML content and returns
the content of the `href` tags.

`parse` from the `Soup` library produces a document node representing the HTML string.

`$$` selects nodes in the document using the selector query.

*)
open Soup

let find_links html_content =
  let document_node = parse html_content in 
  document_node $$ "a[href]" |> iter (fun a -> print_endline (R.attribute "href" a))


(* Example usage *)
let html_content = "
<!DOCTYPE html>
<html lang=\"en\">
<head>
    <meta charset=\"UTF-8\">
    <title>Sample HTML Page</title>
</head>
<body>
    <header>
        <h1>My Cool Learning Links</h1>
    </header>
    <main>
        <section>
            <H2>Click a link to get started!</H2>
            <ul>
                <li><a href=\"https://ocaml.org/docs\">The Ocaml.org Learning Page</a></li>
                <li><a href=\"https://pola.rs/\">Pola.rs: Modern Python Dataframes</a></li>
                <li><a href=\"https://www.nonexistentwebsite.com\">It used to work.com</a></li>
            </ul>
        </section>
    </main>
</body>
</html>"  
  
(*Expected output:
https://ocaml.org/docs
https://pola.rs/
https://www.nonexistentwebsite.com
*)
let () = find_links html_content


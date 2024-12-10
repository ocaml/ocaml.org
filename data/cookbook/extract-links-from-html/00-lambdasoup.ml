---
packages:
  - name: "lambdasoup"
    tested_version: "1.1.1"
    used_libraries:
      - lambdasoup
---

(*
The `find_links` function:
- Takes an HTML string as input
- Parses it into a document structure
- Extracts and returns all href attributes from anchor tags

Key components:
1. `Soup.parse` - Converts HTML string into a traversable document structure
2. `$$` operator - Performs CSS-style selector queries on the document
3. `"a[href]"` - Selects all `<a>` tags that have an href attribute
4. `Soup.R.attribute` - Extracts the value of a specified attribute from an element
*)
let find_links html_content =
  let document_node = Soup.parse html_content in
  Soup.(document_node $$ "a[href]")
  |> Soup.to_list
  |> List.map (Soup.R.attribute "href")

(* Sample HTML document containing some hyperlinks. *)
let html_content = {|
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
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
                <li><a href="https://ocaml.org/docs">The Ocaml.org Learning Page</a></li>
                <li><a href="https://pola.rs/">Pola.rs: Modern Python Dataframes</a></li>
                <li><a href="https://www.nonexistentwebsite.com">It used to work.com</a></li>
            </ul>
        </section>
    </main>
</body>
</html>|}

(*
Expected output shows one URL per line:
* https://ocaml.org/docs
* https://pola.rs/
* https://www.nonexistentwebsite.com
*)
let () =
  find_links html_content
  |> List.iter (fun a -> print_endline a)

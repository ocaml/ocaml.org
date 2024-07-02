---
packages:
  - name: "re"
    tested_version: "1.11.0"
    used_libraries:
      - re
---

(*

`find_links` accepts an argument `html_content` of type string that contains our HTML content and returns
the content of the `href` tags.

You can view the pattern using [Regex101](https://regex101.com/r/2Bs442/1)
to understand more about what is going on. 

`Re.all` searches the entire `html_content` string for the `pattern`. Passing `1` to `Re.Group.get` returns the 
substring versus the entire matching group.

*)
let find_links html_content = 
  let pattern = Re.compile (Re.Perl.re "<a[^>]* href=\"([^\"]*)") in
  let links = Re.all pattern html_content 
  |> List.map (fun group -> Re.Group.get group 1) in
  List.iter print_endline links


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


let create_entries ~create_entry = List.map create_entry

let entries_to_feed ~id ~title (entries : Syndic.Atom.entry list) =
  let id = Uri.of_string ("https://ocaml.org/" ^ id) in
  let title : Syndic.Atom.title = Text title in
  let entries = List.sort Syndic.Atom.descending entries in
  let updated = (List.hd entries).updated in
  Syndic.Atom.feed ~id ~title ~updated entries

let feed_to_string feed =
  feed |> Syndic.Atom.to_xml
  |> Syndic.XML.to_string ~ns_prefix:(fun s ->
         match s with "http://www.w3.org/2005/Atom" -> Some "" | _ -> None)

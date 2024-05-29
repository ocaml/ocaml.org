let create_feed ~id ~title ~create_entry ?span u =
  let id = Uri.of_string ("https://ocaml.org/" ^ id) in
  let title : Syndic.Atom.title = Text title in
  let is_fresh =
    let some span (entry : Syndic.Atom.entry) =
      let now = Ptime.of_float_s (Unix.gettimeofday ()) |> Option.get in
      let than = Ptime.sub_span now (Ptime.Span.v (span, 0L)) |> Option.get in
      if Ptime.is_later entry.updated ~than then Some entry else None
    in
    Option.fold ~none:Option.some ~some span
  in
  let entries = u |> List.filter_map (fun x -> x |> create_entry |> is_fresh) in
  let updated = (List.hd entries).updated in
  Syndic.Atom.feed ~id ~title ~updated entries

let feed_to_string feed =
  feed |> Syndic.Atom.to_xml
  |> Syndic.XML.to_string ~ns_prefix:(fun s ->
         match s with "http://www.w3.org/2005/Atom" -> Some "" | _ -> None)

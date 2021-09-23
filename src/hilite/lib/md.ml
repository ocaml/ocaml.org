let langs = [ "ocaml"; "dune"; "opam" ]

let transform blocks =
  let f (b : 'a Omd.block) =
    match b with
    | Omd.Code_block (attr, lang, src) ->
      if not (List.mem lang langs) then
        b
      else (
        match Syntax.src_code_to_html ~lang ~src with
        | Ok html ->
          Omd.Html_block (attr, html)
        | Error (`Msg s) ->
          failwith s)
    | _ ->
      b
  in
  List.map f blocks

open Brr

let () =
  let button =
    Document.find_el_by_id G.document (Jstr.v "toplevel-load") |> Option.get
  in
  let input = 
    Document.find_el_by_id G.document (Jstr.v "userinput") |> Option.get
  in
  let output = 
    Document.find_el_by_id G.document (Jstr.v "output") |> Option.get
  in
  Ev.listen
    Ev.click
    (fun _ -> 
      El.set_class (Jstr.v "hidden") false input;
      El.set_has_focus true input;
      El.set_children output [];
      Ocamlorg_toplevel.Toplevel.run "/toplevels/worker.js")
    (El.as_target button)

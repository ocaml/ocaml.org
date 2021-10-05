open Brr

let () =
  let button =
    Document.find_el_by_id G.document (Jstr.v "toplevel-load") |> Option.get
  in
  Ev.listen
    Ev.click
    (fun _ -> Ocamlorg_toplevel.Toplevel.run "/toplevels/worker.js")
    (El.as_target button)

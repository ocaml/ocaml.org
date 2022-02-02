open Code_mirror
open Brr

let basic_setup = Jv.get Jv.global "__CM__basic_setup" |> Extension.of_jv

let get_el_by_id i =
  Brr.Document.find_el_by_id G.document (Jstr.of_string i) |> Option.get

let init ?doc ?(exts = [||]) () =
  let open Editor in
  let config =
    State.Config.create ?doc
      ~extensions:(Array.concat [ [| basic_setup |]; exts ])
      ()
  in
  let state = State.create ~config () in
  let opts = View.opts ~state ~parent:(get_el_by_id "editor1") () in
  let view : View.t = View.create ~opts () in
  (state, view)

let set view ~doc ~exts =
  let open Editor in
  let config =
    State.Config.create ~doc
      ~extensions:(Array.concat [ [| basic_setup |]; exts ])
      ()
  in
  let state = State.create ~config () in
  View.set_state view state

let get_doc view =
  let text = Editor.State.doc @@ Editor.View.state view in
  Text.to_jstr_array text |> Array.map Jstr.to_string |> Array.to_list
  |> String.concat "\n"

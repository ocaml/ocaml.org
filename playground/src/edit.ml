open Code_mirror
open Brr

let basic_setup = Jv.get Jv.global "__CM__basic_setup" |> Extension.of_jv

let get_el_by_id i =
  Brr.Document.find_el_by_id G.document (Jstr.of_string i) |> Option.get

let init ?doc ?(exts = []) () =
  let open State in
  let config =
    EditorStateConfig.create ?doc ~extensions:(basic_setup :: exts) ()
  in
  let state = EditorState.create ~config () in
  let config =
    View.EditorViewConfig.create ~state ~parent:(get_el_by_id "editor1") ()
  in
  let view = View.EditorView.create ~config () in
  (state, view)

let get_doc view =
  View.EditorView.state view |> State.EditorState.doc |> State.Text.to_string

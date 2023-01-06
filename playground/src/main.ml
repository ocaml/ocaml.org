open Brr
open Code_mirror
open Lwt.Syntax
module Worker = Brr_webworkers.Worker

(* ~~~ RPC ~~~ *)

module Toplevel_api = Js_top_worker_rpc.Toplevel_api_gen
module Toprpc = Js_top_worker_client.W

let timeout_container () =
  let open Brr in
  match Document.find_el_by_id G.document @@ Jstr.v "toplevel-container" with
  | Some el ->
      El.(
        set_children el
          [
            El.p
              [
                El.txt'
                  "Toplevel terminated after timeout on previous execution";
              ];
          ])
  | None -> ()

let initialise s callback =
  let rpc = Js_top_worker_client.start s 100000 callback in
  let* _ = Toprpc.init rpc Toplevel_api.{ cmas = []; cmi_urls = [] } in
  Lwt.return rpc

let or_raise = function
  | Ok v -> v
  | Error (Toplevel_api.InternalError e) -> failwith e

let with_rpc rpc f v = Lwt.bind rpc (fun r -> Lwt.map or_raise @@ f r v)
let async_raise f = Lwt.async (fun () -> Lwt.map or_raise @@ f ())

module Merlin = Merlin_codemirror.Make (struct
  let worker_url = "/play/merlin-v1.js"
end)

(* Need to port lesser-dark and custom theme to CM6, until then just using the
   one dark theme. *)
let dark_theme_ext =
  let dark = Jv.get Jv.global "__CM__dark" in
  Extension.of_jv @@ Jv.get dark "oneDark"

let get_el_by_id s =
  match Document.find_el_by_id G.document (Jstr.v s) with
  | Some v -> v
  | None ->
      Console.warn [ Jstr.v "Failed to get elemented by id" ];
      invalid_arg s

let cyan = "cyan"
let red = "red"

let render_output color = function
  | None -> None
  | Some output ->
      let el =
        El.p
          ~at:[ At.v (Jstr.v "style") (Jstr.v "white-space: pre-wrap;") ]
          [ El.txt' output ]
      in
      El.set_inline_style (Jstr.v "color") (Jstr.v color) el;
      Some el

let handle_output (o : Toplevel_api.exec_result) =
  let output = get_el_by_id "output" in
  let output_elements =
    List.filter_map
      (fun (c, o) -> render_output c o)
      [ (cyan, o.stdout); (red, o.stderr); (red, o.caml_ppf) ]
  in
  let out = El.div output_elements in
  El.append_children output [ out ]

module Codec = struct
  let ( let+ ) = Result.bind

  let from_window () =
    let uri = Window.location G.window |> Uri.fragment in
    match Uri.Params.find (Jstr.v "code") (Uri.Params.of_jstr uri) with
    | Some jstr ->
        let+ dec = Base64.decode jstr in
        let+ code = Base64.data_utf_8_to_jstr dec in
        Ok (Jstr.to_string code)
    | _ -> Ok Example.adts

  let to_window s =
    let data = Base64.data_utf_8_of_jstr s in
    let+ bin = Base64.encode data in
    let uri = Window.location G.window in
    let+ s = Uri.with_uri ~fragment:(Jstr.concat [ Jstr.v "code="; bin ]) uri in
    Ok (Window.set_location G.window s)
end

let setup () =
  let initial_code =
    Result.value ~default:Example.adts (Codec.from_window ())
  in
  let _state, view =
    Edit.init ~doc:(Jstr.v initial_code)
      ~exts:
        (Array.concat
           [
             [|
               dark_theme_ext;
               Editor.View.line_wrapping ();
               Merlin_codemirror.ocaml;
             |];
             Merlin.all_extensions;
           ])
      ()
  in
  let rpc = initialise "/play/worker-v1.js" timeout_container in
  let setup () =
    let* o = with_rpc rpc Toprpc.setup () in
    handle_output o;
    Lwt.return (Ok ())
  in
  let* _ = setup () in
  let share = get_el_by_id "share" in
  let _listener =
    Ev.(
      listen click
        (fun _ ->
          Console.log_if_error ~use:()
            (Codec.to_window @@ Jstr.v (Edit.get_doc view)))
        (El.as_target share))
  in
  let button = get_el_by_id "run" in
  let on_click _ =
    let run () =
      El.set_class (Jstr.v "loader") true button;
      let* o = with_rpc rpc Toprpc.exec (Edit.get_doc view ^ ";;") in
      El.set_class (Jstr.v "loader") false button;
      handle_output o;
      Lwt.return (Ok ())
    in
    async_raise run
  in
  let _listener = Ev.(listen click on_click (El.as_target button)) in
  Lwt_result.return ()

let () = async_raise setup

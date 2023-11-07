open Brr
open Code_mirror
open Lwt.Syntax
module Worker = Brr_webworkers.Worker

(* ~~~ RPC ~~~ *)

module Toplevel_api = Js_top_worker_rpc.Toplevel_api_gen
module Toprpc = Js_top_worker_client.W

let timeout_container () =
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

let cmi_urls () = List.map (fun cmi -> Printf.sprintf "stdlib/%s" cmi) Cmis.cmis

let initialise s callback =
  let rpc = Js_top_worker_client.start s 100000 callback in
  let* _ = Toprpc.init rpc Toplevel_api.{ cmas = []; cmi_urls = cmi_urls () } in
  Lwt.return rpc

let or_raise = function
  | Ok v -> v
  | Error (Toplevel_api.InternalError e) -> failwith e

let with_rpc rpc f v = Lwt.bind rpc (fun r -> Lwt.map or_raise @@ f r v)
let async_raise f = Lwt.async (fun () -> Lwt.map or_raise @@ f ())

let get_el_by_id s =
  match Document.find_el_by_id G.document (Jstr.v s) with
  | Some v -> v
  | None ->
      Console.warn [ Jstr.v "Failed to get elemented by id" ];
      invalid_arg s

let get_script_data s =
  let script = get_el_by_id "playground-script" in
  Option.value ~default:"" (Option.map Jstr.to_string (El.at (Jstr.v s) script))

let merlin_url = get_script_data "data-merlin-url"
let worker_url = get_script_data "data-worker-url"
let default_code = get_script_data "data-default-code"

module Merlin = Merlin_codemirror.Make (struct
  let worker_url = merlin_url

  let cmis =
    let dcs_toplevel_modules =
      [
        "CamlinternalFormat";
        "CamlinternalFormatBasics";
        "CamlinternalLazy";
        "CamlinternalMod";
        "CamlinternalOO";
        "Std_exit";
        "Stdlib";
        "Unix";
        "UnixLabels";
      ]
    in
    let dcs_url = "stdlib/" in
    let dcs_file_prefixes = [ "stdlib__" ] in
    {
      Protocol.static_cmis = [];
      dynamic_cmis = Some { dcs_url; dcs_toplevel_modules; dcs_file_prefixes };
    }
end)

(* Need to port lesser-dark and custom theme to CM6, until then just using the
   one dark theme. *)
let dark_theme_ext =
  let dark = Jv.get Jv.global "__CM__dark" in
  Extension.of_jv @@ Jv.get dark "oneDark"

let cyan = "cyan"
let red = "red"
let white = "white"

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
      [ (cyan, o.stdout); (red, o.stderr); (white, o.caml_ppf) ]
  in
  let out = El.div output_elements in
  El.append_children output [ out ]

module Codec = struct
  let ( let+ ) = Result.bind

  let replace ~find ~replace s =
    Jstr.cuts ~sep:find s |> Jstr.concat ~sep:replace

  let from_window () =
    let uri = Window.location G.window in
    let params = Uri.fragment_params uri in
    let from_code jstr =
      (* previously, '+' was not URL-encoded and thus became ' ' *)
      let unspace = replace ~find:(Jstr.v " ") ~replace:(Jstr.v "+") jstr in
      Result.to_option
      @@ let+ dec = Base64.decode unspace in
         let+ code = Base64.data_utf_8_to_jstr dec in
         Ok (Jstr.to_string code)
    in
    let from_rawcode jstr = Some (Jstr.to_string jstr) in
    List.find_map
      (fun (k, f) -> Option.bind (Uri.Params.find (Jstr.v k) params) f)
      [ ("code", from_code); ("rawcode", from_rawcode) ]

  let to_window s =
    let data = Base64.data_utf_8_of_jstr s in
    let+ bin = Base64.encode data in
    let query = Uri.Params.of_assoc [ (Jstr.v "code", bin) ] in
    let uri = Uri.with_fragment_params (Window.location G.window) query in
    Window.set_location G.window uri;
    Ok ()
end

let setup () =
  let initial_code =
    Option.value ~default:default_code (Codec.from_window ())
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
  let rpc = initialise worker_url timeout_container in
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

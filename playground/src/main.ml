open Brr
open Code_mirror
open Lwt.Syntax
module Toplevel = Js_of_ocaml_toplevel_worker_lwt_client
module Wrapped = Js_of_ocaml_toplevel_protocol.Wrapped_intf

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
let cmis_url = get_script_data "data-cmis-url"
let default_code = get_script_data "data-default-code"

(* The toplevel worker fetches [<cmis_base_url>stdlib.cmis.js]. Its URL carries
   a digest in a directory component, so pass that directory. *)
let cmis_base_url =
  match String.rindex_opt cmis_url '/' with
  | Some i -> String.sub cmis_url 0 (i + 1)
  | None -> ""

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

(* ~~~ Output ~~~ *)

let cyan = "cyan"
let red = "red"
let yellow = "yellow"
let white = "white"

(* Each run appends a block to the output pane. Output arrives in chunks (stdout
   and stderr are streamed while the code runs), so chunks are inline spans in a
   block that preserves whitespace. *)
let new_block () =
  let block =
    El.div ~at:[ At.v (Jstr.v "style") (Jstr.v "white-space: pre-wrap;") ] []
  in
  El.append_children (get_el_by_id "output") [ block ];
  block

let current_block = ref None

let block () =
  match !current_block with
  | Some b -> b
  | None ->
      let b = new_block () in
      current_block := Some b;
      b

let append color text =
  if text <> "" then (
    let span = El.span [ El.txt' text ] in
    El.set_inline_style (Jstr.v "color") (Jstr.v color) span;
    El.append_children (block ()) [ span ])

let append_line color text =
  append color
    (if String.ends_with ~suffix:"\n" text then text else text ^ "\n")

let banner () = append_line white ("OCaml version " ^ Sys.ocaml_version)

let report_warnings =
  List.iter (fun (w : Wrapped.warning) -> append_line yellow w.msg)

(* ~~~ Toplevel ~~~ *)

let toplevel =
  Toplevel.create ~cmis_base_url ~pp_stdout:(append cyan)
    ~pp_stderr:(append red) ~js_file:worker_url ()

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

(* ~~~ Run / Stop ~~~ *)

let running = ref false

let set_running b =
  running := b;
  let button = get_el_by_id "run" in
  El.set_class (Jstr.v "loader") b button;
  El.set_children (get_el_by_id "run-label")
    [ El.txt' (if b then "STOP" else "RUN") ];
  El.set_class (Jstr.v "hidden") b (get_el_by_id "run-icon");
  El.set_class (Jstr.v "hidden") (not b) (get_el_by_id "stop-icon")

let run code =
  set_running true;
  current_block := Some (new_block ());
  let* outcome =
    Lwt.catch
      (fun () ->
        let* top = toplevel in
        let+ r =
          Toplevel.execute top ~print_outcome:true ~ppf_answer:(append white)
            code
        in
        `Done r)
      (function
        | Lwt.Canceled -> Lwt.return `Interrupted
        | Toplevel.Init_failed e -> Lwt.return (`Init_failed e)
        | e -> Lwt.reraise e)
  in
  (match outcome with
  | `Done (Wrapped.Success (_, warnings)) -> report_warnings warnings
  | `Done (Wrapped.Error (e, warnings)) ->
      report_warnings warnings;
      append_line red e.msg
  | `Interrupted ->
      append_line red
        "Interrupted. The toplevel was restarted: previous definitions are \
         lost.";
      banner ()
  | `Init_failed e -> append_line red ("The toplevel failed to start: " ^ e.msg));
  current_block := None;
  set_running false;
  Lwt.return_unit

let stop () =
  let* top = toplevel in
  Toplevel.interrupt top

let setup () =
  let initial_code =
    Option.value ~default:default_code (Codec.from_window ())
  in
  let _state, view =
    Edit.init ~doc:initial_code
      ~exts:
        (dark_theme_ext
        :: View.EditorView.line_wrapping ()
        :: Merlin_codemirror.ocaml :: Merlin.all_extensions)
      ()
  in
  banner ();
  current_block := None;
  Lwt.async (fun () ->
      Lwt.catch
        (fun () ->
          let+ _ = toplevel in
          ())
        (fun e ->
          let msg =
            match e with
            | Toplevel.Init_failed e -> e.msg
            | e -> Printexc.to_string e
          in
          append_line red ("The toplevel failed to start: " ^ msg);
          current_block := None;
          Lwt.return_unit));
  let share = get_el_by_id "share" in
  let _listener =
    Ev.(
      listen click
        (fun _ ->
          Console.log_if_error ~use:()
            (Codec.to_window @@ Jstr.v (Edit.get_doc view)))
        (El.as_target share))
  in
  let on_click _ =
    Lwt.async (fun () ->
        if !running then stop () else run (Edit.get_doc view ^ ";;"))
  in
  let _listener =
    Ev.(listen click on_click (El.as_target (get_el_by_id "run")))
  in
  ()

let () = setup ()

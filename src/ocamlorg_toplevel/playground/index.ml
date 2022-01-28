open Brr
open Code_mirror
open Lwt.Syntax
module Worker = Brr_webworkers.Worker

(* ~~~ RPC ~~~ *)

module Toplevel_api = Js_top_worker_rpc.Toplevel_api_gen
module Toprpc = Js_top_worker_client.W

let line_to_positions doc n =
  let line = Text.line n doc in
  Text.Line.from line, Text.Line.to_ line

let storage_id = Jstr.v "ocaml-org-playground-v0"

let timeout_container () =
  let open Brr in
  match Document.find_el_by_id G.document @@ Jstr.v "toplevel-container" with
  | Some el ->
    El.(
      set_children
        el
        [ El.p
            [ El.txt' "Toplevel terminated after timeout on previous execution"
            ]
        ])
  | None ->
    ()

let initialise s callback =
  let rpc = Js_top_worker_client.start s 100000 callback in
  let* _ = Toprpc.init rpc Toplevel_api.{ cmas = []; cmi_urls = [] } in
  Lwt.return rpc

let rpc = initialise "/toplevels/worker.js" timeout_container

let or_raise = function
  | Ok v ->
    v
  | Error (Toplevel_api.InternalError e) ->
    failwith e

let with_rpc f v = Lwt.bind rpc (fun r -> Lwt.map or_raise @@ f r v)

let async_raise f = Lwt.async (fun () -> Lwt.map or_raise @@ f ())

(* ~~~ Linting ~~~ *)
let linter =
  let f view =
    let doc = Editor.View.state view |> Editor.State.doc in
    let lines =
      Text.to_jstr_array doc |> Array.to_list |> List.map Jstr.to_string
    in
    let max_length, cumulative =
      List.fold_left_map
        (fun acc a ->
          let i = acc + String.length a in
          i + 1, i + 1) (* Plus one for the newlines *)
        0
        lines
    in
    let result, set_result = Fut.create () in
    let get_line idx i =
      let line = idx - i in
      if line <= 0 then 0 else List.nth cumulative line
    in
    let run () =
      let s = String.concat "\n" lines ^ ";;" in
      let* o = with_rpc Toprpc.typecheck s in
      let errs =
        match o.stderr, o.highlight with
        | Some msg, Some { line1; line2; col1; col2 } ->
          let from = get_line line1 2 + col1 in
          let to_ = get_line line2 2 + col2 in
          let to_ = if to_ >= max_length then from else to_ in
          [ (from, to_), msg ]
        | _ ->
          []
      in
      let diagnostic ~from ~to_ message =
        Lint.Diagnostic.create
          ~source:"toplevel"
          ~from
          ~to_
          ~severity:Error
          ~message
          ()
      in
      let results =
        List.map (fun ((from, to_), msg) -> diagnostic ~from ~to_ msg) errs
        |> Array.of_list
      in
      Lwt_result.return @@ set_result results
    in
    async_raise run;
    result
  in
  Lint.create f

(* ~~~ Autocompletion ~~~ *)
let complete : Autocomplete.source =
 fun (ctx : Autocomplete.Context.t) ->
  let open Autocomplete in
  let result, set_result = Fut.create () in
  let rword = RegExp.create ".*" in
  match Autocomplete.Context.match_before ctx rword with
  | Some jv ->
    let run () =
      let from = Jv.Int.get jv "from" in
      let text = Jv.Jstr.get jv "text" |> Jstr.to_string in
      let* c = with_rpc Toprpc.complete text in
      let options =
        List.map (fun label -> Completion.create ~label ()) c.completions
      in
      let r = Result.create ~from:(from + c.n) ~options () in
      Lwt.return (Ok (set_result (Some r)))
    in
    async_raise run;
    result
  | _ ->
    result

let autocomplete =
  let config = Autocomplete.config ~override:[ complete ] () in
  Autocomplete.create ~config ()

(* Need to port lesser-dark and custom theme to CM6, until then just using the
   one dark theme. *)
let dark_theme_ext =
  let dark = Jv.get Jv.global "__CM__dark" in
  Extension.of_jv @@ Jv.get dark "oneDark"

let ml_like = Jv.get Jv.global "__CM__mllike" |> Stream.Language.of_jv

let set_classes el cl =
  List.iter (fun v -> El.set_class v true el) (List.map Jstr.v cl)

let set_inner_html el html =
  let jv = El.to_jv el in
  Jv.set jv "innerHTML" (Jv.of_string html)

let get_el_by_id s =
  match Document.find_el_by_id G.document (Jstr.v s) with
  | Some v ->
    v
  | None ->
    Console.warn [ Jstr.v "Failed to get elemented by id" ];
    invalid_arg s

let red el = El.set_inline_style (Jstr.v "color") (Jstr.v "red") el

let cyan el = El.set_inline_style (Jstr.v "color") (Jstr.v "cyan") el

let handle_output (o : Toplevel_api.exec_result) =
  let output = get_el_by_id "output" in
  let out = El.(p [ txt' (Option.value ~default:"" o.stdout) ]) in
  cyan out;
  El.append_children output [ out ]

module Codec = struct
  let ( let+ ) = Result.bind

  let from_window () =
    try
      let uri = Window.location G.window |> Uri.fragment in
      match Uri.Params.find (Jstr.v "code") (Uri.Params.of_jstr uri) with
      | Some jstr ->
        let+ dec = Base64.decode jstr in
        let+ code = Base64.data_utf_8_to_jstr dec in
        Ok (Jstr.to_string code)
      | _ ->
        Ok Example.adts
    with
    | _ ->
      Ok Example.adts

  let to_window s =
    let data = Base64.data_utf_8_of_jstr s in
    let+ bin = Base64.encode data in
    let uri = Window.location G.window in
    let+ s = Uri.with_uri ~fragment:(Jstr.concat [ Jstr.v "code="; bin ]) uri in
    Ok (Window.set_location G.window s)
end

let setup () =
  let setup () =
    let* o = with_rpc Toprpc.setup () in
    handle_output o;
    Lwt.return (Ok ())
  in
  let* _ = setup () in
  let initial_code =
    Result.value ~default:Example.adts (Codec.from_window ())
  in
  let _state, view =
    let ml = Stream.Language.define ml_like in
    Edit.init
      ~doc:(Jstr.v initial_code)
      ~exts:
        [| dark_theme_ext
         ; ml
         ; autocomplete
         ; linter
         ; Editor.View.line_wrapping ()
        |]
      ()
  in
  let share = get_el_by_id "share" in
  Ev.(
    listen
      click
      (fun _ ->
        Console.log_if_error
          ~use:()
          (Codec.to_window @@ Jstr.v (Edit.get_doc view)))
      (El.as_target share));
  let button = get_el_by_id "run" in
  let on_click _ =
    let run () =
      El.set_class (Jstr.v "loader") true button;
      let* o = with_rpc Toprpc.exec (Edit.get_doc view ^ ";;") in
      El.set_class (Jstr.v "loader") false button;
      handle_output o;
      Lwt.return (Ok ())
    in
    async_raise run
  in
  Lwt_result.return @@ Ev.(listen click on_click (El.as_target button))

let () = async_raise setup

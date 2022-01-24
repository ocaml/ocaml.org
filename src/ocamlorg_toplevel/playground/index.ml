open Brr
open Code_mirror
open Ocamlorg_toplevel
module Worker = Brr_webworkers.Worker

(* ~~~ RPC ~~~ *)

module Toprpc = Toplevel_api.Make (Rpc_lwt.GenClient ())

let line_to_positions doc n =
  let line = Text.line n doc in
  Text.Line.from line, Text.Line.to_ line

let storage_id = Jstr.v "ocaml-org-playground-v0"

let timeout_container worker () =
  let open Brr in
  Worker.terminate worker;
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

let rpc =
  let worker =
    try Worker.create (Jstr.v "/toplevels/worker.js") with
    | Jv.Error _ ->
      failwith "Failed to created worker"
  in
  let context = Rpc_brr.Worker_rpc.start worker 20 (timeout_container worker) in
  Rpc_brr.Worker_rpc.rpc context

open Lwt.Infix

let rpc_bind x f =
  x |> Rpc_lwt.T.get >>= function
  | Ok x ->
    f x
  | Error (Toplevel_api.InternalError s) ->
    Lwt.fail (Failure (Printf.sprintf "Rpc failure: %s" s))

let ( let* ) = rpc_bind

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
      let* o = Toprpc.typecheck rpc s in
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
      Lwt.return @@ set_result results
    in
    Lwt.async run;
    result
  in
  Lint.create f

(* ~~~ Autocompletion ~~~ *)
let complete : Autocomplete.source = fun (ctx : Autocomplete.Context.t) ->
  let open Autocomplete in
  let result, set_result = Fut.create () in
  let rword = RegExp.create ".*" in
  match Autocomplete.Context.match_before ctx rword with
    | Some jv ->
      let run () =
        let from = Jv.Int.get jv "from" in
        let text = Jv.Jstr.get jv "text" |> Jstr.to_string in
        let* c = Toprpc.complete rpc text in
        let options =
          List.map (fun label -> Completion.create ~label ()) c.completions
        in
        let r = Result.create ~from:(from + c.n) ~options () in
        Lwt.return (set_result (Some r))
      in
      Lwt.async run;
      result
    | _ -> result

let autocomplete = 
  let config = 
    Autocomplete.config ~override:[ complete ] ()
  in
  Autocomplete.create ~config ()

(* Need to port lesser-dark and custom theme to CM6, until then just using the
   one dark theme. *)
let dark_theme_ext =
  let dark = Jv.get Jv.global "__CM__dark" in
  Extension.of_jv @@ Jv.get dark "oneDark"

let ml_like = Jv.get Jv.global "__CM__mllike" |> Language.of_jv

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

let setup () =
  let setup () =
    let* o = Toprpc.setup rpc () in
    handle_output o;
    Lwt.return ()
  in
  setup () >>= fun _ ->
  let _state, view =
    let ml = Stream.Language.define ml_like in
    Edit.init
      ~doc:(Jstr.v Example.adts)
      ~exts:[| dark_theme_ext; ml; autocomplete; linter; Editor.View.line_wrapping () |]
      ()
  in
  let button = get_el_by_id "run" in
  let on_click _ =
    let run () =
      El.set_class (Jstr.v "loader") true button;
      let* o = Toprpc.exec rpc (Edit.get_doc view ^ ";;") in
      El.set_class (Jstr.v "loader") false button;
      handle_output o;
      Lwt.return ()
    in
    Lwt.async run
  in
  Lwt.return @@ Ev.(listen click on_click (El.as_target button))

let () = Lwt.async setup

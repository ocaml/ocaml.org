(* Js_of_ocaml toplevel
 * http://www.ocsigen.org/js_of_ocaml/
 * Copyright (C) 2011 Jérôme Vouillon
 * Laboratoire PPS - CNRS Université Paris Diderot
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, with linking exception;
 * either version 2.1 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *)

open Js_of_ocaml
open Js_of_ocaml_tyxml
open Lwt.Syntax
module Worker = Brr_webworkers.Worker
module Toplevel_api = Js_top_worker_rpc.Toplevel_api_gen
module Toprpc = Js_top_worker_client.W

(* Handy infix bind-style operator for the RPCs *)
let rpc_bind x f =
  x |> Rpc_lwt.T.get >>= function
  | Ok x -> f x
  | Error (Toplevel_api.InternalError s) ->
      Lwt.fail (Failure (Printf.sprintf "Rpc failure: %s" s))

let by_id s = Dom_html.getElementById s

let by_id_coerce s f =
  Js.Opt.get (f (Dom_html.getElementById s)) (fun () -> raise Not_found)

let do_by_id s f = try f (Dom_html.getElementById s) with Not_found -> ()

let resize ~container ~textbox () =
  let* () = Lwt.pause () in
  textbox##.style##.height := Js.string "auto";
  textbox##.style##.height
  := Js.string (Printf.sprintf "%dpx" (max 18 textbox##.scrollHeight));
  container##.scrollTop := container##.scrollHeight;
  Lwt.return ()

(* we need to compute the hash form href to avoid different encoding behavior
   across browser. see Url.get_fragment *)
let parse_hash () =
  let frag = Url.Current.get_fragment () in
  Url.decode_arguments frag

let rec iter_on_sharp ~f x =
  Js.Opt.iter (Dom_html.CoerceTo.element x) (fun e ->
      if Js.to_bool (e##.classList##contains (Js.string "sharp")) then f e);
  match Js.Opt.to_option x##.nextSibling with
  | None -> ()
  | Some n -> iter_on_sharp ~f n

let current_position = ref 0

let highlight_location (h : Toplevel_api.highlight) =
  let x = ref 0 in
  let output = by_id "output" in
  let first =
    Js.Opt.get
      (output##.childNodes##item !current_position)
      (fun _ -> assert false)
  in
  iter_on_sharp first ~f:(fun e ->
      incr x;
      if !x >= h.line1 && !x <= h.line2 then
        let from_ = if !x = h.line1 then `Pos h.col1 else `Pos 0 in
        let to_ = if !x = h.line2 then `Pos h.col2 else `Last in
        Colorize.highlight from_ to_ e)

let append colorize output cl s =
  Dom.appendChild output (Tyxml_js.To_dom.of_element (colorize ~a_class:cl s))

module History = struct
  let data = ref [| "" |]
  let idx = ref 0

  let get_storage () =
    match Js.Optdef.to_option Dom_html.window##.localStorage with
    | exception _ -> raise Not_found
    | None -> raise Not_found
    | Some t -> t

  let setup () =
    try
      let s = get_storage () in
      match Js.Opt.to_option (s##getItem (Js.string "history")) with
      | None -> raise Not_found
      | Some s ->
          let a = Json.unsafe_input s in
          data := a;
          idx := Array.length a - 1
    with _ -> ()

  let push text =
    let l = Array.length !data in
    let n = Array.make (l + 1) "" in
    !data.(l - 1) <- text;
    Array.blit !data 0 n 0 l;
    data := n;
    idx := l;
    try
      let s = get_storage () in
      let str = Json.output !data in
      s##setItem (Js.string "history") str
    with Not_found -> ()

  let current text = !data.(!idx) <- text

  let previous textbox =
    if !idx > 0 then (
      decr idx;
      textbox##.value := Js.string !data.(!idx))

  let next textbox =
    if !idx < Array.length !data - 1 then (
      incr idx;
      textbox##.value := Js.string !data.(!idx))
end

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

let or_raise = function
  | Ok v ->
    v
  | Error (Toplevel_api.InternalError e) ->
    failwith e

let initialise s callback =
  let rpc = Js_top_worker_client.start s 100000 callback in
  let* v = Toprpc.init rpc Toplevel_api.{ cmas = []; cmi_urls = [] } in
  or_raise v;
  Lwt.return rpc

let rpc, set_rpc = Lwt.wait ()

let with_rpc f v = Lwt.bind rpc (fun r -> Lwt.map or_raise @@ f r v)

let async_raise f = Lwt.async (fun () -> Lwt.map or_raise @@ f ())

let run' s =
  let+ v = initialise s timeout_container in
  Lwt.wakeup set_rpc v;
  let container = by_id "toplevel-container" in
  let output = by_id "output" in
  let textbox : 'a Js.t = by_id_coerce "userinput" Dom_html.CoerceTo.textarea in
  textbox##.disabled := Js._false;
  let handle_output (o : Toplevel_api.exec_result) =
    Option.iter (append Colorize.sharp output "sharp") o.sharp_ppf;
    Option.iter (append Colorize.text output "stdout") o.stdout;
    Option.iter (append Colorize.text output "stderr") o.stderr;
    Option.iter (append Colorize.ocaml output "text-gray-400") o.caml_ppf;
    Option.iter highlight_location o.highlight;
    Lwt.async @@ resize ~container ~textbox;
    container##.scrollTop := container##.scrollHeight;
    ignore textbox##focus;
    ()
  in
  let handle_completion (c : Toplevel_api.completion_result) =
    if List.length c.completions = 1 then
      let txt = String.sub (Js.to_string textbox##.value) 0 c.n in
      let txt = txt ^ List.hd c.completions in
      textbox##.value := Js.string txt
    else (
      List.iter
        (fun l -> append Colorize.text output "stdout" (l ^ " "))
        c.completions;
      append Colorize.text output "stdout" "\n");
    Lwt.async @@ resize ~container ~textbox;
    container##.scrollTop := container##.scrollHeight
  in
  let execute () =
    let content = Js.to_string textbox##.value##trim in
    let content' =
      let len = String.length content in
      if
        try
          content <> "" && content.[len - 1] <> ';' && content.[len - 2] <> ';'
        with _ -> true
      then content ^ ";;"
      else content
    in
    current_position := output##.childNodes##.length;
    textbox##.value := Js.string "";
    History.push content;
    let* o = with_rpc Toprpc.exec content' in
    handle_output o;
    Lwt_result.return ()
  in
  let complete () =
    let content = Js.to_string textbox##.value in
    let* c = with_rpc Toprpc.complete content in
    handle_completion c;
    Lwt_result.return ()
  in
  let setup () =
    let* o = with_rpc Toprpc.setup () in
    handle_output o;
    Lwt_result.return ()
  in
  let history_down _e =
    let txt = Js.to_string textbox##.value in
    let pos = textbox##.selectionStart in
    try
      if String.length txt = pos then raise Not_found;
      let _ = String.index_from txt pos '\n' in
      Js._true
    with Not_found ->
      History.current txt;
      History.next textbox;
      Js._false
  in
  let history_up _e =
    let txt = Js.to_string textbox##.value in
    let pos = textbox##.selectionStart - 1 in
    try
      if pos < 0 then raise Not_found;
      let _ = String.rindex_from txt pos '\n' in
      Js._true
    with Not_found ->
      History.current txt;
      History.previous textbox;
      Js._false
  in
  let meta e =
    let b = Js.to_bool in
    b e##.ctrlKey || b e##.altKey || b e##.metaKey
  in
  let shift e = Js.to_bool e##.shiftKey in
  (* setup handlers *)
  textbox##.onkeyup :=
    Dom_html.handler (fun _ ->
        Lwt.async (resize ~container ~textbox);
        Js._true);
  textbox##.onchange :=
    Dom_html.handler (fun _ ->
        Lwt.async (resize ~container ~textbox);
        Js._true);
  textbox##.onkeydown :=
    Dom_html.handler (fun e ->
        match e##.keyCode with
        | 13 when not (meta e || shift e) ->
          async_raise execute;
          Js._false
        | 13 ->
            Lwt.async (resize ~container ~textbox);
            Js._true
        | 09 ->
          async_raise complete;
          Js._false
        | 76 when meta e ->
            output##.innerHTML := Js.string "";
            Js._true
        | 75 when meta e ->
          async_raise setup;
          Js._false
        | 38 ->
          history_up e
        | 40 ->
          history_down e
        | _ ->
          Js._true);
  (Lwt.async_exception_hook :=
     fun exc ->
       Brr.Console.error
         [ Jstr.v @@ "exc during Lwt.async: " ^ Printexc.to_string exc ];
       match exc with
       | Js_error.Exn e -> Firebug.console##log (Js_error.stack e)
       | _ -> ());
  Lwt.async (fun () ->
      let* () = resize ~container ~textbox () in
      textbox##focus;
      Lwt.return_unit);
  let readline () =
    Js.Opt.case
      (Dom_html.window##prompt
         (Js.string "The toplevel expects inputs:")
         (Js.string ""))
      (fun () -> "")
      (fun s -> Js.to_string s ^ "\n")
  in
  Sys_js.set_channel_filler stdin readline;
  async_raise setup;
  History.setup ();
  textbox##.value := Js.string "";
  (* Run initial code if any *)
  try
    let code = List.assoc "code" (parse_hash ()) in
    textbox##.value := Js.string (B64.decode code);
    async_raise execute
  with
  | Not_found -> ()
  | exc ->
      Firebug.console##log_3 (Js.string "exception")
        (Js.string (Printexc.to_string exc))
        exc

let run s = Lwt.async @@ fun () -> run' s

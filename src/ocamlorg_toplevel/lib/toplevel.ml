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
open Brr_io
open Lwt
module Worker = Brr_webworkers.Worker

let by_id s = Dom_html.getElementById s

let by_id_coerce s f =
  Js.Opt.get (f (Dom_html.getElementById s)) (fun () -> raise Not_found)

let do_by_id s f = try f (Dom_html.getElementById s) with Not_found -> ()

let resize ~container ~textbox () =
  Lwt.pause () >>= fun () ->
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
  | None ->
    ()
  | Some n ->
    iter_on_sharp ~f n

let current_position = ref 0

let highlight_location ((line1, col1), (line2, col2)) =
  let x = ref 0 in
  let output = by_id "output" in
  let first =
    Js.Opt.get
      (output##.childNodes##item !current_position)
      (fun _ -> assert false)
  in
  iter_on_sharp first ~f:(fun e ->
      incr x;
      if !x >= line1 && !x <= line2 then
        let from_ = if !x = line1 then `Pos col1 else `Pos 0 in
        let to_ = if !x = line2 then `Pos col2 else `Last in
        Colorize.highlight from_ to_ e)

let append colorize output cl s =
  Dom.appendChild output (Tyxml_js.To_dom.of_element (colorize ~a_class:cl s))

module History = struct
  let data = ref [| "" |]

  let idx = ref 0

  let get_storage () =
    match Js.Optdef.to_option Dom_html.window##.localStorage with
    | exception _ ->
      raise Not_found
    | None ->
      raise Not_found
    | Some t ->
      t

  let setup () =
    try
      let s = get_storage () in
      match Js.Opt.to_option (s##getItem (Js.string "history")) with
      | None ->
        raise Not_found
      | Some s ->
        let a = Json.unsafe_input s in
        data := a;
        idx := Array.length a - 1
    with
    | _ ->
      ()

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
    with
    | Not_found ->
      ()

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

module Worker_rpc = struct
  type t = Jv.t

  let stdout t = Jv.Jstr.find t "stdout"

  let set_stdout t = Jv.Jstr.set t "stdout"

  let stderr t = Jv.Jstr.find t "stderr"

  let set_stderr t = Jv.Jstr.set t "stderr"

  let sharp_ppf t = Jv.Jstr.find t "sharp_ppf"

  let set_sharp_ppf t = Jv.Jstr.set t "sharp_ppf"

  let caml_ppf t = Jv.Jstr.find t "caml_ppf"

  let set_caml_ppf t = Jv.Jstr.set t "caml_ppf"

  (* Encoded highlight position as only line and column positions *)
  let highlight t =
    let jv = Jv.find t "highlight" in
    Option.map
      (fun jv ->
        ( (Jv.Int.get jv "line1", Jv.Int.get jv "col1")
        , (Jv.Int.get jv "line2", Jv.Int.get jv "col2") ))
      jv

  let make_highlight ((l1, c1), (l2, c2)) =
    let o = Jv.obj [||] in
    Jv.Int.set o "line1" l1;
    Jv.Int.set o "col1" c1;
    Jv.Int.set o "line2" l2;
    Jv.Int.set o "col2" c2;
    o

  let set_highlight t h = Jv.set t "highlight" (make_highlight h)

  let completions t =
    let jv = Jv.find t "completions" in
    Option.map (Jv.to_array Jv.to_string) jv

  let set_completions t v =
    Jv.set t "is_completions" Jv.true';
    Jv.set t "completions" v

  let create ?stdout ?stderr ?sharp_ppf ?caml_ppf ?highlight ?completions () =
    let o = Jv.obj [||] in
    Jv.set o "is_completions" Jv.false';
    Option.iter (set_stdout o) stdout;
    Option.iter (set_stderr o) stderr;
    Option.iter (set_sharp_ppf o) sharp_ppf;
    Option.iter (set_caml_ppf o) caml_ppf;
    Option.iter (set_highlight o) highlight;
    Option.iter (set_completions o) completions;
    o

  let of_json v = Brr.Json.decode v |> Result.get_ok

  let to_json v = Brr.Json.encode v
end

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

let outstanding_execution : Brr.G.timer_id option ref = ref None

let worker_setup w =
  let o = Jv.obj [||] in
  Jv.set o "ty" (Jv.of_string "setup");
  Worker.post w o

let worker_exec w phr =
  let o = Jv.obj [||] in
  Jv.set o "ty" (Jv.of_string "execute");
  Jv.set o "phrase" (Jv.of_string phr);
  Worker.post w o

let worker_complete w phr =
  let o = Jv.obj [||] in
  Jv.set o "ty" (Jv.of_string "complete");
  Jv.set o "phrase" (Jv.of_string phr);
  Worker.post w o

let run s =
  let worker =
    try Worker.create (Jstr.v s) with
    | Jv.Error _ ->
      failwith "Failed to created worker"
  in
  let container = by_id "toplevel-container" in
  let output = by_id "output" in
  let textbox : 'a Js.t = by_id_coerce "userinput" Dom_html.CoerceTo.textarea in
  textbox##.disabled := Js._false;
  let recv_from_worker msg =
    Option.iter Brr.G.stop_timer !outstanding_execution;
    outstanding_execution := None;
    let msg : Jstr.t = Message.Ev.data (Brr.Ev.as_type msg) in
    let worker_data = Worker_rpc.of_json msg in
    match
      try Jv.get worker_data "is_completions" |> Jv.to_bool with _ -> false
    with
    | true ->
      let c = Jv.get worker_data "completions" in
      let completions = Jv.get c "l" |> Jv.to_list Jv.to_string in
      let n = Jv.get c "n" |> Jv.to_int in
      if List.length completions = 1 then
        let txt = String.sub (Js.to_string textbox##.value) 0 n in
        let txt = txt ^ List.hd completions in
        textbox##.value := Js.string txt
      else (
        List.iter
          (fun l -> append Colorize.text output "stdout" (l ^ " "))
          completions;
        append Colorize.text output "stdout" "\n")
    | false ->
      let get_jstr f = Option.map Jstr.to_string @@ f worker_data in
      Option.iter
        (append Colorize.ocaml output "sharp")
        (get_jstr Worker_rpc.sharp_ppf);
      Option.iter
        (append Colorize.text output "stdout")
        (get_jstr Worker_rpc.stdout);
      Option.iter
        (append Colorize.text output "stderr")
        (get_jstr Worker_rpc.stderr);
      Option.iter
        (append Colorize.ocaml output "caml")
        (get_jstr Worker_rpc.caml_ppf);
      Option.iter highlight_location (Worker_rpc.highlight worker_data);
      Lwt.async @@ resize ~container ~textbox;
      container##.scrollTop := container##.scrollHeight;
      ignore textbox##focus;
      ()
  in
  let () =
    Brr.Ev.listen Message.Ev.message recv_from_worker (Worker.as_target worker)
  in
  let execute () =
    let content = Js.to_string textbox##.value##trim in
    let content' =
      let len = String.length content in
      if
        try
          content <> "" && content.[len - 1] <> ';' && content.[len - 2] <> ';'
        with
        | _ ->
          true
      then
        content ^ ";;"
      else
        content
    in
    current_position := output##.childNodes##.length;
    textbox##.value := Js.string "";
    History.push content;
    (* Either execute and set outstanding execution or do nothing *)
    if Option.is_none !outstanding_execution then (
      worker_exec worker content';
      outstanding_execution :=
        Some
          (Brr.G.set_timeout ~ms:10000 (fun () ->
               Worker.terminate worker;
               timeout_container ())));
    Lwt.return_unit
  in
  let complete () =
    let content = Js.to_string textbox##.value in
    worker_complete worker content
  in
  let history_down _e =
    let txt = Js.to_string textbox##.value in
    let pos = textbox##.selectionStart in
    try
      if String.length txt = pos then raise Not_found;
      let _ = String.index_from txt pos '\n' in
      Js._true
    with
    | Not_found ->
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
    with
    | Not_found ->
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
          Lwt.async execute;
          Js._false
        | 13 ->
          Lwt.async (resize ~container ~textbox);
          Js._true
        | 09 ->
          complete ();
          Js._false
        | 76 when meta e ->
          output##.innerHTML := Js.string "";
          Js._true
        | 75 when meta e ->
          worker_setup worker;
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
       match exc with Js.Error e -> Firebug.console##log e##.stack | _ -> ());
  Lwt.async (fun () ->
      resize ~container ~textbox () >>= fun () ->
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
  worker_setup worker;
  History.setup ();
  textbox##.value := Js.string "";
  (* Run initial code if any *)
  try
    let code = List.assoc "code" (parse_hash ()) in
    textbox##.value := Js.string (B64.decode code);
    Lwt.async execute
  with
  | Not_found ->
    ()
  | exc ->
    Firebug.console##log_3
      (Js.string "exception")
      (Js.string (Printexc.to_string exc))
      exc

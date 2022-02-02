open Js_of_ocaml_toplevel
open Ocamlorg_toplevel
open Toplevel

(* OCamlorg toplevel in a web worker

   This communicates with the toplevel code via the API defined in
   {!Toplevel_api}. This allows the OCaml execution to not block the "main
   thread" keeping the page responsive. *)

module Version = struct
  type t = int list

  let split_char ~sep p =
    let len = String.length p in
    let rec split beg cur =
      if cur >= len then
        if cur - beg > 0 then [ String.sub p beg (cur - beg) ] else []
      else if sep p.[cur] then
        String.sub p beg (cur - beg) :: split (cur + 1) (cur + 1)
      else split beg (cur + 1)
    in
    split 0 0

  let split v =
    match
      split_char ~sep:(function '+' | '-' | '~' -> true | _ -> false) v
    with
    | [] -> assert false
    | x :: _ ->
        List.map int_of_string
          (split_char ~sep:(function '.' -> true | _ -> false) x)

  let current = split Sys.ocaml_version
  let compint (a : int) b = compare a b

  let rec compare v v' =
    match (v, v') with
    | [ x ], [ y ] -> compint x y
    | [], [] -> 0
    | [], y :: _ -> compint 0 y
    | x :: _, [] -> compint x 0
    | x :: xs, y :: ys -> (
        match compint x y with 0 -> compare xs ys | n -> n)
end

let exec' s =
  let res : bool = JsooTop.use Format.std_formatter s in
  if not res then Format.eprintf "error while evaluating %s@." s

let setup () =
  JsooTop.initialize ();
  Sys.interactive := false;
  if Version.compare Version.current [ 4; 07 ] >= 0 then exec' "open Stdlib";
  let header1 = Printf.sprintf "        %s version %%s" "OCaml" in
  let header2 =
    Printf.sprintf "     Compiled with Js_of_ocaml version %s"
      Js_of_ocaml.Sys_js.js_of_ocaml_version
  in
  exec' (Printf.sprintf "Format.printf \"%s@.\" Sys.ocaml_version;;" header1);
  exec' (Printf.sprintf "Format.printf \"%s@.\";;" header2);
  exec' "#enable \"pretty\";;";
  exec' "#disable \"shortvar\";;";
  Toploop.add_directive "load_js"
    (Toploop.Directive_string
       (fun name -> Js_of_ocaml.Js.Unsafe.global##load_script_ name))
    Toploop.{ section = ""; doc = "Load a javascript script" };
  Sys.interactive := true;
  ()

let setup_printers () =
  exec' "let _print_unit fmt (_ : 'a) : 'a = Format.pp_print_string fmt \"()\"";
  Topdirs.dir_install_printer Format.std_formatter
    Longident.(Lident "_print_unit")

let stdout_buff = Buffer.create 100
let stderr_buff = Buffer.create 100

(* RPC function implementations *)

module M = Idl.IdM (* Server is synchronous *)

module IdlM = Idl.Make (M)
module Server = Toplevel_api.Make (IdlM.GenServer ())

(* These are all required to return the appropriate value for the API within the
   [IdlM.T] monad. The simplest way to do this is to use [IdlM.ErrM.return] for
   the success case and [IdlM.ErrM.return_err] for the failure case *)

let buff_opt b = match Buffer.contents b with "" -> None | s -> Some s

let execute =
  let code_buff = Buffer.create 100 in
  let res_buff = Buffer.create 100 in
  let pp_code = Format.formatter_of_buffer code_buff in
  let pp_result = Format.formatter_of_buffer res_buff in
  let highlighted = ref None in
  let highlight_location loc =
    let _file1, line1, col1 = Location.get_pos_info loc.Location.loc_start in
    let _file2, line2, col2 = Location.get_pos_info loc.Location.loc_end in
    highlighted := Some Toplevel_api.{ line1; col1; line2; col2 }
  in
  fun phrase ->
    Buffer.clear code_buff;
    Buffer.clear res_buff;
    Buffer.clear stderr_buff;
    Buffer.clear stdout_buff;
    JsooTop.execute true ~pp_code ~highlight_location pp_result phrase;
    Format.pp_print_flush pp_code ();
    Format.pp_print_flush pp_result ();
    IdlM.ErrM.return
      Toplevel_api.
        {
          stdout = buff_opt stdout_buff;
          stderr = buff_opt stderr_buff;
          sharp_ppf = buff_opt code_buff;
          caml_ppf = buff_opt res_buff;
          highlight = !highlighted;
        }

let setup () =
  Js_of_ocaml.Sys_js.set_channel_flusher stdout (Buffer.add_string stdout_buff);
  Js_of_ocaml.Sys_js.set_channel_flusher stderr (Buffer.add_string stderr_buff);
  setup ();
  setup_printers ();
  IdlM.ErrM.return
    Toplevel_api.
      {
        stdout = buff_opt stdout_buff;
        stderr = buff_opt stderr_buff;
        sharp_ppf = None;
        caml_ppf = None;
        highlight = None;
      }

let complete phrase =
  let contains_double_underscore s =
    let len = String.length s in
    let rec aux i =
      if i > len - 2 then false
      else if s.[i] = '_' && s.[i + 1] = '_' then true
      else aux (i + 1)
    in
    aux 0
  in
  let n, res = UTop_complete.complete ~phrase_terminator:";;" ~input:phrase in
  let res =
    List.filter (fun (l, _) -> not (contains_double_underscore l)) res
  in
  let completions = List.map fst res in
  IdlM.ErrM.return Toplevel_api.{ n; completions }

let server process e =
  let ( let* ) = M.bind in
  let msg = (Brr_io.Message.Ev.data (Brr.Ev.as_type e) : Jv.t) in
  let call = Rpc_brr.Conv.rpc_call_of_jv msg in
  let* response = process call in
  let jv = Rpc_brr.Conv.jv_of_rpc_response response in
  Worker.G.post jv;
  M.return ()

let run () =
  (* Here we bind the server stub functions to the implementations *)
  Server.complete complete;
  Server.exec execute;
  Server.setup setup;
  let rpc_fn = IdlM.server Server.implementation in
  Jv.(set global "onmessage" @@ Jv.repr (server rpc_fn))

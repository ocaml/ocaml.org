open Js_of_ocaml_toplevel
open Brr
open Brr_io
open Ocamlorg_toplevel.Toplevel

(* OCamlorg toplevel in a web worker

   This communicates with the toplevel code via simple json schema, this allows
   the OCaml execution to not block the "main thread" keeping the page
   responsive. *)

let jstr_of_buffer v = Jstr.v @@ Buffer.contents v

module Version = struct
  type t = int list

  let split_char ~sep p =
    let len = String.length p in
    let rec split beg cur =
      if cur >= len then
        if cur - beg > 0 then [ String.sub p beg (cur - beg) ] else []
      else if sep p.[cur] then
        String.sub p beg (cur - beg) :: split (cur + 1) (cur + 1)
      else
        split beg (cur + 1)
    in
    split 0 0

  let split v =
    match
      split_char ~sep:(function '+' | '-' | '~' -> true | _ -> false) v
    with
    | [] ->
      assert false
    | x :: _ ->
      List.map
        int_of_string
        (split_char ~sep:(function '.' -> true | _ -> false) x)

  let current = split Sys.ocaml_version

  let compint (a : int) b = compare a b

  let rec compare v v' =
    match v, v' with
    | [ x ], [ y ] ->
      compint x y
    | [], [] ->
      0
    | [], y :: _ ->
      compint 0 y
    | x :: _, [] ->
      compint x 0
    | x :: xs, y :: ys ->
      (match compint x y with 0 -> compare xs ys | n -> n)
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
    Printf.sprintf
      "     Compiled with Js_of_ocaml version %s"
      Js_of_ocaml.Sys_js.js_of_ocaml_version
  in
  exec' (Printf.sprintf "Format.printf \"%s@.\" Sys.ocaml_version;;" header1);
  exec' (Printf.sprintf "Format.printf \"%s@.\";;" header2);
  exec' "#enable \"pretty\";;";
  exec' "#disable \"shortvar\";;";
  let[@alert "-deprecated"] new_directive n k =
    Hashtbl.add Toploop.directive_table n k
  in
  new_directive
    "load_js"
    (Toploop.Directive_string
       (fun name -> Js_of_ocaml.Js.Unsafe.global##load_script_ name));
  Sys.interactive := true;
  ()

let setup_printers () =
  exec' "let _print_unit fmt (_ : 'a) : 'a = Format.pp_print_string fmt \"()\"";
  Topdirs.dir_install_printer
    Format.std_formatter
    Longident.(Lident "_print_unit")

let stdout_buff = Buffer.create 100

let stderr_buff = Buffer.create 100

let execute =
  let code_buff = Buffer.create 100 in
  let res_buff = Buffer.create 100 in
  let pp_code = Format.formatter_of_buffer code_buff in
  let pp_result = Format.formatter_of_buffer res_buff in
  let highlighted = ref None in
  let highlight_location loc =
    let _file1, line1, col1 = Location.get_pos_info loc.Location.loc_start in
    let _file2, line2, col2 = Location.get_pos_info loc.Location.loc_end in
    highlighted := Some ((line1, col1), (line2, col2))
  in
  fun phrase ->
    Buffer.clear code_buff;
    Buffer.clear res_buff;
    Buffer.clear stderr_buff;
    Buffer.clear stdout_buff;
    JsooTop.execute true ~pp_code ~highlight_location pp_result phrase;
    Format.pp_print_flush pp_code ();
    Format.pp_print_flush pp_result ();
    let highlight = !highlighted in
    let data =
      Worker_rpc.create
        ?highlight
        ~stdout:(jstr_of_buffer stdout_buff)
        ~stderr:(jstr_of_buffer stderr_buff)
        ~sharp_ppf:(jstr_of_buffer code_buff)
        ~caml_ppf:(jstr_of_buffer res_buff)
        ()
    in
    highlighted := None;
    let json = Worker_rpc.to_json data in
    json

let recv_from_page e =
  let phrase = (Message.Ev.data (Ev.as_type e) : Jstr.t) in
  match Jstr.to_string phrase with
  | "setup" ->
    Js_of_ocaml.Sys_js.set_channel_flusher
      stdout
      (Buffer.add_string stdout_buff);
    Js_of_ocaml.Sys_js.set_channel_flusher
      stderr
      (Buffer.add_string stderr_buff);
    setup ();
    setup_printers ();
    let data =
      Worker_rpc.create
        ~stdout:(jstr_of_buffer stdout_buff)
        ~stderr:(jstr_of_buffer stderr_buff)
        ()
    in
    let json = Worker_rpc.to_json data in
    Worker.G.post json
  | phrase ->
    Worker.G.post (execute phrase)

let () = Jv.(set global "onmessage" @@ Jv.repr recv_from_page)

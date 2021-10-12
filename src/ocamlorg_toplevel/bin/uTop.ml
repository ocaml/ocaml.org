(*
 * uTop.ml
 * -------
 * Copyright : (c) 2011, Jeremie Dimino <jeremie@dimino.org>
 * Licence   : BSD3
 *
 * This file is a part of utop.
 *)

[@@@warning "-27"]


module String_set = Set.Make(String)

let version = "2.7.0"

(* +-----------------------------------------------------------------+
   | Keywords                                                        |
   +-----------------------------------------------------------------+ *)

let default_keywords = [
  "and"; "as"; "assert"; "begin"; "class"; "constraint"; "do";
  "done"; "downto"; "else"; "end"; "exception"; "external";
  "for"; "fun"; "function"; "functor"; "if"; "in"; "include";
  "inherit"; "initializer"; "lazy"; "let"; "match"; "method"; "module";
  "mutable"; "new"; "object";  "of";  "open"; "private";  "rec"; "sig";
  "struct";  "then";  "to";  "try";  "type";  "val"; "virtual";
  "when"; "while"; "with"; "try_lwt"; "finally"; "for_lwt"; "lwt";
]

let keywords = ref (String_set.of_list default_keywords)
let add_keyword kwd = keywords := String_set.add kwd !keywords

(* +-----------------------------------------------------------------+
   | Error reporting                                                 |
   +-----------------------------------------------------------------+ *)

let get_message func x =
  let buffer = Buffer.create 1024 in
  let pp = Format.formatter_of_buffer buffer in
  func pp x;
  Format.pp_print_flush pp ();
  Buffer.contents buffer

let get_ocaml_error_message exn =
  let buffer = Buffer.create 1024 in
  let pp = Format.formatter_of_buffer buffer in
  Errors.report_error pp exn;
  Format.pp_print_flush pp ();
  let str = Buffer.contents buffer in
  try
    Scanf.sscanf
      str
      "Characters %d-%d:\n%[\000-\255]"
      (fun start stop msg -> ((start, stop), msg))
  with _ ->
    ((0, 0), str)

let collect_formatters buf pps f =
  (* First flush all formatters. *)
  List.iter (fun pp -> Format.pp_print_flush pp ()) pps;
  (* Save all formatter functions. *)
  let save = List.map (fun pp -> Format.pp_get_formatter_out_functions pp ()) pps in
  let restore () =
    List.iter2
      (fun pp out_functions ->
         Format.pp_print_flush pp ();
         Format.pp_set_formatter_out_functions pp out_functions)
      pps save
  in
  (* Output functions. *)
  let out_functions =
    let ppb = Format.formatter_of_buffer buf in
    Format.pp_get_formatter_out_functions ppb ()
  in
  (* Replace formatter functions. *)
  List.iter
    (fun pp ->
       Format.pp_set_formatter_out_functions pp out_functions)
    pps;
  try
    let x = f () in
    restore ();
    x
  with exn ->
    restore ();
    raise exn

let discard_formatters pps f =
  (* First flush all formatters. *)
  List.iter (fun pp -> Format.pp_print_flush pp ()) pps;
  (* Save all formatter functions. *)
  let save = List.map (fun pp -> Format.pp_get_formatter_out_functions pp ()) pps in
  let restore () =
    List.iter2
      (fun pp out_functions ->
         Format.pp_print_flush pp ();
         Format.pp_set_formatter_out_functions pp out_functions)
      pps save
  in
  (* Output functions. *)
  let out_functions = {
    Format.out_string = (fun _ _ _ -> ()); out_flush = ignore;
    out_newline = ignore; out_spaces = ignore
#if OCAML_VERSION >= (4, 06, 0)
      ; out_indent = ignore
#endif
  } in
  (* Replace formatter functions. *)
  List.iter (fun pp -> Format.pp_set_formatter_out_functions pp out_functions) pps;
  try
    let x = f () in
    restore ();
    x
  with exn ->
    restore ();
    raise exn

(* +-----------------------------------------------------------------+
   | Parsing                                                         |
   +-----------------------------------------------------------------+ *)

type location = int * int

type 'a result =
  | Value of 'a
  | Error of location list * string

exception Need_more

let input_name = "//toplevel//"

let lexbuf_of_string eof str =
  let pos = ref 0 in
  let lexbuf =
    Lexing.from_function
      (fun buf len ->
        if !pos = String.length str then begin
          eof := true;
          0
        end else begin
          let len = min len (String.length str - !pos) in
          String.blit str !pos buf 0 len;
          pos := !pos + len;
          len
        end)
  in
  Location.init lexbuf input_name;
  lexbuf

let mkloc loc =
  (loc.Location.loc_start.Lexing.pos_cnum,
   loc.Location.loc_end.Lexing.pos_cnum)

let parse_default parse str eos_is_error =
  let eof = ref false in
  let lexbuf = lexbuf_of_string eof str in
  try
    (* Try to parse the phrase. *)
    let phrase = parse lexbuf in
    Value phrase
  with
    | _ when !eof && not eos_is_error ->
        (* This is not an error, we just need more input. *)
        raise Need_more
    | End_of_file ->
        (* If the string is empty, do not report an error. *)
        raise Need_more
    | Lexer.Error (error, loc) ->
#if OCAML_VERSION >= (4, 08, 0)
        (match Location.error_of_exn (Lexer.Error (error, loc)) with
        | Some (`Ok error)->
          Error ([mkloc loc], get_message Location.print_report error)
        | _-> raise Need_more)
#else
        Error ([mkloc loc], get_message Lexer.report_error error)
#endif
    | Syntaxerr.Error error -> begin
      match error with
      | Syntaxerr.Unclosed (opening_loc, opening, closing_loc, closing) ->
        Error ([mkloc opening_loc; mkloc closing_loc],
               Printf.sprintf "Syntax error: '%s' expected, the highlighted '%s' might be unmatched" closing opening)
      | Syntaxerr.Applicative_path loc ->
        Error ([mkloc loc],
               "Syntax error: applicative paths of the form F(X).t are not supported when the option -no-app-funct is set.")
      | Syntaxerr.Other loc ->
        Error ([mkloc loc],
               "Syntax error")
      | Syntaxerr.Expecting (loc, nonterm) ->
        Error ([mkloc loc],
               Printf.sprintf "Syntax error: %s expected." nonterm)
      | Syntaxerr.Variable_in_scope (loc, var) ->
        Error ([mkloc loc],
               Printf.sprintf "In this scoped type, variable '%s is reserved for the local type %s." var var)
      | Syntaxerr.Not_expecting (loc, nonterm) ->
          Error ([mkloc loc],
                 Printf.sprintf "Syntax error: %s not expected" nonterm)
      | Syntaxerr.Ill_formed_ast (loc, s) ->
          Error ([mkloc loc],
                 Printf.sprintf "Error: broken invariant in parsetree: %s" s)
#if OCAML_VERSION >= (4, 03, 0)
      | Syntaxerr.Invalid_package_type (loc, s) ->
          Error ([mkloc loc],
                 Printf.sprintf "Invalid package type: %s" s)
#endif
    end
    | Syntaxerr.Escape_error | Parsing.Parse_error ->
        Error ([mkloc (Location.curr lexbuf)],
               "Syntax error")
    | exn ->
        Error ([], "Unknown parsing error (please report it to the utop project): " ^ Printexc.to_string exn)

let parse_toplevel_phrase_default = parse_default Parse.toplevel_phrase
let parse_toplevel_phrase = ref parse_toplevel_phrase_default

(* +-----------------------------------------------------------------+
   | Safety checking                                                 |
   +-----------------------------------------------------------------+ *)

let null = Format.make_formatter (fun str ofs len -> ()) ignore

let rec last head tail =
  match tail with
    | [] ->
        head
    | head :: tail ->
        last head tail

let with_loc loc str = {
  Location.txt = str;
  Location.loc = loc;
}

#if OCAML_VERSION >= (4, 03, 0)
let nolabel = Asttypes.Nolabel
#else
let nolabel = ""
#endif

(* Check that the given phrase can be evaluated without typing/compile
   errors. *)
let check_phrase phrase =
  let open Parsetree in
  match phrase with
    | Ptop_dir _ ->
        None
    | Ptop_def [] ->
        None
    | Ptop_def (item :: items) ->
        let loc = {
          Location.loc_start = item.pstr_loc.Location.loc_start;
          Location.loc_end = (last item items).pstr_loc.Location.loc_end;
          Location.loc_ghost = false;
        } in
        (* Backup. *)
        let snap = Btype.snapshot () in
        let env = !Toploop.toplevel_env in
        (* Construct "let _ () = let module _ = struct <items> end in ()" in order to test
           the typing and compilation of [items] without evaluating them. *)
        let unit = with_loc loc (Longident.Lident "()") in
        let top_def =
          let open Ast_helper in
          with_default_loc loc
            (fun () ->
               Str.eval
                 (Exp.fun_ nolabel None (Pat.construct unit None)
                   (Exp.letmodule (with_loc loc
                        #if OCAML_VERSION >= (4, 10, 0)
                        (Some "_")
                        #else
                          "_"
                        #endif
                        )
                      (Mod.structure (item :: items))
                      (Exp.construct unit None))))
        in
        let check_phrase = Ptop_def [top_def] in
        try
          let _ =
            discard_formatters [Format.err_formatter] (fun () ->
              Env.reset_cache_toplevel ();
              Toploop.execute_phrase false null check_phrase)
          in
          (* The phrase is safe. *)
          Toploop.toplevel_env := env;
          Btype.backtrack snap;
          None
        with exn ->
          (* The phrase contains errors. *)
          let loc, msg = get_ocaml_error_message exn in
          Toploop.toplevel_env := env;
          Btype.backtrack snap;
          Some ([loc], msg)



(*let try_finally ~always work=
#if OCAML_VERSION >= (4, 08, 0)
    Misc.try_finally ~always work
#else
    Misc.try_finally work always
#endif

let use_output command =
  let fn = Filename.temp_file "ocaml" "_toploop.ml" in
  try_finally ~always:(fun () ->
    try Sys.remove fn with Sys_error _ -> ())
    (fun () ->
       match
         Printf.ksprintf Sys.command "%s > %s"
           command
           (Filename.quote fn)
       with
       | 0 ->
         ignore (Toploop.use_file Format.std_formatter fn : bool)
       | n ->
         Format.printf "Command exited with code %d.@." n)

let () =
  let name = "use_output" in
  if not (Hashtbl.mem Toploop.directive_table name) then
    Hashtbl.add
      Toploop.directive_table
      name
      (Toploop.Directive_string use_output)
*)

 (* +-----------------------------------------------------------------+
   | Compiler-libs re-exports                                        |
   +-----------------------------------------------------------------+ *)

#if OCAML_VERSION >= (4, 08, 0)
let get_load_path ()= Load_path.get_paths ()
let set_load_path path= Load_path.init path
#else
let get_load_path ()= !Config.load_path
let set_load_path path= Config.load_path := path
#endif


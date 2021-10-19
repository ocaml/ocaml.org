(*
 * uTop.mli
 * --------
 * Copyright : (c) 2011, Jeremie Dimino <jeremie@dimino.org>
 * Licence   : BSD3
 *
 * This file is a part of utop.
 *)

(** UTop configuration. *)

val version : string
(** Version of utop. *)

val keywords : Set.Make(String).t ref
(** The set of OCaml keywords. *)

val add_keyword : string -> unit
(** Add a new OCaml keyword. *)

(** Type of a string-location. It is composed of a start and stop offsets (in
    bytes). *)
type location = int * int

(** Result of a function processing a programx. *)
type 'a result =
  | Value of 'a  (** The function succeeded and returned this value. *)
  | Error of location list * string
      (** The function failed. Arguments are a list of locations to highlight in
          the source and an error message. *)

(** Exception raised by a parser when it need more data. *)
exception Need_more

val parse_toplevel_phrase
  : (string -> bool -> Parsetree.toplevel_phrase result) ref
(** [parse_toplevel_phrase] is the function used to parse a phrase typed in the
    toplevel.

    Its arguments are:

    - [input]: the string to parse
    - [eos_is_error]

    If [eos_is_error] is [true] and the parser reach the end of input, then
    {!Parse_failure} should be returned.

    If [eos_is_error] is [false] and the parser reach the end of input, the
    exception {!Need_more} must be thrown.

    Except for {!Need_more}, the function must not raise any exception. *)

val parse_toplevel_phrase_default
  :  string
  -> bool
  -> Parsetree.toplevel_phrase result
(** The default parser for toplevel phrases. It uses the standard ocaml parser. *)

val parse_default : (Lexing.lexbuf -> 'a) -> string -> bool -> 'a result
(** The default parser. It uses the standard ocaml parser. *)

val input_name : string
(** The name you must use in location to let ocaml know that it is from the
    toplevel. *)

val lexbuf_of_string : bool ref -> string -> Lexing.lexbuf
(** [lexbuf_of_string eof str] is the same as [Lexing.from_string
      str]
    except that if the lexer reach the end of [str] then [eof] is set to [true]. *)

(** {6 Helpers} *)

val get_message : (Format.formatter -> 'a -> unit) -> 'a -> string
(** [get_message printer x] applies [printer] on [x] and returns everything it
    prints as a string. *)

val get_ocaml_error_message : exn -> location * string
(** [get_ocaml_error_message exn] returns the location and error message for the
    exception [exn] which must be an exception from the compiler. *)

val check_phrase : Parsetree.toplevel_phrase -> (location list * string) option
(** [check_phrase phrase] checks that [phrase] can be executed without typing or
    compilation errors. It returns [None] if [phrase] is OK and an error message
    otherwise.

    If the result is [None] it is guaranteed that [Toploop.execute_phrase] won't
    raise any exception. *)

val collect_formatters : Buffer.t -> Format.formatter list -> (unit -> 'a) -> 'a
(** [collect_formatters buf pps f] executes [f] and redirect everything it
    prints on [pps] to [buf]. *)

val discard_formatters : Format.formatter list -> (unit -> 'a) -> 'a
(** [discard_formatters pps f] executes [f], dropping everything it prints on
    [pps]. *)

(** {6 compiler-libs reexports} *)

val get_load_path : unit -> string list

val set_load_path : string list -> unit
(** [get_load_path] and [set_load_path] manage the include directories.

    The internal variable contains the list of directories added by
    findlib-required packages and [#directory] directives. *)

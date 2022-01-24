(** IDL for talking to the toplevel webworker *)

open Rpc
open Idl

type highlight = { line1 : int; line2 : int; col1 : int; col2 : int }
[@@deriving rpcty]
(** An area to be highlighted *)

type exec_result = {
  stdout : string option;
  stderr : string option;
  sharp_ppf : string option;
  caml_ppf : string option;
  highlight : highlight option;
}
[@@deriving rpcty]
(** Represents the result of executing a toplevel phrase *)

type completion_result = {
  n : int;
      (** The position in the input string from where the completions may be
          inserted *)
  completions : string list;  (** The list of possible completions *)
}
[@@deriving rpcty]
(** The result returned by a 'complete' call. *)

(** For now we are only using a simple error type *)
type err = InternalError of string [@@deriving rpcty]

module E = Idl.Error.Make (struct
  type t = err

  let t = err
  let internal_error_of e = Some (InternalError (Printexc.to_string e))
end)

let err = E.error

module Make (R : RPC) = struct
  open R

  let description =
    Interface.
      {
        name = "Toplevel";
        namespace = None;
        description =
          [ "Functions for manipulating the toplevel worker thread" ];
        version = (1, 0, 0);
      }

  let implementation = implement description
  let unit_p = Param.mk Types.unit
  let phrase_p = Param.mk Types.string
  let typecheck_result_p = Param.mk exec_result
  let exec_result_p = Param.mk exec_result
  let completion_p = Param.mk completion_result

  let setup =
    declare "setup"
      [
        "Initialise the toplevel. Return value is the initial blurb ";
        "printed when starting a toplevel.";
      ]
      (unit_p @-> returning exec_result_p err)

  let typecheck =
    declare
      "typecheck"
      [ "Typecheck a phrase without actually executing it." ]
      (phrase_p @-> returning typecheck_result_p err)

  let exec =
    declare "exec"
      [
        "Execute a phrase using the toplevel. The toplevel must have been";
        "Initialised first.";
      ]
      (phrase_p @-> returning exec_result_p err)

  let complete =
    declare "complete"
      [
        "Find completions of the incomplete phrase. Completion occurs at the";
        "end of the phrase passed in. If completion is required at a point";
        "other than the end of a string, then take the substring before calling";
        "this API.";
      ]
      (phrase_p @-> returning completion_p err)
end

exception Inconsistent_merge of string * string
(** Cannot merge two PO files. *)

exception File_invalid_index of string * int
(** When parsing a PO file, found an out of order table indices in a plural
    form. *)

exception Invalid_file of string * Lexing.lexbuf
(** A PO file cannot be parsed. *)

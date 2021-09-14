(** Cannot merge two PO files. *)
exception Inconsistent_merge of string * string

(** When parsing a PO file, found an out of order table indices in a plural
    form. *)
exception File_invalid_index of string * int

(** A PO file cannot be parsed. *)
exception Invalid_file of string * Lexing.lexbuf

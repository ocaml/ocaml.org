module String_map = Map.Make (String)

(** Types for the PO processing. The main difference with the type translation
    comes from the necessity of keeping a maximum of comment. *)
type translation =
  | Singular of string list * string list
  | Plural of string list * string list * string list list

type filepos = string * int
(** PO string localizator : represents in which file/lineno a string can be
    found. *)

type special = string
(** PO keyword: represents special keyword like fuzzy, wrap, c-format... *)

type commented_translation = {
  comment_special : special list;
  comment_filepos : filepos list;
  comment_translation : translation;
}

type translations = commented_translation String_map.t
(** Mapping of PO content using the string identifier as the key. *)

type content = { no_domain : translations; domain : translations String_map.t }
(** Content of a PO file. Since comments should be saved, and that we only save
    comments before and in message translation, we need to keep trace of the
    last comments, which is not attached to any translation. *)

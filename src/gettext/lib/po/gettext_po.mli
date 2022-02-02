(** Read and write gettext's .PO files. *)

module Exn : sig
  exception Inconsistent_merge of string * string
  (** Cannot merge two PO files. *)

  exception File_invalid_index of string * int
  (** When parsing a PO file, found an out of order table indices in a plural
      form. *)

  exception Invalid_file of string * Lexing.lexbuf
  (** A PO file cannot be parsed. *)
end

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

type translations = commented_translation Map.Make(String).t
(** Mapping of PO content using the string identifier as the key. *)

type t = { no_domain : translations; domain : translations Map.Make(String).t }
(** Content of a PO file. Since comments should be saved, and that we only save
    comments before and in message translation, we need to keep trace of the
    last comments, which is not attached to any translation. *)

val empty_po : t
(** empty_po : value representing an empty PO *)

val add_translation_no_domain : t -> commented_translation -> t
(** add_translation_no_domain po (comment_lst,location_lst,translation) : add a
    translation to a corpus of already defined translation with no domain
    defined. If the translation already exist, they are merged concerning
    location, and follow these rules for the translation itself :

    - singular and singular : if there is an empty string ( "" ) in one of the
      translation, use the other translation, - plural and plural : if there is
      an empty string list ( [ "" ; "" ] ) in one of the translaiton, use the
      other translation, - singular and plural : merge into a plural form. There
      is checks during the merge that can raise Inconsistent_merge : - for one
      singular string if the two plural strings differs - if there is some
      elements that differs (considering the special case of the empty string )
      in the translation *)

val add_translation_domain : string -> t -> commented_translation -> t
(** add_translation_domain po domain (comment_lst,location_lst,translation): add
    a translation to the already defined translation with the domain defined.
    See add_translation_no_domain for details. *)

val merge_po : t -> t -> t
(** merge_po po1 po2 : merge two PO. The rule for merging are the same as
    defined in add_translation_no_domain. Can raise Inconsistent_merge *)

val merge_pot : t -> t -> t
(** merge_pot po pot : merge a PO with a POT. Only consider strings that exists
    in the pot. Always use location as defined in the POT. If a string is not
    found, use the translation provided in the POT. If a plural is found and a
    singular should be used, downgrade the plural to singular. If a singular is
    found and a plural should be used, upgrade singular to plural, using the
    strings provided in the POT for ending the translation. *)

val input_po : in_channel -> t
val output_po : out_channel -> t -> unit
val read_po : string -> t

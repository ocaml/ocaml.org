type t = {
  language : string;
  territory : string option;
  codeset : string option;
  modifier : string option;
}

val of_string : string -> t
val to_string : t -> string
val compare : t -> t -> int

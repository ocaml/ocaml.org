(* digest map *)
type t

val empty : t

(* read all files in directory [file_root] and add their digest to the given
   digest_map *)
val read_directory : string -> t -> t

(* emit the source code of a ml function that takes as parameter a [filepath]
   and returns an option, if found*)
val render_ml : t -> string

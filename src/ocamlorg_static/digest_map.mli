(* digest map *)
type t

(* read all files in directory [file_root] to compute a digest map from relative
   filepath to digest *)
val read_directory : string -> t

(* retrieve digest for given relative [filepath] from a digest map *)
val digest : string -> t -> string option

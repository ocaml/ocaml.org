(** Backend for the OCaml.org website. *)
module Config = Config

module Package = Package

type t

val init : unit -> t

val pipeline : t -> unit Lwt.t

val site_dir : t -> Fpath.t

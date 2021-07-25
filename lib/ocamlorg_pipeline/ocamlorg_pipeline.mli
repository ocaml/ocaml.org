type t

val init : opam_dir:Fpath.t -> callback:(unit -> unit) -> t
(** [init ~opam_dir ~callback] initialises the pipeline's configuration,
    [opam_dir] is the directory to update with the opam-repository and
    [callback] is a function called after the opam-repository has been updated. *)

val site_dir : t -> Fpath.t
(** [site_dir t] is the directory the pipeline will export the v3.ocaml.org
    website to. *)

val v : t -> (unit, [ `Msg of string ]) Lwt_result.t
(** The pipeline running at port 8081 *)

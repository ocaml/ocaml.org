type t

val init : string -> t
(** [init token] initialises the pipeline's configuration, [token]
    is the Github OAuth token for monitoring repositories with. *)

val site_dir : t -> Fpath.t 
(** [site_dir t] is the directory the pipeline will export the v3.ocaml.org 
    website to. *)

val v : t -> (unit, [`Msg of string]) Lwt_result.t 
(** The pipeline running at port 8081 *)

val open_store : unit -> Git_unix.Store.t Lwt.t

val clone : unit -> unit Lwt.t
(** [clone ()] ensures that "./opam-repository" exists. If not, it clones it. *)

val fetch : unit -> unit Lwt.t

(* Does a "git fetch origin" to update the store. *)

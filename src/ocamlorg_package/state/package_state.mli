(** The durable package state: the package graph computed from opam-repository,
    and its state file. *)

open Package

type t = {
  version : string;  (** {!Info.version} when the state was built. *)
  opam_repository_commit : string option;
      (** The commit the state was built from, if any. *)
  packages : Info.t Version.Map.t Name.Map.t;
  stats : Packages_stats.t option;
}

val empty : t
(** No packages, built from no commit. *)

val rebuild : previous:t -> commit:string -> t Lwt.t
(** [rebuild ~previous ~commit] reads the opam-repository clone, which must be
    at [commit], and computes the state at [commit]. [previous] lets the
    publication dates be read incrementally (see {!Publication_dates.compute}).
    It yields regularly, but each step still runs on the event loop. *)

val load : Fpath.t -> t
(** [load path] reads the state saved at [path]. A missing or unreadable file,
    or one saved with another {!Info.version}, gives {!empty}. *)

val write : Fpath.t -> t -> unit
(** [write path state] saves [state] to [path], atomically: it writes [path.tmp]
    in the same directory and renames it over [path], so that directory must be
    writable. *)

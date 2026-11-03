val exists : unit -> bool
(** Returns true is the clone of opam repository exists, false otherwise. *)

val clone : unit -> string Lwt.t
(** Does a "git clone" on https://github.com/ocaml/opam-repository. Returns the
    latest commit id. *)

val pull : unit -> string Lwt.t
(** Does a "git pull" on https://github.com/ocaml/opam-repository. Returns the
    latest commit id. *)

val last_commit : unit -> string Lwt.t
(** Get the latest commit of the opam repository. *)

val list_packages : unit -> string list
(** List the packages in the [packages/] directory of the opam repository. *)

val list_packages_and_versions : unit -> (string * string list) list
(** List the packages in the [packages/] directory of the opam repository and
    every versions of each packages (in [packages/<package>/]). *)

val list_package_versions : string -> string list option
(** List the versions of the given package by reading the directories in the
    [packages/<package>/] directory. Returns [None] if the specified package
    doesn't exist in [packages/]. *)

val opam_file : string -> string -> OpamFile.OPAM.t option Lwt.t
(** Return the opam file structure given a package name and package version. *)

val commit_at_date : string -> string Lwt.t
(** Find the first commit that happened before or at a date. Will be passed to
    Git's [--before] option, for example ["30.days"]. *)

val new_files_since : a:string -> b:string -> (Fpath.t * string) list Lwt.t
(** Files created during a range of commit. Associate the date at which each
    file as been added, in Git's relative format. Returns more recent files
    first. *)

type ancestry =
  | First_parent  (** On the first-parent history (or equal). *)
  | Not_first_parent
      (** Not an ancestor, an ancestor reachable only through a merge's other
          parent, or ahead of the second commit. *)
  | Unknown_commit  (** The first commit is not in the repository. *)
  | Git_failed of string  (** Any other Git failure, with Git's message. *)

val ancestry : ?repo:Fpath.t -> string -> string -> ancestry Lwt.t
(** [ancestry a b] tells whether commit [a] is on the first-parent history of
    commit [b]. It never raises on a Git failure. [repo] defaults to the
    opam-repository clone. *)

val create_package_to_timestamp :
  ?repo:Fpath.t ->
  ?since:string ->
  ?init:float OpamPackage.Map.t ->
  string ->
  float OpamPackage.Map.t Lwt.t
(** [create_package_to_timestamp commit] maps each package to the commit time of
    the last commit, on the first-parent history of [commit], that added, copied
    or renamed its opam file. With [~since], only the commits in [since..commit]
    are read and folded onto [init] (default: empty): when [since] is on the
    first-parent history of [commit] and [init] holds the dates at [since], the
    result is the same as a full scan. [repo] defaults to the opam-repository
    clone. *)

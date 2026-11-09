(* This module manages the synchronisation of a local clone of
   opam-monorepository to access the opam packages and their metadata. It also
   uses the output of the occurent documentation pipeline to render packages
   documentation. *)

module Import = Import

(** The name of an opam package. *)
module Name : sig
  type t

  val compare : t -> t -> int
  val to_string : t -> string
  val of_string : string -> t
  val of_string_opt : string -> t option

  module Map : OpamStd.MAP with type key := t
end

(** The version of an opam package. *)
module Version : sig
  type t

  val compare : t -> t -> int
  val to_string : t -> string
  val of_string : string -> t
  val of_string_opt : string -> t option

  module Map : OpamStd.MAP with type key := t
end

(** The information of a package. Typically, this is read from the opam file in
    the opam-repository. *)
module Info : sig
  type url = { uri : string; checksum : string list }

  type t = {
    synopsis : string;
    description : string;
    authors : string list;
    maintainers : string list;
    license : string;
    homepage : string list;
    tags : string list;
    dependencies : (Name.t * string option) list;
    rev_deps : (Name.t * string option * Version.t) list;
    depopts : (Name.t * string option) list;
    conflicts : (Name.t * string option) list;
    url : url option;
    publication : float;
    flags : OpamTypes.package_flag list;
  }

  val of_opamfiles :
    timestamps:float OpamPackage.Map.t ->
    OpamFile.OPAM.t Version.Map.t Name.Map.t ->
    t Version.Map.t Name.Map.t Lwt.t
  (** [of_opamfiles ~timestamps opams] builds the info of every package version,
      including its reverse dependencies. Exposed for testing. *)

  val packages_matching :
    OpamPackage.Set.t -> OpamTypes.formula -> OpamPackage.Set.t
  (** [packages_matching packages formula] is
      [OpamFormula.packages packages
      formula], computed the way the
      reverse dependencies are. Exposed for testing that the two agree. *)
end

module Statistics : sig
  type package_stat = { name : Name.t; version : Version.t; info : Info.t }

  type t = {
    nb_packages : int;  (** Total number of packages. *)
    nb_update_week : int;
        (** Number of packages updated during the last 7 days. *)
    nb_packages_month : int;  (** Number of packages added the last 30 days. *)
    newest_packages : (package_stat * string) list;
        (** The 5 newest packages and date, in Git's relative format. *)
    recently_updated : package_stat list;
        (** The 5 most recently updated packages. *)
    most_revdeps : (package_stat * int) list;
        (** The 5 packages with the most number of revdeps. *)
  }
end

type state
type t

module Documentation : sig
  module Status = Documentation.Status

  type pkg := t
  type doc_cache
  type toc = { title : string; href : string; children : toc list }

  type breadcrumb_kind =
    | Page
    | LeafPage
    | Module
    | ModuleType
    | Parameter of int
    | Class
    | ClassType
    | File
    | Source

  type breadcrumb = {
    name : string;
    href : string option;
    kind : breadcrumb_kind;
  }

  type t = {
    uses_katex : bool;
    toc : toc list;
    breadcrumbs : breadcrumb list;
    content : string;
  }

  val status :
    kind:[< `Package | `Universe of string ] ->
    state ->
    pkg ->
    Documentation.Status.t option Lwt.t
  (** Get the build status of the documentation of a package *)

  val sidebar :
    kind:[ `Package | `Universe of string ] ->
    pkg ->
    Ocamlorg_frontend.Navmap.t Lwt.t
  (** Get the sidebar of a package *)

  val documentation_page :
    kind:[< `Package | `Universe of string ] -> pkg -> string -> t option Lwt.t
  (** Get the rendered content of an HTML page for a package given its URL
      relative to the root page of the documentation. *)

  val documentation_asset :
    kind:[< `Package | `Universe of string ] ->
    pkg ->
    string ->
    string option Lwt.t
  (** Get the rendered content of an HTML page for a package given its URL
      relative to the root page of the documentation. *)

  val file :
    kind:[< `Package | `Universe of string ] -> pkg -> string -> t option Lwt.t
  (** Get the rendered content of an HTML page for a file accompanying a package
      given its URL relative to the root of the package. *)

  val search_index :
    kind:[< `Package | `Universe of string ] -> pkg -> string option Lwt.t
  (** Retrieve the search index of a given package. *)

  val search_index_digest :
    kind:[< `Package | `Universe of string ] ->
    state ->
    pkg ->
    string option Lwt.t
  (** Retrieve the hash digest of the search index of a given package. *)

  val doc_status_url : string -> string -> string
  (** [doc_status_url name version] is the URL of the page on the documentation
      build server reporting the documentation build status of the given package
      version. *)
end

module Package_info = Package_info

(** Publication dates of package versions, read from opam-repository's Git
    history. *)
module Publication_dates : sig
  val compute :
    ?repo:Fpath.t ->
    previous:string option * Info.t Version.Map.t Name.Map.t ->
    commit:string ->
    _ Version.Map.t Name.Map.t ->
    float OpamPackage.Map.t Lwt.t
  (** [compute ~previous:(old, old_packages) ~commit packages] maps every
      package version to the time of the last commit, on the first-parent
      history of [commit], that added, copied or renamed its opam file. When
      [old] is on the first-parent history of [commit], only [old..commit] is
      read and folded onto the dates in [old_packages]. It falls back to the
      whole history when there is no [old], when [old] is not in the clone, when
      [old] is not on the first-parent history of [commit] (even if it is
      reachable through a merge's other parent, since [old..commit] would then
      miss first-parent commits that the full scan counts), when Git fails while
      checking this, or when a version of [packages] gets no date that way.
      [repo] defaults to the opam-repository clone. *)
end

val mockup_state : t list -> state
(** [mockup_state ts] produces the opam-repository state from a list of packages *)

val save_state_to : Fpath.t -> state -> unit
(** [save_state_to path state] serializes the durable part of [state] (every
    field except the runtime [docs] cache) to [path]. Exposed for testing; the
    production path is {!Ocamlorg_package_state.Paths.package_state}. *)

val load_state_from : Fpath.t -> state
(** [load_state_from path] reads a state previously written by {!save_state_to},
    rebuilding an empty [docs] cache. A decode failure or a [version] mismatch
    yields a fresh empty state. Exposed for testing. *)

val name : t -> Name.t
(** Get the name of a package. *)

val version : t -> Version.t
(** Get the version of a package. *)

val info : t -> Info.t
(** Get the info of a package. *)

val create : name:Name.t -> version:Version.t -> Info.t -> t
(** This is added to enable demo test package to use Package.t with abstraction *)

val init : ?disable_polling:bool -> unit -> state
(** [init ()] loads the package state saved at
    {!Ocamlorg_package_state.Paths.package_state}, then runs the package-state
    builder ([OCAMLORG_PACKAGE_BUILDER]) at once and every
    [OCAMLORG_OPAM_POLLING] seconds, and loads each new version of the state it
    writes. The server never pulls opam-repository nor rebuilds the state
    itself. With [~disable_polling:true], the builder runs only once. *)

val all_latest : state -> t list
(** Get the list of the latest version of every opam packages. The name and
    versions of the packages are read from the file system, the metadata are
    loaded lazily to improve performance. *)

val stats : state -> Statistics.t option
(** Return the statistics computed from the opam-repository. These statistics
    are continuously updated in the background. Returns [None] if the stats are
    still being computed. *)

val get_by_name : state -> Name.t -> t list option
(** Get the list of packages with the given name. *)

type version_status = Avoided | Deprecated

type version_summary = {
  version : Version.t;
  opam_repository_date : float;
  statuses : version_status list;
}

val get_versions : state -> Name.t -> version_summary list
(** Get the list of versions for a package name, newest coming first. *)

val get_latest : state -> Name.t -> t option
(** Get the latest version of a package given a package name. *)

val get : state -> Name.t -> Version.t -> t option
(** Get a package given its name and version. *)

val latest_documented_version : state -> Name.t -> Version.t option Lwt.t
(** Find the latest documented version of a package. **)

val is_latest_version : state -> Name.t -> Version.t -> bool
(** Returns a bool if the given version is the latest version of a package. **)

val search :
  is_author_match:(string -> string -> bool) ->
  ?sort_by_popularity:bool ->
  state ->
  string ->
  t list
(** Search package that match the given string.

    Packages returned contain the string either in the name, tags, synopsis or
    description. They are ordered in the following way:

    - Packages whose name is exactly the given string - packages whose name
      contain the given string - packages having the given string as a tag -
      packages whose synopsis contain the given string - packages whose
      description contain the given string.

    - Function is_author_match is used decide if a search string correspond to a
      package author

    A call to this function call Lazy.force on every package info. *)

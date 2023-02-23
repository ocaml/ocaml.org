type version = Latest | Version of string

type package = {
  name : string;
  description : string;
  license : string;
  version : string option;
      (* None = we are looking at the latest version of the package on a
         /latest-URL, Some v = we are looking at version v *)
  versions : string list;
  latest_version : string;
  tags : string list;
  rev_deps : string list;
  authors : Ood.Opam_user.t list;
  maintainers : Ood.Opam_user.t list;
  publication : float;
}

let exact_version package =
  match package.version with None -> package.latest_version | Some v -> v

let render_package_version package =
  match package.version with
  | None -> Fmt.str "%s (latest)" package.latest_version
  | Some v -> v

type packages_stats = {
  nb_packages : int;
  nb_update_week : int;
  nb_packages_month : int;
  newest_packages : (package * string) list;
  recently_updated : package list;
  most_revdeps : (package * int) list;
}
(** See {!Ocamlorg_package.Packages_stats.t}. *)

type t =
  { nb_packages : int  (** Total number of packages. *)
  ; nb_commits_week : int
        (** Total number of commits on opam-repository the last 7 days. *)
  ; nb_packages_month : int  (** Number of packages added the last 30 days. *)
  }

let compute _opam_repo_commit packages =
  let nb_packages = OpamPackage.Name.Map.cardinal packages
  and nb_commits_week = 4242
  and nb_packages_month = 42 in
  { nb_packages; nb_commits_week; nb_packages_month }

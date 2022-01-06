type package =
  { name : string
  ; description : string
  ; license : string
  ; version : string
  ; versions : string list
  ; tags : string list
  ; authors : Ood.Opam_user.t list
  ; maintainers : Ood.Opam_user.t list
  }

(** See {!Ocamlorg_package.Packages_stats.t}. *)
type packages_stats =
  { nb_packages : int
  ; nb_update_week : int
  ; nb_packages_month : int
  }

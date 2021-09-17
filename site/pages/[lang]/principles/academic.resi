open! Import

type t = {acads: array<Ood.Academic_institution.t>}

include Pages.S with type t := t

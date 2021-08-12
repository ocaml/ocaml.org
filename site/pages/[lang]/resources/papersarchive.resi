open! Import

type t = {
  title: string,
  pageDescription: string,
  papers: array<Ood.Paper.t>,
}

include Pages.S with type t := t

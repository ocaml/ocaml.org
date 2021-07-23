type t = {
  title: string,
  pageDescription: string,
  tutorials: array<Ood.Tutorial.t>,
}

include Pages.S with type t := t

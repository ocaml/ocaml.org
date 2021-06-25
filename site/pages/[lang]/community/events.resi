type t = {
  title: string,
  pageDescription: string,
  events: array<Ood.Event.t>,
}

include Pages.S with type t := t

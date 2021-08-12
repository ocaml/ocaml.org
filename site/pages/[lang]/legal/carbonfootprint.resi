open! Import

type t = {
  title: string,
  pageDescription: string,
}

include Pages.S with type t := t

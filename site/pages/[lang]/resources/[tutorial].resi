open! Import

type t = {
  source: string,
  title: string,
  pageDescription: string,
  tableOfContents: string,
}

include Pages.S with type t := t

open! Import

module Timeline: {
  module Item: {
    type t = {date: string, description: string}
  }
}

type t = {
  title: string,
  pageDescription: string,
  timeline: array<Timeline.Item.t>,
}

include Pages.S with type t := t

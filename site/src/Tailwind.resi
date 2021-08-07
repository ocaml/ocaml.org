open! Import

module ClassName: {
  type t = string // TODO: make this a private string

  let empty: t
}

module Margin: {
  module Bottom: {
    type t = [
      | #mb2
      | #mb4
      | #mb6
      | #mb10
      | #mb11
      | #mb16
      | #mb20
      | #mb24
      | #mb32
      | #mb36
    ]
  }

  type t = [
    | Bottom.t
  ]
}

module Breakpointable: {
  type t = [
    | Margin.t
  ]
}

module Breakpoint: {
  type item<'a>
  type t<'a> = [#breakpoint(item<'a>)] constraint 'a = [< Breakpointable.t]

  let make: ('a, ~sm: 'a=?, ~md: 'a=?, ~lg: 'a=?, unit) => t<'a>
}

type t = [
  | Margin.t
  | Breakpoint.t<Breakpointable.t>
]

let toClassName: [< t] => ClassName.t
let toClassNames: array<[< t]> => ClassName.t

module Option: {
  let toClassName: option<[< t]> => ClassName.t
}

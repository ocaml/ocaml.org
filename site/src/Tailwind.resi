open! Import

module ClassName: {
  type t = string // TODO: make this a private string

  let empty: t
}

module Margin: {
  module Top: {
    type t = [
      | #mt1
      | #mt2
      | #mt4
      | #mt6
      | #mt10
      | #mt11
      | #mt16
      | #mt20
      | #mt24
      | #mt32
      | #mt36
    ]
  }

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
    | Top.t
  ]
}

module Breakpointable: {
  type t = [
    | Margin.t
  ]
}

module Breakpoint: {
  type item<+'a> = {
    base: 'a,
    sm: option<'a>,
    md: option<'a>,
    lg: option<'a>,
  } constraint 'a = [< Breakpointable.t]

  type t<'a> = [#breakpoint(item<'a>)]

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

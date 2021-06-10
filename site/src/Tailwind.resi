module MarginBottom: {
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

module ByBreakpoint: {
  type t<'a>

  let make: ('a, ~sm: 'a=?, ~md: 'a=?, ~lg: 'a=?, unit) => t<'a>
}

module MarginBottomByBreakpoint: {
  let toClassNamesOrEmpty: option<ByBreakpoint.t<MarginBottom.t>> => string
}

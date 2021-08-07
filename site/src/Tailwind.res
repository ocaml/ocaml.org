open! Import

module ClassName = {
  type t = string

  let empty = ""
}

module Margin = {
  module Bottom = {
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

    let toClassName = mb =>
      switch mb {
      | #mb2 => "mb-2"
      | #mb4 => "mb-4"
      | #mb6 => "mb-6"
      | #mb10 => "mb-10"
      | #mb11 => "mb-11"
      | #mb16 => "mb-16"
      | #mb20 => "mb-20"
      | #mb24 => "mb-24"
      | #mb32 => "mb-32"
      | #mb36 => "mb-36"
      }
  }

  type t = [
    | Bottom.t
  ]

  let toClassName = x =>
    switch x {
    | #...Bottom.t as x => Bottom.toClassName(x)
    }
}

module Breakpointable = {
  type t = [
    | Margin.t
  ]

  let toClassName = t =>
    switch t {
    | #...Margin.t => Margin.toClassName(t)
    }
}

module Breakpoint = {
  type item<'a> = {
    base: 'a,
    sm: option<'a>,
    md: option<'a>,
    lg: option<'a>,
  }

  type t<'a> = [#breakpoint(item<'a>)] constraint 'a = [< Breakpointable.t]

  let make = (base, ~sm=?, ~md=?, ~lg=?, ()) =>
    #breakpoint({
      base: base,
      sm: sm,
      md: md,
      lg: lg,
    })

  let toClassNames = (#breakpoint(t)) => {
    let toClassName = Breakpointable.toClassName
    [
      toClassName(t.base)->Some,
      t.sm->Belt.Option.map(c => `sm:${toClassName(c)}`),
      t.md->Belt.Option.map(c => `md:${toClassName(c)}`),
      t.lg->Belt.Option.map(c => `lg:${toClassName(c)}`),
    ]
    ->Belt.Array.keepMap(x => x)
    ->ClassNames.make
  }
}

type t = [
  | Margin.t
  | Breakpoint.t<Breakpointable.t>
]

let toClassName = t =>
  switch t {
  | #...Margin.t as x => Margin.toClassName(x)
  | #...Breakpoint.t as x => Breakpoint.toClassNames(x)
  }

let toClassNames = ts => ts->Belt.Array.map(toClassName)->Belt.Array.joinWith(" ", x => x)

module Option = {
  let toClassName = t =>
    switch t {
    | None => ClassName.empty
    | Some(t) => toClassName(t)
    }
}

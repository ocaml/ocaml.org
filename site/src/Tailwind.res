module MarginBottom = {
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

module ByBreakpoint = {
  type t<'a> = {
    base: 'a,
    sm: option<'a>,
    md: option<'a>,
    lg: option<'a>,
  }

  let make = (base, ~sm=?, ~md=?, ~lg=?, ()) => {
    base: base,
    sm: sm,
    md: md,
    lg: lg,
  }

  let toClassNames = (t, toClassName) =>
    [
      toClassName(t.base)->Some,
      t.sm->Belt.Option.map(c => `sm:${toClassName(c)}`),
      t.md->Belt.Option.map(c => `md:${toClassName(c)}`),
      t.lg->Belt.Option.map(c => `lg:${toClassName(c)}`),
    ]
    ->Belt.Array.keepMap(x => x)
    ->ClassNames.make

  let toClassNamesOrEmpty = (byBreakpoint, toClassName) =>
    byBreakpoint->Belt.Option.mapWithDefault("", t => toClassNames(t, toClassName))
}

module MarginBottomByBreakpoint = {
  let toClassNamesOrEmpty = byBreakpoint =>
    ByBreakpoint.toClassNamesOrEmpty(byBreakpoint, MarginBottom.toClassName)
}

open! Import

type t = {
  title: string,
  body: string,
  buttonLink: [#Route(Route.t, Lang.t) | #External(string)],
  buttonText: string,
}

module Simple: {
  type t = {
    label: string,
    url: string,
  }

  @react.component
  let make: (~t: t) => React.element
}

module General: {
  @react.component
  let make: (
    ~t: t,
    ~colorStyle: [#BackgroundFilled | #Transparent],
    ~marginBottom: Tailwind.Breakpoint.t<Tailwind.Margin.Bottom.t>=?,
  ) => React.element
}

module TransparentWide: {
  @react.component
  let make: (
    ~t: t,
    ~marginBottom: Tailwind.Breakpoint.t<Tailwind.Margin.Bottom.t>=?,
  ) => React.element
}

module Embedded: {
  @react.component
  let make: (~t: t) => React.element
}

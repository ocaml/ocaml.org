module LinkUrl: {
  type t = Route(string) | External(string)
}

type t = {
  title: string,
  body: string,
  buttonLink: LinkUrl.t,
  buttonText: string,
}

module General: {
  type colorStyle = BackgroundFilled | Transparent

  @react.component
  let make: (
    ~t: t,
    ~colorStyle: colorStyle,
    ~marginBottom: Tailwind.ByBreakpoint.t<Tailwind.MarginBottom.t>=?,
    unit,
  ) => React.element
}

module TransparentWide: {
  @react.component
  let make: (
    ~t: t,
    ~marginBottom: Tailwind.ByBreakpoint.t<Tailwind.MarginBottom.t>=?,
    unit,
  ) => React.element
}

module Embedded: {
  @react.component
  let make: (~t: t) => React.element
}

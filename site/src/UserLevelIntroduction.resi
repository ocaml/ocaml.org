open! Import

type t = {
  level: string,
  introduction: string,
}

@react.component
let make: (
  ~content: t,
  ~marginBottom: Tailwind.Breakpoint.t<Tailwind.Margin.Bottom.t>=?,
) => React.element

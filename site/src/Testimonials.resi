open! Import

type t = {
  quote: string,
  organizationName: string,
  speaker: string,
  organizationLogo: string,
}

@react.component
let make: (
  ~content: t,
  ~marginBottom: Tailwind.Breakpoint.t<Tailwind.Margin.Bottom.t>=?,
) => React.element

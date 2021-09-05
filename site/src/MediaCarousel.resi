open! Import

@react.component
let make: (
  ~marginBottom: Tailwind.Breakpoint.t<Tailwind.Margin.Bottom.t>=?,
  ~label: string,
  ~items: array<'a>,
  ~iconComponent: (int, int, {"item": 'a}) => React.element,
  ~detailsComponent: {"item": 'a} => React.element,
) => React.element

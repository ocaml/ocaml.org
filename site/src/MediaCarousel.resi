open! Import

@react.component
let make: (
  ~label: string,
  ~items: array<'a>,
  ~iconComponent: (int, int, {"item": 'a}) => React.element,
  ~detailsComponent: {"item": 'a} => React.element,
) => React.element

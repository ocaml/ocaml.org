open! Import

@react.component
let make: (
  ~title: string=?,
  ~kind: [#transparent | #opaque],
  ~titleTextColor: string=?,
  ~children: React.element,
) => React.element

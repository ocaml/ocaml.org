open! Import

@react.component
let make: (
  ~title: string=?,
  ~kind: [#Transparent | #Opaque],
  ~titleTextColor: string=?,
  ~children: React.element,
) => React.element

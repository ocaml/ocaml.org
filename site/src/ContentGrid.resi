open! Import

@react.component
let make: (
  ~title: string,
  ~renderChild: 'a => React.element,
  ~cols: [#_2 | #_3],
  ~children: array<'a>,
) => React.element

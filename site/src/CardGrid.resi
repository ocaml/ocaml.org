open! Import

@react.component
let make: (
  ~cardData: array<'a>,
  ~renderCard: (int, 'a) => React.element,
  ~title: string=?,
) => React.element

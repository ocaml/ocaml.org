open! Import

@react.component
let make: (
  ~cardData: array<'a>,
  ~renderCard: 'a => React.element,
  ~title: string=?,
) => React.element

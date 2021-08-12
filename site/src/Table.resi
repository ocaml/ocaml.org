open! Import

module Simple: {
  type t = {
    headers: array<string>,
    data: array<array<React.element>>,
  }

  @react.component
  let make: (~content: t) => React.element
}

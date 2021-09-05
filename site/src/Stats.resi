open! Import

module Item: {
  type t = {
    label: string,
    value: string,
  }
}

@react.component
let make: (~title: string, ~children: array<Item.t>) => React.element

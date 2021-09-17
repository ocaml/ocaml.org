open! Import

module Item: {
  type t = {date: string, description: string}
}

type t = array<Item.t>

@react.component
let make: (~content: t) => React.element

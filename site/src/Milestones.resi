module Table: {
  module Item: {
    type t = {
      version: option<string>,
      description: string,
      period: string,
      completion: string,
      results: string,
    }
  }
}

type t = {items: array<Table.Item.t>}

@react.component
let make: (~content: t) => React.element

module BasicWithIcon: {
  module Item: {
    type t = {
      link: string,
      title: string,
    }
  }

  module RowPrefixIcon: {
    type t = PaperScroll
  }

  @react.component
  let make: (~items: array<Item.t>, ~rowPrefixIcon: RowPrefixIcon.t) => React.element
}

module BasicWithAuxiliaryAttribute: {
  module Item: {
    type t = {
      link: string,
      title: string,
      auxiliaryAttribute: string,
    }
  }

  @react.component
  let make: (~items: array<Item.t>) => React.element
}

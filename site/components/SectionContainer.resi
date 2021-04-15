module MediumCentered2: {
  @react.component
  let make: (~children: React.element) => React.element
}

module ResponsiveCentered: {
  @react.component
  let make: (~children: React.element, ~margins: string) => React.element
}

module MediumCentered: {
  @react.component
  let make: (
    ~children: React.element,
    ~margins: string,
    ~paddingX: string=?,
    ~paddingY: string=?,
    ~otherLayout: string=?,
    ~filled: bool=?,
  ) => React.element
}

module FullyResponsiveCentered: {
  @react.component
  let make: (~children: React.element, ~paddingY: string=?, ~paddingX: string=?) => React.element
}

module NoneFilled: {
  @react.component
  let make: (~children: React.element, ~margins: string) => React.element
}

module LargeCentered: {
  @react.component
  let make: (~children: React.element, ~paddingY: string=?, ~paddingX: string=?) => React.element
}

module SmallCentered: {
  @react.component
  let make: (~children: React.element, ~margins: string, ~otherLayout: string=?) => React.element
}

module VerySmallCentered: {
  @react.component
  let make: (
    ~children: React.element,
    ~margins: string=?,
    ~paddingY: string=?,
    ~paddingX: string=?,
  ) => React.element
}

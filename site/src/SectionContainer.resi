module MediumCentered2: {
  @react.component
  let make: (~children: React.element) => React.element
}

module ResponsiveCentered: {
  @react.component
  let make: (
    ~children: React.element,
    ~marginBottom: Tailwind.Breakpoint.t<Tailwind.Margin.Bottom.t>=?,
  ) => React.element
}

module MediumCentered: {
  @react.component
  let make: (
    ~children: React.element,
    ~marginBottom: Tailwind.Breakpoint.t<Tailwind.Margin.Bottom.t>=?,
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
  let make: (
    ~children: React.element,
    ~marginBottom: Tailwind.Breakpoint.t<Tailwind.Margin.Bottom.t>=?,
  ) => React.element
}

module LargeCentered: {
  @react.component
  let make: (
    ~children: React.element,
    ~paddingY: string=?,
    ~paddingX: string=?,
    ~bgColor: string=?,
  ) => React.element
}

module SmallCentered: {
  @react.component
  let make: (
    ~children: React.element,
    ~marginBottom: Tailwind.Breakpoint.t<Tailwind.Margin.Bottom.t>=?,
    ~otherLayout: string=?,
  ) => React.element
}

module VerySmallCentered: {
  @react.component
  let make: (
    ~children: React.element,
    ~marginBottom: Tailwind.Breakpoint.t<Tailwind.Margin.Bottom.t>=?,
    ~paddingY: string=?,
    ~paddingX: string=?,
  ) => React.element
}

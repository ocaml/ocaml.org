module Large: {
  type callToAction = {
    label: string,
    url: string,
  }

  @react.component
  let make: (
    ~title: string,
    ~callToAction: callToAction=?,
    ~pageDescription: string=?,
    ~marginTop: string=?,
    ~marginBottom: Tailwind.ByBreakpoint.t<Tailwind.MarginBottom.t>=?,
    // ~addMaxWidth: bool=?,
    ~addBottomBar: bool=?,
    unit,
  ) => React.element
}

module MarkdownMedium: {
  @react.component
  let make: (~title: string, ~pageDescription: option<string>) => React.element
}

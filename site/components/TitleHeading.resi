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
    ~marginBottom: string=?,
    // ~addMaxWidth: bool=?,
    ~addBottomBar: bool=?,
    unit,
  ) => React.element
}

module MarkdownMedium: {
  @react.component
  let make: (~title: string, ~pageDescription: option<string>) => React.element
}

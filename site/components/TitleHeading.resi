module Large: {
  type callToAction = {
    label: string,
    url: string,
  }

  @react.component
  let make: (
    ~title: string,
    ~pageDescription: string,
    ~marginTop: string=?,
    ~marginBottom: string=?,
    ~addBottomBar: bool=?,
    ~callToAction: callToAction=?,
    unit,
  ) => React.element
}

module MarkdownMedium: {
  @react.component
  let make: (~title: string, ~pageDescription: string) => React.element
}

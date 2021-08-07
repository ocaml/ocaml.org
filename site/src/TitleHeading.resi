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
    ~marginBottom: Tailwind.Breakpoint.t<Tailwind.Margin.Bottom.t>=?,
    // ~addMaxWidth: bool=?,
    ~addBottomBar: bool=?,
    unit,
  ) => React.element
}

module OverBackgroundImage: {
  module ImageHeight: {
    type t = Tall
  }
  module BackgroundImage: {
    type t = {
      height: ImageHeight.t,
      tailwindImageName: string,
    }
  }

  @react.component
  let make: (
    ~title: string,
    ~backgroundImage: BackgroundImage.t,
    ~pageDescription: string=?,
    unit,
  ) => React.element
}

module MarkdownMedium: {
  @react.component
  let make: (~title: string, ~pageDescription: option<string>) => React.element
}

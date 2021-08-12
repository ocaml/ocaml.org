open! Import

module Large: {
  @react.component
  let make: (
    ~title: string,
    ~callToAction: CallToAction.Simple.t=?,
    ~pageDescription: string=?,
    ~marginTop: Tailwind.Breakpoint.t<Tailwind.Margin.Top.t>=?,
    ~marginBottom: Tailwind.Breakpoint.t<Tailwind.Margin.Bottom.t>=?,
    // ~addMaxWidth: bool=?,
    ~addBottomBar: bool=?,
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
  ) => React.element
}

module MarkdownMedium: {
  @react.component
  let make: (~title: string, ~pageDescription: option<string>) => React.element
}

open! Import

module MainContainer: {
  module None: {
    @react.component
    let make: (~children: React.element) => React.element
  }

  module Centered: {
    @react.component
    let make: (~children: React.element) => React.element
  }

  module NarrowCentered: {
    @react.component
    let make: (~children: React.element) => React.element
  }
}

module Unstructured: {
  @react.component
  let make: (~children: React.element) => React.element
}

module Basic: {
  @react.component
  let make: (
    ~children: React.element,
    ~title: string,
    ~pageDescription: string,
    ~addContainer: [#NoContainer | #Regular | #Narrow]=?,
    ~titleHeadingHeaderClassName: string=?,
    ~callToAction: CallToAction.Simple.t=?,
    ~addBottomBar: bool=?,
  ) => React.element
}

// TODO: imitate "with large screenshot" tailwind ui component
module TopImage: {
  @react.component
  let make: (~children: React.element, ~title: string, ~pageDescription: string) => React.element
}

type highlightItemSummary = {
  preview: string,
  url: string,
}

type highlightContent = {
  highlightItem: string,
  clickToRead: string,
  highlightItemSummary: highlightItemSummary,
  bgImageClass: string,
}

module HighlightItem: {
  @react.component
  let make: (
    ~children: React.element,
    ~title: string,
    ~pageDescription: string,
    ~highlightContent: highlightContent,
  ) => React.element
}

module TitleOverBackgroundImage: {
  @react.component
  let make: (
    ~children: React.element,
    ~title: string,
    ~backgroundImage: TitleHeading.OverBackgroundImage.BackgroundImage.t,
    ~pageDescription: string=?,
  ) => React.element
}

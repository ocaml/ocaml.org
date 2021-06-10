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
  type container = NoContainer | Regular | Narrow

  @react.component
  let make: (
    ~children: React.element,
    ~title: string,
    ~pageDescription: string,
    ~addContainer: container=?,
    ~marginTop: string=?,
    ~callToAction: TitleHeading.Large.callToAction=?,
    ~addBottomBar: bool=?,
    unit,
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

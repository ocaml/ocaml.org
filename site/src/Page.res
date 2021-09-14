open! Import

//  TODO: combine the components below into one variant type

module MainContainer = {
  module None = {
    @react.component
    let make = (~children) => <div className="mx-auto"> children </div>
  }

  module Centered = {
    @react.component
    let make = (~children) => <div className="max-w-7xl mx-auto"> children </div>
  }

  module NarrowCentered = {
    @react.component
    let make = (~children) => <div className="max-w-3xl mx-auto"> children </div>
  }
}

module Unstructured = {
  @react.component
  let make = (~children) => {
    <MainContainer.None> children </MainContainer.None>
  }
}

module Basic = {
  @react.component
  let make = (
    ~children,
    ~title,
    ~pageDescription,
    ~addContainer=#Regular,
    ~titleHeadingHeaderClassName=?,
    ~callToAction=?,
    ~addBottomBar=?,
    (),
  ) => {
    let heading = {
      let addBottomBar = Js.Option.getWithDefault(false, addBottomBar)
      switch callToAction {
      | Some(callToAction) =>
        <div className="mb-6">
          <TitleHeading.Large
            headerClassName=?titleHeadingHeaderClassName
            addBottomBar
            title
            pageDescription
            callToAction
          />
        </div>
      | None =>
        let titleHeading =
          <TitleHeading.Large
            headerClassName=?titleHeadingHeaderClassName addBottomBar title pageDescription
          />
        switch addBottomBar {
        | true => <div className="mb-24"> titleHeading </div>
        | false => titleHeading
        }
      }
    }
    switch addContainer {
    | #Regular => <MainContainer.Centered> heading children </MainContainer.Centered>
    | #Narrow => <MainContainer.NarrowCentered> heading children </MainContainer.NarrowCentered>
    | #NoContainer => <MainContainer.None> heading children </MainContainer.None>
    }
  }
}

// TODO: imitate "with large screenshot" tailwind ui component
module TopImage = {
  @react.component
  let make = (~children, ~title, ~pageDescription) => {
    <MainContainer.Centered>
      <TitleHeading.Large title pageDescription /> children
    </MainContainer.Centered>
  }
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

module HighlightSection = {
  @react.component
  let make = (~content) =>
    <div
      className={content.bgImageClass ++ " bg-auto bg-center bg-no-repeat flex align-bottom place-content-center"}>
      <div className="bg-white overflow-hidden shadow rounded-lg mb-2 lg:mb-7 mt-56 mx-5 max-w-4xl">
        <div className="px-4 py-5 sm:p-6">
          <h2 className="font-bold text-orangedark text-3xl lg:text-4xl text-center mb-2">
            {React.string(content.highlightItem)}
          </h2>
          <p className="text-xl"> {React.string(content.highlightItemSummary.preview)} </p>
          <p className="text-xl text-center lg:text-right">
            // TODO: more descriptive link text (or use aria attribute) for accessibility
            <a href=content.highlightItemSummary.url className="underline text-orangedark">
              {React.string(content.clickToRead ++ ` >`)}
            </a>
          </p>
        </div>
      </div>
    </div>
}

module HighlightItem = {
  @react.component
  let make = (~children, ~title, ~pageDescription, ~highlightContent) => {
    <MainContainer.None>
      <TitleHeading.Large title pageDescription />
      <div className="mb-6"> <HighlightSection content=highlightContent /> </div>
      children
    </MainContainer.None>
  }
}

module TitleOverBackgroundImage = {
  @react.component
  let make = (
    ~children,
    ~title,
    ~backgroundImage: TitleHeading.OverBackgroundImage.BackgroundImage.t,
    ~pageDescription=?,
    (),
  ) => {
    <MainContainer.None>
      <TitleHeading.OverBackgroundImage title backgroundImage ?pageDescription /> children
    </MainContainer.None>
  }
}

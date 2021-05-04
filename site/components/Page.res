// Page:

//  TODO: combine the components below into one variant type

//     Hero (left/right?)

//     TopImage (imitate "with large screenshot"; overlay text?)
//     HighlightedItem

//     Markdown (optional TOC)

// TODO: implement module interface

// need to implement render for the variant

module Basic = {
  @react.component
  let make = (
    ~children,
    ~title,
    ~pageDescription,
    ~addContainer=true,
    ~marginTop=?,
    ~headingMarginBottom=?,
    ~callToAction=?,
    ~addBottomBar=?,
    (),
  ) => {
    let heading = {
      let marginTop = Js.Option.getWithDefault(``, marginTop)
      let headingMarginBottom = Js.Option.getWithDefault(``, headingMarginBottom)
      let addBottomBar = Js.Option.getWithDefault(false, addBottomBar)
      switch callToAction {
      | Some(callToAction) =>
        <TitleHeading.Large
          marginTop marginBottom=headingMarginBottom addBottomBar title pageDescription callToAction
        />
      | None =>
        <TitleHeading.Large
          marginTop marginBottom=headingMarginBottom addBottomBar title pageDescription
        />
      }
    }
    switch addContainer {
    | true => <MainContainer.Centered> heading children </MainContainer.Centered>
    | false => <MainContainer.None> heading children </MainContainer.None>
    }
  }
}

// Section:

//  an interface

//     All the sections used currently

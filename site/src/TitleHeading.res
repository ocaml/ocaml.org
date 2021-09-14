open! Import

// TODO: move this module inside of Page once Markdown layout has finalized
module Large = {
  @react.component
  let make = (
    ~title,
    ~callToAction=?,
    ~pageDescription: option<string>=?,
    ~headerClassName="",
    // ~addMaxWidth=false,
    ~addBottomBar=false,
    (),
  ) => {
    let descr = switch pageDescription {
    | Some(d) => <p className="max-w-xl mt-5 mx-auto text-xl text-gray-500"> {React.string(d)} </p>
    | None => React.null
    }
    <>
      // TODO: make addBottomBar and callToAction mutually exclusive
      // TODO: consider whether to use a container component
      <div
        className={"" /* switch addMaxWidth {  WHICH PAGE USED THIS?
        | true => "max-w-7xl"
        | false => "" 
        } */ ++ " mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8"}>
        <div className="text-center">
          <h1
            className={`text-4xl font-extrabold text-gray-900 sm:text-5xl sm:tracking-tight lg:text-6xl ${headerClassName}`}>
            {React.string(title)}
          </h1>
          descr
          {switch callToAction {
          | Some(callToAction: CallToAction.Simple.t) => <CallToAction.Simple t=callToAction />
          | None => <> </>
          }}
        </div>
      </div>
      {switch addBottomBar {
      | true => <hr className="bg-orangedark h-3" />
      | false => React.null
      }}
    </>
  }
}

module OverBackgroundImage = {
  module ImageHeight = {
    type t = Tall

    let toClassName = t =>
      switch t {
      | Tall => "h-160"
      }
  }

  module BackgroundImage = {
    type t = {
      height: ImageHeight.t,
      tailwindImageName: string,
    }
  }

  @react.component
  let make = (~title, ~backgroundImage: BackgroundImage.t, ~pageDescription=?, ()) => {
    let title = {
      let height = ImageHeight.toClassName(backgroundImage.height)
      <div
        className={`${height} ${backgroundImage.tailwindImageName} bg-cover bg-center flex justify-center items-center`}>
        <h1 className="text-orangedark font-roboto font-bold text-5xl text-center sm:text-8xl">
          {React.string(title)}
        </h1>
      </div>
    }

    let description = switch pageDescription {
    | Some(d) =>
      <p className=`max-w-4xl py-4 sm:py-8 mx-auto text-2xl text-center`> {React.string(d)} </p>
    | None => React.null
    }

    <> title <div className="mt-5"> {description} </div> </>
  }
}

module MarkdownMedium = {
  @react.component
  let make = (~title, ~pageDescription) => {
    let descr = switch pageDescription {
    | Some(d) => <p className="mt-8 text-xl text-gray-500 leading-8"> {React.string(d)} </p>
    | None => React.null
    }

    <SectionContainer.MediumCentered2>
      <h1>
        <span
          className="mt-2 block text-3xl text-center leading-8 font-extrabold tracking-tight text-gray-900 sm:text-4xl">
          {React.string(title)}
        </span>
      </h1>
      descr
    </SectionContainer.MediumCentered2>
  }
}

open! Import

// TODO: move this into a future Link component once the Url and Link types have been thought out
module LinkUrl = {
  @react.component
  let make = (~_to, ~buttonText, ~styling) =>
    switch _to {
    | #Route(_to, lang) =>
      <Route _to lang> <a className=styling> {React.string(buttonText)} </a> </Route>
    | #External(url) =>
      <a href=url target="_blank" className=styling> {React.string(buttonText)} </a>
    }
}

type t = {
  title: string,
  body: string,
  buttonLink: [#Route(Route.t, Lang.t) | #External(string)],
  buttonText: string,
}

module Simple = {
  type t = {
    label: string,
    url: string,
  }
  @react.component
  let make = (~t: t) =>
    <div className="text-center mt-7">
      <Next.Link href=t.url>
        <a
          className="justify-center inline-flex items-center px-4 py-2 border border-transparent text-base font-medium rounded-md shadow-sm text-white bg-orangedark hover:bg-orangedarker focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-orangedarker">
          {React.string(t.label)}
        </a>
      </Next.Link>
    </div>
}

let title = (~text, ~textColor) =>
  <h2 className={`text-3xl font-extrabold ${textColor} sm:text-4xl text-center`}>
    <span className="block"> {React.string(text)} </span>
  </h2>

let body = (~text, ~textColor, ~centered) => {
  let textCenter = switch centered {
  | true => "text-center"
  | false => ""
  }
  <p className={`text-lg leading-6 ${textColor} ${textCenter}`}> {React.string(text)} </p>
}

module General = {
  @react.component
  let make = (~t, ~colorStyle) => {
    let mainFrame = {
      let (
        headingTextColor,
        bodyTextColor,
        buttonTextColor,
        buttonBackground,
        buttonHover,
      ) = switch colorStyle {
      // TODO: use the light orange color noted in Figma instead of bg-gray-100
      | #BackgroundFilled => ("text-white", "text-white", "", "bg-white", "bg-gray-100")
      | #Transparent => ("", "", "text-white", "bg-orangedark", "bg-orangedarker")
      }
      let button =
        <LinkUrl
          _to=t.buttonLink
          buttonText=t.buttonText
          styling={`mt-8 w-full inline-flex items-center justify-center px-5 py-3 border border-transparent text-base font-medium rounded-md ${buttonTextColor} ${buttonBackground} hover:${buttonHover} sm:w-auto`}
        />

      <div className="max-w-2xl mx-auto py-16 px-4 sm:py-20 sm:px-6 lg:px-8">
        {title(~text=t.title, ~textColor=headingTextColor)}
        <div className="mt-4"> {body(~text=t.body, ~textColor=bodyTextColor, ~centered=true)} </div>
        <div className="flex justify-center"> button </div>
      </div>
    }
    switch colorStyle {
    | #BackgroundFilled => <SectionContainer.NoneFilled> mainFrame </SectionContainer.NoneFilled>
    | #Transparent => mainFrame
    }
  }
}

module TransparentWide = {
  @react.component
  let make = (~t) => {
    let button =
      <LinkUrl
        _to=t.buttonLink
        buttonText=t.buttonText
        styling=`mt-8 w-full inline-flex items-center justify-center px-8 py-1 border border-transparent text-base font-medium rounded-md text-white bg-orangedark hover:bg-orangedarker sm:w-auto`
      />

    <SectionContainer.VerySmallCentered paddingY="py-16 sm:py-20" paddingX="px-4 sm:px-6 lg:px-2">
      {title(~text=t.title, ~textColor="")}
      <div className="mt-4"> {body(~text=t.body, ~textColor="", ~centered=false)} </div>
      <div className="flex justify-center"> button </div>
    </SectionContainer.VerySmallCentered>
  }
}

module Embedded = {
  @react.component
  let make = (~t) => {
    let button =
      <div className="inline-flex rounded-md shadow">
        <LinkUrl
          _to=t.buttonLink
          buttonText=t.buttonText
          styling=`inline-flex items-center justify-center px-5 py-3 border border-transparent text-base font-medium rounded-md text-white bg-orangedark hover:bg-orangedarker`
        />
      </div>

    <>
      <p
        className="mt-2 text-orangedark text-center text-3xl font-extrabold tracking-tight sm:text-4xl">
        {React.string(t.title)}
      </p>
      <div className="mt-4"> {body(~text=t.body, ~textColor="text-gray-900", ~centered=true)} </div>
      <div className="mt-8 text-center"> button </div>
    </>
  }
}

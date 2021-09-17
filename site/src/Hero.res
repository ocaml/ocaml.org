open! Import

// TODO: move into a general Link module
module ButtonLink = {
  type t = {
    label: string,
    url: string,
  }
}

type buttonLinks = {
  primaryButton: ButtonLink.t,
  secondaryButton: ButtonLink.t,
}

module HeroTextContainer = {
  @react.component
  let make = (~textAlign, ~display, ~children) =>
    <div className={`mx-auto max-w-7xl w-full pt-16 pb-20 lg:py-48 ${textAlign} ${display}`}>
      children
    </div>
}

let image = (~src, ~pos) => {
  let horizontalPlace = switch pos {
  | #Right => "lg:right-0"
  | #Left => "lg:left-0"
  }
  <div
    className={`relative w-full h-64 sm:h-72 md:h-96 lg:absolute lg:inset-y-0 ${horizontalPlace} lg:w-1/2 lg:h-full`}>
    <img className="absolute inset-0 w-full h-full object-cover" src alt="" />
  </div>
}

let heading = text =>
  <h1
    className="text-4xl tracking-tight font-extrabold text-gray-900 sm:text-5xl md:text-6xl lg:text-5xl xl:text-6xl">
    {React.string(text)}
  </h1>

let bodyText = (~text) =>
  <p className={`max-w-md mx-auto text-lg text-gray-500 sm:text-xl md:max-w-3xl`}>
    {React.string(text)}
  </p>

let button = (~href, ~text, ~colors) =>
  <div className={`rounded-md shadow `}>
    <Next.Link href>
      <a
        className={`${colors} w-full flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-md md:py-4 md:text-lg md:px-10`}>
        {React.string(text)}
      </a>
    </Next.Link>
  </div>

let callToActionArea = (~header, ~body, ~buttonLinks, ~imagePos) => {
  let (lgTextAlign, lgContainerDisplay, lgJustifyButtons) = switch imagePos {
  | #Right => ("lg:text-left", "", "lg:justify-start")
  | #Left => ("lg:text-center", "lg:flex", "lg:justify-center")
  }
  <HeroTextContainer textAlign={`text-center ${lgTextAlign}`} display=lgContainerDisplay>
    {switch imagePos {
    | #Right => <> </>
    | #Left => <div className="lg:w-1/2" />
    }}
    <div className="lg:w-1/2 px-4 sm:px-8 xl:pr-16">
      {heading(header)}
      <div className="mt-3 md:mt-5"> {bodyText(~text=body)} </div>
      {switch buttonLinks {
      | Some(buttonLinks) =>
        <div className={`mt-10 sm:flex sm:justify-center ${lgJustifyButtons}`}>
          {button(
            ~colors=`text-white bg-orangedark hover:bg-orangedarker`,
            ~href=buttonLinks.primaryButton.url,
            ~text=buttonLinks.primaryButton.label,
          )}
          <div className=`mt-3 sm:mt-0 sm:ml-3`>
            {button(
              ~colors=`text-orangedark bg-white hover:bg-gray-50`,
              ~href=buttonLinks.secondaryButton.url,
              ~text=buttonLinks.secondaryButton.label,
            )}
          </div>
        </div>
      | None => <> </>
      }}
    </div>
  </HeroTextContainer>
}

@react.component
let make = (~imageSrc, ~header, ~body, ~buttonLinks=?, ~imagePos, ()) =>
  <SectionContainer.LargeCentered>
    <div className="lg:relative">
      {callToActionArea(~header, ~body, ~buttonLinks, ~imagePos)}
      {image(~src=imageSrc, ~pos=imagePos)}
    </div>
  </SectionContainer.LargeCentered>

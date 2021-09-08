open! Import

module FillIcon = {
  @react.component
  let make = (~id) =>
    <pattern id x="0" y="0" width="20" height="20" patternUnits="userSpaceOnUse">
      <rect x="0" y="0" width="4" height="4" className="text-gray-200" fill="currentColor" />
    </pattern>
}

module FillPattern = {
  @react.component
  let make = (~organizationName, ~position, ~placement, ~transform) =>
    <svg
      className={position ++ ` ` ++ placement ++ ` ` ++ transform}
      width="404"
      height="404"
      fill="none"
      viewBox="0 0 404 404"
      role="img"
      ariaLabelledby="svg-testimonial-org">
      <title id="svg-testimonial-org"> {React.string(organizationName)} </title>
      <defs> <FillIcon id=`ad119f34-7694-4c31-947f-5c9d249b21f3` /> </defs>
      <rect width="404" height="404" fill="url(#ad119f34-7694-4c31-947f-5c9d249b21f3)" />
    </svg>
}

module SlashIcon = {
  @react.component
  let make = (~margins) =>
    <svg
      className={"hidden md:block h-5 w-5 text-orangedark " ++ margins}
      fill="currentColor"
      viewBox="0 0 20 20">
      <path d="M11 0h3L9 20H6l5-20z" />
    </svg>
}

module Quote = {
  @react.component
  let make = (~margins, ~quote, ~speaker, ~organizationName) =>
    <blockquote className=margins>
      <div className="max-w-3xl mx-auto text-center text-2xl leading-9 font-medium text-gray-900">
        <p>
          <span className="text-orangedark"> {React.string(`”`)} </span>
          {React.string(quote)}
          <span className="text-orangedark"> {React.string(`”`)} </span>
        </p>
      </div>
      <footer className="mt-0">
        <div className="md:flex md:items-center md:justify-center">
          <div className="mt-3 text-center md:mt-0 md:ml-4 md:flex md:items-center">
            <div className="text-base font-medium text-gray-900"> {React.string(speaker)} </div>
            <SlashIcon margins=`mx-1` />
            <div className="text-base font-medium text-gray-500">
              {React.string(organizationName)}
            </div>
          </div>
        </div>
      </footer>
    </blockquote>
}

// TODO: move this into general contaienrs?
module TestimonialContainer = {
  @react.component
  let make = (~children) => {
    <section className=`py-12 overflow-hidden md:py-20 lg:py-24`>
      <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8"> children </div>
    </section>
  }
}

type t = {
  quote: string,
  organizationName: string,
  speaker: string,
  organizationLogo: string,
}

@react.component
let make = (~content) =>
  <TestimonialContainer>
    <FillPattern
      organizationName=content.organizationName
      position=`absolute`
      placement=`top-full right-full`
      transform=`transform translate-x-1/3 -translate-y-1/4 lg:translate-x-1/2 xl:-translate-y-1/2`
    />
    <div className="relative">
      <img className="mx-auto h-24" src=content.organizationLogo alt=content.organizationName />
      <Quote
        margins=`mt-10`
        quote=content.quote
        speaker=content.speaker
        organizationName=content.organizationName
      />
    </div>
  </TestimonialContainer>

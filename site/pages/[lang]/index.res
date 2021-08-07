open! Import

let s = React.string

module T = {
  module HeroSection = {
    type t = {
      heroHeader: string,
      heroBody: string,
      installOcaml: string,
      aboutOcaml: string,
    }
  }

  module H2 = {
    @react.component
    let make = (~text) =>
      <h2 className="text-3xl font-extrabold text-gray-900 sm:text-4xl"> {s(text)} </h2>
  }

  module StatBox = {
    @react.component
    let make = (~label, ~statValue, ~borderSizes) =>
      <div className={`flex flex-col border-gray-100 py-16 px-4 text-center ` ++ borderSizes}>
        <dt className="order-2 mt-2 text-lg leading-6 font-bold text-black text-opacity-70">
          {s(label)}
        </dt>
        <dd className="order-1 text-5xl font-extrabold text-orangedark"> {s(statValue)} </dd>
      </div>
  }

  module StatsRowContainer = {
    @react.component
    let make = (~textAlign, ~children) =>
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className={"max-w-4xl mx-auto " ++ textAlign}> children </div>
      </div>
  }

  module StatsSection = {
    type t = {
      statsTitle: string,
      userSatisfaction: string,
      workplaceUse: string,
      easyMaintain: string,
      userSatisfactionPercent: string,
      workplaceUsePercent: string,
      easyMaintainPercent: string,
    }

    @react.component
    let make = (~content) =>
      <div className="pt-12 sm:pt-16">
        <StatsRowContainer textAlign=`text-center`>
          <H2 text=content.statsTitle />
        </StatsRowContainer>
        <div className="mt-10 pb-12 sm:pb-16">
          <StatsRowContainer textAlign=``>
            <dl className="rounded-lg bg-white shadow-lg sm:grid sm:grid-cols-3">
              <StatBox
                label=content.userSatisfaction
                statValue=content.userSatisfactionPercent
                borderSizes=`border-b sm:border-0 sm:border-r`
              />
              <StatBox
                label=content.workplaceUse
                statValue=content.workplaceUsePercent
                borderSizes=`border-t border-b sm:border-0 sm:border-l sm:border-r`
              />
              <StatBox
                label=content.easyMaintain
                statValue=content.easyMaintainPercent
                borderSizes=`border-t sm:border-0 sm:border-l`
              />
            </dl>
          </StatsRowContainer>
        </div>
      </div>
  }

  module OpamSection = {
    type t = {
      header: string,
      body: string,
      linkText: string,
    }

    @react.component
    let make = (~content as {header, body, linkText}) => {
      <MediaObject.Small
        header
        body
        link="https://opam.ocaml.org"
        linkText={linkText ++ ` >`}
        image="/static/opam.png"
      />
    }
  }

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
        <title id="svg-testimonial-org"> {s(organizationName)} </title>
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
            <span className="text-orangedark"> {s(`”`)} </span>
            {s(quote)}
            <span className="text-orangedark"> {s(`”`)} </span>
          </p>
        </div>
        <footer className="mt-0">
          <div className="md:flex md:items-center md:justify-center">
            <div className="mt-3 text-center md:mt-0 md:ml-4 md:flex md:items-center">
              <div className="text-base font-medium text-gray-900"> {s(speaker)} </div>
              <SlashIcon margins=`mx-1` />
              <div className="text-base font-medium text-gray-500"> {s(organizationName)} </div>
            </div>
          </div>
        </footer>
      </blockquote>
  }

  // TODO: move this into general contaienrs?
  module TestimonialContainer = {
    @react.component
    let make = (~marginBottom=?, ~children) =>
      <section
        className={marginBottom->Tailwind.Option.toClassName ++ ` py-12 overflow-hidden md:py-20 lg:py-24 `}>
        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8"> children </div>
      </section>
  }

  module TestimonialSection = {
    type t = {
      quote: string,
      organizationName: string,
      speaker: string,
      organizationLogo: string,
    }

    @react.component
    let make = (~content, ~marginBottom=?) =>
      <TestimonialContainer ?marginBottom>
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
  }

  type t = {
    heroContent: HeroSection.t,
    statsContent: StatsSection.t,
    opamContent: OpamSection.t,
    testimonialContent: TestimonialSection.t,
  }
  include Jsonable.Unsafe

  module Params = Pages.Params.Lang

  @react.component
  let make = (
    ~content as {heroContent, statsContent, opamContent, testimonialContent},
    ~params as {Params.lang: lang},
  ) =>
    <Page.Unstructured>
      <Hero
        imageSrc="/static/oc-sq.jpeg"
        imagePos={#right}
        header=heroContent.heroHeader
        body=heroContent.heroBody
        buttonLinks={
          Hero.primaryButton: {
            label: heroContent.installOcaml,
            url: #resourcesInstallocaml->Route.toString(lang),
          },
          secondaryButton: {
            label: heroContent.aboutOcaml,
            url: #principlesWhatisocaml->Route.toString(lang),
          },
        }
      />
      <StatsSection content=statsContent />
      <OpamSection content=opamContent />
      <TestimonialSection
        content=testimonialContent
        marginBottom={Tailwind.Breakpoint.make(#mb6, ~md=#mb4, ~lg=#mb6, ())}
      />
    </Page.Unstructured>

  let contentEn = {
    heroContent: {
      heroHeader: `Welcome to a World of OCaml`,
      heroBody: `OCaml is a general purpose industrial-strength programming language with an emphasis on expressiveness and 
      safety.`,
      installOcaml: `Install OCaml`,
      aboutOcaml: `About OCaml`,
    },
    statsContent: {
      statsTitle: `OCaml in Numbers`,
      userSatisfaction: `Of users report feeling satisfied with the state of OCaml`,
      workplaceUse: `Report that the use of OCaml is increasing or remaining stable in their workplace`,
      easyMaintain: `Of users report feeling that OCaml software is easy to maintain`,
      userSatisfactionPercent: `85%`,
      workplaceUsePercent: `95%`,
      easyMaintainPercent: `75%`,
    },
    opamContent: {
      OpamSection.header: `Opam: the OCaml Package Manager`,
      body: `Opam is a source-based package manager for OCaml. It supports multiple simultaneous compiler 
      installations, flexible package constraints, and a Git-friendly development workflow.`,
      linkText: `Go to opam.ocaml.org`,
    },
    testimonialContent: {
      quote: `OCaml helps us to quickly adopt to changing market conditions, and go from prototypes to production 
      systems with less effort ... Billions of dollars of transactions flow through our systems every day, so getting 
      it right matters.`,
      organizationName: `Jane Street`,
      speaker: `Yaron Minsky`,
      organizationLogo: `/static/js.svg`,
    },
  }

  let content = [({Params.lang: #en}, contentEn)]
}

include T
include Pages.MakeSimple(T)

open! Import

module T = {
  module HeroSection = {
    type t = {
      heroHeader: string,
      heroBody: string,
      installOcaml: string,
      aboutOcaml: string,
    }
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
      <Stats title=content.statsTitle>
        [
          {
            Stats.Item.label: content.userSatisfaction,
            value: content.userSatisfactionPercent,
          },
          {
            label: content.workplaceUse,
            value: content.workplaceUsePercent,
          },
          {
            label: content.easyMaintain,
            value: content.easyMaintainPercent,
          },
        ]
      </Stats>
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

  type t = {
    heroContent: HeroSection.t,
    statsContent: StatsSection.t,
    opamContent: OpamSection.t,
    testimonialContent: Testimonials.t,
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
        imagePos={#Right}
        header=heroContent.heroHeader
        body=heroContent.heroBody
        buttonLinks={
          Hero.primaryButton: {
            label: heroContent.installOcaml,
            url: #ResourcesInstallocaml->Route.toString(lang),
          },
          secondaryButton: {
            label: heroContent.aboutOcaml,
            url: #PrinciplesWhatisocaml->Route.toString(lang),
          },
        }
      />
      <StatsSection content=statsContent />
      <OpamSection content=opamContent />
      <div className="mb-6 md:mb-4 lg:mb-6"> <Testimonials content=testimonialContent /> </div>
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

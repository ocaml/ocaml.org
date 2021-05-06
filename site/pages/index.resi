module HeroSection: {
  type t = {
    heroHeader: string,
    heroBody: string,
    installOcaml: string,
    aboutOcaml: string,
  }
}

module StatsSection: {
  type t = {
    statsTitle: string,
    userSatisfaction: string,
    workplaceUse: string,
    easyMaintain: string,
    userSatisfactionPercent: string,
    workplaceUsePercent: string,
    easyMaintainPercent: string,
  }
}

module OpamSection: {
  type t = {
    opamHeader: string,
    opamBody: string,
    opamLinkText: string,
  }
}

module TestimonialSection: {
  type t = {
    quote: string,
    organizationName: string,
    speaker: string,
    organizationLogo: string,
  }
}

type t = {
  heroContent: HeroSection.t,
  statsContent: StatsSection.t,
  opamContent: OpamSection.t,
  testimonialContent: TestimonialSection.t,
}

@react.component
let make: (~content: t=?) => React.element

let default: {"content": option<t>} => React.element

open! Import

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
    header: string,
    body: string,
    linkText: string,
  }
}

type t = {
  heroContent: HeroSection.t,
  statsContent: StatsSection.t,
  opamContent: OpamSection.t,
  testimonialContent: Testimonials.t,
}

include Pages.S with type t := t

module LogoSection: {
  type t = {ocamlSummary: string}
}

module MainLinksSection: {
  module Section: {
    type t = {
      header: string,
      entries: array<NavEntry.t>,
    }
  }

  type t = {
    industrySection: Section.t,
    resourcesSection: Section.t,
    communitySection: Section.t,
    legalSection: Section.t,
  }
}

module SponsorsSection: {
  type t = {
    thankSponsorPrefix: string,
    hostingProviders: NavEntry.t,
  }
}

type t = {
  footer: string,
  logoContent: LogoSection.t,
  mainLinksContent: MainLinksSection.t,
  sponsorContent: SponsorsSection.t,
}

@react.component
let make: (~content: t) => React.element

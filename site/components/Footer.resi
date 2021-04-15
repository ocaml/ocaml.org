module LogoSection: {
  type t = {ocamlSummary: string}
}

module MainLinksSection: {
  type industrySection = {
    header: string,
    whatIsOcaml: NavEntry.t,
    industrialUsers: NavEntry.t,
    successStories: NavEntry.t,
  }

  type resourcesSection = {
    header: string,
    releases: NavEntry.t,
    applications: NavEntry.t,
    language: NavEntry.t,
    archive: NavEntry.t,
  }

  type communitySection = {
    header: string,
    opportunities: NavEntry.t,
    news: NavEntry.t,
    aroundTheWeb: NavEntry.t,
  }

  type legalSection = {
    header: string,
    privacy: NavEntry.t,
    terms: NavEntry.t,
    carbonFootprint: NavEntry.t,
  }

  type t = {
    industrySection: industrySection,
    resourcesSection: resourcesSection,
    communitySection: communitySection,
    legalSection: legalSection,
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

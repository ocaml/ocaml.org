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

type navContent = {
  industrySection: industrySection,
  resourcesSection: resourcesSection,
  communitySection: communitySection,
}

let navContentEn = {
  industrySection: {
    header: `Industry`,
    whatIsOcaml: {label: `What is OCaml`, url: `/industry/whatisocaml`},
    industrialUsers: {label: `Industrial Users`, url: `/industry/users`},
    successStories: {label: `Success Stories`, url: `/industry/successstories`},
  },
  resourcesSection: {
    header: `Resources`,
    releases: {label: `Releases`, url: `/resources/releases`},
    applications: {label: `Applications`, url: `/resources/applications`},
    language: {label: `Language`, url: `/resources/language`},
    archive: {label: `Archive`, url: `/resources/archive`},
  },
  communitySection: {
    header: `Community`,
    opportunities: {label: `Opportunities`, url: `/community/opportunities`},
    news: {label: `News`, url: `/community/news`},
    aroundTheWeb: {label: `Around the Web`, url: `/community/aroundweb`},
  },
}

let headerContentEn: HeaderNavigation.content = {
  industrySection: {
    header: navContentEn.industrySection.header,
    whatIsOcaml: navContentEn.industrySection.whatIsOcaml,
    industrialUsers: navContentEn.industrySection.industrialUsers,
    successStories: navContentEn.industrySection.successStories,
  },
  resourcesSection: {
    header: navContentEn.resourcesSection.header,
    releases: navContentEn.resourcesSection.releases,
    applications: navContentEn.resourcesSection.applications,
    language: navContentEn.resourcesSection.language,
    archive: navContentEn.resourcesSection.archive,
  },
  communitySection: {
    header: navContentEn.communitySection.header,
    opportunities: navContentEn.communitySection.opportunities,
    news: navContentEn.communitySection.news,
    aroundTheWeb: navContentEn.communitySection.aroundTheWeb,
  },
  search: `Search`,
  openMenu: `Open menu`,
}

let footerContentEn: Footer.t = {
  footer: `Footer`,
  logoContent: {
    ocamlSummary: `Innovation. Community. Security.`,
  },
  mainLinksContent: {
    industrySection: {
      header: navContentEn.industrySection.header,
      whatIsOcaml: navContentEn.industrySection.whatIsOcaml,
      industrialUsers: navContentEn.industrySection.industrialUsers,
      successStories: navContentEn.industrySection.successStories,
    },
    resourcesSection: {
      header: navContentEn.resourcesSection.header,
      releases: navContentEn.resourcesSection.releases,
      applications: navContentEn.resourcesSection.applications,
      language: navContentEn.resourcesSection.language,
      archive: navContentEn.resourcesSection.archive,
    },
    communitySection: {
      header: navContentEn.communitySection.header,
      opportunities: navContentEn.communitySection.opportunities,
      news: navContentEn.communitySection.news,
      aroundTheWeb: navContentEn.communitySection.aroundTheWeb,
    },
    legalSection: {
      header: `Legal`,
      privacy: {label: `Privacy`, url: `/legal/privacy`},
      terms: {label: `Terms`, url: `/legal/terms`},
      carbonFootprint: {label: `Carbon Footprint`, url: `/legal/carbonfootprint`},
    },
  },
  sponsorContent: {
    thankSponsorPrefix: `Thank you to our`,
    hostingProviders: {label: `Hosting Providers`, url: `/legal/carbonfootprint#hostingproviders`},
  },
}

@react.component
let make = (~children) =>
  <div className="bg-white">
    // TODO: change element to body, move to document.res
    <div className="relative shadow"> <HeaderNavigation content=headerContentEn /> </div>
    <main className="relative bg-graylight pb-1">
      // pb-1 is used to prevent margin-bottom from collapsing on last child
      children
    </main>
    <div className="relative"> <Footer content=footerContentEn /> </div>
  </div>

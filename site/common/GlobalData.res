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
    entries: [
      navContentEn.industrySection.whatIsOcaml,
      navContentEn.industrySection.industrialUsers,
      navContentEn.industrySection.successStories,
    ],
  },
  resourcesSection: {
    header: navContentEn.resourcesSection.header,
    entries: [
      navContentEn.resourcesSection.releases,
      navContentEn.resourcesSection.applications,
      navContentEn.resourcesSection.language,
      navContentEn.resourcesSection.archive,
    ],
  },
  communitySection: {
    header: navContentEn.communitySection.header,
    entries: [
      navContentEn.communitySection.opportunities,
      navContentEn.communitySection.news,
      navContentEn.communitySection.aroundTheWeb,
    ],
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
      entries: [
        navContentEn.industrySection.whatIsOcaml,
        navContentEn.industrySection.industrialUsers,
        navContentEn.industrySection.successStories,
      ],
    },
    resourcesSection: {
      header: navContentEn.resourcesSection.header,
      entries: [
        navContentEn.resourcesSection.releases,
        navContentEn.resourcesSection.applications,
        navContentEn.resourcesSection.language,
        navContentEn.resourcesSection.archive,
      ],
    },
    communitySection: {
      header: navContentEn.communitySection.header,
      entries: [
        navContentEn.communitySection.opportunities,
        navContentEn.communitySection.news,
        navContentEn.communitySection.aroundTheWeb,
      ],
    },
    legalSection: {
      header: `Legal`,
      entries: [
        {label: `Privacy`, url: `/legal/privacy`},
        {label: `Terms`, url: `/legal/terms`},
        {label: `Carbon Footprint`, url: `/legal/carbonfootprint`},
      ],
    },
  },
  sponsorContent: {
    thankSponsorPrefix: `Thank you to our`,
    hostingProviders: {label: `Hosting Providers`, url: `/legal/carbonfootprint#hostingproviders`},
  },
}

let milestonesContentEn: Milestones.t = {
  items: [
    {
      version: Some("v3.1"),
      description: "Select technologies",
      period: "Nov - Jan 2020",
      completion: "100%",
      results: "Selected NextJS as static site generator, ReScript as implementation language, FlowMapp as sitemap tool, Figma for design, Tailwind for CSS.",
    },
    {
      version: Some("v3.2"),
      description: "Implement most important layouts",
      period: "Feb - Apr 2021",
      completion: "100%",
      results: "The 10 most important pages have been designed and implemented.",
    },
    {
      version: None,
      description: "Design information architecture",
      period: "Aug 2020 - Jun 2021",
      completion: "60%",
      results: " Sitemap is complete, 8 user personas and some journeys have been defined.",
    },
    {
      version: Some("v3.3"),
      description: "Implement all 40 distinct layouts",
      period: "Jun 30, 2021",
      completion: "25%",
      results: "A quarter of the 40 distinct pages have been implemented.",
    },
    {
      version: None,
      description: "Port 40 most important pages",
      period: "Aug 2021",
      completion: "10%",
      results: "Some work started.",
    },
    {
      version: Some("v3.4"),
      description: "Implement OCaml Manual",
      period: "Jul - Aug 2021",
      completion: "0%",
      results: "Not started.",
    },
    {
      version: Some("v3.5"),
      description: "Integrate docs.ocaml.org",
      period: "Jul 2021",
      completion: "0%",
      results: "Pending completion of the separate docs.ocaml.org project.",
    },
    {
      version: None,
      description: "Implement multilingual site framework",
      period: "Aug 2021",
      completion: "10%",
      results: "Some work started.",
    },
    {
      version: None,
      description: "Finalize site design",
      period: "Jan - Aug 2021",
      completion: "50%",
      results: "Half of the 40 pages needing a distinct design have been designed.",
    },
    {
      version: Some("v3.6"),
      description: "Go live on ocaml.org, replacing old site",
      period: "Aug 1, 2021",
      completion: "30%",
      results: "One-third of the work has been done.",
    },
  ],
}

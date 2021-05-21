type industrySection = {
  header: string,
  whatIsOcaml: NavEntry.t,
  industrialUsers: NavEntry.t,
  academicExcellence: NavEntry.t,
  successStories: NavEntry.t,
}

type resourcesSection = {
  header: string,
  language: NavEntry.t,
  packages: NavEntry.t,
  applications: NavEntry.t,
  bestPractices: NavEntry.t,
}

type communitySection = {
  header: string,
  opportunities: NavEntry.t,
  news: NavEntry.t,
  aroundTheWeb: NavEntry.t,
  archive: NavEntry.t,
}

type navContent = {
  industrySection: industrySection,
  resourcesSection: resourcesSection,
  communitySection: communitySection,
}

let navContentEn = {
  industrySection: {
    header: `Industry`,
    whatIsOcaml: {
      label: `Why OCaml`,
      url: InternalUrls.industryWhatisocaml,
      icon: Icons.camel,
      text: "Find out about OCaml and how it became what it is today.",
    },
    industrialUsers: {
      label: `Industrial Users`,
      url: InternalUrls.industryUsers,
      icon: Icons.industry,
      text: "Discover the organisations and companies that use OCaml to accomplish their goals.",
    },
    academicExcellence: {
      label: `Academic Excellence`,
      url: InternalUrls.industrySuccessstories /* TODO - point to correct page once it's created */,
      icon: Icons.academic,
      text: "Learn about the universities and academics that use OCaml.",
    },
    successStories: {
      label: `Success Stories`,
      url: InternalUrls.industrySuccessstories,
      icon: Icons.success,
      text: "Read about the great things that have been achieved using OCaml.",
    },
  },
  resourcesSection: {
    header: `Resources`,
    language: {
      label: `Language`,
      url: InternalUrls.resourcesLanguage,
      icon: Icons.language,
      text: "Discover the OCaml tutorial, books and papers on OCaml, as well as the OCaml Manual",
    },
    packages: {
      label: `Packages`,
      url: "http://ci5.ocamllabs.io:8082/" /* TODO - point to correct page once it's created */,
      icon: Icons.packages,
      text: "Browse the many packages available in OCaml.",
    },
    applications: {
      label: `Applications`,
      url: InternalUrls.resourcesApplications,
      icon: Icons.applications,
      text: "Using or building tools and applicatins in OCaml? This page is full of useful information.",
    },
    bestPractices: {
      label: `Best Practices`,
      url: InternalUrls.resourcesBestpractices,
      icon: Icons.bestPractices,
      text: "Some of the best known methods in OCaml are shared here, as well as the Platform Tools.",
    },
  },
  communitySection: {
    header: `Community`,
    opportunities: {
      label: `Opportunities`,
      url: InternalUrls.communityOpportunities,
      icon: Icons.opportunities,
      text: "Explore vacancies in projects and companies and see where you could fit in.",
    },
    news: {
      label: `News`,
      url: InternalUrls.communityNews,
      icon: Icons.news,
      text: "Catch up on the latest news from the OCaml sphere!",
    },
    aroundTheWeb: {
      label: `Around the Web`,
      url: InternalUrls.communityAroundweb,
      icon: Icons.web,
      text: "A bit of everything, this page encapsulates OCaml's presence online, blogposts, videos, and mailing lists all live here.",
    },
    archive: {
      label: `Archive`,
      url: InternalUrls.resourcesArchive,
      icon: Icons.archive,
      text: "Can't find what you're looking for? Try searching the Archive.",
    },
  },
}

let headerContentEn: HeaderNavigation.content = {
  industrySection: {
    header: navContentEn.industrySection.header,
    entries: [
      navContentEn.industrySection.whatIsOcaml,
      navContentEn.industrySection.industrialUsers,
      navContentEn.industrySection.academicExcellence,
      navContentEn.industrySection.successStories,
    ],
  },
  resourcesSection: {
    header: navContentEn.resourcesSection.header,
    entries: [
      navContentEn.resourcesSection.language,
      navContentEn.resourcesSection.packages,
      navContentEn.resourcesSection.applications,
      navContentEn.resourcesSection.bestPractices,
    ],
  },
  communitySection: {
    header: navContentEn.communitySection.header,
    entries: [
      navContentEn.communitySection.opportunities,
      navContentEn.communitySection.news,
      navContentEn.communitySection.aroundTheWeb,
      navContentEn.communitySection.archive,
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
        navContentEn.resourcesSection.language,
        navContentEn.resourcesSection.packages,
        navContentEn.resourcesSection.applications,
        navContentEn.resourcesSection.bestPractices,
      ],
    },
    communitySection: {
      header: navContentEn.communitySection.header,
      entries: [
        navContentEn.communitySection.opportunities,
        navContentEn.communitySection.news,
        navContentEn.communitySection.aroundTheWeb,
        navContentEn.communitySection.archive,
      ],
    },
    legalSection: {
      header: `Legal`,
      entries: [
        {label: `Privacy`, url: InternalUrls.legalPrivacy, icon: Icons.industry, text: ""},
        {label: `Terms`, url: InternalUrls.legalTerms, icon: Icons.industry, text: ""},
        {
          label: `Carbon Footprint`,
          url: InternalUrls.legalCarbonfootprint,
          icon: Icons.industry,
          text: "",
        },
      ],
    },
  },
  sponsorContent: {
    thankSponsorPrefix: `Thank you to our`,
    hostingProviders: {
      label: `Hosting Providers`,
      url: `${InternalUrls.legalCarbonfootprint}#hostingproviders`,
      icon: Icons.industry,
      text: "",
    },
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

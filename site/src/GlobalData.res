type principlesSection = {
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
  principlesSection: principlesSection,
  resourcesSection: resourcesSection,
  communitySection: communitySection,
}

let navContentEn = {
  let url = Route.toString(_, #en)
  {
    principlesSection: {
      header: `Principles`,
      whatIsOcaml: {
        label: `Why OCaml`,
        url: url(#principlesWhatisocaml),
        icon: Icons.camel,
        text: "Find out about OCaml's history and how it became what it is today.",
      },
      industrialUsers: {
        label: `Industrial Users`,
        url: url(#principlesIndustrialUsers),
        icon: Icons.industry,
        text: "Discover the organisations that use OCaml to accomplish their goals.",
      },
      academicExcellence: {
        label: `Academic Excellence`,
        url: url(#principlesAcademic),
        icon: Icons.academic,
        text: "Learn about the academics that research programming language technology.",
      },
      successStories: {
        label: `Success Stories`,
        url: url(#principlesSuccesses),
        icon: Icons.success,
        text: "Read about the things that have been achieved using OCaml.",
      },
    },
    resourcesSection: {
      header: `Resources`,
      language: {
        label: `Language`,
        url: url(#resourcesLanguage),
        icon: Icons.language,
        text: "Read through the OCaml tutorial, official manual and books.",
      },
      packages: {
        label: `Packages`,
        url: "/packages",
        icon: Icons.packages,
        text: "Browse the third-party packages published in the OCaml ecosystem.",
      },
      applications: {
        label: `Applications`,
        url: url(#resourcesApplications),
        icon: Icons.applications,
        text: "Learn techniques for building tools and applications in OCaml.",
      },
      bestPractices: {
        label: `Best Practices`,
        url: url(#resourcesBestpractices),
        icon: Icons.bestPractices,
        text: "Adopt the best known methods for development from the OCaml community.",
      },
    },
    communitySection: {
      header: `Community`,
      opportunities: {
        label: `Opportunities`,
        url: url(#communityOpportunities),
        icon: Icons.opportunities,
        text: "Explore vacancies in projects and companies and see where you could fit in.",
      },
      news: {
        label: `News`,
        url: url(#communityNews),
        icon: Icons.news,
        text: "Catch up on the latest news from the OCaml sphere!",
      },
      aroundTheWeb: {
        label: `Around the Web`,
        url: url(#communityAroundweb),
        icon: Icons.web,
        text: "A bit of everything, this page encapsulates OCaml's presence online, blogposts, videos, and mailing lists all live here.",
      },
      archive: {
        label: `Archive`,
        url: url(#resourcesArchive),
        icon: Icons.archive,
        text: "Can't find what you're looking for? Try searching the Archive.",
      },
    },
  }
}

let headerContentEn: HeaderNavigation.content = {
  principlesSection: {
    header: navContentEn.principlesSection.header,
    entries: [
      navContentEn.principlesSection.whatIsOcaml,
      navContentEn.principlesSection.industrialUsers,
      navContentEn.principlesSection.academicExcellence,
      navContentEn.principlesSection.successStories,
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
  search: `Search ocaml.org`,
  openMenu: `Open menu`,
}

let footerContentEn: Footer.t = {
  let url = Route.toString(_, #en)
  {
    footer: `Footer`,
    logoContent: {
      ocamlSummary: `Innovation. Community. Security.`,
    },
    mainLinksContent: {
      principlesSection: {
        header: navContentEn.principlesSection.header,
        entries: [
          navContentEn.principlesSection.whatIsOcaml,
          navContentEn.principlesSection.industrialUsers,
          navContentEn.principlesSection.academicExcellence,
          navContentEn.principlesSection.successStories,
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
          {
            label: `Privacy`,
            url: url(#legalPrivacy),
            icon: Icons.industry,
            text: "",
          },
          {
            label: `Terms`,
            url: url(#legalTerms),
            icon: Icons.industry,
            text: "",
          },
          {
            label: `Carbon Footprint`,
            url: url(#legalCarbonfootprint),
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
        url: url(#legalCarbonfootprint) ++ `#hostingproviders`,
        icon: Icons.industry,
        text: "",
      },
    },
  }
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

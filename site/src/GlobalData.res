open! Import

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
        url: url(#PrinciplesWhatisocaml),
        icon: Icons.camel,
        text: "Find out about OCaml's history and how it became what it is today.",
      },
      industrialUsers: {
        label: `Industrial Users`,
        url: url(#PrinciplesIndustrialUsers),
        icon: Icons.industry,
        text: "Discover the organisations that use OCaml to accomplish their goals.",
      },
      academicExcellence: {
        label: `Academic Excellence`,
        url: url(#PrinciplesAcademic),
        icon: Icons.academic,
        text: "Learn about the academics that research programming language technology.",
      },
      successStories: {
        label: `Success Stories`,
        url: url(#PrinciplesSuccesses),
        icon: Icons.success,
        text: "Read about the things that have been achieved using OCaml.",
      },
    },
    resourcesSection: {
      header: `Resources`,
      language: {
        label: `Language`,
        url: url(#ResourcesLanguage),
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
        url: url(#ResourcesApplications),
        icon: Icons.applications,
        text: "Learn techniques for building tools and applications in OCaml.",
      },
      bestPractices: {
        label: `Best Practices`,
        url: url(#ResourcesBestpractices),
        icon: Icons.bestPractices,
        text: "Adopt the best known methods for development from the OCaml community.",
      },
    },
    communitySection: {
      header: `Community`,
      opportunities: {
        label: `Opportunities`,
        url: url(#CommunityOpportunities),
        icon: Icons.opportunities,
        text: "Explore vacancies in projects and companies and see where you could fit in.",
      },
      news: {
        label: `News`,
        url: url(#CommunityNews),
        icon: Icons.news,
        text: "Catch up on the latest news from the OCaml sphere!",
      },
      aroundTheWeb: {
        label: `Around the Web`,
        url: url(#CommunityAroundweb),
        icon: Icons.web,
        text: "A bit of everything, this page encapsulates OCaml's presence online, blogposts, videos, and mailing lists all live here.",
      },
      archive: {
        label: `Archive`,
        url: url(#ResourcesArchive),
        icon: Icons.archive,
        text: "Can't find what you're looking for? Try searching the Archive.",
      },
    },
  }
}

let navContent: Lang.t => navContent = lang => {
  switch lang {
  | #en => navContentEn
  | (_: Lang.t) => navContentEn
  }
}

let headerContent: Lang.t => HeaderNavigation.content = lang => {
  let searchEn = `Search ocaml.org`
  let openMenuEn = `Open menu`
  {
    principlesSection: {
      header: navContentEn.principlesSection.header,
      entries: [
        navContent(lang).principlesSection.whatIsOcaml,
        navContent(lang).principlesSection.industrialUsers,
        navContent(lang).principlesSection.academicExcellence,
        navContent(lang).principlesSection.successStories,
      ],
    },
    resourcesSection: {
      header: navContent(lang).resourcesSection.header,
      entries: [
        navContent(lang).resourcesSection.language,
        navContent(lang).resourcesSection.packages,
        navContent(lang).resourcesSection.applications,
        navContent(lang).resourcesSection.bestPractices,
      ],
    },
    communitySection: {
      header: navContent(lang).communitySection.header,
      entries: [
        navContent(lang).communitySection.opportunities,
        navContent(lang).communitySection.news,
        navContent(lang).communitySection.aroundTheWeb,
        navContent(lang).communitySection.archive,
      ],
    },
    search: switch lang {
    | #en => searchEn
    | (_: Lang.t) => searchEn
    },
    openMenu: switch lang {
    | #en => openMenuEn
    | (_: Lang.t) => openMenuEn
    },
  }
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
            url: url(#LegalPrivacy),
            icon: Icons.industry,
            text: "",
          },
          {
            label: `Terms`,
            url: url(#LegalTerms),
            icon: Icons.industry,
            text: "",
          },
          {
            label: `Carbon Footprint`,
            url: url(#LegalCarbonfootprint),
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
        url: url(#LegalCarbonfootprint) ++ `#hostingproviders`,
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
      completion: "100%",
      results: " Sitemap is complete, and some user journeys have been defined.",
    },
    {
      version: Some("v3.3"),
      description: "Implement all 40 distinct layouts in frontend",
      period: "Jun 30, 2021",
      completion: "50%",
      results: "A half of the 40 distinct pages have been implemented, mainly leaf pages left.",
    },
    {
      version: None,
      description: "Port all v2 content to ocaml/ood",
      period: "Aug-Oct 2021",
      completion: "80%",
      results: "Most pages ported from v2, but history and a few others to go.",
    },
    {
      version: None,
      description: "Implement multilingual site framework",
      period: "Aug-Sept 2021",
      completion: "80%",
      results: "Content framework in place, need to expose user choice and port content to ood",
    },
    {
      version: None,
      description: "Integrate OCaml documentation",
      period: "Jul 2021",
      completion: "80%",
      results: "Integrated with packages pages, but styling needs to match main site",
    },
    {
      version: Some("v3.4"),
      description: "Port OCaml Manual to new site design",
      period: "Aug - Sept 2021",
      completion: "0%",
      results: "Not started.",
    },
    {
      version: None,
      description: "Community feedback and consensus",
      period: "Aug - Oct 2021",
      completion: "0%",
      results: "Post on OCaml discussion forums and gather feedback / action changes.",
    },
    {
      version: None,
      description: "Map user pathways to site content",
      period: "July - Oct 2021",
      completion: "20%",
      results: "Integrate Platform pathways (packager, teacher, developer) into site.",
    },
    {
      version: Some("v3.5"),
      description: "Go live on ocaml.org, moving old site to v2",
      period: "Oct 2021",
      completion: "60%",
      results: "Exact time depends on the public feedback.",
    },
  ],
}

let footerContent: Lang.t => Footer.t = lang => {
  switch lang {
  | #en => footerContentEn
  | (_: Lang.t) => footerContentEn
  }
}

let milestonesContent: Lang.t => Milestones.t = lang => {
  switch lang {
  | #en => milestonesContentEn
  | (_: Lang.t) => milestonesContentEn
  }
}

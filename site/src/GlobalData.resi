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

let navContentEn: navContent

let headerContentEn: HeaderNavigation.content

let footerContentEn: Footer.t

let milestonesContentEn: Milestones.t

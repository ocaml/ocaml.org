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

type content = {
  industrySection: industrySection,
  resourcesSection: resourcesSection,
  communitySection: communitySection,
  search: string,
  openMenu: string,
}

@react.component
let make: (~content: content) => React.element

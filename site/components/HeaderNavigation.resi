type section = {
  header: string,
  entries: array<NavEntry.t>,
}

type content = {
  industrySection: section,
  resourcesSection: section,
  communitySection: section,
  search: string,
  openMenu: string,
}

@react.component
let make: (~content: content) => React.element

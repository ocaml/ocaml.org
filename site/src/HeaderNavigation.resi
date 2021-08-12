open! Import

type section = {
  header: string,
  entries: array<NavEntry.t>,
}

type content = {
  principlesSection: section,
  resourcesSection: section,
  communitySection: section,
  search: string,
  openMenu: string,
}

@react.component
let make: (~content: content) => React.element

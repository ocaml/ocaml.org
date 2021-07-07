open! Import

type t = [
  | #index
  | #history
  | #communityAroundweb
  | #communityEvents
  | #communityEventOud2020
  | #communityMediaarchive
  | #communityNews
  | #communityNewsarchive
  | #communityOpportunities
  | #principlesSuccesses
  | #principlesIndustrialUsers
  | #principlesAcademic
  | #principlesWhatisocaml
  | #legalCarbonfootprint
  | #legalPrivacy
  | #legalTerms
  | #resourcesBasics
  | #resourcesInstallocaml
  | #resourcesApplications
  | #resourcesArchive
  | #resourcesBestpractices
  | #resourcesDevelopinginocaml
  | #resourcesLanguage
  | #resourcesPapers
  | #resourcesPapersarchive
  | #resourcesPlatform
  | #resourcesReleases
  | #resourcesUsingocaml
]

let toString: (t, Lang.t) => string

@react.component
let make: (~_to: t, ~lang: Lang.t, ~children: React.element) => React.element

open! Import

type t = [
  | #Index
  | #History
  | #CommunityAroundweb
  | #CommunityEvents
  | #CommunityEventOud2020
  | #CommunityMediaarchive
  | #CommunityNews
  | #CommunityNewsarchive
  | #CommunityOpportunities
  | #PrinciplesSuccesses
  | #PrinciplesIndustrialUsers
  | #PrinciplesAcademic
  | #PrinciplesWhatisocaml
  | #LegalCarbonfootprint
  | #LegalPrivacy
  | #LegalTerms
  | #ResourcesBasics
  | #ResourcesInstallocaml
  | #ResourcesApplications
  | #ResourcesArchive
  | #ResourcesBestpractices
  | #ResourcesDevelopinginocaml
  | #ResourcesLanguage
  | #ResourcesPapers
  | #ResourcesPapersarchive
  | #ResourcesPlatform
  | #ResourcesReleases
  | #ResourcesUsingocaml
  | #ResourcesTutorials
  | #ResourcesTutorial(string)
]

let toString: (t, Lang.t) => string

@react.component
let make: (~_to: t, ~lang: Lang.t, ~children: React.element) => React.element

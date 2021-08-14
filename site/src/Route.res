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

let toString = (t: t, lang) => {
  let lang = Lang.toString(lang)
  let path = switch t {
  | #Index => ""
  | #History => "history"
  | #CommunityAroundweb => "community/aroundweb"
  | #CommunityEvents => "community/events"
  | #CommunityEventOud2020 => "community/event/oud2020"
  | #CommunityMediaarchive => "community/mediaarchive"
  | #CommunityNews => "community/blog"
  | #CommunityNewsarchive => "community/newsarchive"
  | #CommunityOpportunities => "community/opportunities"
  | #PrinciplesSuccesses => "principles/successes"
  | #PrinciplesIndustrialUsers => "principles/users"
  | #PrinciplesAcademic => "principles/academic"
  | #PrinciplesWhatisocaml => "principles/whatisocaml"
  | #LegalCarbonfootprint => "legal/carbonfootprint"
  | #LegalPrivacy => "legal/privacy"
  | #LegalTerms => "legal/terms"
  | #ResourcesBasics => "resources/basics"
  | #ResourcesInstallocaml => "resources/installocaml"
  | #ResourcesApplications => "resources/applications"
  | #ResourcesArchive => "resources/archive"
  | #ResourcesBestpractices => "resources/bestpractices"
  | #ResourcesDevelopinginocaml => "resources/developinginocaml"
  | #ResourcesLanguage => "resources/language"
  | #ResourcesPapers => "resources/papers"
  | #ResourcesPapersarchive => "resources/papersarchive"
  | #ResourcesPlatform => "resources/platform"
  | #ResourcesReleases => "resources/releases"
  | #ResourcesUsingocaml => "resources/usingocaml"
  | #ResourcesTutorials => "resources/tutorials"
  | #ResourcesTutorial(s) => "resources/tutorials/" ++ s
  }
  "/" ++ lang ++ "/" ++ path
}

@react.component
let make = (~_to, ~lang, ~children) => {
  let href = _to->toString(lang)
  <Next.Link href passHref=true> children </Next.Link>
}

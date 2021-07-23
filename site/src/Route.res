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
  | #resourcesTutorials
  | #resourcesTutorial(string)
]

let toString = (t: t, lang) => {
  let lang = Lang.toString(lang)
  let path = switch t {
  | #index => ""
  | #history => "history"
  | #communityAroundweb => "community/aroundweb"
  | #communityEvents => "community/events"
  | #communityEventOud2020 => "community/event/oud2020"
  | #communityMediaarchive => "community/mediaarchive"
  | #communityNews => "community/blog"
  | #communityNewsarchive => "community/newsarchive"
  | #communityOpportunities => "community/opportunities"
  | #principlesSuccesses => "principles/successes"
  | #principlesIndustrialUsers => "principles/users"
  | #principlesAcademic => "principles/academic"
  | #principlesWhatisocaml => "principles/whatisocaml"
  | #legalCarbonfootprint => "legal/carbonfootprint"
  | #legalPrivacy => "legal/privacy"
  | #legalTerms => "legal/terms"
  | #resourcesBasics => "resources/basics"
  | #resourcesInstallocaml => "resources/installocaml"
  | #resourcesApplications => "resources/applications"
  | #resourcesArchive => "resources/archive"
  | #resourcesBestpractices => "resources/bestpractices"
  | #resourcesDevelopinginocaml => "resources/developinginocaml"
  | #resourcesLanguage => "resources/language"
  | #resourcesPapers => "resources/papers"
  | #resourcesPapersarchive => "resources/papersarchive"
  | #resourcesPlatform => "resources/platform"
  | #resourcesReleases => "resources/releases"
  | #resourcesUsingocaml => "resources/usingocaml"
  | #resourcesTutorials => "resources/tutorials"
  | #resourcesTutorial(s) => "resources/" ++ s
  }
  "/" ++ lang ++ "/" ++ path
}

@react.component
let make = (~_to, ~lang, ~children) => {
  let href = _to->toString(lang)
  <Next.Link href passHref=true> children </Next.Link>
}

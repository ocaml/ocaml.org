module Story: {
  type t = string
}

module NewsCategory: {
  type t = {
    header: string,
    seeAllNewsInCategory: string,
    stories: array<Story.t>,
  }
}

module CategorizedNews: {
  type t = {
    otherNewsStories: string,
    communityCategory: NewsCategory.t,
    releasesCategory: NewsCategory.t,
    industryCategory: NewsCategory.t,
    eventsCategory: NewsCategory.t,
    goToNewsArchive: string,
  }
}

module WeeklyNews: {
  type t = {
    ocamlWeeklyNews: string,
    overview: string,
  }
}

type t = {
  title: string,
  pageDescription: string,
  highlightContent: Page.highlightContent,
  categorizedNews: CategorizedNews.t,
  weeklyNews: WeeklyNews.t,
}

@react.component
let make: (~content: t=?) => React.element

let default: {"content": option<t>} => React.element

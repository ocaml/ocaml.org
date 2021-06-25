module NewsCategory: {
  type t = {
    header: string,
    seeAllNewsInCategory: string,
    stories: array<HighlightsInQuadrants.Story.t>,
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

include Pages.S with type t := t

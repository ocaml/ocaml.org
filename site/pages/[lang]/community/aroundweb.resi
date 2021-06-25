module LatestNews: {
  type t = {news: array<Ood.News.t>}
}

module Events: {
  type t = {
    title: string,
    description: string,
    callToAction: string,
    latestEvents: array<Ood.Event.t>,
  }
}

module BlogEntry: {
  type t = {
    title: string,
    excerpt: string,
    author: string,
    dateValue: string,
    date: string,
    readingTime: string,
  }
}

type t = {
  title: string,
  pageDescription: string,
  engageHeader: string,
  engageBody: string,
  engageButtonText: string,
  latestNewsContent: LatestNews.t,
  events: Events.t,
  blogSectionHeader: string,
  blogSectionDescription: string,
  blog: string,
  blogEntries: array<BlogEntry.t>,
  blogArchiveText: string,
  spacesSectionHeader: string,
  spaces: array<string>,
}

include Pages.S with type t := t

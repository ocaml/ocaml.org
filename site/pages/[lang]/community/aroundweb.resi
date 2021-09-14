open! Import

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

module Space: {
  type t = {
    logoSrc: string,
    name: string,
    url: string,
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
  blogEntries: (BlogCard.Entry.t, BlogCard.Entry.t, BlogCard.Entry.t),
  blogArchiveText: string,
  spacesSectionHeader: string,
  spaces: array<Space.t>,
}

include Pages.S with type t := t

open! Import

module Tutorials: {
  type t = {
    title: string,
    description: string,
    tutorials: array<Ood.Tutorial.t>,
  }
}

module Books: {
  type t = {
    booksLabel: string,
    books: array<Ood.Book.t>,
  }
}

module Manual: {
  type item = {
    link: string,
    text: string,
  }

  type t = {
    title: string,
    items: array<item>,
  }
}

module Papers: {
  type t = {
    title: string,
    item1: VerticalHighlightCard.item,
    item2: VerticalHighlightCard.item,
    item3: VerticalHighlightCard.item,
    buttonText: string,
    route: Route.t,
  }
}

type t = {
  title: string,
  pageDescription: string,
  tutorials: Tutorials.t,
  beginning: UserLevelIntroduction.t,
  growing: UserLevelIntroduction.t,
  booksContent: Books.t,
  expanding: UserLevelIntroduction.t,
  diversifying: UserLevelIntroduction.t,
  researching: UserLevelIntroduction.t,
  manual: Manual.t,
  papers: Papers.t,
}

include Pages.S with type t := t

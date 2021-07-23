module UserLevelIntroduction: {
  type t = {
    level: string,
    introduction: string,
  }
}

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
}

include Pages.S with type t := t

open! Import

module MediaSection: {
  module Item: {
    type t = {
      name: string,
      author: string,
      creationDate: string,
      link: string,
    }
  }

  type t = {
    title: string,
    image: string,
    items: array<Item.t>,
  }
}

type t = {
  title: string,
  pageDescription: string,
  videosContent: MediaSection.t,
  talksContent: MediaSection.t,
  papersContent: MediaSection.t,
}

include Pages.S with type t := t

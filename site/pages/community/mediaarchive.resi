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

@react.component
let make: (
  ~title: string,
  ~pageDescription: string,
  ~videosContent: MediaSection.t,
  ~talksContent: MediaSection.t,
  ~papersContent: MediaSection.t,
) => React.element

type prop = {
  title: string,
  pageDescription: string,
  videosContent: MediaSection.t,
  talksContent: MediaSection.t,
  papersContent: MediaSection.t,
}

let getStaticProps: Next.GetStaticProps.t<prop, unit, unit>

let default: {
  "title": string,
  "pageDescription": string,
  "videosContent": MediaSection.t,
  "talksContent": MediaSection.t,
  "papersContent": MediaSection.t,
} => React.element

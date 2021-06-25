@react.component
let make: (
  ~source: string,
  ~title: string,
  ~pageDescription: Js.Nullable.t<string>,
  ~tableOfContents: string,
) => React.element

type props = {
  source: string,
  title: string,
  pageDescription: string,
  tableOfContents: string,
}

module Params: {
  type t = {tutorial: string}
}

let getStaticProps: Next.GetStaticProps.t<props, Params.t, unit>

let getStaticPaths: Next.GetStaticPaths.t<Params.t>

let default: {
  "source": string,
  "title": string,
  "pageDescription": Js.Nullable.t<string>,
  "tableOfContents": string,
} => React.element

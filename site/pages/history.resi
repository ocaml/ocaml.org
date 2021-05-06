module Timeline: {
  module Item: {
    type t = {date: string, description: string}
  }
}

type pageContent = {
  title: string,
  pageDescription: string,
  timeline: array<Timeline.Item.t>,
}

@react.component
let make: (~content: pageContent) => React.element

type props = {content: pageContent}

let getStaticProps: Next.GetStaticProps.t<props, unit, unit>

let default: {"content": pageContent} => React.element

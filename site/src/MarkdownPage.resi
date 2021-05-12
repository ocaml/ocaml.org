module MarkdownPageBody: {
  @react.component
  let make: (~margins: string, ~renderedMarkdown: string) => React.element
}

module TableOfContents: {
  type t = {
    contents: string,
    toc: Unified.MarkdownTableOfContents.t,
  }

  @react.component
  let make: (~content: t) => React.element
}

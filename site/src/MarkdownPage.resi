open! Import

module Body: {
  @react.component
  let make: (~renderedMarkdown: string) => React.element
}

module TOC: {
  @react.component
  let make: (~renderedMarkdown: string) => React.element
}

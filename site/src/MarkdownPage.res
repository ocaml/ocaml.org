open! Import

module Body = {
  @react.component
  let make = (~margins, ~renderedMarkdown) =>
    <div
      className={margins ++ ` prose prose-yellow prose-lg text-gray-500 mx-auto`}
      dangerouslySetInnerHTML={{"__html": renderedMarkdown}}
    />
}

module TOC = {
  @react.component
  let make = (~renderedMarkdown) =>
    <nav className="toc" dangerouslySetInnerHTML={{"__html": renderedMarkdown}} />
}

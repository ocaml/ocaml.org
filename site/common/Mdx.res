module Components = {
  type props = {"children": ReasonReact.reactElement}

  // Used for reflection based logic in
  // components such as `code` or `ul`
  // with runtime reflection
  type unknown

  @deriving(abstract)
  type t = {
    /* Common markdown elements */
    @optional
    p: React.component<props>,
    @optional
    li: React.component<props>,
    @optional
    h1: React.component<props>,
    @optional
    h2: React.component<props>,
    @optional
    h3: React.component<props>,
    @optional
    h4: React.component<props>,
    @optional
    h5: React.component<props>,
    @optional
    ul: React.component<props>,
    @optional
    ol: React.component<props>,
    @optional
    table: React.component<props>,
    @optional
    thead: React.component<props>,
    @optional
    th: React.component<props>,
    @optional
    td: React.component<props>,
    @optional
    blockquote: React.component<props>,
    @optional
    inlineCode: React.component<props>,
    @optional
    strong: React.component<props>,
    @optional
    hr: React.component<{.}>,
    @optional
    code: React.component<{
      "className": option<string>,
      "metastring": option<string>,
      "children": unknown,
    }>,
    @optional
    pre: React.component<props>,
    @optional
    a: React.component<{
      "children": ReasonReact.reactElement,
      "href": string,
    }>,
  }
}

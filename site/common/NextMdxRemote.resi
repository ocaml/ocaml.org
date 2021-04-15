@deriving(abstract)
type renderToStringParams = {@optional components: Mdx.Components.t}

type renderToStringResult = {
  compiledSource: string,
  renderedOutput: string,
}

let renderToString: ('source, renderToStringParams) => Js.Promise.t<renderToStringResult>

@deriving(abstract)
type hydrateParams = {@optional components: Mdx.Components.t}

let hydrate: (renderToStringResult, hydrateParams) => ReasonReact.reactElement

@deriving(abstract)
type renderToStringParams = {
  @optional components: Mdx.Components.t,
  // TODO: optional mdxOptions and optional scope
}

type renderToStringResult = {
  compiledSource: string,
  renderedOutput: string,
  //TODO: optional "scope"
}

@module("next-mdx-remote/render-to-string")
external renderToString: ('source, renderToStringParams) => Js.Promise.t<renderToStringResult> =
  "default"

@deriving(abstract)
type hydrateParams = {@optional components: Mdx.Components.t}

@module("next-mdx-remote/hydrate")
external hydrate: (renderToStringResult, hydrateParams) => ReasonReact.reactElement = "default"

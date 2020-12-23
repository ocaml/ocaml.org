@bs.deriving(abstract)
type renderToStringParams = {
    @bs.optional components: Mdx.Components.t,
    // TODO: optional mdxOptions and optional scope
}

type renderToStringResult = {
    compiledSource: string,
    renderedOutput: string,
    //TODO: optional "scope"
}

@bs.module("next-mdx-remote/render-to-string") 
    external renderToString: ('source, renderToStringParams) => Js.Promise.t<renderToStringResult> =
        "default";

@bs.deriving(abstract)
type hydrateParams = {
    @bs.optional components: Mdx.Components.t,
}

@bs.module("next-mdx-remote/hydrate") 
    external hydrate: (renderToStringResult, hydrateParams) => ReasonReact.reactElement =
        "default";

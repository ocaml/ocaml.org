open! Import

module GetStaticProps = {
  // See: https://github.com/zeit/next.js/blob/canary/packages/next/types/index.d.ts
  type context<'props, 'params, 'previewData> = {
    params: 'params,
    preview: option<bool>, // preview is true if the page is in the preview mode and undefined otherwise.
    previewData: Js.t<'previewData>,
    query: Js.Dict.t<string>,
    req: Js.Nullable.t<Js.t<'props>>,
  }

  type t<'props, 'params, 'previewData> = context<'props, 'params, 'previewData> => Js.Promise.t<{
    "props": Js.Json.t,
  }>
}

module GetStaticPaths = {
  // 'params: dynamic route params used in dynamic routing paths
  // Example: pages/[id].js would result in a 'params = { id: string }
  type path<'params> = {params: 'params}

  type return<'params> = {
    paths: array<path<'params>>,
    fallback: bool,
  }

  type t<'params> = unit => Js.Promise.t<return<'params>>
}

module Link = {
  @module("next/link") @react.component
  external make: (
    ~href: string=?,
    ~_as: string=?,
    ~prefetch: bool=?,
    ~replace: option<bool>=?,
    ~shallow: option<bool>=?,
    ~passHref: option<bool>=?,
    ~children: React.element,
  ) => React.element = "default"
}

module Error = {
  @module("next/error") @react.component
  external make: (~statusCode: int) => React.element = "default"
}

module Router = {
  /*
      Make sure to only register events via a useEffect hook!
 */
  module Events = {
    type t

    @send
    external on: (
      t,
      @string
      [
        | #routeChangeStart(string => unit)
        | #routeChangeComplete(string => unit)
        | #hashChangeComplete(string => unit)
      ],
    ) => unit = "on"

    @send
    external off: (
      t,
      @string
      [
        | #routeChangeStart(string => unit)
        | #routeChangeComplete(string => unit)
        | #hashChangeComplete(string => unit)
      ],
    ) => unit = "off"
  }

  type router = {
    route: string,
    asPath: string,
    events: Events.t,
    query: Js.Dict.t<string>,
  }

  @send external push: (router, string) => unit = "push"

  @module("next/router") external useRouter: unit => router = "useRouter"
  @send external replace: (router, string) => unit = "replace"
}

module Head = {
  @module("next/head") @react.component
  external make: (~children: React.element) => React.element = "default"
}

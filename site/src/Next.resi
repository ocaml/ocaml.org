module GetStaticProps: {
  type context<'props, 'params, 'previewData> = {
    params: 'params,
    preview: option<bool>,
    previewData: Js.t<'previewData>,
    query: Js.Dict.t<string>,
    req: Js.Nullable.t<Js.t<'props>>,
  }

  type t<'props, 'params, 'previewData> = context<'props, 'params, 'previewData> => Js.Promise.t<{
    "props": 'props,
  }>
}

module GetStaticPaths: {
  type path<'params> = {params: 'params}

  type return<'params> = {
    paths: array<path<'params>>,
    fallback: bool,
  }

  type t<'params> = unit => Js.Promise.t<return<'params>>
}

module Link: {
  @react.component
  let make: (
    ~href: string=?,
    ~_as: string=?,
    ~prefetch: bool=?,
    ~replace: option<bool>=?,
    ~shallow: option<bool>=?,
    ~passHref: option<bool>=?,
    ~children: React.element,
  ) => React.element
}

module Router: {
  module Events: {
    type t

    let on: (
      t,
      @string
      [
        | #routeChangeStart(string => unit)
        | #routeChangeComplete(string => unit)
        | #hashChangeComplete(string => unit)
      ],
    ) => unit

    let off: (
      t,
      @string
      [
        | #routeChangeStart(string => unit)
        | #routeChangeComplete(string => unit)
        | #hashChangeComplete(string => unit)
      ],
    ) => unit
  }

  type router = {
    route: string,
    asPath: string,
    events: Events.t,
    query: Js.Dict.t<string>,
  }

  let push: (router, string) => unit

  let useRouter: unit => router
  let replace: (router, string) => unit
}

module Head: {
  @react.component
  let make: (~children: React.element) => React.element
}

module Error: {
  @react.component
  let make: (~statusCode: int, ~children: React.element) => React.element
}

module Dynamic: {
  type options = {
    ssr: bool,
    loading: unit => React.element,
  }

  let dynamic: (unit => Js.Promise.t<'a>, options) => 'a

  let \"import": string => Js.Promise.t<'a>
}

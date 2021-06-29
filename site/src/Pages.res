open! Import

module Params = {
  // An exceedingly simple json object parser
  module P: {
    type t<'a>

    let return: 'a => t<'a>
    let map: (t<'a>, 'a => 'b) => t<'b>
    let ap: (t<'a => 'b>, t<'a>) => t<'b>
    let field: (string, Js.Json.t => option<'a>) => t<'a>
    let parse: (t<'a>, Js.Json.t) => option<'a>
  } = {
    type t<'a> = Js.Dict.t<Js.Json.t> => option<'a>

    let return = (x: 'a): t<'a> => _ => Some(x)

    let map = (ta: t<'a>, f: 'a => 'b): t<'b> => dict => ta(dict)->Belt.Option.map(f)

    let ap = (tf: t<'a => 'b>, ta: t<'a>): t<'b> =>
      dict => {
        switch (tf(dict), ta(dict)) {
        | (Some(f), Some(a)) => Some(f(a))
        | (_, _) => None
        }
      }

    let field = (name: string, f: Js.Json.t => option<'a>): t<'a> =>
      dict => dict->Js.Dict.get(name)->Belt.Option.flatMap(f)

    let parse = (t: t<'a>, json): option<'a> => json->Js.Json.decodeObject->Belt.Option.flatMap(t)
  }

  module type S = {
    type t
    include Jsonable.S with type t := t
  }

  let lang = P.field("lang", Lang.ofJson)
  let tutorial = P.field("tutorial", Js.Json.decodeString)

  module Lang = {
    type t = {lang: Lang.t}
    let make = lang => {lang: lang}

    let ofJson = (json: Js.Json.t): option<t> => P.return(make)->P.ap(lang)->P.parse(json)
    let toJson = ({lang}: t): Js.Json.t =>
      Js.Json.object_(Js.Dict.fromArray([("lang", lang->Lang.toJson)]))

    module Tutorial = {
      type t = {lang: Lang.t, tutorial: string}
      let make = (lang, tutorial) => {lang: lang, tutorial: tutorial}

      let ofJson = (json: Js.Json.t): option<t> =>
        P.return(make)->P.ap(lang)->P.ap(tutorial)->P.parse(json)
      let toJson = ({lang, tutorial}: t): Js.Json.t =>
        Js.Json.object_(
          Js.Dict.fromArray([("lang", lang->Lang.toJson), ("tutorial", tutorial->Js.Json.string)]),
        )
    }
  }
}

module type S = {
  type t
  type props<'content, 'params>
  type params

  @react.component
  let make: (~content: t, ~params: params) => React.element
  let getStaticProps: Next.GetStaticProps.t<props<t, params>, params, void>
  let getStaticPaths: Next.GetStaticPaths.t<params>
  let default: props<Js.Json.t, Js.Json.t> => React.element
}

module type ArgBase = {
  type t
  include Jsonable.S with type t := t

  module Params: Params.S

  @react.component
  let make: (~content: t, ~params: Params.t) => React.element
}

module type Arg = {
  include ArgBase
  let getContent: Params.t => Js.Promise.t<option<t>>
  let getParams: unit => Js.Promise.t<array<Params.t>>
}

module type ArgSimple = {
  include ArgBase
  let content: array<(Params.t, t)>
}

module Make = (Arg: Arg): (S with type t := Arg.t and type params = Arg.Params.t) => {
  module Props = {
    type t<'content, 'params> = {content: 'content, params: 'params}
    let toJson = (
      t: t<'content, 'params>,
      contentToJson: 'content => Js.Json.t,
      paramsToJson: 'params => Js.Json.t,
    ): Js.Json.t =>
      [("content", contentToJson(t.content)), ("params", paramsToJson(t.params))]
      ->Js.Dict.fromArray
      ->Js.Json.object_
  }

  type props<'a, 'b> = Props.t<'a, 'b>
  type params = Arg.Params.t

  let getStaticProps: Next.GetStaticProps.t<props<Arg.t, params>, params, void> = ctx => {
    Arg.getContent(ctx.params) |> Js.Promise.then_(content => {
      switch content {
      | None =>
        failwith(
          "BUG: No content found for params: " ++ ctx.params->Arg.Params.toJson->Js.Json.stringify,
        )
      | Some(content) =>
        let props = {Props.content: content, params: ctx.params}
        Js.Promise.resolve({
          "props": props->Props.toJson(Arg.toJson, Arg.Params.toJson),
        })
      }
    })
  }

  let default = (props: props<Js.Json.t, Js.Json.t>) => {
    switch Arg.ofJson(props.content) {
    | None => failwith("BUG: Unable to parse content")
    | Some(content: Arg.t) =>
      switch Arg.Params.ofJson(props.params) {
      | None => failwith("BUG: Unable to parse params")
      | Some(params: Arg.Params.t) => Arg.make(Arg.makeProps(~content, ~params, ()))
      }
    }
  }

  let getStaticPaths: Next.GetStaticPaths.t<Arg.Params.t> = () => {
    let params = Arg.getParams()
    params |> Js.Promise.then_(params =>
      Js.Promise.resolve({
        Next.GetStaticPaths.paths: params->Belt.Array.map(params => {
          Next.GetStaticPaths.params: params,
        }),
        fallback: false,
      })
    )
  }

  include Arg
}

module MakeSimple = (Arg: ArgSimple): (
  S with type t := Arg.t and type params = Arg.Params.t
) => Make({
  include Arg

  let getParams = () =>
    Js.Promise.resolve(content->Belt.Array.mapU((. (params, _content)) => params))

  let getContent = (params: Params.t) =>
    Js.Promise.resolve(
      content
      ->Belt.Array.getByU((. (key, _content)) => key == params)
      ->Belt.Option.map(((_key, content)) => content),
    )
})

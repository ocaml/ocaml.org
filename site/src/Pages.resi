open! Import

module Params: {
  module type S = Jsonable.S

  module Lang: {
    type t = {lang: Lang.t}
    include S with type t := t

    module Slug: {
      let name: string
    } =>
    {
      type t = {lang: Lang.t, slug: string}
      include S with type t := t
    }
  }
}

module type S = {
  type t
  type props<'content, 'params>
  type params
  type json1<'a> = Js.Json.t

  @react.component
  let make: (~content: t, ~params: params) => React.element

  let getStaticProps: Next.GetStaticProps.t<props<t, params>, json1<params>, void>
  let getStaticPaths: Next.GetStaticPaths.t<json1<params>>
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

module Make: (Arg: Arg) => (S with type t := Arg.t and type params = Arg.Params.t)
module MakeSimple: (Arg: ArgSimple) => (S with type t := Arg.t and type params = Arg.Params.t)

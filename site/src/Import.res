type void

module Jsonable = {
  module type S1 = {
    type t<'a>
    let toJson: t<'a> => Js.Json.t
    let ofJson: Js.Json.t => option<t<'a>>
  }

  module type S = {
    type t
    include S1 with type t<'a> := t
  }

  module Unsafe: S1 with type t<'a> := 'a = {
    external toJson: 'a => Js.Json.t = "%identity"
    let toJson = t => {
      // Unfortunately, NextJS cannot serialise `undefined` which is what `None` is converted too.
      // This really only leaves one solution because our types are defined in ood, we have to do
      // some manual stripping of the undefined types when passing it to getStaticProps. This approach
      // is detailed here https://dev.to/ryyppy/rescript-records-nextjs-undefined-and-getstaticprops-4890
      t->toJson->Js.Json.stringify->Js.Json.parseExn
    }
    external ofJson: Js.Json.t => 'a = "%identity"
    let ofJson = x => Some(ofJson(x))
  }
}

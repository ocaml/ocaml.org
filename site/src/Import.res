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
    external assumeJsonable: 'a => Js.Json.t = "%identity"
    let toJson = (t: 'a) => {
      // Unsafely assume that [t] is a value in Javascript that
      // can be serialized to JSON.
      let jsonable = assumeJsonable(t)
      // The "JSONable" subset of Javascript is a superset of JSON,
      // and many JSONable values can map to the same JSON value,
      // for example:
      //   | JSONable             | JSON   | string
      //   |----------------------|--------|-------------
      //   | {a: 1, b: undefined} | {a: 1} | "{\"a\": 1}"
      //   | {a: 1, c: undefined} | {a: 1} | "{\"a\": 1}"
      //
      // We want to convert our JSONable value into a JSON value.
      // Afaict, Javascript doesn't let us do this directly, but
      // we can take a roundabout path by calling JSON.stringify()
      // and then reparsing the result.
      jsonable->Js.Json.stringify->Js.Json.parseExn
    }

    external ofJson: Js.Json.t => 'a = "%identity"
    let ofJson = x => {
      // Unsafely assume the Javascript value is of type 'a without
      // parsing. Since there is no actual parsing/validation involved,
      // this call always succeeds.
      Some(ofJson(x))
    }
  }
}

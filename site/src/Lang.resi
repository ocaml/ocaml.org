open! Import

type t = [#en | #fr | #es]

let name: (~lang: t=?, t) => string
let ofString: string => option<t>
let ofStringExn: string => t
let toString: t => string
let ofJson: Js.Json.t => option<t>
let toJson: t => Js.Json.t

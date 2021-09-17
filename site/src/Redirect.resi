open! Import

type t = {
  title: string,
  linkTextLeft: option<string>,
  linkText: string,
  linkTextRight: option<string>,
}

let contentEn: t
let content: Lang.t => option<t>

@react.component
let make: (~path: string, ~content: t) => React.element

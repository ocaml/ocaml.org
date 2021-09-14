open! Import

type t = {
  level: string,
  introduction: string,
}

@react.component
let make: (~content: t) => React.element

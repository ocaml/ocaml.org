type t = {
  title: string,
  pageDescription: string,
}

@react.component
let make: (~content: t=?) => React.element

let default: {"content": option<t>} => React.element

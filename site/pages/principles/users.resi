type company = {
  logo: string,
  name: string,
  customWidth: option<string>,
  needsRounding: bool,
  website: string,
}

type t = {
  title: string,
  pageDescription: string,
  companies: array<company>,
}

@react.component
let make: (~content: t=?) => React.element

let default: {"content": option<t>} => React.element

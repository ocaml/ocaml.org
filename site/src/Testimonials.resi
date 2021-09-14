open! Import

type t = {
  quote: string,
  organizationName: string,
  speaker: string,
  organizationLogo: string,
}

@react.component
let make: (~content: t) => React.element

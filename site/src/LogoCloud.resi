open! Import

module CompanyOptionalLogo: {
  type t = {
    logoSrc: option<string>,
    name: string,
    website: string,
  }
}

module Company: {
  type t = {
    logoSrc: string,
    name: string,
    website: string,
  }
}

type t = [
  | #LogoOnly(array<Company.t>)
  | #LogoWithText(array<CompanyOptionalLogo.t>)
]

@react.component
let make: (~companies: t) => React.element

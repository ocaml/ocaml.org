module Company: {
  type t = {
    logoSrc: string,
    name: string,
  }
}

@react.component
let make: (~companies: array<Company.t>) => React.element

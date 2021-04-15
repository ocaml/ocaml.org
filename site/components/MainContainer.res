module None = {
  @react.component
  let make = (~children) => children
}

module Centered = {
  @react.component
  let make = (~children) => <div className="max-w-7xl mx-auto"> children </div>
}

module NarrowCentered = {
  @react.component
  let make = (~children) => <div className="max-w-3xl mx-auto"> children </div>
}

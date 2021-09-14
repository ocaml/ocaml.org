open! Import

module Simple: {
  type t = {
    headers: array<string>,
    data: array<array<React.element>>,
  }

  @react.component
  let make: (~content: t) => React.element
}

module Regular: {
  type columnSpec<'map> = {
    title: string,
    component: 'map => React.element,
    className: string,
  }

  @react.component
  let make: (~rows: array<'map>, ~children: array<columnSpec<'map>>) => React.element
}

module CornerTitleLogo: {
  @react.component
  let make: (~title: string, ~graphicUrl: string, ~body: string) => React.element
}

module CornerLogoCenterTitle: {
  @react.component
  let make: (
    ~title: string,
    ~graphicUrl: string,
    ~body: string,
    ~buttonText: string=?,
    unit,
  ) => React.element
}

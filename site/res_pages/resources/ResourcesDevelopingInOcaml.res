let s = React.string

type t = {
  title: string,
  pageDescription: string,
}

let contentEn = {
  title: `Developing in OCaml`,
  pageDescription: `Workflows for application developers and library authors.`,
}

@react.component
let make = (~content=contentEn) => <>
  <ConstructionBanner />
  <TitleHeading title=content.title pageDescription=content.pageDescription />
</>

let default = make

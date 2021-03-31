let s = React.string

type t = {
  title: string,
  pageDescription: string,
}

let contentEn = {
  title: `Platform`,
  pageDescription: `The OCaml Platform represents the best way for developers, both new and old, to write software in OCaml.`,
}

@react.component
let make = (~content=contentEn) => <>
  <ConstructionBanner />
  <TitleHeading.Large title=content.title pageDescription=content.pageDescription />
</>

let default = make

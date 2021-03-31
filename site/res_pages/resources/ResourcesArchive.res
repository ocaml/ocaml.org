let s = React.string

type t = {
  title: string,
  pageDescription: string,
}

let contentEn = {
  title: `Archive`,
  pageDescription: ``,
}

@react.component
let make = (~content=contentEn) => <>
  <ConstructionBanner />
  <TitleHeading.Large title=content.title pageDescription=content.pageDescription />
</>

let default = make

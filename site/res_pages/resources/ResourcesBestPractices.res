let s = React.string

type t = {
  title: string,
  pageDescription: string,
}

let contentEn = {
  title: `Best Practices`,
  pageDescription: `Some guides to commonly used tools in OCaml development workflows.`,
}

@react.component
let make = (~content=contentEn) => <>
  <ConstructionBanner />
  <MainContainer.None>
    <TitleHeading.Large title=content.title pageDescription=content.pageDescription />
  </MainContainer.None>
</>

let default = make

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
  <MainContainer.Centered>
    <TitleHeading.Large title=content.title pageDescription=content.pageDescription />
  </MainContainer.Centered>
</>

let default = make

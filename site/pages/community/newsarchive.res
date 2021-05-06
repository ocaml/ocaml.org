type t = {
  title: string,
  pageDescription: string,
}

let contentEn = {
  title: `News Archive`,
  pageDescription: `Archive of news presented in the News page.`,
}

@react.component
let make = (~content=contentEn) => <>
  <ConstructionBanner />
  <Page.Basic title=content.title pageDescription=content.pageDescription> {<> </>} </Page.Basic>
</>

let default = make

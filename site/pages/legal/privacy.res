let s = React.string

type t = {
  title: string,
  pageDescription: string,
}

let contentEn = {
  title: `Privacy Policy`,
  pageDescription: ``,
}

@react.component
let make = (~content=contentEn) => <>
  <ConstructionBanner />
  <Page.Basic title=content.title pageDescription=content.pageDescription> {<> </>} </Page.Basic>
</>

let default = make

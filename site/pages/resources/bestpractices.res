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
  <Page.Basic
    marginTop=`mt-1`
    headingMarginBottom=`mb-24`
    addBottomBar=true
    addContainer=Page.Basic.NoContainer
    title=content.title
    pageDescription=content.pageDescription>
    {<> </>}
  </Page.Basic>
</>

let default = make

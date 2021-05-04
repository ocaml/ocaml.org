let s = React.string

type t = {
  title: string,
  pageDescription: string,
}

let contentEn = {
  title: `Using OCaml`,
  pageDescription: `Besides developing in the language and making your own applications, there are many useful tools that already exist in OCaml for you to use.`,
}

@react.component
let make = (~content=contentEn) => <>
  <ConstructionBanner />
  <Page.Basic title=content.title pageDescription=content.pageDescription> {<> </>} </Page.Basic>
</>

let default = make

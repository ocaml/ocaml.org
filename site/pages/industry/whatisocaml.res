let s = React.string

type t = {
  title: string,
  pageDescription: string,
}

let contentEn = {
  title: `What is OCaml`,
  pageDescription: `A description of OCaml's features.`,
}

@react.component
let make = (~content=contentEn) => <>
  <ConstructionBanner />
  <Page.TopImage title=content.title pageDescription=content.pageDescription>
    {<> </>}
  </Page.TopImage>
</>

let default = make

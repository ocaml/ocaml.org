type t = {
  title: string,
  pageDescription: string,
}

let contentEn = {
  title: `Papers Archive`,
  pageDescription: `A selection of OCaml papers through the ages. Filter by the tags or do a search over all of the text.`,
}

@react.component
let make = (~content=contentEn) => <>
  <ConstructionBanner playgroundLink=`/play/resources/paperarchive` />
  <Page.Basic title=content.title pageDescription=content.pageDescription> {<> </>} </Page.Basic>
</>

let default = make

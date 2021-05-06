type t = {
  title: string,
  pageDescription: string,
}

let contentEn = {
  title: `Carbon Footprint`,
  pageDescription: `Over the years, the OCaml community has become more and more proactive when it comes to reducing its environmental impact. As part of this journey we have documented our efforts towards becoming Carbon Zero.`,
}

@react.component
let make = (~content=contentEn) => <>
  <ConstructionBanner
    figmaLink=`https://www.figma.com/file/36JnfpPe1Qoc8PaJq8mGMd/V1-Pages-Next-Step?node-id=931%3A6483`
  />
  <Page.TopImage title=content.title pageDescription=content.pageDescription>
    {<> </>}
  </Page.TopImage>
</>

let default = make

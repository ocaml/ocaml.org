let s = React.string

type t = {
  title: string,
  pageDescription: string,
}

let contentEn = {
  title: `Install OCaml`,
  pageDescription: ``,
}

@react.component
let make = (~content=contentEn) => <>
  <ConstructionBanner
    figmaLink=`https://www.figma.com/file/36JnfpPe1Qoc8PaJq8mGMd/V1-Pages-Next-Step?node-id=430%3A21054`
    playgroundLink=`/play/resources/installocaml`
  />
  <TitleHeading title=content.title pageDescription=content.pageDescription />
</>

let default = make

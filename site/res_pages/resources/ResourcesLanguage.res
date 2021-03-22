let s = React.string

type t = {
  title: string,
  pageDescription: string,
}

let contentEn = {
  title: `Language`,
  pageDescription: ``,
}

@react.component
let make = (~content=contentEn) => <>
  <ConstructionBanner
    figmaLink=`https://www.figma.com/file/36JnfpPe1Qoc8PaJq8mGMd/V1-Pages-Next-Step?node-id=1085%3A121`
    playgroundLink=`/play/resources/language`
  />
  <TitleHeading title=content.title pageDescription=content.pageDescription />
</>

let default = make

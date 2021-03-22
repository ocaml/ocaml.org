let s = React.string

type t = {
  title: string,
  pageDescription: string,
}

let contentEn = {
  title: `News`,
  pageDescription: ``,
}

@react.component
let make = (~content=contentEn) => <>
  <ConstructionBanner
    figmaLink=`https://www.figma.com/file/36JnfpPe1Qoc8PaJq8mGMd/V1-Pages-Next-Step?node-id=952%3A422`
    playgroundLink=`/play/community/news`
  />
  <TitleHeading title=content.title pageDescription=content.pageDescription />
</>

let default = make

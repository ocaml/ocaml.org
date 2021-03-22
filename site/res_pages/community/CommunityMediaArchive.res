let s = React.string

type t = {
  title: string,
  pageDescription: string,
}

let contentEn = {
  title: `Media Archive`,
  pageDescription: `This is where you can find archived videos, slides from talks, and other media produced by people in the OCaml Community.`,
}

@react.component
let make = (~content=contentEn) => <>
  <ConstructionBanner
    figmaLink=`https://www.figma.com/file/36JnfpPe1Qoc8PaJq8mGMd/V1-Pages-Next-Step?node-id=430%3A25378`
    playgroundLink=`/play/resources/mediaarchive`
  />
  <TitleHeading title=content.title pageDescription=content.pageDescription />
</>

let default = make

let s = React.string

type t = {
  title: string,
  pageDescription: string,
}

let contentEn = {
  title: `Applications`,
  pageDescription: `This is where you can find resources for working with the language itself. Whether you're building applications or maintaining libraries, this page has useful information for you.`,
}

@react.component
let make = (~content=contentEn) => <>
  <ConstructionBanner
    figmaLink=`https://www.figma.com/file/36JnfpPe1Qoc8PaJq8mGMd/V1-Pages-Next-Step?node-id=745%3A1`
    playgroundLink=`/play/resources/applications`
  />
  <TitleHeading.LandingTitleHeading title=content.title pageDescription=content.pageDescription />
</>

let default = make

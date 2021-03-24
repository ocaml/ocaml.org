let s = React.string

type t = {
  title: string,
  pageDescription: string,
}

let contentEn = {
  title: `Language`,
  pageDescription: `This is the home of learning and tutorials. Whether you're a beginner, a teacher, or a seasoned researcher, this is where you can find the resources you need to accomplish your goals in OCaml.`,
}

@react.component
let make = (~content=contentEn) => <>
  <ConstructionBanner
    figmaLink=`https://www.figma.com/file/36JnfpPe1Qoc8PaJq8mGMd/V1-Pages-Next-Step?node-id=1085%3A121`
    playgroundLink=`/play/resources/language`
  />
  <TitleHeading.LandingTitleHeading title=content.title pageDescription=content.pageDescription />
</>

let default = make

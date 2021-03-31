let s = React.string

type t = {
  title: string,
  pageDescription: string,
}

let contentEn = {
  title: `Events`,
  pageDescription: `Several events take place in the OCaml community over the course of each year, in countries all over the world. This calendar will help you stay up to date on what is coming up in the OCaml sphere.`,
}

@react.component
let make = (~content=contentEn) => <>
  <ConstructionBanner
    figmaLink=`https://www.figma.com/file/36JnfpPe1Qoc8PaJq8mGMd/V1-Pages-Next-Step?node-id=1176%3A0`
  />
  <TitleHeading.Large title=content.title pageDescription=content.pageDescription />
</>

let default = make

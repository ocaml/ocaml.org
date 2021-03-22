let s = React.string

type t = {
  title: string,
  pageDescription: string,
}

let contentEn = {
  title: `Milestones`,
  pageDescription: ``,
}

@react.component
let make = (~content=contentEn) => <>
  <ConstructionBanner
    figmaLink=`https://www.figma.com/file/Vha4bcBvNVrjyLmAEDgZ1x/History-Timeline?node-id=14%3A5`
  />
  <TitleHeading title=content.title pageDescription=content.pageDescription />
</>

let default = make

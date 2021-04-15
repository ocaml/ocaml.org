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
  <MainContainer.None>
    <TitleHeading.Large title=content.title pageDescription=content.pageDescription />
  </MainContainer.None>
</>

let default = make

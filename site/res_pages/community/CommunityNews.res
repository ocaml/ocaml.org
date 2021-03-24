let s = React.string

type t = {
  title: string,
  pageDescription: string,
}

let contentEn = {
  title: `OCaml News`,
  pageDescription: `This is where you'll find the latest stories from the OCaml Community! Periodically, we will also highlight individual stories that `,
}

@react.component
let make = (~content=contentEn) => <>
  <ConstructionBanner
    figmaLink=`https://www.figma.com/file/36JnfpPe1Qoc8PaJq8mGMd/V1-Pages-Next-Step?node-id=952%3A422`
    playgroundLink=`/play/community/news`
  />
  <div className="relative pt-16 pb-6 lg:pb-9 overflow-hidden">
    <div className="relative px-4 sm:px-6 lg:px-8">
      // TODO: use this component from shared area, as noted in generalize header issue
      <IndustryUsers.MarkdownPageTitleHeading2
        title=content.title pageDescription=content.pageDescription descriptionCentered=true
      />
    </div>
  </div>
</>

let default = make

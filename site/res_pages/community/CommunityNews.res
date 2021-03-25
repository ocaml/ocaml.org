let s = React.string
type highlightedStorySummary = {
  preview: string,
  url: string,
}

type highlightedContent = {
  highlightedStory: string,
  clickToRead: string,
  highlightedStorySummary: highlightedStorySummary,
}

type t = {
  title: string,
  pageDescription: string,
  highlightedContent: highlightedContent,
}

let contentEn = {
  title: `OCaml News`,
  pageDescription: `This is where you'll find the latest stories from the OCaml Community! Periodically, we will also highlight individual stories that `,
  highlightedContent: {
    highlightedStory: `Highlighted Story`,
    clickToRead: `Click to Read`,
    highlightedStorySummary: {
      preview: `Isabelle Leandersson interviewed speakers at the 2020 OCaml workshop at ICFP. Click through to read about what they had to say.`,
      url: `/community/isabelle-leandersson-interviewed-speakers`,
    },
  },
}

module HighlightedStory = {
  @react.component
  let make = (~margins, ~content) =>
    <div
      className={"bg-news-bg bg-auto bg-center bg-no-repeat flex align-bottom place-content-center " ++
      margins}>
      <div className="bg-white overflow-hidden shadow rounded-lg mb-2 lg:mb-7 mt-56 mx-5 max-w-4xl">
        <div className="px-4 py-5 sm:p-6">
          <h2 className="font-bold text-orangedark text-3xl lg:text-4xl text-center mb-2">
            {s(content.highlightedStory)}
          </h2>
          <p className="text-xl"> {s(content.highlightedStorySummary.preview)} </p>
          <p className="text-xl text-center lg:text-right">
            // TODO: more descriptive link text (or use aria attribute) for accessibility
            <a href=content.highlightedStorySummary.url className="underline text-orangedark">
              {s(content.clickToRead ++ ` >`)}
            </a>
          </p>
        </div>
      </div>
    </div>
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
  <HighlightedStory margins=`mb-6` content=content.highlightedContent />
</>

let default = make

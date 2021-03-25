let s = React.string

type t = {
  title: string,
  pageDescription: string,
}

let contentEn = {
  title: `Applications`,
  pageDescription: `This is where you can find resources for working with the language itself. Whether you're building applications or maintaining libraries, this page has useful information for you.`,
}

module ApiDocumentation = {
  @react.component
  let make = (~margins) =>
    <div className={"sm:flex px-32 items-center mx-auto max-w-5xl " ++ margins}>
      <div className="mb-4 sm:mb-0 sm:mr-4">
        <h4 className="text-4xl font-bold mb-8"> {s(`API Documentation`)} </h4>
        <p className="mt-1 mb-8">
          {s(`Visit our page for API Documentation in OCaml for a concise reference manual with all the information you need to work with the OCaml API.`)}
        </p>
        <a
          href="#"
          className="inline-flex items-center px-14 py-2 border border-transparent text-sm leading-4 font-medium rounded-md shadow-sm text-white bg-orangedark hover:bg-yellow-800">
          {s(`Visit Docs.ocaml.org`)}
        </a>
      </div>
      <div className="flex-shrink-0"> <img className="h-56" src="/static/api-img.jpeg" /> </div>
    </div>
}

@react.component
let make = (~content=contentEn) => <>
  <ConstructionBanner
    figmaLink=`https://www.figma.com/file/36JnfpPe1Qoc8PaJq8mGMd/V1-Pages-Next-Step?node-id=745%3A1`
    playgroundLink=`/play/resources/applications`
  />
  <TitleHeading.LandingTitleHeading title=content.title pageDescription=content.pageDescription />
  <ApiDocumentation margins=`mb-24` />
</>

let default = make

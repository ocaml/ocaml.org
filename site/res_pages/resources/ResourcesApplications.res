module Link = Next.Link

let s = React.string

module ApiDocumentation = {
  @react.component
  let make = (~margins) =>
    // TODO: factor out and define content type
    <div className={"sm:flex px-32 items-center mx-auto max-w-5xl " ++ margins}>
      <div className="mb-4 sm:mb-0 sm:mr-4">
        <h4 className="text-4xl font-bold mb-8"> {s(`API Documentation`)} </h4>
        <p className="mt-1 mb-8">
          {s(`Visit our page for API Documentation in OCaml for a concise reference manual with all the information you need to work with the OCaml API.`)}
        </p>
        //TODO: add visual indicator that link is opening new tab
        <a
          href="https://docs.mirage.io/"
          target="_blank"
          className="inline-flex items-center px-14 py-2 border border-transparent text-sm leading-4 font-medium rounded-md shadow-sm text-white bg-orangedark hover:bg-orangedarker">
          {s(`Visit Docs.ocaml.org`)}
        </a>
      </div>
      <div className="flex-shrink-0"> <img className="h-56" src="/static/api-img.jpeg" /> </div>
    </div>
}

module DeveloperGuides = {
  @react.component
  let make = (~margins) =>
    <div className={"bg-white overflow-hidden shadow rounded-lg mx-auto max-w-3xl " ++ margins}>
      <div className="px-4 py-5 sm:p-6">
        // TODO: factor out and define content type
        <h2 className="text-center text-orangedark text-4xl font-bold mb-8">
          {s(`Developer Guides`)}
        </h2>
        <div className="flex mb-11">
          <div>
            <h4 className="text-base font-bold mb-3">
              // TODO: visual indicator that link is opening new tab
              <a
                className="hover:underline"
                href="https://docs.mirage.io/mirage/index.html"
                target="_blank">
                {s(`Mirage OS`)}
              </a>
            </h4>
            <p className="mt-1">
              {s(`Mirage OS Unikernels lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer at tristique odio. Etiam sodales porta lectus ac malesuada. Proin in odio ultricies, faucibus ligula ut`)}
            </p>
          </div>
          <div className="ml-7 flex-shrink-0">
            <img className="h-32" src="/static/app-image.png" />
          </div>
        </div>
        <div className="flex mb-11">
          <div className="mr-10 flex-shrink-0">
            <img className="h-24" src="/static/jvs.png" />
          </div>
          <div>
            <h4 className="text-base font-bold mb-3">
              // TODO: visual indicator that link is opening new tab
              <a
                className="hover:underline"
                href="https://b0-system.github.io/odig/doc/js_of_ocaml/Js_of_ocaml/index.html"
                target="_blank">
                {s(`JS_of_OCaml`)}
              </a>
            </h4>
            <p className="mt-1">
              {s(`Browser programming dolor sit amet, consectetur adipiscing elit. Integer at tristique odio. Etiam sodales porta lectus ac maleuada. Proin in odio ultricies, faucibus ligula ut`)}
            </p>
          </div>
        </div>
      </div>
    </div>
}

module PlatformTools = {
  @react.component
  let make = () =>
    <div className="max-w-3xl mx-auto py-16 px-4 sm:py-20 sm:px-6 lg:px-2">
      // TODO: factor out and define content type
      <h2 className="text-3xl font-bold sm:text-3xl text-center"> {s(`Platform Tools`)} </h2>
      <p className="mt-4 text-lg leading-6">
        {s(`The OCaml Platform is a collection of tools that allow programmers to be productive in the OCaml language. It has been an iterative process of refinement as new tools are added and older tools are updated. Different tools accomplish different workflows and are used at different points of a project's life.`)}
      </p>
      <div className="flex justify-center">
        <Link href="/resources/platform">
          <a
            className="mt-8 w-full inline-flex items-center justify-center px-8 py-1 border border-transparent text-white text-base font-medium rounded-md bg-orangedark hover:bg-orangedarker sm:w-auto">
            {s(`Visit Platform Tools`)}
          </a>
        </Link>
      </div>
    </div>
}

module UsingOcaml = {
  @react.component
  let make = (~margins) =>
    // TODO: factor out and define content type
    <div className={"bg-white overflow-hidden shadow rounded-lg mx-auto max-w-3xl " ++ margins}>
      <div className="px-4 py-5 sm:py-8 sm:px-24">
        <h2 className="text-center text-orangedark text-4xl font-bold mb-8">
          {s(`Using OCaml`)}
        </h2>
        <p className="text-center mb-6">
          {s(`Besides developing in the language and making your own applications, there are many useful tools that already exist in OCaml for you to use.`)}
        </p>
        <div className="grid grid-cols-3 gap-x-16 mb-6">
          <div className="flex justify-center items-center mb-6">
            // TODO: visual indicator that link opens new tab
            <a href="https://github.com/bcpierce00/unison/wiki/Downloading-Unison" target="_blank">
              <img className="border-1 h-10" src="/static/unison2.png" alt="Unison Install Guide" />
            </a>
          </div>
          <div className="flex justify-center items-center mb-6">
            <a href="https://coq.inria.fr/download" target="_blank">
              <img className="border-1 h-24" src="/static/coq.png" alt="Coq Intall Guide" />
            </a>
          </div>
          <div className="flex justify-center items-center mb-6">
            <a href="https://www.liquidsoap.info/doc-1.4.4/install.html" target="_blank">
              <img
                className="border-1 h-20" src="/static/liq.png" alt="Liquid Soap Install Guide"
              />
            </a>
          </div>
          <div>
            <p className="font-bold text-center mb-2"> {s(`Unison`)} </p>
            <p> {s(`Dolor sit amet, consectetur adipiscing elit. Integer at tristique odio.`)} </p>
          </div>
          <div>
            <p className="font-bold text-center mb-2"> {s(`Coq`)} </p>
            <p> {s(`Dolor sit amet, consectetur adipiscing elit. Integer at tristique odio.`)} </p>
          </div>
          <div>
            <p className="font-bold text-center mb-2"> {s(`Liquidsoap`)} </p>
            <p> {s(`Dolor sit amet, consectetur adipiscing elit. Integer at tristique odio.`)} </p>
          </div>
        </div>
        <p className="text-right font-bold">
          <Link href="/resources/usingocaml">
            <a className="text-orangedark underline"> {s(`See more >`)} </a>
          </Link>
        </p>
      </div>
    </div>
}

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
  <TitleHeading.LandingTitleHeading
    title=content.title
    pageDescription=content.pageDescription
    marginTop=`mt-1`
    marginBottom=`mb-24`
  />
  <ApiDocumentation margins=`mb-24` />
  <DeveloperGuides margins=`mb-2` />
  <PlatformTools />
  <UsingOcaml margins=`mb-16` />
</>

let default = make

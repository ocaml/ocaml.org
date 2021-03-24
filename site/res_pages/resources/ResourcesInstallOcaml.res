let s = React.string

type t = {
  title: string,
  pageDescription: string,
}

let contentEn = {
  title: `Get Started with OCaml`,
  pageDescription: `This page will help you install OCaml, the Dune build system, and support for your favourite text editor or IDE. These instructions work on Windows, Unix systems like Linux, and macOS.`,
}

module MarkdownPageTitleHeading = {
  @react.component
  let make = (~title, ~pageDescription) =>
    <div className="text-lg max-w-prose mx-auto">
      <h1>
        <span
          className="mt-2 block text-3xl text-center leading-8 font-extrabold tracking-tight text-gray-900 sm:text-4xl">
          {s(title)}
        </span>
      </h1>
      <p className="mt-8 text-xl text-gray-500 leading-8"> {s(pageDescription)} </p>
    </div>
}

module MarkdownPageBody = {
  @react.component
  let make = (~margins, ~children) =>
    <div className={margins ++ ` prose prose-yellow prose-lg text-gray-500 mx-auto`}>
      children
    </div>
}

type props = {
  source: NextMdxRemote.renderToStringResult,
  title: string,
  pageDescription: string,
}

@react.component
let make = (~source, ~title, ~pageDescription) => {
  let body = NextMdxRemote.hydrate(source, NextMdxRemote.hydrateParams())
  <>
    <ConstructionBanner
      figmaLink=`https://www.figma.com/file/36JnfpPe1Qoc8PaJq8mGMd/V1-Pages-Next-Step?node-id=430%3A21054`
      playgroundLink=`/play/resources/installocaml`
    />
    <div className="grid grid-cols-9">
      <div className="hidden lg:flex lg:col-span-2 " />
      <div className="col-span-9 lg:col-span-7 relative py-16 bg-graylight overflow-hidden">
        <div className="relative px-4 sm:px-6 lg:px-8">
          <MarkdownPageTitleHeading title pageDescription />
          <MarkdownPageBody margins=`mt-6`> body </MarkdownPageBody>
        </div>
      </div>
    </div>
  </>
}

let getStaticProps = _ctx => {
  let contentFilePath = "res_pages/resources/installocaml.md"
  let source = Fs.readFileSync(contentFilePath)
  let mdSourcePromise = NextMdxRemote.renderToString(source, NextMdxRemote.renderToStringParams())
  mdSourcePromise->Js.Promise.then_(mdSource => {
    let props = {
      source: mdSource,
      title: contentEn.title,
      pageDescription: contentEn.pageDescription,
    }
    Js.Promise.resolve({"props": props})
  }, _)
}

let default = make

let s = React.string

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

module TableOfContents = {
  // TODO: define general heading tree type and recursively traverse when rendering
  type subHeading = {
    subName: string,
    subHeadingId: string,
  }

  type heading = {
    name: string,
    headingId: string,
    subHeadings: array<subHeading>,
  }

  type t = {
    contents: string,
    headings: array<heading>,
  }

  @react.component
  let make = (~content) =>
    <div
      className="hidden lg:sticky lg:self-start lg:top-2 lg:flex lg:flex-col lg:col-span-2 border-r border-gray-200 pt-5 pb-4 overflow-y-auto">
      <div className="px-4"> <span className="text-lg"> {s(content.contents)} </span> </div>
      <div className="mt-5 ">
        <nav className="px-2 space-y-1" ariaLabel="Sidebar">
          {content.headings
          |> Js.Array.mapi((hdg, idx) =>
            <div key={Js.Int.toString(idx)} className="space-y-1">
              // Expanded: "text-gray-400 rotate-90", Collapsed: "text-gray-300"
              <a
                href={"#" ++ hdg.headingId}
                className="block text-gray-600 hover:text-gray-900 pr-2 py-2 text-sm font-medium">
                {s(hdg.name)}
              </a>
              {hdg.subHeadings
              |> Js.Array.mapi((sub, idx) =>
                <a
                  href={"#" ++ sub.subHeadingId}
                  className="block pl-6 pr-2 py-2 text-sm font-medium text-gray-600 hover:text-gray-900"
                  key={Js.Int.toString(idx)}>
                  {s(sub.subName)}
                </a>
              )
              |> React.array}
            </div>
          )
          |> React.array}
        </nav>
      </div>
    </div>
}

type t = {
  title: string,
  pageDescription: string,
  tableOfContents: TableOfContents.t,
}

let contentEn = {
  title: `Get Started with OCaml`,
  pageDescription: `This page will help you install OCaml, the Dune build system, and support for your favourite text editor or IDE. These instructions work on Windows, Unix systems like Linux, and macOS.`,
  tableOfContents: {
    contents: `Contents`,
    headings: [
      {
        name: "Installing OCaml",
        headingId: "installing-ocaml",
        subHeadings: [
          {
            subName: "For Linux and macOS",
            subHeadingId: "for-linux-and-macos",
          },
          {
            subName: "For Windows",
            subHeadingId: "for-windows",
          },
        ],
      },
      {
        name: "The OCaml top level",
        headingId: "the-ocaml-top-level",
        subHeadings: [],
      },
      {
        name: "Installing the Dune build system",
        headingId: "installing-the-dune-build-system",
        subHeadings: [],
      },
      {
        name: "A first project",
        headingId: "a-first-project",
        subHeadings: [],
      },
      {
        name: "Editor support for OCaml",
        headingId: "editor-support-for-ocaml",
        subHeadings: [],
      },
    ],
  },
}

type props = {
  source: NextMdxRemote.renderToStringResult,
  title: string,
  pageDescription: string,
  tableOfContents: TableOfContents.t,
}

@react.component
let make = (~source, ~title, ~pageDescription, ~tableOfContents) => {
  let body = NextMdxRemote.hydrate(source, NextMdxRemote.hydrateParams())
  <>
    <ConstructionBanner
      figmaLink=`https://www.figma.com/file/36JnfpPe1Qoc8PaJq8mGMd/V1-Pages-Next-Step?node-id=430%3A21054`
      playgroundLink=`/play/resources/installocaml`
    />
    <div className="grid grid-cols-9 bg-white">
      <TableOfContents content=tableOfContents />
      <div className="col-span-9 lg:col-span-7 bg-graylight relative py-16 overflow-hidden">
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
      tableOfContents: contentEn.tableOfContents,
    }
    Js.Promise.resolve({"props": props})
  }, _)
}

let default = make

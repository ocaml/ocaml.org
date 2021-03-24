module Link = Next.Link

let s = React.string

type t = {
  title: string,
  pageDescription: string,
}

let contentEn = {
  title: `Industrial Users of OCaml`,
  pageDescription: `OCaml is a popular choice for companies who make use of its features in key aspects of their technologies. Some companies that use OCaml code are listed below:`,
}

type callToAction = {
  label: string,
  url: string,
}

// TODO: as part of generalizing, consolidate this with installocaml version
module MarkdownPageTitleHeading2 = {
  @react.component
  let make = (~title, ~pageDescription, ~descriptionCentered=false, ~callToAction=?) =>
    <div className="text-lg max-w-prose mx-auto">
      <h1>
        // TODO: pass in mt-2 as a paramater
        <span
          className="mt-2 block text-3xl text-center leading-8 font-extrabold tracking-tight text-gray-900 sm:text-4xl">
          {s(title)}
        </span>
      </h1>
      <p
        className={"mt-8 text-xl text-gray-500 leading-8" ++
        switch descriptionCentered {
        | true => " text-center "
        | false => ""
        }}>
        {s(pageDescription)}
      </p>
      {switch callToAction {
      | Some(callToAction) =>
        <div className="text-center mt-7">
          <Link href=callToAction.url>
            <a
              className="justify-center inline-flex items-center px-4 py-2 border border-transparent text-base font-medium rounded-md shadow-sm text-white bg-yellow-600 hover:bg-yellow-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
              {s(callToAction.label)}
            </a>
          </Link>
        </div>
      | None => <> </>
      }}
    </div>
}

@react.component
let make = (~content=contentEn) => <>
  <ConstructionBanner
    figmaLink=`https://www.figma.com/file/36JnfpPe1Qoc8PaJq8mGMd/V1-Pages-Next-Step?node-id=430%3A36400`
    playgroundLink=`/play/industry/users`
  />
  <div className="relative py-16 overflow-hidden">
    <div className="relative px-4 sm:px-6 lg:px-8">
      <MarkdownPageTitleHeading2
        title=content.title
        pageDescription=content.pageDescription
        descriptionCentered=true
        callToAction={label: "Success Stories", url: "/industry/successstories"}
      />
    </div>
  </div>
</>

let default = make

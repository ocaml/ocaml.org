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
  let make = (~title, ~pageDescription, ~margins=``, ~descriptionCentered=false, ~callToAction=?) =>
    // TODO: remove default value for margins, fix compiler error
    <div className="text-lg max-w-prose mx-auto">
      <h1
        className={margins ++ " block text-3xl text-center leading-8 font-extrabold tracking-tight text-gray-900 sm:text-4xl"}>
        {s(title)}
      </h1>
      <p
        className={"mt-8 text-xl text-gray-500 leading-8 " ++
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
              className="justify-center inline-flex items-center px-4 py-2 border border-transparent text-base font-medium rounded-md shadow-sm text-white bg-orangedark hover:bg-orangedarker focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-orangedarker">
              {s(callToAction.label)}
            </a>
          </Link>
        </div>
      | None => <> </>
      }}
    </div>
}

type company = {
  logo: string,
  name: string,
  customWidth: option<string>,
  needsRounding: bool,
  companyWebsite: string,
}

let companies = [
  {
    logo: `/static/oclabs.png`,
    name: `OCaml Labs`,
    customWidth: None,
    needsRounding: false,
    companyWebsite: `https://ocamllabs.io`,
  },
  {
    logo: `/static/trd.png`,
    name: `Tarides`,
    customWidth: Some(`w-40`),
    needsRounding: false,
    companyWebsite: `https://tarides.com`,
  },
  {
    logo: `/static/slv2.png`,
    name: `Solvuu`,
    customWidth: None,
    needsRounding: true,
    companyWebsite: `https://solvuu.com/`,
  },
  {
    logo: `/static/js2.jpeg`,
    name: `Jane Street`,
    customWidth: None,
    needsRounding: true,
    companyWebsite: `https://janestreet.com`,
  },
  {
    logo: `/static/lxf.png`,
    name: `LexiFi`,
    customWidth: None,
    needsRounding: false,
    companyWebsite: `https://lexifi.com`,
  },
  {
    logo: `/static/tz.png`,
    name: `Tezos`,
    customWidth: Some(`w-24`),
    needsRounding: false,
    companyWebsite: `https://tezos.com`,
  },
]

module LogoSection = {
  @react.component
  let make = (~margins, ~companies) =>
    <div className={margins ++ " mx-auto sm:max-w-screen-sm lg:max-w-screen-lg"}>
      <div className="flex flex-wrap justify-center lg:justify-between ">
        {companies
        |> Js.Array.mapi((c, idx) =>
          <div key={Js.Int.toString(idx)} className="p-12 flex flex-col items-center">
            <img
              className={switch c.customWidth {
              | Some(width) => width
              | None => ` w-32 `
              } ++
              switch c.needsRounding {
              | true => ` rounded-full `
              | false => ``
              } ++ " mb-9"}
              src=c.logo
              alt=""
            />
            <p className="text-4xl underline font-bold">
              // TODO: accessibility - warn opening a new tab
              <a href=c.companyWebsite target="_blank"> {s(c.name)} </a>
            </p>
          </div>
        )
        |> React.array}
      </div>
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
        margins=`mt-2`
        descriptionCentered=true
        callToAction={
          label: "Success Stories",
          url: "/industry/successstories",
        }
      />
      <LogoSection margins=`mt-6` companies />
    </div>
  </div>
</>

let default = make

module Link = Next.Link

let s = React.string

module Large = {
  type callToAction = {
    label: string,
    url: string,
  }

  @react.component
  let make = (
    ~title,
    ~pageDescription,
    ~marginTop="",
    ~marginBottom="",
    ~addBottomBar=false,
    ~callToAction=?,
    (),
  ) => <>
    // TODO: make addBottomBar and callToAction mutually exclusive
    <div className="max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8">
      <div className="text-center">
        <h1
          className={marginTop ++ " text-4xl font-extrabold text-gray-900 sm:text-5xl sm:tracking-tight lg:text-6xl"}>
          {s(title)}
        </h1>
        <p className="max-w-xl mt-5 mx-auto text-xl text-gray-500"> {s(pageDescription)} </p>
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
    </div>
    {switch addBottomBar {
    | true => <hr className={"bg-orangedark h-3 " ++ marginBottom} />
    | false => React.null
    }}
  </>
}

module MarkdownMedium = {
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

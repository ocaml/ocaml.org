open! Import

module T = {
  type t = {
    title: string,
    pageDescription: string,
    papers: array<Ood.Paper.t>,
  }
  include Jsonable.Unsafe

  module Params = Pages.Params.Lang

  @react.component
  let make = (~content, ~params as {Params.lang: _}) => <>
    <ConstructionBanner playgroundLink=`/play/resources/paperarchive` />
    <Page.Basic title=content.title pageDescription=content.pageDescription>
      <div>
        <div className="container pt-6 px-4 max-w-7xl mx-auto">
          <div className="p-0">
            <input
              id="search"
              type_="search"
              className="w-3/5 md:w-2/5 text-xs sm:text-base shadow rounded border-0 p-3"
              placeholder="Search papers..."
            />
            <button
              className="rounded-r bg-yellow-200 text-xs sm:text-base p-3 w-1/5 md:w-1/6"
              type_="submit">
              {React.string("Search")}
            </button>
          </div>
        </div>
      </div>
      <Table.Regular rows=content.papers>
        {[
          {
            title: "Title",
            component: (paper: Ood.Paper.t) => {
              let link =
                Array.of_list(paper.links)->Belt.Array.get(0)->Js.Option.getWithDefault("", _)
              <a className="border-b-2 border-yellow-300" href=link>
                {React.string(paper.title)}
              </a>
            },
            className: "py-4 px-3",
          },
          {
            title: "Authors",
            component: (paper: Ood.Paper.t) => {
              <div className="flex flex-wrap">
                {List.map(
                  author =>
                    <div className="bg-red-200 whitespace-nowrap p-1 m-1 rounded">
                      {React.string(author)}
                    </div>,
                  paper.authors,
                )
                |> Array.of_list
                |> React.array}
              </div>
            },
            className: "py-3 px-3",
          },
          {
            title: "Year",
            component: (paper: Ood.Paper.t) => {
              React.string(string_of_int(paper.year))
            },
            className: "py-3 px-3",
          },
          {
            title: "Tags",
            component: (paper: Ood.Paper.t) => {
              <div className="flex flex-wrap">
                {List.map(
                  tag =>
                    <div className="bg-green-200 whitespace-nowrap p-1 m-1 rounded">
                      {React.string(tag)}
                    </div>,
                  paper.tags,
                )
                |> Array.of_list
                |> React.array}
              </div>
            },
            className: "py-3 px-3",
          },
          {
            title: "Description",
            component: (paper: Ood.Paper.t) => {
              React.string(paper.abstract)
            },
            className: "py-3 px-3",
          },
        ]}
      </Table.Regular>
    </Page.Basic>
  </>

  let contentEn = {
    let papers = Ood.Paper.all->Belt.List.toArray
    {
      title: `Papers Archive`,
      pageDescription: `A selection of OCaml papers through the ages. Filter by the tags or do a search over all of the text.`,
      papers: papers,
    }
  }

  let content = [({Params.lang: #en}, contentEn)]
}

include T
include Pages.MakeSimple(T)

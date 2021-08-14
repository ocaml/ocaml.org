open! Import

module T = {
  type t = {
    source: string,
    title: string,
    pageDescription: string,
    tableOfContents: string,
  }
  include Jsonable.Unsafe

  module Params = Pages.Params.Lang.Tutorial

  @react.component
  let make = (
    ~content as {source, title, pageDescription, tableOfContents},
    ~params as {Params.lang: _, tutorial: _},
  ) => {
    <>
      // TODO: should this have a constrained width? what does tailwind do?
      <Page.Unstructured>
        <div className="grid grid-cols-9 bg-white">
          <MarkdownPage.TOC renderedMarkdown=tableOfContents />
          <div className="col-span-9 lg:col-span-7 bg-graylight relative py-16 overflow-hidden">
            <div className="relative px-4 sm:px-6 lg:px-8">
              <TitleHeading.MarkdownMedium title pageDescription={Some(pageDescription)} />
              <MarkdownPage.Body margins=`mt-6` renderedMarkdown=source />
            </div>
          </div>
        </div>
      </Page.Unstructured>
    </>
  }

  let content =
    Ood.Tutorial.all
    ->Belt.List.toArray
    ->Belt.Array.map((
      {Ood.Tutorial.slug: slug, body_html, title, description, toc_html}: Ood.Tutorial.t,
    ) => {
      (
        {Params.lang: #en, tutorial: slug},
        {
          source: body_html,
          title: title,
          pageDescription: description,
          tableOfContents: toc_html,
        },
      )
    })
}

include T
include Pages.MakeSimple(T)

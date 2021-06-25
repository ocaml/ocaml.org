module Params = {
  type t = {tutorial: string}
}

type props = {
  source: string,
  title: string,
  pageDescription: string,
  tableOfContents: string,
}

@react.component
let make = (~source, ~title, ~pageDescription, ~tableOfContents) => {
  <>
    // TODO: should this have a constrained width? what does tailwind do?
    <Page.Unstructured>
      <div className="grid grid-cols-9 bg-white">
        <MarkdownPage.TOC renderedMarkdown=tableOfContents />
        <div className="col-span-9 lg:col-span-7 bg-graylight relative py-16 overflow-hidden">
          <div className="relative px-4 sm:px-6 lg:px-8">
            <TitleHeading.MarkdownMedium
              title pageDescription={Js.Nullable.toOption(pageDescription)}
            />
            <MarkdownPage.Body margins=`mt-6` renderedMarkdown=source />
          </div>
        </div>
      </div>
    </Page.Unstructured>
  </>
}

let getStaticProps = ctx => {
  let {Params.tutorial: tutorial} = ctx.Next.GetStaticProps.params

  // TODO(tmattio): Get tutorial by slug
  let tutorial = Ood.Tutorial.get_by_slug(tutorial)->Belt.Option.getExn->Next.stripUndefined

  Js.Promise.resolve({
    "props": {
      source: tutorial.body_html,
      title: tutorial.title,
      pageDescription: tutorial.description,
      tableOfContents: tutorial.toc_html,
    },
  })
}

let getStaticPaths: Next.GetStaticPaths.t<Params.t> = () => {
  let ret = {
    Next.GetStaticPaths.paths: Array.map(tutorial => {
      Next.GetStaticPaths.params: {
        Params.tutorial: tutorial.Ood.Tutorial.slug,
      },
    }, Array.of_list(Ood.Tutorial.all)),
    // TODO: update bindings to always use "false"
    fallback: false,
  }
  Js.Promise.resolve(ret)
}

let default = make

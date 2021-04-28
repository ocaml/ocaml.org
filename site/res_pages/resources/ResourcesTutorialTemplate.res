let s = React.string

module Params = {
  type t = {tutorial: string}
}

type t = {contents: string}

type props = {
  source: string,
  title: string,
  pageDescription: Js.Nullable.t<string>,
  tableOfContents: MarkdownPage.TableOfContents.t,
}

@react.component
let make = (~source, ~title, ~pageDescription, ~tableOfContents) => {
  <>
    // TODO: should this have a constrained width? what does tailwind do?
    <MainContainer.None>
      <div className="grid grid-cols-9 bg-white">
        <MarkdownPage.TableOfContents content=tableOfContents />
        <div className="col-span-9 lg:col-span-7 bg-graylight relative py-16 overflow-hidden">
          <div className="relative px-4 sm:px-6 lg:px-8">
            <TitleHeading.MarkdownMedium title pageDescription />
            <MarkdownPage.MarkdownPageBody margins=`mt-6` renderedMarkdown=source />
          </div>
        </div>
      </div>
    </MainContainer.None>
  </>
}

let contentEn = {
  contents: `Contents`,
}

type pageContent = {title: string, pageDescription: option<string>}

@module("js-yaml") external load: (string, ~options: 'a=?, unit) => pageContent = "load"

let getStaticProps = ctx => {
  let {Params.tutorial: tutorial} = ctx.Next.GetStaticProps.params
  let baseDirectory = "data/tutorials/"
  // TODO: find the location of the tutorial
  let contentFilePath = baseDirectory ++ tutorial ++ "/" ++ tutorial ++ ".md"
  let fileContents = Fs.readFileSync(contentFilePath)
  let parsed = GrayMatter.matter(fileContents)
  // TODO: move this into GrayMatter or another module
  GrayMatter.forceInvalidException(parsed.data)
  let source = parsed.content

  let resPromise = Unified.process(
    Unified.use(
      Unified.use(
        Unified.use(
          Unified.use(Unified.use(Unified.unified(), Unified.remarkParse), Unified.remarkSlug),
          MdastToc.plugin,
        ),
        Unified.remark2rehype,
      ),
      Unified.rehypeStringify,
    ),
    source,
  )

  Js.Promise.then_((res: Unified.vfile) => {
    let props = {
      source: res.contents,
      title: parsed.data.title,
      pageDescription: switch parsed.data.pageDescription {
      | None => Js.Nullable.null
      | Some(v) => Js.Nullable.return(v)
      },
      tableOfContents: {
        contents: "Contents",
        toc: res.toc,
      },
    }
    Js.Promise.resolve({"props": props})
  }, resPromise)
}

let getStaticPaths: Next.GetStaticPaths.t<Params.t> = () => {
  // TODO: move this logic into a module dedicated to fetching tutorials
  // TODO: throw exception if any tutorials have the same filename or add a more parts to the tutorials path
  // TODO: throw exception if any entry is not a directory
  let markdownFiles = Fs.readdirSyncEntries("data/tutorials/")

  let ret = {
    Next.GetStaticPaths.paths: Array.map((f: Fs.dirent) => {
      Next.GetStaticPaths.params: {
        // TODO: better error
        Params.tutorial: Js.String.split(".", f.name)[0],
      },
    }, markdownFiles),
    // TODO: update bindings to always use "false"
    fallback: false,
  }
  Js.Promise.resolve(ret)
}

let default = make

type props = {
    source: NextMdxRemote.renderToStringResult,
}

let default = (props) => {
  let content = NextMdxRemote.hydrate(
      props.source, 
      NextMdxRemote.hydrateParams(~components=Markdown.default, ()))
  <>
  {content}
  </>
}

let getStaticProps = _ctx => {
    // TODO: add next file watcher to scripts
    // TODO: export const POSTS_PATH = path.join(process.cwd(), '_contents')
    let contentFilePath = "_content/community/support.mdx"
    let source = Fs.readFileSync(contentFilePath)
    let mdxSourcePromise = NextMdxRemote.renderToString(
        source, 
        NextMdxRemote.renderToStringParams(~components=Markdown.default, ()))
    mdxSourcePromise->Js.Promise.then_(mdxSource => {
        let props = {
            source: mdxSource,
        }
        Js.Promise.resolve({"props": props})
    }, _)
}
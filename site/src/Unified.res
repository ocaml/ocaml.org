// The following code causes a warning. My limited understanding is that the warning
// occurs because there is a mismatch between ReScript's assumptions about the version
// of Javascript being used and the actual version of Javascript used in NextJS. Currently,
// we have ReScript configured to target the ES6 version of Javascript. This is the emerging standard. At the same time,
// there are open issues in NextJS requesting ES6 support, but NextJS does not
// currently evaluate Javascript in an ES6 context. NextJS uses CommonJS when
// evaluating Javascript. The warning occurs because ReScript uses an external validator
// on the generated Javascript and the external validator notes that using "import" in
// the syntax below is not valid in ES6. The syntax is valid in CommonJS, which means
// the code will successfully run in NextJS.
// This warning will hopefully be resolved by September of 2021, if
// NextJS proceeds to lift its restriction on using ES6. The status of this issue
// can be tracked in Github issue #298.
%%raw(`
const MdastUtilToStringInternal = (await import('mdast-util-to-string')).toString
`)

module MarkdownTableOfContents = {
  type rec toc = {
    label: string,
    id: string,
    children: list<toc>,
  }

  type t = list<toc>
}

type processor

@module("unified") external unified: unit => processor = "default"

type node = {\"type": string, depth: option<int>}

type data = {id: string}

type headingnode = {
  depth: int,
  data: data,
}

external asHeadingNode: node => headingnode = "%identity"

type rootnode = {children: array<node>}

type vfile = {mutable toc: MarkdownTableOfContents.t, contents: string}

type transformer = (rootnode, vfile) => unit

type attacher = unit => transformer

@send external use: (processor, attacher) => processor = "use"

@send external process: (processor, string) => Js.Promise.t<vfile> = "process"

@module("remark-slug") external remarkSlug: attacher = "default"

@module("remark-parse") external remarkParse: attacher = "default"

@module("remark-rehype") external remark2rehype: attacher = "default"

@module("rehype-stringify") external rehypeStringify: attacher = "default"

@module("rehype-highlight") external rehypeHighlight: attacher = "default"

module MdastUtilToString = {
  @val external toString: headingnode => string = "MdastUtilToStringInternal"
}

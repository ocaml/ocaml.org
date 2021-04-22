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

module MdastUtilToString = {
  @module("mdast-util-to-string") external toString: headingnode => string = "default"
}

module MarkdownTableOfContents: {
  type rec toc = {
    label: string,
    id: string,
    children: list<toc>,
  }

  type t = list<toc>
}

type processor

let unified: unit => processor

type node = {\"type": string, depth: option<int>}

type data = {id: string}

type headingnode = {
  depth: int,
  data: data,
}

let asHeadingNode: node => headingnode

type rootnode = {children: array<node>}

type vfile = {mutable toc: MarkdownTableOfContents.t, contents: string}

type transformer = (rootnode, vfile) => unit

type attacher = unit => transformer

let use: (processor, attacher) => processor

let process: (processor, string) => Js.Promise.t<vfile>

let remarkSlug: attacher

let remarkParse: attacher

let remark2rehype: attacher

let rehypeStringify: attacher

module MdastUtilToString: {
  let toString: headingnode => string
}

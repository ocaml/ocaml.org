// TODO: define scanleft (https://github.com/reazen/relude/blob/e733128d0df8022448398a44c80cba6f28443b94/src/list/Relude_List_Base.re#L487)
// and use it below

// TODO: factor out the core algorithm from other concerns, and
//  write unit tests for the core algorithm.

let transformer = (rootnode: Unified.rootnode, file: Unified.vfile) => {
  let rec collect = (nodes, inProgress) => {
    switch nodes {
    | list{} =>
      inProgress
      ->Belt.Option.map(((_, entry)) => entry)
      ->Belt.Option.mapWithDefault(list{}, e => list{e})
    | list{h: Unified.headingnode, ...tail} =>
      let d = h.depth
      if d >= 2 || d <= 3 {
        let entry = {
          Unified.MarkdownTableOfContents.label: Unified.MdastUtilToString.toString(h),
          id: h.data.id,
          children: list{},
        }
        switch inProgress {
        | None => collect(tail, Some(d, entry))
        | Some(lastRootDepth, completed) if d <= lastRootDepth => list{
            completed,
            ...collect(tail, Some(d, entry)),
          }
        | Some(lastRootDepth, inProgress) =>
          let inProgress = {
            ...inProgress,
            // TODO: use add and perform reverse when inProgress is complete
            children: Belt.List.concat(inProgress.children, list{entry}),
          }
          collect(tail, Some(lastRootDepth, inProgress))
        }
      } else {
        // TODO: Should we guard against unusual jumps in depth here?
        //  No, instead validate the list of headings
        //  in an earlier pass and produce new type with
        //  stronger guarantees about heading sequences.
        collect(tail, inProgress)
      }
    }
  }
  let headings =
    rootnode.children
    ->Belt.Array.keepMap(ch =>
      switch ch {
      | {\"type": "heading", depth: Some(_)} => Some(Unified.asHeadingNode(ch))
      | _ => None
      }
    )
    ->Array.to_list
    ->collect(None)

  file.toc = headings
}

let plugin = () => {
  transformer
}

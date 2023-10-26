---
title: Ocamlformat 0.26.0
date: "2023-07-20"
tags: [ocamlformat, platform]
changelog: |
  _Items marked with an asterisk (`*`) are changes that are likely to format
  existing code differently from the previous release when using the default
  profile._

  ### New features

  - Handle short syntax for generative functor types (#2348, @gpetiot)
  - Improved error reporting for unstable or dropped comments (#2292, @gpetiot)

  ### Removed

  - Remove `--numeric` feature (#2333, #2357, @gpetiot)

  ### Bug fixes

  - Fix crash caused by `let f (type a) :> a M.u = ..` (#2399, @Julow)
  - Fix crash caused by `module T = (val (x : (module S)))` (#2370, @Julow)
  - Fix invalid formatting of `then begin end` (#2369, @Julow)
  - Protect match after `fun _ : _ ->` (#2352, @Julow)
  - Fix invalid formatting of `(::)` (#2347, @Julow)
  - Fix indentation of module-expr extensions (#2323, @gpetiot)
  - \* Remove double parentheses around tuples in a match (#2308, @Julow)
  - \* Remove extra parentheses around module packs (#2305, @Julow, @gpetiot)
  - Fix indentation of trailing double-semicolons (#2295, @gpetiot)
  - Fix formatting of comments in "disable" chunks (#2279, @gpetiot)
  - Fix non-stabilizing comments attached to private/virtual/mutable keywords (#2272, #2307, @gpetiot, @Julow)

  ### Changes

  - Improve formatting of doc-comments (#2338, #2349, #2376, #2377, #2379, #2378, @Julow)
    Remove unnecessary escaping and preserve empty lines.
  - \* Indent `as`-patterns that have parentheses (#2359, @Julow)
  - Don't print warnings related to odoc code-blocks when '--quiet' is set (#2336, #2373, @gpetiot, @Julow)
  - \* Improve formatting of module arguments (#2322, @Julow)
  - \* Don't indent attributes after a let/val/external (#2317, @Julow)
  - Consistent indentation of `@@ let+ x = ...` (#2315, #2396, @Julow)
    It was formatted differently than `@@ let x = ...`.
  - \* Improve formatting of class expressions and signatures (#2301, #2328, #2387, @gpetiot, @Julow)
  - \* Consistent indentation of `fun (type a) ->` following `fun x ->` (#2294, @Julow)
  - \* Restore short-form formatting of record field aliases (#2282, #2388, @gpetiot, @Julow)
  - \* Restore short-form for first-class modules: `((module M) : (module S))` is formatted as `(module M : S)`) (#2280, #2300, @gpetiot, @Julow)
  - \* Improve indentation of `~label:(fun ...` (#2271, #2291, #2293, #2298, #2398, @Julow)
    The `fun` keyword is docked where possible and the arguments are indented to avoid confusion with the body.
  - JaneStreet profile: treat comments as doc-comments (#2261, #2344, #2354, #2365, #2392, @gpetiot, @Julow)
  - Tweaks the JaneStreet profile to be more consistent with ocp-indent (#2214, #2281, #2284, #2289, #2299, #2302, #2309, #2310, #2311, #2313, #2316, #2362, #2363, @gpetiot, @Julow)
---

We are thrilled to announce the release of OCamlFormat 0.26.0!

After almost 5 months of intense development, this release comes with a ton of consistency improvements and bug fixes. In particular, the handling of comments should be largely superior!

Have a look at the full changelog to see the list of improvements, and don't hesitate to share your feedback on this release on [OCaml Discuss](https://discuss.ocaml.org/).

---
title: Ocamlformat 0.26.1
date: "2023-09-19"
tags: [ocamlformat, platform]
changelog: |
  ### Changed

  - Compatible with OCaml 5.1.0 (#2412, @Julow)
    The syntax of let-bindings changed sligthly in this version.
  - Improved ocp-indent compatibility (#2428, @Julow)
  - \* Removed extra break in constructor declaration with comment (#2429, @Julow)
  - \* De-indent the `object` keyword in class types (#2425, @Julow)
  - \* Consistent formatting of arrows in class types (#2422, @Julow)

  ### Fixed

  - Fix dropped attributes on a begin-end in a match case (#2421, @Julow)
  - Fix dropped attributes on begin-end in an if-then-else branch (#2436, @gpetiot)
  - Fix non-stabilizing comments before a functor type argument (#2420, @Julow)
  - Fix crash caused by module types with nested `with module` (#2419, @Julow)
  - Fix ';;' formatting between doc-comments and toplevel directives (#2432, @gpetiot)
---

We are pleased to announce the release of OCamlFormat 0.26.1!

This is the first OCamlFormat release to be compatible with OCaml 5.1.

We highlight notable formatting improvements below:

1. **Removal of extra breaks in constructor declarations**
  ```diff
   type t =                               
     | Foo
     | (* Redirect (None, lib) looks up lib in the same database *)
  -    Redirect of
  -      db option * (Loc.t * Lib_name.t)
  +    Redirect of db option * (Loc.t * Lib_name.t)
  +    
  ```

2. **Consistent formatting for arrow class types, and consistent indentation of the `object` keyword**
  ```diff
  module type S = sig                    
  -  class tttttttttttt : aaaaaaaaaaaaaaaaaa:int -> bbbbbbbbbbbbbbbbbbbbb:float ->
  +  class tttttttttttt :
  +    aaaaaaaaaaaaaaaaaa:int ->
  +    bbbbbbbbbbbbbbbbbbbbb:float ->
      cccccccccccccccccccc
  end

  class type ct =
    let open M in
  -  object
  +object
    val x : t
  end
  ```

We've also fixed a few bugs. Attributes that were previously skipped are not preserved, and we fixed a crash that occured in the presence of nested modules.

Have a look at the full changelog to see the list of improvements, and don’t hesitate to share your feedback on this release on OCaml Discuss.

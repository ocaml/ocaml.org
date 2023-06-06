---
title: How to migrate your ppx to OCaml migrate parsetree
description: OCaml migrate parse tree          OCaml migrate parse tree     Earlier
  this   year, this   blog post  [2] explored the impleme...
url: http://blog.shaynefletcher.org/2017/12/how-to-migrate-your-ppx-to-ocaml.html
date: 2017-12-09T15:40:00-00:00
preview_image:
featured:
authors:
- Shayne Fletcher
---


<html>
  <head>
    
    <title>OCaml migrate parse tree</title>
  </head>
  <body>
  <h2>OCaml migrate parse tree</h2>

  <p>Earlier this
  year, <a href="http://blog.shaynefletcher.org/2017/05/preprocessor-extensions-for-code.html">this
  blog post</a> [2] explored the implementation of a small
  preprocessor extension (ppx).
  </p>
  <p>The code of the above article worked well enough at the time but
  as written, exhibits a problem : new releases of the OCaml compiler
  are generally accompanied by evolutions of the OCaml parse tree. The
  effect of this is, a ppx written against a specific version of the
  compiler will &quot;break&quot; in the presence of later releases of the
  compiler. As pointed out in [3], the use of ppx's in the OCaml
  eco-system these days is ubiquitous. If each new release of the
  OCaml compiler required sychronized updates of each and every ppx
  in <a href="http://opam.ocaml.org/">opam</a>, getting new releases
  of the compiler out would soon become a near impossibilty.
  </p>
  <p>Mitigation of the above problem is provided by
  the <a href="http://opam.ocaml.org/packages/ocaml-migrate-parsetree/"><code>ocaml-migrate-parsetree</code>
  </a> library. The library provides the means to convert parsetrees
  from one OCaml version to another. This allows the ppx rewriter to
  write against a specific version of the parsetree and lets the
  library take care of rolling parsetrees backwards and forwards in
  versions as necessary.  In this way, the resulting ppx is &quot;forward
  compatible&quot; with newer OCaml versions without requiring ppx code
  updates.
  </p>
  <p>To get the <code>ppx_id_of</code> code from the earlier blog post
  usable with <code>ocaml-migrate-parsetree</code> required a couple
  of small tweaks to make it OCaml 4.02.0 compatible. The changes from
  the original code were slight and not of significant enough interest
  to be worth presenting here. What is worth looking at is what it
  then took to switch the code to
  use <code>ocaml-migrate-parsetree</code>. The answer is : very
  little!
</p><pre><code class="code"><span class="keyword">open</span> <span class="constructor">Migrate_parsetree</span>
<span class="keyword">open</span> <span class="constructor">OCaml_402</span>.<span class="constructor">Ast</span>

<span class="keyword">open</span> <span class="constructor">Ast_mapper</span>
<span class="keyword">open</span> <span class="constructor">Ast_helper</span>
<span class="keyword">open</span> <span class="constructor">Asttypes</span>
<span class="keyword">open</span> <span class="constructor">Parsetree</span>
<span class="keyword">open</span> <span class="constructor">Longident</span>

<span class="comment">(* The original ppx as written before goes here!
   .                    .                   .
   .                    .                   .
   .                    .                   .
*)</span>

<span class="keyword">let</span> () = <span class="constructor">Driver</span>.register ~name:<span class="string">&quot;id_of&quot;</span> (<span class="keyword">module</span> <span class="constructor">OCaml_402</span>) id_of_mapper
</code></pre> The complete code for this article is available
online <a href="https://github.com/shayne-fletcher/zen/tree/master/ocaml/ppx_id_of/v2">here</a>
and as a bonus, includes a
minimal <a href="https://jbuilder.readthedocs.io/en/latest/"><code>jbuilder</code></a>
build system demonstrating just how well the OCaml tool-chain comes
together these days.
  
  <hr/>
  <p>
    References:<br/>
     [1] <a href="https://whitequark.org/blog/2014/04/16/a-guide-to-extension-points-in-ocaml/">&quot;A
     Guide to Extension Points in OCaml&quot; -- Whitequark (blog post
     2014)</a><br/>
     [2] <a href="http://blog.shaynefletcher.org/2017/05/preprocessor-extensions-for-code.html">&quot;Preprocessor
     extensions for code generation&quot; -- Shayne Fletcher (blog post
     2017)</a><br/>
     [3] <a href="http://rgrinberg.com/posts/extension-points-3-years-later/">&quot;Extension
     Points - 3 Years Later&quot; -- Rudi Grinberg (blog post 2017)</a><br/>
  </p>
  </body>
</html>


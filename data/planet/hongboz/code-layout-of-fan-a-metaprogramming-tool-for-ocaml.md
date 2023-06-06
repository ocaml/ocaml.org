---
title: Code layout of Fan (a metaprogramming tool for OCaml)
description: "Fan is a metaprogramming tool for OCaml. I believe it would be an invaluable
  tool for the community when it\u2019s production ready. If you are attracted by
  the power of Camlp4 while frustrated wi\u2026"
url: https://hongboz.wordpress.com/2013/09/16/code-layout-of-fan-a-metaprogramming-tool-for-ocaml/
date: 2013-09-16T19:04:58-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- hongboz
---

<div>
<p>
Fan is a metaprogramming tool for OCaml.  I believe it would be an<br/>
invaluable tool for the community when it&rsquo;s production ready.
</p>
<p>
If you are attracted by the power of Camlp4 while frustrated with the<br/>
complexity, or slowness, I would be very glad that you could join and contribute.
</p>
<p>
It&rsquo;s already ready for accepting external contribution, since the<br/>
development of Fan would be pinned to <a href="http://caml.inria.fr/pub/distrib/ocaml-4.01/">OCaml 4.01.0</a> for a while.
</p>
<div class="outline-2">
<h2><span class="section-number-2">1</span> Code layout</h2>
<div class="outline-text-2">
<p>
The source is scattered in four directories<br/>
<code>common</code>, <code>treeparser</code>, <code>src</code>, <code>cold</code>, and <code>unitest</code>
</p>
<p>
In the common directory, all sources are written in <i>vanilla OCaml</i>,<br/>
it defines basic primitives which dumps Fan&rsquo;s abstract syntax into<br/>
OCaml&rsquo;s abstract syntax.
</p>
<p>
Note that all compiler related modules is isolated in this<br/>
directory. That said, in the future, if we would like to support<br/>
different patched compiler, for example, metaocaml or Lexifi&rsquo;s mlfi<br/>
compiler, only this directory needs to be touched.
</p>
<p>
In the treeparser directory, it is also written in <i>vanilla Ocaml</i>,<br/>
it defines the runtime of the parsing structure.
</p>
<p>
The <code>src</code> directory is written in Fan&rsquo;s syntax.<br/>
Keep in mind that Fan&rsquo;s syntax is essentially the same as OCaml&rsquo;s<br/>
syntax, except that it allows quotations, and other tiny<br/>
differences (parens around tuple is necessary, not optional).
</p>
<p>
The <code>cold</code> directory is a mirror of <code>src</code> directory in <i>vanilla<br/>
ocaml</i>, though it is much verbose compared with src.
</p>
<p>
So when you get the source tree, the initial build  is typically
</p>
<div class="org-src-container">
<pre class="src src-sh">ocamlbuild cold/fan.native
</pre>
</div>
<p>
The first command <code>ocamlbuild cold/fan.native</code> would build a binary<br/>
composed of modules from <code>common</code>, <code>treeparser</code> and <code>cold</code>. Since<br/>
they are all written in <i>vanilla ocaml</i>, no preprocessors are<br/>
needed for the initial compilation.
</p>
<p>
If you are a third party user, that&rsquo;s pretty much all you need to<br/>
know. As a developer of Fan, the next command is
</p>
<div class="org-src-container">
<pre class="src src-sh">./re cold fan.native
</pre>
</div>
<p>
This shell script would symlink <code>_build/cold/fan.native</code> to<br/>
<code>_build/boot/fan</code>, which would be used by compiling src.
</p>
<p>
Now you can compile the src directory
</p>
<div class="org-src-container">
<pre class="src src-sh">ocamlbuild src/fan.native
</pre>
</div>
<p>
The command <code>ocamlbuild cold/fan.native</code> would build a binary<br/>
composed of modules from <code>common</code>, <code>treeparser</code> and <code>cold</code>.
</p>
<p>
Note that at this time src is a mirror of cold, after preprocessored<br/>
by fan, the produced binary <code>src/fan.native</code> should be the same as<br/>
<code>cold/fan.native</code>.
</p>
<p>
Now you can
</p>
<div class="org-src-container">
<pre class="src src-sh">./re src fan.native
</pre>
</div>
<p>
But this does not make much sense since <code>src/fan.native</code> is exactly<br/>
the same as <code>./cold/fan.native</code>.
</p>
<p>
Okay, in most cases, your development would be in such directories:<br/>
common, treeparser, src and unitest.
</p>
<p>
If you only touch common, treeparser or unitest, commit the changes<br/>
and send me a pull request.
</p>
<p>
If you also touch the files in <code>src</code> directory, you should mirror<br/>
those changes back to <code>cold</code> directory. Here we go:
</p>
<div class="org-src-container">
<pre class="src src-sh">./snapshot
</pre>
</div>
<p>
Yes, now all the changes in <code>src</code> will be mirrored back to <code>cold</code><br/>
directory.<br/>
For a simple change, commit and done. For a complex change that you<br/>
are not sure whether it would break anything or not, try to run:
</p>
<div class="org-src-container">
<pre class="src src-sh">./hb fan.native
</pre>
</div>
<p>
The command above would first build <code>src/fan.native</code> using the<br/>
current preprocessor <code>_build/boot/fan</code>.
</p>
<p>
When it&rsquo;s done, it would first remove the directories <code>_build/src</code>,<br/>
and <code>_build/common</code>, <code>_build/treeparser</code>. Then it would set<br/>
<code>_build/boot/fan</code> to be the new build preprocessor <code>src/fan.native</code>.<br/>
After that it would call <code>ocamlbuild src/fan.native</code> to build a new<br/>
preprocessor based on the existing preprocessor.
</p>
<p>
Then it would compare the two preprocessors, if they are exactly the<br/>
same, it means we manage to have a successful bootstrap. There is a<br/>
large chance that your change is correct.
</p>
<p>
Then
</p>
<div class="org-src-container">
<pre class="src src-sh">make test
</pre>
</div>
<p>
If everything goes well, it&rsquo;s safe to commit now.
</p>
<p>
When the bootstrap fails, generally two cases: 1. the comparison<br/>
does not tell you the two preprocessors are the same, the normal<br/>
workflow is to repeat the command <code>./hb fan.native</code> again. 2. It<br/>
fails to compile, since you always have <code>cold/fan.native</code> compiled,<br/>
fall back to such preprocessor and see where you made wrong.
</p>
</div>
</div>
</div>


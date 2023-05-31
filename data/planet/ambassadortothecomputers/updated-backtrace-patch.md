---
title: Updated backtrace patch
description: "I\u2019ve updated my backtrace  patch  to work with OCaml 3.11.x as
  well as 3.10.x. The patch provides         access to backtraces from within a..."
url: http://ambassadortothecomputers.blogspot.com/2010/03/updated-backtrace-patch.html
date: 2010-03-28T01:19:00-00:00
preview_image:
featured:
authors:
- ambassadortothecomputers
---

<p>I&rsquo;ve updated my <a href="http://skydeck.com/blog/programming/stack-traces-in-ocaml">backtrace</a> <a href="http://skydeck.com/blog/programming/more-stack-traces-in-ocaml">patch</a> to work with OCaml 3.11.x as well as 3.10.x. The patch provides</p> 
 
<ul> 
<li> 
<p>access to backtraces from within a program (this is already provided in stock 3.11.x)</p> 
</li> 
 
<li> 
<p>backtraces for dynamically-loaded bytecode</p> 
</li> 
 
<li> 
<p>backtraces in the (bytecode) toplevel</p> 
</li> 
</ul> 
 
<p>In addition there are a few improvements since the last version:</p> 
 
<ul> 
<li> 
<p>debugging events are allocated outside the heap, so memory use should be better with forking (on Linux at least, the data is shared on copy-on-write pages but the first GC causes the pages be copied)</p> 
</li> 
 
<li> 
<p>fixed a bug that could cause spurious &ldquo;unknown location&rdquo; lines in the backtrace</p> 
</li> 
 
<li> 
<p>a script to apply the patch (instead of the previous multi-step manual process)</p> 
</li> 
</ul> 
 
<p>See <a href="http://github.com/jaked/ocaml-backtrace-patch">ocaml-backtrace-patch</a> on Github or <a href="http://github.com/downloads/jaked/ocaml-backtrace-patch/ocaml-backtrace-patch-0.5.tar.gz">download the tarball</a>.</p>

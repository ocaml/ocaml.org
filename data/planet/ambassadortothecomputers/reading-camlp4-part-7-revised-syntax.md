---
title: 'Reading Camlp4, part 7: revised syntax'
description: "As we have seen, Camlp4 contains an alternative syntax for OCaml, the
  \u201Crevised\u201D syntax, which attempts to correct some infelicities of the o..."
url: http://ambassadortothecomputers.blogspot.com/2010/07/reading-camlp4-part-7-revised-syntax.html
date: 2010-07-27T18:01:00-00:00
preview_image:
featured:
authors:
- ambassadortothecomputers
---

<p>As we have seen, Camlp4 contains an alternative syntax for OCaml, the &ldquo;revised&rdquo; syntax, which attempts to correct some infelicities of the original syntax, and to make it easier to parse and pretty-print. Most (all?) of Camlp4 itself is written in this syntax.</p> 
 
<p>While OCaml quotations may be written in either original or revised syntax, original syntax quotations are not as well-supported; there are AST constructions which are difficult or impossible to generate from original syntax quotations. (As I understand it, part of the motivation for the revised syntax was to provide more context, in the form of extra brackets etc., so that antiquotations work more smoothly.)</p> 
 
<p>I have always felt that the revised syntax is a pointless idiosyncrasy, and that whatever value it might bring is offset by the mental clutter of working with two syntaxes (since most code is still written in the original syntax). So I have stuck with original syntax quotations in this series, and recommended that you fall back to AST constructors when quotations don&rsquo;t work out. However, the situation with original syntax quotations seems to have gotten worse in the upcoming OCaml 3.12.0 release (see bugs <a href="http://caml.inria.fr/mantis/view.php?id=5080">5080</a> and <a href="http://caml.inria.fr/mantis/view.php?id=5104">5104</a>).</p> 
 
<p>These bugs affected my <a href="http://github.com/jaked/orpc">orpc</a> and <a href="http://github.com/jaked/ocamljs">ocamljs</a> projects, and I decided to use revised syntax quotations rather than uglying up the code with AST constructors. This turned out to be not so bad, requiring only a few changes. Fortunately, you can choose for each source file which kind to use (in ocamlbuild you can give the <code>pkg_camlp4.quotations.o</code> or <code>pkg_camlp4.quotations.r</code> tags per file), so I left quotations in files that were unaffected or only lightly affected in the original syntax.</p> 
 
<p>I don&rsquo;t have anything new to say about the revised syntax, but I want to point out the following resources:</p> 
 
<ul> 
<li><a href="http://caml.inria.fr/pub/docs/tutorial-camlp4/tutorial005.html">tutorial and rationale (old camlp4)</a></li> 
 
<li><a href="http://caml.inria.fr/pub/docs/manual-camlp4/manual007.html">reference (old camlp4)</a></li> 
 
<li><a href="http://brion.inria.fr/gallium/index.php/Revised">wiki page (new camlp4)</a></li> 
</ul> 
 
<p>The final word on the revised syntax is of course the parser itself, found in <code>Camlp4OCamlRevisedParser.ml</code>; you may find these <a href="http://ambassadortothecomputers.blogspot.com/2009/01/reading-camlp4-part-3-quotations-in.html">earlier</a> <a href="http://ambassadortothecomputers.blogspot.com/2010/05/reading-camlp4-part-6-parsing.html">posts</a> useful in making sense of it.</p>

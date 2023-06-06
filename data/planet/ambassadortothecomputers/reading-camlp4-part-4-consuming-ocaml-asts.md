---
title: 'Reading Camlp4, part 4: consuming OCaml ASTs'
description: It's easy to think of Camlp4 as just "defmacro on steroids"; that is,
  just a tool for syntax extension, but it is really a box of independen...
url: http://ambassadortothecomputers.blogspot.com/2009/01/reading-camlp4-part-4-consuming-ocaml.html
date: 2009-01-28T06:09:00-00:00
preview_image:
featured:
authors:
- ambassadortothecomputers
---

It's easy to think of Camlp4 as just &quot;defmacro on steroids&quot;; that is, just a tool for syntax extension, but it is really a box of independently-useful tools. As we've seen, Camlp4 can be used purely for code generation; in this post I'll describe a tool that uses it purely for code consumption: a (minimal, broken) version of <a href="http://www.cs.ru.nl/~tews/otags/">otags</a>:
<pre>
<span class="htmlize-tuareg-font-lock-governing">open</span> <span class="htmlize-type">Camlp4.PreCast</span>
<span class="htmlize-tuareg-font-lock-governing">module</span> <span class="htmlize-type">M </span><span class="htmlize-tuareg-font-lock-operator">=</span> <span class="htmlize-type">Camlp4OCamlRevisedParser</span>.Make<span class="htmlize-tuareg-font-lock-operator">(</span>Syntax<span class="htmlize-tuareg-font-lock-operator">)</span>
<span class="htmlize-tuareg-font-lock-governing">module</span> <span class="htmlize-type">N </span><span class="htmlize-tuareg-font-lock-operator">=</span> <span class="htmlize-type">Camlp4OCamlParser</span>.Make<span class="htmlize-tuareg-font-lock-operator">(</span>Syntax<span class="htmlize-tuareg-font-lock-operator">)</span>
</pre>
We're going to call the OCaml parser directly. These functor applications are used only for their effect (which is to fill in an empty grammer with OCaml cases); ordinarily they would be called as part of Camlp4's dynamic loading process. Recall that the original syntax parser is an extension of the revised parser, so we need both, in this order.
<pre>
<span class="htmlize-tuareg-font-lock-governing">let</span> <span class="htmlize-variable-name">files </span><span class="htmlize-tuareg-font-lock-operator">=</span> <span class="htmlize-tuareg-font-lock-operator">ref</span> <span class="htmlize-tuareg-font-lock-operator">[]</span>

<span class="htmlize-tuareg-font-lock-governing">let</span> <span class="htmlize-tuareg-font-lock-governing">rec</span> <span class="htmlize-function-name">do_fn</span><span class="htmlize-variable-name"> fn </span><span class="htmlize-tuareg-font-lock-operator">=</span>
  <span class="htmlize-tuareg-font-lock-governing">let</span> <span class="htmlize-variable-name">st </span><span class="htmlize-tuareg-font-lock-operator">=</span> <span class="htmlize-type">Stream</span>.of_channel <span class="htmlize-tuareg-font-lock-operator">(</span>open_in fn<span class="htmlize-tuareg-font-lock-operator">)</span> <span class="htmlize-tuareg-font-lock-governing">in</span>
  <span class="htmlize-tuareg-font-lock-governing">let</span> <span class="htmlize-variable-name">str_item </span><span class="htmlize-tuareg-font-lock-operator">=</span> <span class="htmlize-type">Syntax</span>.parse_implem <span class="htmlize-tuareg-font-lock-operator">(</span><span class="htmlize-type">Loc</span>.mk fn<span class="htmlize-tuareg-font-lock-operator">)</span> st <span class="htmlize-tuareg-font-lock-governing">in</span>
  <span class="htmlize-tuareg-font-lock-governing">let</span> <span class="htmlize-variable-name">str_items </span><span class="htmlize-tuareg-font-lock-operator">=</span> <span class="htmlize-type">Ast</span>.list_of_str_item str_item <span class="htmlize-tuareg-font-lock-operator">[]</span> <span class="htmlize-tuareg-font-lock-governing">in</span>
  <span class="htmlize-tuareg-font-lock-governing">let</span> <span class="htmlize-variable-name">tags </span><span class="htmlize-tuareg-font-lock-operator">=</span> <span class="htmlize-type">List</span>.fold_right do_str_item str_items <span class="htmlize-tuareg-font-lock-operator">[]</span> <span class="htmlize-tuareg-font-lock-governing">in</span>
  files <span class="htmlize-tuareg-font-lock-operator">:=</span> <span class="htmlize-tuareg-font-lock-operator">(</span>fn<span class="htmlize-tuareg-font-lock-operator">,</span> tags<span class="htmlize-tuareg-font-lock-operator">)::!</span>files
</pre>
We'll call <code>do_fn</code> for each filename on the command line. The <code>Syntax.parse_implem</code> function takes a <code>Loc.t</code> and a stream, and parses the stream into a <code>str_item</code>. (The initial <code>Loc.t</code> just provides the filename so later locations can refer to it, for error messages etc.) Now, recall that even though we got back a single <code>str_item</code>, it can contain several definitions (collected with <code>StSem</code>). We use <code>Ast.list_of_str_item</code> to get an ordinary list, then accumulate tags into <code>files</code>.
<pre>
<span class="htmlize-tuareg-font-lock-governing">and</span> <span class="htmlize-function-name">do_str_item</span><span class="htmlize-variable-name"> si tags </span><span class="htmlize-tuareg-font-lock-operator">=</span>
  <span class="htmlize-keyword">match</span> si <span class="htmlize-keyword">with</span>
 <span class="htmlize-comment">(* | &lt;:str_item&lt; let $rec:_$ $bindings$ &gt;&gt; -&gt; *)</span>
    <span class="htmlize-tuareg-font-lock-operator">|</span> <span class="htmlize-type">Ast</span>.StVal <span class="htmlize-tuareg-font-lock-operator">(</span>_<span class="htmlize-tuareg-font-lock-operator">,</span> _<span class="htmlize-tuareg-font-lock-operator">,</span> bindings<span class="htmlize-tuareg-font-lock-operator">)</span> <span class="htmlize-tuareg-font-lock-operator">-&gt;</span>
        <span class="htmlize-tuareg-font-lock-governing">let</span> <span class="htmlize-variable-name">bindings </span><span class="htmlize-tuareg-font-lock-operator">=</span> <span class="htmlize-type">Ast</span>.list_of_binding bindings <span class="htmlize-tuareg-font-lock-operator">[]</span> <span class="htmlize-tuareg-font-lock-governing">in</span>
        <span class="htmlize-type">List</span>.fold_right do_binding bindings tags
    <span class="htmlize-tuareg-font-lock-operator">|</span> _ <span class="htmlize-tuareg-font-lock-operator">-&gt;</span> tags
</pre>
We'll only consider value bindings. The commented-out <code>str_item</code> quotation doesn't work (run it through Camlp4 to see why--I'm not sure where the extra <code>StSem</code>/<code>StNil</code> come from), so we fall back to an explicit constructor. (The <code>rec</code> antiquotation matches a flag controlling whether an <code>StVal</code> is a <code>let rec</code> or just a <code>let</code>; here we don't care.) Now we have an <code>Ast.binding</code>, which again can contain several bindings (collected with <code>BiAnd</code>) so we call <code>Ast.list_of_bindings</code>.
<pre>
<span class="htmlize-tuareg-font-lock-governing">and</span> <span class="htmlize-function-name">do_binding</span><span class="htmlize-variable-name"> bi tags </span><span class="htmlize-tuareg-font-lock-operator">=</span>
  <span class="htmlize-keyword">match</span> bi <span class="htmlize-keyword">with</span>
    <span class="htmlize-tuareg-font-lock-operator">|</span> <span class="htmlize-tuareg-font-lock-operator">&lt;:</span><span class="htmlize-type">binding</span><span class="htmlize-tuareg-font-lock-operator">@</span>loc<span class="htmlize-tuareg-font-lock-operator">&lt;</span> <span class="htmlize-tuareg-font-lock-operator">$</span>lid<span class="htmlize-tuareg-font-lock-operator">:</span><span class="htmlize-type">lid</span><span class="htmlize-tuareg-font-lock-operator">$</span><span class="htmlize-type"> </span><span class="htmlize-tuareg-font-lock-operator">=</span> <span class="htmlize-tuareg-font-lock-operator">$</span>_<span class="htmlize-tuareg-font-lock-operator">$</span> <span class="htmlize-tuareg-font-lock-operator">&gt;&gt;</span> <span class="htmlize-tuareg-font-lock-operator">-&gt;</span>
      <span class="htmlize-tuareg-font-lock-governing">let</span> <span class="htmlize-variable-name">line </span><span class="htmlize-tuareg-font-lock-operator">=</span> <span class="htmlize-type">Loc</span>.start_line loc <span class="htmlize-tuareg-font-lock-governing">in</span>
      <span class="htmlize-tuareg-font-lock-governing">let</span> <span class="htmlize-variable-name">off </span><span class="htmlize-tuareg-font-lock-operator">=</span> <span class="htmlize-type">Loc</span>.start_off loc <span class="htmlize-tuareg-font-lock-governing">in</span>
      <span class="htmlize-tuareg-font-lock-governing">let</span> <span class="htmlize-variable-name">pre </span><span class="htmlize-tuareg-font-lock-operator">=</span> <span class="htmlize-string">&quot;let &quot;</span> <span class="htmlize-tuareg-font-lock-operator">^</span> lid <span class="htmlize-tuareg-font-lock-governing">in</span>
      <span class="htmlize-tuareg-font-lock-operator">(</span>pre<span class="htmlize-tuareg-font-lock-operator">,</span> lid<span class="htmlize-tuareg-font-lock-operator">,</span> line<span class="htmlize-tuareg-font-lock-operator">,</span> off<span class="htmlize-tuareg-font-lock-operator">)::</span>tags
    <span class="htmlize-tuareg-font-lock-operator">|</span> _ <span class="htmlize-tuareg-font-lock-operator">-&gt;</span> tags
</pre>
We're going to generate an <code>etags</code>-format file, where each definition consists of a prefix of the line in the source, the tag itself, the line number, and the character offset. If you look in the parser you'll see that the left side of a binding can be any pattern (as you'd expect), but we only handle the case where it's a single identifier; the <code>lid</code> antiquotation extracts it as a string. The line number and character offset are easy to find from the location of the binding (see <a href="http://camlcvs.inria.fr/cgi-bin/cvsweb/~checkout~/ocaml/camlp4/Camlp4/Sig.ml?content-type=text/plain">camlp4/Camlp4/Sig.ml</a> for the <code>Loc</code> functions), which we get with <code>@loc</code>. The prefix is problematic: the location of the binding does not include the <code>let</code> or <code>and</code> part, and anyway what we really want is everything from the beginning of the line. Doable but not so instructive of Camlp4, so we just tack on a <code>&quot;let &quot;</code> prefix (so this doesn't work for <code>and</code> or if there is whitespace).
<pre>
<span class="htmlize-tuareg-font-lock-governing">let</span> <span class="htmlize-function-name">print_tags</span><span class="htmlize-variable-name"> files </span><span class="htmlize-tuareg-font-lock-operator">=</span>
  <span class="htmlize-tuareg-font-lock-governing">let</span> <span class="htmlize-variable-name">ch </span><span class="htmlize-tuareg-font-lock-operator">=</span> open_out <span class="htmlize-string">&quot;TAGS&quot;</span> <span class="htmlize-tuareg-font-lock-governing">in</span>
  <span class="htmlize-type">ListLabels</span>.iter files <span class="htmlize-tuareg-font-lock-operator">~</span><span class="htmlize-variable-name">f</span><span class="htmlize-tuareg-font-lock-operator">:(</span><span class="htmlize-keyword">fun</span> <span class="htmlize-tuareg-font-lock-operator">(</span><span class="htmlize-variable-name">fn</span><span class="htmlize-tuareg-font-lock-operator">,</span><span class="htmlize-variable-name"> tags</span><span class="htmlize-tuareg-font-lock-operator">)</span><span class="htmlize-variable-name"> </span><span class="htmlize-tuareg-font-lock-operator">-&gt;</span>
    <span class="htmlize-type">Printf</span>.fprintf ch <span class="htmlize-string">&quot;\012\n%s,%d\n&quot;</span> fn 0<span class="htmlize-tuareg-font-lock-operator">;</span>
    <span class="htmlize-type">ListLabels</span>.iter tags <span class="htmlize-tuareg-font-lock-operator">~</span><span class="htmlize-variable-name">f</span><span class="htmlize-tuareg-font-lock-operator">:(</span><span class="htmlize-keyword">fun</span> <span class="htmlize-tuareg-font-lock-operator">(</span><span class="htmlize-variable-name">pre</span><span class="htmlize-tuareg-font-lock-operator">,</span><span class="htmlize-variable-name"> tag</span><span class="htmlize-tuareg-font-lock-operator">,</span><span class="htmlize-variable-name"> line</span><span class="htmlize-tuareg-font-lock-operator">,</span><span class="htmlize-variable-name"> off</span><span class="htmlize-tuareg-font-lock-operator">)</span><span class="htmlize-variable-name"> </span><span class="htmlize-tuareg-font-lock-operator">-&gt;</span>
      <span class="htmlize-type">Printf</span>.fprintf ch <span class="htmlize-string">&quot;%s\127%s\001%d,%d\n&quot;</span> pre tag line off<span class="htmlize-tuareg-font-lock-operator">))</span>
</pre>
Generating the tags file is straightforward, following the description at the bottom of the <a href="http://www.cs.ru.nl/~tews/otags/README">otags README</a>. (The <code>0</code> is supposed to be the length of the tag data, but my Emacs doesn't seem to care.) We put the pieces together with <code>Arg</code>:
<pre>
<span class="htmlize-tuareg-font-lock-operator">;;</span>
<span class="htmlize-type">Arg</span>.parse <span class="htmlize-tuareg-font-lock-operator">[]</span> do_fn <span class="htmlize-string">&quot;otags: fn1 [fn2 ...]&quot;</span><span class="htmlize-tuareg-font-lock-operator">;</span>
print_tags <span class="htmlize-tuareg-font-lock-operator">!</span>files
</pre>
and finally, a Makefile:
<pre>
<span class="htmlize-makefile-targets">otags</span>: otags.ml
<span class="htmlize-pesche-tab">        </span><span class="htmlize-makefile-shell">ocamlc \
</span><span class="htmlize-pesche-tab">        </span>  -pp camlp4of \
<span class="htmlize-pesche-tab">        </span>  -o otags \
<span class="htmlize-pesche-tab">        </span>  -I +camlp4 -I +camlp4/Camlp4Parsers \
<span class="htmlize-pesche-tab">        </span>  dynlink.cma camlp4fulllib.cma otags.ml
</pre>
We could improve this in many ways (error-handling, patterns, types, etc.); clearly we can't replicate otags in a few dozen lines. But Camlp4 takes care of a lot of the hard work. Next time, maybe, an actual syntax extension.

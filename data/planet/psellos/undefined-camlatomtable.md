---
title: Undefined caml_atom_table
description:
url: http://psellos.com/2014/10/2014.10.atom-table-undef.html
date: 2014-11-03T19:00:00-00:00
preview_image:
featured:
authors:
- Psellos
---

<div class="date">November 3, 2014</div>

<p>This week I spent some time tracking down a problem when linking an
OCaml application for iOS. It turns out that the same problem shows up
when linking for OS X. I can imagine that somebody else might see the
problem someday and wonder what&rsquo;s going on, so I thought I&rsquo;d write it
up.</p>

<p>The problem shows up when you have a C program that calls out to an
OCaml function. I made a tiny example; the C code looks like this
(<code>main.c</code>):</p>

<pre><code>#include &lt;stdio.h&gt;
#include &quot;caml/mlvalues.h&quot;
#include &quot;caml/callback.h&quot;

int main(int ac, char *av[])
{
    value *fact_closure = caml_named_value(&quot;fact&quot;);
    value result = caml_callback(*fact_closure, Val_int(atoi(av[1])));
    printf(&quot;%ld\n&quot;, Long_val(result));
    exit(0);
}</code></pre>

<p>The OCaml code looks like this (<code>fact.ml</code>):</p>

<pre><code>let rec fact n = if n &lt; 2 then 1 else n * fact (n - 1)

let () = Callback.register &quot;fact&quot; fact</code></pre>

<p>If you compile and link this for OS X, you see the following:</p>

<pre><code>$ uname -rs
Darwin 13.3.0
$ ocamlopt -output-obj -o factobj.o fact.ml
$ cc -I /usr/local/lib/ocaml -o cfact main.c factobj.o -L /usr/local/lib/ocaml -lasmrun
Undefined symbols for architecture x86_64:
  &quot;_caml_atom_table&quot;, referenced from:
      _caml_alloc in libasmrun.a(alloc.o)
      _caml_alloc_array in libasmrun.a(alloc.o)
      _caml_alloc_dummy in libasmrun.a(alloc.o)
      _caml_alloc_dummy_float in libasmrun.a(alloc.o)
      _intern_alloc in libasmrun.a(intern.o)
      _intern_rec in libasmrun.a(intern.o)
  &quot;_caml_code_area_end&quot;, referenced from:
      _segv_handler in libasmrun.a(signals_asm.o)
  &quot;_caml_code_area_start&quot;, referenced from:
      _segv_handler in libasmrun.a(signals_asm.o)</code></pre>

<p>This struck me as strange, as these are clearly symbols over which I
have no control. Furthermore, if you look in libasmrun.a, the symbols
are in fact defined:</p>

<pre><code>$ nm /usr/local/lib/ocaml/libasmrun.a | egrep 'atom_table|code_area'
0000000000000800 C _caml_atom_table
0000000000000008 C _caml_code_area_end
0000000000000008 C _caml_code_area_start
                 U _caml_code_area_end
                 U _caml_code_area_start
                 U _caml_atom_table
                 U _caml_atom_table
                 U _caml_atom_table
                 U _caml_atom_table</code></pre>

<p>The <code>C</code> next to their names shows that the symbols are defined. The
other appearances with <code>U</code> are the unsatisfied references that the
linker is complaining about.</p>

<p>One interesting thing, though, is that these are so-called &ldquo;common&rdquo;
symbols. That is, they represent uninitialized (zero-filled) values that
will be added to an executable only if there are no other definitions
that provide an initial value. The technical name for this in C is a
&ldquo;tentative definition.&rdquo; (The justified, ancient name &ldquo;common&rdquo; comes, I
believe, from Fortran of 1958, may it rest in peace.)</p>

<p>To make a long story short, what I found out through web searching and
testing is that Apple decided to change the semantics of common symbols
appearing in libraries. In particular, Apple&rsquo;s archiver <code>ar</code> doesn&rsquo;t
list common symbols in the table of contents (TOC) for an archive like
<code>libasmrun.a</code>. So, although the symbols are defined in individual
modules, they don&rsquo;t appear in the TOC, which is where the linker
actually looks. This means that the symbols will not be found by the
linker unless the module is included for other reasons.</p>

<p>This is a pretty big change from age-old Unix semantics, and if you
search you can find a fair number of developers confused by the
behavior. There&rsquo;s a little more detail on this page at Stack Overflow:</p>

<blockquote>
  <p><a href="http://stackoverflow.com/questions/19398742/os-x-linker-unable-to-find-symbols-from-a-c-file-which-only-contains-variables">OS X linker unable to find symbols from a C file which only contains variables</a></p>
</blockquote>

<p>What&rsquo;s suspicious, however, is that I&rsquo;ve never seen this problem before
when building OCaml apps for OS X or iOS. So why do I see it in this
code?</p>

<p>The answer is that the code is wrong! When setting up a main program in
C that calls out to OCaml, you&rsquo;re supposed to call <code>caml_main()</code> before
things get rolling in your program. The <code>main</code> function is actually
supposed to look like this:</p>

<pre><code>int main(int ac, char *av[])
{
    caml_main(av);
    value *fact_closure = caml_named_value(&quot;fact&quot;);
    value result = caml_callback(*fact_closure, Val_int(atoi(av[1])));
    printf(&quot;%ld\n&quot;, Long_val(result));
    exit(0);
}</code></pre>

<p>If you make this change, everything works totally great:</p>

<pre><code>$ ocamlopt -output-obj -o factobj.o fact.ml
$ cc -I /usr/local/lib/ocaml -o cfact main.c factobj.o -L /usr/local/lib/ocaml -lasmrun
$ cfact 20
2432902008176640000</code></pre>

<p>In summary, although I have some mild reservations about this Apple
change to <code>ar</code>, when building OCaml apps it&rsquo;s actually helpful, as it
indirectly detects the failure to call <code>caml_main()</code>.</p>

<p>To see what I mean, compile and link the original (incorrect) example
under a system with more traditional Unix semantics. On a cloudy 64-bit
Linux system, for example, it looks like this:</p>

<pre><code>$ uname -rs
Linux 3.2.20-1.29.6.amzn1.x86_64
$ ocamlopt -output-obj -o factobj.o fact.ml
$ cc -I /usr/lib64/ocaml -o cfact main.c factobj.o -L /usr/lib64/ocaml -lasmrun -lm -ldl</code></pre>

<p>You notice that there are no problems in the link step. If you try to
run the program, however, you see this:</p>

<pre><code>$ cfact 20
Segmentation fault</code></pre>

<p>The program fails because the registration of <code>fact</code> hasn&rsquo;t taken place.</p>

<p>I hope this may help some other lonely OCaml developer who sees an
undefined atom table. If you have any comments, leave them below or
email me at <a href="mailto:jeffsco@psellos.com">jeffsco@psellos.com</a>.</p>

<p>Posted by: <a href="http://psellos.com/aboutus.html#jeffreya.scofieldphd">Jeffrey</a></p>

<p></p>


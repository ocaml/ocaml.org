---
title: "OCamlPro\u2019s Contributions to OCaml 4.00.0"
description: OCaml 4.00.0 has been released on July 27, 2012. For the first time,
  the new OCaml includes some of the work we have been doing during the last year.
  In this article, I will present our main contributions, mostly funded by Jane Street
  and Lexifi. Binary Annotations for Advanced Development Tools OCa...
url: https://ocamlpro.com/blog/2012_08_20_ocamlpro_contributions_to_400
date: 2012-08-20T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Fabrice Le Fessant\n  "
source:
---

<p>OCaml 4.00.0 has been released on July 27, 2012. For the first time,
the new OCaml includes some of the work we have been doing during the
last year. In this article, I will present our main contributions,
mostly funded by Jane Street and Lexifi.</p>
<h2>Binary Annotations for Advanced Development Tools</h2>
<p>OCaml 4.00.0 has a new option <code>-bin-annot</code> (undocumented, for now, as
it is still being tested). This option tells the compiler to dump in
binary format a compressed version of the typed tree (an abstract
syntax tree with type annotations) to a file (with the <code>.cmt</code>
extension for implementation files, and <code>.cmti</code> for interface
files). This file can then be used by development tools to provide new
features, based on the full knowledge of types in the sources. One of
the first tools to use it is the new version of <code>ocamlspotter</code>, by Jun
Furuse.</p>
<p>This new option will probably make the old option <code>-annot</code> obsolete
(except, maybe, in specific contextes where you don&rsquo;t want to depend
on the internal representation of the typedtree, for example when you
are modifying this representation !). Generated files are much smaller
than with the <code>-annot</code> option, and much faster to write (during
compilation) and to read (for analysis).</p>
<h2>New Options for ocamldep</h2>
<p>As requested on the bug tracker, we implemented a set of new options for ocamldep:</p>
<ul>
<li>
<p><code>-all</code> will print all the dependencies, i.e. not only on .cmi, .cmo and .cmx files, but also on source files, and for .o files. In this mode also, no proxying is performed: if there is no interface file, a bytecode dependency will still appear against the .cmi file, and not against the .cmo file as it would before;</p>
</li>
<li>
<p><code>-one-line</code> will not break dependencies on several lines;</p>
</li>
<li>
<p><code>-sort</code> will print the arguments of ocamldep (filenames) in the order of dependencies, so that the following command should work when all source files are in the same directory:</p>
</li>
</ul>
<pre><code class="language-shell-session">ocamlopt -o my_program `ocamldep -sort *.ml *.mli
</code></pre>
<h2>CFI Directives for Debugging</h2>
<p>OCaml tries to make the best use of available registers and stack
space, and consequently, its layout on the stack is much different
from the one of C functions. Also, function names are mangled to make
them local to their module. As a consequence, debugging native code
OCaml programs has long been a problem with previous versions of
OCaml:, since the debugger cannot print correctly the backtrace of the
stack, nor put breakpoints on OCaml functions.</p>
<p>In OCaml 4.00.0, we worked on a patch submitted on the bug tracker to
improve the situation: x86 and amd64 backends now emit more debugging
directives, such as the locations in the source corresponding to
functions in the assembly (so that you can put breakpoints at function
entry), and CFI directives, indicating the correct stack layout, for
the debugger to correctly unwind the stack. These directives are part
of the DWARF debugging standard.</p>
<p>Unfortunately, line by line stepping is not yet available, but here is an example of session that was not possible with previous versions:</p>
<pre><code class="language-ocaml">let f x y = List.map ( (+) x ) y
let _ = f 3 [1;2;3;4]
</code></pre>
<pre><code class="language-shell-session">$ ocamlopt -g toto.ml
$ gdb ./a.out
(gdb) b toto.ml:1
Breakpoint 1 at 0x4044f4: file toto.ml, line 1.
(gdb) run
Starting program: /home/lefessan/ocaml-4.00.0-example/a.out

Breakpoint 1, 0x00000000004044f4 in camlToto__f_1008 () at toto.ml:1
1 let f x y = List.map ( (+) x ) y
(gdb) bt

0 0x00000000004044f4 in camlToto__f_1008 () at toto.ml:1
1 0x000000000040456c in camlToto__entry () at toto.ml:2
2 0x000000000040407d in caml_program ()
3 0x0000000000415fe6 in caml_start_program ()
4 0x00000000004164b5 in caml_main (argv=0x7fffffffe3f0) at startup.c:189
5 0x0000000000408cdc in main (argc=&lt;optimized out&gt;, argv=&lt;optimized out&gt;)
at main.c:56
(gdb)
</code></pre>
<h2>Optimisation of Partial Function Applications</h2>
<p>Few people know that partial applications with multiple arguments are
not very efficient. For example, do you know how many closures are
dynamically allocated in in the following example ?</p>
<pre><code class="language-ocaml">let f x y z = x + y + z
let sum_list_offsets orig list = List.fold_left (f orig) 0 list
let sum = sum_list_offsets 10 [1;2;3]
</code></pre>
<p>Most programmers would reply one, <code>f orig</code>, but that&rsquo;s not all
(indeed, f and sum_list_offsets are allocated statically, not
dynamically, as they have no free variables). Actually, three more
closures are allocated, when <code>List.fold_left</code> is executed on the list,
one closure per element of the list.</p>
<p>The reason for this is that Ocaml has only two modes to execute
functions: either all arguments are present, or just one
argument. Prior to 4.00.0, when a function would enter the second mode
(as f in the previous example), then it would remain in that mode,
meaning that the two other arguments would be passed one by one,
creating a partial closure between them.</p>
<p>In 4.00.0, we implemented a simple optimization, so that whenever all
the remaining expected arguments are passed at once, no partial
closure is created and the function is immediatly called with all its
arguments, leading to only one dynamic closure creation in the
example.</p>
<h2>Optimized Pipe Operators</h2>
<p>It is sometimes convenient to use the pipe notation in OCaml programs, for example:</p>
<pre><code class="language-ocaml">let (|&gt;) x f = f x;;
let (@@) f x = f x;;
[1;2;3] |&gt; List.map (fun x -&gt; x + 2) |&gt; List.map print_int;;
List.map print_int @@ List.map (fun x -&gt; x + 1 ) @@ [1;2;3];;
</code></pre>
<p>However, such <code>|&gt;</code> and <code>@@</code> operators are currently not optimized: for
example, the last line will be compiled as:</p>
<pre><code class="language-ocaml">let f1 = List.map print_int;;
let f2 = List.map (fun x -&gt; x + 1);;
let x = f2 [1;2;3;];;
f1 x;;
</code></pre>
<p>Which means that partial closures are allocated every time a function
is executed with multiple arguments.</p>
<p>In OCaml 4.00.0, we optimized these operators by providing native
operators, for which no partial closures are generated:</p>
<pre><code class="language-ocaml">external (|&gt;) : &lsquo;a -&gt; (&lsquo;a -&gt; &lsquo;b) -&gt; &lsquo;b = &quot;%revapply&quot;;;
external ( @@ ) : (&lsquo;a -&gt; &lsquo;b) -&gt; &lsquo;a -&gt; &lsquo;b = &quot;%apply&quot;
</code></pre>
<p>Now, the previous example is equivalent to:</p>
<pre><code class="language-ocaml">List.map print_int (List.map ( (+) 1 ) [1;2;3])
</code></pre>
<h2>Bug Fixing</h2>
<p>Of course, a lot of our contributions are not always as visible as the
previous ones. We also spent a lot of time fixing small bugs. Although
it doesn&rsquo;t sound very fun, fixing bugs in OCaml is also fun, because
bugs are often challenging to understand, and even more challenging to
remove without introducing new ones !</p>


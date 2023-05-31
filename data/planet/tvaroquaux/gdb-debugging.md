---
title: Gdb debugging...
description: 'Last month my brother  came to visit and we did what every normal family
  would do: have beer and talk comp-scy. When he asked me how we debu...'
url: https://till-varoquaux.blogspot.com/2011/10/gdb-debugging.html
date: 2011-10-07T16:23:00-00:00
preview_image:
featured:
authors:
- Till
---

<div dir="ltr" style="text-align: left;" trbidi="on">Last month my <a href="http://gael-varoquaux.info/blog/">brother</a> came to visit and we did what every normal family would do: have beer and talk comp-scy. When he asked me how we debugged programs I had to sheepishly admit that I use printf... Part of the issue is that ocaml doesn't have good support for elf debugging annotation (the patch in <a href="http://caml.inria.fr/mantis/view.php?id=4888">PR#4888</a> hopes to address some of that) but it also comes from the fact that I am just not really up to speed on my debugging tools... Printf debugging has nearly no learning curve but it is slow and painful. Tools like gdb,strace,gprof,valgrind come with a steeper learning curve (especially for higher level languages because they require you to peer under the abstraction) but are the way to go in the long run.<br/>
<br/>
So this month is going to be the <b>no printf debugging month</b> which means that I will only start modifying the source code of a programmer to debug it only as a last resort.<br/>
<br/>
<h1>Meet the culprit</h1>Today I had a quick look at a problem with the compiler itself. The compiler segfaulted while compiling code with very long lists (<a href="http://caml.inria.fr/mantis/view.php?id=5368">PR#5368</a>). <br/>
<br/>
The following bash command will generate a file (<code>big_list.ml</code>) that will cause the failure:<br/>
<br/>
<pre><tt>cat <span style="color: #990000;">&gt;</span> big_list<span style="color: #990000;">.</span>ml <span style="color: #990000;">&lt;&lt;</span><b>EOF</b>
<span style="color: #666666;">let big x =[</span>
  <span style="color: #990000;">$(</span>yes <span style="color: red;">&quot;true;&quot;</span> <span style="color: #990000;">|</span> head -n <span style="color: #993399;">100000</span><span style="color: #990000;">)</span>
<span style="color: #666666;"> ]</span>
<b>EOF</b>
</tt></pre><br/>
<h1>Looking at backtraces</h1>This smelled like a stack overflow (the stack size is fixed if you have too many function call chained you blow your stack out and might get a segfault). Sure enough, after raising the size of the stack (<code>ulimit -s 50000</code>)  the compilation ran fine... So we are probably looking for a stack overflow. Those are usually called by non-tail call reccursions and real easy to find:<br/>
<ul><li>load the binary in gdb. with <code> gdb --args ocamlopt.opt big_list.ml </code> <br/>
</li>
<li>run it (<code>run</code>) until it blows up <br/>
</li>
<li>look at the stack (<code>bt</code>) and one or several function should appear all the time.<br/>
</li>
</ul><h1>Using breakpoints</h1>In my case the stacktrace was a bit anti climatic:  <br/>
<pre><tt>#0  0x000000000058150d in camlIdent__find_same_16167 ()
#1  0x0000000000000000 in ?? ()</tt></pre>The lack of proper backtrace could be due to one of several things: <br/>
<ul><li> Ocamlopt's calling convention for function is not the same as C and this could throw of <code>gdb</code><br/>
</li>
<li> the Ocaml run time has code to detect stack overflow (./asmrun/signals_asm.c). It works by registering a signal handler for the SIGSEGV signal and examining the address of the error and raising an exception if anything is wrong. This code is running inside a unix signal; this is a very restricted environment in which you are not allowed to do much (e.g. you cannot call malloc); it might be doing something illegal and/or messing up the stack.<br/>
</li>
</ul>We did however get one function name out of it: <code>camlIdent__find_same_16167</code>. The caml compiler assigns symbols to functions following this naming convention: caml&lt;module name&gt;__&lt;function name&gt;_&lt;integer&gt;. In this case the function is the <code>find_name</code> function in the <code>Ident</code>(typing/ident,ml) module. Let's have a look at who's calling this function by using break points.  No before calling <code>run</code>in <code>gdb</code> we set a breakpoint on the function.  <br/>
<pre><tt>
(gdb) break camlIdent__find_same_16167
Breakpoint 1 at 0x5814f0
(gdb) run
Starting program: /opt/ocaml-exp/bin/ocamlopt.opt big_list.ml

Breakpoint 1, 0x00000000005814f0 in camlIdent__find_same_16167 ()
</tt></pre>We want to let cross this break point enough to have a nice a fat backtrace.  <pre><tt>(gdb) ignore 1 500
Will ignore next 500 crossings of breakpoint 1.
(gdb) continue
Continuing.

Breakpoint 1, 0x00000000005814f0 in camlIdent__find_same_16167 ()
</tt></pre>By looking at the backtrace we can now clearly see that: <code>camlTypecore__type_construct_206357</code> is appearing a lot on the stack and, sure enough, the <code>type_construct</code> in <code>typing/typecore.ml</code> is not tail recursive. In our case the easiest solution is probably to change our code generator to output the list by chunks: <pre>let v0=[]

let v1= true::true:: ..... ::v0
let v2= true::true:: ..... ::v1
....
let v = vn
</pre><h1>Finding function's symbol</h1>Last but not least: of you wanted to put a breakpoint in <code>typecore.ml</code> on the function <code>type_argument</code> you'd have to figure out the symbol name: <pre><tt>&gt; nm /opt/ocaml-exp/bin/ocamlopt.opt | grep camlTypecore__type_argument
0000000000526b70 T camlTypecore__type_argument_206355</tt></pre></div>

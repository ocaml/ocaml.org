---
title: Portable Regular Expressions
description:
url: https://mirage.io/blog/ocaml-regexp
date: 2011-08-12T00:00:00-00:00
preview_image:
featured:
authors:
- Raphael Proust
---


        <p>MirageOS targets different backends: micro-kernels for the Xen hypervisor, Unix
executables and Javascript programs. The recent inclusion of the Javascript
backend makes many C bindings unsuitable. In order to push backend incompatibilities
closer to the application level, it is necessary to either reimplement the C
bindings in Javascript or OCaml, or remove them completely. This is particularly
important for the standard library.</p>
<h2>The <code>Str</code> module has to go!</h2>
<p><code>Str</code> provides regular expressions in a non-reentrant, non-functional fashion.
While the OCaml distribution provides it in <code>otherlibs</code>, it is installed by
default and so widely used, and implemented under the hood via a C library.
Regular expressions are used in several places in MirageOS, mainly for small
operations (splitting, getting an offset, etc.), and so having a portable
fallback written in pure OCaml would be very useful.</p>
<p>There are several possible ways to replace the <code>Str</code> module, each with its own
set of perks and drawbacks:</p>
<ul>
<li>Use a backend-neutral regexp library which &quot;translates&quot; to either <code>Str</code>
or <code>Pcre</code> for the Xen and Unix backends or Javascript native regexps for
the Javascript backend. This solution may be hard to maintain, especially if a
fourth backend is to be included. Moreover each regexp library uses a slightly
different convention for regexps (e.g. see the
<a href="http://vimdoc.sourceforge.net/htmldoc/pattern.html#/magic">magic</a> option in
vim) which means that a lot of translation code might be needed.
</li>
<li>Do string processing without regexps (using <code>String.index</code> and the likes).
This solution is portable and potentially efficient. However, the potential
efficiency comes from a low-level way of doing things.
</li>
<li>Use an OCaml regexp library without C bindings. We expected such a library to
be slower than <code>Str</code> and needed an estimation of performance cost in order to
assess the practicality of the solution.
</li>
</ul>
<h2>Benchmarking <code>Str</code></h2>
<p>There is a purely OCaml regexp library readily available, called <code>Regexp</code> and
developed by Claude March&eacute; from the LRI laboratory. You can find the
documentation and the source on the associated
<a href="http://www.lri.fr/~marche/regexp/">webpage</a>. After getting rid of mutexes
(which, in MirageOS, are of no use, because of the <code>Lwt</code> based
concurrency), we benchmarked it against <code>Str</code>. We also included the popular
<code>Pcre</code> (Perl Compatible Regular Expression) library that is widely used.</p>
<p>The benchmark (available <a href="http://github.com/raphael-proust/regexp-benchmark.git">on github</a>)
is really simple and measures three different factors:</p>
<ul>
<li>regexp construction: the transformation of a string (or another representation
available to the programmer) into the internal representation of regexps used
by the library
</li>
<li>regexp usage: the execution of operations using regexps
</li>
<li>string size: the length of the string being matched
</li>
</ul>
<p>MirageOS uses regexp in a specific pattern: a limited number of regexp
constructions with a potentially high number of invocation (e.g. HTTP header parsing).
The size of the strings on which regexps are used may vary.  Because of this pattern,
our benchmark does not take regexp construction overhead into account.</p>
<p>Here are the execution times of approximately 35000 string matching operations
on strings of 20 to 60 bytes long.</p>
<img src="https://mirage.io/graphics/all_1_1000_10.png"/>
<p>Quite surprisingly for the string matching operation, the C based <code>Str</code> module
is less efficient than the pure OCaml <code>Regexp</code>. The <code>Pcre</code> results were even worse
than <code>Str</code>. Why?</p>
<h3>A simple library for a simple task</h3>
<p>The <code>Regexp</code> library is lightweight, and so far faster than its C based
counterparts. One of the features <code>Regexp</code> lacks is &quot;group capture&quot;: the ability
to refer to blocks of a previously matched string. In <code>Pcre</code> it is possible to
explicitly and selectively turn group capturing off via special syntax,
instead of the regular parentheses. <code>Str</code> does not offer  this, and thus
imposes the runtime cost of capture even when not necessary. In other words, the
slowdown/group capturing &quot;is not a feature, it's a bug!&quot;</p>
<h3>The MirageOS Regexp library</h3>
<p>With the introduction of <code>Regexp</code> into the tree, the libraries available to MirageOS
applications are now <code>Str</code>-free and safer to use across multiple backends. The main
drawback is a slight increase in verbosity of some parts of the code.
Benchmarking the substitution operation is also necessary to assess the
performance gain/loss (which we will do shortly).</p>
<p>In addition to cosmetic and speed considerations, it is important to consider the
portability increase: MirageOS's standard library is <a href="http://nodejs.org">Node.js</a> compatible,
a feature we will explore shortly!</p>

      

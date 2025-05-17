---
title: "Everything is a file; except when it\u2019s not"
description: "Some titles make more sense than others. One of my oldest contributions
  to OCaml was a complete overhaul of Unix.stat et al in ocaml/ocaml#462 which formed
  part of OCaml 4.03. As part of the work on msvs-detect in late 2015, I\u2019d ended
  up with a Windows 7 VM which had every single version of Visual Studio back to Visual
  Studio 6.0. Visual Studio (and Visual C++ before that) has always included the source
  code for the C Runtime Library (CRT), and as a side-effect of having all these installed
  Visual Studios, I was able to construct a Git repository showing the evolution of
  the CRT code over each release (sadly, the licence doesn\u2019t allow this to be
  pushed publicly). This was particularly useful for studying how the behaviour of
  the stat implementation had changed over time, particularly with reference to Windows
  Vista\u2019s symlinks. Anyway, that particular bit of work left me with a habit
  of often reaching for the CRT whenever something weird\u2019s happening, and that\u2019s
  led naturally to a fairly detailed bug-fix - and outline for more bug-fixes - in
  OCaml."
url: https://www.dra27.uk/blog/platform/2025/04/03/cloexec.html
date: 2025-04-03T00:00:00-00:00
preview_image:
authors:
- ""
source:
---

<p>Some titles make more sense than others. One of my oldest contributions to OCaml
was a complete overhaul of <a href="https://ocaml.org/p/ocaml-base-compiler/5.2.1/doc/Unix/index.html#file-status"><code class="language-plaintext highlighter-rouge">Unix.stat</code> et al</a>
in <a href="https://github.com/ocaml/ocaml/pull/462">ocaml/ocaml#462</a> which formed part
of OCaml 4.03. As part of the work on <a href="https://ocaml.org/p/msvs-detect/latest"><code class="language-plaintext highlighter-rouge">msvs-detect</code></a>
in late 2015, I’d ended up with a Windows 7 VM which had every single version of
Visual Studio back to <a href="https://en.wikipedia.org/wiki/Visual_Studio#6.0_(1998)">Visual Studio 6.0</a>.
Visual Studio (and Visual C++ before that) has always included the source code
for the C Runtime Library (CRT), and as a side-effect of having all these
installed Visual Studios, I was able to construct a Git repository showing the
evolution of the CRT code over each release (sadly, the licence doesn’t allow
this to be pushed publicly). This was particularly useful for studying how the
behaviour of the <code class="language-plaintext highlighter-rouge">stat</code> implementation had changed over time, particularly with
reference to Windows Vista’s symlinks. Anyway, that particular bit of work left
me with a habit of often reaching for the CRT whenever something weird’s
happening, and that’s led naturally to a fairly detailed bug-fix - and outline
for more bug-fixes - in OCaml.</p>

<p>As part of my ongoing work on Relocatable OCaml, I wanted to have a test to
check that file descriptors set with <em>keep-on-exec</em> were being correctly passed
to Windows processes. While looking through the tests already present for the
Unix library, I happened upon <a href="https://github.com/ocaml/ocaml/blob/0a7c5fe35f4be2ea5c834b586fb5e947bd952377/testsuite/tests/lib-unix/common/cloexec.ml"><code class="language-plaintext highlighter-rouge">testsuite/tests/lib-unix/common/cloexec.ml</code></a>
and in particular this interesting comment in its preamble:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>This test is temporarily disabled on the MinGW and MSVC ports,
because since fdstatus has been wrapped in an OCaml program,
it does not work as well as before.
Presumably this is because the OCaml runtime opens files, so that handles
that have actually been closed at execution look open and make the
test fail.
</code></pre></div></div>

<p>The test actually formed part of <a href="https://github.com/ocaml/ocaml/pull/650">ocaml/ocaml#650</a>
in OCaml 4.05, which added <code class="language-plaintext highlighter-rouge">?cloexec</code> parameters to various Unix functions. The
test looked perfect for my needs, but the comment above had been added a year or
so later when the test was upgraded to use <code class="language-plaintext highlighter-rouge">ocamltest</code> instead. The bug I was
actually trying to fix in Relocatable OCaml - and which had caused all the
spelunking into the Microsoft CRT code - was to do with how file descriptors are
physically inherited by processes. On a Unix system, the CRT and the kernel are
quite closely related as a consequence of the relationship between the Single
Unix Specification and the C Standard, but on Windows the heritage is a bit more
complicated. Various functions - the <code class="language-plaintext highlighter-rouge">exec</code> and <code class="language-plaintext highlighter-rouge">spawn</code> functions included -
are very much user-level functions implemented over different kernel primitives,
rather than being either direct syscalls, or at most very thin wrappers around
direct syscalls.</p>

<p>Windows doesn’t have file descriptors (“FDs”), rather it has <a href="https://learn.microsoft.com/en-us/windows/win32/sysinfo/handles-and-objects"><code class="language-plaintext highlighter-rouge">HANDLE</code>s</a>.
Although Windows doesn’t follow the Unix <a href="https://en.wikipedia.org/wiki/Everything_is_a_file">“Everything is a file”</a>
philosophy, the values for <code class="language-plaintext highlighter-rouge">HANDLE</code> sort of do (mainly because they’re
pointers/indexes into kernel information structures for the process). The
original version of this test, knowing that Windows doesn’t really have FDs, had
passed the <code class="language-plaintext highlighter-rouge">HANDLE</code> values instead. The crux of this test is to pass a series of
FD values on the command line to a small auxiliary program and have it test
which ones are still open - the <em>close-on-exec</em> ones, should obviously not be in
use. This works on Unix, because while the OCaml runtime may open some files
during startup, they are all closed by the time the program itself is running,
so the state of the FDs should be unaltered.</p>

<p>On Windows, with it’s <code class="language-plaintext highlighter-rouge">HANDLE</code> version instead, this had worked fine in the
original test where the checker being invoked was a simple C program, but it had
hit problems when that simple C program was changed to a simple OCaml program.
I realised that the instability here was that whereas any FDs which were opened
by the runtime would be closed by the time the program ran, the same was not
true for <code class="language-plaintext highlighter-rouge">HANDLE</code>s <em>which were not files</em>. This was a slight variation on the
comment in the test - the point is that the <code class="language-plaintext highlighter-rouge">HANDLE</code>s which occasionally
appeared open were not in fact files at all, and so perfectly allowed to be
still open.</p>

<p>But… Windows does in fact have support for inheriting FD values across
<code class="language-plaintext highlighter-rouge">exec</code> calls. There’s a <a href="https://www.catch22.net/tuts/system/undocumented-createprocess/">lovely survey</a>
of the mechanism in Windows which is present for this, as an undocumented part
of <a href="https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-createprocessw"><code class="language-plaintext highlighter-rouge">CreateProcess</code></a>,
and the code which does it can be seen in the Universal CRT sources in
<code class="language-plaintext highlighter-rouge">exec/spawnv.cpp</code> and <code class="language-plaintext highlighter-rouge">lowio/ioinit.cpp</code>. Our implementation of
<code class="language-plaintext highlighter-rouge">Unix.create_process</code> is implemented directly in terms of Windows API calls,
which completely breaks this mechanism (that’s filed away for the future: we
should reimplement our <code class="language-plaintext highlighter-rouge">create_process</code> function in terms of the CRT’s own
<code class="language-plaintext highlighter-rouge">spawn</code> function in order not to break this). However, the <code class="language-plaintext highlighter-rouge">Unix.exec</code> functions
call the CRT equivalents directly. These functions are normally pretty useless
on Windows, because they work by spawning a new process and then immediately
terminating the current one, which means you can’t block or retrieve the actual
exit status. Luckily <code class="language-plaintext highlighter-rouge">ocamltest</code> already has some magic added in <a href="https://github.com/ocaml/ocaml/pull/1739">ocaml/ocaml#1739</a>
which means that it doesn’t continue until every process created by the item
being tested has itself terminated. The success or failure of this test is
determined by the output it produces, rather than the exit status, so for the
first time ever for me, <code class="language-plaintext highlighter-rouge">Unix.execv</code> was actually able to be used on Windows!</p>

<p>The switch allowed most of the special-case code for Windows to be removed in
the C portion of the test - we’re just dealing with FDs in the same way as on
Unix. However, given that <code class="language-plaintext highlighter-rouge">Unix.create_process</code> is presently “broken” on
Windows (inasmuch as it doesn’t actually pass the FD values to the new process),
I made the test work for both mechanisms, to record the “TODO” item for fixing
<code class="language-plaintext highlighter-rouge">Unix.create_process</code> on Windows at some point.</p>

<p>Finally, I was able to adapt the test for what I needed in Relocatable OCaml,
but the changes made up to this point were good to go upstream, and formed
<a href="https://github.com/ocaml/ocaml/pull/13879">ocaml/ocaml#13879</a>. It’s a testsuite
fix only, and it got merged quite quickly (thank you <a href="https://github.com/gasche">Gabriel</a>!).</p>

<p>Everything was rosy. Except that when I was preparing Relocatable OCaml for last
week’s Developer’s meeting in Paris, I spotted that several of my test runs on
our <a href="https://ci.inria.fr/ocaml/job/precheck">“precheck infrastructure”</a> were
failing that test. Searching logs further, I found that since my PR had been
merged, the test was sporadically failing. Mostly, the failure was:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>Fatal error: exception Sys_error("tmp.txt: Permission denied")
</code></pre></div></div>

<p>which looked suspiciously like Windows Defender or some such was getting in the
way. Irritating, but a known issue to have to fix. What was however not so good
was an instance of:</p>

<div class="language-diff highlighter-rouge"><div class="highlight"><pre class="highlight"><code> #19: open
<span class="gd">-#20: closed
</span><span class="gi">+#20: open
</span> #21: closed
</code></pre></div></div>

<p>A descriptor which was meant to be closed was open?! Something more complex
 clearly still going on. But that’s for next time…</p>

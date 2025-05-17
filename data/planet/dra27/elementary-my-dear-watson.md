---
title: Elementary, my dear Watson
description: "Overall, I enjoy bug-hunting. Getting there can be really quite tortuous,
  via the fairly typical \u201Coh my goodness, why do I do this?\u201D, but there\u2019s
  something inordinately satisfying about arriving at a complete and convincing explanation
  not only for what is going wrong but also for why it was only sometimes wrong. I
  find the satisfaction is in inverse proportion to the size of the fix then required:
  the best of these fixes have pages of explanation followed by a miniscule diff.
  A couple of old personal scalps of mine include the path from a random failure in
  a debugger test (see ocaml/ocaml#9043) only seen with specific-code-alignment-on-one-CI-worker
  to a missing GC root registration fixed in ocaml/ocaml#9051 (and which I\u2019d
  allowed to become masked in the past by automatically allowing re-running \u2018unstable\u2019
  tests in ocaml/ocaml#401; a technique I\u2019d strongly recommend never using again!)
  and the relationship between Unix.fork only failing on every other invocation in
  the OCaml REPL on Cygwin, and an unstable topological sort (see cygwin/cygwin#226f694).
  My personal favourite is not mine, though, which is the wonderful alignment of compiler
  planets required in ocaml/ocaml#10071. Obligatory xkcd."
url: https://www.dra27.uk/blog/platform/2025/04/11/cloexec2.html
date: 2025-04-11T00:00:00-00:00
preview_image:
authors:
- ""
source:
---

<p>Overall, I enjoy bug-hunting. Getting there can be really quite tortuous, via
the fairly typical “oh my goodness, why do I do this?”, but there’s something
inordinately satisfying about arriving at a complete and convincing explanation
not only for what is going wrong but also for why it was only <em>sometimes</em> wrong.
I find the satisfaction is in inverse proportion to the size of the fix then
required: the best of these fixes have pages of explanation followed by a
miniscule diff. A couple of old personal scalps of mine include the path from a
random failure in a debugger test (see <a href="https://github.com/ocaml/ocaml/issues/9043">ocaml/ocaml#9043</a>)
only seen with specific-code-alignment-on-one-CI-worker to a missing GC root
registration fixed in <a href="https://github.com/ocaml/ocaml/pull/9051/commits/81f9cb190380c64b63aa599b188fa68b4d77f6f6">ocaml/ocaml#9051</a>
(and which I’d allowed to become masked in the past by automatically allowing
re-running ‘unstable’ tests in <a href="https://github.com/ocaml/ocaml/pull/401">ocaml/ocaml#401</a>;
a technique I’d strongly recommend <strong>never</strong> using again!) and the relationship
between <code class="language-plaintext highlighter-rouge">Unix.fork</code> only failing on every <em>other</em> invocation in the OCaml REPL
on Cygwin, and an unstable topological sort (see <a href="https://github.com/cygwin/cygwin/commit/226f69422a44bbd177da6d8f3e1771f3b786fb0c">cygwin/cygwin#226f694</a>). My personal favourite is not mine, though, which is the wonderful
alignment of compiler planets required in <a href="https://github.com/ocaml/ocaml/pull/10071">ocaml/ocaml#10071</a>.
Obligatory <a href="https://www.xkcd.com/1722/">xkcd</a>.</p>

<p>Anyway, something I find to be a common pitfall when debugging these things is
the temptation to start fixing the area of code one <em>thinks</em> is wrong, even if
there isn’t a logical explanation for why the code being “fixed” is in any way
related to the actual failure being seen. Which brings us back to <a href="https://www.dra27.uk/blog/platform/2025/04/03/cloexec.html">the mystery
of the failing cloexec test</a> from last week.</p>

<p>This test was creating a file <code class="language-plaintext highlighter-rouge">tmp.txt</code>, opening it various ways and marking the
handles as inheritable. My previous changes had switched the test to use <code class="language-plaintext highlighter-rouge">execv</code>
and the resulting <code class="language-plaintext highlighter-rouge">exec</code>’d process was expected to delete this file, except it
was occasionally getting:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>Fatal error: exception Sys_error("tmp.txt: Permission denied")
</code></pre></div></div>

<p>from <a href="https://github.com/ocaml/ocaml/blob/331b5e64a174f47da6b37fa47bf23acdf1625399/testsuite/tests/lib-unix/common/fdstatus_main.ml#L10-L11">these lines</a>:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code>  <span class="k">if</span> <span class="nn">Sys</span><span class="p">.</span><span class="n">argv</span><span class="o">.</span><span class="p">(</span><span class="mi">1</span><span class="p">)</span> <span class="o">=</span> <span class="s2">"execv"</span> <span class="k">then</span>
    <span class="nn">Sys</span><span class="p">.</span><span class="n">remove</span> <span class="s2">"tmp.txt"</span>
</code></pre></div></div>

<p>On Windows, the file can’t be deleted until all open handles to it are closed
(that’s just one of those things). Pretty sure OCaml’s Unix library was
functioning correctly (avoid temptation to debug that; polish halo). So what
scenario could cause this file still be open. The odd thing here is how <code class="language-plaintext highlighter-rouge">execv</code>
is implemented on Windows, as it’s a library function rather than a kernel
function:</p>

<div class="language-c++ highlighter-rouge"><div class="highlight"><pre class="highlight"><code>    <span class="n">PROCESS_INFORMATION</span> <span class="n">process_info</span><span class="p">;</span>
    <span class="n">BOOL</span> <span class="k">const</span> <span class="n">create_process_status</span> <span class="o">=</span> <span class="n">traits</span><span class="o">::</span><span class="n">create_process</span><span class="p">(</span>
        <span class="k">const_cast</span><span class="o">&lt;</span><span class="n">Character</span><span class="o">*&gt;</span><span class="p">(</span><span class="n">file_name</span><span class="p">),</span>
        <span class="n">command_line</span><span class="p">.</span><span class="n">get</span><span class="p">(),</span>
        <span class="nb">nullptr</span><span class="p">,</span>
        <span class="nb">nullptr</span><span class="p">,</span>
        <span class="n">TRUE</span><span class="p">,</span>
        <span class="n">creation_flags</span><span class="p">,</span>
        <span class="n">environment_block</span><span class="p">.</span><span class="n">get</span><span class="p">(),</span>
        <span class="nb">nullptr</span><span class="p">,</span>
        <span class="o">&amp;</span><span class="n">startup_info</span><span class="p">,</span>
        <span class="o">&amp;</span><span class="n">process_info</span><span class="p">);</span>

    <span class="n">__crt_unique_handle</span> <span class="nf">process_handle</span><span class="p">(</span><span class="n">process_info</span><span class="p">.</span><span class="n">hProcess</span><span class="p">);</span>
    <span class="n">__crt_unique_handle</span> <span class="nf">thread_handle</span><span class="p">(</span><span class="n">process_info</span><span class="p">.</span><span class="n">hThread</span><span class="p">);</span>

    <span class="k">if</span> <span class="p">(</span><span class="o">!</span><span class="n">create_process_status</span><span class="p">)</span>
    <span class="p">{</span>
        <span class="n">__acrt_errno_map_os_error</span><span class="p">(</span><span class="n">GetLastError</span><span class="p">());</span>
        <span class="k">return</span> <span class="o">-</span><span class="mi">1</span><span class="p">;</span>
    <span class="p">}</span>

    <span class="k">if</span> <span class="p">(</span><span class="n">mode</span> <span class="o">==</span> <span class="n">_P_OVERLAY</span><span class="p">)</span>
    <span class="p">{</span>
        <span class="c1">// Destroy ourselves:</span>
        <span class="n">_exit</span><span class="p">(</span><span class="mi">0</span><span class="p">);</span>
    <span class="p">}</span>
</code></pre></div></div>

<p>(the code is excerpted from <code class="language-plaintext highlighter-rouge">ucrt/exec/spawnv.cpp</code> in UCRT 10.0.22621.0,
available in Microsoft Visual Studio). There is a small window between that
<code class="language-plaintext highlighter-rouge">create_process</code> call and the subsequent <code class="language-plaintext highlighter-rouge">_exit(0)</code> where <code class="language-plaintext highlighter-rouge">tmp.txt</code> would be
open in <em>both</em> the “ancestor” process and the <code class="language-plaintext highlighter-rouge">exec</code>’d process. Our CI systems
run on small VMs, and the testsuite is run in parallel, so the machine is very
much overloaded. Maybe it was just about possible for the overloaded Windows
scheduler to run the <code class="language-plaintext highlighter-rouge">exec</code>’d process all the way to completion before actually
giving the original process enough chance to get to <code class="language-plaintext highlighter-rouge">_exit</code> for its handles to
be closed?</p>

<p>That led to <a href="https://github.com/ocaml/ocaml/pull/13921/commits/55e9cd44ed34d6a62b83d1a608a15de709df5b1e">commit 55e9cd44</a>:
but it wasn’t enough. The test was still failing. At least that wasn’t wasted
work - the race condition <strong>is</strong> real, and the locking added ensured that
scenario couldn’t arise, but it certainly seems that it wasn’t the issue being
seen.</p>

<p>Still managing to resist the temptation to debug the Unix library further (halo
looking very shiny by this time), the next candidate is to blame Windows
Defender. On Windows, virus scanners are given the opportunity to scan files
after they’ve been closed - unfortunately, virus scanner are programs, just like
anything else, which means that they do then have to open the files. That’s a
known problem then when trying to delete those files soon after. While it seems
odd that we could be seeing such a delay for a file with no content, recall that
the testsuite runs in parallel. It <em>could</em> be that the file is open and waiting
to be scanned, and that’s taking time because <em>other</em> tests (with executables,
for example), are swamping the system.</p>

<p>The sledgehammer approach for this is to add a retry loop around the delete
call. In most cases, this is a perfectly adequate approach - it usually only
takes a few milliseconds. But that got me thinking as to what a suitable number
of seconds to wait would be - the machine’s overloaded, after all. So I tried
something different in <a href="https://github.com/ocaml/ocaml/pull/13921/commits/78fc5774e856cfbe133750c66dfab48e3ab75452">commit 78fc5774</a>
by using the slightly obscure <code class="language-plaintext highlighter-rouge">FILE_FLAG_DELETE_ON_CLOSE</code> flag for <a href="https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilew"><code class="language-plaintext highlighter-rouge">CreateFileW</code></a>.
Using this flag requires all instances of the file to be opened with
<code class="language-plaintext highlighter-rouge">FILE_SHARE_DELETE</code>, but fortunately that flag is already exposed in OCaml’s
Unix library (and that doesn’t affect the test) and the test already needs some
custom C code, so a little bit more won’t hurt. The idea is simple: on Windows,
when the program begins, we open the file with this special flag and then just
discard the handle. When the test ends, Windows will automatically close the
file handle and when it does so, it’ll be <em>Windows</em> responsibility to ensure the
file is cleaned up.</p>

<p>That got it! And it turned out that it was definitely worth worrying about the
time that it would be necessary to “spin” - our precheck system reports tests
which are slow-running, and that file deletion can take 12-20 seconds on our
poor overloaded machines!</p>

<p>Well, that was most of the failing logs dealt with, but there was still this
failure left:</p>

<div class="language-diff highlighter-rouge"><div class="highlight"><pre class="highlight"><code> #19: open
<span class="gd">-#20: closed
</span><span class="gi">+#20: open
</span> #21: closed
</code></pre></div></div>

<p>As it happened, I’d seen this in a couple of places, and the only pattern was
that a descriptor which was expected to be <em>closed</em> was <em>open</em>. I added some
annotations in the test to relate the descriptor number to the function being
tested. My previously gleaming halo was getting a bit tarnished at this point:
could it actually be a bug in the Unix library?! It <em>still</em> didn’t feel it could
be though - why was the failure sporadic? Why was it seemingly only ever just
the one closed handle? Why, for that matter, was it only closed handles?</p>

<p>However, staring in frustration at some self-evidently correct C code, the penny
suddenly dropped. The way both channels and file descriptors are implemented in
Windows OCaml is tremendously complicated, but for the most part in the Unix
library, the CRT is bypassed, and we call Windows API functions directly
(e.g. we use <code class="language-plaintext highlighter-rouge">CreateFileW</code> rather than <a href="https://learn.microsoft.com/en-us/cpp/c-runtime-library/reference/open-wopen"><code class="language-plaintext highlighter-rouge">_wopen</code></a>)
for <code class="language-plaintext highlighter-rouge">Unix.openfile</code>). All the <em>close-on-exec</em> stuff was obviously setting the
Windows <code class="language-plaintext highlighter-rouge">HANDLE</code> to be correctly inheritable (or nothing would be working), but
what was happening now with the file descriptors?</p>

<p>It turns out that while <a href="https://learn.microsoft.com/en-us/cpp/c-runtime-library/reference/open-osfhandle"><code class="language-plaintext highlighter-rouge">_open_osfhandle</code></a>
does check for some properties of the <code class="language-plaintext highlighter-rouge">HANDLE</code> it’s given automatically, it does
not call <a href="https://learn.microsoft.com/en-us/windows/win32/api/handleapi/nf-handleapi-gethandleinformation"><code class="language-plaintext highlighter-rouge">GetHandleInformation</code></a>
to see if it’s been marked as inheritable.</p>

<p>That led to the third <a href="https://github.com/ocaml/ocaml/pull/13921/commits/aa67aa695431e6a56c93d33c06d7e72755588ec0">commit aa67aa6</a>,
which checks the <code class="language-plaintext highlighter-rouge">HANDLE</code> itself and if it is <em>not</em> meant to be inheritable,
also passes the <code class="language-plaintext highlighter-rouge">O_NOINHERIT</code> flag to <code class="language-plaintext highlighter-rouge">_open_osfhandle</code>.</p>

<p>Bug found, problem solved, right? Does <em>this fix</em> explain what was being seen on
the test failures? It turns out it does. We have a whole series of Windows
<code class="language-plaintext highlighter-rouge">HANDLE</code> values, some of which are marked inheritable and some of which are not.
Previously, we were then acquiring a CRT file descriptor for <em>all</em> of those
<code class="language-plaintext highlighter-rouge">HANDLE</code> values. However, because OCaml was never passing <code class="language-plaintext highlighter-rouge">O_NOINHERIT</code> to
<code class="language-plaintext highlighter-rouge">_open_osfhandle</code>, all of those file descriptors would be marked as inheritable.</p>

<p>What then happens comes back to those lovely internal details of how <code class="language-plaintext highlighter-rouge">exec</code> is
actually implemented. All of those file descriptors are <em>not</em> marked
<code class="language-plaintext highlighter-rouge">O_NOINHERIT</code> which means that the CRT will pass their Windows <code class="language-plaintext highlighter-rouge">HANDLE</code> values
to the <code class="language-plaintext highlighter-rouge">exec</code>’d process. However, because those <code class="language-plaintext highlighter-rouge">HANDLE</code> values are <em>not</em> marked
as inheritable, the new process <strong>may reuse them</strong>. In other words, we
accidentally ended up with exactly the problem that switching to CRT file
descriptors was meant to have eliminated - Windows has re-used the <code class="language-plaintext highlighter-rouge">HANDLE</code>
value, because it wasn’t in use.</p>

<p>Bingo! Bugs fixed - and the explanation (hopefully) explains all the evidence.
Elementary, my dear Watson…</p>

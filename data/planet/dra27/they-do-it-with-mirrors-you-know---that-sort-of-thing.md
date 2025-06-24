---
title: They do it with mirrors, you know - that sort of thing
description: "While comfort-watching the indomitable Joan Hickson as Agatha Christie\u2019s
  Miss Marple in The Body in the Library, it occurred to me that Miss Marple would
  have been a formidable debugger. Since returning from holiday one, two, three weeks
  ago, I\u2019ve been mostly straightening out and finalising the final Relocatable
  OCaml PR. A frustrating task, because I know these things will take weeks and have
  little to show for at the end, so one spends the entire time feeling it should be
  finished by now. It\u2019s just about there, when this little testsuite failure
  popped up:"
url: https://www.dra27.uk/blog/platform/2025/06/22/they-do-it-with-mirrors.html
date: 2025-06-22T00:00:00-00:00
preview_image:
authors:
- ""
source:
ignore:
---

<p>While comfort-watching the indomitable <a href="https://en.wikipedia.org/wiki/Joan_Hickson">Joan Hickson</a>
as Agatha Christie’s <a href="https://en.wikipedia.org/wiki/Miss_Marple_(TV_series)">Miss Marple</a>
in <a href="https://en.wikipedia.org/wiki/The_Body_in_the_Library_(film)">The Body in the Library</a>,
it occurred to me that Miss Marple would have been a formidable debugger. Since
returning from holiday <del>one</del>, <del>two</del>, three weeks ago, I’ve been mostly
straightening out and finalising the final Relocatable OCaml PR. A frustrating
task, because I know these things will take weeks and have little to show for at
the end, so one spends the entire time feeling it should be finished by now.
It’s just about there, when this little testsuite failure popped up:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>List of failed tests:
    tests/lib-unix/common/cloexec.ml
    tests/warnings/mnemonics.mll
</code></pre></div></div>

<p>In both cases there was a similar, very strange-looking error:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>the file '/home/runner/work/ocaml/ocaml/testsuite/tests/lib-unix/_ocamltest/tests/lib-unix/common/cloexec/ocamlc.byte/cloexec_leap.exe' is not a bytecode executable file
</code></pre></div></div>

<p>and</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>the file '/home/runner/work/ocaml/ocaml/testsuite/tests/warnings/_ocamltest/tests/warnings/mnemonics/ocamlc.byte/mnemonics.byte' is not a bytecode executable file
Fatal error: exception File "mnemonics.mll", line 55, characters 2-8: Assertion failed
</code></pre></div></div>

<p>Now, as it happens, the diagnosis of <em>what</em> was happening was relatively quick
for me. I’ve dusted off and thrown around so many obscure bits of the runtime
system on so many diverse configurations and platforms with Relocatable OCaml
that it’s resulted in a lot of other bugs being fixed <em>before</em> the main PRs,
some bugs fixed <em>with</em> the main PRs and then a pile of follow-up work with the
additional parts. There’s one particularly long-standing bug on Windows:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>C:\Users\DRA&gt;where ocamlc.byte
C:\Users\DRA\AppData\Local\opam\default\bin\ocamlc.byte.exe

C:\Users\DRA&gt;where ocamlc.byte.exe
C:\Users\DRA\AppData\Local\opam\default\bin\ocamlc.byte.exe

C:\Users\DRA&gt;ocamlc.byte.exe --version
5.2.0

C:\Users\DRA&gt;ocamlc.byte --version
unknown option --version
</code></pre></div></div>

<p>Strange, huh: <code class="language-plaintext highlighter-rouge">ocamlc.byte.exe</code> does one thing and <code class="language-plaintext highlighter-rouge">ocamlc.byte</code> does another!
The precise diagnosis of what’s going on there is nearly a novel in itself. The
fix is quite involved, and is at the “might get put into PR 3; might be left for
the future” stage. The failures across CI were just the Unix builds which use
the stub launcher for bytecode (it’s an obscure corner of startup which lives in
<a href="https://github.com/ocaml/ocaml/tree/trunk/stdlib/header.c"><code class="language-plaintext highlighter-rouge">stdlib/header.c</code></a>
and which has received a pre-Relocatable overhaul in <a href="https://github.com/ocaml/ocaml/pull/13988">ocaml/ocaml#13988</a>).
There are so many bits to Relocatable OCaml that I have a master script that
puts them all together and then backports them: the CI failure was only on the
“trunk” version of this, the 5.4, 5.3 and 5.2 versions passing as normal. The
backports don’t include the “future” work, so that quickly pointed me at the
work sitting in <a href="https://github.com/dra27/ocaml/pull/190/commits">dra27/ocaml#190</a>.</p>

<p>Both those failures are from tests which themselves spawn executables as part of
the test. What was particularly strange was mnemonics because that doesn’t call
itself, rather it calls the compiler:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">mnemonics</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">stdout</span> <span class="o">=</span> <span class="s2">"warn-help.out"</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">n</span> <span class="o">=</span>
    <span class="nn">Sys</span><span class="p">.</span><span class="n">command</span>
      <span class="nn">Filename</span><span class="p">.(</span><span class="n">quote_command</span> <span class="o">~</span><span class="n">stdout</span>
                  <span class="n">ocamlrun</span> <span class="p">[</span><span class="n">concat</span> <span class="n">ocamlsrcdir</span> <span class="s2">"ocamlc"</span><span class="p">;</span> <span class="s2">"-warn-help"</span><span class="p">])</span>
  <span class="k">in</span>
  <span class="k">assert</span> <span class="p">(</span><span class="n">n</span> <span class="o">=</span> <span class="mi">0</span><span class="p">);</span>
</code></pre></div></div>

<p>That’s invoking the <code class="language-plaintext highlighter-rouge">ocamlc</code> bytecode binary from the root of the build tree
passing it as an argument directly to <code class="language-plaintext highlighter-rouge">runtime/ocamlrun</code> in the root of the
build tree. The fact that ocamlrun is then displaying a message referring to
<code class="language-plaintext highlighter-rouge">mnemonics.byte</code> is very strange, but was down to a bug in my fix for this other
issue. The core of the bug-fix is that the stub launcher, having opened the
bytecode image to find its <code class="language-plaintext highlighter-rouge">RNTM</code> section so it can search for the runtime to
call now leaves the file descriptor open and hands its number over to <code class="language-plaintext highlighter-rouge">ocamlrun</code>
as part of the <code class="language-plaintext highlighter-rouge">exec</code> call (works on Windows as well). The problem was the
cleanup from this in <code class="language-plaintext highlighter-rouge">ocamlrun</code> itself, where that environment is reset having
been consumed:</p>

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="cp">#if defined(_WIN32)
</span>  <span class="n">_wputenv</span><span class="p">(</span><span class="s">L"__OCAML_EXEC_FD="</span><span class="p">);</span>
<span class="cp">#elif defined(HAS_SETENV_UNSETENV)
</span>  <span class="n">unsetenv</span><span class="p">(</span><span class="s">"__OCAML_EXEC_FD="</span><span class="p">);</span>
<span class="cp">#endif
</span></code></pre></div></div>

<p>There’s a stray <code class="language-plaintext highlighter-rouge">=</code> at the end of the Unix branch there 🫣 Right, problem solved
and, were I Inspector Slack, I should have zipped straight round to Basil
Blake’s gaudy cottage, handcuffs at the ready.</p>

<p>But what about the second murder? Which, in this case, is why the heck hadn’t
this been seen before? That’s the kind of thing that terrifies me with a fix
like this: the bug is obvious, but was something else being masked and, more to
the point, have I just changed something which introduced a <em>different</em> bug
which happened to cause this one to be visible. At this point, I made a note,
closed my laptop, and returned to my knitting (no, wait, that was Miss Marple).
Then the penny dropped: the compiler’s being configured here with
<code class="language-plaintext highlighter-rouge">--with-target-sh=exe</code> (on Unix, that means that bytecode executables
intentionally avoid shebang-style scripts and use the stub), which should mean
that those two tests are compiled using the stub. Except that because we test
the compiler in the build tree, previously the compiler picks up
<code class="language-plaintext highlighter-rouge">stdlib/runtime-launch-info</code> which is the <em>build</em> version of that header, not
the <em>target</em> version. However, one of the refactorings I’ve done in <a href="https://github.com/dra27/ocaml/pull/189/commits/c60e4aafcf97bde037445e4cd94a9e659caf072a">c60e4aaf</a>
stops using <code class="language-plaintext highlighter-rouge">runtime-launch-info</code> this way (I introduced that header in <a href="https://github.com/ocaml/ocaml/pull/12751">ocaml/ocaml#12751</a>
as part of OCaml 5.2.0). A side-effect of that change is that
<code class="language-plaintext highlighter-rouge">stdlib/runtime-launch-info</code> is actually the target version of the header, and
the <em>root</em> bytecode compiler is <em>now</em> behaving as we’d always been expecting it
to that test, using target configuration defined in <code class="language-plaintext highlighter-rouge">utils/config.ml</code>… and so
only now revealing this latent bug in my fix.</p>

<p><em>“They do it with mirrors, you know-that sort of thing-if you understand me.”
Inspector Curry did not understand. He stared and wondered if Miss Marple was
quite right in the head.</em></p>

---
title: A first foray into agentic coding
description: "I\u2019ve been largely steering clear of the AI bandwagon up to now,
  mainly because the last thing I needed while working on Relocatable OCaml was to
  be trying to learn a new tool at the same time as finishing something which felt
  desperately late and which, at times, I myself didn\u2019t fully understand! However,
  as the buzz of the announcement dies down, I had a first go at pointing Claude Code
  to the OCaml compiler codebase, and thought I\u2019d add to the general noise of
  AI memoirs\u2026"
url: https://www.dra27.uk/blog/platform/2025/09/17/late-to-the-party.html
date: 2025-09-17T00:00:00-00:00
preview_image:
authors:
- ""
source:
ignore:
---

<p>I’ve been largely steering clear of the AI bandwagon up to now, mainly because
the last thing I needed while working on <a href="https://www.dra27.uk/(/blog/platform/2025/09/15/relocatable-ocaml.html)">Relocatable OCaml</a>
was to be trying to learn a new tool at the same time as finishing something
which felt desperately late and which, at times, I myself didn’t fully
understand! However, as the buzz of <a href="https://discuss.ocaml.org/t/relocatable-ocaml/17253">the announcement</a>
dies down, I had a first go at pointing <a href="https://claude.ai/">Claude Code</a> to the
OCaml compiler codebase, and thought I’d add to the general noise of AI
memoirs…</p>

<p>These are just my observations at this “day 1” stage, so there’ll be
inadequacies in the way I’m doing things, and so forth. The result can be seen <a href="https://github.com/dra27/ocaml/compare/535463082ea48f71fac945bdc242ab0774a6f18b...dra27:ocaml:f364eade826314b1b066597e6e126f12e9f8b29a?expand=1">on my OCaml fork</a>.</p>

<p>The task I had a play with is related to an interest I have in ultimately being
able to use OCaml as a scripting language within OCaml programs themselves. Many
of the things I do <em>to</em> OCaml often end up being curiously related or having
seemingly unrelated tasks, and one of the things implied by this goal is
unifying the bytecode and native runtime libraries (<code class="language-plaintext highlighter-rouge">libcamlrun</code> and
<code class="language-plaintext highlighter-rouge">libasmrun</code>). At the moment, these are separately compiled, with some files
which are just for the bytecode runtime or just for the native runtime, most
files which are shared between the two, and some files which are peppered with
<code class="language-plaintext highlighter-rouge">#ifdef NATIVE_CODE</code>-style sections for the bits which are slightly different
between the two implementations.</p>

<p>I’m pleased to say that in my few hours of playing with this, I managed not to
edit any files, so every change in each commit is physically Claude’s.</p>

<p>As a warm-up, I got Claude to produce a very simple plugin demo (the fourth
commit). I was particularly impressed at Claude’s understanding how to use a
compiler build in-tree, without having to install it. Although it slipped up
occasionally on where directories were relatively, it was inferring quite
readily the need for <code class="language-plaintext highlighter-rouge">-I ../stdlib</code> (because the compiler isn’t installed) and
so forth and although it didn’t grasp the need to pass bytecode programs
directly to the interpreter (you have, for example, to run
<code class="language-plaintext highlighter-rouge">../runtime/ocamlrun ../ocamlc</code> rather than <code class="language-plaintext highlighter-rouge">../ocamlc</code>), there was an
impressive lack of going-in-circles when I suggested alternate commands
(incidentally, the <code class="language-plaintext highlighter-rouge">Makefile</code> is hideous because I requested it to be a
complete expansion without variables and extraneous rubbish, not because it was
offered by default!).</p>

<p>So far, so interesting, but what about actually working on the compiler itself?
Interesting side-line with this - there’s a reasonable amount of scepticism
about LLM-based contributions in OCaml core development at the moment. This
branch isn’t ever heading upstream, but if it were to be opened as a PR, I need
to sign off on literally every edit that’s been made as being owned by
me - which means I wasn’t expecting ever to leave Claude in “auto mode”. More on
that later.</p>

<p>We started exploring a few of the source files which differ between bytecode and
native code. <em>I</em> suggested the first two commits while examining
<code class="language-plaintext highlighter-rouge">backtrace_byt.c</code>, <code class="language-plaintext highlighter-rouge">backtrace_nat.c</code> and <code class="language-plaintext highlighter-rouge">backtrace.c</code>, but Claude readily did
the work. I changed my mind about what I wanted to look at at that point and
decided to explore something different, so looked at a file which is shared, but
which has different implementations of the bytecode and native code versions of
the same functions - <code class="language-plaintext highlighter-rouge">callback.c</code>. The functions here are what are used from C
code to be able to call back into the OCaml runtime. That’s an very interesting
thing to look at when unifying the code, because it’s an entry-point from user
code into OCaml - i.e. the functions themselves will need to know whether
they’re operating on bytecode or native code.</p>

<p>We did it in two stages: the first part was to tweak the representation of
closures in the runtime to allow the closures to describe if they are bytecode
or native code. Claude unquestionably shone at this stage. I’m aware at a
high-level of <a href="https://github.com/ocaml/ocaml/pull/9619">ocaml/ocaml#9619</a> (I
remember very well the meeting where it was discussed, because it’s also the
meeting where I first aired the idea for Relocatable OCaml!), but I certainly
didn’t have it at the front of my mind. Claude was able in a very short amount
of time both to remind me how the closure representation works (with reference
to the runtime code) and furthermore produced an explanation which - for me,
knowing how it works - was convincing that a bit could be stolen from the
environment offset in the descriptor to be able to record whether a closure is
actually bytecode (pass the first field to <code class="language-plaintext highlighter-rouge">caml_bytecode_interpreter</code>) or is
native code (execute it directly, via one of the assembly callback stubs).</p>

<p>Getting the runtime updated and building was quite painless. There were two
interesting bits after that: the build failed quite a way in with segfaults
coming from the compiler. While I was impressed that Claude had inferred how
our bytecode bootstrap procedure works (perhaps it was trained on one of our
compiler courses!), that was a “yeah, but no” moment - bytecode closures are
always constructed at runtime, so how could <code class="language-plaintext highlighter-rouge">boot/ocamlc</code> be involved (“You’re
so right!”). The next suggestion was to attempt to start gdb. At that point, we
used the human brain instead of the LLM - I ran the build myself and could see
the command that what was actually segfaulting was not <code class="language-plaintext highlighter-rouge">ocamlc</code> but
<strong><code class="language-plaintext highlighter-rouge">ocamlc.opt</code></strong>, and for me there was an instant crashing-sound of a penny on
the floor. Claude had dutifully updated the runtime for this new closure
representation, and bytecode was therefore fine - but the native code compiler
<em>does</em> emit closures at compile-time and needed updating.</p>

<p>This part I must say was terribly impressive. I merely had to prompt that the
native compiler hadn’t been updated and Claude had leapt to
<code class="language-plaintext highlighter-rouge">asmcomp/cmm_helpers.ml</code> before I’d had a chance to remember the filename. The
build then worked and we moved on to running the testsuite.</p>

<p>Only one failure - again, Claude was very ready to start going into gdb and to
use all sorts of other sledgehammers, but it was clear to the human brain that
this was just a reference file which needed updating.</p>

<p>Quite impressive - we committed the work so far. Less impressive was Claude’s
ability to craft two commits from the working directory. I confess I got bored
trying to persuade it to unstage a single hunk.</p>

<p>Having updated the representation, we then tackled the much bigger job of
merging the functions. I was unimpressed by Claude’s suggestions about how it
might structure the changes, but it was very impressive at inferring the
connection between the stated target and my suggestions about what to do
instead.</p>

<p>The refactor here has a small subtlety: beforehand, the files are being compiled
with one version where <code class="language-plaintext highlighter-rouge">NATIVE_CODE</code> is <code class="language-plaintext highlighter-rouge">#define</code>‘d, and another where it’s not.
Although the ultimate aim is to have just one function, it doesn’t actually
reduce it to just one version of the code. We still have two: one of them is the
version of OCaml where both bytecode and native are available, but there is
another where there is no native code version at all. Claude readily inferred
why I wanted <code class="language-plaintext highlighter-rouge">BYTECODE_ONLY</code> to be introduced for this second case (and, if you
look at the <code class="language-plaintext highlighter-rouge">bytecode_callbackN_exn</code> and similar declarations which are
<code class="language-plaintext highlighter-rouge">#ifdef</code>‘d with this, you can see the idea), but when further problems happened
in the build, it too readily wanted to reach back for <code class="language-plaintext highlighter-rouge">#ifdef NATIVE_CODE</code>. This
kind of refactoring I describe as “infectious” - there’s a relatively small
first change in one file, but then further non-trivial changes have to be made
to propagate <em>the semantics</em> of that update. There were four changes needed to
make this one work:</p>

<ol>
  <li>Some bytecode-only shim versions of some native code functions are needed,
in order to be able to link the native code support object (<code class="language-plaintext highlighter-rouge">amd64.S</code> et al)
in the bytecode runtime.</li>
  <li>The fiber stack C declarations need to be unified between bytecode and
native code, as they use different pointer types.</li>
  <li>Some native-only functions, while not needed in the bytecode runtime, need to
be available just so that other code links. This is to support the code path
of invoking a native code closure on the bytecode runtime. It’s not going to
happen (yet), but the code still needs to compile.</li>
  <li>Some native-code shim versions of some bytecode functions are needed for the
dual reason of 1! Noteworthy because…</li>
</ol>

<p>Claude inferred none of these steps, always preferring to go back to
<code class="language-plaintext highlighter-rouge">NATIVE_ONLY</code>. <em>But</em> it was very good at executing the changes when I suggested
them, and inferring how they were alternate solutions to the problem.</p>

<p>We got through those changes fairly painlessly and, at this point, the
distribution built. Claude seems desperately keen to ignore the testsuite and
write test programs of its own, but I worried that its fingers would wear out
and dogmatically kept saying, “no, run the testsuite”. A lot of failures. Again,
not the greatest insights from it straight-away. At this stage, the human brain
was doing some staring at the code (maybe in the future I’d more readily let it
sit there crunching tokens). It turns out both the human brain and the LLM had
made a silly mistake with the header change and forgotten about pointer
arithmetic. <em>Nil point</em> to Claude for the lack of inference originally - but I
was certainly impressed that the prompt “The failing tests are all in bytecode.
I’m wondering if you made a mistake with the change to the header” which
<em>immediately</em> caused the LLM to identify that the switch from <code class="language-plaintext highlighter-rouge">value *</code> to
<code class="language-plaintext highlighter-rouge">void *</code> had totally omitted the need for more pointer casts (this is a large
part of what I don’t like about the change at the moment, but it’s a WIP… I
often find when hacking these ideas that it’s necessary to go through some very
ugly intermediate C states!).</p>

<p>After a fair bit of “think very hard”, all casts were updated and the entire
testsuite passed. As soon as that happened, Claude wanted to re-test the tree
with a bytecode-only build (to verify that the new <code class="language-plaintext highlighter-rouge">BYTECODE_ONLY</code> version was
working correctly too). And at that point we committed this little foray.</p>

<p>Impressions, perhaps to revisit in a few months:</p>
<ul>
  <li>Claude was excellent at getting the first version up and putting the outline
plan for the change together. It was certainly slower (than me) at editing the
files having done it. That, in fairness, fits with my experience of pair
programming, and perhaps reflects more on me than Claude.</li>
  <li>The first ideas Claude wanted to make for how to proceed were almost always
dreadful, and given the complexity of the code, I’m not sure I’d ever want to
leave it doing large amounts of work on its own. That probably says a lot
about my “prompt engineering”.</li>
  <li>In these few hours of “vibing”, I poked at builds, viewed source files on my
own in order to agree, but didn’t edit anything directly myself. Will
certainly be interesting to see what happens if Claude’s doing less of the
editing, but watching and doing more of the analysis.</li>
  <li>Given the need to sign off personally on every change made, while the task
felt like it took longer, it should be tempered with the fact I would feel
less need to review the change afterwards (although the final commit is still
not at a state which would be submitted in a PR).</li>
  <li>It’s possible that left to its own devices, Claude would have arrived at a
working version of this small step without intervention. However, based on
its attempt to describe a high-level plan of an earlier bigger idea, I dread
to think what the code would have looked like!</li>
  <li>Its response to error messages and the speed with which it gets to a
resolution definitely makes the process “feel” faster, even though it was
actually slower than doing it myself (a social media, echo-chambery feeling)</li>
</ul>

<p><em>The commits referenced on my GitHub fork of OCaml in this post are included for
information and illustration only, and are not intended to be upstreamed to
OCaml.</em></p>

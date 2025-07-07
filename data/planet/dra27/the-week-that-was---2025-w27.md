---
title: The week that was - 2025 w27
description: "Rather varied week this week. A number of our EEG interns have started
  their work with us for the summer, with two nice projects falling under my direct
  supervision, with Lucas and Jeremy. It\u2019s great to get to watch people start
  their first forays into the world of hacking on OCaml, once the customary \u201CI
  was a baby when you started maintaining OCaml\u201D comments et al are out of the
  way \U0001F602 It\u2019s also great to get to see the excitement, and reassuring
  to know that it is still an exciting thing to get to do for new people too!"
url: https://www.dra27.uk/blog/week-that-was/2025/07/06/wtw-27.html
date: 2025-07-06T00:00:00-00:00
preview_image:
authors:
- ""
source:
ignore:
---

<p>Rather varied week this week. A number of our <a href="https://anil.recoil.org/notes/eeg-interns-2025">EEG interns</a>
have started their work with us for the summer, with two <a href="https://anil.recoil.org/ideas/effects-scheduling-ocaml-compiler">nice</a>
<a href="https://anil.recoil.org/ideas/ocaml-bytecode-native-ffi">projects</a> falling
under my direct supervision, with Lucas and Jeremy. It’s great to get to watch
people start their first forays into the world of hacking <em>on</em> OCaml, once the
customary “I was a baby when you started maintaining OCaml” comments et al are
out of the way 😂 It’s also great to get to see the excitement, and reassuring
to know that it <em>is</em> still an exciting thing to get to do for new people too!</p>

<p>The two projects are of particular interest to me. I’ve poked (and supervised
some other poking) at various aspects related to OCaml’s <code class="language-plaintext highlighter-rouge">Load_path</code>, which is a
fairly innocuous-looking data structure at the heart of the compiler which is
simply responsible for mapping from names of files to locations based on the
provided <code class="language-plaintext highlighter-rouge">-I</code> search directories. As ever, a simple-sounding operation but with
wide-reaching complexity and impact - it’s an interesting piece of code to want
to rip out and replace if you’re writing a JavaScript toplevel, for example (no
file system…); it’s a remarkably hot piece of code if you suddenly find that
your file system is being slow (hello Windows, occasionally…). First week on
this is mostly about settling in, becoming familiar with the vagaries of OCaml’s
build system and development workflow, but even in week 1 there’s an unexpected
nice piece of refactoring opening up. In <a href="https://github.com/ocaml/ocaml/pull/11198">ocaml/ocaml#11198</a>,
as part of OCaml 5.0, we finally moved the extra libraries to separate
directories from the main Standard Library one but, to maintain compatibility,
you can still say <code class="language-plaintext highlighter-rouge">#load "unix.cma"</code> from the toplevel, etc. but you get an
alert that you should added <code class="language-plaintext highlighter-rouge">#directory "+unix"</code> beforehand (and, one day, you
might <em>have</em> to). The code for that is a bit fiddly because the <code class="language-plaintext highlighter-rouge">Load_path</code> is
further down the dependency graph from the modules responsible for displaying
and processing alerts and warnings, so it had to be passed as a hook. It’s a
nice demonstration with effects that this warty bit of code becomes <em>naturally</em>
cleaner, as the actual lookup of files takes place <em>much</em> higher up in <code class="language-plaintext highlighter-rouge">main.ml</code>
where it’s completely natural simply to display the alert. More exciting things
to come with this.</p>

<p>The other project extends work I’ve poked at with changes like <a href="https://github.com/ocaml/ocaml/pull/13745">ocaml/ocaml#13745</a>
where we start to take advantage of recent changes in the way <code class="language-plaintext highlighter-rouge">Dynlink</code> is built
that mean it can be used for the main toplevel (a largely historical accident
means that we at present have two almost-but-not-quite identical ways of loading
bytecode into a running OCaml program…). Being able to
<code class="language-plaintext highlighter-rouge">#load "my-numerical-library.cmxs"</code> in the <em>Bytecode</em> toplevel gives us the best
of worlds, hopefully - we get the power of native code for the library we’re
<em>using</em> and the flexibility and compilation-speed of the bytecode interpreter
for writing and experimenting <em>around</em> that library. You can do that at present
using ocamlnat (the native OCaml toplevel) but its compilation speed is slow and
other solutions such as the ocaml-jit project are not totally portable and not
particularly “drop-in”. I’m also really excited about the <em>converse</em> side of
this project - being able to run the <em>bytecode</em> interpreter in a <em>native</em>
program. Add the compiler frontend into your program, and what you have at that
point is the ability to embed OCaml as a scripting language into any program as
trivially as you can embed Lua, JavaScript, etc… so we might start to be able
to have a world where you can configure your complex application using actual
OCaml scripts but without needing OCaml to be on your end-user’s machine.
Needless to say, I have scheming ideas for how this might be highly useful in
opam packaging one of these days…</p>

<p>While working on the ever-overdue Relocatable OCaml at the weekend (the last
prerequisite PR got merged on Friday, with thanks to Damien and Nicolás for the
rubberstamp, and Antonin a while back for the deep-dive reviewing!), I
discovered some broken stuff, following a rebase. Turns out it wasn’t me, and
I’d been able to open <a href="https://github.com/ocaml/ocaml/pull/14114%5D">ocaml/ocaml#14114</a>
to fix the fault. Whilst checking that, I saw that the ppc64 port of OCaml
appeared to be broken, but I just left that with a note on the PR. Some distant
debugging on Monday with me connected to one of our POWER9 machines and
<a href="https://github.com/stedolan">Stephen Dolan</a> suggesting tweaks to a broken test
over Slack led us to <a href="https://github.com/ocaml/ocaml/pull/14116">ocaml/ocaml#14116</a>
and a particularly humorous mantra of Stephen’s for investigating broken tests
in OCaml:</p>
<ol>
  <li>If it’s running too slowly, trying removing a zero from all constants in the
test</li>
  <li>If it’s not working at all, trying add a zero to all constants in the test</li>
</ol>

<p>Works a charm, as you can see from the PR…</p>

<p>In between times, I managed to give a performance at <a href="https://www.medren2025.co.uk/concerts">MedRen2025</a>
in Newcastle, which has no connection to OCaml whatsover, beyond the amusing
observation that it featured music written between c.1450 and 1528, which is
<em>just</em> older than the opening sentence of my final-year undergraduate computer
science disseration many years ago (which began, somewhat unusually,
“In 1529, …”). We all managed not to get blown away at Fitzwilliam College for
the EEG Garden Party, and Relocatable OCaml became a little less far from
completion, but that’s for another post…</p>

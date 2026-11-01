---
title: Fireworks and things
description: "Thanks to some targetted optimisations in the script which manages Relocatable
  OCaml\u2019s various branches, I\u2019d vastly improved the turn-around time when
  making changes to the patch-set and propagating them through the various tests and
  backports. On Tuesday night, the entire set of branches was green in CI (they\u2019re
  sat here with green check marks and everything). All that was to be needed on Wednesday
  was to quickly update the opam packaging to take advantage of Relocatable-awesomeness
  and plumb it all together. The 2022 version of the packages for Ljubljana I knew
  contained a hack for searching a previous switch, but I\u2019d already investigated
  a more principled approach using opam\u2019s build-id variable, so it would just
  be a matter of plumbing that in and using the cloning mechanism already in that
  script."
url: https://www.dra27.uk/blog/platform/2025/07/17/fireworks.html
date: 2025-07-17T00:00:00-00:00
preview_image:
authors:
- ""
source:
ignore:
keywords:
- "bin"
- "cloning"
- "co-opted"
- "config"
- "lib"
- "ljubljana"
- "man"
- "man1"
- "opam"
- "wednesday"
---

<p>Thanks to some targetted optimisations in the <a href="https://github.com/dra27/relocatable/commits/main/stack">script which manages Relocatable
OCaml’s various branches</a>,
I’d vastly improved the turn-around time when making changes to the patch-set
and propagating them through the various tests and backports. On Tuesday night,
the <em>entire</em> set of branches was green in CI (they’re sat <a href="https://github.com/dra27/ocaml/pulls?q=is:pr%20is:open%20label:relocatable%20combined">here</a>
with green check marks and everything). All that was to be needed on Wednesday
was to quickly update the opam packaging to take advantage of
Relocatable-awesomeness and plumb it all together. The 2022 version of the
packages for Ljubljana I knew contained a hack for searching a previous switch,
but I’d already investigated a more principled approach using opam’s <code class="language-plaintext highlighter-rouge">build-id</code>
variable, so it would just be a matter of plumbing that in and using the cloning
mechanism already in that script.</p>

<p>And then I opened that scripts which I’d hacked together ready for the talk in
2022 in Ljubljana. I vaguely remember getting that all working at some ungodly
hour of the morning. The final clone is an unsightly:</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>    <span class="c"># Cloning</span>
    <span class="nv">SOURCE</span><span class="o">=</span><span class="s2">"</span><span class="si">$(</span><span class="nb">cat </span>clone-from<span class="si">)</span><span class="s2">"</span>
    <span class="nb">cp</span> <span class="s2">"</span><span class="nv">$SOURCE</span><span class="s2">/share/ocaml/config.cache"</span> <span class="nb">.</span>
    <span class="nb">mkdir</span> <span class="nt">-p</span> <span class="s2">"</span><span class="nv">$1</span><span class="s2">/man/man1"</span>
    <span class="nb">cp</span> <span class="s2">"</span><span class="nv">$SOURCE</span><span class="s2">/man/man1/"</span>ocaml<span class="k">*</span> <span class="s2">"</span><span class="nv">$1</span><span class="s2">/man/man1/"</span>
    <span class="nb">mkdir</span> <span class="nt">-p</span> <span class="s2">"</span><span class="nv">$1</span><span class="s2">/bin"</span>
    <span class="nb">cp</span> <span class="s2">"</span><span class="nv">$SOURCE</span><span class="s2">/bin/"</span>ocaml<span class="k">*</span> <span class="s2">"</span><span class="nv">$1</span><span class="s2">/bin/"</span>
    <span class="nb">rm</span> <span class="nt">-rf</span> <span class="s2">"</span><span class="nv">$1</span><span class="s2">/lib/ocaml"</span>
    <span class="nb">cp</span> <span class="nt">-a</span> <span class="s2">"</span><span class="nv">$SOURCE</span><span class="s2">/lib/ocaml"</span> <span class="s2">"</span><span class="nv">$1</span><span class="s2">/lib/"</span>
</code></pre></div></div>

<p>with no attempt to check the file lists 😭 Sorting out the installation targets
in OCaml’s build system is on my radar, but was not on my “Relocatable OCaml
blockers” TODO list.</p>

<div class="tenor-gif-embed" data-postid="22401840" data-share-method="host" data-aspect-ratio="1.74863" data-width="100%"><a href="https://tenor.com/view/were-so-close-gif-22401840">We were so close</a></div>


<p>Alas, the things which you can get away for a demo in a conference talk aren’t
quite the same as for actually maintained software. Ho hum - on the plus side,
Wednesday and Thursday’s hacking now yields a version of OCaml which can
generate opam install files properly, and which can therefore be co-opted to
produce the cloning script actually required. Onwards and upwards, apparently
now with memes…</p>

---
title: opam 2.0.5 release
description: 'We are pleased to announce the minor release of opam 2.0.5. This new
  version contains build update and small fixes: Bump src_ext Dune to 1.6.3, allows
  compilation with OCaml 4.08.0. [#3887 @dra27]

  Support Dune 1.7.0 and later [#3888 @dra27 - fix #3870]

  Bump the ocaml_mccs lib-ext, to include latest ...'
url: https://ocamlpro.com/blog/2019_07_11_opam_2.0.5_release
date: 2019-07-11T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Raja Boujbel\n  "
source:
---

<p>We are pleased to announce the minor release of <a href="https://github.com/ocaml/opam/releases/tag/2.0.5">opam 2.0.5</a>.</p>
<p>This new version contains build update and small fixes:</p>
<ul>
<li>Bump src_ext Dune to 1.6.3, allows compilation with OCaml 4.08.0. [<a href="https://github.com/ocaml/opam/pull/3887">#3887</a> <a href="https://github.com/dra27">@dra27</a>]
</li>
<li>Support Dune 1.7.0 and later [<a href="https://github.com/ocaml/opam/pull/3888">#3888</a> <a href="https://github.com/dra27">@dra27</a> - fix <a href="https://github.com/ocaml/opam/issues/3870">#3870</a>]
</li>
<li>Bump the ocaml_mccs lib-ext, to include latest changes [<a href="https://github.com/ocaml/opam/pull/3896">#3896</a> <a href="https://github.com/AltGr">@AltGr</a>]
</li>
<li>Fix cppo detection in configure [<a href="https://github.com/ocaml/opam/pull/3917">#3917</a> <a href="https://github.com/dra27">@dra27</a>]
</li>
<li>Read jobs variable from OpamStateConfig [<a href="https://github.com/ocaml/opam/pull/3916">#3916</a> <a href="https://github.com/dra27">@dra27</a>]
</li>
<li>Linting:
<ul>
<li>add check upstream option [<a href="https://github.com/ocaml/opam/pull/3758">#3758</a> <a href="https://github.com/rjbou">@rjbou</a>]
</li>
<li>add warning for with-test in run-test field [<a href="https://github.com/ocaml/opam/pull/3765">#3765</a>, <a href="https://github.com/ocaml/opam/pull/3860">#3860</a> <a href="https://github.com/rjbou">@rjbou</a>]
</li>
<li>fix misleading <code>doc</code> filter warning [<a href="https://github.com/ocaml/opam/pull/3871">#3871</a> <a href="https://github.com/rjbou">@rjbou</a>]
</li>
</ul>
</li>
<li>Fix typos [<a href="https://github.com/ocaml/opam/pull/3891">#3891</a> <a href="https://github.com/dra27">@dra27</a>, <a href="https://github.com/mehdid">@mehdid</a>]
</li>
</ul>
<blockquote>
<p>Note: To homogenise macOS name on system detection, we decided to keep <code>macos</code>, and convert <code>darwin</code> to <code>macos</code> in opam. For the moment, to not break jobs &amp; CIs, we keep uploading <code>darwin</code> &amp; <code>macos</code> binaries, but from the 2.1.0 release, only <code>macos</code> ones will be kept.</p>
</blockquote>
<hr/>
<p>Installation instructions (unchanged):</p>
<ol>
<li>From binaries: run
</li>
</ol>
<pre><code class="language-shell-session">sh &lt;(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.0.5">the Github &quot;Releases&quot; page</a> to your PATH. In this case, don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script.</p>
<ol start="2">
<li>From source, using opam:
</li>
</ol>
<pre><code class="language-shell-sesiion">opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained, and don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script)</p>
<ol start="3">
<li>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.0.5#compiling-this-repo">README</a>.
</li>
</ol>
<p>We hope you enjoy this new minor version, and remain open to <a href="https://github.com/ocaml/opam/issues">bug reports</a> and <a href="https://github.com/ocaml/opam/issues">suggestions</a>.</p>
<blockquote>
<p>NOTE: this article is cross-posted on <a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and <a href="https://ocamlpro.com/blog">ocamlpro.com</a>.</p>
</blockquote>


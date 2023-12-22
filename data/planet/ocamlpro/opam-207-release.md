---
title: opam 2.0.7 release
description: 'We are pleased to announce the minor release of opam 2.0.7. This new
  version contains backported small fixes: Escape Windows paths on manpages [#4129
  @AltGr @rjbou]

  Fix opam installer opam file [#4058 @rjbou]

  Fix various warnings [#4132 @rjbou @AltGr - fix #4100]

  Fix dune 2.5.0 promote-install-files...'
url: https://ocamlpro.com/blog/2020_04_21_opam_2.0.7_release
date: 2020-04-21T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Raja Boujbel\n  "
source:
---

<p>We are pleased to announce the minor release of <a href="https://github.com/ocaml/opam/releases/tag/2.0.7">opam 2.0.7</a>.</p>
<p>This new version contains <a href="https://github.com/ocaml/opam/pull/4143">backported</a> small fixes:</p>
<ul>
<li>Escape Windows paths on manpages [<a href="https://github.com/ocaml/opam/pull/4129">#4129</a> <a href="https://github.com/AltGr">@AltGr</a> <a href="https://github.com/rjbou">@rjbou</a>]
</li>
<li>Fix opam installer opam file [<a href="https://github.com/ocaml/opam/pull/4058">#4058</a> <a href="https://github.com/rjbou">@rjbou</a>]
</li>
<li>Fix various warnings [<a href="https://github.com/ocaml/opam/pull/4132">#4132</a> <a href="https://github.com/rjbou">@rjbou</a> <a href="https://github.com/AltGr">@AltGr</a> - fix <a href="https://github.com/ocaml/opam/issues/4100">#4100</a>]
</li>
<li>Fix dune 2.5.0 promote-install-files duplication [<a href="https://github.com/ocaml/opam/pull/4132">#4132</a> <a href="https://github.com/rjbou">@rjbou</a>]
</li>
</ul>
<hr/>
<p>Installation instructions (unchanged):</p>
<ol>
<li>From binaries: run
</li>
</ol>
<pre><code class="language-shell-session">bash -c &quot;sh &lt;(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh) --version 2.0.7&quot;
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.0.7">the Github &quot;Releases&quot; page</a> to your PATH. In this case, don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script.</p>
<ol start="2">
<li>From source, using opam:
</li>
</ol>
<pre><code class="language-shell-session">opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained, and don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script)</p>
<ol start="3">
<li>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.0.7#compiling-this-repo">README</a>.
</li>
</ol>
<p>We hope you enjoy this new minor version, and remain open to <a href="https://github.com/ocaml/opam/issues">bug reports</a> and <a href="https://github.com/ocaml/opam/issues">suggestions</a>.</p>
<blockquote>
<p>NOTE: this article is cross-posted on <a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and <a href="https://ocamlpro.com/blog">ocamlpro.com</a>.</p>
</blockquote>


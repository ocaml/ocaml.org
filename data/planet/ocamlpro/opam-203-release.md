---
title: opam 2.0.3 release
description: 'We are pleased to announce the release of opam 2.0.3. This new version
  contains some backported fixes: Fix manpage remaining $ (OPAMBESTEFFORT)

  Fix OPAMROOTISOK handling

  Regenerate missing environment file Installation instructions (unchanged): From
  binaries: run or download manually from the Github...'
url: https://ocamlpro.com/blog/2019_01_28_opam_2.0.3_release
date: 2019-01-28T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Raja Boujbel\n  "
source:
---

<p>We are pleased to announce the release of <a href="https://github.com/ocaml/opam/releases/tag/2.0.3">opam 2.0.3</a>.</p>
<p>This new version contains some <a href="https://github.com/ocaml/opam/pull/3715">backported fixes</a>:</p>
<ul>
<li>Fix manpage remaining $ (OPAMBESTEFFORT)
</li>
<li>Fix OPAMROOTISOK handling
</li>
<li>Regenerate missing environment file
</li>
</ul>
<hr/>
<p>Installation instructions (unchanged):</p>
<ol>
<li>From binaries: run
</li>
</ol>
<pre><code class="language-shell-session">sh &lt;(curl -sL https://opam.ocaml.org/install.sh)
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.0.3">the Github &quot;Releases&quot; page</a> to your PATH. In this case, don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script.</p>
<ol start="2">
<li>From source, using opam:
</li>
</ol>
<pre><code class="language-shell-session">opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained, and don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script)</p>
<ol start="3">
<li>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.0.3#compiling-this-repo">README</a>.
</li>
</ol>
<p>We hope you enjoy this new major version, and remain open to <a href="https://github.com/ocaml/opam/issues">bug reports</a> and <a href="https://github.com/ocaml/opam/issues">suggestions</a>.</p>
<blockquote>
<p>NOTE: this article is cross-posted on <a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and <a href="https://ocamlpro.com/blog">ocamlpro.com</a>.</p>
</blockquote>


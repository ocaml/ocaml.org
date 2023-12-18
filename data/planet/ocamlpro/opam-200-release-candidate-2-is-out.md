---
title: opam 2.0.0 Release Candidate 2 is out!
description: We are pleased to announce the release of a second release candidate
  for opam 2.0.0. This new version brings us very close to a final 2.0.0 release,
  and in addition to many fixes, features big performance enhancements over the RC1.
  Among the new features, we have squeezed in full sandboxing of packa...
url: https://ocamlpro.com/blog/2018_05_22_opam_2.0.0_release_candidate_2_is_out
date: 2018-05-22T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Louis Gesbert\n  "
source:
---

<p>We are pleased to announce the release of a second release candidate for opam 2.0.0.</p>
<p>This new version brings us very close to a final 2.0.0 release, and in addition to many fixes, features big performance enhancements over the RC1.</p>
<p>Among the new features, we have squeezed in full sandboxing of package commands for both Linux and macOS, to protect our users from any <a href="http://opam.ocaml.org/blog/camlp5-system/">misbehaving scripts</a>.</p>
<blockquote>
<p>NOTE: if upgrading manually from 2.0.0~rc, you need to run
<code>opam init --reinit -ni</code> to enable sandboxing.</p>
</blockquote>
<p>The new release candidate also offers the possibility to setup a hook in your shell, so that you won't need to run <code>eval $(opam env)</code> anymore. This is specially useful in combination with local switches, because with it enabled, you are guaranteed that running <code>make</code> from a project directory containing a local switch will use it.</p>
<p>The documentation has also been updated, and a preview of the opam 2 webpages can be browsed at http://opam.ocaml.org/2.0-preview/ (please report issues <a href="https://github.com/ocaml/opam2web/issues">here</a>). This provides the list of packages available for opam 2 (the <code>2.0</code> branch of <a href="https://github.com/ocaml/opam-repository/tree/2.0.0">opam-repository</a>), including the <a href="https://opam.ocaml.org/2.0-preview/packages/ocaml-base-compiler/">compiler packages</a>.</p>
<p>Installation instructions:</p>
<ol>
<li>From binaries: run
</li>
</ol>
<pre><code class="language-shell-session">sh &lt;(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.0.0-rc2">the Github &quot;Releases&quot; page</a> to your PATH. In this case, don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed.</p>
<ol start="2">
<li>From source, using opam:
</li>
</ol>
<pre><code class="language-shell-session">opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained, and don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed)</p>
<ol start="3">
<li>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.0.0-rc2#compiling-this-repo">README</a>.
</li>
</ol>
<p>Thanks a lot for testing out this new RC and <a href="https://github.com/ocaml/opam/issues">reporting</a> any issues you may find.</p>
<blockquote>
<p>NOTE: this article is cross-posted on <a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and <a href="https://ocamlpro.com/blog">ocamlpro.com</a>.</p>
</blockquote>


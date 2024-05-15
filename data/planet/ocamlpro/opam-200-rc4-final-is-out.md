---
title: opam 2.0.0 RC4-final is out!
description: "We are happy to announce the opam 2.0.0 final release candidate! \U0001F37E
  This release features a few bugfixes over Release Candidate 3. It will be promoted
  to 2.0.0 proper within a few weeks, when the official repository format switches
  from 1.2.0 to 2.0.0. After that date, updates to the 1.2.0 reposit..."
url: https://ocamlpro.com/blog/2018_07_26_opam_2.0.0_rc4_final_is_out
date: 2018-07-26T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Raja Boujbel\n  "
source:
---

<p>We are happy to announce the <a href="https://github.com/ocaml/opam/releases/tag/2.0.0-rc4">opam 2.0.0 final release candidate</a>! &#127870;</p>
<p>This release features a few bugfixes over <a href="https://ocamlpro.com/2018/07/26/opam-2-0-0-rc3">Release Candidate 3</a>. <strong>It will be promoted to 2.0.0 proper within a few weeks, when the <a href="https://github.com/ocaml/opam-repository">official repository</a> format switches from 1.2.0 to 2.0.0.</strong> After that date, updates to the 1.2.0 repository may become limited, as new features are getting used in packages.</p>
<p>It is safe to update as soon as you see fit, since opam 2.0.0 supports the older formats. See the <a href="https://opam.ocaml.org/2.0-preview/doc/Upgrade_guide.html">Upgrade Guide</a> for details about the new features and changes. If you are a package maintainer, you should keep publishing as before for now: the <a href="https://opam.ocaml.org/blog/opam-2-0-0-repo-upgrade-roadmap">roadmap</a> for the repository upgrade will be detailed shortly.</p>
<p>The opam.ocaml.org pages have also been refreshed a bit, and the new version showing the 2.0.0 branch of the repository is already online at <a href="https://opam.ocaml.org/2.0-preview/">https://opam.ocaml.org/2.0-preview/</a> (report any issues <a href="https://github.com/ocaml/opam2web/issues">here</a>).</p>
<hr/>
<p>Installation instructions:</p>
<ol>
<li>From binaries: run
</li>
</ol>
<pre><code class="language-shell-session">sh &lt;(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.0.0-rc4">the Github &quot;Releases&quot; page</a> to your PATH. In this case, don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed.</p>
<ol start="2">
<li>From source, using opam:
</li>
</ol>
<pre><code class="language-shell-session">opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained, and don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed)</p>
<ol start="3">
<li>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.0.0-rc4#compiling-this-repo">README</a>.
</li>
</ol>
<p>We hope you enjoy this new version, and remain open to <a href="https://github.com/ocaml/opam/issues">bug reports</a> and <a href="https://github.com/ocaml/opam/issues">suggestions</a>.</p>
<blockquote>
<p>NOTE: this article is cross-posted on <a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and <a href="https://ocamlpro.com/blog">ocamlpro.com</a>.</p>
</blockquote>


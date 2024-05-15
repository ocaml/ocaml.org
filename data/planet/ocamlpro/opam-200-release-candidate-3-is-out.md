---
title: opam 2.0.0 Release Candidate 3 is out!
description: 'We are pleased to announce the release of a third release candidate
  for opam 2.0.0. This one is expected to be the last before 2.0.0 comes out. Changes
  since the 2.0.0~rc2 are, as expected, mostly fixes. We deemed it useful, however,
  to bring in the following: a new command opam switch link that all...'
url: https://ocamlpro.com/blog/2018_06_22_opam_2.0.0_release_candidate_3_is_out
date: 2018-06-22T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Raja Boujbel\n  "
source:
---

<p>We are pleased to announce the release of a third release candidate for opam 2.0.0. This one is expected to be the last before 2.0.0 comes out.</p>
<p>Changes since the <a href="https://ocamlpro.com/opam-2-0-0-rc2">2.0.0~rc2</a> are, as expected, mostly fixes. We deemed it useful, however, to bring in the following:</p>
<ul>
<li>a new command <code>opam switch link</code> that allows to select a switch to be used in a given directory (particularly convenient if you use the shell hook for automatic opam environment update)
</li>
<li>a new option <code>opam install --assume-built</code>, that allows to install a package using its normal opam procedure, but for a source repository that has been built by hand. This fills a gap that remained in the local development workflows.
</li>
</ul>
<p>The preview of the opam 2 webpages can be browsed at http://opam.ocaml.org/2.0-preview/ (please report issues <a href="https://github.com/ocaml/opam2web/issues">here</a>).</p>
<p>Installation instructions (unchanged):</p>
<ol>
<li>From binaries: run
</li>
</ol>
<pre><code class="language-shell-session">sh &lt;(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.0.0-rc3">the Github &quot;Releases&quot; page</a> to your PATH. In this case, don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed.</p>
<ol start="2">
<li>From source, using opam:
</li>
</ol>
<pre><code class="language-shell-session">opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained, and don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed)</p>
<ol start="3">
<li>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.0.0-rc3#compiling-this-repo">README</a>.
</li>
</ol>
<p>Thanks a lot for testing out this new RC and <a href="https://github.com/ocaml/opam/issues">reporting</a> any issues you may find.</p>


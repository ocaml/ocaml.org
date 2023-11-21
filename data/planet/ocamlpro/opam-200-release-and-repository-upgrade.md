---
title: opam 2.0.0 release and repository upgrade
description: 'We are happy to announce the final release of opam 2.0.0. A few weeks
  ago, we released a last release candidate to be later promoted to 2.0.0, synchronised
  with the opam package repository upgrade. You are encouraged to update as soon as
  you see fit, to continue to get package updates: opam 2.0.0 su...'
url: https://ocamlpro.com/blog/2018_09_19_opam_2.0.0_release_and_repository_upgrade
date: 2018-09-19T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Raja Boujbel\n  "
source:
---

<p>We are happy to announce the final release of <a href="https://github.com/ocaml/opam/releases/tag/2.0.0">opam 2.0.0</a>.</p>
<p>A few weeks ago, we released a <a href="https://opam.ocaml.org/blog/opam-2-0-0-rc4">last release candidate</a> to be later promoted to 2.0.0, synchronised with the <a href="https://github.com/ocaml/opam-repository">opam package repository</a> <a href="https://opam.ocaml.org/blog/opam-2-0-0-repo-upgrade-roadmap/">upgrade</a>.</p>
<p>You are encouraged to update as soon as you see fit, to continue to get package updates: opam 2.0.0 supports the older formats, and 1.2.2 will no longer get regular updates. See the <a href="http://opam.ocaml.org/2.0-preview/doc/Upgrade_guide.html">Upgrade Guide</a> for details about the new features and changes.</p>
<p>The website opam.ocaml.org has been updated, with the full 2.0.0 documentation pages. You can still find the documentation for the previous versions in the corresponding menu.</p>
<p>Package maintainers should be aware of the following:</p>
<ul>
<li>the master branch of the <a href="https://github.com/ocaml/opam-repository">opam package repository</a> is now in the 2.0.0 format
</li>
<li>package submissions must accordingly be made in the 2.0.0 format, or using the new version of <code>opam-publish</code> (2.0.0)
</li>
<li>anything that was merged into the repository in 1.2 format has been automatically updated to the 2.0.0 format
</li>
<li>the 1.2 format repository has been forked to its own branch, and will only be updated for critical fixes
</li>
</ul>
<p>For custom repositories, the <a href="https://opam.ocaml.org/blog/opam-2-0-0-repo-upgrade-roadmap/#Advice-for-custom-repository-maintainers">advice</a> remains the same.</p>
<hr/>
<p>Installation instructions (unchanged):</p>
<ol>
<li>From binaries: run
</li>
</ol>
<pre><code class="language-shell-session">sh &lt;(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.0.0">the Github &quot;Releases&quot; page</a> to your PATH. In this case, don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed.</p>
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
<p>We hope you enjoy this new major version, and remain open to <a href="https://github.com/ocaml/opam/issues">bug reports</a> and <a href="https://github.com/ocaml/opam/issues">suggestions</a>.</p>
<blockquote>
<p>NOTE: this article is cross-posted on <a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and <a href="https://ocamlpro.com/blog">ocamlpro.com</a>.</p>
</blockquote>


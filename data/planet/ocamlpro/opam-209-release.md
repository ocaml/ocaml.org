---
title: opam 2.0.9 release
description: Feedback on this post is welcomed on Discuss! We are pleased to announce
  the minor release of opam 2.0.9. This new version contains some back-ported fixes.
  New features Back-ported ability to load upgraded roots read-only; allows applications
  compiled with opam-state 2.0.9 to load a root which has b...
url: https://ocamlpro.com/blog/2021_08_03_opam_2.0.9_release
date: 2021-08-03T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Raja Boujbel\n  "
source:
---

<p><em>Feedback on this post is welcomed on <a href="https://discuss.ocaml.org/t/ann-opam-2-1-0/8255">Discuss</a>!</em></p>
<p>We are pleased to announce the minor release of <a href="https://github.com/ocaml/opam/releases/tag/2.0.9">opam 2.0.9</a>.</p>
<p>This new version contains some <a href="https://github.com/ocaml/opam/pull/4547">back-ported</a> fixes.</p>
<h2>New features</h2>
<ul>
<li>Back-ported ability to load upgraded roots read-only; allows applications compiled with opam-state 2.0.9 to load a root which has been upgraded to opam 2.1 [<a href="https://github.com/ocaml/opam/issues/4636">#4636</a>]
</li>
<li>macOS sandbox now supports <code>OPAM_USER_PATH_RO</code> for adding a custom read-only directory to the sandbox [<a href="https://github.com/ocaml/opam/issues/4589">#4589</a>, <a href="https://github.com/ocaml/opam/issues/4609">#4609</a>]
</li>
<li><code>OPAMROOT</code> and <code>OPAMSWITCH</code> now reflect the <code>--root</code> and <code>--switch</code> parameters in the package build [<a href="https://github.com/ocaml/opam/issues/4668">#4668</a>]
</li>
<li>When built with opam-file-format 2.1.3+, opam-format 2.0.x displays better errors for newer opam files [<a href="https://github.com/ocaml/opam/issues/4394">#4394</a>]
</li>
</ul>
<h2>Bug fixes</h2>
<ul>
<li>Linux sandbox now mounts <em>host</em> <code>$TMPDIR</code> read-only, then sets the <em>sandbox</em> <code>$TMPDIR</code> to a new separate tmpfs. <strong>Hardcoded <code>/tmp</code> access no longer works if <code>TMPDIR</code> points to another directory</strong> [<a href="https://github.com/ocaml/opam/issues/4589">#4589</a>]
</li>
<li>Stop clobbering <code>DUNE_CACHE</code> in the sandbox script [<a href="https://github.com/ocaml/opam/issues/4535">#4535</a>, fixing <a href="https://github.com/ocaml/dune/issues/4166">ocaml/dune#4166</a>]
</li>
<li>Ctrl-C now correctly terminates builds with bubblewrap; sandbox now requires bubblewrap 0.1.8 or later [<a href="https://github.com/ocaml/opam/issues/4400">#4400</a>]
</li>
<li>Linux sandbox script no longer makes <code>PWD</code> read-write on remove actions [<a href="https://github.com/ocaml/opam/issues/4589">#4589</a>]
</li>
<li>Lint W59 and E60 no longer trigger for packages flagged <code>conf</code> [<a href="https://github.com/ocaml/opam/issues/4549">#4549</a>]
</li>
<li>Reduce the length of temporary file names for pin caching to ease pressure on Windows [<a href="https://github.com/ocaml/opam/issues/4590">#4590</a>]
</li>
<li>Security: correct quoting of arguments when removing switches [<a href="https://github.com/ocaml/opam/issues/4707">#4707</a>]
</li>
<li>Stop advertising the removed option <code>--compiler</code> when creating local switches [<a href="https://github.com/ocaml/opam/issues/4718">#4718</a>]
</li>
<li>Pinning no longer fails if the archive's opam file is malformed [<a href="https://github.com/ocaml/opam/issues/4580">#4580</a>]
</li>
<li>Fish: stop using deprecated <code>^</code> syntax to fix support for Fish 3.3.0+ [<a href="https://github.com/ocaml/opam/issues/4736">#4736</a>]
</li>
</ul>
<hr/>
<p>Installation instructions (unchanged):</p>
<ol>
<li>From binaries: run
</li>
</ol>
<pre><code class="language-shell-session">bash -c &quot;sh &lt;(curl -fsSL https://opam.ocaml.org/install.sh) --version 2.0.9&quot;
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.0.9">the Github &quot;Releases&quot; page</a> to your PATH. In this case, don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script.</p>
<ol start="2">
<li>From source, using opam:
</li>
</ol>
<pre><code class="language-shell-session">opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained, and don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update your sandbox script)</p>
<ol start="3">
<li>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.0.9#compiling-this-repo">README</a>.
</li>
</ol>
<p>We hope you enjoy this new minor version, and remain open to <a href="https://github.com/ocaml/opam/issues">bug reports</a> and <a href="https://github.com/ocaml/opam/issues">suggestions</a>.</p>


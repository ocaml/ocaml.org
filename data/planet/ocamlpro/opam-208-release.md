---
title: opam 2.0.8 release
description: 'We are pleased to announce the minor release of opam 2.0.8. This new
  version contains some backported fixes: Critical for fish users! Don''t add . to
  PATH. [#4078]

  Fix sandbox script for newer ccache versions. [#4079 and #4087]

  Fix sandbox crash when ~/.cache is a symlink. [#4068]

  User modifications ...'
url: https://ocamlpro.com/blog/2021_02_08_opam_2.0.8_release
date: 2021-02-08T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Raja Boujbel\n  "
source:
---

<p>We are pleased to announce the minor release of <a href="https://github.com/ocaml/opam/releases/tag/2.0.8">opam 2.0.8</a>.</p>
<p>This new version contains some <a href="https://github.com/ocaml/opam/pull/4425">backported</a> fixes:</p>
<ul>
<li><strong>Critical for fish users!</strong> Don't add <code>.</code> to <code>PATH</code>. [<a href="https://github.com/ocaml/opam/issues/4078">#4078</a>]
</li>
<li>Fix sandbox script for newer <code>ccache</code> versions. [<a href="https://github.com/ocaml/opam/issues/4079">#4079</a> and <a href="https://github.com/ocaml/opam/pull/4087">#4087</a>]
</li>
<li>Fix sandbox crash when <code>~/.cache</code> is a symlink. [<a href="https://github.com/ocaml/opam/issues/4068">#4068</a>]
</li>
<li>User modifications to the sandbox script are no longer overwritten by <code>opam init</code>. [<a href="https://github.com/ocaml/opam/pull/4092">#4020</a> &amp; <a href="https://github.com/ocaml/opam/pull/4092">#4092</a>]
</li>
<li>macOS sandbox script always mounts <code>/tmp</code> read-write, regardless of <code>TMPDIR</code> [<a href="https://github.com/ocaml/opam/pull/3742">#3742</a>, addressing <a href="https://github.com/ocaml/opam-repository/issues/13339">ocaml/opam-repository#13339</a>]
</li>
<li><code>pre-</code> and <code>post-session</code> hooks can now print to the console [<a href="https://github.com/ocaml/opam/issues/4359">#4359</a>]
</li>
<li>Switch-specific pre/post sessions hooks are now actually run [<a href="https://github.com/ocaml/opam/issues/4472">#4472</a>]
</li>
<li>Standalone <code>opam-installer</code> now correctly builds from sources [<a href="https://github.com/ocaml/opam/issues/4173">#4173</a>]
</li>
<li>Fix <code>arch</code> variable detection when using 32bit mode on ARM64 and i486 [<a href="https://github.com/ocaml/opam/pull/4462">#4462</a>]
</li>
</ul>
<p>A more complete <a href="https://github.com/ocaml/opam/releases/tag/2.0.8">release note</a> is available.</p>
<hr/>
<p>Installation instructions (unchanged):</p>
<ol>
<li>From binaries: run
</li>
</ol>
<pre><code class="language-shell-session">$~ bash -c &quot;sh &lt;(curl -fsSL https://opam.ocaml.org/install.sh) --version 2.0.8&quot;
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.0.8">the Github &quot;Releases&quot; page</a> to your PATH. In this case, don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script.</p>
<ol start="2">
<li>From source, using opam:
</li>
</ol>
<pre><code class="language-shell-session">$~ opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained, and don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script)</p>
<ol start="3">
<li>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.0.8#compiling-this-repo">README</a>.
</li>
</ol>
<p>We hope you enjoy this new minor version, and remain open to <a href="https://github.com/ocaml/opam/issues">bug reports</a> and <a href="https://github.com/ocaml/opam/issues">suggestions</a>.</p>
<blockquote>
<p>NOTE: this article is cross-posted on <a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and <a href="https://ocamlpro.com/blog">ocamlpro.com</a>, and published in <a href="https://discuss.ocaml.org/t/ann-opam-2-0-8-release/7242">discuss.ocaml.org</a>.</p>
</blockquote>


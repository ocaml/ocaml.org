---
title: opam 2.0.1 is out!
description: 'We are pleased to announce the release of opam 2.0.1. This new version
  contains mainly backported fixes, some platform-specific: Cold boot for MacOS/CentOS/Alpine

  Install checksum validation on MacOS

  Archive extraction for OpenBSD now defaults to using gtar

  Fix compilation of mccs on MacOS and Nix p...'
url: https://ocamlpro.com/blog/2018_10_24_opam_2.0.1_is_out
date: 2018-10-24T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Raja Boujbel\n  "
source:
---

<p>We are pleased to announce the release of <a href="https://github.com/ocaml/opam/releases/tag/2.0.1">opam 2.0.1</a>.</p>
<p>This new version contains mainly <a href="https://github.com/ocaml/opam/pull/3560">backported fixes</a>, some platform-specific:</p>
<ul>
<li>Cold boot for MacOS/CentOS/Alpine
</li>
<li>Install checksum validation on MacOS
</li>
<li>Archive extraction for OpenBSD now defaults to using <code>gtar</code>
</li>
<li>Fix compilation of mccs on MacOS and Nix platforms
</li>
<li>Do not use GNU-sed specific features in the release Makefile, to fix build on OpenBSD/FreeBSD
</li>
<li>Cleaning to enable reproducible builds
</li>
<li>Update configure scripts
</li>
</ul>
<p>And some opam specific:</p>
<ul>
<li>git: fix git fetch by sha1 for git &lt; 2.14
</li>
<li>linting: add <code>test</code> variable warning and empty description error
</li>
<li>upgrade: convert pinned but not installed opam files
</li>
<li>error reporting: more comprehensible error message for tar extraction, and upgrade of git-url compilers
</li>
<li>opam show: upgrade given local files
</li>
<li>list: as opam 2.0.0 <code>list</code> doesn't return non-zero code if list is empty, add <code>--silent</code> option for a silent output and returns 1 if list is empty
</li>
</ul>
<hr/>
<p>Installation instructions (unchanged):</p>
<ol>
<li>From binaries: run
</li>
</ol>
<pre><code class="language-shell-session">sh &lt;(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.0.1">the Github &quot;Releases&quot; page</a> to your PATH. In this case, don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed.</p>
<ol start="2">
<li>From source, using opam:
</li>
</ol>
<pre><code class="language-shell-session">opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained, and don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed)</p>
<ol start="3">
<li>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.0.1#compiling-this-repo">README</a>.
</li>
</ol>
<p>We hope you enjoy this new major version, and remain open to <a href="https://github.com/ocaml/opam/issues">bug reports</a> and <a href="https://github.com/ocaml/opam/issues">suggestions</a>.</p>
<blockquote>
<p>NOTE: this article is cross-posted on <a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and <a href="https://ocamlpro.com/blog">ocamlpro.com</a>.</p>
</blockquote>


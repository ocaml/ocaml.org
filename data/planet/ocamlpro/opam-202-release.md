---
title: opam 2.0.2 release
description: 'We are pleased to announce the release of opam 2.0.2. As sandbox scripts
  have been updated, don''t forget to run opam init --reinit -ni to update yours.
  This new version contains mainly backported fixes: Doc:

  update man page

  add message for deprecated options

  reinsert removed ones to print a deprecat...'
url: https://ocamlpro.com/blog/2018_12_12_opam_2.0.2_release
date: 2018-12-12T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Raja Boujbel\n  "
source:
---

<p>We are pleased to announce the release of <a href="https://github.com/ocaml/opam/releases/tag/2.0.2">opam 2.0.2</a>.</p>
<p>As <strong>sandbox scripts</strong> have been updated, don't forget to run <code>opam init --reinit -ni</code> to update yours.</p>
<p>This new version contains mainly <a href="https://github.com/ocaml/opam/pull/3669">backported fixes</a>:</p>
<ul>
<li>Doc:
<ul>
<li>update man page
</li>
<li>add message for deprecated options
</li>
<li>reinsert removed ones to print a deprecated message instead of fail (e.g. <code>--alias-of</code>)
</li>
<li>deprecate <code>no-aspcud</code>
</li>
</ul>
</li>
<li>Pin:
<ul>
<li>on pinning, rebuild updated <code>pin-depends</code> packages reliably
</li>
<li>include descr &amp; url files on pinning 1.2 opam files
</li>
</ul>
</li>
<li>Sandbox:
<ul>
<li>handle symlinks in bubblewrap for system directories such as <code>/bin</code> or <code>/lib</code> (<a href="https://github.com/ocaml/opam/pull/3661">#3661</a>).  Fixes sandboxing on some distributions such as CentOS 7 and Arch Linux.
</li>
<li>allow use of unix domain sockets on macOS (<a href="https://github.com/ocaml/opam/issues/3659">#3659</a>)
</li>
<li>change one-line conditional to if statement which was incompatible with set -e
</li>
<li>make /var readonly instead of empty and rw
</li>
</ul>
</li>
<li>Path: resolve default opam root path
</li>
<li>System: suffix .out for read_command_output stdout files
</li>
<li>Locked: check consistency with opam file when reading lock file to suggest regeneration message
</li>
<li>Show: remove pin depends messages
</li>
<li>Cudf: Fix closure computation in the presence of cycles to have a complete graph if a cycle is present in the graph (typically <code>ocaml-base-compiler</code> &#8644; <code>ocaml</code>)
</li>
<li>List: Fix some cases of listing coinstallable packages
</li>
<li>Format upgrade: extract archived source files of version-pinned packages
</li>
<li>Core: add is_archive in OpamSystem and OpamFilename
</li>
<li>Init: don't fail if empty compiler given
</li>
<li>Lint: fix light_uninstall flag for error 52
</li>
<li>Build: partial port to dune
</li>
<li>Update cold compiler to 4.07.1
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
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.0.2">the Github &quot;Releases&quot; page</a> to your PATH. In this case, don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update your sandbox script.</p>
<ol start="2">
<li>From source, using opam:
</li>
</ol>
<pre><code class="language-shell-session">opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained, and don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script)</p>
<ol start="3">
<li>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.0.2#compiling-this-repo">README</a>.
</li>
</ol>
<p>We hope you enjoy this new minor version, and remain open to <a href="https://github.com/ocaml/opam/issues">bug reports</a> and <a href="https://github.com/ocaml/opam/issues">suggestions</a>.</p>
<blockquote>
<p>NOTE: this article is cross-posted on <a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and <a href="https://ocamlpro.com/blog">ocamlpro.com</a>.</p>
</blockquote>


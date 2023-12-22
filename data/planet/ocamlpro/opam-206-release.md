---
title: opam 2.0.6 release
description: 'We are pleased to announce the minor release of opam 2.0.6. This new
  version contains some small backported fixes and build update: Don''t remove git
  cache objects that may be used [#3831 @AltGr]

  Don''t include .gitattributes in index.tar.gz [#3873 @dra27]

  Update FAQ uri [#3941 @dra27]

  Lock: add warni...'
url: https://ocamlpro.com/blog/2020_01_16_opam_2.0.6_release
date: 2020-01-16T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Raja Boujbel\n  "
source:
---

<p>We are pleased to announce the minor release of <a href="https://github.com/ocaml/opam/releases/tag/2.0.6">opam 2.0.6</a>.</p>
<p>This new version contains some small <a href="https://github.com/ocaml/opam/pull/3973">backported</a> fixes and build update:</p>
<ul>
<li>Don't remove git cache objects that may be used [<a href="https://github.com/ocaml/opam/pull/3831">#3831</a> <a href="https://github.com/AltGr">@AltGr</a>]
</li>
<li>Don't include .gitattributes in index.tar.gz [<a href="https://github.com/ocaml/opam/pull/3873">#3873</a> <a href="https://github.com/dra27">@dra27</a>]
</li>
<li>Update FAQ uri [<a href="https://github.com/ocaml/opam/pull/3941">#3941</a> <a href="https://github.com/dra27">@dra27</a>]
</li>
<li>Lock: add warning in case of missing locked file [<a href="https://github.com/ocaml/opam/pull/3939">#3939</a> <a href="https://github.com/rjbou">@rjbou</a>]
</li>
<li>Directory tracking: fix cached entries retrieving with precise
tracking [<a href="https://github.com/ocaml/opam/pull/4038">#4038</a> <a href="https://github.com/hannesm">@hannesm</a>]
</li>
<li>Build:
<ul>
<li>Add sanity checks [<a href="https://github.com/ocaml/opam/pull/3934">#3934</a> <a href="https://github.com/dra27">@dra27</a>]
</li>
<li>Build man pages using dune [<a href="https://github.com/ocaml/opam/issues/3902">#3902</a> ]
</li>
<li>Add patch and bunzip check for make cold [<a href="https://github.com/ocaml/opam/pull/4006">#4006</a> <a href="https://github.com/rjbou">@rjbou</a> - fix <a href="https://github.com/ocaml/opam/issues/3842">#3842</a>]
</li>
</ul>
</li>
<li>Shell:
<ul>
<li>fish: add colon for fish manpath [<a href="https://github.com/ocaml/opam/pull/3886">#3886</a> <a href="https://github.com/rjbou">@rjbou</a> - fix <a href="https://github.com/ocaml/opam/issues/3878">#3878</a>]
</li>
</ul>
</li>
<li>Sandbox:
<ul>
<li>Add dune cache as rw [<a href="https://github.com/ocaml/opam/pull/4019">#4019</a> <a href="https://github.com/rjbou">@rjbou</a> - fix <a href="https://github.com/ocaml/opam/issues/4012">#4012</a>]
</li>
<li>Do not fail if $HOME/.ccache is missing [<a href="https://github.com/ocaml/opam/pull/3957">#3957</a> <a href="https://github.com/mseri">@mseri</a>]
</li>
</ul>
</li>
<li>opam-devel file: avoid copying extraneous files in opam-devel example [<a href="https://github.com/ocaml/opam/pull/3999">#3999</a> <a href="https://github.com/maroneze">@maroneze</a>]
</li>
</ul>
<p>As <strong>sandbox scripts</strong> have been updated, don't forget to run <code>opam init --reinit -ni</code> to update yours.</p>
<blockquote>
<p>Note: To homogenise macOS name on system detection, we decided to keep <code>macos</code>, and convert <code>darwin</code> to <code>macos</code> in opam. For the moment, to not break jobs &amp; CIs, we keep uploading <code>darwin</code> &amp; <code>macos</code> binaries, but from the 2.1.0 release, only <code>macos</code> ones will be kept.</p>
</blockquote>
<hr/>
<p>Installation instructions (unchanged):</p>
<ol>
<li>From binaries: run
</li>
</ol>
<pre><code class="language-sheel-session">bash -c &quot;sh &lt;(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh) --version 2.0.6&quot;
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.0.6">the Github &quot;Releases&quot; page</a> to your PATH. In this case, don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script.</p>
<ol start="2">
<li>From source, using opam:
</li>
</ol>
<pre><code class="language-shell-session">opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained, and don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script)</p>
<ol start="3">
<li>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.0.6#compiling-this-repo">README</a>.
</li>
</ol>
<p>We hope you enjoy this new minor version, and remain open to <a href="https://github.com/ocaml/opam/issues">bug reports</a> and <a href="https://github.com/ocaml/opam/issues">suggestions</a>.</p>
<blockquote>
<p>NOTE: this article is cross-posted on <a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and <a href="https://ocamlpro.com/blog">ocamlpro.com</a>.</p>
</blockquote>


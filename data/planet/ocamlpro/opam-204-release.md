---
title: opam 2.0.4 release
description: 'We are pleased to announce the release of opam 2.0.4. This new version
  contains some backported fixes: Sandboxing on macOS: considering the possibility
  that TMPDIR is unset [#3597 @herbelin - fix #3576]

  display: Fix opam config var display, aligned on opam config list [#3723 @rjbou
  - rel. #3717]

  pin...'
url: https://ocamlpro.com/blog/2019_04_10_opam_2.0.4_release
date: 2019-04-10T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Raja Boujbel\n  "
source:
---

<p>We are pleased to announce the release of <a href="https://github.com/ocaml/opam/releases/tag/2.0.4">opam 2.0.4</a>.</p>
<p>This new version contains some <a href="https://github.com/ocaml/opam/pull/3805">backported fixes</a>:</p>
<ul>
<li>Sandboxing on macOS: considering the possibility that TMPDIR is unset [<a href="https://github.com/ocaml/opam/pull/3597">#3597</a> <a href="https://github.com/herbelin">@herbelin</a> - fix <a href="https://github.com/ocaml/opam/issues/3576">#3576</a>]
</li>
<li>display: Fix <code>opam config var</code> display, aligned on <code>opam config list</code> [<a href="https://github.com/ocaml/opam/pull/3723">#3723</a> <a href="https://github.com/rjbou">@rjbou</a> - rel. <a href="https://github.com/ocaml/opam/issues/3717">#3717</a>]
</li>
<li>pin:
<ul>
<li>update source of (version) pinned directory [<a href="https://github.com/ocaml/opam/pull/3726">#3726</a> <a href="https://github.com/rjbou">@rjbou</a> - <a href="https://github.com/ocaml/opam/issues/3651">#3651</a>]
</li>
<li>fix <code>--ignore-pin-depends</code> with autopin [<a href="https://github.com/ocaml/opam/pull/3736">#3736</a> <a href="https://github.com/AltGr">@AltGr</a>]
</li>
<li>fix pinnings not installing/upgrading already pinned packages (introduced in 2.0.2) [<a href="https://github.com/ocaml/opam/pull/3800">#3800</a> <a href="https://github.com/AltGr">@AltGr</a>]
</li>
</ul>
</li>
<li>opam clean: Ignore errors trying to remove directories [<a href="https://github.com/ocaml/opam/pull/3732">#3732</a> <a href="https://github.com/kit">@kit-ty-kate</a>]
</li>
<li>remove wrong &quot;mismatched extra-files&quot; warning [<a href="https://github.com/ocaml/opam/pull/3744">#3744</a> <a href="https://github.com/rjbou">@rjbou</a>]
</li>
<li>urls: fix hg opam 1.2 url parsing [<a href="https://github.com/ocaml/opam/pull/3754">#3754</a> <a href="https://github.com/rjbou">@rjbou</a>]
</li>
<li>lint: update message of warning 47, to avoid confusion because of missing <code>synopsis</code> field internally inferred from <code>descr</code> [<a href="https://github.com/ocaml/opam/pull/3753">#3753</a> <a href="https://github.com/rjbou">@rjbou</a> - fix <a href="https://github.com/ocaml/opam/issues/3738">#3738</a>]
</li>
<li>system:
<ul>
<li>lock &amp; signals: don't interrupt at non terminal signals [<a href="https://github.com/ocaml/opam/pull/3541">#3541</a> <a href="https://github.com/rjbou">@rjbou</a>]
</li>
<li>shell: fix fish manpath setting [<a href="https://github.com/ocaml/opam/pull/3728">#3728</a> <a href="https://github.com/gregory">@gregory-nisbet</a>]
</li>
<li>git: use <code>diff.noprefix=false</code> config argument to overwrite user defined configuration [<a href="https://github.com/ocaml/opam/pull/3788">#3788</a> <a href="https://github.com/rjbou">@rjbou</a>, <a href="https://github.com/ocaml/opam/pull/3628">#3628</a> <a href="https://github.com/Blaisorblade">@Blaisorblade</a> - fix <a href="https://github.com/ocaml/opam/issues/3627">#3627</a>]
</li>
</ul>
</li>
<li>dirtrack: fix precise tracking mode [<a href="https://github.com/ocaml/opam/pull/3796">#3796</a> <a href="https://github.com/rjbou">@rjbou</a>]
</li>
<li>fix some mispellings [<a href="https://github.com/ocaml/opam/pull/3731">#3731</a> <a href="https://github.com/MisterDA">@MisterDA</a>]
</li>
<li>CI enhancement &amp; fixes [<a href="https://github.com/ocaml/opam/pull/3706">#3706</a> <a href="https://github.com/dra27">@dra27</a>, <a href="https://github.com/ocaml/opam/pull/3748">#3748</a> <a href="https://github.com/rjbou">@rjbou</a>, <a href="https://github.com/ocaml/opam/pull/3801">#3801</a> <a href="https://github.com/rjbou">@rjbou</a>]
</li>
</ul>
<blockquote>
<p>Note: To homogenise macOS name on system detection, we decided to keep <code>macos</code>, and convert <code>darwin</code> to <code>macos</code> in opam. For the moment, to not break jobs &amp; CIs, we keep uploading <code>darwin</code> &amp; <code>macos</code> binaries, but from the 2.1.0 release, only <code>macos</code> ones will be kept.</p>
</blockquote>
<hr/>
<p>Installation instructions (unchanged):</p>
<ol>
<li>From binaries: run
</li>
</ol>
<pre><code class="language-shell-session">sh &lt;(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.0.4">the Github &quot;Releases&quot; page</a> to your PATH. In this case, don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script.</p>
<ol start="2">
<li>From source, using opam:
</li>
</ol>
<pre><code class="language-shell-session">opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained, and don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script)</p>
<ol start="3">
<li>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.0.4#compiling-this-repo">README</a>.
</li>
</ol>
<p>We hope you enjoy this new minor version, and remain open to <a href="https://github.com/ocaml/opam/issues">bug reports</a> and <a href="https://github.com/ocaml/opam/issues">suggestions</a>.</p>
<blockquote>
<p>NOTE: this article is cross-posted on <a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and <a href="https://ocamlpro.com/blog">ocamlpro.com</a>.</p>
</blockquote>


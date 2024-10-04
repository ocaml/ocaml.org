---
title: opam 2.0 Beta5 is out!
description: After a few more months brewing, we are pleased to announce a new beta
  release of opam. With this new milestone, opam is reaching feature-freeze, with
  an expected 2.0.0 by the beginning of next year. This version brings many new features,
  stability fixes, and big improvements to the local developmen...
url: https://ocamlpro.com/blog/2017_11_27_opam_2.0_beta5_is_out
date: 2017-11-27T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Louis Gesbert\n  "
source:
---

<p>After a few more months brewing, we are pleased to announce a new beta release
of opam. With this new milestone, opam is reaching feature-freeze, with an
expected 2.0.0 by the beginning of next year.</p>
<p>This version brings many new features, stability fixes, and big improvements to
the local development workflows.</p>
<h2>What's new</h2>
<p>The features presented in past announcements:
<a href="http://opam.ocaml.org/blog/opam-local-switches/">local switches</a>,
<a href="http://opam.ocaml.org/blog/opam-install-dir/">in-source package definition handling</a>,
<a href="http://opam.ocaml.org/blog/opam-extended-dependencies/">extended dependencies</a>
are of course all present. But now, all the glue to make them interact nicely
together is here to provide new smooth workflows. For example, the following
command, if run from the source tree of a given project, creates a local switch
where it will restore a precise installation, including explicit versions of all
packages and pinnings:</p>
<pre><code class="language-shell-session">opam switch create ./ --locked
</code></pre>
<p>this leverages the presence of <code>opam.locked</code> or <code>&lt;name&gt;.opam.locked</code> files,
which are valid package definitions that contain additional details of the build
environment, and can be generated with the
<a href="https://github.com/AltGr/opam-lock"><code>opam-lock</code> plugin</a> (the <code>lock</code> command may
be merged into opam once finalised).</p>
<p>But this new beta also provides a large amount of quality of life improvements,
and other features. A big one, for example, is the integration of a built-in
solver (derived from <a href="http://www.i3s.unice.fr/~cpjm/misc/mccs.html"><code>mccs</code></a> and
<a href="https://www.gnu.org/software/glpk/"><code>glpk</code></a>). This means that the <code>opam</code> binary
works out-of-the box, without requiring the external
<a href="https://www.cs.uni-potsdam.de/wv/aspcud/"><code>aspcud</code></a> solver, and on all
platforms. It is also faster.</p>
<p>Another big change is that detection of architecture and OS details is now done
in opam, and can be used to select the external dependencies with the new format
of the <a href="http://opam.ocaml.org/doc/2.0/Manual.html#opamfield-depexts"><code>depexts:</code></a>
field, but also to affect dependencies or build flags.</p>
<p>There is much more to it. Please see the
<a href="https://github.com/ocaml/opam/blob/2.0.0-beta5/CHANGES">changelog</a>, and the
<a href="http://opam.ocaml.org/doc/2.0/Manual.html">updated manual</a>.</p>
<h2>How to try it out</h2>
<p>Our warm thanks for trying the new beta and
<a href="https://github.com/ocaml/opam/issues">reporting</a> any issues you may hit.</p>
<p>There are three main ways to get the update:</p>
<ol>
<li>The easiest is to use our pre-compiled binaries.
<a href="https://github.com/ocaml/opam/blob/master/shell/opam_installer.sh">This script</a>
will also make backups if you migrate from 1.x, and has an option to revert
back:
</li>
</ol>
<pre><code class="language-shell-session">sh &lt;(curl -sL https://opam.ocaml.org/install.sh)
</code></pre>
<p>This uses the binaries from https://github.com/ocaml/opam/releases/tag/2.0.0-beta5</p>
<ol start="2">
<li>Another option is to compile from source, using an existing opam
installation. Simply run:
</li>
</ol>
<pre><code class="language-shell-session">opam update; opam install opam-devel
</code></pre>
<p>and follow the instructions (you will need to copy the compiled binary to
your PATH).</p>
<ol start="3">
<li>
<p>Compiling by hand from the
<a href="https://github.com/ocaml/opam/releases/download/2.0.0-beta5/opam-full-2.0.0-beta5.tar.gz">inclusive source archive</a>,
or from the <a href="https://github.com/ocaml/opam/tree/2.0.0-beta5">git repo</a>. Use
<code>./configure &amp;&amp; make lib-ext &amp;&amp; make</code> if you have OCaml &gt;= 4.02.3 already
available; <code>make cold</code> otherwise.</p>
<p>If the build fails after updating a git repo from a previous version, try
<code>git clean -fdx src/</code> to remove any stale artefacts.</p>
</li>
</ol>
<p>Note that the repository format is different from that of opam 1.2. Opam 2 will
be automatically redirected from the
<a href="https://github.com/ocaml/opam-repository">opam-repository</a> to an automatically
rewritten 2.0 mirror, and is otherwise able to do the conversion on the fly
(both for package definitions when pinning, and for whole repositories). You may
not yet contribute packages in 2.0 format to opam-repository, though.</p>
<h2>What we need tested</h2>
<p>We are interested in all opinions and reports, but here are a few areas where
your feedback would be specially useful to us:</p>
<ul>
<li>Use 2.0 day-to-day, in particular check any packages you may be maintaining.
We would like to ensure there are no regressions due to the rewrite from 1.2
to 2.0.
</li>
<li>Check the quality of the solutions provided by the solver (or conflicts, when
applicable).
</li>
<li>Test the different pinning mechanisms (rsync, git, hg, darcs) with your
project version control systems. See the <code>--working-dir</code> option.
</li>
<li>Experiment with local switches for your project (and/or <code>opam install DIR</code>).
Give us feedback on the workflow. Use <code>opam lock</code> and share development
environments.
</li>
<li>If you have any custom repositories, please try the conversion to 2.0 format
with <code>opam admin upgrade --mirror</code> on them, and use the generated mirror.
</li>
<li>Start porting your CI systems for larger projects to use opam 2, and give us
feedback on any improvements you need for automated scripting (e.g. the
<code>--json</code> output).
</li>
</ul>


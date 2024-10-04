---
title: opam 2.1.0 alpha is here!
description: We are happy to announce a alpha for opam 2.1.0, one year and a half
  in the making after the release of 2.0.0. Many new features made it in (see the
  complete changelog or release note for the details), but here are a few highlights
  of this release. Release highlights The two following features have ...
url: https://ocamlpro.com/blog/2020_04_22_opam_2.1.0_alpha_is_here
date: 2020-04-22T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Raja Boujbel\n  "
source:
---

<p>We are happy to announce a alpha for opam 2.1.0, one year and a half in the
making after the release of 2.0.0.</p>
<p>Many new features made it in (see the <a href="https://github.com/ocaml/opam/blob/2.1.0-alpha/CHANGES">complete
changelog</a> or <a href="https://github.com/ocaml/opam/releases/tag/2.1.0-alpha">release
note</a> for the details),
but here are a few highlights of this release.</p>
<h2>Release highlights</h2>
<p>The two following features have been around for a while as plugins and are now
completely integrated in the core of opam. No extra installs needed anymore, and
a more smooth experience.</p>
<h3>Seamless integration of System dependencies handling (a.k.a. &quot;depexts&quot;)</h3>
<p>A number of opam packages depend on tools or libraries installed on the system,
which are out of the scope of opam itself. Previous versions of opam added a
<a href="http://opam.ocaml.org/doc/Manual.html#opamfield-depexts">specification format</a>,
and opam 2.0 already handled checking the OS and extracting the required system
package names.</p>
<p>However, the workflow generally involved letting opam fail once, then installing
the dependencies and retrying, or explicitely using the
<a href="https://github.com/ocaml/opam-depext">opam-depext plugin</a>, which was invaluable
for CI but still incurred extra steps.</p>
<p>With opam 2.1.0, <em>depexts</em> are seamlessly integrated, and you basically won't
have to worry about them ahead of time:</p>
<ul>
<li>Before applying its course of actions, opam 2.1.0 checks that external
dependencies are present, and will prompt you to install them. You are free to
let it do it using <code>sudo</code>, or just run the provided commands yourself.
</li>
<li>It is resilient to <em>depexts</em> getting removed or out of sync.
</li>
<li>Opam 2.1.0 detects packages that depend on stuff that is not available on your
OS version, and automatically avoids them.
</li>
</ul>
<p>This is all fully configurable, and can be bypassed without tricky commands when
you need it (<em>e.g.</em> when you compiled a dependency yourself).</p>
<h3>Dependency locking</h3>
<p>To share a project for development, it is often necessary to be able to
reproduce the exact same environment and dependencies setting &mdash; as opposed to
allowing a range of versions as opam encourages you to do for releases.</p>
<p>For some reason, most other package managers call this feature &quot;lock files&quot;.
Opam can handle those in the form of <code>[foo.]opam.locked</code> files, and the
<code>--locked</code> option.</p>
<p>With 2.1.0, you no longer need a plugin to generate these files: just running
<code>opam lock</code> will create them for existing <code>opam</code> files, enforcing the exact
version of all dependencies (including locally pinned packages).</p>
<p>If you check-in these files, new users would just have run
<code>opam switch create . --locked</code> on a fresh clone to get a local switch ready to
build the project.</p>
<h3>Pinning sub-directories</h3>
<p>This one is completely new: fans of the <em>Monorepo</em> rejoice, opam is now able to
handle projects in subtrees of a repository.</p>
<ul>
<li>Using <code>opam pin PROJECT_ROOT --subpath SUB_PROJECT</code>, opam will look for
<code>PROJECT_ROOT/SUB_PROJECT/foo.opam</code>. This will behave as a pinning to
<code>PROJECT_ROOT/SUB_PROJECT</code>, except that the version-control handling is done
in <code>PROJECT_ROOT</code>.
</li>
<li>Use <code>opam pin PROJECT_ROOT --recursive</code> to automatically lookup all sub-trees
with opam files and pin them.
</li>
</ul>
<h3>Opam switches are now defined by invariants</h3>
<p>Previous versions of opam defined switches based on <em>base packages</em>, which
typically included a compiler, and were immutable. Opam 2.1.0 instead defines
them in terms of an <em>invariant</em>, which is a generic dependency formula.</p>
<p>This removes a lot of the rigidity <code>opam switch</code> commands had, with little
changes on the existing commands. For example, <code>opam upgrade ocaml</code> commands are
now possible; you could also define the invariant as <code>ocaml-system</code> and have
its version change along with the version of the OCaml compiler installed
system-wide.</p>
<h3>Configuring opam from the command-line</h3>
<p>The new <code>opam option</code> command allows to configure several options,
without requiring manual edition of the configuration files.</p>
<p>For example:</p>
<ul>
<li><code>opam option jobs=6 --global</code> will set the number of parallel build
jobs opam is allowed to run (along with the associated <code>jobs</code> variable)
</li>
<li><code>opam option depext-run-commands=false</code> disables the use of <code>sudo</code> for
handling system dependencies; it will be replaced by a prompt to run the
installation commands.
</li>
</ul>
<p>The command <code>opam var</code> is extended with the same format, acting on switch and
global variables.</p>
<h2>Try it!</h2>
<p>In case you plan a possible rollback, you may want to first backup your
<code>~/.opam</code> directory.</p>
<p>The upgrade instructions are unchanged:</p>
<ol>
<li>Either from binaries: run
</li>
</ol>
<pre><code class="language-shell-session">$~ bash -c &quot;sh &lt;(curl -fsSL https://opam.ocaml.org/install.sh) --version 2.1.0~alpha&quot;
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.1.0-alpha">the Github &quot;Releases&quot; page</a> to your PATH.</p>
<ol start="2">
<li>Or from source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.1.0-alpha#compiling-this-repo">README</a>.
</li>
</ol>
<p>You should then run:</p>
<pre><code class="language-shell-session">opam init --reinit -ni
</code></pre>
<p>This is still a alpha, so a few glitches or regressions are to be expected.
Please report them to <a href="https://github.com/ocaml/opam/issues">the bug-tracker</a>.
Thanks for trying it out, and hoping you enjoy!</p>
<blockquote>
<p>NOTE: this article is cross-posted on
<a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and
<a href="https://ocamlpro.com/blog">ocamlpro.com</a>.</p>
</blockquote>


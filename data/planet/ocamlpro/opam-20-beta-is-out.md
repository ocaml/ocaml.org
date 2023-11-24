---
title: opam 2.0 Beta is out!
description: 'UPDATE (2017-02-14): A beta2 is online, which fixes issues and performance
  of the opam build command. Get the new binaries, or recompile the opam-devel package
  and replace the previous binary. We are pleased to announce that the beta release
  of opam 2.0 is now live! You can try it already, bootstrap...'
url: https://ocamlpro.com/blog/2017_02_09_opam_2.0_beta_is_out
date: 2017-02-09T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Louis Gesbert\n  "
source:
---

<blockquote>
<p>UPDATE (2017-02-14): A beta2 is online, which fixes issues and performance of
the <code>opam build</code> command. Get the new
<a href="https://github.com/ocaml/opam/releases/tag/2.0.0-beta2">binaries</a>, or
recompile the <a href="http://opam.ocaml.org/packages/opam-devel/">opam-devel</a> package
and replace the previous binary.</p>
</blockquote>
<p>We are pleased to announce that the beta release of opam 2.0 is now live! You
can try it already, bootstrapping from a working 1.2 opam installation, with:</p>
<pre><code class="language-shell-session">opam update; opam install opam-devel
</code></pre>
<p>With about a thousand patches since the last stable release, we took the time to
gather feedback after <a href="https://ocamlpro.com/opam-2-0-preview">our last announcement</a> and
implemented a couple of additional, most-wanted features:</p>
<ul>
<li>An <code>opam build</code> command that, from the root of a source tree containing one
or more package definitions, can automatically handle initialisation and
building of the sources in a local switch.
</li>
<li>Support for
<a href="https://github.com/hannesm/conex-paper/raw/master/paper.pdf">repository signing</a>
through the external <a href="https://github.com/hannesm/conex">Conex</a> tool, being
developed in parallel.
</li>
</ul>
<p>There are many more features, like the new <code>opam clean</code> and <code>opam admin</code>
commands, a new archive caching system, etc., but we'll let you check the full
<a href="https://github.com/ocaml/opam/blob/2.0.0-beta/CHANGES">changelog</a>.</p>
<p>We also improved still on the
<a href="https://ocamlpro.com/opam-2-0-preview/#Afewhighlights">already announced features</a>, including
compilers as packages, local switches, per-switch repository configuration,
package file tracking, etc.</p>
<p>The updated documentation is at http://opam.ocaml.org/doc/2.0/. If you are
developing in opam-related tools, you may also want to browse the
<a href="https://opam.ocaml.org/doc/2.0/api/index.html">new APIs</a>.</p>
<h2>Try it out</h2>
<p>Please try out the beta, and report any issues or missing features. You can:</p>
<ul>
<li>Build it from source in opam, as shown above (<code>opam install opam-devel</code>)
</li>
<li>Use the <a href="https://github.com/ocaml/opam/releases/tag/2.0.0-beta">pre-built binaries</a>.
</li>
<li>Building from the source tarball:
<a href="https://github.com/ocaml/opam/releases/download/2.0.0-beta/opam-full-2.0.0-beta.tar.gz">download here</a>
and build using <code>./configure &amp;&amp; make lib-ext &amp;&amp; make</code> if you have OCaml &gt;=
4.01 already available; <code>make cold</code> otherwise
</li>
<li>Or directly from the
<a href="https://github.com/ocaml/opam/tree/2.0.0-beta">git tree</a>, following the
instructions included in the README. Some files have been moved around, so if
your build fails after you updated an existing git clone, try to clean it up
(<code>git clean -dx</code>).
</li>
</ul>
<p>Some users have been using the alpha for the past months without problems, but
you may want to keep your opam 1.2 installation intact until the release is out.
An easy way to do this is with an alias:</p>
<pre><code class="language-shell-session">alias opam2=&quot;OPAMROOT=~/.opam2 path/to/opam-2-binary&quot;
</code></pre>
<h2>Changes to be aware of</h2>
<h3>Command-line interface</h3>
<ul>
<li><code>opam switch create</code> is now needed to create new switches, and <code>opam switch</code>
is now much more expressive
</li>
<li><code>opam list</code> is also much more expressive, but be aware that the output may
have changed if you used it in scripts
</li>
<li>new commands:
<ul>
<li><code>opam build</code>: setup and build a local source tree
</li>
<li><code>opam clean</code>: various cleanup operations (wiping caches, etc.)
</li>
<li><code>opam admin</code>: manage software repositories, including upgrading them to
opam 2.0 format (replaces the <code>opam-admin</code> tool)
</li>
<li><code>opam env</code>, <code>opam exec</code>, <code>opam var</code>: shortcuts for the <code>opam config</code> subcommands
</li>
</ul>
</li>
<li><code>opam repository add</code> will now setup the new repository for the current switch
only, unless you specify <code>--all</code>
</li>
<li>Some flags, like <code>--test</code>, now apply to the packages listed on the
command-line only. For example, <code>opam install lwt --test</code> will build and
install lwt and all its dependencies, but only build/run the tests of the
<code>lwt</code> package. Test-dependencies of its dependencies are also ignored
</li>
<li>The new <code>opam install --soft-request</code> is useful for batch runs, it will
maximise the installed packages among the requested ones, but won't fail if
all can't be installed
</li>
</ul>
<p>As before, opam is self-documenting, so be sure to check <code>opam COMMAND --help</code>
first when in doubt. The bash completion scripts have also been thoroughly
improved, and may help navigating the new options.</p>
<h3>Metadata</h3>
<p>There are both a few changes (extensions, mostly) to the package description
format, and more drastic changes to the repository format, mainly related to
translating the old compiler definitions into packages.</p>
<ul>
<li>opam will automatically update, internally, definitions of pinned packages as
well as repositories in the 1.2 format
</li>
<li>however, it is faster to use repositories in the 2.0 format directly. To that
end, please use the <code>opam admin upgrade</code> command on your repositories. The
<code>--mirror</code> option will create a 2.0 mirror and put in place proper
redirections, allowing your original repository to retain the old format
</li>
</ul>
<p>The official opam repository at https://opam.ocaml.org remains in 1.2 format for
now, but has a live-updated 2.0 mirror to which you should be automatically
redirected. It cannot yet accept package definitions in 2.0 format.</p>
<h4>Package format</h4>
<ul>
<li>Any <code>available:</code> constraints based on the OCaml compiler version should be
rewritten into dependencies to the <code>ocaml</code> package
</li>
<li>Separate <code>build:</code> and <code>install:</code> instructions are now required
</li>
<li>It is now preferred to include the old <code>url</code> and <code>descr</code> files (containing the
archive URL and package description) in the <code>opam</code> file itself: (see the new
<a href="http://opam.ocaml.org/doc/2.0/Manual.html#opamfield-synopsis"><code>synopsis:</code></a>
and
<a href="http://opam.ocaml.org/doc/2.0/Manual.html#opamfield-description"><code>description:</code></a>
fields, and the
<a href="http://opam.ocaml.org/doc/2.0/Manual.html#opamsection-url">url {}</a> file
section)
</li>
<li>Building tests and documentation should now be part of the main <code>build:</code>
instructions, using the <code>{test}</code> and <code>{doc}</code> filters. The <code>build-test:</code> and
<code>build-doc:</code> fields are still supported.
</li>
<li>It is now possible to use opam variables within dependencies, for example
<code>depends: [ &quot;foo&quot; {= version} ]</code>, for a dependency to package <code>foo</code> at the
same version as the package being defined, or <code>depends: [ &quot;bar&quot; {os = &quot;linux&quot;} ]</code> for a dependency that only applies on Linux.
</li>
<li>The new <code>conflict-class:</code> field allows mutual conflicts among a set of
packages to be declared. Useful, for example, when there are many concurrent,
incompatible implementations.
</li>
<li>The <code>ocaml-version:</code> field has been deprecated for a long time and is no
longer accepted. This should now be a dependency on the <code>ocaml</code> package
</li>
<li>Three types of checksums are now accepted: you should use <code>md5=&lt;hex-value&gt;</code>,
<code>sha256=&lt;hex-value&gt;</code> or <code>sha512=&lt;hex-value&gt;</code>. We'll be gradually deprecating
md5 in favour of the more secure algorithms; multiple checksums are allowed
</li>
<li>Patches supplied in the <code>patches:</code> field must apply with <code>patch -p1</code>
</li>
<li>The new <code>setenv:</code> field allows packages to export updates to environment
variables;
</li>
<li>Custom fields <code>x-foo:</code> can be used for extensions and external tools
</li>
<li><code>&quot;&quot;&quot;</code> delimiters allow unescaped strings
</li>
<li><code>&amp;</code> has now the customary higher precedence than <code>|</code> in formulas
</li>
<li>Installed files are now automatically tracked meaning that the <code>remove:</code>
field is usually no longer required.
</li>
</ul>
<p>The full, up-to-date specification of the format can be browsed in the
<a href="http://opam.ocaml.org/doc/2.0/Manual.html#opam">manual</a>.</p>
<h4>Repository format</h4>
<p>In the official, default repository, and also when migrating repositories from
older format versions, there are:</p>
<ul>
<li>A virtual <code>ocaml</code> package, that depends on any implementation of the OCaml
compiler. This is what packages should depend on, and the version is the
corresponding base OCaml version (e.g. <code>4.04.0</code> for the <code>4.04.0+fp</code> compiler).
It also defines various configuration variables, see <code>opam config list ocaml</code>.
</li>
<li>Three mutually-exclusive packages providing actual implementations of the
OCaml toolchain:
<ul>
<li><code>ocaml-base-compiler</code> is the official releases
</li>
<li><code>ocaml-variants.&lt;base-version&gt;+&lt;variant-name&gt;</code> contains all the other
variants
</li>
<li><code>ocaml-system-compiler</code> maps to a compiler installed on the system
outside of opam
</li>
</ul>
</li>
</ul>
<p>The layout is otherwise the same, apart from:</p>
<ul>
<li>The <code>compilers/</code> directory is ignored
</li>
<li>A <code>repo</code> file should be present, containing at least the line <code>opam-version: &quot;2.0&quot;</code>
</li>
<li>The indexes for serving over HTTP have been simplified, and <code>urls.txt</code> is no
longer needed. See <code>opam admin index --help</code>
</li>
<li>The <code>archives/</code> directory is no longer used. The cache now uses a different
format and is configured through the <code>repo</code> file, defaulting to <code>cache/</code> on
the same server. See <code>opam admin cache --help</code>
</li>
</ul>
<h2>Feedback</h2>
<p>Thanks for trying out the beta! Please let us have feedback, preferably to the
<a href="https://github.com/ocaml/opam/issues">opam tracker</a>; other options include the
<a href="mailto:opam-devel@lists.ocaml.org">opam-devel</a> list and #opam IRC channel on
Freenode.</p>


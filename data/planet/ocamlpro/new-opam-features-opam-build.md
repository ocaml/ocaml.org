---
title: 'new opam features: "opam build"'
description: 'UPDATE: after discussions following this post, this feature was abandoned
  with the interface presented below. See this post for the details and the new interface!
  The new opam 2.0 release, currently in beta, introduces several new features. This
  post gets into some detail on the new opam build comma...'
url: https://ocamlpro.com/blog/2017_03_16_new_opam_features_opam_build
date: 2017-03-16T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Louis Gesbert\n  "
source:
---

<blockquote>
<p>UPDATE: after discussions following this post, this feature was abandoned with
the interface presented below. See <a href="https://ocamlpro.com/blog/2017_05_04_new_opam_features_opam_install_dir">this post</a> for
the details and the new interface!</p>
</blockquote>
<p>The new opam 2.0 release, currently in beta, introduces several new features.
This post gets into some detail on the new <code>opam build</code> command, its purpose,
its use, and some implementation aspects.</p>
<p><strong><code>opam build</code> is run from the source tree of a project, and does not rely on a
pre-existing opam installation.</strong> As such, it adds a new option besides the
existing workflows based on managing shared OCaml installations in the form of
switches.</p>
<h3>What does it do ?</h3>
<p>Typically, this is used in a fresh git clone of some OCaml project. Like when
pinning the package, opam will find and leverage package definitions found in
the source, in the form of <code>opam</code> files.</p>
<ul>
<li>if opam hasn't been initialised (no <code>~/.opam</code>), this is taken care of.
</li>
<li>if no switch is otherwise explicitely selected, a <em>local switch</em> is used, and
created if necessary (<em>i.e.</em> in <code>./_opam/</code>)
</li>
<li>the metadata for the current project is registered, and the package installed
after its dependencies, as opam usually does
</li>
</ul>
<p>This is particularly useful for <strong>distributing projects</strong> to people not used to
opam and the OCaml ecosystem: the setup steps are automatically taken care of,
and a single <code>opam build</code> invocation can take care of resolving the dependency
chains for your package.</p>
<p>If building the project directly is preferred, adding <code>--deps-only</code> is a good
way to get the dependencies ready for the project:</p>
<pre><code class="language-shell-session">opam build --deps-only
eval $(opam config env)
./configure; make; etc.
</code></pre>
<p>Note that if you just want to handle project-local opam files, <code>opam build</code> can
also be used in your existing switches: just specify <code>--no-autoinit</code>, <code>--switch</code>
or make sure the <code>OPAMSWITCH</code> variable is set. <em>E.g.</em> <code>opam build --no-autoinit --deps-only</code> is a convenient way to get the dependencies for the local project
ready in your current switch.</p>
<h3>Additional functions</h3>
<h4>Installation</h4>
<p>The installation of the packages happens as usual to the prefix corresponding to
the switch used (<code>&lt;project-root&gt;/_opam/</code> for a local switch). But it is
possible, with <code>--install-prefix</code>, to further install the package to the system:</p>
<pre><code class="language-shell-session">opam build --install-prefix ~/local
</code></pre>
<p>will install the results of the package found in the current directory below
~/local.</p>
<p>The dependencies of the package won't be installed, so this is intended for
programs, assuming they are relocatable, and not for libraries.</p>
<h4>Choosing custom repositories</h4>
<p>The user can pre-select the repositories to use on the creation of the local
switch with:</p>
<pre><code class="language-shell-session">opam build --repositories &lt;repos&gt;
</code></pre>
<p>where <code>&lt;repos&gt;</code> is a comma-separated list of repositories, specified either as
<code>name=URL</code>, or <code>name</code> if already configured on the system.</p>
<h4>Multiple packages</h4>
<p>Multiple packages are commonly found to share a single repository. In this case,
<code>opam build</code> registers and builds all of them, respecting cross-dependencies.
The opam files to use can also be explicitely selected on the command-line.</p>
<p>In this case, specific opam files must be named <code>&lt;package-name&gt;.opam</code>.</p>
<h3>Implementation details</h3>
<p>The choice of the compiler, on automatic initialisation, is either explicit,
using the <code>--compiler</code> option, or automatic. In the latter case, the default
selection is used (see <code>opam init --help</code>, section &quot;CONFIGURATION FILE&quot; for
details), but a compiler compatible with the local packages found is searched
from that. This allows, for example, to choose a system compiler when available
and compatible, avoiding a recompilation of OCaml.</p>
<p>When using <code>--install-prefix</code>, the normal installation is done, then the
tracking of package-installed files, introduced in opam 2.0, is used to extract
the installed files from the switch and copy them to the prefix.</p>
<p>The packages installed through <code>opam build</code> are not registered in any
repository, and this is not an implicit use of <code>opam pin</code>: the rationale is that
packages installed this way will also be updated by repeating <code>opam build</code>. This
means that when using other commands, <em>e.g.</em> <code>opam upgrade</code>, opam won't try to
keep the packages to their local, source version, and will either revert them to
their repository definition, or remove them, if they need recompilation.</p>
<h3>Planned extensions</h3>
<p>This is still in beta: there are still rough edges, please experiment and give
feedback! It is still possible that the command syntax and semantics change
significantly before release.</p>
<p>Another use-case that we are striving to improve is sharing of development
setups (share sets of pinned packages, depend on specific remotes or git hashes,
etc.). We have <a href="https://github.com/ocaml/opam/issues/2762">many</a>
<a href="https://github.com/ocaml/opam/issues/2495">ideas</a> to
<a href="https://github.com/ocaml/opam/issues/1734">improve</a> on this, but <code>opam build</code>
is not, as of today, a direct solution to this. In particular, installing this
way still relies on the default opam repository; a way to define specific
options for the switch that is implicitely created on <code>opam build</code> is in the
works.</p>
<blockquote>
<p>NOTE: this article is cross-posted on <a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and <a href="https://ocamlpro.com/blog">ocamlpro.com</a>.</p>
</blockquote>
<h1>Comments</h1>
<p>Louis Gesbert (16 March 2017 at 14 h 31 min):</p>
<blockquote>
<p>Some discussion on a better naming and making some parts of this more widely available in the opam CLI is ongoing at https://github.com/ocaml/opam/issues/2882</p>
</blockquote>
<p>Hez Carty (16 March 2017 at 17 h 23 min):</p>
<blockquote>
<p>Is it possible/planned to support sharing of compilers across local (or global) switches? It would be very useful to have a global 4.04.0+flambda switch including only the compiler itself or the compiler + basic tools like ocp-indent and merlin. Then a number of projects could share this base installation but have their own locally installed dependencies without duplicating the entire build time per-project.</p>
</blockquote>
<p>Louis Gesbert (17 March 2017 at 10 h 10 min):</p>
<blockquote>
<p>Sharing compilers, or other packages across switches is not supported at the moment. However:</p>
<p>You can still use the global <code>system compiler</code> on any switch, local or not, to avoid its recompilation
What is planned, as a first step, for after the 2.0 release, is to add a cache of compiled packages. Hooks are already in place to allow this, and opam is able to track the files installed by each package already, so the most difficult part is probably going to be the relocation issues with OCaml itself.</p>
<p>A cache is an easier solution to warrant consistency: with shared switches, the problem of reinstallations and keeping everything consistent gets much more complex &mdash; what happens when you change the compiler of your &ldquo;master&rdquo; switch ?</p>
</blockquote>
<p>Hez Carty (20 March 2017 at 16 h 46 min):</p>
<blockquote>
<p>That sounds great, thank you. Should make this kind of local switch more useful when working with large numbers of projects.</p>
</blockquote>


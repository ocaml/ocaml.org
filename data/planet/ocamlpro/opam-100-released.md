---
title: OPAM 1.0.0 released
description: I am very happy to announce the first official release of OPAM! Many
  of you already know and use OPAM so I won't be long. Please read beta-release-of-opam
  for a longer description. 1.0.0 fixes many bugs and add few new features to the
  previously announced beta-release. The most visible new feature, ...
url: https://ocamlpro.com/blog/2013_03_15_opam_1.0.0_released
date: 2013-03-15T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Thomas Gazagnaire\n  "
source:
---

<p>I am <em>very</em> happy to announce the first official release of OPAM!</p>
<p>Many of you already know and use OPAM so I won't be long. Please read
<a href="https://ocamlpro.com/blog/2013_01_17_beta_release_of_opam">beta-release-of-opam</a> for a
longer description.</p>
<p>1.0.0 fixes many bugs and add few new features to the previously announced
beta-release.</p>
<p>The most visible new feature, which should be useful for beginners with
OCaml and OPAM,  is an auto-configuration tool. This tool easily enables all
the features of OPAM (auto-completion, fix the loading of scripts for the
toplevel, opam-switch-eval alias, etc). This tool runs interactively on each
<code>opam init</code> invocation. If you don't like OPAM to change your configuration
files, use <code>opam init --no-setup</code>. If you trust the tool blindly,  use
<code>opam init --auto-setup</code>. You can later review the setup by doing
<code>opam config setup --list</code> and call the tool again using <code>opam config setup</code>
(and you can of course manually edit your ~/.profile (or ~/.zshrc for zsh
users), ~/.ocamlinit and ~/.opam/opam-init/*).</p>
<p>Please report:</p>
<ul>
<li>Bug reports and feature requests for the OPAM tool: <code>https://github.com/OCamlPro/opam/issues</code>
</li>
<li>Packaging issues or requests for a new packages: <code>https://github.com/OCamlPro/opam-repository/issues</code>
</li>
<li>General queries to: <code>https://lists.ocaml.org/listinfo/platform</code>
</li>
<li>More specific queries about the internals of OPAM to: <code>https://lists.ocaml.org/listinfo/opam-devel</code>
</li>
</ul>
<h2>Install</h2>
<p>Packages for Debian and OSX (at least homebrew) should follow shortly and
I'm looking for volunteers to create and maintain rpm packages. The binary
installer is up-to-date for Linux and Darwin 64-bit architectures, the
32-bit version for Linux should arrive shortly.</p>
<p>If you want to build from sources, the full archive (including dependencies)
is available here:</p>
<p><code>https://github.com/ocaml/opam/releases/tag/2.1.0</code></p>
<h3>Upgrade</h3>
<p>If you are upgrading from 0.9.* you won't  have anything special to do apart
installing the new binary. You can then update your package metadata by
running <code>opam update</code>. If you want to use the auto-setup feature, remove the
&quot;eval <code>opam config env</code> line you have previously added in your ~/.profile
and run <code>opam config setup --all</code>.</p>
<p>So everything should be fine. But you never know ... so if something goes
horribly wrong in the upgrade process (of if your are upgrading from an old
version of OPAM) you can still trash your ~/.opam, manually remove what OPAM
added in  your ~/.profile (~/.zshrc for zsh users) and ~/.ocamlinit, and
start again from scratch.</p>
<h3>Random stats</h3>
<p>Great success on github. Thanks everybody for the great contributions!</p>
<p><code>https://github.com/OCamlPro/opam</code>: +2000 commits, 26 contributors
<code>https://github.com/OCamlPro/opam-repository</code>: +1700 commits, 75 contributors, 370+ packages</p>
<p>on <code>http://opam.ocamlpro.com/</code>
+400 unique visitor per week, 15k 'opam update' per week
+1300 unique visitor per month, 55k 'opam update' per month
3815 unique visitor since the alpha release</p>
<h3>Changelog</h3>
<p>The full change-log since the beta release in January:</p>
<p>1.0.0 [Mar 2013]</p>
<ul>
<li>Improve the lexer performance (thx to @oandrieu)
</li>
<li>Fix various typos (thx to @chaudhuri)
</li>
<li>Fix build issue (thx to @avsm)
</li>
</ul>
<p>0.9.6 [Mar 2013]</p>
<ul>
<li>Fix installation of pinned packages on BSD (thx to @smondet)
</li>
<li>Fix configuration for zsh users (thx to @AltGr)
</li>
<li>Fix loading of <code>~/.profile</code> when using dash (eg. in Debian/Ubuntu)
</li>
<li>Fix installation of packages with symbolic links (regression introduced in 0.9.5)
</li>
</ul>
<p>0.9.5 [Mar 2013]</p>
<ul>
<li>If necessary, apply patches and substitute files before removing a package
</li>
<li>Fix <code>opam remove &lt;pkg&gt; --keep-build-dir</code> keeps the folder if a source archive is extracted
</li>
<li>Add build and install rules using ocamlbuild to help distro packagers
</li>
<li>Support arbitrary level of nested subdirectories in packages repositories
</li>
<li>Add <code>opam config exec &quot;CMD ARG1 ... ARGn&quot; --switch=SWITCH</code> to execute a command in a subshell
</li>
<li>Improve the behaviour of <code>opam update</code> wrt. pinned packages
</li>
<li>Change the default external solver criteria (only useful if you have aspcud installed on your machine)
</li>
<li>Add support for global and user configuration for OPAM (<code>opam config setup</code>)
</li>
<li>Stop yelling when OPAM is not up-to-date
</li>
<li>Update or generate <code>~/.ocamlinit</code> when running <code>opam init</code>
</li>
<li>Fix tests on *BSD (thx Arnaud Degroote)
</li>
<li>Fix compilation for the source archive
</li>
</ul>
<p>0.9.4 [Feb 2013]</p>
<ul>
<li>Disable auto-removal of unused dependencies. This can now be enabled on-demand using <code>-a</code>
</li>
<li>Fix compilation and basic usage on Cygwin
</li>
<li>Fix BSD support (use <code>type</code> instead of <code>which</code> to detect existing commands)
</li>
<li>Add a way to tag external dependencies in OPAM files
</li>
<li>Better error messages when trying to upgrade pinned packages
</li>
<li>Display <code>depends</code> and <code>depopts</code> fields in <code>opam info</code>
</li>
<li><code>opam info pkg.version</code> shows the metadata for this given package version
</li>
<li>Add missing <code>doc</code> fields in <code>.install</code> files
</li>
<li><code>opam list</code> now only shows installable packages
</li>
</ul>
<p>0.9.3 [Feb 2013]</p>
<ul>
<li>Add system compiler constraints in OPAM files
</li>
<li>Better error messages in case of conflicts
</li>
<li>Cleaner API to install/uninstall packages
</li>
<li>On upgrade, OPAM now perform all the remove action first
</li>
<li>Use a cache for main storing OPAM metadata: this greatly speed-up OPAM invocations
</li>
<li>after an upgrade, propose to reinstall a pinned package only if there were some changes
</li>
<li>improvements to the solver heuristics
</li>
<li>better error messages on cyclic dependencies
</li>
</ul>
<p>0.9.2 [Jan 2013]</p>
<ul>
<li>Install all the API files
</li>
<li>Fix <code>opam repo remove repo-name</code>
</li>
<li>speed-up <code>opam config env</code>
</li>
<li>support for <code>opam-foo</code> scripts (which can be called using <code>opam foo</code>)
</li>
<li>'opam update pinned-package' works
</li>
<li>Fix 'opam-mk-repo -a'
</li>
<li>Fix 'opam-mk-repo -i'
</li>
<li>clean-up pinned cache dir when a pinned package fails to install
</li>
</ul>
<p>0.9.1 [Jan 2013]</p>
<ul>
<li>Use ocaml-re 1.2.0
</li>
</ul>


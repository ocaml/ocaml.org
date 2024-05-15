---
title: OPAM 1.1.1 released
description: We are proud to announce that OPAM 1.1.1 has just been released. This
  minor release features mostly stability and UI/doc improvements over OPAM 1.1.0,
  but also focuses on improving the API and tools to be a better base for the platform
  (functions for opam-doc, interface with tools like opamfu and op...
url: https://ocamlpro.com/blog/2014_01_29_opam_1.1.1_released
date: 2014-01-29T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Louis Gesbert\n  "
source:
---

<p>We are proud to announce that <em>OPAM 1.1.1</em> has just been released.</p>
<p>This minor release features mostly stability and UI/doc improvements over
OPAM 1.1.0, but also focuses on improving the API and tools to be a better
base for the platform (functions for <code>opam-doc</code>, interface with tools like
<code>opamfu</code> and <code>opam-installer</code>). Lots of bigger changes are in the works, and
will be merged progressively after this release.</p>
<h2>Installing</h2>
<p>Installation instructions are available
<a href="http://opam.ocaml.org/doc/Quick_Install.html">on the wiki</a>.</p>
<p>Note that some packages may take a few days until they get out of the
pipeline. If you're eager to get 1.1.1, either use our
<a href="https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh">binary installer</a> or
<a href="https://github.com/ocaml/opam/releases/tag/1.1.1">compile from source</a>.</p>
<p>The 'official' package repository is now hosted at <a href="https://opam.ocaml.org">opam.ocaml.org</a>,
synchronised with the Git repository at
<a href="http://github.com/ocaml/opam-repository">http://github.com/ocaml/opam-repository</a>,
where you can contribute new packages descriptions. Those are under a CC0
license, a.k.a. public domain, to ensure they will always belong to the
community.</p>
<p>Thanks to all of you who have helped build this repository and made OPAM
such a success.</p>
<h2>Changes</h2>
<p>From the changelog:</p>
<ul>
<li>Fix <code>opam-admin make &lt;packages&gt; -r</code> (#990)
</li>
<li>Explicitly prettyprint list of lists, to fix <code>opam-admin depexts</code> (#997)
</li>
<li>Tell the user which fields is invalid in a configuration file (#1016)
</li>
<li>Add <code>OpamSolver.empty_universe</code> for flexible universe instantiation (#1033)
</li>
<li>Add <code>OpamFormula.eval_relop</code> and <code>OpamFormula.check_relop</code> (#1042)
</li>
<li>Change <code>OpamCompiler.compare</code> to match <code>Pervasives.compare</code> (#1042)
</li>
<li>Add <code>OpamCompiler.eval_relop</code> (#1042)
</li>
<li>Add <code>OpamPackage.Name.compare</code> (#1046)
</li>
<li>Add types <code>version_constraint</code> and <code>version_formula</code> to <code>OpamFormula</code> (#1046)
</li>
<li>Clearer command aliases. Made <code>info</code> an alias for <code>show</code> and added the alias
<code>uninstall</code> (#944)
</li>
<li>Fixed <code>opam init --root=&lt;relative path&gt;</code> (#1047)
</li>
<li>Display OS constraints in <code>opam info</code> (#1052)
</li>
<li>Add a new 'opam-installer' script to make <code>.install</code> files usable outside of opam (#1026)
</li>
<li>Add a <code>--resolve</code> option to <code>opam-admin make</code> that builds just the archives you need for a specific installation (#1031)
</li>
<li>Fixed handling of spaces in filenames in internal files (#1014)
</li>
<li>Replace calls to <code>which</code> by a more portable call (#1061)
</li>
<li>Fixed generation of the init scripts in some cases (#1011)
</li>
<li>Better reports on package patch errors (#987, #988)
</li>
<li>More accurate warnings for unknown package dependencies (#1079)
</li>
<li>Added <code>opam config report</code> to help with bug reports (#1034)
</li>
<li>Do not reinstall dev packages with <code>opam upgrade &lt;pkg&gt;</code> (#1001)
</li>
<li>Be more careful with <code>opam init</code> to a non-empty root directory (#974)
</li>
<li>Cleanup build-dir after successful compiler installation to save on space (#1006)
</li>
<li>Improved OSX compatibility in the external solver tools (#1074)
</li>
<li>Fixed messages printed on update that were plain wrong (#1030)
</li>
<li>Improved detection of meaningful changes from upstream packages to trigger recompilation
</li>
</ul>


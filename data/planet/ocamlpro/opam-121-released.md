---
title: OPAM 1.2.1 Released
description: 'OPAM 1.2.1 has just been released. This patch version brings a number
  of fixes and improvements over 1.2.0, without breaking compatibility. Upgrade from
  1.2.0 (or earlier) See the normal installation instructions: you should generally
  pick up the packages from the same origin as you did for the last...'
url: https://ocamlpro.com/blog/2015_03_18_opam_1.2.1_released
date: 2015-03-18T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Louis Gesbert\n  "
source:
---

<p><a href="https://github.com/ocaml/opam/releases/tag/1.2.1">OPAM 1.2.1</a> has just been
released. This patch version brings a number of fixes and improvements
over 1.2.0, without breaking compatibility.</p>
<h3>Upgrade from 1.2.0 (or earlier)</h3>
<p>See the normal
<a href="https://opam.ocaml.org/doc/Install.html">installation instructions</a>: you should
generally pick up the packages from the same origin as you did for the last
version -- possibly switching from the official repository packages to the ones
we provide for your distribution, in case the former are lagging behind.</p>
<h3>What's new</h3>
<p>No huge new features in this point release -- which means you can roll back
to 1.2.0 in case of problems -- but lots going on under the hood, and quite a
few visible changes nonetheless:</p>
<ul>
<li>The engine that processes package builds and other commands in parallel has
been rewritten. You'll notice the cool new display but it's also much more
reliable and efficient. Make sure to set <code>jobs:</code> to a value greater than 1 in
<code>~/.opam/config</code> in case you updated from an older version.
</li>
<li>The install/upgrade/downgrade/remove/reinstall actions are also processed in a
better way: the consequences of a failed actions are minimised, when it used
to abort the full command.
</li>
<li>When using version control to pin a package to a local directory without
specifying a branch, only the tracked files are used by OPAM, but their
changes don't need to be checked in. This was found to be the most convenient
compromise.
</li>
<li>Sources used for several OPAM packages may use <code>&lt;name&gt;.opam</code> files for package
pinning. URLs of the form <code>git+ssh://</code> or <code>hg+https://</code> are now allowed.
</li>
<li><code>opam lint</code> has been vastly improved.
</li>
</ul>
<p>... and much more</p>
<p>There is also a <a href="https://opam.ocaml.org/doc/Manual.html">new manual</a> documenting
the file and repository formats.</p>
<h3>Fixes</h3>
<p>See <a href="https://github.com/ocaml/opam/blob/1.2.1/CHANGES">the changelog</a> for a
summary or
<a href="https://github.com/ocaml/opam/issues?q=is:issue%20closed:%3E2014-10-16%20closed:%3C2015-03-05%20">closed issues</a>
in the bug-tracker for an overview.</p>
<h3>Experimental features</h3>
<p>These are mostly improvements to the file formats. You are welcome to use them,
but they won't be accepted into the
<a href="https://github.com/ocaml/opam-repository">official repository</a> until the next
release.</p>
<ul>
<li>New field <code>features:</code> in opam files, to help with <code>./configure</code> scripts and
documenting the specific features enabled in a given build. See the
<a href="https://github.com/ocaml/opam/blob/master/doc/design/depopts-and-features">original proposal</a>
and the section in the <a href="https://opam.ocaml.org/doc/Manual.html#opam">new manual</a>
</li>
<li>The &quot;filter&quot; language in opam files is now well defined, and documented in the
<a href="https://opam.ocaml.org/doc/Manual.html#Filters">manual</a>. In particular,
undefined variables are consistently handled, as well as conversions between
string and boolean values, with new syntax for converting bools to strings.
</li>
<li>New package flag &quot;verbose&quot; in opam files, that outputs the package's build
script to stdout
</li>
<li>New field <code>libexec:</code> in <code>&lt;name&gt;.install</code> files, to install into the package's
lib dir with the execution bit set.
</li>
<li>Compilers can now be defined without source nor build instructions, and the
base packages defined in the <code>packages:</code> field are now resolved and then
locked. In practice, this means that repository maintainers can move the
compiler itself to a package, giving a lot more flexibility.
</li>
</ul>


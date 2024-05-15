---
title: OPAM 1.2.2 Released
description: OPAM 1.2.2 has just been released. This fixes a few issues over 1.2.1
  and brings a couple of improvements, in particular better use of the solver to keep
  the installation as up-to-date as possible even when the latest version of a package
  can not be installed. Upgrade from 1.2.1 (or earlier) See the...
url: https://ocamlpro.com/blog/2015_05_07_opam_1.2.2_released
date: 2015-05-07T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Louis Gesbert\n  "
source:
---

<p><a href="https://github.com/ocaml/opam/releases/tag/1.2.2">OPAM 1.2.2</a> has just been
released. This fixes a few issues over 1.2.1 and brings a couple of improvements,
in particular better use of the solver to keep the installation as up-to-date as
possible even when the latest version of a package can not be installed.</p>
<h3>Upgrade from 1.2.1 (or earlier)</h3>
<p>See the normal
<a href="https://opam.ocaml.org/doc/Install.html">installation instructions</a>: you should
generally pick up the packages from the same origin as you did for the last
version -- possibly switching from the official repository packages to the ones
we provide for your distribution, in case the former are lagging behind.</p>
<p>There are no changes in repository format, and you can roll back to earlier
versions in the 1.2 branch if needed.</p>
<h3>Improvements</h3>
<ul>
<li>Conflict messages now report the original version constraints without
translation, and they have been made more concise in some cases
</li>
<li>Some new <code>opam lint</code> checks, <code>opam lint</code> now numbers its warnings and may
provide script-friendly output
</li>
<li>Feature to <strong>automatically install plugins</strong>, e.g. <code>opam depext</code> will prompt
to install <code>depext</code> if available and not already installed
</li>
<li><strong>Priority to newer versions</strong> even when the latest can't be installed (with a
recent solver only. Before, all non-latest versions were equivalent to the
solver)
</li>
<li>Added <code>opam list --resolve</code> to list a consistent installation scenario
</li>
<li>Be cool by default on errors in OPAM files, these don't concern end-users and
packagers and CI now have <code>opam lint</code> to check them.
</li>
</ul>
<h3>Fixes</h3>
<ul>
<li>OSX: state cache got broken in 1.2.1, which could induce longer startup times.
This is now fixed
</li>
<li><code>opam config report</code> has been fixed to report the external solver properly
</li>
<li><code>--dry-run --verbose</code> properly outputs all commands that would be run again
</li>
<li>Providing a simple path to an aspcud executable as external solver (through
options or environment) works again, for backwards-compatibility
</li>
<li>Fixed a fd leak on solver calls (thanks Ivan Gotovchits)
</li>
<li><code>opam list</code> now returns 0 when no packages match but no pattern was supplied,
which is more helpful in scripts relying on it to check dependencies.
</li>
</ul>


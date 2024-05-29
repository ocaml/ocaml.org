---
title: OPAM 1.2.0 Released
description: 'We are very proud to announce the availability of OPAM 1.2.0. Upgrade
  from 1.1 Simply follow the usual instructions, using your preferred method (package
  from your distribution, binary, source, etc.) as documented on the homepage. NOTE:
  There are small changes to the internal repository format (~/.o...'
url: https://ocamlpro.com/blog/2014_10_23_opam_1.2.0_released
date: 2014-10-23T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Louis Gesbert\n  "
source:
---

<p>We are very proud to announce the availability of OPAM 1.2.0.</p>
<h3>Upgrade from 1.1</h3>
<p>Simply follow the usual instructions, using your preferred method (package from
your distribution, binary, source, etc.) as documented on the
<a href="https://opam.ocaml.org/doc/Install.html">homepage</a>.</p>
<blockquote>
<p><strong>NOTE</strong>: There are small changes to the internal repository format (~/.opam).
It will be transparently updated on first run, but in case you might want to
go back and have anything precious there, you're advised to back it up.</p>
</blockquote>
<h3>Usability</h3>
<p>Lot of work has been put into providing a cleaner interface, with helpful
behaviour and messages in case of errors.</p>
<p>The <a href="https://opam.ocaml.org/doc/">documentation pages</a> also have been largely
rewritten for consistency and clarity.</p>
<h3>New features</h3>
<p>This is just the top of the list:</p>
<ul>
<li>A extended and versatile <code>opam pin</code> command. See the
<a href="https://ocamlpro.com/opam-1-2-pin">Simplified packaging workflow</a>
</li>
<li>More expressive queries, see for example <code>opam source</code>
</li>
<li>New metadata fields, including source repositories, bug-trackers, and finer
control of package behaviour
</li>
<li>An <code>opam lint</code> command to check the quality of packages
</li>
</ul>
<p>For more detail, see <a href="https://ocamlpro.com/opam-1-2-0-beta4">the announcement for the beta</a>,
<a href="https://raw.githubusercontent.com/ocaml/opam/1.2.0/CHANGES">the full changelog</a>,
and <a href="https://github.com/ocaml/opam/issues?q=label:%22Feature%20Wish%22%20milestone:1.2%20is:closed">the bug-tracker</a>.</p>
<h3>Package format</h3>
<p>The package format has been extended to the benefit of both packagers and users.
The repository already accepts packages in the 1.2 format, and this won't
affect 1.1 users as a rewrite is done on the server for compatibility with 1.1.</p>
<p>If you are hosting a repository, you may be interested in these
<a href="https://github.com/ocaml/opam/tree/master/admin-scripts">administration scripts</a>
to quickly take advantage of the new features or retain compatibility.</p>


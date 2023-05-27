---
title: 'OASIS-DB: alpha website available'
description:
url: http://www.ocamlcore.com/wp/2010/08/oasis-db-alpha-website-available/
date: 2010-08-23T13:51:52-00:00
preview_image:
featured:
authors:
- ocamlcore
---

<p>A prototype version of OASIS-DB is up and running, go to the official OASIS website and follow the link to test it:</p>
<table width="100%" cellspacing="1" cellpadding="1" border="0">
<tbody>
<tr>
<td>
<p><a href="http://oasis.ocamlcore.org">http://oasis.ocamlcore.org</a></p>
<p>(direct link to the <a href="http://oasis.ocamlcore.org/dev">development&nbsp; version</a> and <a href="http://oasis.forge.ocamlcore.org/oasis-db/server-dev/">access to various files</a>)</p>
</td>
<td><img src="http://www.ocamlcore.com/wp/wp-content/uploads/logo.png" align="right" width="100" height="94" alt=""/></td>
</tr>
</tbody>
</table>
<p>&nbsp;</p>
<p>This version is only a <em>very early prototype</em>. For now, the main focus was to adapt OASIS to the requirements of OASIS-DB. In particular, <a href="http://ocsigen.org">ocsigen</a> brings additional constraints because the library is used at the same time by many users. For example, it implies to replace <a href="http://caml.inria.fr/pub/docs/manual-ocaml/manual037.html">Str</a> by <a href="http://www.ocaml.info/home/ocaml_sources.html#pcre-ocaml"> Pcre</a> for regular expression because the later is thread safe.</p>
<p>The login is connected to a stub so that everyone can login without password. OASIS-DB will use <a href="http://forge.ocamlcore.org">forge.ocamlcore.org</a> authentification in a future version but this will also restrict access.</p>
<p>There is still a lot of things to do, but you can:</p>
<ul>
<li>upload a tarball with or without _oasis file,</li>
<li>download a tarball from its original location or directly on OASIS-DB,</li>
<li>browse available packages,</li>
<li>render _oasis files using a subset <a href="http://daringfireball.net/projects/markdown/">Markdown</a> for description (thanks to Mauricio Fernandez for this part)</li>
</ul>
<p>OASIS-DB is&nbsp; a <a href="http://en.wikipedia.org/wiki/CPAN">CPAN</a> for OCaml. It is developped by <a href="http://www.ocamlcore.com">OCamlCore</a>, with support from the OCaml enthusiasts at <a href="http://janestreet.com/">Jane Street</a>.</p>
<p>More information about <a href="http://oasis.forge.ocamlcore.org">OASIS</a> and more precisely about <a href="http://oasis.forge.ocamlcore.org/oasis-db.html">OASIS-DB</a>.</p>


---
title: Summer Ocsigen releases
description:
url: https://ocsigen.github.io/blog/2015/08/17/releases/
date: 2015-08-17T00:00:00-00:00
preview_image:
featured:
authors:
- Gabriel Radanne
---

<p>We are happy to announce the releases of</p>

<ul>
  <li><a href="https://github.com/ocsigen/eliom/releases/tag/4.2">Eliom 4.2</a></li>
  <li><a href="https://github.com/ocsigen/ocsigenserver/releases/tag/2.6">Server 2.6</a></li>
  <li><a href="https://github.com/ocsigen/js_of_ocaml/releases/tag/2.6">js_of_ocaml 2.6</a></li>
  <li><a href="https://github.com/ocsigen/tyxml/releases/tag/3.5.0">TyXML 3.5</a></li>
</ul>

<p>We also welcome a new member in the ocsigen team, <a href="https://github.com/vasilisp">Vasilis Papavasileiou</a>.</p>

<p>Key changes in the various releases:</p>

<ul>
  <li>
    <p>PPX support for js_of_ocaml with OCaml &gt;= 4.02.2.
See documentation <a href="http://ocsigen.org/js_of_ocaml/2.6/api/Ppx_js">here</a>.</p>

    <p>This was also the occasion to introduce a new syntax for object
literals, and to improve the Camlp4 syntax (w.r.t. to
locations). Both syntaxes emit the same code, and are perfectly
compatible.</p>
  </li>
  <li>
    <p>Support for dynlink in js_of_ocaml.</p>
  </li>
  <li>
    <p>Logging improvements in Eliom and Server, in particular on
the client side.</p>
  </li>
  <li>
    <p>A healthy amount of bugfixes.</p>
  </li>
</ul>

<p>The next releases will probably see major changes. The current plan
is:</p>

<ul>
  <li>
    <p>Replace Server&rsquo;s internals with cohttp, as part of our
move towards Mirage-compatible libraries. See <a href="https://github.com/ocsigen/ocsigenserver/issues/54">here</a>.</p>
  </li>
  <li>
    <p>Shared_react, which allows to build reactive pages from server side. See <a href="https://github.com/ocsigen/eliom/issues/162">here</a>.</p>
  </li>
  <li>
    <p>PPX for Eliom.</p>
  </li>
  <li>
    <p>Support for async/core in js_of_ocaml.</p>
  </li>
</ul>

<p>Have fun with Ocsigen!</p>


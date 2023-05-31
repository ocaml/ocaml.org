---
title: January 2016 Ocsigen releases
description:
url: https://ocsigen.github.io/blog/2016/02/01/january-2016-releases/
date: 2016-02-01T00:00:00-00:00
preview_image:
featured:
authors:
- The Ocsigen team
---

<p>We are excited to announce the releases of</p>

<ul>
  <li><a href="https://github.com/ocsigen/eliom/releases/tag/5.0.0">Eliom 5.0</a></li>
  <li><a href="https://github.com/ocsigen/js_of_ocaml/releases/tag/2.7">js_of_ocaml 2.7</a></li>
  <li><a href="https://github.com/ocsigen/tyxml/releases/tag/3.6.0">TyXML 3.6</a></li>
  <li><a href="https://github.com/ocsigen/reactiveData/releases/tag/0.2">reactiveData 0.2</a></li>
</ul>

<p>These releases are the result of many months of work by the Ocsigen
team, and bring a range of improvements.</p>

<h2>PPX</h2>

<p>Eliom 5.0 comes with a <a href="http://ocsigen.org/eliom/5.0/manual/ppx-syntax">PPX-based
language</a> (for OCaml
4.02.x). This follows our PPX extensions for
<a href="https://ocsigen.org/js_of_ocaml/2.7/api/Ppx_js">js_of_ocaml</a> and
<a href="https://ocsigen.org/lwt/2.5.1/api/Ppx_lwt">Lwt</a>. The new syntax is
more flexible than our previous Camlp4-based one, and we recommend it
for new projects. Nevertheless, the Camlp4-based syntax remains
available.</p>

<h2>Shared reactive programming</h2>

<p>Recent versions of Eliom provided client-side support for (functional)
reactive programming. Eliom 5.0 additionally supports <a href="http://ocsigen.org/eliom/5.0/manual/clientserver-react">&ldquo;shared&rdquo;
(client-server) reactive
programming</a>,
where the reactive signals have meaning both on the server and the
client. This means that the initial version of the page is produced
(on the server) with the same code that takes care of the dynamic
updates (on the client).</p>

<h2>Enhanced js_of_ocaml library</h2>

<p>The js_of_ocaml library provides additional bindings for established
JavaScript APIs. This includes</p>

<ul>
  <li><a href="http://ocsigen.org/js_of_ocaml/2.7/api/Geolocation">geolocation</a>,</li>
  <li><a href="http://ocsigen.org/js_of_ocaml/2.7/api/MutationObserver">mutation
observers</a>, and</li>
  <li><a href="http://ocsigen.org/js_of_ocaml/2.7/api/Worker">web workers</a>.</li>
</ul>

<p>A new JavaScript-specific <a href="http://ocsigen.org/js_of_ocaml/2.7/api/Jstable">table
module</a> is also
available.</p>

<h2>ppx_deriving</h2>

<p>js_of_ocaml provides a new <a href="https://github.com/ocsigen/js_of_ocaml/pull/364">JSON
  plugin</a> for
  <a href="https://github.com/whitequark/ppx_deriving">ppx_deriving</a>. This can
  be used for serializing OCaml data structures to JSON in a type-safe
  way. The plugin remains compatible with its Camlp4-based predecessor
  with respect to the serialization format.</p>

<h2>Under the hood</h2>

<p>In addition to providing various fixes, we have improved the
performance of various Ocsigen components. Notably:</p>

<ul>
  <li>
    <p>A <a href="https://github.com/ocsigen/eliom/pull/233">range of patches related to request
data</a> result in
measurably smaller size for the produced pages.</p>
  </li>
  <li>
    <p>The js_of_ocaml compiler becomes faster via improvements in
<a href="https://github.com/ocsigen/js_of_ocaml/commit/3991c07b15d88c89bad43de8303b0e0a553b2eed">bytecode
parsing</a>.</p>
  </li>
  <li>
    <p>reactiveData employs
<a href="https://github.com/ocsigen/reactiveData/pull/12">diffing</a> to detect
data structure changes, leading to more localized incremental
updates.</p>
  </li>
</ul>

<h2>Community</h2>

<p>The Ocsigen team always welcomes your feedback and contributions.
Stay in touch via <a href="https://github.com/ocsigen">GitHub</a> and our
<a href="https://sympa.inria.fr/sympa/subscribe/ocsigen">mailing list</a>!</p>


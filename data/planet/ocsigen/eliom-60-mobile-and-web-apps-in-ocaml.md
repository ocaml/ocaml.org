---
title: 'Eliom 6.0: mobile and Web apps in OCaml'
description:
url: https://ocsigen.github.io/blog/2016/12/12/eliom6/
date: 2016-12-12T00:00:00-00:00
preview_image:
featured:
authors:
- The Ocsigen Team
---

<p>We are very happy to announce the release of <a href="https://github.com/ocsigen/eliom/releases/tag/6.0.0">Ocsigen Eliom 6.0</a>,
which follows the recent releases of
<a href="https://github.com/ocsigen/ocsigenserver/releases/tag/2.8">Ocsigen Server 2.8</a>
and <a href="https://github.com/ocsigen/js_of_ocaml/releases/tag/2.8.3">Ocsigen Js_of_ocaml 2.8.x</a>.</p>

<p>New features include a friendlier service API that retains the
expressive power of our service system. Additionally, Eliom can now be
used to build cross-platform Web/mobile applications (Android, iOS, &hellip;).</p>

<h2>What is Eliom?</h2>

<p>Eliom is a framework for developing client/server web
applications. Both the server and the client parts of the application
are written in OCaml, as a single program. Communication between
server and client is straightforward, e.g., one can just call a
server-side function from client-side code.</p>

<p>Eliom makes extensive use of the OCaml language features. It provides
advanced functionality like a powerful session mechanism and support
for functional reactive Web pages.</p>

<h2>Friendly service APIs</h2>

<p>Services are a key concept in Eliom, used for building the pages that
are sent to the user, for accessing server-side data, for performing
various actions, and so on. Eliom 6.0 provides a friendlier API for
defining and registering services, thus making Eliom more
approachable.</p>

<p>The new API makes extensive use of OCaml&rsquo;s <a href="https://en.wikipedia.org/wiki/Generalized_algebraic_data_type">GADTs</a>, and provides
a single entry-point that supports most kinds of services
(<a href="https://ocsigen.org/eliom/api/server/Eliom_service#VALcreate">Eliom_service.create</a>). For more information, refer
to the <a href="https://ocsigen.org/eliom/dev/manual/server-services">Eliom manual</a>.</p>

<h2>Mobile applications</h2>

<p>Eliom 6.0 allows one to build applications for multiple mobile
platforms (including iOS, Android, and Windows) with the same codebase
as for a Web application, and following standard Eliom idioms.</p>

<p>To achieve this, we have made available the Eliom service APIs
<a href="https://ocsigen.org/eliom/manual/clientserver-services">on the client</a>. Thus, the user interface can be
produced directly on the mobile device, with remote calls only when
absolutely necessary.</p>

<p>To build an Eliom 6.0 mobile application easily, we recommend that you
use our soon-to-be-released <a href="https://github.com/ocsigen/ocsigen-start">Ocsigen Start</a> project, which
provides a mobile-ready template application
(<a href="https://ocsigen.org/tuto/manual/mobile">walkthrough</a>).</p>

<h2>Compatibility</h2>

<p>Eliom 6.0 supports the last 3 major versions of OCaml (4.02 up to
4.04). Additionally, Eliom is compatible with and builds on the
latest Ocsigen releases, including
<a href="https://github.com/ocsigen/ocsigenserver/releases/tag/2.8">Ocsigen Server 2.8</a>,
<a href="https://github.com/ocsigen/js_of_ocaml/releases/tag/2.8.3">Js_of_ocaml 2.8.x</a>, and <a href="https://github.com/ocsigen/tyxml/releases/tag/4.0.1">TyXML 4.0.x</a>.</p>

<h2>Future</h2>

<p>The Ocsigen team is busy working on new features. Notably, we are
developing an <a href="https://github.com/ocsigen/ocaml-eliom">OCaml compiler</a> specifically tuned for
Eliom. Additionally, we are planning a transition to the
<a href="https://github.com/mirage/ocaml-cohttp">Cohttp</a> HTTP backend.</p>

<h2>Support</h2>

<ul>
  <li><a href="https://ocsigen.org/eliom/Eliom60">Migration guide</a></li>
  <li><a href="https://github.com/ocsigen/eliom/issues">Issue tracker</a></li>
  <li><a href="https://sympa.inria.fr/sympa/info/ocsigen">Mailing list</a></li>
  <li>IRC: <code class="language-plaintext highlighter-rouge">#ocsigen</code> on <code class="language-plaintext highlighter-rouge">irc.freenode.net</code></li>
</ul>



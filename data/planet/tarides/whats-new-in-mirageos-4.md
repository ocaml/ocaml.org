---
title: What's New in MirageOS 4!
description: "MirageOS 4.0 Release Week Tarides is thrilled to see the great responses
  to MirageOS\n4.0 and the excitement\nthat\u2019s building across the\u2026"
url: https://tarides.com/blog/2022-04-14-what-s-new-in-mirageos-4
date: 2022-04-14T00:00:00-00:00
preview_image: https://tarides.com/static/656a2275778454f88a6e1dcb3f2d53cf/2070e/mirage2.jpg
featured:
---

<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#mirageos-40-release-week" aria-label="mirageos 40 release week permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>MirageOS 4.0 Release Week</h2>
<p>Tarides is thrilled to see the great responses to <a href="https://mirage.io/blog/announcing-mirage-40">MirageOS
4.0</a> and the excitement
that&rsquo;s building across the community. We&rsquo;re proud to have played an
important part in its development and release, bringing great tools
and opportunities to OCaml developers. If you haven&rsquo;t kept up with
what&rsquo;s been going on since the release, here is a summary of several
articles posted by various OCaml users.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#cross-compilation" aria-label="cross compilation permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Cross-Compilation</h3>
<p>The MirageOS 4.0 update brings with it a major change in its build
system to support <a href="https://dune.build/">the Dune build system</a>.
Tarides has been working on this feature since 2019,
iterating on various design solutions in the <code>mirage</code> tool with
<a href="https://github.com/mirage/mirage/issues/969">mirage/mirage/#</a>,
<a href="https://github.com/mirage/mirage/pull/979">mirage/mirage#979</a>,
<a href="https://github.com/mirage/mirage/pull/1020">mirage/mirage/#1020</a>,
<a href="https://github.com/mirage/mirage/pull/1024">mirage/mirage#1024</a>,
<a href="https://github.com/mirage/mirage/pull/1153">mirage/mirage#1153</a>, and
finally <a href="https://github.com/mirage/mirage/pull/1226">miarge/mirage#1226</a>.
This incremental process resulted in making several contributions to
upstream OCaml for features and tools required to support
the flexible building of MirageOS libraries: for
instance, adding support for <a href="https://dune.readthedocs.io/en/stable/variants.html">virtual library and
variants</a> in Dune
with <a href="https://github.com/ocaml/dune/pull/1900">ocaml/dune#1900</a>,
<a href="https://github.com/ocaml/dune/pull/2098">ocaml/dune#2098</a>, and
<a href="https://github.com/ocaml/dune/pull/2169">ocaml/dune#2169</a>; or the
development or a new opam plugin to manage
<a href="https://github.com/ocamllabs/opam-monorepo">mono-repositories</a>. We
are happy to see it released to all with Mirage 4.0.</p>
<p>What makes Dune a great option to build MirageOS is that it allows for
customisable cross-compilation flags to compile MirageOS to different
architectures. Using Dune also enables developers to use the Merlin
tool to access a rich set of IDE features when writing
applications. It unlocks a new development workflow based on
<code>opam-monorepo</code>, which downloads all the unikernel dependencies into a
single Dune workspace. Having a single workspace containing all of the
unikernel&rsquo;s code lets developers edit code anywhere in the stack,
which makes work like debugging libraries and improving APIs a faster
and more enjoyable experience. In his <a href="https://mirage.io/blog/2022-03-30.cross-compilation">excellent article on build
contexts in MirageOS
4.0</a>, Lucas
Pluvinage goes into detail about how to use the new cross-compilation
features to build MirageOS unikernels for new architectures.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#email-in-ocaml--mr-mime" aria-label="email in ocaml  mr mime permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Email in OCaml &amp; Mr. MIME</h3>
<p>Mr. MIME is an OCaml library that aims to give its users peace of mind
when it comes to the security of their email communications. Mr. MIME
is built on unikernels and deploys them to handle email traffic. At
Tarides, we got a grant from <a href="https://dapsi.ngi.eu/">NGI DAPSI</a> to
work on this project, and several of our engineers have been busy
working hard to make it happen.</p>
<p>Several other libraries support the Mr. MIME library and enable it to
transform an email into an OCaml value, then create an email from it
again. An amazing thing about Mr. MIME is its reliability. Using the
<a href="https://github.com/mirage/hamlet"><code>hamlet</code></a> tool, which proposes a
large corpus of emails for Mr. MIME to parse and re-encode, the team
can prove that Mr. MIME doesn&rsquo;t alter anything in the message between
the parser and the encoder.</p>
<p>The team behind Mr. MIME has also created the library
<em><a href="https://github.com/mirage/colombe">Colombe</a></em> that implements the
foundations of an SMTP protocol with the ability to upgrade its flow
to TLS, giving its users an extra layer of security. A goal for the
future is to provide a full SMTP stack that&rsquo;s able to send and receive
emails.</p>
<p>Mr. MIME also allows its users to manipulate emails through the use of
CLI tools, including
<a href="https://github.com/mirage/ocaml-dkim"><code>ocaml-dkim</code></a>, a tool to verify
and sign an email, and
<a href="https://github.com/mirage/spamtacus"><code>spamtacus</code></a>, a tool which
analyses the incoming email to determine if it&rsquo;s spam or not. The
<a href="https://github.com/mirage/ptt">ptt repo</a> contains several more as well.</p>
<p>If you want to find out more information about Mr. MIME, including
details about its architecture, please read Romain Calascibetta&rsquo;s
<a href="https://mirage.io/blog/2022-04-01-Mr-MIME">article</a>.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#mirageos-in-production" aria-label="mirageos in production permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>MirageOS in Production</h2>
<p>The use of MirageOS benefits not only Tarides, but it also enables
several other companies to make their products better. Below are a
couple of examples from <a href="https://docker.com">Docker</a> and
<a href="https://robur.coop">Robur</a> on how they use MirageOS to their
advantage.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#vpn-kit" aria-label="vpn kit permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>VPN Kit</h3>
<p>Docker Desktop is a tool that enables its users to build and share
containerised or isolated applications in either a Mac or Windows
environment. Its main challenge is that running Docker on macOS or
Windows is difficult in terms of compatibility, as Linux primitives
are unavailable on those platforms.</p>
<p>This is where VPN Kit comes in; it uses MirageOS to bridge the gap
between Linux primitives and macOS or Windows by reading the raw
ethernet frames coming out of the Linux VM and translating them into
macOS or Windows high-level syscalls. In this way, MirageOS networking
libraries transparently handle the traffic of millions of containers
every day.</p>
<p>To find out more go read the article &ldquo;How MirageOS Powers Docker
Desktop&rdquo; <a href="https://mirage.io/blog/2022-04-06.vpnkit">on mirage.io</a>
or
<a href="https://www.docker.com/blog/how-docker-desktop-networking-works-under-the-hood/">on docker.com</a>.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#robur-projects" aria-label="robur projects permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Robur Projects</h3>
<p>Robur uses MirageOS for several of their projects, including OpenVPN,
DNS Projects, and CalDAV. All of these projects are written in OCaml
and are deployed as MirageOS unikernels.</p>
<p>The DNS Projects include the &lsquo;Let&rsquo;s Encrypt&rsquo;-Certified DNS solver, a
DNS resolver, and an authoritative DNS server. Robur&rsquo;s DNS server
ensures that the internet user gets to the right IP address, whilst
its DNS resolver finds the exact server to handle the user&rsquo;s
request. Only strictly necessary elements are included in order to
keep the codebase as small as possible for security and
simplicity.</p>
<p>CalDAV is the most recent unikernel released by Robur. As the name
implies, CalDAV is a protocol used to synchronise calendars.
Its minimal codebase comes with significant security benefits.</p>
<p>To find out more go read the article &ldquo;MirageOS Unikernels at Robur&rdquo; on
<a href="https://mirage.io/blog/2022-04-08.robur">mirage.io</a>.</p>
<hr/>
<p>To learn more about MirageOS, take a look at some recent articles at
<a href="https://mirage.io">mirage.io</a>.
If you&rsquo;re interested in working with Tarides or
incorporating MirageOS tools in your project, please <a href="https://tarides.com/company">contact us via
our website</a>.</p>

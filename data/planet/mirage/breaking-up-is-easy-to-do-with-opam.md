---
title: Breaking up is easy to do (with OPAM)
description:
url: https://mirage.io/blog/breaking-up-is-easy-with-opam
date: 2012-10-17T00:00:00-00:00
preview_image:
featured:
authors:
- Anil Madhavapeddy
---


        <p>When we first started developing Mirage in 2009, we were rewriting huge chunks of operating system and runtime code in OCaml. This ranged from low-level device drivers to higher-level networking protocols such as TCP/IP or HTTP.  The changes weren't just straight rewrites of C code either, but also involved experimenting with interfaces such as iteratees and <a href="https://mirage.io/wiki/tutorial-lwt">lightweight threading</a> to take advantage of OCaml's static type system.  To make all of this easy to work with, we decided to lump everything into a <a href="http://github.com/avsm/mirage">single Git repository</a> that would bootstrap the entire system with a single <code>make</code> invocation.</p>
<p>Nowadays though, Mirage is self-hosting, the interfaces are settling down, the number of libraries are growing every day, and portions of it are being used in <a href="https://mirage.io/blog/xenstore-stub-domain">the Xen Cloud Platform</a>. So for the first developer release, we wanted to split up the monolithic repository into more manageable chunks, but still make it as easy as possible for the average OCaml developer to try out Mirage.</p>
<p>Thanks to much hard work from <a href="http://gazagnaire.org">Thomas</a> and his colleagues at <a href="http://ocamlpro.com">OCamlPro</a>, we now have <a href="http://opam.ocamlpro.com">OPAM</a>: a fully-fledged package manager for Mirage!  OPAM is a source-based package manager that supports a growing number of community OCaml libraries.  More importantly for Mirage, it can also switch between multiple compiler installations, and so support cross-compiled runtimes and modified standard libraries.</p>
<p>OPAM includes compiler variants for Mirage-friendly environments for Xen and the UNIX <code>tuntap</code> backends.  The <a href="https://mirage.io/wiki/install">installation instructions</a> now give you instructions on how to use OPAM, and the old monolithic repository is considered deprecated.  We're still working on full documentation for the first beta release, but all the repositories are on the <a href="http://github.com/mirage">Mirage organisation</a> on Github, with some of the important ones being:</p>
<ul>
<li><a href="http://github.com/mirage/mirage-platform">mirage-platform</a> has the core runtime for Xen and UNIX, implemented as the <code>OS</code> module.
</li>
<li><a href="http://github.com/mirage/mirage-net">mirage-net</a> has the TCP/IP networking stack.
</li>
<li><a href="http://github.com/mirage/ocaml-cstruct">ocaml-cstruct</a> has the camlp4 extension to manipulate memory like C <code>struct</code>s, but with type-safe accessors in OCaml.
</li>
<li><a href="http://github.com/mirage/ocaml-xenstore">ocaml-xenstore</a> has a portable implementation of the Xenstore protocol to communicate with the Xen management stack from a VM (or even act as a <a href="https://mirage.io/blog/xenstore-stub-domain">server in a stub domain</a>).
</li>
<li><a href="http://github.com/mirage/ocaml-dns">ocaml-dns</a> is a pure OCaml implementation of the DNS protocol, including a server and stub resolver.
</li>
<li><a href="http://github.com/mirage/ocaml-re">ocaml-re</a> is a pure OCaml version of several regular expression engines, including Perl compatibility.
</li>
<li><a href="http://github.com/mirage/ocaml-uri">ocaml-uri</a> handles parsing the surprisingly complex URI strings.
</li>
<li><a href="http://github.com/mirage/ocaml-cohttp">ocaml-cohttp</a> is a portable HTTP parser, with backends for Mirage, Lwt and Core/Async. This is a good example of how to factor out OS-specific concerns using the OCaml type system (and I plan to blog more about this soon).
</li>
<li><a href="http://github.com/mirage/ocaml-cow">ocaml-cow</a> is a set of syntax extensions for JSON, CSS, XML and XHTML, which are explained <a href="https://mirage.github.io/wiki/cow">here</a>, and used by this site.
</li>
<li><a href="http://github.com/mirage/dyntype">ocaml-dyntype</a> uses camlp4 to <a href="http://anil.recoil.org/papers/2011-dynamics-ml.pdf">generate dynamic types</a> and values from OCaml type declarations.
</li>
<li><a href="http://github.com/mirage/orm">ocaml-orm</a> auto-generates SQL scheme from OCaml types via Dyntype, and currently supports SQLite.
</li>
<li><a href="http://github.com/mirage/ocaml-openflow">ocaml-openflow</a> implements an OCaml switch and controller for the Openflow protocol.
</li>
</ul>
<p>There are quite a few more that are still being hacked for release by the team, but we're getting there very fast now. We also have the Mirage ports of <a href="http://github.com/avsm/ocaml-ssh">SSH</a> to integrate before the first release this year, and Haris has got some <a href="http://github.com/mirage/ocaml-crypto-keys">interesting DNSSEC</a> code!  If you want to get involved, join the <a href="https://mirage.io/about">mailing list</a> or IRC channel!</p>

      

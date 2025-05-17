---
title: Functional ABNF parser generators
description:
url: https://anil.recoil.org/ideas/functional-imap
date: 2011-01-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<h1>Functional ABNF parser generators</h1>
<p>This is an idea proposed in 2011 as a Cambridge Computer Science Part II project, and has been <span class="idea-completed">completed</span> by <a href="https://github.com/ns476" class="contact">Nicholas Skehin</a>.</p>
<p>Writing internet servers is a difficult proposition. On some levels it seems as
though we haven’t made much progress since the 1970s, as popular servers such as
Apache and nginx for HTTP, BIND for DNS and qmail for IMAP for many Internet
protocols still tend to be written in C. While it is not impossible to write
robust software in C, it does tend to be extremely difficult and almost all of
the above have suffered from their fair share of security vulnerabilities.
With the advent of higher level programming languages, this does not need to be
the case any longer. Modern functional languages such as OCaml and Haskell can
be competitive performance-wise with C on many workloads. In many cases their
emphasis on purity where possible comes with significant benefits when moving
towards an environment where concurrent execution is the norm rather than the
exception.</p>
<p>This project aimed to build a functional parser for the IMAP email protocol
in OCaml, and to compare its performance and flexibility against a C-based
parser.  IMAP is a very complex protocol with many quirks and has endured several
buggy implementations through the years on both the server and the client side.
Since writing a parser for IMAP by hand was going to be tedious and error prone,
this project focusses on how better tooling to make writing parsers for internet
servers a more manageable and pain-free experience. Specifically, it investigated
writing ABNF generators for OCaml, since IMAP was already specified using that.</p>
<h2>Related Reading</h2>
<ul>
<li>RFC 3501 and the ABNF spec of IMAP.</li>
<li>An OCaml <a href="https://github.com/nojb/ocaml-imap">IMAP implementation</a></li>
<li><a href="https://anil.recoil.org/papers/rwo">Real World OCaml: Functional Programming for the Masses</a></li>
</ul>
<h2>Links</h2>
<p>The dissertation PDF isn't available publically but
should be in the Cambridge Computer Lab archives somewhere.
The ABNFComp tool that was built is also available on request
from the author, but not published.</p>


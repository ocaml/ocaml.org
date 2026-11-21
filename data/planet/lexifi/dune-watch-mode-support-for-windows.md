---
title: Dune watch mode support for Windows
description: "Between May and August 2022, Uma Kothuri from the US interned with us
  at LexiFi and worked on adding native Windows support for Dune\u2019s watch mode
  (dune build -w). The internship was a big success, but, unfortunately we ran out
  of time before the contribution could be polished for submission upstream, which
  delayed its integration in Dune."
url: https://www.lexifi.com/blog/ocaml/dune-watch-mode-windows/
date: 2023-03-02T00:00:00-00:00
preview_image:
authors:
- LexiFi
source:
ignore:
keywords:
- OCaml LSP
- completion
- dune
- mode
- notifications
- readdirectorychangesw
- thread
- type checker
- watch
- windows
---

<p>Between May and August 2022, Uma Kothuri from the US interned with us at LexiFi
and worked on adding native Windows support for Dune’s watch mode (<code>dune build -w</code>). The internship was a big success, but, unfortunately we ran out of time
before the contribution could be polished for submission upstream, which delayed
its integration in Dune.</p>
<p><a href="https://github.com/ocaml/dune/pull/7010">This is now done</a>, and the support has
been included in the <a href="https://discuss.ocaml.org/t/ann-dune-3-7-0/11474">latest
release</a> of Dune. To mark the
occassion we are writing this note to give a semi-technical overview of how the
feature is implemented.  And, of course, we warmly invite all Windows Dune users
to give it a go and report any issues that come up in the <a href="https://github.com/ocaml/dune/issues">official bug
tracker</a>.</p>

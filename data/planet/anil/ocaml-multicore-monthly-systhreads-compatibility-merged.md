---
title: 'OCaml Multicore Monthly: systhreads compatibility merged'
description: OCaml Multicore now supports systhreads compatibility for seamless integration.
url: https://anil.recoil.org/notes/multicore-monthly-sep20
date: 2020-08-20T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<p>The big advance in the multicore OCaml branch is that we restored compatibility
with the traditional OCaml systhreads. This in turn means that many existing
software packages just work out of the box on the new runtime.</p>
<blockquote>
<p>Big news this month is that the systhreads compatibility support PR has been
merged, which means that Dune (and other users of the Thread module) can
compile out of the box. You can now compile the multicore OCaml fork
conveniently using the new opam compiler plugin (see announcement).
<cite>-- <a href="https://discuss.ocaml.org/t/multicore-ocaml-september-2020/6565">me, on the discussion forum</a></cite></p>
</blockquote>


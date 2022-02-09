---
title: Simple top-down development in OCaml
description: Often when writing a new module, I want to write the interface first
  and savethe implementation for later. This lets me use the module as a black box,extendi...
url: https://blog.janestreet.com/simple-top-down-development-in-ocaml/
date: 2014-07-18T00:00:00-00:00
preview_image: https://blog.janestreet.com/static/img/header.png
featured:
---

<p>Often when writing a new module, I want to write the interface first and save
the implementation for later. This lets me use the module as a black box,
extending the interface as needed to support the rest of the program. When
everything else is finished, I can fill in the implementation, knowing the full
interface I need to support. Of course sometimes the implementation needs to
push back on the interface &ndash; this pattern isn&rsquo;t an absolute &ndash; but it&rsquo;s certainly
a useful starting point. The trick is getting the program to compile at
intermediate stages when the implementation hasn&rsquo;t been filled in.</p>



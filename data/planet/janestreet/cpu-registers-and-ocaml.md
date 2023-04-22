---
title: CPU Registers and OCaml
description: Even though registers are a low-level CPU concept, having some knowledge
  aboutthem can help write faster code. Simply put, a CPU register is a storage for
  as...
url: https://blog.janestreet.com/cpu-registers-and-ocaml-2/
date: 2015-05-05T00:00:00-00:00
preview_image: https://blog.janestreet.com/static/img/header.png
featured:
---

<p>Even though registers are a low-level CPU concept, having some knowledge about
them can help write faster code. Simply put, a CPU register is a storage for a
single variable. CPU can keep data in memory or cache or in registers and
registers are often much faster. Furthermore, some operations are possible only
when the data is in registers. Hence, the OCaml compiler tries to keep as many
variables as it can in the registers.</p>



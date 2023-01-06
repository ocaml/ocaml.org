---
title: Accelerating zk-SNARKs - MSM and NTT algorithms on FPGAs with Hardcaml
description: "In 2022 a consortium of companies ran an international competition,called
  the ZPrize, to advance the state ofthe art in \u201Czero-knowledge\u201D cryptography.
  We dec..."
url: https://blog.janestreet.com/zero-knowledge-fpgas-hardcaml/
date: 2022-12-07T00:00:00-00:00
preview_image: https://blog.janestreet.com/zero-knowledge-fpgas-hardcaml/hardcaml-zprize.jpg
featured:
---

<p>In 2022 a consortium of companies ran an international competition,
called the <a href="https://www.zprize.io/">ZPrize</a>, to advance the state of
the art in &ldquo;zero-knowledge&rdquo; cryptography. We decided to have a go in
our free time at submitting solutions to both the Multi-Scalar
Multiplication (MSM) and Number Theoretic Transform (NTT) tracks,
using the same open source <a href="https://hardcaml.com/">Hardcaml</a> libraries
that Jane Street uses for our own FPGA development. We believe by
using Hardcaml we were able to more efficiently and robustly come up
with designs in the short competition period. These designs also
interact with the standard vendor RTL flow and so we hope they will be
useful to others.</p>



---
title: Effective geospatial code in OCaml
description:
url: https://anil.recoil.org/ideas/effective-geospatial-code
date: 2024-01-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<h1>Effective geospatial code in OCaml</h1>
<p>This is an idea proposed in 2024 as a Cambridge Computer Science Part II project, and is currently <span class="idea-ongoing">being worked on</span> by <a href="mailto:gp528@cam.ac.uk" class="contact">George Pool</a>. It is co-supervised with <a href="https://mynameismwd.org" class="contact">Michael Dales</a> and <a href="https://patrick.sirref.org" class="contact">Patrick Ferris</a>.</p>
<p>Geospatial data processing is a critical component of many scientific and engineering workflows, from environmental monitoring to urban planning. However, writing geospatial code that scales to multiple cores and makes best use of available memory can be challenging due to the scale of the data involved.  To deal with this, we have been developing some domain-specific tools to improve the state of affairs.</p>
<p><a href="https://github.com/quantifyearth/yirgacheffe">Yirgacheffe</a> is a wrapper to the GDAL library that provides high-level Python APIs that take care of figuring out if datasets overlap, and if vector layers need to be rasterised, and manages memory efficiently for large layers.  There is only one problem: we would like to write similar code to this, but in a high level functional language rather than an imperative one!</p>
<p>OCaml has recently gained supported for multicore parallelism, and is also one of the first mainstream languages with support for effects.  This project will involve writing a library in OCaml that provides similar functionality to Yirgacheffe, but with a focus on high-level functional programming.  This will involve interfacing with the GDAL library, and also writing some high-level abstractions for geospatial data processing. As an alternative to depending on GDAL, you may also choose to contribute to the emerging <a href="https://github.com/geocaml">GeoCaml</a> ecosystem which <a href="https://patrick.sirref.org" class="contact">Patrick Ferris</a> created.</p>
<p>A successful project will demonstrate a direct-style, readable interface to geospatial code, with the scheduling of parallel operations and memory management delegated to a separate library written in OCaml which can be customised to the local computing environment (e.g. a large local multicore machine, or a cloud computing cluster).</p>
<h2>Related reading</h2>
<ul>
<li><a href="https://anil.recoil.org/papers/2024-planetary-computing">Planetary computing for data-driven environmental policy-making</a> covers the data processing pipelines we need to integrate into.</li>
<li><a href="https://anil.recoil.org/papers/2021-pldi-retroeff">Retrofitting effect handlers onto OCaml</a>, PLDI 2021 describes how the effect system in OCaml works.</li>
<li><a href="https://github.com/ocaml-multicore/eio">EIO</a> is the high-performance direct-style IO library we have been developing for OCaml.</li>
</ul>


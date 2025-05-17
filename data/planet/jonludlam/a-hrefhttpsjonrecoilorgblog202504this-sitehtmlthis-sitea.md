---
title: <a href="https://jon.recoil.org/blog/2025/04/this-site.html">This site</a>
description:
url: https://jon.recoil.org/blog/2025/04/this-site.html
date: 2025-04-07T00:00:00-00:00
preview_image:
authors:
- Jon Ludlam
source:
---

<section><h1><a href="https://jon.recoil.org/atom.xml#this-site" class="anchor"></a>This site</h1><ul class="at-tags"><li class="libs"><span class="at-tag">libs</span> <p>mime_printer</p></li></ul><ul class="at-tags"><li class="published"><span class="at-tag">published</span> <p>2025-04-07</p></li></ul><p>I've spent a <em>lot</em> of time over the past few years working on Odoc, the OCaml documentation generator, so when it came time to (re)start my own website and blog, I found it hard to resist thinking about how I might use odoc as part of it. We've spent a lot of time recently trying to make odoc more able to generate structured documentation sites, so I've gone all in and am trialling using it as a tool to generate my entire site. This is a bit of an experiment, and I don't know how well it will work out, but let's see how it goes.</p><p>Additionally, I've recently been working on a project currently called <code>odoc_notebook</code>, which is a set of tools to allow odoc <code>mld</code> files to be used as a sort of Jupyter-style notebook. The idea is that you can write both text and code in the same file, and then run the code in the notebook interactively. Since I've only got a webserver, all the execution of code has to be done client side, so I'm making extensive use of the phenomenal <a href="https://github.com/ocsigen/js_of_ocaml">Js_of_ocaml</a> project to get an OCaml engine running in the browser.</p><p>My focus has initially been on getting 'toplevel-style' code execution working. As an example, let's write a little demo.</p></section><p>Continue reading <a href="https://jon.recoil.org/blog/2025/04/this-site.html">here</a></p>

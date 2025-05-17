---
title: Foundations of Computer Science
description: Resources for teaching Foundations of Computer Science with OCaml and
  Jupyter notebooks.
url: https://anil.recoil.org/notes/focs
date: 2018-09-02T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<p>Here are the various repos used to create the interactive <a href="https://anil.recoil.org/notes/teaching">teaching</a> environment
we use for 1A Foundations of Computer Science in Cambridge. It may be useful to
other professors who are using OCaml in their courses.</p>
<ul>
<li><a href="https://github.com/avsm/teaching-fcs">https://github.com/avsm/teaching-fcs</a> is a private repo, but ping me if
are teaching and I'll give you access (it has coursework answers in it).
We use a Jupyter notebook, with the course written in Markdown using the
<a href="https://github.com/realworldocaml/mdx">mdx</a> OCaml parser which evaluates
toplevel phrases through the compiler and promotes the output directly
into the markdown.</li>
<li>We then convert the Markdown into Jupyter format using a
<a href="https://github.com/realworldocaml/mdx/pull/124">fork of mdx</a>, and then
nbconvert it into LaTeX for the printed notes.</li>
<li>A <a href="https://jupyter.org/install.html">JupyterLab</a> installation with a
<a href="https://github.com/akabe/ocaml-jupyter">custom OCaml kernel</a> suffices
for the live setup. Every student gets their own container on the server
and one server is sufficient for a full class of ~125 students.</li>
</ul>
<p>Ping me if you want to know more, and other people who have worked
on this with me are <a href="https://www.cst.cam.ac.uk/people/jdy22" class="contact">Jeremy Yallop</a>, <a href="https://github.com/dra27" class="contact">David Allsopp</a> and <a href="https://github.com/jonludlam" class="contact">Jon Ludlam</a>, with Jon
being the currently active additional lecturer on the course as of 2024/2025.</p>


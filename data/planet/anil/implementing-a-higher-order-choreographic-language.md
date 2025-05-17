---
title: Implementing a higher-order choreographic language
description:
url: https://anil.recoil.org/ideas/choregraphic-programming-ocaml
date: 2024-08-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<h1>Implementing a higher-order choreographic language</h1>
<p>This is an idea proposed in 2024 as a Cambridge Computer Science Part II project, and has been <span class="idea-completed">completed</span> by <a href="https://github.com/Rokcas" class="contact">Rokas Urbonas</a>. It was co-supervised with <a href="https://www.cst.cam.ac.uk/people/ds709" class="contact">Dmirtij Szamozvancev</a>.</p>
<p>This project aims to implement a functional choreographic language inspired by
the <a href="https://dl.acm.org/doi/pdf/10.1145/3498684">Pirouette calculus</a>. This language was meant to make the notoriously
difficult process of implementing distributed algorithms easier, while offering
a practical execution model for multi-participant programs. Additionally, it
aimed to match the expressiveness and performance of similar existing
solutions.</p>
<p>The project completed very successfully, and resulted in <a href="https://github.com/Rokcas/chorcaml"><em>ChorCaml</em></a>, an
embedded DSL for choreographic programming in OCaml. The language facilitates
the implementation of distributed algorithms, while offering a clear syntax and
safety via the type system. ChorCaml also improves upon existing alternatives
in certain common use cases, both in terms of program conciseness and
performance. The practicality of the DSL was verified by successfully
implementing well-known distributed algortihms such as Diffie-Hellman key
exchange and concurrent Karatsuba fast integer multiplication.</p>
<p><a href="https://github.com/Rokcas" class="contact">Rokas Urbonas</a> subsequently submitted a proposal to the OCaml Workshop about his
work, and presented it at the <a href="https://icfp24.sigplan.org/details/ocaml-2024-papers/13/ChorCaml-Functional-Choreographic-Programming-in-OCaml">2014 edition of the OCaml Workshop</a>.</p>
<ul>
<li><a href="https://www.youtube.com/watch?v=KEkmcXVtFi0">Video</a> of his talk</li>
<li><a href="https://ocaml2024.hotcrp.com/doc/ocaml2024-paper17.pdf">PDF</a> of his writeup.</li>
</ul>


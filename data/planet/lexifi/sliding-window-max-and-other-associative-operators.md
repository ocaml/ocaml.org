---
title: Sliding-window max (and other associative operators)
description: Consider a sequence of n nn numbers and imagine you need to compute the
  maximum of all adjacent sub-sequences of length k kk. How would you do that efficiently?
url: https://www.lexifi.com/blog/ocaml/sliding_max/
date: 2019-12-12T00:00:00-00:00
preview_image:
authors:
- LexiFi
source:
ignore:
keywords:
- ldots
- max
- ofs_k
- x_1
- x_2
- x_3
- x_4
- x_5
- y_0
- y_i
---

<p>Consider a sequence of <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>n</mi></mrow><annotation encoding="application/x-tex">n</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="katex-base"><span class="katex-strut" style="height:0.4306em;"></span><span class="mord mathnormal">n</span></span></span></span> numbers and imagine you need to compute the
maximum of all adjacent sub-sequences of length <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>k</mi></mrow><annotation encoding="application/x-tex">k</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="katex-base"><span class="katex-strut" style="height:0.6944em;"></span><span class="mord mathnormal" style="margin-right:0.0315em;">k</span></span></span></span>. How would you do
that efficiently?</p>

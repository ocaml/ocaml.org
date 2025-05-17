---
title: Probabilistic Programming in OCaml
description:
url: https://anil.recoil.org/ideas/prob-programming-owl
date: 2018-01-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<h1>Probabilistic Programming in OCaml</h1>
<p>This is an idea proposed in 2018 as a Cambridge Computer Science Part II project, and has been <span class="idea-completed">completed</span> by <a href="https://anil.recoil.org/news.xml" class="contact">Hari Chandrasekaran</a>. It was co-supervised with <a href="https://github.com/ctk21" class="contact">Tom Kelly</a> and <a href="https://github.com/ryanrhymes" class="contact">Liang Wang</a>.</p>
<p>With increasing use of machine learning, it is useful to develop frameworks
that support rapid development and functional specification of probabilistic
models for inference and reasoning.  Probabilistic Programming Languages aim to
support concise syntax for specifying models and consequently making inference
easier. This can pave way to improvements of the model created, more data
gathering and further model refinement in an iterative sense.</p>
<p>PPL enables easier development of statistical models and allows decoupling
inference from modelling.  There is a lot of recent work on PPLs, and this
project seeks to incorporate them into functional languages.  This project aims
to develop a small PPL with a graph based model for Bayesian inference (similar
to the Edward PPL) into the Owl numerical library written in OCaml.</p>
<p>The implementation focusses on modularity, enabling the composability of models
and allowing them contain parameters which could be random variables from
common probability distributions or deterministic functions or combinations of
other random variables.  The language would allow the specification of
generative models that model the joint probability distribution of latent
variables and observed parameters, and inference by conditioning.  The initial
focus will be on common statistical inference methods such as MCMC.  Other
inference algorithms such as Hamiltonian Monte Carlo or Variational Inference
will be explored as optional extensions to the project.</p>
<h1>Background reading</h1>
<ul>
<li><a href="https://dl.acm.org/doi/10.1145/3236778">"Functional Programming for modular Bayesian Inference"</a></li>
<li>Dustin Tran, Alp Kucukelbir, Adji B. Dieng, Maja Rudolph, Dawen Liang, and David M. Blei. <a href="https://arxiv.org/abs/1610.09787">Edward: A library for probabilistic modeling, inference, and criticism</a>, 2016</li>
<li>Liang Wang. 2017. Owl: A General-Purpose Numerical Library in OCaml.</li>
</ul>
<h2>Links</h2>
<p>The dissertation is not available online; contact <a href="https://anil.recoil.org/news.xml" class="contact">Hari Chandrasekaran</a> directly to obtain a
copy.</p>


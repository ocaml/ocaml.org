---
title: Modular Semantics for Brainfuck
description: The problem with Brainfuck  is that its semantics are given by its different
  implementations but not all its implementations agree so that ...
url: https://alaska-kamtchatka.blogspot.com/2011/11/modular-semantics-for-brainfuck.html
date: 2011-11-11T14:05:00-00:00
preview_image:
featured:
authors:
- "Mat\xEDas Giovannini"
---


The problem with Brainfuck is that its semantics are given by its different implementations but not all its implementations agree so that writing an interpreter is straightforward but writing portable Brainfuck programs is not. OCaml functors allows playing with pluggable semantics in a way that would be very difficult laborious with other languages. I can't imagine this flexibility in 

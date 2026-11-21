---
title: 'From AST to CST: rebuilding the parser of our template language'
description: "This post is about a piece of infrastructure that we rebuilt over the
  last few months: the parser of the template language used inside LexiFi\u2019s products.
  More precisely, it is about the switch from a classic parser producing an abstract
  syntax tree (AST) to one producing a concrete syntax tree (CST)."
url: https://www.lexifi.com/blog/ocaml/template-language-cst/
date: 2026-11-03T00:00:00-00:00
preview_image:
authors:
- LexiFi
source:
ignore:
keywords:
- ast
- cst
- delimited
- expr
- parser
- template
- token
- tokens
- trivia
- with_token
---

<p>This post is about a piece of infrastructure that we rebuilt over the last few
months: the parser of the <em>template language</em> used inside LexiFi’s products.
More precisely, it is about the switch from a classic parser producing an
abstract syntax tree (AST) to one producing a <em>concrete syntax tree</em> (CST). The
main difference between these two kinds of tree is that the concrete syntax tree
preserves every single character of the source: keywords, punctuation,
whitespace, comments and even the parts that do not parse.</p>

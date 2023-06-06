---
title: Extending OCaml programs with Lua (soupault got plugin support)
description:
url: https://www.baturin.org/blog/extending-ocaml-programs-with-lua-soupault-got-plugin-support
date: 2019-08-10T00:00:00-00:00
preview_image:
featured:
authors:
- Daniil Baturin
---


    Most of the time, when people make extensible programs in typed functional languages,
they make a DSL, not least because it's much easier to make a DSL in a language with algebraic types
and pattern matching than in one without.<br/>
Some use cases really require a general-purpose language though. That's where things get
more interesting. Commonly used embeddable interpreters such as Lua, Guile, or Chicken are written in C.
It's possible to make OCaml or Haskell bindings for them and such bindings do exist,
but that's two high level languages communicating through a low level one.<br/>
It would be much better to be able to expose native types to the embedded language in a type-safe and more or less convenient
fashion. Here's my take at it.
    

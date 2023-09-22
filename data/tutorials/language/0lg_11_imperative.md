---
id: stateful
title: Mutability and Imperative Programming
description: >
  Writing stateful programs in OCaml, mixing imperative and functional style
category: "Tutorials"
---

TODO: Relationship between side-effects and mutability. Change of state is a side-effect; that must be said. 

# Mutability and Imperative Programming

## Introduction

## Learning Goals

## Exceptions

An uncaught exception is side-effect

## Mutable Data

### References

### Mutable Fields

### Mutables Index Accessible Collections `array` and `bytes`

Arrays and `bytes`

## Imperative Iteration

### `for` Loop

### `while` Loop

### Breaking Out of Any Loop

TODO: mention `raise Exit` to terminate a `while true` loop (alternative to break statement).

## Recomendations on Mixing Functional and Imperative Programming

### Good: Application Wide State

### Good: Function Encapsulated Mutability

### Good: Hash-Consing

### Good: Prefer Side-Effect Free / Stateless Functions

You can't avoid them. But should not unless unavoidable.

### Acceptable: Module Wide State

### Acceptable: Memoization

https://twitter.com/mrclbschff/status/1701737914319675747?t=HjFptgmk3LwnF3Zl0mtXmg&s=19

### Bad: Mutable in Disguise

Code looking as functional but actually stateful

### Bad: Hidden Side-Effect

TODO: include discussion on evaluation order, sides effects and monadic pipes

### Bad: Imperative by Default

## Some Example of Things You Don't Need Imperative Programming For

### Fast Loops: Tail Recursion

### Accumulators: Continuation Passing Style

### Asynchronous Processing

TODO: Mention concurrency

## Conclusion

Handling mutable state isn't good or bad. In the cases where it is needed, OCaml provides fine tools to handle them. Many courses and books on programming and algorithmic are written in imperative style without stronger reasons thane being the dominant style. Many techniques can be translated into functional style without loss in speed or increased memory consumption. Careful inspection of many efficient programming techniques or good practices show they turn out to be functional programming in essense, made working the in imperative setting by hook or by crook. In OCaml, it is possible to express things in their true essence and it is preferable Monadsto do so.

## References

* [The Curse of the Excluded Middle](https://queue.acm.org/detail.cfm?id=2611829), Erik Meijer. ACM Queue, Volume 12, Issue 4, April 2014, pages 20-29
* https://www.lri.fr/~filliatr/hauteur/pres-hauteur.pdf
* https://medium.com/neat-tips-tricks/ocaml-continuation-explained-3b73839b679f
* https://discuss.ocaml.org/t/what-is-the-use-of-continuation-passing-style-cps/4491/7
* https://www.pathsensitive.com/2019/07/the-best-refactoring-youve-never-heard.html
* https://link.springer.com/chapter/10.1007/11783596_2
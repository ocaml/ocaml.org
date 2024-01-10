# How to Write Documentation

This document explains how to write documentation such as tutorials, guides or recommendations to be hosted in ocaml.org.

## Materials

- Reference. This includes the [OCaml Manual](https://ocaml.org/releases/latest/manual.html), the [Opam manual](https://opam.ocaml.org/) and [Dune's documentation](https://dune.readthedocs.io/en/stable/). This is considered upstream material, refer to the corresponding projects to propose changes in them.
- Tutorials
- Guides
- Recommended practices

## Audience

Not our audience:
* Students going to universities
* Absolutely clueless about programming, we do not teach from scratch

Our audience:
* Self-directed learners without a tutor
* Already know some programming basics (one other programming programming)
* People who want to learn untainted functional programming (have seen functional patterns in other languages and are curious about “the real thing”)
* Likely a majority of consumers of libraries, hopefully some authors or people who turn into it
* English level B2 ideally

## Goals

1. Enable people to use OCaml for real projects / at the job / side projects / Advent of Code
1. Get people who want to build and contribute to the ecosystem up to speed and building something good quickly
1. Help people learn untainted FP through learning a language
1. **Oddly Specific**: Enable people to do Advent of Code in OCaml.

## Our Key Values / Constraints:
- **Goals and Prerequisites**. Each tutorial begins with its objectives and ends with a section listing necessary prior knowledge, marked as "**Prerequisites:**". This part doesn't use section headings.
- **Avoid Overwhelming Choices**. Tutorials should guide learners on a straightforward path, avoiding multiple options. This makes the learning process smoother. Detailed choices can be included in additional references and guides.
- **Highlight Important Computer Science Terms**. Use italics for well-known terms, providing a visual hint that these are important concepts. Linking to Wikipedia for further explanation is an option.
- **Be Entertaining in Examples, Accurate in Text**. While it's essential to be clear and precise in the main text, using engaging and fun examples can make the material more appealing. This approach helps cater to different learning styles.
- **Start with Examples**. Present examples first, then explain them. This helps in understanding the application before the theory.
- **Clear Section Headings**. Make sure section titles clearly indicate their content. Just like a candy store displays its products openly, avoid vague titles and opt for ones that clearly reveal the content. This is also helpful for better display of search results.
- **Use B2 Level English**. This ensures the material is comprehensible to those who are not native English speakers.

## Common phrases

- "binding a value to a name" ~ declaring a variable
- `'a` is a type parameter called "alpha" - it is not a _type variable_ (because the term variable is a forbidden word)
- pass a function as a value to another function as a parameter - not a "function value"

## Things to avoid

1. don't use the same letter for different things, i.e. when talking about a type parameter `'a`, don't have a name `a` nearby
1. never use the term "variable", instead
    a. names and values (binding = a value is bound to a name)
    b. type parameter
1. Use “parameter” and “argument” appropriately
1. Don't use math, computer science, or programming language theory terminology without reason and explanation.

---
title: "Backstage OCaml: You Can Try the Experimental Branch of Merlin That Uses Domains and Effects
"
tags: [experimental, merlin, platform, editors]
---

The Merlin team is excited to share that you can now try out an experimental branch of Merlin that leverages OCaml 5's domains and effects! This is Merlin-domains, and we'd love for you to test it and share your feedback.

## What is Merlin-domains?

Merlin-domains is an experimental branch that uses domains and effects to implement two optimisations to improve performance in large buffers: partial typing and cancellation.

As a reminder, Merlin is the editor service that powers OCaml's IDE features—if you're using the OCaml Platform extension with VS Code or ocaml-eglot with Emacs, you're already using Merlin under the hood through OCaml LSP Server.

## Why This Matters

While Merlin has had relatively few performance complaints over the years, in some contexts like very large files, the parsing-typing-analysis mechanism could sometimes cause slowdowns. The experimental branch addresses this in a clever way.

When you run an analysis command on a very large file, the type-checker will progress up to the location that makes the analysis possible, run the analysis phase, return the result, and then continue typing the file. This separation is made possible through control flow management enabled by effects, with two domains interacting with each other.

**The result?** Analysis phases become much more efficient! This is a great example of migrating a regular OCaml application to take advantage of multicore.

## Learn More at Lambda World

Want to understand the technical details? Sonja Heinze and Carine Morel will present their talk **"When magic meets multicore - OCaml and its elegant era of parallelism"** at [Lambda World](https://lambda.world/speakers/?speaker=Sonja%20Heinze), where they'll dive into how this experimental branch works internally.

## How to Test It

Currently, the branch is in its incubation phase. To test it, pin the branch in the switches where you want to experiment:

```bash
opam pin add https://github.com/ocaml/merlin#merlin-domains
```

Although this experimental branch passes the test suite, your feedback is very important to help collect potential bugs we may have missed. The team has added a **Bug/Merlin-domains** label to organize tickets related to this branch.

## What's Next

The goal is for this branch to eventually become the main branch, so that all users can benefit from these improvements. The rest of the ecosystem depending on Merlin, including OCaml LSP Server, will be adapted to take full advantage of these new features.

**We need you!** Try out merlin-domains with your real-world OCaml projects and share your experience on the [Discuss thread](https://discuss.ocaml.org/t/ann-an-experimental-branch-of-merlin-based-on-domains-and-effects/17195). Your testing and feedback will help shape the future of Merlin!

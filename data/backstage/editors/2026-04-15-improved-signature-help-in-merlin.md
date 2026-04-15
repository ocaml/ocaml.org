---
title: "Improved Signature Help in Merlin"
tags: [merlin, ocaml-lsp, editors]
---

Discuss this post on [discuss](https://discuss.ocaml.org/t/ann-improve-signature-help-feature-in-merlin/17920)!

Merlin's signature-help feature, which displays function signatures and highlights the active parameter as you type, has received several improvements:

- **Parameter-only display**: Signature help now only appears on function parameters, no longer on the function name itself.
- **No more parameter looping**: After the last parameter, the highlight no longer wraps back to the first one.
- **Better context support**: Signature help now activates within `let .. in` bindings even before the `in` keyword is written.
- **Optional parameter detection**: Optional parameters are now correctly detected and highlighted when the user starts writing one.

Some of these improvements are already available in the latest Merlin and ocaml-lsp releases, with the rest coming in upcoming versions.

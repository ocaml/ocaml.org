---
title: "Wasm_of_ocaml on WASI: A Working Prototype Looking for a Production User"
tags: [wasm, platform]
---

[WASI](https://wasi.dev/) (the WebAssembly System Interface) lets WebAssembly modules run on standalone runtimes, with no browser or JavaScript host required. That opens the door to running OCaml as serverless functions, edge compute, sandboxed plugins, and portable command-line `.wasm` binaries. A working WASI backend for [wasm_of_ocaml](https://ocsigen.org/js_of_ocaml/latest/manual/wasm_overview), the compiler that turns OCaml into WebAssembly, already exists. It was authored by [Jérôme Vouillon](https://github.com/vouillon) as [PR #1831](https://github.com/ocsigen/js_of_ocaml/pull/1831). The prototype works today; the one thing missing is a production user to carry it from branch to release.

The good news is that WASI itself is a solved problem here: the backend targets [WASI preview1](https://github.com/WebAssembly/WASI/blob/main/legacy/preview1/docs.md), which essentially every runtime supports. The output already runs fully on the [Wizard engine](https://github.com/titzer/wizard-engine) today, and on [Wasmtime](https://wasmtime.dev/) and Node too, with effects compiled via `--effects=cps`.

What unlocks the rest is engine support catching up across the ecosystem. Wasm GC, tail calls, and exception handling are now standardized in [Wasm 3.0](https://webassembly.org/news/2025-09-17-wasm-3.0/), but engine support is still maturing; [stack switching](https://github.com/WebAssembly/stack-switching) (used for OCaml's effects) remains a proposal. These features are landing engine by engine, and as support stabilizes OCaml is poised to target the whole class of standalone Wasm runtimes: serverless functions (e.g. [Fermyon Spin](https://www.fermyon.com/spin)), plugin sandboxes (e.g. [Shopify Functions](https://shopify.dev/docs/apps/build/functions/programming-languages/webassembly-for-functions)), edge compute (e.g. [Fastly Compute](https://www.fastly.com/products/edge-compute)), and portable CLI `.wasm` binaries (e.g. [Wasmer](https://wasmer.io/)). Since Spin and Fastly are both built on Wasmtime, progress there carries straight through to those platforms.

## What works today (on the Branch)

Compile an OCaml bytecode program for WASI with `--enable wasi`:

```shell
wasm_of_ocaml --enable wasi foo.byte -o foo.js
```

The output is the usual `foo.js` plus a `foo.assets/` directory containing the `.wasm` binary. Run the binary directly on the [Wizard engine](https://github.com/titzer/wizard-engine):

```shell
wizeng.x86-64-linux -ext:stack-switching foo.assets/code.wasm
```

The same output also runs on [wasmtime](https://github.com/bytecodealliance/wasmtime). The newer `exnref`-based exception handling is now the default when producing WASI binaries, so no extra compile-time flags are needed:

```shell
wasm_of_ocaml --enable wasi foo.byte -o foo.js
wasmtime -W=all-proposals=y foo.assets/code.wasm
```

The generated `foo.js` also works as a Node wrapper that runs the WASI binary under Node's WASI support. CI exercises all three paths: Wizard, wasmtime, and Node. Note that only Wizard runs effect-using programs unflagged; on wasmtime and Node, effects need to be compiled with `--effects=cps`, since neither yet ships GC-integrated stack switching in a stable build.

Under the hood, the PR adds around 5,200 lines across 90 files: a WASI-compatible virtual filesystem (`fs.wat`), Unix bindings covering file operations, process info, time, and permissions, a small libc in `libc.c`, WASI memory management and errno mapping, and the Node wrapper. It's substantial work, and it's already standing on its own in CI against real runtimes.

## Status: prototype, on a branch

The original work was done as a feasibility study for [Jane Street](https://www.janestreet.com/). They wanted to know whether wasm_of_ocaml could realistically target WASI. The answer is yes, and PR #1831 is the result. The [native effects PR #2189](https://github.com/ocsigen/js_of_ocaml/pull/2189) it depended on was merged recently, and as far as we know nobody is running WASI-targeted wasm_of_ocaml in production yet.

## Funding wanted

If your team would benefit from running OCaml on standalone Wasm runtimes, this prototype is much closer to production-ready than the "open PR on a branch" status suggests. Tarides is interested in carrying it forward and would like to hear from organizations that could sponsor the work. Reach out at [contact@tarides.com](mailto:contact@tarides.com), or start a thread on [discuss.ocaml.org](https://discuss.ocaml.org/).

See also: [Wasm_of_ocaml: What Changed Since 6.1](https://ocaml.org/backstage/2026-04-16-wasm-of-ocaml-what-changed-since-6-1) for the broader picture of where wasm_of_ocaml is headed, including the dynlink/toplevel and native-effects work that landed or is in flight alongside WASI.

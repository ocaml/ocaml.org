---
title: "Wasm_of_ocaml: What Changed Since 6.1"
tags: [wasm, platform]
---

[Wasm_of_ocaml](https://ocsigen.org/js_of_ocaml/latest/manual/wasm_overview) compiles OCaml bytecode to WebAssembly, targeting [WasmGC](https://github.com/WebAssembly/gc) so that OCaml values are managed by the host garbage collector. This post covers the most relevant Wasm changes in versions 6.1 through 6.3, and three PRs that add WASI support, native effects via Stack Switching, and dynlink/toplevel support. The Background section at the end has a short recap of where the project fits alongside js_of_ocaml.

## What changed in 6.1-6.3

The [full changelog](https://github.com/ocsigen/js_of_ocaml/blob/master/CHANGES.md) covers all three releases in detail. Below are the changes most relevant to the Wasm backend.

### The compiler writes Wasm binaries directly now (6.1)

Before 6.1, the compiler emitted [WAT](https://webassembly.github.io/spec/core/text/index.html) (WebAssembly text format) and then converted it to binary via [Binaryen](https://github.com/WebAssembly/binaryen). Since 6.1, it writes `.wasm` binary modules directly, removing a compilation step. WAT output is still available for debugging and is also faster to generate now.

### Better Wasm code generation (6.1-6.3)

Several changes across 6.1-6.3 improve the quality of the generated Wasm code:

- **Direct calls for known functions (6.1).** When the compiler can determine the target of a function call at compile time, it emits a `call_ref` instruction. Having context on which functions are called where enables the Binaryen toolchain to better optimize the generated Wasm code.
- **Precise closure environment types (6.1).** Closures carry refined [WasmGC struct types](https://github.com/WebAssembly/gc/blob/main/proposals/gc/Overview.md) for their captured variables instead of generic arrays. This gives the Wasm engine exact layout information.
- **Closure code pointer omission (6.2).** When a closure is never called indirectly through a generic apply, the code pointer field is omitted from the closure struct entirely.
- **Number unboxing (6.3).** The compiler tracks unboxed int/float values through chains of arithmetic operations and keeps them in Wasm locals instead of allocating heap boxes. This is the kind of optimization that makes tight numerical loops actually fast.
- **Reference unboxing (6.3).** `ref` cells that don't escape a function become Wasm locals instead of heap-allocated mutable [GC structs](https://github.com/WebAssembly/gc/blob/main/proposals/gc/Overview.md).
- **Specialized comparisons and bigarray ops (6.3).** Instead of dispatching through [`caml_compare`](https://v2.ocaml.org/api/Stdlib.html#VALcompare) or generic bigarray accessors, the compiler emits type-specific Wasm instructions when it can resolve types statically.

There are also shared compiler improvements (benefiting both js_of_ocaml and wasm_of_ocaml): the inlining pass was rewritten in 6.1 ([#1935](https://github.com/ocsigen/js_of_ocaml/pull/1935), [#2018](https://github.com/ocsigen/js_of_ocaml/pull/2018), [#2027](https://github.com/ocsigen/js_of_ocaml/pull/2027)) with better tailcall optimization, deadcode elimination, and arity propagation between compilation units.

### Runtime additions (6.1-6.3)

- [Marshal](https://v2.ocaml.org/api/Marshal.html) now handles zstd-compressed values in the Wasm runtime (6.1, fix in 6.3).
- [Bigarray](https://v2.ocaml.org/api/Bigarray.html) element access uses `DataView` get/set, which is faster than the typed array primitives that we used before (6.1).
- Effect handler continuation resumption is more efficient (6.1).
- [`Unix.times`](https://v2.ocaml.org/api/Unix.html#VALtimes) works in the Wasm runtime (6.3).
- `Dom_html.onload` added for Wasm-compatible load event handling -- the JS `window.onload` pattern doesn't work when Wasm modules load asynchronously (6.3).

### Compatibility

6.1 dropped OCaml 4.12 and earlier, requires [Dune](https://dune.build/) 3.19, and added preliminary [OCaml 5.4](https://ocaml.org/releases/5.4.0) support. The compiler runs on [Node.js](https://nodejs.org/) 22+ (which has WasmGC support), [CloudFlare Workers](https://developers.cloudflare.com/workers/) (V8 12.0+), and [WasmEdge](https://wasmedge.org/) 0.14.0+.

## Three Features in Flight

The three PRs below address the three biggest limitations of wasm_of_ocaml relative to js_of_ocaml: no standalone execution outside the browser, CPS overhead for effects, and no dynlink/toplevel. Dynlink/toplevel ([#2187](https://github.com/ocsigen/js_of_ocaml/pull/2187)) was merged on 2026-04-08; the other two are still open.

### WASI support ([PR #1831](https://github.com/ocsigen/js_of_ocaml/pull/1831))

Until now, wasm_of_ocaml has been browser-oriented: the generated Wasm module expects a JavaScript host to provide I/O, filesystem access, and so on. [WASI](https://wasi.dev/) (WebAssembly System Interface) is a standard set of system-call-like imports that lets Wasm modules run on standalone runtimes without a JS host.

This PR by Jerome Vouillon adds a `--enable wasi` flag:

```
wasm_of_ocaml --enable wasi foo.byte -o foo.js
```

The output still follows the existing convention (a `.js` file and a `.assets/` directory with the `.wasm` code), but the Wasm file can now also be run directly on standalone runtimes. On the [Wizard engine](https://github.com/titzer/wizard-engine) (which supports legacy exception handling):

```
wizeng.x86-64-linux -ext:stack-switching -ext:legacy-eh foo.assets/code.wasm
```

For [wasmtime](https://github.com/bytecodealliance/wasmtime) and other runtimes using the newer `exnref`-based exception handling, compile with `--enable exnref`:

```
wasm_of_ocaml --enable wasi --enable exnref foo.byte -o foo.js
wasmtime -W=all-proposals=y foo.assets/code.wasm
```

The `--enable exnref` flag selects the [newer `exnref`-based exception handling spec](https://github.com/WebAssembly/exception-handling/blob/main/proposals/exception-handling/Exceptions.md) rather than the [legacy proposal](https://github.com/WebAssembly/exception-handling/blob/main/proposals/exception-handling/legacy/Exceptions.md) used by V8/Chrome and the Wizard engine.

The implementation is substantial: a WASI-compatible filesystem (`fs.wat`), Unix API bindings covering file operations, process info, time, and permissions (`unix.wat`), a minimal libc (`libc.c`/`libc.wasm`), WASI memory management and errno mapping, and a Node.js wrapper for running WASI binaries under Node.

### Native effects via Stack Switching ([PR #2189](https://github.com/ocsigen/js_of_ocaml/pull/2189))

[OCaml 5 effect handlers](https://v2.ocaml.org/manual/effects.html) need the ability to suspend a computation, run a handler, and resume. In the native OCaml compiler, this is implemented using stack segments. In wasm_of_ocaml, we rely on [JSPI](https://v8.dev/blog/jspi) by default, which does not cost much when effects are not used, but is comparatively slow when effects are used as core control flow. However, there's also the option of using [CPS-transformation](https://en.wikipedia.org/wiki/Continuation-passing_style): every function that might perform an effect gets a continuation parameter, and `perform`/`continue`/`discontinue` manipulate these closures explicitly. This works but has overhead -- extra closure allocations, indirect calls, and the CPS transform obscures the control flow, which inhibits other optimizations.

The [WebAssembly Stack Switching proposal](https://github.com/WebAssembly/stack-switching) (currently [Phase 3](https://github.com/WebAssembly/stack-switching/blob/main/proposals/stack-switching/Explainer.md) in the Wasm standardization process) adds a third implementation: native primitives for creating, suspending, and resuming stacks. This maps directly onto what OCaml's effect handlers need.

This PR by Jerome Vouillon adds a `--effects native` flag:

```
wasm_of_ocaml --effects native foo.byte -o foo.js
```

When enabled, the CPS transformation is skipped entirely. Instead, `perform` suspends the current Wasm stack, the handler runs on the parent stack, and `continue` resumes the suspended stack -- using the primitives from the [Stack Switching explainer](https://github.com/WebAssembly/stack-switching/blob/main/proposals/stack-switching/Explainer.md). The implementation is in a new `effect-native.wat` runtime module.

This should remove the CPS overhead for code using [Eio](https://github.com/ocaml-multicore/eio), [`Domain.DLS`](https://v2.ocaml.org/api/Domain.DLS.html), or [Lwt](https://github.com/ocsigen/lwt) with its effects backend. Stack Switching is not yet in stable browser releases (Chrome/V8 has it behind a flag), so the CPS path remains the default.

### Dynlink and toplevel support ([PR #2187](https://github.com/ocsigen/js_of_ocaml/pull/2187), merged 2026-04-08)

One of the most visible limitations of wasm_of_ocaml compared to js_of_ocaml was the lack of [`Dynlink`](https://v2.ocaml.org/api/Dynlink.html) support, which also meant no OCaml toplevel (REPL) in the browser. The [OCaml Playground](https://ocaml.org/play) currently uses js_of_ocaml for exactly this reason.

This PR by Jerome Vouillon adds both. Concretely, it provides:

- A `wasm_of_ocaml_compiler_dynlink` library that can compile `.cmo` files to Wasm and load them at runtime -- the Wasm equivalent of what [`JsooTop`](https://ocsigen.org/js_of_ocaml/latest/jsoo_toplevel/JsooTop/index.html) does for js_of_ocaml.
- A `toplevel.wat` runtime module implementing the low-level primitives for registering dynamically loaded code with the Wasm module system.
- A `graphics.wat` module implementing the OCaml [`Graphics`](https://v2.ocaml.org/api/Graphics.html) library in WAT.
- Virtual filesystem improvements so the toplevel can access `.cmi` files at runtime.
- The [Lwt toplevel example](https://github.com/ocsigen/js_of_ocaml/tree/master/toplevel/examples/lwt_toplevel) updated to build with both js_of_ocaml and wasm_of_ocaml.
- A new test suite (`compiler/tests-dynlink-wasm/`) covering `loadfile`, `loadfile_private`, compile-and-load, effects flags, and plugin dependencies.

As [noted in the PR discussion](https://github.com/ocsigen/js_of_ocaml/pull/2187#issuecomment-2733803989), the virtual filesystem work also allows `compiler/tests-toplevel` to run under Wasm. This opens a path to running the [OCaml.org Playground](https://ocaml.org/play) on wasm_of_ocaml instead of js_of_ocaml.

## Background: Wasm_of_ocaml and OCaml-to-Wasm compilation

Wasm_of_ocaml started as a fork of [js_of_ocaml](https://ocsigen.org/js_of_ocaml/) by [Jerome Vouillon](https://github.com/vouillon) (with major contributions from [Hugo Heuzard](https://github.com/hhugo)), became a new backend in the js_of_ocaml project, and is now developed alongside it: since version 6.0.1 (the [first public release](https://tarides.com/blog/2025-02-19-the-first-wasm-of-ocaml-release-is-out/), February 2025), wasm_of_ocaml and js_of_ocaml share a [single repository](https://github.com/ocsigen/js_of_ocaml) and are released together.

It targets [WasmGC](https://github.com/WebAssembly/gc) (supported in Chrome 119+, Firefox 120+, and Safari 18.2+), the [tail-call extension](https://github.com/WebAssembly/tail-call), and the [exception handling extension](https://github.com/WebAssembly/exception-handling). Using WasmGC means OCaml values are managed by the host GC directly; no custom collector is shipped, and JS interop works through shared GC'd references.

The project was [presented at the ML Workshop at ICFP 2024](https://icfp24.sigplan.org/details/mlworkshop-2024-papers/10/Wasm_of_ocaml). A separate project, [Wasocaml](https://ocamlpro.com/blog/2022_12_14_wasm_and_ocaml/) by OCamlPro, also targets WasmGC but compiles from the Flambda IR of the native-code compiler rather than from bytecode. Jane Street has reported [2x-8x speedups](https://tarides.com/blog/2025-02-19-the-first-wasm-of-ocaml-release-is-out/) from wasm_of_ocaml over js_of_ocaml on their workloads. The [OCaml.org WebAssembly page](https://ocaml.org/tools/wasm-target) has an overview of all OCaml-to-Wasm compilation options.

## Getting involved

If you want to try wasm_of_ocaml, the [manual](https://ocsigen.org/js_of_ocaml/latest/manual/wasm_overview) covers setup with Dune. If you're already using js_of_ocaml, it's mostly a matter of adding a `wasm_of_ocaml` stanza:

```
opam install wasm_of_ocaml-compiler js_of_ocaml js_of_ocaml-ppx js_of_ocaml-lwt
```

`wasm_of_ocaml-compiler` depends on a system installation of [Binaryen](https://github.com/WebAssembly/binaryen) 119 or later.

Bug reports and contributions go to the [js_of_ocaml repository](https://github.com/ocsigen/js_of_ocaml). Discussion happens on the [OCaml Discuss forum](https://discuss.ocaml.org/).

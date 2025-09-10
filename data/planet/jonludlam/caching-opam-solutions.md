---
title: Caching opam solutions
description:
url: https://jon.recoil.org/blog/2025/09/caching-opam-solutions.html
date: 2025-09-09T00:00:00-00:00
preview_image:
authors:
- Jon Ludlam
source:
ignore:
---

<section><h1><a href="https://jon.recoil.org/atom.xml#caching-opam-solutions" class="anchor"></a>Caching opam solutions</h1><ul class="at-tags"><li class="published"><span class="at-tag">published</span> <p>2025-09-09</p></li></ul><ul class="at-tags"><li class="notanotebook"><span class="at-tag">notanotebook</span> </li></ul><p>The <a href="https://github.com/ocurrent/ocaml-docs-ci">ocaml-docs-ci</a> system works by watching opam-repository for changes, and then when it notices a new package it performs an opam solve and builds the package, a prerequisite for building the documentation. In order to give the docs some stability, as the docs may well <a href="https://jon.recoil.org/04/semantic-versioning-is-hard.html" title="semantic-versioning-is-hard">depend upon your dependencies</a>, we currently cache the solve results so that a package will always be built with the same set of dependencies, even if a new version of one of those dependencies has been released.</p><p>The downside to this is that as time goes on, the number of distinct universes that we build increases, and docs get more and more out of date. So it's not necessarily the best thing to do, though it does mean we minimise the amount of time spent solving.</p><p>The alternative approach is that on every commit to opam-repository we could resolve for all packages and use the latest, greatest solution to build the docs. Using this approach we would maximise the sharing of builds and keep the total amount of required storage steadier. Of course, this would mean solving for every package on every commit to opam-repository, even if we didn't end up rebuilding all of them due to the way that the cache works.</p><p>One possibility that might be worth investigating is to cache the solutions - but then Leon Bambrick <a href="https://twitter.com/secretGeek/status/7269997868">advises us</a>:</p><p>and indeed it's not obvious what the best approach to cache invalidation is here. A sledgehammer approach would be to hook into the solver and note what questions it asks of opam-repository and record the responses. If any of these change, then it's safe to say that we need to recalculate. I had a quick look at this and checked what packages were involved in the solution of <code>ocaml</code> as this would represent a minimum set of packages that would affect virtually all packages. The list was big, but not <i>too</i> big:</p><pre>winpthreads, system-msvc, system-mingw, ocaml-variants, ocaml-system,
ocaml-options-vanilla, ocaml-option-tsan, ocaml-option-static,
ocaml-option-spacetime, ocaml-option-no-flat-float-array,
ocaml-option-no-compression, ocaml-option-nnpchecker,
ocaml-option-nnp, ocaml-option-musl, ocaml-option-mingw,
ocaml-option-leak-sanitizer, ocaml-option-fp, ocaml-option-flambda,
ocaml-option-default-unsafe-string, ocaml-option-bytecode-only,
ocaml-option-afl, ocaml-option-address-sanitizer,ocaml-option-32bit,
ocaml-config, ocaml-compiler, ocaml-beta, ocaml-base-compiler, ocaml,
dkml-base-compiler, conf-unwind, conf-pkg-config, base-unix,
base-threads, base-ocamlbuild, base-nnp, base-metaocaml-ocamlfind,
base-implicits, base-effects, base-domains, base-bigarray</pre><p>I tried the same thing whilst using the oxcaml opam-repository, and this time, the list became much <i>much</i> larger:</p><pre>zed, zarith-xen, zarith-freestanding, zarith, yojson, xenstore, xdg,
x509, webbrowser, wasm_of_ocaml-compiler, variantslib, uutf, uuseg,
uunf, uucp, uTop, uri-sexp, uri, uopt, univ_map, uchar, tyxml,
typerex, typerep, trie, topkg, tls-lwt, tls, timezone, time_now,
textutils_kernel, textutils, tcpip, system-msvc, system-mingw,
swhid_core, stringext, string_dict, stdune, stdlib-shims, stdio, ssl,
splittable_random, spdx_licenses, spawn, shell,
shared-memory-ring-lwt, shared-memory-ring, sha, sexplib0, sexplib,
sexp_pretty, seq, sedlex, rresult, result, regex_parser_intf,
record_builder, react, re2, re, randomconv, publish, ptime, psq,
protocol_version_header, ppxlib_jane, ppxlib_ast, ppxlib, ppxfind,
ppx_yojson_conv_lib, ppx_yojson_conv, ppx_variants_conv, ppx_var_name,
ppx_typerep_conv, ppx_typed_fields, ppx_tydi, ppx_tools_versioned,
ppx_tools, ppx_template, ppx_string_conv, ppx_string,
ppx_stable_witness, ppx_stable, ppx_shorthand, ppx_sexp_value,
ppx_sexp_message, ppx_sexp_conv, ppx_pipebang, ppx_optional,
ppx_optcomp, ppx_module_timer, ppx_log, ppx_let, ppx_js_style,
ppx_jane, ppx_inline_test, ppx_ignore_instrumentation, ppx_here,
ppx_helpers, ppx_hash, ppx_globalize, ppx_fixed_literal,
ppx_fields_conv, ppx_fail, ppx_expect, ppx_enumerate,
ppx_disable_unused_warnings, ppx_diff, ppx_deriving, ppx_derivers,
ppx_custom_printf, ppx_cstruct, ppx_compare, ppx_cold, ppx_bin_prot,
ppx_bench, ppx_base, ppx_assert, pp, portable, pipe_with_writer_error,
pcre, pbkdf, patch, parsexp, ounit2, ordering, optint, opam-state,
opam-repository, opam-publish, opam-lib, opam-format,
opam-file-format, opam-core, ojs, ohex, odoc-parser, odoc, octavius,
ocplib-endian, ocp-indent, ocp-build, ocb-stubblr, ocamlnet,
ocamlgraph, ocamlformat-rpc-lib, ocamlformat-lib, ocamlformat,
ocamlfind-secondary, ocamlfind, ocamlc-loc, ocamlbuild,
ocaml_intrinsics_kernel, ocaml_intrinsics, ocaml-version,
ocaml-variants, ocaml-system, ocaml-syntax-shims,
ocaml-secondary-compiler, ocaml-options-vanilla, ocaml-option-tsan,
ocaml-option-static, ocaml-option-spacetime,
ocaml-option-no-flat-float-array, ocaml-option-no-compression,
ocaml-option-nnpchecker, ocaml-option-nnp, ocaml-option-musl,
ocaml-option-mingw, ocaml-option-leak-sanitizer, ocaml-option-fp,
ocaml-option-flambda, ocaml-option-default-unsafe-string,
ocaml-option-bytecode-only, ocaml-option-afl,
ocaml-option-address-sanitizer, ocaml-option-32bit,
ocaml-migrate-parsetree, ocaml-lsp-server, ocaml-index,
ocaml-freestanding, ocaml-config, ocaml-compiler-libs,
ocaml-base-compiler, ocaml, obuild, num, nocrypto, mtime, mmap,
mirage-xen-posix, mirage-xen, mirage-types, mirage-time, mirage-stack,
mirage-solo5, mirage-sleep, mirage-runtime, mirage-random,
mirage-ptime, mirage-protocols, mirage-profile, mirage-no-xen,
mirage-no-solo5, mirage-net-xen, mirage-net, mirage-mtime,
mirage-kv-mem, mirage-kv-lwt, mirage-kv, mirage-flow, mirage-entropy,
mirage-device, mirage-crypto-rng-mirage, mirage-crypto-rng-lwt,
mirage-crypto-rng, mirage-crypto-pk, mirage-crypto-ec, mirage-crypto,
mirage-clock-unix, mirage-clock-lwt, mirage-clock, mew_vi, mew,
metrics-lwt, metrics, merlin-lib, merlin, menhirSdk, menhirLib,
menhirCST, menhir, mdx, magic-mime, macaddr-cstruct, macaddr, lwt_ssl,
lwt_react, lwt_ppx, lwt_log, lwt-dllist, lwt, lsp, lru, logs,
lambda-term, kdf, jst-config, jsonrpc, jsonm, js_of_ocaml-toplevel,
js_of_ocaml-ppx, js_of_ocaml-lwt, js_of_ocaml-compiler, js_of_ocaml,
jbuilder, jane_rope, jane-street-headers, ipaddr-sexp, ipaddr-cstruct,
ipaddr, io-page, int_repr, http, hkdf, hex, hacl_x25519, gmap,
github-unix, github-data, github, gen_js_api, gen, gel,
functoria-runtime, fpath, fmt, fix, fieldslib, fiber, fiat-p256,
ezjsonm, extlib-compat, extlib, expectree, expect_test_helpers_core,
ethernet, eqaf, either, easy-format, dyn, duration, dune-site,
dune-rpc, dune-release, dune-private-libs, dune-configurator,
dune-compiledb, dune-build-info, dune, dot-merlin-reader, domain-name,
dkml-base-compiler, digestif, curly, cstruct-sexp, cstruct-lwt,
cstruct, csexp, crunch, cpuid, cppo, core_unix, core_kernel,
core_extended, core, configurator, conf-which, conf-unwind,
conf-pkg-config, conf-ninja, conf-m4, conf-libssl, conf-libpcre,
conf-gmp-powm-sec, conf-gmp, conf-g++, conf-cmake, conf-c++,
conf-bash, conf-autoconf, conduit-lwt-unix, conduit-lwt, conduit,
cohttp-lwt-unix, cohttp-lwt-jsoo, cohttp-lwt, cohttp, cmdliner,
cmarkit, chrome-trace, charInfo_width, capitalization, camomile,
camlp4, camlp-streams, ca-certs, bos, biniou, binaryen-bin, bin_prot,
bigstringaf, bigarray-compat, bheap, basement, base_quickcheck,
base_bigstring, base64, base-unix, base-threads, base-ocamlbuild,
base-num, base-nnp, base-effects, base-domains, base-bytes,
base-bigarray, base, backoff, atdgen-runtime, atdgen, atd, async_unix,
async_rpc_kernel, async_log, async_kernel, async_extra, async,
astring, asn1-combinators, arp, angstrom, alcotest</pre><p>This enormous list is because the opam file for oxcaml - <code>ocaml-variants.5.2.0+ox</code> - lists a bunch of conflicts to ensure that various incompatible packages are never selected:</p><pre>conflicts: [
  "base" {&lt; "v0.18~"}
  "alcotest" {!= "1.9.0+ox"}
  "backoff" {!= "0.1.1+ox"}
  "dot-merlin-reader" {!= "5.2.1-502+ox"}
  "gen_js_api" {!= "1.1.2+ox"}
  "js_of_ocaml" {!= "6.0.1+ox"}
  "js_of_ocaml-compiler" {!= "6.0.1+ox"}
  "js_of_ocaml-ppx" {!= "6.0.1+ox"}
  "js_of_ocaml-toplevel" {!= "6.0.1+ox"}
  "jsonrpc" {!= "1.19.0+ox"}
  "lsp" {!= "1.19.0+ox"}
  "lwt_ppx" {!= "5.9.1+ox"}
  "mdx" {!= "2.5.0+ox"}
  "merlin" {!= "5.2.1-502+ox"}
  "merlin-lib" {!= "5.2.1-502+ox"}
  "ocaml-compiler-libs" {!= "v0.17.0+ox"}
  "ocaml-index" {!= "1.1+ox"}
  "ocaml-lsp-server" {!= "1.19.0+ox"}
  "ocamlbuild" {!= "0.15.0+ox"}
  "ocamlformat" {!= "0.26.2+ox"}
  "ocamlformat-lib" {!= "0.26.2+ox"}
  "ojs" {!= "1.1.2+ox"}
  "ppxlib" {!= "0.33.0+ox"}
  "ppxlib_ast" {!= "0.33.0+ox"}
  "sedlex" {!= "3.3+ox"}
  "topkg" {!= "1.0.8+ox"}
  "uTop" {!= "2.15.0+ox"}
  "uutf" {!= "1.0.3+ox"}
  "wasm_of_ocaml-compiler" {!= "6.0.1+ox"}
  "zarith" {!= "1.12+ox"}
]</pre><p>and it seems that the solver is looking not just at these packages, but also at all of their dependencies too. So this is a much larger set of packages that we need to track changes for, probably making the caching an awful lot less effective. It's not clear to me that this is the best way for the solver to handle conflicts, but I don't know enough about how it works yet to say for sure.</p></section><p>Continue reading <a href="https://jon.recoil.org/blog/2025/09/caching-opam-solutions.html">here</a></p>

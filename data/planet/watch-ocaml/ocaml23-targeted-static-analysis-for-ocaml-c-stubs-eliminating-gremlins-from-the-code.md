---
title: '[OCaML''23] Targeted Static Analysis for OCaml C Stubs: Eliminating gremlins
  from the code'
description: "[OCaML'23] Targeted Static Analysis for OCaml C Stubs: Eliminating gremlins
  from the code Edwin T\xF6r\xF6k Migration to OCaml 5 requires updating a lot of
  C bindings due to the removal of naked pointer ..."
url: https://watch.ocaml.org/w/sj5jf9iieZA7E1cbDbnv2j
date: 2024-09-29T14:32:44-00:00
preview_image: https://watch.ocaml.org/lazy-static/previews/02fc8f1e-7e60-4f76-af5f-8228533fb06f.jpg
authors:
- Watch OCaml
source:
---

<p>[OCaML'23] Targeted Static Analysis for OCaml C Stubs: Eliminating gremlins from the code</p>
<p>Edwin Török</p>
<p>Migration to OCaml 5 requires updating a lot of C bindings due to the removal of naked pointer support. Writing OCaml user-defined primitives in C is a necessity, but is unsafe and error-prone. It does not benefit from either OCaml’s or C’s type checking, and existing C static analysers are not aware of the OCaml GC safety rules, and cannot infer them from existing macros alone. The alternative is automatically generating C stubs, which requires correctly managing value lifetimes. Having a static analyser for OCaml to C interfaces is useful outside the OCaml 5 porting effort too.<br>
After some motivating examples of real bugs in C bindings a static analyser is presented that finds these known classes of bugs. The tool works on the OCaml abstract parse and typed trees, and generates a header file and a caller model. Together with a simplified model of the OCaml runtime this is used as input to a static analysis framework, Goblint. An analysis is developed that tracks dereferences of OCaml values, and together with the existing framework reports incorrect dereferences. An example is shown how to extend the analysis to cover more safety properties.<br>
The tools and runtime models are generic and could be reused with other static analysis tools.</p>


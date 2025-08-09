---
title: Try OxCaml
description:
url: https://patrick.sirref.org/try-oxcaml/
date: 2025-05-09T00:00:00-00:00
preview_image:
authors:
- https://patrick.sirref.org/Patrick%20Ferris/
source:
ignore:
---


        <p>This week, I have been trying out Janestreet's <a href="https://blog.janestreet.com/oxidizing-ocaml-locality/">Oxidised OCaml</a> (see their <a href="https://patrick.sirref.org/oxcaml-2024/">ICFP paper</a>).  This adds a system of <em>modes</em> to OCaml for expressing things like locality.</p>
        <blockquote>
          <p>...we’re introducing a system of modes, which track properties like the locality and uniqueness of OCaml values. Modes allow the compiler to emit better, lower-allocation code, empower users to write safer APIs, and with the advent of multicore, statically guarantee data race freedom—all in a lightweight way that only affects those in need.</p>
        </blockquote>
        <p>For example, you might say:</p>
        <pre class="hilite">          <code><span class="ocaml-keyword">let</span><span class="ocaml-source"> </span><span class="ocaml-entity-name-function-binding">is_empty</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-source">s</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other-ocaml punctuation-other-colon punctuation">:</span><span class="ocaml-source"> </span><span class="ocaml-support-type">string</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">@@</span><span class="ocaml-source"> </span><span class="ocaml-source">local</span><span class="ocaml-source">) </span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-constant-language-capital-identifier">String</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-source">length</span><span class="ocaml-source"> </span><span class="ocaml-source">s</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-constant-numeric-decimal-integer">0</span><span class="ocaml-source">
</span></code>
        </pre>
        <p>To get a feel for how this changes the language, you can follow their <a href="https://github.com/janestreet/opam-repository/tree/with-extensions">instructions on their custom opam-repository</a>. Alternatively, you can <a href="https://patrick.sirref.org/oxcaml">give it a go in your browser</a>! This is a full toplevel running with <code>Base</code> installed (which has plenty of OxCaml annotations on Stdlib-like functions).</p>
        <p>Happy OxCamling!</p>
      

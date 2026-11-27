---
title: 'Wax: A User-Friendly Syntax for WebAssembly'
description: Wax is a Rust-like syntax for WebAssembly, with an OCaml toolchain that
  converts between Wax, WAT and binary Wasm in every direction.
url: https://tarides.com/blog/2026-11-26-wax
date: 2026-11-26T00:00:00-00:00
preview_image: https://tarides.com/blog/images/rosetta_stone-1360w.webp
authors:
- Tarides
source:
ignore:
keywords:
- i31
- i32
- local
- marshalling
- ref
- wasm
- wasm_of_ocaml
- wat
- wax
- webassembly
---

<p>The runtime of <a href="https://github.com/ocsigen/js_of_ocaml">wasm_of_ocaml</a>, the
OCaml-to-WebAssembly compiler developed alongside js_of_ocaml, is nearly 27,000
lines of WebAssembly written by hand. It is the library of <strong>primitives</strong> that
compiled OCaml code calls into for strings, polymorphic comparison, hashing,
marshalling and effect handlers. Our 2025 work on making wasm_of_ocaml faster
is described in <a href="https://tarides.com/blog/2026-02-11-announcing-new-wasm-of-ocaml-optimisations/">an earlier
post</a>.</p>
<p>I wrote <a href="https://github.com/ocsigen/wax">Wax</a> to offer another way to write
that code: a Rust-like syntax for WebAssembly that compiles to exactly the same
instructions. It comes with a toolchain, written in OCaml, that converts
between Wax and WebAssembly's text and binary formats in every direction.
Although it grew out of wasm_of_ocaml, Wax is meant for anyone who writes
WebAssembly by hand.</p>
<h2>One function, three forms</h2>
<p><strong>WebAssembly</strong> (Wasm) is a compact binary instruction format for a
<strong>stack machine</strong>: instructions take their operands from a stack and push their
results back onto it. Every major browser ships a Wasm <strong>engine</strong>, and
standalone engines such as Wasmtime run it outside the browser. A compiled
program is called a <strong>module</strong>. The binary is not meant for human eyes, so the
standard also defines a <strong>text format</strong>, WAT.</p>
<p>Here is a function that adds two numbers. As it ships in the binary, its body
is seven bytes:</p>
<p><img src="https://tarides.com/blog/images/wax-add-bytes~n7V2504YaZn1Yx19jxSKeg.svg" alt="The seven bytes 00 20 00 20 01 6a 0b, grouped by meaning: 00 says the function declares no extra locals, 20 00 is local.get 0, 20 01 is local.get 1, 6a is i32.add and 0b is end."></p>
<p>Parameters count as local variables (<strong>locals</strong>): <code>local.get 0</code> and
<code>local.get 1</code> read the two arguments, and the leading <code>00</code> says the function
declares no locals beyond them.</p>
<p>In the text format, as a disassembler prints it, the same function reads:</p>
<pre><code><span class="wat-source">(</span><span class="wat-keyword-control">func</span><span class="wat-source"> </span><span class="wat-variable-other">$add</span><span class="wat-source"> (</span><span class="wat-keyword-control">export</span><span class="wat-source"> </span><span class="wat-string-quoted-double">"</span><span class="wat-string-quoted-double">add</span><span class="wat-string-quoted-double">"</span><span class="wat-source">) (</span><span class="wat-keyword-control">param</span><span class="wat-source"> </span><span class="wat-variable-other">$x</span><span class="wat-source"> </span><span class="wat-support-type">i32</span><span class="wat-source">) (</span><span class="wat-keyword-control">param</span><span class="wat-source"> </span><span class="wat-variable-other">$y</span><span class="wat-source"> </span><span class="wat-support-type">i32</span><span class="wat-source">) (</span><span class="wat-keyword-control">result</span><span class="wat-source"> </span><span class="wat-support-type">i32</span><span class="wat-source">)
</span><span class="wat-source">  (</span><span class="wat-keyword-control-instruction">i32.add</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">local.get</span><span class="wat-source"> </span><span class="wat-variable-other">$x</span><span class="wat-source">) (</span><span class="wat-keyword-control-instruction">local.get</span><span class="wat-source"> </span><span class="wat-variable-other">$y</span><span class="wat-source">)))
</span></code></pre>
<p>This is the <em>folded</em> form of the text format: each instruction wraps its
operands, so the stack mostly stays out of sight. But each parenthesised form
is still one instruction. Reading a local takes a <code>local.get</code>, and
every operator carries its type: <code>i32.add</code> adds two 32-bit integers. The
<code>(export "add")</code> makes the function callable from outside the module, from
JavaScript for instance, under the name <code>add</code>.</p>
<p>And here it is in Wax:</p>
<pre><code><span class="wax-punctuation-definition-attribute">#[</span><span class="wax-entity-other-attribute-name">export</span><span class="wax-meta-attribute"> </span><span class="wax-keyword-operator-assignment">=</span><span class="wax-meta-attribute"> </span><span class="wax-punctuation-definition-string-begin">"</span><span class="wax-string-quoted-double">add</span><span class="wax-punctuation-definition-string-end">"</span><span class="wax-punctuation-definition-attribute">]</span><span class="wax-source">
</span><span class="wax-storage-type-function">fn</span><span class="wax-source"> </span><span class="wax-entity-name-function">add</span><span class="wax-source">(x</span><span class="wax-punctuation-separator-colon">:</span><span class="wax-source"> </span><span class="wax-support-type-primitive">i32</span><span class="wax-punctuation-separator-comma">,</span><span class="wax-source"> y</span><span class="wax-punctuation-separator-colon">:</span><span class="wax-source"> </span><span class="wax-support-type-primitive">i32</span><span class="wax-source">) </span><span class="wax-keyword-operator-arrow">-&gt;</span><span class="wax-source"> </span><span class="wax-support-type-primitive">i32</span><span class="wax-source"> {
</span><span class="wax-source">    x </span><span class="wax-keyword-operator-arithmetic">+</span><span class="wax-source"> y</span><span class="wax-punctuation-terminator">;</span><span class="wax-source">
</span><span class="wax-source">}
</span></code></pre>
<p>The <code>#[export = "add"]</code> attribute is how Wax writes that export.
Compiling the Wax version gives the seven bytes above, byte for byte.</p>
<h2>The trouble with 27,000 lines of WAT</h2>
<p>The text format was designed so that a tool could print a binary and a human
could check what the tool did. It was never meant for someone to sit down and
write twenty-seven thousand lines of it.</p>
<p>Yet that is how the wasm_of_ocaml runtime is written: about fifty <code>.wat</code> files,
all by hand, for reasons we explain at the end. Its maintainers, me included,
work in S-expressions where every variable read is a <code>local.get</code> and every loop
is a <code>loop</code> with a branch (<code>br</code>) back to its start.</p>
<p>The <a href="https://github.com/WebAssembly/gc/blob/main/proposals/gc/Overview.md">WebAssembly GC
proposal</a>,
now part of the standard, added structs, arrays, nullable references, subtyping
and downcasts, all managed by the engine's garbage collector. They let
wasm_of_ocaml represent OCaml values directly, rather than as bytes in a
<strong>linear memory</strong>, the single flat array of bytes that Wasm programs otherwise
manage themselves. They also make the text format wordier. Reading a field looks
like this:</p>
<pre><code><span class="wat-source">(</span><span class="wat-keyword-control-instruction">struct.get</span><span class="wat-source"> </span><span class="wat-variable-other">$list</span><span class="wat-source"> </span><span class="wat-variable-other">$value</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">local.get</span><span class="wat-source"> </span><span class="wat-variable-other">$l</span><span class="wat-source">))
</span></code></pre>
<p>And in Wax:</p>
<pre><code><span class="wax-source">l</span><span class="wax-punctuation-accessor">.</span><span class="wax-variable-other-property">value</span><span class="wax-source">
</span></code></pre>
<p>Both are the same two instructions, a <code>local.get</code> and a <code>struct.get</code>, and Wax
can convert between the two syntaxes in either direction.</p>
<h2>What you write is what runs</h2>
<p>Here is a complete function that walks a linked list and sums its values:</p>
<pre><code><span class="wax-storage-type">type</span><span class="wax-source"> </span><span class="wax-entity-name-type">list</span><span class="wax-source"> </span><span class="wax-keyword-operator-assignment">=</span><span class="wax-source"> { value</span><span class="wax-punctuation-separator-colon">:</span><span class="wax-source"> </span><span class="wax-support-type-primitive">i32</span><span class="wax-punctuation-separator-comma">,</span><span class="wax-source"> next</span><span class="wax-punctuation-separator-colon">:</span><span class="wax-source"> </span><span class="wax-keyword-operator-reference">&amp;</span><span class="wax-keyword-operator-reference">?</span><span class="wax-entity-name-type">list</span><span class="wax-source"> }</span><span class="wax-punctuation-terminator">;</span><span class="wax-source">
</span><span class="wax-source">
</span><span class="wax-punctuation-definition-attribute">#[</span><span class="wax-entity-other-attribute-name">export</span><span class="wax-meta-attribute"> </span><span class="wax-keyword-operator-assignment">=</span><span class="wax-meta-attribute"> </span><span class="wax-punctuation-definition-string-begin">"</span><span class="wax-string-quoted-double">sum</span><span class="wax-punctuation-definition-string-end">"</span><span class="wax-punctuation-definition-attribute">]</span><span class="wax-source">
</span><span class="wax-storage-type-function">fn</span><span class="wax-source"> </span><span class="wax-entity-name-function">sum</span><span class="wax-source">(l</span><span class="wax-punctuation-separator-colon">:</span><span class="wax-source"> </span><span class="wax-keyword-operator-reference">&amp;</span><span class="wax-keyword-operator-reference">?</span><span class="wax-entity-name-type">list</span><span class="wax-source">) </span><span class="wax-keyword-operator-arrow">-&gt;</span><span class="wax-source"> </span><span class="wax-support-type-primitive">i32</span><span class="wax-source"> {
</span><span class="wax-source">    </span><span class="wax-storage-type">let</span><span class="wax-source"> total</span><span class="wax-punctuation-separator-colon">:</span><span class="wax-source"> </span><span class="wax-support-type-primitive">i32</span><span class="wax-source"> </span><span class="wax-keyword-operator-assignment">=</span><span class="wax-source"> </span><span class="wax-constant-numeric-integer-decimal">0</span><span class="wax-punctuation-terminator">;</span><span class="wax-source">
</span><span class="wax-source">    </span><span class="wax-keyword-control">while</span><span class="wax-source"> l </span><span class="wax-keyword-operator-word">is</span><span class="wax-source"> </span><span class="wax-keyword-operator-reference">&amp;</span><span class="wax-entity-name-type">list</span><span class="wax-source"> {
</span><span class="wax-source">        total </span><span class="wax-keyword-operator-assignment">+=</span><span class="wax-source"> l</span><span class="wax-punctuation-accessor">.</span><span class="wax-variable-other-property">value</span><span class="wax-punctuation-terminator">;</span><span class="wax-source">
</span><span class="wax-source">        l </span><span class="wax-keyword-operator-assignment">=</span><span class="wax-source"> l</span><span class="wax-punctuation-accessor">.</span><span class="wax-variable-other-property">next</span><span class="wax-punctuation-terminator">;</span><span class="wax-source">
</span><span class="wax-source">    }
</span><span class="wax-source">    total</span><span class="wax-punctuation-terminator">;</span><span class="wax-source">
</span><span class="wax-source">}
</span></code></pre>
<p>Three bits of notation cover most of what you will meet in Wax code:</p>
<ul>
<li><code>&amp;t</code> is a reference to <code>t</code> that cannot be null, and <code>&amp;?t</code> one that may be.</li>
<li><code>e is &amp;t</code> is a type test, and <code>e as &amp;t</code> a cast.</li>
<li>Types are those of Wasm: <code>i32</code>, <code>i64</code>, <code>f32</code>, <code>f64</code>, and references.</li>
</ul>
<p><code>wax sum.wax -f wat</code> compiles it to the text format:</p>
<pre><code><span class="wat-source">(</span><span class="wat-keyword-control">type</span><span class="wat-source"> </span><span class="wat-variable-other">$list</span><span class="wat-source"> (</span><span class="wat-keyword-control">struct</span><span class="wat-source"> (</span><span class="wat-keyword-control">field</span><span class="wat-source"> </span><span class="wat-variable-other">$value</span><span class="wat-source"> </span><span class="wat-support-type">i32</span><span class="wat-source">) (</span><span class="wat-keyword-control">field</span><span class="wat-source"> </span><span class="wat-variable-other">$next</span><span class="wat-source"> (</span><span class="wat-keyword-control">ref</span><span class="wat-source"> </span><span class="wat-keyword-control">null</span><span class="wat-source"> </span><span class="wat-variable-other">$list</span><span class="wat-source">))))
</span><span class="wat-source">
</span><span class="wat-source">(</span><span class="wat-keyword-control">func</span><span class="wat-source"> </span><span class="wat-variable-other">$sum</span><span class="wat-source"> (</span><span class="wat-keyword-control">export</span><span class="wat-source"> </span><span class="wat-string-quoted-double">"</span><span class="wat-string-quoted-double">sum</span><span class="wat-string-quoted-double">"</span><span class="wat-source">) (</span><span class="wat-keyword-control">param</span><span class="wat-source"> </span><span class="wat-variable-other">$l</span><span class="wat-source"> (</span><span class="wat-keyword-control">ref</span><span class="wat-source"> </span><span class="wat-keyword-control">null</span><span class="wat-source"> </span><span class="wat-variable-other">$list</span><span class="wat-source">)) (</span><span class="wat-keyword-control">result</span><span class="wat-source"> </span><span class="wat-support-type">i32</span><span class="wat-source">)
</span><span class="wat-source">  (</span><span class="wat-keyword-control">local</span><span class="wat-source"> </span><span class="wat-variable-other">$total</span><span class="wat-source"> </span><span class="wat-support-type">i32</span><span class="wat-source">)
</span><span class="wat-source">  (</span><span class="wat-keyword-control-instruction">local.set</span><span class="wat-source"> </span><span class="wat-variable-other">$total</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">i32.const</span><span class="wat-source"> </span><span class="wat-constant-numeric">0</span><span class="wat-source">))
</span><span class="wat-source">  (</span><span class="wat-keyword-control">loop</span><span class="wat-source"> </span><span class="wat-variable-other">$loop</span><span class="wat-source">
</span><span class="wat-source">    (</span><span class="wat-keyword-control">if</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">ref.test</span><span class="wat-source"> (</span><span class="wat-keyword-control">ref</span><span class="wat-source"> </span><span class="wat-variable-other">$list</span><span class="wat-source">) (</span><span class="wat-keyword-control-instruction">local.get</span><span class="wat-source"> </span><span class="wat-variable-other">$l</span><span class="wat-source">))
</span><span class="wat-source">      (</span><span class="wat-keyword-control">then</span><span class="wat-source">
</span><span class="wat-source">        (</span><span class="wat-keyword-control-instruction">local.set</span><span class="wat-source"> </span><span class="wat-variable-other">$total</span><span class="wat-source">
</span><span class="wat-source">          (</span><span class="wat-keyword-control-instruction">i32.add</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">local.get</span><span class="wat-source"> </span><span class="wat-variable-other">$total</span><span class="wat-source">)
</span><span class="wat-source">            (</span><span class="wat-keyword-control-instruction">struct.get</span><span class="wat-source"> </span><span class="wat-variable-other">$list</span><span class="wat-source"> </span><span class="wat-variable-other">$value</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">local.get</span><span class="wat-source"> </span><span class="wat-variable-other">$l</span><span class="wat-source">))))
</span><span class="wat-source">        (</span><span class="wat-keyword-control-instruction">local.set</span><span class="wat-source"> </span><span class="wat-variable-other">$l</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">struct.get</span><span class="wat-source"> </span><span class="wat-variable-other">$list</span><span class="wat-source"> </span><span class="wat-variable-other">$next</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">local.get</span><span class="wat-source"> </span><span class="wat-variable-other">$l</span><span class="wat-source">)))
</span><span class="wat-source">        (</span><span class="wat-keyword-control">br</span><span class="wat-source"> </span><span class="wat-variable-other">$loop</span><span class="wat-source">))))
</span><span class="wat-source">  (</span><span class="wat-keyword-control-instruction">local.get</span><span class="wat-source"> </span><span class="wat-variable-other">$total</span><span class="wat-source">)
</span><span class="wat-source">)
</span></code></pre>
<p>Each Wax construct maps directly onto Wasm instructions and types. The <code>while</code>
is a <code>loop</code> with a <code>br</code> back to its start, the <code>+=</code> is an <code>i32.add</code> followed by
a <code>local.set</code>, and the type declaration is the struct definition.</p>
<p>The loop condition is a null test. <code>l is &amp;list</code> becomes a <code>ref.test</code> against
<code>&amp;list</code>, a type that excludes null. Since <code>l</code> is declared as a <code>&amp;?list</code>, the
test fails only when <code>l</code> is null. Wasm also has an instruction that is true
when a reference is null, <code>ref.is_null</code>, written <code>!l</code> in Wax, but the loop
needs the opposite test.</p>
<h2>Three formats, every direction</h2>
<p><img src="https://tarides.com/blog/images/wax-conversions~VTzKk9WQzUE2c8202Wc3Qg.svg" alt="Three formats at the corners of a triangle: .wax, .wat and .wasm. Wax compiles to both WAT and Wasm, and both decompile back to Wax; WAT assembles to Wasm and Wasm disassembles to WAT. The two text formats, .wax and .wat, also have a format arrow back to themselves."></p>
<p>Wax converts between any two formats, in both directions, and its formatter
rewrites <code>.wax</code> and <code>.wat</code> files in place. Converting between the two text
formats keeps comments and lays the code out the way the formatter does. It is
all one binary:</p>
<pre><code><span class="sh-source">wax input.wax -o output.wasm    </span><span class="sh-punctuation-definition-comment">#</span><span class="sh-comment-line-number-sign"> compile to binary</span><span class="sh-comment-line-number-sign">
</span><span class="sh-source">wax input.wax -f wat            </span><span class="sh-punctuation-definition-comment">#</span><span class="sh-comment-line-number-sign"> compile to text</span><span class="sh-comment-line-number-sign">
</span><span class="sh-source">wax program.wasm                </span><span class="sh-punctuation-definition-comment">#</span><span class="sh-comment-line-number-sign"> decompile a binary to Wax</span><span class="sh-comment-line-number-sign">
</span><span class="sh-source">wax input.wat                   </span><span class="sh-punctuation-definition-comment">#</span><span class="sh-comment-line-number-sign"> convert WAT to Wax</span><span class="sh-comment-line-number-sign">
</span><span class="sh-source">wax format -i input.wax         </span><span class="sh-punctuation-definition-comment">#</span><span class="sh-comment-line-number-sign"> reformat in place</span><span class="sh-comment-line-number-sign">
</span><span class="sh-source">wax check input.wax             </span><span class="sh-punctuation-definition-comment">#</span><span class="sh-comment-line-number-sign"> type-check only</span><span class="sh-comment-line-number-sign">
</span></code></pre>
<h2>Running the compiler backwards</h2>
<p>Compilers usually run one way. The most interesting engineering in Wax is in
the reverse arrow. To show it at work, this is <code>caml_string_equal</code> from the
wasm_of_ocaml runtime, as I wrote it. It implements OCaml's <code>String.equal</code>:</p>
<pre><code><span class="wat-source">(</span><span class="wat-keyword-control">func</span><span class="wat-source"> </span><span class="wat-variable-other">$caml_string_equal</span><span class="wat-source"> (</span><span class="wat-keyword-control">export</span><span class="wat-source"> </span><span class="wat-string-quoted-double">"</span><span class="wat-string-quoted-double">caml_string_equal</span><span class="wat-string-quoted-double">"</span><span class="wat-source">)
</span><span class="wat-source">   (</span><span class="wat-keyword-control">param</span><span class="wat-source"> </span><span class="wat-variable-other">$p1</span><span class="wat-source"> (</span><span class="wat-keyword-control">ref</span><span class="wat-source"> </span><span class="wat-keyword-control">eq</span><span class="wat-source">)) (</span><span class="wat-keyword-control">param</span><span class="wat-source"> </span><span class="wat-variable-other">$p2</span><span class="wat-source"> (</span><span class="wat-keyword-control">ref</span><span class="wat-source"> </span><span class="wat-keyword-control">eq</span><span class="wat-source">)) (</span><span class="wat-keyword-control">result</span><span class="wat-source"> (</span><span class="wat-keyword-control">ref</span><span class="wat-source"> </span><span class="wat-keyword-control">eq</span><span class="wat-source">))
</span><span class="wat-source">   (</span><span class="wat-keyword-control">local</span><span class="wat-source"> </span><span class="wat-variable-other">$s1</span><span class="wat-source"> (</span><span class="wat-keyword-control">ref</span><span class="wat-source"> </span><span class="wat-variable-other">$bytes</span><span class="wat-source">)) (</span><span class="wat-keyword-control">local</span><span class="wat-source"> </span><span class="wat-variable-other">$s2</span><span class="wat-source"> (</span><span class="wat-keyword-control">ref</span><span class="wat-source"> </span><span class="wat-variable-other">$bytes</span><span class="wat-source">))
</span><span class="wat-source">   (</span><span class="wat-keyword-control">local</span><span class="wat-source"> </span><span class="wat-variable-other">$len</span><span class="wat-source"> </span><span class="wat-support-type">i32</span><span class="wat-source">) (</span><span class="wat-keyword-control">local</span><span class="wat-source"> </span><span class="wat-variable-other">$i</span><span class="wat-source"> </span><span class="wat-support-type">i32</span><span class="wat-source">)
</span><span class="wat-source">   (</span><span class="wat-keyword-control">if</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">ref.eq</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">local.get</span><span class="wat-source"> </span><span class="wat-variable-other">$p1</span><span class="wat-source">) (</span><span class="wat-keyword-control-instruction">local.get</span><span class="wat-source"> </span><span class="wat-variable-other">$p2</span><span class="wat-source">))
</span><span class="wat-source">      (</span><span class="wat-keyword-control">then</span><span class="wat-source"> (</span><span class="wat-keyword-control">return</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">ref.i31</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">i32.const</span><span class="wat-source"> </span><span class="wat-constant-numeric">1</span><span class="wat-source">)))))
</span><span class="wat-source">   (</span><span class="wat-keyword-control-instruction">local.set</span><span class="wat-source"> </span><span class="wat-variable-other">$s1</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">ref.cast</span><span class="wat-source"> (</span><span class="wat-keyword-control">ref</span><span class="wat-source"> </span><span class="wat-variable-other">$bytes</span><span class="wat-source">) (</span><span class="wat-keyword-control-instruction">local.get</span><span class="wat-source"> </span><span class="wat-variable-other">$p1</span><span class="wat-source">)))
</span><span class="wat-source">   (</span><span class="wat-keyword-control-instruction">local.set</span><span class="wat-source"> </span><span class="wat-variable-other">$s2</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">ref.cast</span><span class="wat-source"> (</span><span class="wat-keyword-control">ref</span><span class="wat-source"> </span><span class="wat-variable-other">$bytes</span><span class="wat-source">) (</span><span class="wat-keyword-control-instruction">local.get</span><span class="wat-source"> </span><span class="wat-variable-other">$p2</span><span class="wat-source">)))
</span><span class="wat-source">   (</span><span class="wat-keyword-control-instruction">local.set</span><span class="wat-source"> </span><span class="wat-variable-other">$len</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">array.len</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">local.get</span><span class="wat-source"> </span><span class="wat-variable-other">$s1</span><span class="wat-source">)))
</span><span class="wat-source">   (</span><span class="wat-keyword-control">if</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">i32.ne</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">local.get</span><span class="wat-source"> </span><span class="wat-variable-other">$len</span><span class="wat-source">) (</span><span class="wat-keyword-control-instruction">array.len</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">local.get</span><span class="wat-source"> </span><span class="wat-variable-other">$s2</span><span class="wat-source">)))
</span><span class="wat-source">      (</span><span class="wat-keyword-control">then</span><span class="wat-source"> (</span><span class="wat-keyword-control">return</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">ref.i31</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">i32.const</span><span class="wat-source"> </span><span class="wat-constant-numeric">0</span><span class="wat-source">)))))
</span><span class="wat-source">   (</span><span class="wat-keyword-control-instruction">local.set</span><span class="wat-source"> </span><span class="wat-variable-other">$i</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">i32.const</span><span class="wat-source"> </span><span class="wat-constant-numeric">0</span><span class="wat-source">))
</span><span class="wat-source">   (</span><span class="wat-keyword-control">loop</span><span class="wat-source"> </span><span class="wat-variable-other">$loop</span><span class="wat-source">
</span><span class="wat-source">      (</span><span class="wat-keyword-control">if</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">i32.lt_s</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">local.get</span><span class="wat-source"> </span><span class="wat-variable-other">$i</span><span class="wat-source">) (</span><span class="wat-keyword-control-instruction">local.get</span><span class="wat-source"> </span><span class="wat-variable-other">$len</span><span class="wat-source">))
</span><span class="wat-source">         (</span><span class="wat-keyword-control">then</span><span class="wat-source">
</span><span class="wat-source">            (</span><span class="wat-keyword-control">if</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">i32.ne</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">array.get_u</span><span class="wat-source"> </span><span class="wat-variable-other">$bytes</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">local.get</span><span class="wat-source"> </span><span class="wat-variable-other">$s1</span><span class="wat-source">) (</span><span class="wat-keyword-control-instruction">local.get</span><span class="wat-source"> </span><span class="wat-variable-other">$i</span><span class="wat-source">))
</span><span class="wat-source">                        (</span><span class="wat-keyword-control-instruction">array.get_u</span><span class="wat-source"> </span><span class="wat-variable-other">$bytes</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">local.get</span><span class="wat-source"> </span><span class="wat-variable-other">$s2</span><span class="wat-source">) (</span><span class="wat-keyword-control-instruction">local.get</span><span class="wat-source"> </span><span class="wat-variable-other">$i</span><span class="wat-source">)))
</span><span class="wat-source">               (</span><span class="wat-keyword-control">then</span><span class="wat-source"> (</span><span class="wat-keyword-control">return</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">ref.i31</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">i32.const</span><span class="wat-source"> </span><span class="wat-constant-numeric">0</span><span class="wat-source">)))))
</span><span class="wat-source">            (</span><span class="wat-keyword-control-instruction">local.set</span><span class="wat-source"> </span><span class="wat-variable-other">$i</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">i32.add</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">local.get</span><span class="wat-source"> </span><span class="wat-variable-other">$i</span><span class="wat-source">) (</span><span class="wat-keyword-control-instruction">i32.const</span><span class="wat-source"> </span><span class="wat-constant-numeric">1</span><span class="wat-source">)))
</span><span class="wat-source">            (</span><span class="wat-keyword-control">br</span><span class="wat-source"> </span><span class="wat-variable-other">$loop</span><span class="wat-source">))))
</span><span class="wat-source">   (</span><span class="wat-keyword-control-instruction">ref.i31</span><span class="wat-source"> (</span><span class="wat-keyword-control-instruction">i32.const</span><span class="wat-source"> </span><span class="wat-constant-numeric">1</span><span class="wat-source">)))
</span></code></pre>
<p>Running it through <code>wax</code> gives:</p>
<pre><code><span class="wax-punctuation-definition-attribute">#[</span><span class="wax-entity-other-attribute-name">export</span><span class="wax-punctuation-definition-attribute">]</span><span class="wax-source">
</span><span class="wax-storage-type-function">fn</span><span class="wax-source"> </span><span class="wax-entity-name-function">caml_string_equal</span><span class="wax-source">(p1</span><span class="wax-punctuation-separator-colon">:</span><span class="wax-source"> </span><span class="wax-keyword-operator-reference">&amp;</span><span class="wax-support-type-heap">eq</span><span class="wax-punctuation-separator-comma">,</span><span class="wax-source"> p2</span><span class="wax-punctuation-separator-colon">:</span><span class="wax-source"> </span><span class="wax-keyword-operator-reference">&amp;</span><span class="wax-support-type-heap">eq</span><span class="wax-source">) </span><span class="wax-keyword-operator-arrow">-&gt;</span><span class="wax-source"> </span><span class="wax-keyword-operator-reference">&amp;</span><span class="wax-support-type-heap">eq</span><span class="wax-source"> {
</span><span class="wax-source">    </span><span class="wax-keyword-control">if</span><span class="wax-source"> p1 </span><span class="wax-keyword-operator-comparison">==</span><span class="wax-source"> p2 {
</span><span class="wax-source">        </span><span class="wax-keyword-control">return</span><span class="wax-source"> </span><span class="wax-constant-numeric-integer-decimal">1</span><span class="wax-source"> </span><span class="wax-keyword-operator-word">as</span><span class="wax-source"> </span><span class="wax-keyword-operator-reference">&amp;</span><span class="wax-support-type-heap">i31</span><span class="wax-punctuation-terminator">;</span><span class="wax-source">
</span><span class="wax-source">    }
</span><span class="wax-source">    </span><span class="wax-storage-type">let</span><span class="wax-source"> s1 </span><span class="wax-keyword-operator-assignment">=</span><span class="wax-source"> p1 </span><span class="wax-keyword-operator-word">as</span><span class="wax-source"> </span><span class="wax-keyword-operator-reference">&amp;</span><span class="wax-entity-name-type">bytes</span><span class="wax-punctuation-terminator">;</span><span class="wax-source">
</span><span class="wax-source">    </span><span class="wax-storage-type">let</span><span class="wax-source"> s2 </span><span class="wax-keyword-operator-assignment">=</span><span class="wax-source"> p2 </span><span class="wax-keyword-operator-word">as</span><span class="wax-source"> </span><span class="wax-keyword-operator-reference">&amp;</span><span class="wax-entity-name-type">bytes</span><span class="wax-punctuation-terminator">;</span><span class="wax-source">
</span><span class="wax-source">    </span><span class="wax-storage-type">let</span><span class="wax-source"> len </span><span class="wax-keyword-operator-assignment">=</span><span class="wax-source"> s1</span><span class="wax-punctuation-accessor">.</span><span class="wax-support-function-method">length</span><span class="wax-source">()</span><span class="wax-punctuation-terminator">;</span><span class="wax-source">
</span><span class="wax-source">    </span><span class="wax-keyword-control">if</span><span class="wax-source"> len </span><span class="wax-keyword-operator-comparison">!=</span><span class="wax-source"> s2</span><span class="wax-punctuation-accessor">.</span><span class="wax-support-function-method">length</span><span class="wax-source">() {
</span><span class="wax-source">        </span><span class="wax-keyword-control">return</span><span class="wax-source"> </span><span class="wax-constant-numeric-integer-decimal">0</span><span class="wax-source"> </span><span class="wax-keyword-operator-word">as</span><span class="wax-source"> </span><span class="wax-keyword-operator-reference">&amp;</span><span class="wax-support-type-heap">i31</span><span class="wax-punctuation-terminator">;</span><span class="wax-source">
</span><span class="wax-source">    }
</span><span class="wax-source">    </span><span class="wax-storage-type">let</span><span class="wax-source"> i </span><span class="wax-keyword-operator-assignment">=</span><span class="wax-source"> </span><span class="wax-constant-numeric-integer-decimal">0</span><span class="wax-punctuation-terminator">;</span><span class="wax-source">
</span><span class="wax-source">    </span><span class="wax-keyword-control">while</span><span class="wax-source"> i </span><span class="wax-keyword-operator-comparison">&lt;s</span><span class="wax-source"> len </span><span class="wax-punctuation-separator-colon">:</span><span class="wax-source"> (i </span><span class="wax-keyword-operator-assignment">+=</span><span class="wax-source"> </span><span class="wax-constant-numeric-integer-decimal">1</span><span class="wax-source">) {
</span><span class="wax-source">        </span><span class="wax-keyword-control">if</span><span class="wax-source"> s1[i] </span><span class="wax-keyword-operator-word">as</span><span class="wax-source"> </span><span class="wax-support-type-primitive">i32_u</span><span class="wax-source"> </span><span class="wax-keyword-operator-comparison">!=</span><span class="wax-source"> s2[i] </span><span class="wax-keyword-operator-word">as</span><span class="wax-source"> </span><span class="wax-support-type-primitive">i32_u</span><span class="wax-source"> {
</span><span class="wax-source">            </span><span class="wax-keyword-control">return</span><span class="wax-source"> </span><span class="wax-constant-numeric-integer-decimal">0</span><span class="wax-source"> </span><span class="wax-keyword-operator-word">as</span><span class="wax-source"> </span><span class="wax-keyword-operator-reference">&amp;</span><span class="wax-support-type-heap">i31</span><span class="wax-punctuation-terminator">;</span><span class="wax-source">
</span><span class="wax-source">        }
</span><span class="wax-source">    }
</span><span class="wax-source">    </span><span class="wax-constant-numeric-integer-decimal">1</span><span class="wax-source"> </span><span class="wax-keyword-operator-word">as</span><span class="wax-source"> </span><span class="wax-keyword-operator-reference">&amp;</span><span class="wax-support-type-heap">i31</span><span class="wax-punctuation-terminator">;</span><span class="wax-source">
</span><span class="wax-source">}
</span></code></pre>
<p>A bare <code>#[export]</code> exports the function under its own name. In wasm_of_ocaml,
<code>&amp;eq</code> is the type of any OCaml value. Values that are not allocated, such as
integers and booleans, are <code>&amp;i31</code>: 31-bit integers packed into a reference, so
<code>1 as &amp;i31</code> is OCaml's <code>true</code>. A string is a <code>&amp;bytes</code>, an array of 8-bit
integers.</p>
<p>Some of the notation comes from Wasm itself. A Wasm <code>i32</code> is just 32 bits,
which can be read either as an unsigned integer or as a signed one in two's
complement. Operations whose result depends on the reading come in two
versions: <code>&lt;s</code> is signed less-than (<code>i32.lt_s</code>), and <code>&lt;u</code> its unsigned
counterpart (<code>i32.lt_u</code>).</p>
<p>Wasm has no 8-bit values either: an array can store bytes, but reading one
widens it to an <code>i32</code>, and the read must say how to interpret the byte.
<code>s1[i] as i32_u</code> reads it as unsigned, between 0 and 255, which fills the upper
24 bits with zeros (<strong>zero extension</strong>, <code>array.get_u</code>). <code>s1[i] as i32_s</code> would
read it as signed, between −128 and 127, which copies its top bit into them
(<strong>sign extension</strong>, <code>array.get_s</code>).</p>
<p>Now look at what the decompiler had to do to get there:</p>
<ul>
<li><strong>Locals moved to where they are used.</strong> The text format declares every local
at the top of the function. In Wax, each one became a <code>let</code> at its first
assignment.</li>
<li><strong>The loop became a <code>while</code>.</strong> The decompiler recognised the <code>loop</code> ending in
<code>br $loop</code> as a <code>while</code>. The increment, which must sit just before the jump
back, moved into the loop header as a continue-expression, the <code>: (i += 1)</code>
part, so the body holds only the body.</li>
<li><strong>Redundant types disappeared.</strong> <code>s1</code> and <code>s2</code> carry no annotation, because
the casts already say what they are.</li>
</ul>
<p>WAT puts a <code>local.get</code> on every variable read and a type on every operator,
and declares locals far from where they are used. Wax avoids all three, so
across the whole file, about 480 lines of WAT shrink to about 320 lines of Wax
that are easier to read as well as shorter. The result type-checks and compiles
back.</p>
<h3>Decompile, recompile, same instructions</h3>
<p>The reverse arrow is how a project with an existing <code>.wat</code> codebase gets to
try Wax at all, so it has to be trustworthy, and "the module still does the
same thing" is not good enough.</p>
<p>A round trip, decompiling and then recompiling, gives back the same
<em>instruction stream</em>: for <code>string.wat</code>, all instructions, in the same order.
Only names and numbering may change, and a running module cannot tell the
difference. A local gets a new index when its declaration moves, and a function
that was anonymous in the binary gets a name.</p>
<p>By default, the decompiler also tidies up a few idioms, reshaping a sequence
into an equivalent one: an <code>i32.eq</code> followed by <code>i32.eqz</code> (a test for zero)
becomes a single <code>!=</code>, and a cast that cannot fail is dropped. <code>--faithful</code>
turns this off, so the result recompiles instruction for instruction, and a
nightly fuzzing run holds it to that on machine-generated modules, unreachable
code included. The default mode is checked on behaviour instead: modules from
the official WebAssembly test suite go to Wax and back, and the suite's
assertions are re-run against the result.</p>
<h2>Errors, tools and editors</h2>
<p>Wax has its own type checker, so a mistake is reported in your source, at the
exact spot, rather than as a validation failure when an engine loads the
module:</p>
<pre><code><span style="color:#f87171;font-weight:bold">Error</span>: This operator cannot be applied to operands of types <span style="color:#22d3ee">i32</span> and <span style="color:#22d3ee">f64</span>.
<span style="color:#22d3ee"> ──➤</span>  hello.wax:3:7
<span style="color:#22d3ee">1 │</span> #[export = "add"]
<span style="color:#22d3ee">2 │</span> fn add(x: i32, y: f64) -&gt; i32 {
<span style="color:#22d3ee">3 │</span>     x + y;
<span style="color:#22d3ee">  ·</span> <span style="color:#f87171">      ^</span>
<span style="color:#22d3ee">4 │</span> }</code></pre>
<p>I put a lot of effort into making messages like this one clear. Each of the
hundreds of places where the parser can fail has its own message, saying what
was expected there and, when an unclosed bracket is the likely cause, pointing
back at it. These messages are generated from the grammar, with just a few
written by hand, so they keep up as the language evolves. Automated checks
make sure each one talks about what you wrote, statements and brackets rather
than the parser's internals, and that what it says was expected is
correct. Type errors get the same care.</p>
<p>Beyond type checking, Wax has:</p>
<ul>
<li>a formatter, and configurable lints that warn about suspicious code;</li>
<li>conditional compilation, to include or leave out code depending on build
flags;</li>
<li>source maps, to step through the generated Wasm in browser DevTools.</li>
</ul>
<p>You also get editor support. The <a href="https://marketplace.visualstudio.com/items?itemName=wax-wasm.wax">VS Code
extension</a>
runs the whole toolchain inside the editor, compiled to WebAssembly, so there is
nothing else to install, and it works the same in desktop VS Code and on
<a href="https://vscode.dev">vscode.dev</a>. Neovim and Emacs get syntax highlighting from
a tree-sitter grammar, and the rest from <code>wax lsp</code>, a server for the Language
Server Protocol (LSP) that most editors support: diagnostics as you type, types
on hover, go to definition, find references, rename and completion. Any other
editor with LSP support can use the same server.</p>
<p>None of this is reserved for <code>.wax</code> files. <code>.wat</code> files get the same type
checking, with the same care in the messages. A type error underlines both the
value of the wrong type and the instruction that expected another one:</p>
<pre><code><span style="color:#f87171;font-weight:bold">Error</span>:
  Type mismatch: this produces a value of type <span style="color:#f87171">f64</span>, but type <span style="color:#f87171">i32</span> is expected.
<span style="color:#22d3ee"> ──➤</span>  bad.wat:3:30
<span style="color:#22d3ee">1 │</span> (module
<span style="color:#22d3ee">2 │</span>   (func (export "f") (param $x i32) (result i32)
<span style="color:#22d3ee">3 │</span>     (i32.add (local.get $x) (f64.const 1))))
<span style="color:#22d3ee">  ·</span> <span style="color:#f87171">                             ^^^^^^^^^^^</span>
<span style="color:#22d3ee">  ·</span> <span style="color:#60a5fa;font-weight:bold">     ^^^^^^^</span> <span style="color:#60a5fa;font-weight:bold">expected here</span></code></pre>
<p>They also get the formatter, the lints, conditional compilation, source maps,
and the same editor support, so a project can use all of this on its existing
<code>.wat</code> files.</p>
<h2>Why not OCaml? Why not Rust?</h2>
<p>OCaml programmers often ask why the runtime is not written in OCaml. Much of it
exists to do what OCaml code cannot. Polymorphic comparison, hashing and
marshalling walk any value whatever its type, so they must distinguish between
the Wasm structs, arrays, <code>&amp;i31</code> references and JavaScript values that represent
it. Other primitives talk to the JavaScript environment the program runs in.
OCaml compiled by wasm_of_ocaml only ever sees OCaml values, never the Wasm
types behind them.</p>
<p>An OCaml <strong>DSL</strong>, a library of OCaml functions that build Wasm instructions,
would let the runtime be written in OCaml after all. But the code would be
harder to read: built from function calls, one per instruction, it would look
much like WAT, where Wax can write <code>l.value</code>. And only OCaml programmers could
use it. Wax is meant for anyone who writes Wasm by hand, which is also why its
syntax follows Rust rather than OCaml.</p>
<p>C and Rust both compile to Wasm, and they are the right tool for many
applications, but not for a runtime like wasm_of_ocaml's, for two reasons.</p>
<p>First, they target the wrong half of Wasm. C and Rust compile to linear memory,
which they manage with their own allocator. They have no way to express the GC
proposal's structs, arrays and references, which the engine manages, and those
are the values the OCaml runtime works on. A string is a GC array, a record is a
GC struct, and a runtime primitive receives them as references and returns
references.</p>
<p>The second reason is control. The runtime must decide exactly which types,
casts and instructions the engine sees, because they are the contract with the
code the OCaml compiler generates. <code>caml_string_equal</code>, for instance, must take
two <code>&amp;eq</code> and return an <code>&amp;eq</code>, and must read a string as the <code>&amp;bytes</code> array
the compiled code allocated. A compiler from a higher-level language makes
those choices itself, the way a C compiler picks the machine instructions of a
native program. Control over them means writing at the level of assembly, which
for Wasm is WAT, or Wax.</p>
<p>Wax makes no choices of its own. Every construct stands for a Wasm instruction
or type, and you can check by reading the WAT it produces.</p>
<h2>Next: the wasm_of_ocaml runtime</h2>
<p>Wax is still young, at release 0.3, but wasm_of_ocaml already uses it: its CI
runs every runtime <code>.wat</code> file through Wax, so the runtime is type-checked and
linted on each change. The next step is to switch to Wax for parsing those files
when building wasm_of_ocaml. Moving the runtime itself to Wax syntax comes
later, and it will come down to running the decompiler: the whole runtime
already converts to Wax that type-checks and compiles back, conditional
compilation included, and shrinks from nearly 27,000 lines to about 21,000.</p>
<h2>Try it</h2>
<p>The quickest way in is the
<a href="https://ocsigen.org/wax/playground.html">playground</a>. It runs the compiler in
your browser, with nothing to install and nothing running on a server. Type Wax
on the left and watch the WAT and the diagnostics update live on the right, or
paste in a <code>.wat</code> file and read it the other way.</p>
<p>When you are ready to install it:</p>
<pre><code><span class="sh-source">opam install wax    </span><span class="sh-punctuation-definition-comment">#</span><span class="sh-comment-line-number-sign"> or: npm install -g @wax-wasm/wax</span><span class="sh-comment-line-number-sign">
</span></code></pre>
<p>or grab a prebuilt binary from the
<a href="https://github.com/ocsigen/wax/releases/latest">releases</a>. In VS Code, install
the Wax extension from the Marketplace; for Neovim, Emacs and other editors,
the <a href="https://ocsigen.org/wax/editor.html">editor guide</a> has ready-made
configurations. The <a href="https://ocsigen.org/wax/">documentation</a> has the language
guide, the full Wax-to-WebAssembly correspondence and the CLI reference, and
the code is on <a href="https://github.com/ocsigen/wax">GitHub</a> under Apache-2.0.</p>
<h2>Until Next Time</h2>
<p>If you write WebAssembly by hand, or read what your compiler emits, give Wax a
try, and tell us on the <a href="https://github.com/ocsigen/wax/issues">issue tracker</a>
where it falls short.</p>
<p>You can connect with us on <a href="https://bsky.app/profile/tarides.com">Bluesky</a>,
<a href="https://mastodon.social/@tarides">Mastodon</a>,
<a href="https://www.threads.net/@taridesltd">Threads</a>, and
<a href="https://www.linkedin.com/company/tarides">LinkedIn</a> or sign up for our mailing
list to stay updated on our latest projects. We look forward to hearing from
you!</p>

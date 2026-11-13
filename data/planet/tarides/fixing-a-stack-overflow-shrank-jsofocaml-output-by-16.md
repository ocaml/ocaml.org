---
title: Fixing a Stack Overflow Shrank Js_of_ocaml Output by 16%
description: Fixing a stack overflow in js_of_ocaml cut local variables by 91% and
  compressed output by 16%, via variable coalescing and constant sinking.
url: https://tarides.com/blog/2026-11-12-fixing-a-stack-overflow-shrank-js-of-ocaml-output-by-16
date: 2026-11-12T00:00:00-00:00
preview_image: https://tarides.com/blog/images/lockers-1360w.webp
authors:
- Tarides
source:
ignore:
keywords:
- coalescing
- constant
- js_of_ocaml
- live
- prt
- sinking
- stack
- var
- variable
- variables
---

<p>One of our customers ran into a puzzling problem: their OCaml programs, compiled to
JavaScript with <a href="https://github.com/ocsigen/js_of_ocaml">js_of_ocaml</a>, were
crashing with stack overflows, but the stack traces weren't deep at all. The
cause was a single function with tens of thousands of local variables, which
used up most of the stack before doing any work.</p>
<h2>13,000 Variables, 100 KB of Stack</h2>
<p>Js_of_ocaml is a compiler from OCaml bytecode to JavaScript. It puts all
initialisation code into a single large toplevel function, a design that enables
whole-program optimisations like dead code elimination, constant propagation,
and inlining. Most JavaScript is hand-written or comes from compilers that
generate many smaller functions, so this problem doesn't arise. With
js_of_ocaml, this one function can become enormous.</p>
<p>V8 compiles JavaScript to its own bytecode, allocating one stack slot (8 bytes)
for each local variable that isn't captured by a nested function. (Captured
variables live on the heap in a "context" object.) For a function with 13,000
local variables, that's 100 KB of stack consumed before the function starts
running. We focused on V8, which is the most common target, but other engines
may behave similarly.</p>
<p>The fix is to reduce the number of local variables, and two complementary
techniques do this: <strong>variable coalescing</strong> and <strong>constant sinking</strong>.</p>
<h2>Variable Coalescing Reuses the Names of Dead Variables</h2>
<p>Not all 13,000 variables are in use at the same time. If variable <code>x</code> is never
used again by the time variable <code>y</code> gets defined, the two can share the same
name.</p>
<p>This is <em>variable coalescing</em>, a classic optimisation from compiler
construction, typically applied when converting out of SSA (Static Single
Assignment) form, an internal representation in which each variable is assigned
only once. I'd wanted to implement it for years, but kept putting it off, for
reasons I come back to at the end.</p>
<h3>Liveness First, Then Merging</h3>
<p>The pass walks through the code, works out when each variable is "alive" (might
still be used) or "dead" (won't be used again), then gives the same name to
variables whose live periods don't overlap.</p>
<p>It adapts a technique called <em>linear scan register allocation</em>, originally
designed for assigning variables to CPU registers. The usual alternative, graph
colouring, builds a graph of the variables that can't share a name and then
colours it. It can find better assignments, but it is expensive on large
functions, and compile time is a concern in js_of_ocaml. Linear scan runs in
time linear in the size of the function, which keeps it fast on tens of
thousands of variables.</p>
<p>The pass builds on <a href="https://dl.acm.org/doi/10.1145/543552.512558">Mössenböck and Pfeiffer's
extension</a> of linear scan that
supports <em>holes</em> in live ranges: a variable may be alive, then dead for a while,
then alive again. Another variable can reuse the name during that gap.</p>
<p>The algorithm has four steps:</p>
<ol>
<li>
<p><strong>Build a control flow graph</strong> in which statements are nodes and control flow
(if/else branches, loops, try/catch) creates edges.</p>
</li>
<li>
<p><strong>Compute liveness</strong> by working backwards through the graph. At each node,
track which variables might still be needed. In the usual notation:</p>
<pre><code>LiveIn(n) = Use(n) ∪ (LiveOut(n) - Def(n))
LiveOut(n) = ∪ LiveIn(succ) for all successors
</code></pre>
<p>where <code>Use(n)</code> is the set of variables read at node <code>n</code>, <code>Def(n)</code> those
written at <code>n</code>, and the successors of <code>n</code> are the nodes that can execute
next.</p>
</li>
<li>
<p><strong>Compute live ranges</strong> for each variable: the spans of code where it's
alive.</p>
</li>
<li>
<p><strong>Merge variables</strong>, processing them in the order in which they first become
alive. For each variable, the pass tries to reuse an existing name:</p>
<ul>
<li><strong>Hint-based</strong>: If this variable comes from a copy (<code>x = y</code>), try to reuse
<code>y</code>'s name. If it works, the copy becomes a no-op.</li>
<li><strong>Opportunistic</strong>: Reuse a variable from the <strong>free list</strong> (completely
dead) or find a fit in the <strong>inactive list</strong> (currently in a hole).</li>
</ul>
<p>If no merging is possible, the variable keeps its own name.</p>
</li>
</ol>
<h3>Dead in One Branch, Live in the Other</h3>
<p>A simple view of liveness treats a variable as alive from its first definition
to its last use. Branches make this view too coarse. Consider this code:</p>
<pre><code><span class="javascript-constant-numeric-decimal">1</span><span class="javascript-source">: </span><span class="javascript-storage-type">var</span><span class="javascript-meta-var-expr"> </span><span class="javascript-meta-definition-variable-js variable-other-readwrite">big</span><span class="javascript-meta-var-single-variable-expr"> </span><span class="javascript-keyword-operator-assignment">=</span><span class="javascript-meta-var-expr"> </span><span class="javascript-entity-name-function">createLargeObject</span><span class="javascript-meta-brace-round">(</span><span class="javascript-meta-brace-round">)</span><span class="javascript-punctuation-terminator-statement">;</span><span class="javascript-source"> </span><span class="javascript-comment-line-double-slash">//</span><span class="javascript-comment-line-double-slash"> 'big' is defined</span><span class="javascript-source">
</span><span class="javascript-constant-numeric-decimal">2</span><span class="javascript-source">: </span><span class="javascript-keyword-control-conditional">if</span><span class="javascript-source"> </span><span class="javascript-meta-brace-round">(</span><span class="javascript-variable-other-readwrite">someCondition</span><span class="javascript-meta-brace-round">)</span><span class="javascript-source"> </span><span class="javascript-punctuation-definition-block">{</span><span class="javascript-meta-block">
</span><span class="javascript-constant-numeric-decimal">3</span><span class="javascript-meta-block">:   </span><span class="javascript-comment-line-double-slash">//</span><span class="javascript-comment-line-double-slash"> 'big' is dead in this branch: it is never read here.</span><span class="javascript-meta-block">
</span><span class="javascript-constant-numeric-decimal">4</span><span class="javascript-meta-block">:   </span><span class="javascript-comment-line-double-slash">//</span><span class="javascript-comment-line-double-slash"> It is still live in the other branch.</span><span class="javascript-meta-block">
</span><span class="javascript-constant-numeric-decimal">5</span><span class="javascript-meta-block">:   </span><span class="javascript-storage-type">var</span><span class="javascript-meta-var-expr"> </span><span class="javascript-meta-definition-variable-js variable-other-readwrite">temp</span><span class="javascript-meta-var-single-variable-expr"> </span><span class="javascript-keyword-operator-assignment">=</span><span class="javascript-meta-var-expr"> </span><span class="javascript-entity-name-function">doWork</span><span class="javascript-meta-brace-round">(</span><span class="javascript-meta-brace-round">)</span><span class="javascript-punctuation-terminator-statement">;</span><span class="javascript-meta-block">
</span><span class="javascript-constant-numeric-decimal">6</span><span class="javascript-meta-block">:   </span><span class="javascript-comment-line-double-slash">//</span><span class="javascript-comment-line-double-slash"> 'temp' can share a name with 'big'</span><span class="javascript-meta-block">
</span><span class="javascript-constant-numeric-decimal">7</span><span class="javascript-meta-block">:   </span><span class="javascript-comment-line-double-slash">//</span><span class="javascript-comment-line-double-slash"> because 'big' is dead here.</span><span class="javascript-meta-block">
</span><span class="javascript-constant-numeric-decimal">8</span><span class="javascript-meta-block">: </span><span class="javascript-punctuation-definition-block">}</span><span class="javascript-source"> </span><span class="javascript-keyword-control-conditional">else</span><span class="javascript-source"> </span><span class="javascript-punctuation-definition-block">{</span><span class="javascript-meta-block">
</span><span class="javascript-constant-numeric-decimal">9</span><span class="javascript-meta-block">:   </span><span class="javascript-entity-name-function">use</span><span class="javascript-meta-brace-round">(</span><span class="javascript-variable-other-readwrite">big</span><span class="javascript-meta-brace-round">)</span><span class="javascript-punctuation-terminator-statement">;</span><span class="javascript-meta-block"> </span><span class="javascript-comment-line-double-slash">//</span><span class="javascript-comment-line-double-slash"> 'big' is used here</span><span class="javascript-meta-block">
</span><span class="javascript-constant-numeric-decimal">10</span><span class="javascript-meta-block">: </span><span class="javascript-punctuation-definition-block">}</span><span class="javascript-source">
</span></code></pre>
<p>In a linear view of the code (lines 1-10), <code>big</code> is defined at line 1 and used
at line 9, so its live range spans both. But inside the <code>if</code> branch, on lines
3-7, <code>big</code> is dead. The algorithm records this as a hole in <code>big</code>'s live range
and lets <code>temp</code> reuse the name, even though <code>big</code> is still needed on the other
branch.</p>
<pre><code><span class="javascript-comment-line-double-slash">//</span><span class="javascript-comment-line-double-slash"> Optimised: 'big' and 'temp' share variable 'a'</span><span class="javascript-source">
</span><span class="javascript-storage-type">var</span><span class="javascript-meta-var-expr"> </span><span class="javascript-meta-definition-variable-js variable-other-readwrite">a</span><span class="javascript-meta-var-single-variable-expr"> </span><span class="javascript-keyword-operator-assignment">=</span><span class="javascript-meta-var-expr"> </span><span class="javascript-entity-name-function">createLargeObject</span><span class="javascript-meta-brace-round">(</span><span class="javascript-meta-brace-round">)</span><span class="javascript-punctuation-terminator-statement">;</span><span class="javascript-source">
</span><span class="javascript-keyword-control-conditional">if</span><span class="javascript-source"> </span><span class="javascript-meta-brace-round">(</span><span class="javascript-variable-other-readwrite">someCondition</span><span class="javascript-meta-brace-round">)</span><span class="javascript-source"> </span><span class="javascript-punctuation-definition-block">{</span><span class="javascript-meta-block">
</span><span class="javascript-punctuation-whitespace-comment-leading">  </span><span class="javascript-comment-line-double-slash">//</span><span class="javascript-comment-line-double-slash"> 'a' now holds 'temp'. Overwriting 'big' is safe</span><span class="javascript-meta-block">
</span><span class="javascript-punctuation-whitespace-comment-leading">  </span><span class="javascript-comment-line-double-slash">//</span><span class="javascript-comment-line-double-slash"> because this branch never reads it.</span><span class="javascript-meta-block">
</span><span class="javascript-meta-block">  </span><span class="javascript-variable-other-readwrite">a</span><span class="javascript-meta-block"> </span><span class="javascript-keyword-operator-assignment">=</span><span class="javascript-meta-block"> </span><span class="javascript-entity-name-function">doWork</span><span class="javascript-meta-brace-round">(</span><span class="javascript-meta-brace-round">)</span><span class="javascript-punctuation-terminator-statement">;</span><span class="javascript-meta-block">
</span><span class="javascript-punctuation-definition-block">}</span><span class="javascript-source"> </span><span class="javascript-keyword-control-conditional">else</span><span class="javascript-source"> </span><span class="javascript-punctuation-definition-block">{</span><span class="javascript-meta-block">
</span><span class="javascript-meta-block">  </span><span class="javascript-entity-name-function">use</span><span class="javascript-meta-brace-round">(</span><span class="javascript-variable-other-readwrite">a</span><span class="javascript-meta-brace-round">)</span><span class="javascript-punctuation-terminator-statement">;</span><span class="javascript-meta-block"> </span><span class="javascript-comment-line-double-slash">//</span><span class="javascript-comment-line-double-slash"> 'a' still holds 'big' here</span><span class="javascript-meta-block">
</span><span class="javascript-punctuation-definition-block">}</span><span class="javascript-source">
</span></code></pre>
<h3>Copy Hints Turn <code>x = y</code> into a No-op</h3>
<p>When the pass sees <code>var x = y</code> where <code>y</code> is a local variable, it records a hint
that <code>x</code> should reuse <code>y</code>'s name if possible. If they end up sharing the name,
the assignment becomes a no-op that later passes can eliminate.</p>
<p>This is important for js_of_ocaml because its internal representation is in SSA
form. Assigning each variable once creates a problem at control flow join
points, where an <code>if</code> and <code>else</code> branch merge back together. If the <code>if</code> branch
sets <code>x1 = 1</code> and the <code>else</code> branch sets <code>x2 = 2</code>, what variable holds the
result after the merge? Textbook SSA solves this with <em>phi nodes</em>, special
constructs that pick the right value based on which branch was taken.
Js_of_ocaml uses an equivalent formulation: each branch passes its value as an
argument to the block it jumps to, which receives it as a parameter.</p>
<p>When compiled to JavaScript, passing such an argument becomes a plain
assignment: <code>var x3 = x1</code> in one branch, <code>var x3 = x2</code> in the other. With copy
hints, the pass often merges <code>x3</code> with <code>x1</code> or <code>x2</code>.</p>
<p>For this to work, the pass must be precise about exactly when a variable dies.
It uses a technique from the register allocation literature: split every
instruction into two time points, an input step and an output step.</p>
<p>Consider <code>var x = y</code> at instruction <code>i</code>:</p>
<ul>
<li>At time <code>2i</code> (input), the instruction reads <code>y</code>. If this is <code>y</code>'s last use,
its live range ends here.</li>
<li>At time <code>2i+1</code> (output), it writes <code>x</code>. This is <code>x</code>'s definition, so its live
range begins here.</li>
</ul>
<p>Because <code>2i &lt; 2i+1</code>, the two live ranges don't overlap, so <code>x</code> and <code>y</code> can get
the same name and the assignment disappears.</p>
<h3>Exception Handlers Extend Live Ranges</h3>
<p>Since an exception can be thrown from any point in a try block, variables live
at the handler entry must be considered live throughout the entire try block.
The pass extends their live ranges accordingly.</p>
<h3>Pretty Mode Keeps Your Variable Names</h3>
<p>Coalescing makes generated code harder to read, since one name now stands for
several variables. Js_of_ocaml output is minified by default, so this only
affects "pretty mode", used for debugging. There, js_of_ocaml <strong>disables
coalescing for user-defined variables</strong> and only merges compiler-generated
temporaries. The variable names from your OCaml source are then preserved in the
JavaScript output, which makes it easier to step through with a debugger.</p>
<h3>Captured Variables Are Left Alone</h3>
<p>The pass does not coalesce <strong>captured variables</strong> (variables used by nested
functions), for two reasons:</p>
<ol>
<li>They don't contribute to the problem. The stack overflow was caused by
stack-allocated locals, and captured variables live on the heap, in V8's
context objects.</li>
<li>Handling them would be complex. The pass tracks captured variables with a
simple flag, set when a variable is used in a nested function. Merging a
captured variable with a non-captured one that dies before the closure is
created is possible in theory, but doing so safely is tricky.</li>
</ol>
<h2>Constant Sinking Moves Definitions Next to Their Uses</h2>
<p>Variable coalescing alone wasn't enough, because js_of_ocaml places shared
constants at the top of the generated code, and there can be many of them. OCaml
bytecode stores constants in a table loaded at program start, which js_of_ocaml
reproduces. A separate pass also deduplicates strings and numbers, hoisting
these shared literals to the top.</p>
<p>This leaves hundreds of variables defined at line 10 that aren't used until line
10,000. Each one blocks coalescing for 9,990 lines.</p>
<p><em>Constant sinking</em> fixes this by moving definitions closer to their uses.</p>
<h3>Analyse, Plan, Transform</h3>
<ol>
<li>
<p><strong>Analysis</strong>: Walk through the code to find constant declarations: primitives
like numbers and strings, and allocations like arrays and objects. For each
constant, record every place it's used and what scope (function, loop, block)
that use lives in. Also track dependencies: if constant <code>x</code> is used to define
constant <code>y</code>, then where <code>x</code> goes affects where <code>y</code> can go.</p>
</li>
<li>
<p><strong>Planning</strong>: The pass processes constants in <strong>reverse definition order</strong> to
handle dependencies. If constant <code>y</code> uses constant <code>x</code> in its initialiser,
then <code>y</code> is a use of <code>x</code>, and where <code>y</code> ends up has to be known before <code>x</code>
can be placed. For each constant, the pass finds the innermost scope that
contains all its uses (the "nearest common ancestor" of the usage sites).
Then:</p>
<ul>
<li><strong>Primitives</strong> (numbers, strings) can move freely to that location.</li>
<li><strong>Allocations</strong> (arrays, objects) are more restricted: they can't cross
into loops or nested functions.</li>
<li><strong>Single-use constants</strong> get inlined directly at their usage site when
safe.</li>
</ul>
</li>
<li>
<p><strong>Transformation</strong>: Remove the original declarations and re-insert them at
their new positions.</p>
</li>
</ol>
<h3>Two Traversals Must Visit Scopes in the Same Order</h3>
<p>To move a variable to "Scope #42", the transformation pass needs to know which
scope is #42. The analysis and transformation passes must therefore traverse the
abstract syntax tree (AST) in the same order and enter and leave scopes at the
same moments.</p>
<p>At one point, I had an implementation that looked correct, but variables kept
landing in the wrong scopes. The cause turned out to be OCaml's evaluation
order. The analysis used an iterator, which only visits nodes, and the
transformation used a map, which rebuilds the tree as it goes. But OCaml doesn't
specify the evaluation order of constructor arguments, and the current backend
evaluates them right to left. The two traversals visited nodes in different
orders, so their scope IDs silently drifted apart. I had to make the evaluation
order explicit in the map traversal so that it matched the iterator.</p>
<h3>Allocations Stay Out of Loops</h3>
<p>Consider this code:</p>
<pre><code><span class="javascript-storage-type">var</span><span class="javascript-meta-var-expr"> </span><span class="javascript-meta-definition-variable-js variable-other-readwrite">arr</span><span class="javascript-meta-var-single-variable-expr"> </span><span class="javascript-keyword-operator-assignment">=</span><span class="javascript-meta-array-literal"> </span><span class="javascript-meta-brace-square">[</span><span class="javascript-constant-numeric-decimal">1</span><span class="javascript-punctuation-separator-comma">,</span><span class="javascript-meta-array-literal"> </span><span class="javascript-constant-numeric-decimal">2</span><span class="javascript-punctuation-separator-comma">,</span><span class="javascript-meta-array-literal"> </span><span class="javascript-constant-numeric-decimal">3</span><span class="javascript-meta-brace-square">]</span><span class="javascript-punctuation-terminator-statement">;</span><span class="javascript-source">
</span><span class="javascript-keyword-control-loop">for</span><span class="javascript-source"> </span><span class="javascript-meta-brace-round">(</span><span class="javascript-storage-type">var</span><span class="javascript-meta-var-expr"> </span><span class="javascript-meta-definition-variable-js variable-other-readwrite">i</span><span class="javascript-meta-var-single-variable-expr"> </span><span class="javascript-keyword-operator-assignment">=</span><span class="javascript-meta-var-expr"> </span><span class="javascript-constant-numeric-decimal">0</span><span class="javascript-punctuation-terminator-statement">;</span><span class="javascript-source"> </span><span class="javascript-variable-other-readwrite">i</span><span class="javascript-source"> </span><span class="javascript-keyword-operator-relational">&lt;</span><span class="javascript-source"> </span><span class="javascript-constant-numeric-decimal">10</span><span class="javascript-punctuation-terminator-statement">;</span><span class="javascript-source"> </span><span class="javascript-variable-other-readwrite">i</span><span class="javascript-keyword-operator-increment">++</span><span class="javascript-meta-brace-round">)</span><span class="javascript-source"> </span><span class="javascript-punctuation-definition-block">{</span><span class="javascript-meta-block">
</span><span class="javascript-meta-block">  </span><span class="javascript-entity-name-function">process</span><span class="javascript-meta-brace-round">(</span><span class="javascript-variable-other-readwrite">arr</span><span class="javascript-meta-brace-round">)</span><span class="javascript-punctuation-terminator-statement">;</span><span class="javascript-meta-block">
</span><span class="javascript-punctuation-definition-block">}</span><span class="javascript-source">
</span></code></pre>
<p>If we moved <code>arr</code>'s definition into the loop:</p>
<pre><code><span class="javascript-keyword-control-loop">for</span><span class="javascript-source"> </span><span class="javascript-meta-brace-round">(</span><span class="javascript-storage-type">var</span><span class="javascript-meta-var-expr"> </span><span class="javascript-meta-definition-variable-js variable-other-readwrite">i</span><span class="javascript-meta-var-single-variable-expr"> </span><span class="javascript-keyword-operator-assignment">=</span><span class="javascript-meta-var-expr"> </span><span class="javascript-constant-numeric-decimal">0</span><span class="javascript-punctuation-terminator-statement">;</span><span class="javascript-source"> </span><span class="javascript-variable-other-readwrite">i</span><span class="javascript-source"> </span><span class="javascript-keyword-operator-relational">&lt;</span><span class="javascript-source"> </span><span class="javascript-constant-numeric-decimal">10</span><span class="javascript-punctuation-terminator-statement">;</span><span class="javascript-source"> </span><span class="javascript-variable-other-readwrite">i</span><span class="javascript-keyword-operator-increment">++</span><span class="javascript-meta-brace-round">)</span><span class="javascript-source"> </span><span class="javascript-punctuation-definition-block">{</span><span class="javascript-meta-block">
</span><span class="javascript-meta-block">  </span><span class="javascript-storage-type">var</span><span class="javascript-meta-var-expr"> </span><span class="javascript-meta-definition-variable-js variable-other-readwrite">arr</span><span class="javascript-meta-var-single-variable-expr"> </span><span class="javascript-keyword-operator-assignment">=</span><span class="javascript-meta-array-literal"> </span><span class="javascript-meta-brace-square">[</span><span class="javascript-constant-numeric-decimal">1</span><span class="javascript-punctuation-separator-comma">,</span><span class="javascript-meta-array-literal"> </span><span class="javascript-constant-numeric-decimal">2</span><span class="javascript-punctuation-separator-comma">,</span><span class="javascript-meta-array-literal"> </span><span class="javascript-constant-numeric-decimal">3</span><span class="javascript-meta-brace-square">]</span><span class="javascript-punctuation-terminator-statement">;</span><span class="javascript-meta-block">  </span><span class="javascript-comment-line-double-slash">//</span><span class="javascript-comment-line-double-slash"> Creates 10 different arrays</span><span class="javascript-meta-block">
</span><span class="javascript-meta-block">  </span><span class="javascript-entity-name-function">process</span><span class="javascript-meta-brace-round">(</span><span class="javascript-variable-other-readwrite">arr</span><span class="javascript-meta-brace-round">)</span><span class="javascript-punctuation-terminator-statement">;</span><span class="javascript-meta-block">
</span><span class="javascript-punctuation-definition-block">}</span><span class="javascript-source">
</span></code></pre>
<p>We'd create 10 different array objects instead of one. This changes semantics if
<code>process</code> mutates <code>arr</code>, stores a reference to it, or compares array identity.
Constant sinking avoids this by refusing to move allocations into loops or
nested functions.</p>
<h2>The Numbers</h2>
<p>I measured both optimisations on two programs: <strong>ocamlc</strong> (the OCaml bytecode
compiler, which produces about 2.3 MB of JavaScript) and <strong>PRT</strong> (the partial
render table benchmark from the <a href="https://github.com/janestreet/bonsai_web_components">Bonsai web
framework</a>). For each, the
tables below report the number of local variables in the toplevel function and
the size of the generated JavaScript in bytes, before and after gzip
compression.</p>
<h3>OCaml Compiler (ocamlc)</h3>
<div role="region"><table>
<tbody><tr>
<th>Optimisation</th>
<th>Variables</th>
<th>Uncompressed</th>
<th>Compressed</th>
</tr>
<tr>
<td>None</td>
<td>3,005</td>
<td>2,351,542</td>
<td>606,480</td>
</tr>
<tr>
<td>Sinking</td>
<td>1,778 (-41%)</td>
<td>2,326,301 (-1.1%)</td>
<td>600,010 (-1.1%)</td>
</tr>
<tr>
<td>Coalescing</td>
<td>2,173 (-28%)</td>
<td>2,286,633 (-2.8%)</td>
<td>550,096 (-9.3%)</td>
</tr>
<tr>
<td>Both</td>
<td>771 (-74%)</td>
<td>2,259,902 (-3.9%)</td>
<td>541,914 (-10.6%)</td>
</tr>
</tbody></table></div><h3>PRT</h3>
<div role="region"><table>
<tbody><tr>
<th>Optimisation</th>
<th>Variables</th>
<th>Uncompressed</th>
<th>Compressed</th>
</tr>
<tr>
<td>None</td>
<td>13,539</td>
<td>1,548,716</td>
<td>507,021</td>
</tr>
<tr>
<td>Sinking</td>
<td>4,957 (-63%)</td>
<td>1,466,933 (-5.3%)</td>
<td>461,435 (-9.0%)</td>
</tr>
<tr>
<td>Coalescing</td>
<td>9,432 (-30%)</td>
<td>1,504,402 (-2.9%)</td>
<td>475,907 (-6.1%)</td>
</tr>
<tr>
<td>Both</td>
<td>1,263 (-91%)</td>
<td>1,421,410 (-8.2%)</td>
<td>423,323 (-16.5%)</td>
</tr>
</tbody></table></div><h3>What the Numbers Tell Us</h3>
<p>For PRT, the two passes together cut the toplevel function from 13,539 variables
to 1,263, a 91% reduction.</p>
<p>The two passes reinforce each other. Sinking shortens live ranges, which gives
coalescing more room to merge variables, and it inlines single-use constants,
which removes variables before coalescing runs. For PRT, sinking alone removes
63% of the variables and coalescing alone 30%. If the two acted independently,
combining them would leave about a quarter of the variables (a 74% reduction),
but the measured reduction is 91%.</p>
<p>Programs with more toplevel initialisation benefit more. With both passes
enabled, PRT improves more than ocamlc on every metric, despite producing less
code overall: its toplevel function starts with 4.5× as many variables (13,539
vs 3,005). Bonsai applications build up a lot of state at startup, which is what
these passes target.</p>
<h2>What I Didn't Expect</h2>
<p>I set out to fix the stack overflow, but the passes did more than that.</p>
<p>I'd wanted to implement variable coalescing for fifteen years. It's textbook
stuff, standard practice when moving out of SSA form to remove the unnecessary
assignments that phi nodes produce (<code>var x = y</code>). I had two reasons for putting
it off. First, back then I didn't understand JavaScript engines nearly as well
as I do now, and I worried that reusing a variable for different purposes might
confuse their optimisers. JS engines track <em>values</em>, not variables, so this
isn't an issue. Second, these unnecessary assignments aren't that frequent, so
the benefit seemed marginal. I was wrong about that second part.</p>
<p>Constant sinking also did more than I planned. I implemented it to help
coalescing, since shorter live ranges mean more merging opportunities. But many
constants turned out to have a single use, and these get inlined at that use,
which removes the variable. Inlining wasn't in the original plan; it came up as
an obvious improvement while writing the code.</p>
<p>The biggest gain was in compressed size. A 10–16% reduction in gzipped output is
significant for web deployment, since compressed size is what users download.</p>
<p>Part of the gain is simple. With 1,263 variables instead of 13,539, most names
shrink from two or three characters to one or two, so the uncompressed file gets
smaller as well. The rest comes from how compression algorithms like Deflate
work: they look for repeated patterns. Code drawing on thousands of distinct
names (<code>a</code>, <code>b</code>, <code>c</code>, ... <code>aa</code>, <code>ab</code>...) repeats itself far less than code that
keeps reusing about a thousand, and Deflate compresses repetition well.</p>
<h2>Conclusion</h2>
<p>What started as a fix for stack overflows also made the output smaller: 74–91%
fewer variables, roughly 4–8% smaller output, and 10–16% smaller gzipped output.
Our customer's stack overflows are fixed, at the cost of about 5% slower
compilation. For performance work on the WebAssembly side, see our <a href="https://tarides.com/blog/2026-02-11-announcing-new-wasm-of-ocaml-optimisations/">earlier post
on Wasm_of_ocaml
optimisations</a>.</p>
<p>The implementation is available in the js_of_ocaml repository:</p>
<ul>
<li><a href="https://github.com/ocsigen/js_of_ocaml/blob/master/compiler/lib/js_variable_coalescing.ml"><code>compiler/lib/js_variable_coalescing.ml</code></a></li>
<li><a href="https://github.com/ocsigen/js_of_ocaml/blob/master/compiler/lib/js_constant_sinking.ml"><code>compiler/lib/js_constant_sinking.ml</code></a></li>
</ul>
<h2>Until Next Time</h2>
<p>If you use js_of_ocaml 6.4.0 or later, both passes are on by default, so you get
the benefit without changing anything. We are always keen to hear how they
behave on real applications, so please share your experience on OCaml's
<a href="https://discuss.ocaml.org/">discussion forum</a>.</p>
<p>You can connect with us on <a href="https://bsky.app/profile/tarides.com">Bluesky</a>,
<a href="https://mastodon.social/@tarides">Mastodon</a>,
<a href="https://www.threads.net/@taridesltd">Threads</a>, and
<a href="https://www.linkedin.com/company/tarides">LinkedIn</a> or sign up for our mailing
list to stay updated on our latest projects. We look forward to hearing from
you!</p>

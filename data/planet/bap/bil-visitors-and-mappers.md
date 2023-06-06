---
title: BIL Visitors and Mappers
description: The Binary Analysis Platform Blog
url: http://binaryanalysisplatform.github.io/bil-visitor-mappers
date: 2016-01-24T00:00:00-00:00
preview_image:
featured:
authors:
- bap
---

<p>During disassembly, BAP lifts native binary instructions to a
language-agnostic, intermediate representation: the BAP intermediate Language
(BIL). In this post we look specifically at traversing and transforming BIL
using BAP&rsquo;s API. Lifted BIL code is represented as an AST data structure that
can be traversed and transformed for the purposes of analysis.</p>

<p>BAP provides a plethora of method hooks for traversing BIL ASTs according to
the visitor design pattern. OCaml&rsquo;s object-oriented features allow us to
realize these visitor patterns in an elegant and powerful way; however, for the
unfamiliar, usage tends to be harder to grasp. This post serves to
provide self-contained, explanatory examples that eases the introduction to the
BIL visitor and mapper capabilities.</p>

<p>A full template is provided for each example at the end of this post&ndash;it may be
used with the same <code class="language-plaintext highlighter-rouge">example</code> binary from previous posts.</p>

<h2>Visitors</h2>

<h4>A simple visitor</h4>

<blockquote>
  <p>How do I use a BIL visitor to print BIL statements?</p>
</blockquote>

<p>The following snippet accepts a list of <code class="language-plaintext highlighter-rouge">bil_stmts</code> and simply visits each
statement in the list, printing it.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">visit_each_stmt</span> <span class="n">bil_stmts</span> <span class="o">=</span>
  <span class="p">(</span><span class="k">object</span> <span class="k">inherit</span> <span class="p">[</span><span class="kt">unit</span><span class="p">]</span> <span class="nn">Bil</span><span class="p">.</span><span class="n">visitor</span>
    <span class="n">method</span><span class="o">!</span> <span class="n">enter_stmt</span> <span class="n">stmt</span> <span class="n">state</span> <span class="o">=</span>
      <span class="nn">Format</span><span class="p">.</span><span class="n">printf</span> <span class="s2">&quot;Visiting %s</span><span class="se">\n</span><span class="s2">&quot;</span> <span class="p">(</span><span class="nn">Stmt</span><span class="p">.</span><span class="n">to_string</span> <span class="n">stmt</span><span class="p">)</span>
    <span class="k">end</span><span class="p">)</span><span class="o">#</span><span class="n">run</span> <span class="n">bil_stmts</span> <span class="bp">()</span>
</code></pre></div></div>

<p>Output:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>Visiting t_113 := RBP
Visiting RSP := RSP - 0x8:64
Visiting mem64 := mem64 with [RSP, el]:u64 &lt;- t_113
...
</code></pre></div></div>

<p>Notes:</p>

<ul>
  <li>We inherit the <code class="language-plaintext highlighter-rouge">Bil.visitor</code> class, which defines and provides our visitor
callback hooks.</li>
  <li>We make use of the <code class="language-plaintext highlighter-rouge">enter_stmt</code> callback. There are <a href="https://github.com/BinaryAnalysisPlatform/bap/blob/master/lib/bap/bap.mli#L2048">many such
callbacks</a>,
for each language construct for BIL.</li>
  <li><code class="language-plaintext highlighter-rouge">[unit]</code> indicates the type of the state that we are passing along in our
visitor; here, every time we enter a statement. This corresponds with the
variable <code class="language-plaintext highlighter-rouge">state</code> for <code class="language-plaintext highlighter-rouge">enter_stmt</code> which we override.</li>
  <li>The <code class="language-plaintext highlighter-rouge">#run</code> invocation operates over a <code class="language-plaintext highlighter-rouge">stmt list</code> by default.</li>
  <li>We pass unit <code class="language-plaintext highlighter-rouge">()</code> as the initial state.</li>
  <li>The return type of enter_stmt is that of our state: <code class="language-plaintext highlighter-rouge">unit</code>.</li>
</ul>

<hr/>

<h4>A visitor with state</h4>

<blockquote>
  <p>How do I collect all the the jump (direct) targets in a list of BIL statements?</p>
</blockquote>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">collect_jumps</span> <span class="n">bil_stmts</span> <span class="o">=</span>
  <span class="p">(</span><span class="k">object</span> <span class="k">inherit</span> <span class="p">[</span><span class="nn">Word</span><span class="p">.</span><span class="n">t</span> <span class="kt">list</span><span class="p">]</span> <span class="nn">Bil</span><span class="p">.</span><span class="n">visitor</span>
    <span class="n">method</span><span class="o">!</span> <span class="n">enter_int</span> <span class="n">x</span> <span class="n">state</span> <span class="o">=</span> <span class="k">if</span> <span class="n">in_jmp</span> <span class="k">then</span> <span class="n">x</span> <span class="o">::</span> <span class="n">state</span> <span class="k">else</span> <span class="n">state</span>
  <span class="k">end</span><span class="p">)</span><span class="o">#</span><span class="n">run</span> <span class="n">bil_stmts</span> <span class="bp">[]</span>
</code></pre></div></div>

<p>Output (if we print the result):</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>Jmp: 0x40056E:64
</code></pre></div></div>

<p>Notes:</p>

<ul>
  <li>This time, the visitor uses a <code class="language-plaintext highlighter-rouge">Word.t list</code> as user-supplied state which
stores jump targets.</li>
  <li>Our callback triggers every time we enter an int; essentially, a constant.</li>
  <li>We determine that this constant is a jump target with the <code class="language-plaintext highlighter-rouge">in_jmp</code> predicate:
this state is implicitly included with each visit. See the <a href="https://github.com/BinaryAnalysisPlatform/bap/blob/master/lib/bap/bap.mli#L1982">class
state</a>
in the API for other information passed along visits.</li>
  <li>Instead of <code class="language-plaintext highlighter-rouge">in_jmp</code>, we could of course have used a different hook: the
provided
<a href="https://github.com/BinaryAnalysisPlatform/bap/blob/master/lib/bap/bap.mli#L2058">enter_jmp</a>
callback.</li>
</ul>

<hr/>

<h2>Mappers</h2>

<h4>A simple mapper</h4>

<blockquote>
  <p>How do I use a BIL mapper to transform BIL code?</p>
</blockquote>

<p>Our previous visitor inherited the BIL <code class="language-plaintext highlighter-rouge">class 'a visitor</code>, where <code class="language-plaintext highlighter-rouge">'a</code> was our
inherited user-supplied state. But there&rsquo;s also <code class="language-plaintext highlighter-rouge">class mapper</code>. <code class="language-plaintext highlighter-rouge">class mapper</code>
doesn&rsquo;t carry any user-supplied state with it. With mapper, you can transform
the BIL statements and expressions in the AST.</p>

<p>Let&rsquo;s transform binary operations with some constant offset to an offset of <code class="language-plaintext highlighter-rouge">0x41</code>. For instance:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>RSP := RSP - 0x8:64
</code></pre></div></div>

<p>becomes</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>RSP := RSP - 0x41:64
</code></pre></div></div>

<p>Specifically, if we encounter the binary operator <code class="language-plaintext highlighter-rouge">+</code> or <code class="language-plaintext highlighter-rouge">-</code>, and its second
operand is a constant, we rewrite the constant to be <code class="language-plaintext highlighter-rouge">0x41</code>.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">offset_41_mapper</span> <span class="n">bil_stmts</span> <span class="o">=</span>
  <span class="p">(</span><span class="k">object</span> <span class="k">inherit</span> <span class="nn">Bil</span><span class="p">.</span><span class="n">mapper</span>
    <span class="n">method</span><span class="o">!</span> <span class="n">map_binop</span> <span class="n">operator</span> <span class="n">operand1</span> <span class="n">operand2</span> <span class="o">=</span>
      <span class="k">match</span> <span class="n">operator</span><span class="o">,</span><span class="n">operand2</span> <span class="k">with</span>
      <span class="o">|</span> <span class="nn">Bil</span><span class="p">.</span><span class="nc">PLUS</span><span class="o">,</span><span class="nn">Bil</span><span class="p">.</span><span class="nc">Int</span> <span class="n">offset</span>
      <span class="o">|</span> <span class="nn">Bil</span><span class="p">.</span><span class="nc">MINUS</span><span class="o">,</span><span class="nn">Bil</span><span class="p">.</span><span class="nc">Int</span> <span class="n">offset</span> <span class="o">-&gt;</span>
        <span class="k">let</span> <span class="n">new_operand2</span> <span class="o">=</span> <span class="nn">Bil</span><span class="p">.</span><span class="n">int</span> <span class="p">(</span><span class="nn">Word</span><span class="p">.</span><span class="n">of_int</span> <span class="o">~</span><span class="n">width</span><span class="o">:</span><span class="mi">64</span> <span class="mh">0x41</span><span class="p">)</span> <span class="k">in</span>
        <span class="nn">Bil</span><span class="p">.</span><span class="n">binop</span> <span class="n">operator</span> <span class="n">operand1</span> <span class="n">new_operand2</span>
      <span class="o">|</span> <span class="n">_</span> <span class="o">-&gt;</span> <span class="nn">Bil</span><span class="p">.</span><span class="n">binop</span> <span class="n">operator</span> <span class="n">operand1</span> <span class="n">operand2</span>
  <span class="k">end</span><span class="p">)</span><span class="o">#</span><span class="n">run</span> <span class="n">bil_stmts</span> <span class="k">in</span>
</code></pre></div></div>

<p>Output:</p>
<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>t_113 := RBP
RSP := RSP - 0x41:64
mem64 := mem64 with [RSP, el]:u64 &lt;- t_113
</code></pre></div></div>

<p>Notes:</p>

<ul>
  <li>We inherit <code class="language-plaintext highlighter-rouge">Bil.mapper</code>.</li>
  <li>We use <code class="language-plaintext highlighter-rouge">map_binop</code> instead of <code class="language-plaintext highlighter-rouge">enter_binop</code>.</li>
  <li>We pattern-match against the BIL operators <code class="language-plaintext highlighter-rouge">PLUS</code> and <code class="language-plaintext highlighter-rouge">MINUS</code>, and pattern
match the second operand against <code class="language-plaintext highlighter-rouge">Bil.Int</code>: if it matches, we rewrite the
second operand and construct a new <code class="language-plaintext highlighter-rouge">Bil.binop</code> expression.</li>
  <li>If we reach the <code class="language-plaintext highlighter-rouge">_</code> case for pattern matching, nothing changes: we
reconstruct the original expression using the same operator and operands.</li>
  <li>No user-state is passed a long. The return type for each expression is <code class="language-plaintext highlighter-rouge">exp</code>.</li>
</ul>

<hr/>

<h2>Customization</h2>

<h4>A custom visitor</h4>

<blockquote>
  <p>What is a custom visitor and how can I make one?</p>
</blockquote>

<p>We can create our own subclassing visitor, i.e., we don&rsquo;t have to use class &lsquo;a visitor or class mapper. For instance, we can pass our own implicit state a long with a custom visitor (and still allow anyone else to define a user-supplied state variable). Here&rsquo;s some quick syntax for defining your own visitor:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">class</span> <span class="p">[</span><span class="k">'</span><span class="n">a</span><span class="p">]</span> <span class="n">custom_visitor</span> <span class="o">=</span> <span class="k">object</span>
   <span class="k">inherit</span> <span class="p">[</span><span class="k">'</span><span class="n">a</span> <span class="o">*</span> <span class="kt">int</span> <span class="kt">list</span><span class="p">]</span> <span class="nn">Bil</span><span class="p">.</span><span class="n">visitor</span>
<span class="k">end</span>
</code></pre></div></div>
<p>Let&rsquo;s define a <code class="language-plaintext highlighter-rouge">custom_visit</code> function:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">custom_visit</span> <span class="n">bil_stmts</span> <span class="o">=</span>
  <span class="p">(</span><span class="k">object</span> <span class="k">inherit</span> <span class="p">[</span><span class="kt">string</span><span class="p">]</span> <span class="n">custom_visitor</span>
    <span class="n">method</span><span class="o">!</span> <span class="n">enter_stmt</span> <span class="n">stmt</span> <span class="n">state</span> <span class="o">=</span>
      <span class="nn">Format</span><span class="p">.</span><span class="n">printf</span> <span class="s2">&quot;Visiting %s</span><span class="se">\n</span><span class="s2">&quot;</span> <span class="p">(</span><span class="nn">Stmt</span><span class="p">.</span><span class="n">to_string</span> <span class="n">stmt</span><span class="p">);</span>
      <span class="p">(</span><span class="s2">&quot;still-user-defined&quot;</span><span class="o">,</span><span class="p">[</span><span class="mi">3</span><span class="p">;</span><span class="mi">2</span><span class="p">;</span><span class="mi">1</span><span class="p">])</span>
  <span class="k">end</span><span class="p">)</span><span class="o">#</span><span class="n">run</span> <span class="n">bil_stmts</span> <span class="p">(</span><span class="s2">&quot;user-defined&quot;</span><span class="o">,</span><span class="p">[</span><span class="mi">1</span><span class="p">;</span><span class="mi">2</span><span class="p">;</span><span class="mi">3</span><span class="p">])</span>
</code></pre></div></div>

<p>Output:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>Visiting t_113 := RBP
Visiting RSP := RSP - 0x8:64
Visiting mem64 := mem64 with [RSP, el]:u64 &lt;- t_113
</code></pre></div></div>

<p>Notes:</p>

<ul>
  <li>Our visitor inherits only the type of our <em>user-defined</em> state: a string.</li>
  <li>However, the inherited <code class="language-plaintext highlighter-rouge">state</code> variable in <code class="language-plaintext highlighter-rouge">enter_stmt</code> has type <code class="language-plaintext highlighter-rouge">string *
int list</code>: the type defined in our <code class="language-plaintext highlighter-rouge">custom_visitor</code> class.</li>
  <li>The <code class="language-plaintext highlighter-rouge">int list</code> is passed along any visitor we create using <code class="language-plaintext highlighter-rouge">custom_vistor</code>.
This is useful if the <code class="language-plaintext highlighter-rouge">int list</code> state is changed by another function as we
fold over BIL (for instance, for tracking depth in the AST, we might create a
<code class="language-plaintext highlighter-rouge">depth_visitor</code> that maintains a depth of the current traversal, without the
user having to define their own variable for doing so).</li>
</ul>

<hr/>

<h2>Wrap-up</h2>

<p>This post highlighted some basics of BIL visitor and mapper functionality, but
there is a lot more to discover. For example, here are further extensions that
are possible within the visitor framework:</p>

<ul>
  <li>Our examples used only a single callback method; of course, we can have
multiple visit methods inside our visitor object.</li>
  <li>Our examples have all invoked the traversal with <code class="language-plaintext highlighter-rouge">#run</code>. However, we can in
fact visit any particular part of the BIL AST by replacing <code class="language-plaintext highlighter-rouge">#run</code> in previous
examples with
<a href="https://github.com/BinaryAnalysisPlatform/bap/blob/master/lib/bap/bap.mli#L2048">#enter_stmt</a>,
<a href="https://github.com/BinaryAnalysisPlatform/bap/blob/master/lib/bap/bap.mli#L2083">#enter_exp</a>,
<a href="https://github.com/BinaryAnalysisPlatform/bap/blob/master/lib/bap/bap.mli#L2098">#enter_binop</a>,
and so on: the only condition is that we supply these visits with the correct
type. So, where <code class="language-plaintext highlighter-rouge">#run</code> accepts a <code class="language-plaintext highlighter-rouge">stmt list</code>, <code class="language-plaintext highlighter-rouge">enter_exp</code> expects an <code class="language-plaintext highlighter-rouge">exp</code>.</li>
  <li>Our examples made use of <code class="language-plaintext highlighter-rouge">enter_...</code> visitors. However, every language
construct also has additional <code class="language-plaintext highlighter-rouge">visit_...</code> and <code class="language-plaintext highlighter-rouge">leave_...</code> directives,
depending on the need.</li>
  <li>There are a host of <a href="https://github.com/BinaryAnalysisPlatform/bap/blob/master/lib/bap/bap.mli#L2226">BIL
iterators</a>
that can be used in all sorts of imaginative ways: We can iterate, map, fold
(and many more!) over BIL statements. For example, we can supply <code class="language-plaintext highlighter-rouge">Bil.fold</code>
with a visitor object which is run over the AST with our own <code class="language-plaintext highlighter-rouge">init</code> state.</li>
  <li>Many interesting BIL transformers exist, for example, a <a href="https://github.com/BinaryAnalysisPlatform/bap/blob/master/lib/bap/bap.mli#L2316">constant
folder</a>
and <a href="https://github.com/BinaryAnalysisPlatform/bap/blob/master/lib/bap/bap.mli#L2299">expression
substituter</a>.</li>
  <li>Have a look at the
<a href="https://github.com/BinaryAnalysisPlatform/bap/blob/master/lib/bap/bap.mli#L2149">finder</a>
if you want a BIL visitor that searches for specific patterns in the AST.</li>
</ul>

<hr/>

<h2>Examples template</h2>

<h4>Visitor and mapper examples template</h4>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="o">#</span><span class="n">use</span> <span class="s2">&quot;topfind&quot;</span><span class="p">;;</span>
<span class="o">#</span><span class="n">require</span> <span class="s2">&quot;bap.top&quot;</span><span class="p">;;</span>
<span class="k">open</span> <span class="nn">Core_kernel</span><span class="p">.</span><span class="nc">Std</span>
<span class="k">open</span> <span class="nn">Bap</span><span class="p">.</span><span class="nc">Std</span>
<span class="k">open</span> <span class="nc">Or_error</span>

<span class="k">let</span> <span class="n">main</span> <span class="bp">()</span> <span class="o">=</span>
  <span class="nn">Project</span><span class="p">.</span><span class="n">from_file</span> <span class="nn">Sys</span><span class="p">.</span><span class="n">argv</span><span class="o">.</span><span class="p">(</span><span class="mi">1</span><span class="p">)</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="n">project</span> <span class="o">-&gt;</span>

  <span class="k">let</span> <span class="n">normalize</span> <span class="o">=</span> <span class="nn">String</span><span class="p">.</span><span class="n">filter</span> <span class="o">~</span><span class="n">f</span><span class="o">:</span><span class="p">(</span><span class="k">function</span>
      <span class="o">|</span> <span class="sc">'\t'</span> <span class="o">|</span> <span class="k">'</span><span class="p">{</span><span class="k">'</span> <span class="o">|</span> <span class="k">'</span><span class="p">}</span><span class="k">'</span> <span class="o">-&gt;</span> <span class="bp">false</span>
      <span class="o">|</span> <span class="n">_</span> <span class="o">-&gt;</span> <span class="bp">true</span><span class="p">)</span> <span class="k">in</span>

  <span class="k">let</span> <span class="n">syms</span> <span class="o">=</span> <span class="nn">Project</span><span class="p">.</span><span class="n">symbols</span> <span class="n">project</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">main_fn</span> <span class="o">=</span> <span class="k">match</span> <span class="nn">Symtab</span><span class="p">.</span><span class="n">find_by_name</span> <span class="n">syms</span> <span class="s2">&quot;main&quot;</span> <span class="k">with</span>
    <span class="o">|</span> <span class="nc">Some</span> <span class="n">fn</span> <span class="o">-&gt;</span> <span class="n">fn</span>
    <span class="o">|</span> <span class="nc">None</span> <span class="o">-&gt;</span> <span class="n">failwith</span> <span class="s2">&quot;Could not find function main in symbol table&quot;</span>
  <span class="k">in</span>
  <span class="k">let</span> <span class="n">entry_block</span> <span class="o">=</span> <span class="nn">Symtab</span><span class="p">.</span><span class="n">entry_of_fn</span> <span class="n">main_fn</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">block_insns</span> <span class="o">=</span> <span class="nn">Block</span><span class="p">.</span><span class="n">insns</span> <span class="n">entry_block</span> <span class="k">in</span>

  <span class="c">(* visit_each_stmt *)</span>
  <span class="k">let</span> <span class="n">visit_each_stmt</span> <span class="n">bil_stmts</span> <span class="o">=</span>
    <span class="p">(</span><span class="k">object</span> <span class="k">inherit</span> <span class="p">[</span><span class="kt">unit</span><span class="p">]</span> <span class="nn">Bil</span><span class="p">.</span><span class="n">visitor</span>
      <span class="n">method</span><span class="o">!</span> <span class="n">enter_stmt</span> <span class="n">stmt</span> <span class="n">state</span> <span class="o">=</span>
        <span class="nn">Format</span><span class="p">.</span><span class="n">printf</span> <span class="s2">&quot;Visiting %s</span><span class="se">\n</span><span class="s2">&quot;</span> <span class="p">(</span><span class="nn">Stmt</span><span class="p">.</span><span class="n">to_string</span> <span class="n">stmt</span><span class="p">)</span>
    <span class="k">end</span><span class="p">)</span><span class="o">#</span><span class="n">run</span> <span class="n">bil_stmts</span> <span class="bp">()</span>
  <span class="k">in</span>

  <span class="nn">List</span><span class="p">.</span><span class="n">iter</span> <span class="n">block_insns</span> <span class="o">~</span><span class="n">f</span><span class="o">:</span><span class="p">(</span><span class="k">fun</span> <span class="p">(</span><span class="n">_</span><span class="o">,</span><span class="n">insn</span><span class="p">)</span> <span class="o">-&gt;</span>
      <span class="k">let</span> <span class="n">bil</span> <span class="o">=</span> <span class="nn">Insn</span><span class="p">.</span><span class="n">bil</span> <span class="n">insn</span> <span class="k">in</span>
      <span class="n">visit_each_stmt</span> <span class="n">bil</span><span class="p">);</span>

  <span class="c">(* collect_jumps *)</span>
  <span class="k">let</span> <span class="n">collect_jumps</span> <span class="n">bil_stmts</span> <span class="o">=</span>
    <span class="p">(</span><span class="k">object</span> <span class="k">inherit</span> <span class="p">[</span><span class="nn">Word</span><span class="p">.</span><span class="n">t</span> <span class="kt">list</span><span class="p">]</span> <span class="nn">Bil</span><span class="p">.</span><span class="n">visitor</span>
      <span class="n">method</span><span class="o">!</span> <span class="n">enter_int</span> <span class="n">x</span> <span class="n">state</span> <span class="o">=</span> <span class="k">if</span> <span class="n">in_jmp</span> <span class="k">then</span> <span class="n">x</span> <span class="o">::</span> <span class="n">state</span> <span class="k">else</span> <span class="n">state</span>
    <span class="k">end</span><span class="p">)</span><span class="o">#</span><span class="n">run</span> <span class="n">bil_stmts</span> <span class="bp">[]</span>
  <span class="k">in</span>

  <span class="nn">List</span><span class="p">.</span><span class="n">iter</span> <span class="n">block_insns</span> <span class="o">~</span><span class="n">f</span><span class="o">:</span><span class="p">(</span><span class="k">fun</span> <span class="p">(</span><span class="n">_</span><span class="o">,</span><span class="n">insn</span><span class="p">)</span> <span class="o">-&gt;</span>
      <span class="k">let</span> <span class="n">bil</span> <span class="o">=</span> <span class="nn">Insn</span><span class="p">.</span><span class="n">bil</span> <span class="n">insn</span> <span class="k">in</span>
      <span class="n">collect_jumps</span> <span class="n">bil</span> <span class="o">|&gt;</span> <span class="nn">List</span><span class="p">.</span><span class="n">iter</span>
        <span class="o">~</span><span class="n">f</span><span class="o">:</span><span class="p">(</span><span class="k">fun</span> <span class="n">word</span> <span class="o">-&gt;</span> <span class="nn">Format</span><span class="p">.</span><span class="n">printf</span> <span class="s2">&quot;Jmp: %a</span><span class="se">\n</span><span class="s2">&quot;</span> <span class="nn">Word</span><span class="p">.</span><span class="n">pp</span> <span class="n">word</span><span class="p">));</span>

  <span class="c">(* offset_41_mapper *)</span>
  <span class="k">let</span> <span class="n">offset_41_mapper</span> <span class="n">bil_stmts</span> <span class="o">=</span>
    <span class="p">(</span><span class="k">object</span> <span class="k">inherit</span> <span class="nn">Bil</span><span class="p">.</span><span class="n">mapper</span>
      <span class="n">method</span><span class="o">!</span> <span class="n">map_binop</span> <span class="n">operator</span> <span class="n">operand1</span> <span class="n">operand2</span> <span class="o">=</span>
        <span class="k">match</span> <span class="n">operator</span><span class="o">,</span><span class="n">operand2</span> <span class="k">with</span>
        <span class="o">|</span> <span class="nn">Bil</span><span class="p">.</span><span class="nc">PLUS</span><span class="o">,</span><span class="nn">Bil</span><span class="p">.</span><span class="nc">Int</span> <span class="n">offset</span>
        <span class="o">|</span> <span class="nn">Bil</span><span class="p">.</span><span class="nc">MINUS</span><span class="o">,</span><span class="nn">Bil</span><span class="p">.</span><span class="nc">Int</span> <span class="n">offset</span> <span class="o">-&gt;</span>
          <span class="k">let</span> <span class="n">new_operand2</span> <span class="o">=</span> <span class="nn">Bil</span><span class="p">.</span><span class="n">int</span> <span class="p">(</span><span class="nn">Word</span><span class="p">.</span><span class="n">of_int</span> <span class="o">~</span><span class="n">width</span><span class="o">:</span><span class="mi">64</span> <span class="mh">0x41</span><span class="p">)</span> <span class="k">in</span>
          <span class="nn">Bil</span><span class="p">.</span><span class="n">binop</span> <span class="n">operator</span> <span class="n">operand1</span> <span class="n">new_operand2</span>
        <span class="o">|</span> <span class="n">_</span> <span class="o">-&gt;</span> <span class="nn">Bil</span><span class="p">.</span><span class="n">binop</span> <span class="n">operator</span> <span class="n">operand1</span> <span class="n">operand2</span>
    <span class="k">end</span><span class="p">)</span><span class="o">#</span><span class="n">run</span> <span class="n">bil_stmts</span> <span class="k">in</span>

  <span class="nn">List</span><span class="p">.</span><span class="n">iter</span> <span class="n">block_insns</span> <span class="o">~</span><span class="n">f</span><span class="o">:</span><span class="p">(</span><span class="k">fun</span> <span class="p">(</span><span class="n">_</span><span class="o">,</span><span class="n">insn</span><span class="p">)</span> <span class="o">-&gt;</span>
      <span class="k">let</span> <span class="n">bil</span> <span class="o">=</span> <span class="nn">Insn</span><span class="p">.</span><span class="n">bil</span> <span class="n">insn</span> <span class="k">in</span>
      <span class="k">let</span> <span class="n">new_bil</span> <span class="o">=</span>
        <span class="n">offset_41_mapper</span> <span class="n">bil</span> <span class="k">in</span>
      <span class="nn">Format</span><span class="p">.</span><span class="n">printf</span> <span class="s2">&quot;41-Bil: %s</span><span class="se">\n</span><span class="s2">&quot;</span> <span class="p">(</span><span class="nn">Bil</span><span class="p">.</span><span class="n">to_string</span> <span class="n">new_bil</span> <span class="o">|&gt;</span> <span class="n">normalize</span><span class="p">));</span>

  <span class="n">return</span> <span class="bp">()</span>

  <span class="k">let</span> <span class="bp">()</span> <span class="o">=</span>
    <span class="k">try</span> <span class="n">main</span> <span class="bp">()</span>
        <span class="o">|&gt;</span> <span class="k">function</span>
        <span class="o">|</span> <span class="nc">Ok</span> <span class="n">o</span> <span class="o">-&gt;</span> <span class="bp">()</span>
        <span class="o">|</span> <span class="nc">Error</span> <span class="n">e</span> <span class="o">-&gt;</span> <span class="nn">Format</span><span class="p">.</span><span class="n">printf</span> <span class="s2">&quot;BAP error: %s</span><span class="se">\n</span><span class="s2">&quot;</span> <span class="o">@@</span> <span class="nn">Error</span><span class="p">.</span><span class="n">to_string_hum</span> <span class="n">e</span>
    <span class="k">with</span>
    <span class="o">|</span> <span class="nc">Invalid_argument</span> <span class="n">_</span> <span class="o">-&gt;</span>
      <span class="nn">Format</span><span class="p">.</span><span class="n">printf</span> <span class="s2">&quot;Please specify a file on the command line</span><span class="se">\n</span><span class="s2">&quot;</span>
</code></pre></div></div>

<h4>Custom visitor template</h4>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="o">#</span><span class="n">use</span> <span class="s2">&quot;topfind&quot;</span><span class="p">;;</span>
<span class="o">#</span><span class="n">require</span> <span class="s2">&quot;bap.top&quot;</span><span class="p">;;</span>
<span class="k">open</span> <span class="nn">Core_kernel</span><span class="p">.</span><span class="nc">Std</span>
<span class="k">open</span> <span class="nn">Bap</span><span class="p">.</span><span class="nc">Std</span>
<span class="k">open</span> <span class="nc">Or_error</span>

<span class="c">(* custom_visitor *)</span>
<span class="k">class</span> <span class="p">[</span><span class="k">'</span><span class="n">a</span><span class="p">]</span> <span class="n">custom_visitor</span> <span class="o">=</span> <span class="k">object</span>
   <span class="k">inherit</span> <span class="p">[</span><span class="k">'</span><span class="n">a</span> <span class="o">*</span> <span class="kt">int</span> <span class="kt">list</span><span class="p">]</span> <span class="nn">Bil</span><span class="p">.</span><span class="n">visitor</span>
<span class="k">end</span>

<span class="k">let</span> <span class="n">main</span> <span class="bp">()</span> <span class="o">=</span>
  <span class="nn">Project</span><span class="p">.</span><span class="n">from_file</span> <span class="nn">Sys</span><span class="p">.</span><span class="n">argv</span><span class="o">.</span><span class="p">(</span><span class="mi">1</span><span class="p">)</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="n">project</span> <span class="o">-&gt;</span>

  <span class="c">(* custom_visit *)</span>
  <span class="k">let</span> <span class="n">custom_visit</span> <span class="n">bil_stmts</span> <span class="o">=</span>
    <span class="p">(</span><span class="k">object</span> <span class="k">inherit</span> <span class="p">[</span><span class="kt">string</span><span class="p">]</span> <span class="n">custom_visitor</span>
      <span class="n">method</span><span class="o">!</span> <span class="n">enter_stmt</span> <span class="n">stmt</span> <span class="n">state</span> <span class="o">=</span>
        <span class="nn">Format</span><span class="p">.</span><span class="n">printf</span> <span class="s2">&quot;Visiting %s</span><span class="se">\n</span><span class="s2">&quot;</span> <span class="p">(</span><span class="nn">Stmt</span><span class="p">.</span><span class="n">to_string</span> <span class="n">stmt</span><span class="p">);</span>
        <span class="p">(</span><span class="s2">&quot;still-user-defined&quot;</span><span class="o">,</span><span class="p">[</span><span class="mi">3</span><span class="p">;</span><span class="mi">2</span><span class="p">;</span><span class="mi">1</span><span class="p">])</span>
    <span class="k">end</span><span class="p">)</span><span class="o">#</span><span class="n">run</span> <span class="n">bil_stmts</span> <span class="p">(</span><span class="s2">&quot;user-defined&quot;</span><span class="o">,</span><span class="p">[</span><span class="mi">1</span><span class="p">;</span><span class="mi">2</span><span class="p">;</span><span class="mi">3</span><span class="p">])</span>
  <span class="k">in</span>

  <span class="k">let</span> <span class="n">syms</span> <span class="o">=</span> <span class="nn">Project</span><span class="p">.</span><span class="n">symbols</span> <span class="n">project</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">main_fn</span> <span class="o">=</span> <span class="k">match</span> <span class="nn">Symtab</span><span class="p">.</span><span class="n">find_by_name</span> <span class="n">syms</span> <span class="s2">&quot;main&quot;</span> <span class="k">with</span>
    <span class="o">|</span> <span class="nc">Some</span> <span class="n">fn</span> <span class="o">-&gt;</span> <span class="n">fn</span>
    <span class="o">|</span> <span class="nc">None</span> <span class="o">-&gt;</span> <span class="n">failwith</span> <span class="s2">&quot;Could not find function main in symbol table&quot;</span>
  <span class="k">in</span>
  <span class="k">let</span> <span class="n">entry_block</span> <span class="o">=</span> <span class="nn">Symtab</span><span class="p">.</span><span class="n">entry_of_fn</span> <span class="n">main_fn</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">block_insns</span> <span class="o">=</span> <span class="nn">Block</span><span class="p">.</span><span class="n">insns</span> <span class="n">entry_block</span> <span class="k">in</span>

  <span class="nn">List</span><span class="p">.</span><span class="n">iter</span> <span class="n">block_insns</span> <span class="o">~</span><span class="n">f</span><span class="o">:</span><span class="p">(</span><span class="k">fun</span> <span class="p">(</span><span class="n">mem</span><span class="o">,</span><span class="n">insn</span><span class="p">)</span> <span class="o">-&gt;</span>
      <span class="k">let</span> <span class="n">bil</span> <span class="o">=</span> <span class="nn">Insn</span><span class="p">.</span><span class="n">bil</span> <span class="n">insn</span> <span class="k">in</span>
      <span class="n">custom_visit</span> <span class="n">bil</span> <span class="o">|&gt;</span> <span class="nn">Pervasives</span><span class="p">.</span><span class="n">ignore</span><span class="p">);</span>

  <span class="n">return</span> <span class="bp">()</span>

  <span class="k">let</span> <span class="bp">()</span> <span class="o">=</span>
    <span class="k">try</span> <span class="n">main</span> <span class="bp">()</span>
        <span class="o">|&gt;</span> <span class="k">function</span>
        <span class="o">|</span> <span class="nc">Ok</span> <span class="n">o</span> <span class="o">-&gt;</span> <span class="bp">()</span>
        <span class="o">|</span> <span class="nc">Error</span> <span class="n">e</span> <span class="o">-&gt;</span> <span class="nn">Format</span><span class="p">.</span><span class="n">printf</span> <span class="s2">&quot;BAP error: %s</span><span class="se">\n</span><span class="s2">&quot;</span> <span class="o">@@</span> <span class="nn">Error</span><span class="p">.</span><span class="n">to_string_hum</span> <span class="n">e</span>
    <span class="k">with</span>
    <span class="o">|</span> <span class="nc">Invalid_argument</span> <span class="n">_</span> <span class="o">-&gt;</span>
      <span class="nn">Format</span><span class="p">.</span><span class="n">printf</span> <span class="s2">&quot;Please specify a file on the command line</span><span class="se">\n</span><span class="s2">&quot;</span>
</code></pre></div></div>


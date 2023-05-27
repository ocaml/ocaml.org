---
title: OCaml compiler weekly, 3 April 2023
description:
url: http://gallium.inria.fr/blog/florian-compiler-weekly-2023-04-03
date: 2023-04-03T08:00:00-00:00
preview_image:
featured:
authors:
- gallium
---



  <p>This series of blog post aims to give a short weekly glimpse into my
(Florian Angeletti) work on the OCaml compiler: this week, the focus is
on format string and how to serialize partial error messages while still
using the formatting engine from the Format module.</p>


  

  
<p>Last week, beyond some ongoing discussion on the refactorisation of
Dynlink, and a draft for some future tutorial on GADTs, I spent some
time refactoring and cleaning up my work on an alternative interpreter
for OCaml format strings.</p>
<h3>A serializable
data type for Format messages</h3>
<p>A medium term objective for me this year is to make it possible for
the compiler to emit machine-readable messages at the destination of the
various development tools for OCaml.</p>
<p>This would avoid the need for those tools to parse the compiler error
messages or warnings, and make it simpler for exterior contributors to
experiment with new error formats.</p>
<p>One of the obstacle towards this objective comes from the difficulty
to have partial messages when using <code>Format</code> as a formatting
engine. As an example, imagine that I want to print an error message
with a prefix</p>
<div class="highlight"><pre><span></span><span class="o">@[</span><span class="nc">Error</span><span class="o">:</span>
</pre></div>

<p>and a main body</p>
<div class="highlight"><pre><span></span><span class="nc">This</span> <span class="n">expression</span> <span class="n">has</span> <span class="k">type</span> <span class="kt">int</span><span class="o">@</span> <span class="n">which</span> <span class="n">is</span> <span class="n">not</span> <span class="n">a</span> <span class="n">record</span> <span class="k">type</span>
</pre></div>

<p>if I want to preserve the newline hint in the main body while making
the body message starts just after the prefix, I need to print the two
parts of the error message at the same time, with for instance:</p>
<div class="highlight"><pre><span></span><span class="nn">Format</span><span class="p">.</span><span class="n">fprintf</span> <span class="n">ppf</span> <span class="s2">&quot;%t%t&quot;</span> <span class="n">prefix</span> <span class="n">main_body</span>
</pre></div>

<p>If I rendered ever part of the messages to string before printing I
would lose the context that the Format module is using for indentation
and line breaks. Similarly, I cannot start rendering the second message
before the first. This means that the <code>Format</code> requires us to
always print messages in order.</p>
<p>This complexity is reflected in the type of the compiler error report
where partial messages are represented as suspended closure:</p>
<div class="highlight"><pre><span></span><span class="k">type</span> <span class="n">msg</span> <span class="o">=</span> <span class="o">(</span><span class="nn">Format</span><span class="p">.</span><span class="n">formatter</span> <span class="o">-&gt;</span> <span class="kt">unit</span><span class="o">)</span> <span class="n">loc</span>
<span class="k">type</span> <span class="n">report</span> <span class="o">=</span> <span class="o">{</span>
  <span class="n">kind</span> <span class="o">:</span> <span class="n">report_kind</span><span class="o">;</span>
  <span class="n">main</span> <span class="o">:</span> <span class="n">msg</span><span class="o">;</span>
  <span class="n">sub</span> <span class="o">:</span> <span class="n">msg</span> <span class="kt">list</span><span class="o">;</span>
<span class="o">}</span>
</pre></div>

<p>This representation creates three issues:</p>
<ul>
<li>First, one must be very careful that the delayed closure does not
capture the wrong global state.</li>
<li>Second, it is not serializable.</li>
<li>Third, it is cumbersome and for instance warning messages where
never converted to this format.</li>
</ul>
<p>As surprising as it may sound, the first grievance rears its head not
that infrequently in the compiler code base because the pretty-printer
for types is full of global states (there are some global state to track
loop, some other state to track naming decision, yet another global
state to track shortest path name).</p>
<p>As a way to circumvent this issue, I have been working on immutable
interpreter for format strings which translates format strings as a
sequence of formatting instruction that might be interpreted later by a
formatting engine.</p>
<p>For instance with this interpreter, the format string</p>
<div class="highlight"><pre><span></span><span class="nn">Format_doc</span><span class="p">.</span><span class="nn">Immutable</span><span class="p">.</span><span class="n">printf</span>
  <span class="s2">&quot;@[This is a text with %s,@ breaks and @[%d box@].@]&quot;</span>
   <span class="s2">&quot;one hole&quot;</span> <span class="mi">2</span>
   <span class="nn">Format_doc</span><span class="p">.</span><span class="nn">Doc</span><span class="p">.</span><span class="n">empty</span>
</pre></div>

<p>is rendered to the following sequence of instructions for
<code>Format</code>:</p>
<div class="highlight"><pre><span></span><span class="o">[</span>
 <span class="nc">Open_box</span> <span class="o">{</span><span class="n">kind</span> <span class="o">=</span> <span class="nc">B</span><span class="o">;</span> <span class="n">indent</span> <span class="o">=</span> <span class="mi">0</span><span class="o">};</span>
 <span class="nc">Data</span> <span class="s2">&quot;This is a text with &quot;</span><span class="o">;</span>
 <span class="nc">Data</span> <span class="s2">&quot;one hole&quot;</span><span class="o">;</span>
 <span class="nc">Data</span> <span class="s2">&quot;,&quot;</span><span class="o">;</span>
 <span class="nc">Simple_break</span> <span class="o">{</span><span class="n">spaces</span> <span class="o">=</span> <span class="mi">1</span><span class="o">;</span> <span class="n">indent</span> <span class="o">=</span> <span class="mi">0</span><span class="o">};</span>
 <span class="nc">Data</span> <span class="s2">&quot;breaks and &quot;</span><span class="o">;</span>
 <span class="nc">Open_box</span> <span class="o">{</span><span class="n">kind</span> <span class="o">=</span> <span class="nc">B</span><span class="o">;</span> <span class="n">indent</span> <span class="o">=</span> <span class="mi">0</span><span class="o">};</span>
 <span class="nc">Data</span> <span class="s2">&quot;2&quot;</span><span class="o">;</span>
 <span class="nc">Data</span> <span class="s2">&quot; box&quot;</span><span class="o">;</span>
 <span class="nc">Close_box</span><span class="o">;</span>
 <span class="nc">Data</span> <span class="s2">&quot;.&quot;</span><span class="o">;</span>
 <span class="nc">Close_box</span>
<span class="o">]</span>
</pre></div>

<p>One advantages of this type is that we have transformed the format
string into data, with no closures in sight. The format is thus
inherently serializable and does not rely on any captured state.</p>
<p>Moreover, with a bit of GADTs, we can create a compatibility layer
between the classical <code>Format</code> interpreter and the new
immutable interpreter.</p>
<p>First, we define compatibility formatters as</p>
<div class="highlight"><pre><span></span><span class="k">type</span> <span class="n">rdoc</span> <span class="o">=</span> <span class="nn">Doc</span><span class="p">.</span><span class="n">t</span> <span class="n">ref</span>
<span class="k">type</span> <span class="o">_</span> <span class="n">formatter</span> <span class="o">=</span>
  <span class="o">|</span> <span class="nc">Format</span><span class="o">:</span> <span class="nn">Format</span><span class="p">.</span><span class="n">formatter</span> <span class="o">-&gt;</span> <span class="nn">Format</span><span class="p">.</span><span class="n">formatter</span> <span class="n">formatter</span>
  <span class="o">|</span> <span class="nc">Doc</span><span class="o">:</span> <span class="n">rdoc</span> <span class="o">-&gt;</span> <span class="n">rdoc</span> <span class="n">formatter</span>
</pre></div>

<p>Then the actual printing functions can choose which underlying
function to call in function of the formatter:</p>
<div class="highlight"><pre><span></span><span class="k">let</span> <span class="n">pp_print_string</span> <span class="o">(</span><span class="k">type</span> <span class="n">i</span><span class="o">)</span> <span class="o">(</span><span class="n">ppf</span><span class="o">:</span> <span class="n">i</span> <span class="n">formatter</span><span class="o">)</span> <span class="n">s</span> <span class="o">=</span> <span class="k">match</span> <span class="n">ppf</span> <span class="k">with</span>
  <span class="o">|</span> <span class="nc">Format</span> <span class="n">ppf</span> <span class="o">-&gt;</span> <span class="nn">Format</span><span class="p">.</span><span class="n">pp_print_string</span> <span class="n">ppf</span> <span class="n">s</span>
  <span class="o">|</span> <span class="nc">Doc</span> <span class="n">rdoc</span> <span class="o">-&gt;</span> <span class="n">rdoc</span> <span class="o">:=</span> <span class="nn">Immutable</span><span class="p">.</span><span class="n">string</span> <span class="n">s</span> <span class="o">!</span><span class="n">rdoc</span>
</pre></div>

<p>Splitting all primitive functions of the <code>Format</code> module
gives us a new <code>fprintf</code> function with type:</p>
<div class="highlight"><pre><span></span><span class="k">val</span> <span class="n">fprintf</span> <span class="o">:</span> <span class="k">'</span><span class="n">impl</span> <span class="n">formatter</span> <span class="o">-&gt;</span> <span class="o">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span><span class="k">'</span><span class="n">impl</span> <span class="n">formatter</span><span class="o">,</span><span class="kt">unit</span><span class="o">)</span> <span class="n">format</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span>
</pre></div>

<p>With this compatibility layer in place, converting a
<code>Format</code> printers is a matter of adding a single
<code>open Format_doc.Compat</code>.</p>
<p>I am still pondering on the implementation and design of this
alternative printing module. It is thus probable that I will end up
tying the final PR on this feature but I have made the implementation
available as a small <a href="https://github.com/Octachron/format-doc">format-doc</a>
library.</p>


  

---
title: OCaml compiler weekly, 27 March 2023
description:
url: http://gallium.inria.fr/blog/florian-compiler-weekly-2023-03-27
date: 2023-03-27T08:00:00-00:00
preview_image:
featured:
authors:
- gallium
---



  <p>This series of blog post aims to give a short weekly glimpse into my
(Florian Angeletti) work on the OCaml compiler.</p>


  

  
  <h3>Reviewing github pull
requests</h3>
<p>Last week, I have spent a significant portion of my week reviewing
pull requests on the compiler and I have been fortunate to merge three
nice pull requests:</p>
<h4><a href="https://github.com/ocaml/ocaml/pull/12116">Don&rsquo;t suggest a
semicolon when the type is not unit</a></h4>
<p>This pull request by Jules Aguillon improves the new error report for
applying a function to too many argument.</p>
<div class="highlight"><pre><span></span><span class="nn">List</span><span class="p">.</span><span class="n">map</span> <span class="o">((+)</span> <span class="mi">0</span><span class="o">)</span> <span class="o">[</span><span class="mi">1</span><span class="o">;</span><span class="mi">2</span><span class="o">;</span><span class="mi">3</span><span class="o">]</span> <span class="mi">0</span>
</pre></div>

<div class="highlight"><pre><span></span><span class="n">Error:</span> <span class="n">The</span> <span class="n">function</span> <span class="s">'List.map'</span> <span class="k">has</span> <span class="nb">type</span> (<span class="s">'a -&gt; '</span><span class="n">b</span>) -&gt; <span class="s">'a list -&gt; '</span><span class="n">b</span> <span class="n">list</span>
       <span class="n">It</span> <span class="k">is</span> <span class="n">applied</span> <span class="nb">to</span> <span class="n">too</span> <span class="n">many</span> <span class="n">arguments</span>
<span class="n">File</span> <span class="s">&quot;test.ml&quot;</span>, <span class="nb">line</span> <span class="mi">1</span>, <span class="n">characters</span> <span class="mi">23</span><span class="o">-</span><span class="mi">25</span>:
<span class="mi">1</span> | <span class="nb">List</span>.<span class="n">map</span> ((+) <span class="mi">1</span>) [<span class="mi">0</span>;<span class="mi">1</span>;<span class="mi">2</span>] [<span class="mi">2</span>;<span class="mi">3</span>;<span class="mi">4</span>]
                           ^^
  <span class="n">Hint:</span> <span class="n">Did</span> <span class="n">you</span> <span class="n">forget</span> <span class="n">a</span> <span class="s">';'</span>?
<span class="n">File</span> <span class="s">&quot;test.ml&quot;</span>, <span class="nb">line</span> <span class="mi">1</span>, <span class="n">characters</span> <span class="mi">25</span><span class="o">-</span><span class="mi">32</span>:
<span class="mi">1</span> | <span class="nb">List</span>.<span class="n">map</span> ((+) <span class="mi">1</span>) [<span class="mi">0</span>;<span class="mi">1</span>;<span class="mi">2</span>] [<span class="mi">2</span>;<span class="mi">3</span>;<span class="mi">4</span>]
                             ^^^^^^^
  <span class="n">This</span> <span class="o">extra</span> <span class="n">argument</span> <span class="k">is</span> <span class="nb">not</span> <span class="nb">expected</span>.
</pre></div>

<p>by removing the hint whenever the expect result type of the
application is not <code>unit</code>. This let us with a shorter and
to-the-point error message:</p>
<div class="highlight"><pre><span></span><span class="nn">List</span><span class="p">.</span><span class="n">map</span> <span class="o">((+)</span> <span class="mi">0</span><span class="o">)</span> <span class="o">[</span><span class="mi">1</span><span class="o">;</span><span class="mi">2</span><span class="o">;</span><span class="mi">3</span><span class="o">]</span> <span class="mi">0</span>
</pre></div>

<div class="highlight"><pre><span></span><span class="n">Error:</span> <span class="n">The</span> <span class="n">function</span> <span class="s">'List.map'</span> <span class="k">has</span> <span class="nb">type</span> (<span class="s">'a -&gt; '</span><span class="n">b</span>) -&gt; <span class="s">'a list -&gt; '</span><span class="n">b</span> <span class="n">list</span>
       <span class="n">It</span> <span class="k">is</span> <span class="n">applied</span> <span class="nb">to</span> <span class="n">too</span> <span class="n">many</span> <span class="n">arguments</span>
<span class="n">File</span> <span class="s">&quot;test.ml&quot;</span>, <span class="nb">line</span> <span class="mi">1</span>, <span class="n">characters</span> <span class="mi">25</span><span class="o">-</span><span class="mi">32</span>:
<span class="mi">1</span> | <span class="nb">List</span>.<span class="n">map</span> ((+) <span class="mi">1</span>) [<span class="mi">0</span>;<span class="mi">1</span>;<span class="mi">2</span>] [<span class="mi">2</span>;<span class="mi">3</span>;<span class="mi">4</span>]
                             ^^^^^^^
  <span class="n">This</span> <span class="o">extra</span> <span class="n">argument</span> <span class="k">is</span> <span class="nb">not</span> <span class="nb">expected</span>.
</pre></div>

<p>Note that if you don&rsquo;t recognize the error message format, this is
expected: the previous version had already been considerably improved by
a previous PR by Jules.</p>
<h4><a href="https://github.com/ocaml/ocaml/pull/12051">Print the type
variables that cannot be generalized</a></h4>
<p>This pull request by Stefan Muenzel proposed to make more explicit
the error messages concerning non-generalizable type variables. The new
error message points explicitly to all non-generalize type variables in
the involved types.</p>
<p>For instance, writing a ml file containing the single line</p>
<div class="highlight"><pre><span></span><span class="k">let</span> <span class="n">x</span> <span class="o">=</span> <span class="nn">Fun</span><span class="p">.</span><span class="n">id</span> <span class="nn">Fun</span><span class="p">.</span><span class="n">id</span><span class="o">,</span> <span class="n">ref</span> <span class="nc">None</span>
</pre></div>

<p>now raises</p>
<div class="highlight"><pre><span></span><span class="mf">1</span><span class="w"> </span><span class="err">|</span><span class="w"> </span><span class="kd">let</span><span class="w"> </span><span class="n">x</span><span class="w"> </span><span class="o">=</span><span class="w"> </span><span class="n">Fun</span><span class="mf">.</span><span class="n">id</span><span class="w"> </span><span class="n">Fun</span><span class="mf">.</span><span class="n">id</span><span class="p">,</span><span class="w"> </span><span class="n">ref</span><span class="w"> </span><span class="n">None</span><span class="w"></span>
<span class="w">        </span><span class="o">^</span><span class="w"></span>
<span class="n">Error</span><span class="p">:</span><span class="w"> </span><span class="n">The</span><span class="w"> </span><span class="n">type</span><span class="w"> </span><span class="n">of</span><span class="w"> </span><span class="n">this</span><span class="w"> </span><span class="nb">exp</span><span class="n">ression</span><span class="p">,</span><span class="w"></span>
<span class="w">       </span><span class="p">(</span><span class="err">'</span><span class="n">_weak1</span><span class="w"> </span><span class="o">-&gt;</span><span class="w"> </span><span class="err">'</span><span class="n">_weak1</span><span class="p">)</span><span class="w"> </span><span class="o">*</span><span class="w"> </span><span class="err">'</span><span class="n">_weak2</span><span class="w"> </span><span class="n">option</span><span class="w"> </span><span class="n">ref</span><span class="p">,</span><span class="w"></span>
<span class="w">       </span><span class="kr">cont</span><span class="n">ains</span><span class="w"> </span><span class="n">the</span><span class="w"> </span><span class="n">non</span><span class="o">-</span><span class="n">generalizable</span><span class="w"> </span><span class="n">type</span><span class="w"> </span><span class="n">variable</span><span class="p">(</span><span class="n">s</span><span class="p">):</span><span class="w"> </span><span class="err">'</span><span class="n">_weak1</span><span class="p">,</span><span class="w"> </span><span class="err">'</span><span class="n">_weak2</span><span class="mf">.</span><span class="w"></span>
<span class="w">       </span><span class="p">(</span><span class="n">see</span><span class="w"> </span><span class="n">manual</span><span class="w"> </span><span class="n">section</span><span class="w"> </span><span class="mf">6.1.2</span><span class="p">)</span><span class="w"></span>
</pre></div>

<p>Moreover whenever the error happens in a submodule, the error message
now points to the first value with a non-generalizable type:</p>
<div class="highlight"><pre><span></span><span class="k">module</span> <span class="n">M</span> = <span class="n">struct</span> <span class="k">let</span> <span class="nb">x</span> = <span class="n">ref</span> [] <span class="nb">end</span>
</pre></div>

<div class="highlight"><pre><span></span>File &quot;test.ml&quot;, line 1, characters 0-36:
1 | module M = struct let x = ref [] end
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Error: The type of this module, sig val x : '_weak1 list ref end,
       contains non-generalizable type variable(s).
       (see manual section 6.1.2)
File &quot;test.ml&quot;, line 1, characters 22-23:
1 | module M = struct let x = ref [] end
                          ^
  The type of this value, '_weak1 list ref,
  contains the non-generalizable type variable(s) '_weak1.
</pre></div>

<h4><a href="https://github.com/ocaml/ocaml/pull/12125">Better manual reference
in error message</a></h4>
<p>In order to implement the improved error message above, a better way
to cite subsections in the manual was needed. Stefan Muenzel took the
time to improve the manual cross-reference checker tool to handle this
case. The manual cross-reference test checks that references in error
messages and warnings are consistent with the section numbering of the
manual by parsing the latex-generated aux-file. On the OCaml side, the
test only handled chapter and section numbers.</p>
<p>With the change in Stefan&rsquo;s PR, it is now possible to cite uniformly
chapters, sections and subsections (and subsubsections) of the manual in
error messages.</p>
<h3>My pull requests</h3>
<p>Two weeks ago, I finally found the time to propose a small change on
the OCaml AST node for value bindings.</p>
<h4><a href="https://github.com/ocaml/ocaml/pull/12119">Explicit type
constraints in value bindings</a></h4>
<p>Consider the following value binding:</p>
<div class="highlight"><pre><span></span><span class="k">let</span> <span class="n">pat</span> <span class="o">:</span> <span class="n">typ</span> <span class="o">=</span> <span class="n">exp</span>
</pre></div>

<p>Before my change, the type constraint was stored both in the pattern
node and (sometimes) in the expression node with a rather complex
desugaring. This duplication of nodes make handling such constraints in
ppxs more complicated than it ought to be and it introduced some
irregular encoding of type expressions.</p>
<p>With my change, the type constraint is stored directly in the value
binding node, and the elaboration has been moved to the typechecker.
Hopefully, soon we will no longer build parsetree node in the
typechecker. However, in the meanwhile, the parsetree is now closer to
the source language and simpler to transform with ppxs.</p>
<h3>On-going discussions</h3>
<p>In term of medium term projects, I have been discussing two
interesting projects last week.</p>
<h4>Dynlink library</h4>
<p>I have spent some time discussing with S&eacute;bastien Hinderer about his
plans to simplify the build and dependency of OCaml dynlinking library.
Right now, this library is built with its own version of the compiler
library (to avoid module name collision) which introduces a lot of
complexity in the compiler build system. After some discussions with
S&eacute;bastien, we decided to try to isolate a core <code>linking</code>
library that would be shared with both <code>dynlink</code> and the rest
of the compiler library.</p>
<h4>OCamltest DSL</h4>
<p>The ocamltest DSL for the compiler test suite is currently inspired
by org mode as a generic way to write tree of tests. However, with some
more distance, it has become clearer that such representation is not
optimized for most tests in the compiler test suite. In particular,
tests often have very long sequences of actions that are ill-fit the
current representation. We have thus been discussing an improved DSL for
ocamltest for some time, and recently converged towards a new
version.</p>


  

---
title: Bare-bones unit testing in OCaml with dune
description: 'THERE are various techniques and tools to do unit testing in OCaml.
  A small selection:    Alcotest -...'
url: https://dev.to/yawaramin/bare-bones-unit-testing-in-ocaml-with-dune-1lkb
date: 2024-07-01T01:30:17-00:00
preview_image: https://media2.dev.to/dynamic/image/width=1000,height=500,fit=cover,gravity=auto,format=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Ftkq6ahyi34nyyrfj9l2o.png
authors:
- Yawar Amin
source:
ignore:
---

<p>THERE are various techniques and tools to do unit testing in OCaml. A small selection:</p>

<ul>
<li>
<a href="https://github.com/mirage/alcotest/" rel="noopener noreferrer">Alcotest</a> - a colourful unit testing framework</li>
<li>
<a href="https://github.com/gildor478/ounit?tab=readme-ov-file" rel="noopener noreferrer">OUnit2</a> - an xUnit-style test framework</li>
<li>
<a href="https://github.com/janestreet/ppx_expect" rel="noopener noreferrer">ppx_expect</a> - a snapshot testing framework</li>
<li>
<a href="https://dev.to/stroiman/introducing-speed-2ofk">Speed</a>, a new framework announced right here on dev.to, with an emphasis on a fast feedback loop.</li>
</ul>

<p>While these have various benefits, it is undeniable that they all involve using a third-party library to write the tests, learning the various assertion functions and their helpers, and learning how to read and deal with test failure outputs. I have lately been wondering if we can simplify and distill this process to its very essence.</p>

<p>When you run a unit test, you have some expected output, some 'actual' output from the system under test, and then you compare the two. If they are the same, then the test passes, if they are different, the test fails. Ideally, you get the test failure report as an easily readable diff so you can see <em>exactly</em> what went wrong. Of course, this is a simplified view of unit testing–there are tests that require more sophisticated checks–but for many cases, this simple approach is often 'good enough'.</p>

<h2>
  
  
  Enter dune
</h2>

<p>And here is where dune, OCaml's build system, comes in. It turns out that dune ships out of the box with a <a href="https://dune.readthedocs.io/en/stable/concepts/promotion.html" rel="noopener noreferrer">'diff-and-promote'</a> workflow. You can tell it to diff two files, running silently if they have the same content, or failing and printing out a diff if they don't. Then you can run a simple <code>dune promote</code> command to update the 'expected' or 'snapshot' file with the 'actual' content.</p>

<p>Let's look at an example.</p>

<h2>
  
  
  Example project
</h2>

<p>Let's set up a tiny example project to test out this workflow. Here are the files:</p>

<h3>
  
  
  dune-project
</h3>



<div class="highlight js-code-highlight">
<pre class="highlight plaintext"><code>(lang dune 3.0)
</code></pre>

</div>



<p>This file is needed for dune to recognize a project. You can use any supported version of dune here, I just default to 3.0.</p>

<h3>
  
  
  lib/dune
</h3>



<div class="highlight js-code-highlight">
<pre class="highlight plaintext"><code>(library
 (name lib))
</code></pre>

</div>



<p>This declares a dune library inside the project.</p>

<h3>
  
  
  lib/lib.ml
</h3>



<div class="highlight js-code-highlight">
<pre class="highlight ocaml"><code><span class="k">let</span> <span class="n">add</span> <span class="n">x</span> <span class="n">y</span> <span class="o">=</span> <span class="n">x</span> <span class="o">+</span> <span class="n">y</span>
<span class="k">let</span> <span class="n">sub</span> <span class="n">x</span> <span class="n">y</span> <span class="o">=</span> <span class="n">x</span> <span class="o">-</span> <span class="n">y</span>
</code></pre>

</div>



<p>This is the implementation source code of the library. Here we are just setting up two dummy functions that we will 'test' for demonstration purposes. Of course in real-world code there will be more complex functions.</p>

<h3>
  
  
  test/test.expected
</h3>

<p>(This file is initally left empty–will be filled later.)</p>

<h3>
  
  
  test/test.ml
</h3>



<div class="highlight js-code-highlight">
<pre class="highlight ocaml"><code><span class="k">let</span> <span class="n">test</span> <span class="n">msg</span> <span class="n">op</span> <span class="n">x</span> <span class="n">y</span> <span class="o">=</span> <span class="nn">Printf</span><span class="p">.</span><span class="n">printf</span> <span class="s2">"%s: %d</span><span class="se">\n\n</span><span class="s2">"</span> <span class="n">msg</span> <span class="p">(</span><span class="n">op</span> <span class="n">x</span> <span class="n">y</span><span class="p">)</span>

<span class="k">open</span> <span class="nc">Lib</span>

<span class="k">let</span> <span class="bp">()</span> <span class="o">=</span>
  <span class="n">test</span> <span class="s2">"add 1 1"</span> <span class="n">add</span> <span class="mi">1</span> <span class="mi">1</span><span class="p">;</span>
  <span class="n">test</span> <span class="s2">"sub 1 1"</span> <span class="n">sub</span> <span class="mi">1</span> <span class="mi">1</span>
</code></pre>

</div>



<p>This file defines a <code>test</code> helper function whose only job is to just print out a message and then the result of the test, together, to standard output. Then we use the helper repeatedly to test various scenarios. This has the effect that we just print out a bunch of things to standard output.</p>

<h3>
  
  
  test/dune
</h3>



<div class="highlight js-code-highlight">
<pre class="highlight plaintext"><code>(test
 (name test)
 (libraries lib))
</code></pre>

</div>



<p>That's all you need! Dune runs the test mostly on a 'convention-over-configuration' basis.</p>

<ul>
<li>The test component has name <code>test</code>, meaning that dune will build it into an executable <code>test.exe</code>.</li>
<li>The test executable will print some output to standard output, which dune will automatically capture in a file <code>test.exe.output</code>.</li>
<li>Then dune will diff this output against the expected output in <code>test.expected</code>.</li>
</ul>

<p>The file <code>test.expected</code> is meant to be committed into the codebase. It is initially empty, and we will update it as part of our testing workflow.</p>

<p>Notice that dune automatically understands these inputs and outputs and their relation to each other, and will rebuild the test whenever necessary.</p>

<h2>
  
  
  First test
</h2>

<p>Now let's run the initial test:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight plaintext"><code>$ dune test
File "test/test.expected", line 1, characters 0-0:
diff --git a/_build/default/test/test.expected b/_build/default/test/test.exe.output
index e69de29..1522c5b 100644
--- a/_build/default/test/test.expected
+++ b/_build/default/test/test.exe.output
@@ -0,0 +1,4 @@
+add 1 1: 2
+
+sub 1 1: 0
+
</code></pre>

</div>



<h2>
  
  
  Promotion
</h2>

<p>The diff says that the actual output content is not what we 'expected'. Of course, we deliberately started with an empty file here, so let's update the 'expected file' to match the 'actual' one:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight plaintext"><code>$ dune promote
Promoting _build/default/test/test.exe.output to test/test.expected.
</code></pre>

</div>



<h2>
  
  
  Rerun test
</h2>

<p>After the promotion, let's check that the test passes:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight plaintext"><code>$ dune test
$
</code></pre>

</div>



<p>No output, meaning the test succeeded.</p>

<h2>
  
  
  Add tests
</h2>

<p>Let's add a new test:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight ocaml"><code><span class="k">let</span> <span class="bp">()</span> <span class="o">=</span>
  <span class="n">test</span> <span class="s2">"add 1 1"</span> <span class="n">add</span> <span class="mi">1</span> <span class="mi">1</span><span class="p">;</span>
  <span class="n">test</span> <span class="s2">"sub 1 1"</span> <span class="n">sub</span> <span class="mi">1</span> <span class="mi">1</span><span class="p">;</span>
  <span class="n">test</span> <span class="s2">"sub 1 -1"</span> <span class="n">sub</span> <span class="mi">1</span> <span class="o">~-</span><span class="mi">1</span>
</code></pre>

</div>



<p>And run it:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight plaintext"><code>$ dune test
File "test/test.expected", line 1, characters 0-0:
diff --git a/_build/default/test/test.expected b/_build/default/test/test.exe.output
index 1522c5b..17ccf8e 100644
--- a/_build/default/test/test.expected
+++ b/_build/default/test/test.exe.output
@@ -2,3 +2,5 @@ add 1 1: 2

 sub 1 1: 0

+sub 1 -1: 2
+
</code></pre>

</div>



<p>OK, we just need to promote it: <code>dune promote</code>. Then the next <code>dune test</code> succeeds.</p>

<h2>
  
  
  Fix a bug
</h2>

<p>Let's say we introduce a bug into our implementation:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight ocaml"><code><span class="k">let</span> <span class="n">sub</span> <span class="n">x</span> <span class="n">y</span> <span class="o">=</span> <span class="n">x</span> <span class="o">+</span> <span class="n">y</span>
</code></pre>

</div>



<p>Now let's run the tests:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight plaintext"><code>$ dune test
File "test/test.expected", line 1, characters 0-0:
diff --git a/_build/default/test/test.expected b/_build/default/test/test.exe.output
index 17ccf8e..29adb0b 100644
--- a/_build/default/test/test.expected
+++ b/_build/default/test/test.exe.output
@@ -1,6 +1,6 @@
 add 1 1: 2

-sub 1 1: 0
+sub 1 1: 2

-sub 1 -1: 2
+sub 1 -1: 0
</code></pre>

</div>



<p>It gives us a diff of exactly the failing tests. Obviously, in this case we are not going to run <code>dune promote</code>. We need to fix the implementation: <code>let sub x y = x - y</code>, then rerun the test. And we see that after fixing and rerunning, <code>dune test</code> exits silently, meaning the tests are passing again.</p>

<h2>
  
  
  Discussion
</h2>

<p>So...should you actually do this? Let's look at the pros and cons.</p>

<h3>
  
  
  Pros
</h3>

<ol>
<li>No need for a third-party testing library. Dune already does the heavy lifting of running tests and diffing outputs.</li>
<li>No need to learn a set of testing APIs that someone else created. You can just write your own helpers that are custom-made for testing your libraries. All you need to do is make the output understandable and diffable.</li>
<li>Diff-and-promote workflow is really quite good, even with a bare-bones setup like this. Conventional unit test frameworks really struggle to provide diff output as good as this (Jane Street's ppx_expect is an exception which takes a hybrid approach and wants to make the workflow <a href="https://blog.janestreet.com/the-joy-of-expect-tests/" rel="noopener noreferrer">a joyful experience</a>).</li>
<li>You have all expected test results in a single file for easy inspection.</li>
</ol>

<h3>
  
  
  Cons
</h3>

<ol>
<li>It's tied to dune. While dune is today and for the foreseeable future clearly the recommended build system for OCaml, not everyone is using it, and there's no guarantee that the ecosystem will stick to it in perpetuity. It's just highly likely.</li>
<li>You have to define your own output format and helpers. While usually not that big of a deal, it may still need some <a href="https://dev.to/yawaramin/how-to-print-anything-in-ocaml-1hkl">thought and knowledge</a> to define printers for complex custom types.</li>
<li>You can't run only a subset or a single test. You have to run all tests defined in the executable test module. This is not a huge deal if tests usually run fast, but can become problematic when you have slow tests. Of course, many things become problematic when you have slow unit tests.</li>
<li>It doesn't output results in a structured format that can be processed by other tools, eg <code>junit.xml</code> that can be used by CI pipelines to report test failures, or test coverage.</li>
<li>It goes against the 'common wisdom'. People expect unit tests to use conventional-style frameworks, and can be taken aback when they don't.</li>
</ol>

<p>Overall, in my opinion this approach is fine for simple cases. If you have more complex needs, fortunately there are plenty of options for more powerful test frameworks.</p>



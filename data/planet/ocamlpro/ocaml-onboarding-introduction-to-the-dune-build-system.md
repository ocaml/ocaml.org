---
title: 'OCaml Onboarding: Introduction to the Dune build system'
description: Welcome to all Camleers We are back with another practical walkthrough
  for the newcomers of the OCaml ecosystem. We understand from the feedback we have
  gathered over the years that getting started with the OCaml Distribution can sometimes
  be perceived as challenging at first. That's why we keep it ...
url: https://ocamlpro.com/blog/2025_07_29_ocaml_onboarding_introduction_to_dune
date: 2025-07-29T09:41:44-00:00
preview_image: https://ocamlpro.com/blog/assets/img/ai_construction_camel.png
authors:
- "\n    Raja Boujbel\n  "
source:
ignore:
---

<p></p>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/ai_construction_camel.png">
      <img src="https://ocamlpro.com/blog/assets/img/ai_construction_camel.png" alt="A camel sitting atop a dune in the middle of the desert. He wears his hard hat as he takes a break from all the building and running of OCaml code. Want to start building your own? Follow the tracks below.">
    </a>
    </p><div class="caption">
      A camel sitting atop a dune in the middle of the desert. He wears his hard hat as he takes a break from all the building and running of OCaml code. Want to start building your own? Follow the tracks below.
    </div>
  <p></p>
</div>
<p></p>
<h4>Welcome to all Camleers</h4>
<p>We are back with another practical walkthrough for the newcomers of the OCaml
ecosystem. We understand from the feedback we have gathered over the years that
getting started with the OCaml Distribution can sometimes be perceived as
challenging at first. That's why we keep it in mind when planning each post -
to make your onboarding smoother and more approachable.</p>
<p>Case in point: today's topic, which came to us during the making of our latest
<code>opam deep-dive</code>: <em><a href="https://ocamlpro.com/blog/2025_04_29_opam_103_starting_new_project/">Opam 103: Bootstrapping a New OCaml Project with
opam</a></em>.</p>
<p>It occured to us that we were assuming a level of familiarity with the
toolchain that we had never explicitly explained or clarified. We decided to
put together a short, practical guide for the newer developers, looking for
quick, on-the-fly tutorials for OCaml. 🛠️</p>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#basics" class="anchor-link">A Camleer's basics: Dune</a>
          </h3>
<p>If you're new to OCaml, or any other programming language for that matter, the
first necessities you'll encounter are <strong>building</strong>, <strong>running</strong>, and
<strong>testing</strong> your code. Fortunately, there is a powerful build system called
<code>dune</code> that we can use. It is widespread and makes project setup and
compilation straightforward. Understanding how <code>dune</code> works is a key step
towards becoming productive in the OCaml ecosystem.</p>
<p>In this article, we’ll walk you through the essentials of using <code>dune</code> to
<strong>build libraries</strong>, <strong>executables</strong>, and <strong>tests</strong>, and to manage your
<strong>project structure</strong>. Whether you're writing your first OCaml program or
stepping into a new dune-based codebase, this guide will help you get up and
running quickly.</p>
<blockquote>
<p>We strongly believe that <strong>starting from scratch is key when approaching a
brand new technical topic</strong> — and today's topic is no exception. Anyone who
has ever felt lost exploring a new codebase knows that minimal, toy examples
are often the best way to build intuition.</p>
</blockquote>
<p></p><div>
<strong>Table of contents</strong><p></p>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#basics">A Camleer's basics: Dune</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#ressources">Ressources</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#setupyourproject">Project metadata and build specification files</a>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#duneproject">dune-project</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#dunefile">dune file</a>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#keystanzas">Key stanzas</a>
</li>
</ul>
</li>
</ul>
</li>
<li><a href="https://ocamlpro.com/blog/feed#buildyourproject">Build and run your project</a>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#dunebuild">dune build</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#dunebuilddoc">dune build @doc</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#duneexec">dune exec --</a>
</li>
</ul>
</li>
<li><a href="https://ocamlpro.com/blog/feed#testyourproject">Test your project with Dune</a>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#dunecramtests">Cram tests</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#duneruntest">dune runtest</a>
</li>
</ul>
</li>
<li><a href="https://ocamlpro.com/blog/feed#duneinit">Scaffolding with dune init</a>
</li></ul></div>


<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#ressources" class="anchor-link">Ressources</a>
          </h3>
<p>As said previously, this article was written in the context of the latest
<em><a href="https://ocamlpro.com/blog/2025_04_29_opam_103_starting_new_project/">Opam 103: Bootstrapping a New OCaml Project with
opam</a></em>.
That article explained how an OCaml developer should go about structuring an
OCaml project when they intend to use it with <code>opam</code>.</p>
<p>The point of today's topic is to focus on the other defining parameter of the
structure of an OCaml project: your build system. The goal is to show how
the workflows of <code>opam</code> and <code>dune</code> fit together, while giving you a solid
introduction to the fundamentals of dune.</p>
<p>We're using <a href="https://gitlab.ocamlpro.com/raja/opam_bps_examples/-/tree/dune-minimal/opam-103">the same toy
project</a>
<code>helloer</code> as basis for this rundown. It's a simple, well-scoped example with a
structure that's idiomatic to both opam and dune, making it a great fit for
illustrating the fundamentals without unnecessary complexity.</p>
<p>Note that <code>helloer</code> was not created using <code>dune init</code> that we will introduce at
the end of this article. First, it's important to understand how Dune works
under the hood - so you know what it's generating for you, how to modify it
confidently, and how it fits into your overall build workflow.</p>
<blockquote>
<p>Consider checking <strong><a href="https://dune.readthedocs.io/en/latest/reference/index.html">Dune's official reference
manual</a></strong> or
visiting the <strong><a href="https://discuss.ocaml.org/">official OCaml Discuss</a></strong> forum
to reach out to the OCaml Community.</p>
</blockquote>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#setupyourproject" class="anchor-link">Project metadata and build specification files</a>
          </h3>
<h4>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#duneproject" class="anchor-link">dune-project</a>
          </h4>
<p>Let's first start with the <code>dune-project</code> file since every Dune-driven
project should have one at its root.</p>
<p>This file is the <strong>entry point</strong> for your project and its contents are its
metadata — which Dune uses to understand how your project is structured.</p>
<p>Said metadata includes things like:</p>
<ul>
<li>the version of <code>dune</code> you're using;
</li>
<li>important URLs for your projects lifecycles;
</li>
<li>optional settings like dependencies licensing, documentation;
</li>
<li>and even configuration for automatic opam file generation.
<strong>More on that in <a href="https://ocamlpro.com/blog/2025_04_29_opam_103_starting_new_project">Opam
103</a></strong>.
</li>
</ul>
<p>This information not only guides Dune, but also helps tools like opam
understand how to build, distribute, and document your project.</p>
<pre><code class="language-shell-session">$ cat dune-project
(lang dune 3.15)
(package (name helloer))

(cram enable)
</code></pre>
<p>Note: The first line must be <code>(lang dune X.Y)</code> - with no comments or extra
whitespace. This line determines which features and syntax dune will recognize.</p>
<blockquote>
<p><strong>NB</strong>: You will find all complementary information <a href="https://dune.readthedocs.io/en/latest/reference/dune-project/index.html"><strong>in the official
docs</strong></a>
👈.</p>
</blockquote>
<h4>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#dunefile" class="anchor-link">dune file</a>
          </h4>
<p>A <code>dune</code> file is a <strong>build specification</strong> file that tells Dune how to compile
the OCaml code within a specific directory.</p>
<p>Usually there's one <code>dune</code> file per subdirectory, with the description of
what's there - library, executable, or some tests. Since our toy <code>helloer</code>
project is flat in structure, we’ll place this file <a href="https://gitlab.ocamlpro.com/raja/opam_bps_examples/-/tree/dune-minimal/opam-103">at the root of the
project</a>.</p>
<pre><code class="language-shell-session">$ cat dune
(library
 (name helloer_lib)
 (modules helloer_lib)
)

(executable
 (public_name helloer)
 (name helloer)
 (libraries cmdliner helloer_lib)
 (modules helloer)
)

(test
 (name test)
 (libraries alcotest helloer_lib)
 (modules test)
)
</code></pre>
<p><strong>In effect, this tells <code>dune</code>:</strong></p>
<ul>
<li>how to build the OCaml files in that directory;
</li>
<li>how <strong>libraries</strong>, <strong>executables</strong>, and <strong>test targets</strong> are defined.
</li>
</ul>
<h4>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#keystanzas" class="anchor-link">Key stanzas</a>
          </h4>
<p>In the context of Dune, a
<strong><a href="https://dune.readthedocs.io/en/stable/overview.html#term-stanza">stanza</a></strong>
is just a fancy word for a <strong>block of configuration</strong>. It tells the build
system what kind of artifact you want to define — be it a library, an
executable, a test, a documentation alias, or even an installable binary. Each
stanza lives inside a <code>dune</code> file and follows a structured, declarative syntax.</p>
<p>They’re usually grouped by purpose, and each type comes with its own expected
fields. Each of these stanzas deserves a deeper dive, but here's a quick overview to
get you started.</p>
<h5>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#librarystanza" class="anchor-link"><code>library</code> stanza</a>
          </h5>
<pre><code class="language-lisp">(library
 (name helloer_lib)
 (modules helloer_lib)
)
</code></pre>
<blockquote>
<p>A <code>library</code> stanza tells Dune how to compile a set of modules into a
reusable package.</p>
</blockquote>
<p><strong>Purpose of this stanza</strong>:</p>
<ul>
<li>defines a library named <code>helloer_lib</code>;
</li>
<li>which will be built from the module <code>helloer_lib.ml</code> (by default, each .ml
file defines a module with the same name);
</li>
<li>and only the exposed modules should be listed here - that is, the modules
that are meant to be part of the library's public API and usable by other
parts of the project or by external code.
</li>
</ul>
<p>OCaml module names should match the filename, so <code>helloer_lib.ml</code> is expected
to exist in this directory.</p>
<h5>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#executablestanza" class="anchor-link"><code>executable</code> stanza</a>
          </h5>
<pre><code class="language-dune">(executable
 (public_name helloer)
 (name helloer)
 (libraries cmdliner helloer_lib)
 (modules helloer)
)
</code></pre>
<blockquote>
<p>An <code>executable</code> stanza explains how to bundle up some code into a runnable
binary.</p>
</blockquote>
<p><strong>Purposes</strong>:</p>
<ul>
<li><code>name</code>: builds an executable named <code>helloer</code>;
</li>
<li>needs libraries: <strong>external</strong> <code>cmdliner</code> (for CLI parsing) and <strong>internal</strong> <code>helloer_lib</code> (our own library);
</li>
<li><code>public_name helloer</code>: this makes the executable available publicly. It is
used for <code>dune install helloer</code> in the <code>opam</code> file for instance.
</li>
</ul>
<blockquote>
<p>You can learn about how to find and install <code>cmdliner</code> in <code>opam</code> <a href="https://ocamlpro.com/blog/2025_04_29_opam_103_starting_new_project/#clitooling">in the
latest Opam 103
blogpost</a>,
you'll find <a href="https://ocamlpro.com/blog/2025_04_29_opam_103_starting_new_project/#minimalopamfile">a simple
breakdown</a>
of <code>opam</code> files there too .</p>
</blockquote>
<h5>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#teststanza" class="anchor-link"><code>test</code> stanza</a>
          </h5>
<pre><code class="language-dune">(test
 (name test)
 (libraries alcotest helloer_lib)
 (modules test)
)
</code></pre>
<p><strong>What it does</strong>:</p>
<ul>
<li>declares a test target named <code>test</code>, defined in the file <code>test.ml</code>. A <code>test</code>
stanza registers the executable as part of the <code>runtest</code> rule alias, meaning
it will be compiled and run automatically when you invoke <code>dune runtest</code> (or
its alias <code>dune test</code>);
</li>
<li>uses the <code>alcotest</code> testing library;
</li>
<li>also uses <code>helloer_lib</code> to test its functionality.
</li>
</ul>
<hr>
<p><strong>Now your project is setup and structured. Next, let’s see how to build it.</strong></p>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#buildyourproject" class="anchor-link">Build and run your project</a>
          </h3>
<h4>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#dunebuild" class="anchor-link"><code>dune build</code></a>
          </h4>
<p>As you can see below, the <code>dune build @all</code> command will build <strong>all</strong> targets
defined in your <code>dune</code> files, it's the default behaviour of the <code>dune build</code>
command.</p>
<pre><code class="language-shell-session">$ tree
.
├── dune
├── dune-project
├── helloer_lib.ml
├── helloer.ml
├── helloer.opam
└── test.ml
$ dune build @all

$ tree -L 2
.
├── _build
│&nbsp;&nbsp; ├── default
│&nbsp;&nbsp; │&nbsp;&nbsp; ├── helloer.exe      // executable in its build dir
│&nbsp;&nbsp; │&nbsp;&nbsp; ├── helloer_lib.cmxs // built library
│&nbsp;&nbsp; │&nbsp;&nbsp; ├── test.exe         // test executable
│&nbsp;&nbsp; │&nbsp;&nbsp; └── [...]
│&nbsp;&nbsp; ├── install
│&nbsp;&nbsp; └── log
├── dune
├── dune-project
├── helloer_lib.ml
├── helloer.ml
├── helloer.opam
└── test.ml
</code></pre>
<p><strong>Explanation</strong>:</p>
<ul>
<li><code>@all</code> is an alias that includes all buildable targets defined in your dune
files: executables, libraries, tests, docs, etc;
</li>
<li>it is useful for doing a full build to ensure everything compiles.
</li>
</ul>
<p>You can also use custom aliases (like <code>@doc</code>, <code>@runtest</code>, etc.), or
define your own in your dune files.</p>
<h4>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#dunebuilddoc" class="anchor-link"><code>dune build @doc</code></a>
          </h4>
<p>Once your code builds and your project has a proper <code>dune-project</code> file, you
can generate documentation using:</p>
<pre><code class="language-shell-session">$ dune build @doc
</code></pre>
<p><strong>What it does</strong>:</p>
<ul>
<li>uses <code>odoc</code> behind the scenes to build API docs from your OCaml code. This
implies that installing <code>odoc</code> is mandatory to benefit from this feature, a
simple <code>opam install odoc</code> will do just fine;
</li>
<li>builds HTML files in <code>_build/default/_doc/_html/</code>.
</li>
</ul>
<p>Make sure your <code>dune-project</code> file includes a <code>(package ...)</code> stanza, and that
your libraries are properly documented using OCaml comments <code>(** your comment *)</code>.</p>
<p>You can see generate the doc for the toy project
<a href="https://github.com/OCamlPro/opam_bp_examples/commit/5ec8dd28115f72df44fd9f1b4de4379d2bf54d5f">here</a></p>
<blockquote>
<p><strong>NB</strong>: You will find all complementary information <a href="https://ocaml.github.io/odoc/odoc/odoc_for_authors.html"><strong>in the official
docs</strong></a> 👈.</p>
</blockquote>
<p>After building, you can view the generated docs:</p>
<pre><code class="language-shell-session">$ open _build/default/_doc/_html/index.html
</code></pre>
<p><strong>This is great for checking your module interfaces or publishing documentation
online.</strong></p>
<h4>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#duneexec" class="anchor-link"><code>dune exec --</code></a>
          </h4>
<p>This command is used to <strong>run executables</strong> defined in your project.</p>
<p><strong>So, something like</strong>:</p>
<pre><code class="language-shell-session">$ dune exec -- ./helloer.exe
Hello OCamlers!!                   
$ dune exec -- ./helloer.exe --gentle
Welcome my dear OCamlers.          
</code></pre>
<p>This tells dune to build the executable if necessary, then run it. The <code>--</code>
separates the dune options from the executable and its arguments. The first
item after <code>--</code> is the executable to run</p>
<p>This can be:</p>
<ul>
<li>A relative path to a built target, so: <code>dune exec -- ./path/to/executable</code>
</li>
<li>A public name of an installed executable, meaning: <code>dune exec -- ./helloer</code>.
</li>
</ul>
<p>All additional arguments after the executable name (like <code>--gentle</code>) are passed
to the executable itself.</p>
<p>Essentially, <code>dune exec -- COMMAND</code> behaves the same way as calling <code>dune install</code> first and <strong>then</strong> <code>COMMAND</code> sequentially.</p>
<blockquote>
<p><strong>NB</strong>: If you'd like to copy the executable to your project root (outside
<code>_build/</code>), you can add <code>(promote (until-clean))</code> to your executable stanza.</p>
</blockquote>
<hr>
<p><strong>Great, our little project builds and runs smoothly, now onto testing it.</strong></p>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#testyourproject" class="anchor-link">Test your project with Dune</a>
          </h3>
<p>In our <code>helloer</code> project, we use the <code>alcotest</code> library on our internal
<code>helloer_lib</code>. This is quite standard. However testing the executable itself
can be done <strong>without</strong> depending on an external tool with the help of <strong>cram
tests</strong>.</p>
<h4>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#dunecramtests" class="anchor-link">Cram tests</a>
          </h4>
<p>Dune supports a special kind of test called a cram test, inspired by the
original <a href="https://bitheap.org/cram/">Cram</a>, which checks that command-line
examples produce the expected output.</p>
<p>The <em>"expected output"</em> is the shell-session itself and whatever your
executable prints, during its test run for that specific call, is checked
against it.</p>
<p>To create a cram test, you just write a <code>.t</code> file that contains a succession of
shell-like sessions separated by empty newlines like so:</p>
<pre><code class="language-shell-session">$ helloer
Hello OCamlers!!

$ helloer --gentle
Welcome my dear OCamlers.
</code></pre>
<p><strong>How it works</strong>:</p>
<ul>
<li>it runs the commands in <code>.t</code> files;
</li>
<li>it compares what is printed to <code>stdout</code> by our binary to the expected output
written in the cram file;
</li>
<li>fails if the outputs differ. However, you can use <code>dune promote</code> whenever you
wish to replace all the failed tests with the new output, which will most
often happen when you make changes to your binary's printing to <code>stdout</code>.
</li>
</ul>
<p>You can test it <a href="https://github.com/OCamlPro/opam_bp_examples/commit/8415437d2a3d13c890af4eb7406f0803a185d6a6">here</a>.</p>
<h4>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#duneruntest" class="anchor-link"><code>dune runtest</code></a>
          </h4>
<p>You can run all your tests using:</p>
<pre><code class="language-shell-session">$ dune runtest
</code></pre>
<ul>
<li>it builds <code>test</code> targets defined in your project;
</li>
<li>it looks for files ending in <code>.t</code> or <code>.ml</code> files marked as tests;
</li>
<li>it executes the tests, often using <em>expect</em> style testing (like <code>ppx_expect</code> or <code>alcotest</code>).
</li>
</ul>
<p>It's quite straightforward: if you have an <code>inline_tests</code> stanza or an
<code>expect</code> test, it will run them and tell you if anything failed.</p>
<p>For example, a valid cram test will output something like:</p>
<pre><code class="language-shell-session">$ dune runtest
Testing `Tests'.                 
This run has ID `N39NJ5ZE'.

  [OK]          messages          0   normal.
  [OK]          messages          1   gentle.

Full test results in `~/ocamler/dev/helloer/_build/default/_build/_tests/Tests'.
Test Successful in 0.000s. 2 tests run.
</code></pre>
<p>However, if one of these tests were to fail, you would see something like:</p>
<pre><code class="language-shell-session">$ dune runtest
File "test.t", line 1, characters 0-0:
diff --git a/_build/.sandbox/e6d6dcfb864b62e42104889af2a44f23/default/test.t b/_build/.sandbox/e6d6dcfb864b62e42104889af2a44f23/default/test.t.corrected
index f79b63c..70c7a17 100644
--- a/_build/.sandbox/e6d6dcfb864b62e42104889af2a44f23/default/test.t
+++ b/_build/.sandbox/e6d6dcfb864b62e42104889af2a44f23/default/test.t.corrected
@@ -3,7 +3,7 @@ Default behaviour
   Hello OCamlers!!
 Gentle behaviour
   $ helloer --gentle
-  Welcome my deer OCamlers.
+  Welcome my dear OCamlers.
 Unknown behaviour
   $ helloer --unknown
   helloer: unknown option '--unknown'.
File "dune", line 16, characters 7-11:       
16 |  (name test)
            ^^^^
Testing `Tests'.
This run has ID `1OS0H3WP'.

  [OK]          messages          0   normal.
&gt; [FAIL]        messages          1   gentle.

┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ [FAIL]        messages          1   gentle.                                                                                              │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
ASSERT same string
FAIL same string

   Expected: `"Welcome my deer OCamlers."'
   Received: `"Welcome my dear OCamlers."'

Raised at Alcotest_engine__Test.check in file "src/alcotest-engine/test.ml", lines 216-226, characters 4-19
Called from Alcotest_engine__Core.Make.protect_test.(fun) in file "src/alcotest-engine/core.ml", line 186, characters 17-23
Called from Alcotest_engine__Monad.Identity.catch in file "src/alcotest-engine/monad.ml", line 24, characters 31-35

Logs saved to `~/ocamler/dev/helloer/_build/default/_build/_tests/Tests/messages.001.output'.
 ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Full test results in `~/ocamler/dev/helloer/_build/default/_build/_tests/Tests'.
1 failure! in 0.000s. 2 tests run.
</code></pre>
<hr>
<p><strong>At this point in the development process, we can assume that you know how to
use the most basic <code>dune</code> command-lines to make your OCaml projects a
reality!</strong></p>
<p>Now that we’ve explored how Dune works at a foundational level — writing
stanzas by hand, managing libraries and executables, building, running, testing
— you’re probably starting to see patterns. These project ingredients don’t
change much from one small OCaml project to the next. That’s exactly where <code>dune init</code> comes in.</p>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#duneinit" class="anchor-link">Scaffolding with dune init</a>
          </h3>
<p><code>dune init</code> is the starting point for creating a new OCaml project using Dune.
It scaffolds a working directory structure and sets up the essential files
you’ll need.</p>
<p>Rather than writing every file from scratch, Dune offers a command-line
scaffolding tool that sets up a complete, minimal project for you — so you can
jump straight to writing code with a solid structure already in place.</p>
<p>This means the following command is all you need to scaffold a basic project:</p>
<pre><code class="language-shell-session">$ dune init project helloer
</code></pre>
<p><strong>What it does:</strong></p>
<ul>
<li>creates a new directory <code>helloer</code> with a working OCaml project inside;
</li>
<li>sets up the dune-project file;
</li>
<li>adds sample source files and their associated dune build files.
</li>
</ul>
<p>The structure you'll get looks like this:</p>
<pre><code class="language-tree">$ tree
helloer/
├── bin/
│   ├── dune
│   └── main.ml
├── dune-project
├── lib
│&nbsp;&nbsp; ├── dune
├── test
│    ├── dune
│    ├── test_helloer.ml
└── [...]
</code></pre>
<p>From here, you can build on this template by adding libraries, tests, and more.</p>
<blockquote>
<p>If your project is only a library or binary, you can use the other project
template with <code>dune init lib helloer</code> or <code>dune init exec helloer</code>.</p>
</blockquote>
<p>Sharp-eyed readers may notice differences between our toy project and the
layout generated by <code>dune init</code>.</p>
<p>You can see the end result in this
<a href="https://gitlab.ocamlpro.com/raja/opam_bps_examples/-/tree/dune-init-minimal">branch</a>.</p>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#conclusion" class="anchor-link">Conclusion</a>
          </h3>
<p>Indeed, you should be comfortable with the basic building blocks of a
<code>dune</code>-based OCaml project: from initializing it, defining libraries and
executables, to running it and writing tests, and even generating
documentation. <code>dune</code> takes care of a lot of the heavy lifting, letting you
focus on writing code rather than fiddling with build scripts. As you grow more
confident with OCaml and Dune, you’ll discover even more powerful features—but
for now, you’re well-equipped to start building real-world OCaml applications.</p>


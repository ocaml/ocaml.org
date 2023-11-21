---
title: OPAM 1.2 and Travis CI
description: 'The new pinning feature of OPAM 1.2 enables new interesting workflows
  for your day-to-day development in OCaml projects. I will briefly describe one of
  them here: simplifying continuous testing with Travis CI and GitHub. Creating an
  opam file As explained in the previous post, adding an opam file at...'
url: https://ocamlpro.com/blog/2014_12_18_opam_1.2_and_travis_ci
date: 2014-12-18T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Thomas Gazagnaire\n  "
source:
---

<p>The <a href="https://opam.ocaml.org/blog/opam-1-2-pin/">new pinning feature</a> of OPAM 1.2 enables new interesting
workflows for your day-to-day development in OCaml projects. I will
briefly describe one of them here: simplifying continuous testing with
<a href="https://travis-ci.org/">Travis CI</a> and
<a href="https://github.com/">GitHub</a>.</p>
<h2>Creating an <code>opam</code> file</h2>
<p>As explained in the <a href="https://opam.ocaml.org/blog/opam-1-2-pin/">previous post</a>, adding an <code>opam</code> file at the
root of your project now lets you pin development versions of your
project directly. It's very easy to create a default template with OPAM 1.2:</p>
<pre><code class="language-shell-session">$ opam pin add &lt;my-project-name&gt; . --edit
[... follow the instructions ...]
</code></pre>
<p>That command should create a fresh <code>opam</code> file; if not, you might
need to fix the warnings in the file by re-running the command. Once
the file is created, you can edit it directly and use <code>opam lint</code> to
check that is is well-formed.</p>
<p>If you want to run tests, you can also mark test-only dependencies with the
<code>{test}</code> constraint, and add a <code>build-test</code> field. For instance, if you use
<code>oasis</code> and <code>ounit</code>, you can use something like:</p>
<pre><code class="language-shell-session">build: [
  [&quot;./configure&quot; &quot;--prefix=%{prefix}%&quot; &quot;--%{ounit:enable}%-tests&quot;]
  [make]
]
build-test: [make &quot;test&quot;]
depends: [
  ...
  &quot;ounit&quot; {test}
  ...
]
</code></pre>
<p>Without the <code>build-test</code> field, the continuous integration scripts
will just test the compilation of your project for various OCaml
compilers.
OPAM doesn't run tests by default, but you can make it do so by
using <code>opam install -t</code> or setting the <code>OPAMBUILDTEST</code>
environment variable in your local setup.</p>
<h2>Installing the Travis CI scripts</h2>
<p><a href="https://travis-ci.org/">Travis CI</a> is a free service that enables continuous testing on your
GitHub projects. It uses Ubuntu containers and runs the tests for at most 50
minutes per test run.</p>
<p>To use Travis CI with your OCaml project, you can follow the instructions on
<a href="https://github.com/ocaml/ocaml-travisci-skeleton">https://github.com/ocaml/ocaml-travisci-skeleton</a>. Basically, this involves:</p>
<ul>
<li>adding
<a href="https://github.com/ocaml/ocaml-travisci-skeleton/blob/master/.travis.yml">.travis.yml</a>
at the root of your project. You can tweak this file to test your
project with different versions of OCaml. By default, it will use
the latest stable version (today: 4.02.1, but it will be updated for
each new compiler release).  For every OCaml version that you want to
test (supported values for <code>&lt;VERSION&gt;</code> are <code>3.12</code>, <code>4.00</code>,
<code>4.01</code> and <code>4.02</code>) add the line:
</li>
</ul>
<pre><code class="language-shell-session">env:
 - OCAML_VERSION=&lt;VERSION&gt;
</code></pre>
<ul>
<li>signing in at <a href="https://travis-ci.org/">TravisCI</a> using your GitHub account and
enabling the tests for your project (click on the <code>+</code> button on the
left pane).
</li>
</ul>
<p>And that's it, your project now has continuous integration, using the OPAM 1.2
pinning feature and Travis CI scripts.</p>
<h2>Testing Optional Dependencies</h2>
<p>By default, the script will not try to install the <a href="https://opam.ocaml.org/doc/manual/dev-manual.html#sec9">optional
dependencies</a> specified in your <code>opam</code> file. To do so, you
need to manually specify which combination of optional dependencies
you want to tests using the <code>DEPOPTS</code> environment variable. For
instance, to test <code>cohttp</code> first with <code>lwt</code>, then with <code>async</code> and
finally with both <code>lwt</code> and <code>async</code> (but only on the <code>4.01</code> compiler)
you should write:</p>
<pre><code class="language-shell-session">env:
   - OCAML_VERSION=latest DEPOPTS=lwt
   - OCAML_VERSION=latest DEPOPTS=async
   - OCAML_VERSION=4.01   DEPOPTS=&quot;lwt async&quot;
</code></pre>
<p>As usual, your contributions and feedback on this new feature are <a href="https://github.com/ocaml/ocaml-travisci-skeleton/issues/">gladly welcome</a>.</p>


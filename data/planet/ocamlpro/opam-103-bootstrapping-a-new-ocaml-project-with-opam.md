---
title: 'Opam 103: Bootstrapping a New OCaml Project with opam'
description: 'Curious about the origins of opam?

  Check out this short history on its evolution as the de facto package manager and
  environment manager for OCaml. Welcome back to the opam deep-dives series! Finally
  - you''ve asked for it since our very first opam deep-dive: it''s time to explore
  the developer side o...'
url: https://ocamlpro.com/blog/2025_04_29_opam_103_starting_new_project
date: 2025-04-19T15:35:40-00:00
preview_image: https://ocamlpro.com/blog/assets/img/draw_camel_opam_bp.png
authors:
- "\n    Raja Boujbel\n  "
source:
ignore:
---

<p></p>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/draw_camel_opam_bp.png">
      <img src="https://ocamlpro.com/blog/assets/img/draw_camel_opam_bp.png" alt="A young camel is ready to leave on its first journey through the desert, he is well-prepared and has the perfect tools at his disposal!">
    </a>
    </p><div class="caption">
      A young camel is ready to leave on its first journey through the desert, he is well-prepared and has the perfect tools at his disposal!
    </div>
  <p></p>
</div>
<p></p>
<blockquote>
<p><strong>Curious about the origins of opam?</strong></p>
<p>Check out this <a href="https://opam.ocaml.org/about.html#A-little-bit-of-History">short
history</a> on its
evolution as the de facto package manager and environment manager for OCaml.</p>
</blockquote>
<h3>Welcome back to the <code>opam deep-dives</code> series!</h3>
<p>Finally - you've asked for it since our very first <code>opam deep-dive</code>: it's time to
explore the developer side of the <code>opam</code> experience.</p>
<p>So far, we have focused on user-facing scenarios to provide a gentle
introduction. Now, we are shifting gears into project creation and development
workflows.</p>
<p>Thank you for your patience - the wait was worth it! Today, we will guide you
through starting a new <strong>OCaml project with a full opam-integrated workflow.</strong>
🚀</p>
<p>This guide is especially geared toward newer OCaml developers who want to
master opam when setting up and managing a project. 😇</p>
<p></p><div>
<strong>Table of contents</strong><p></p>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#requisites">Prerequisites &amp; Context</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#setupenv">Setting up the environment</a>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#localswitch">Creating a new local switch</a>
</li>
</ul>
</li>
<li><a href="https://ocamlpro.com/blog/feed#gettingstarted">Getting started</a>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#necessarytools">Looking for the necessary tools</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#buildsystem">Build System</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#clitooling">Command-line libraries</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#testlibraries">Use test libraries</a>
</li>
</ul>
</li>
<li><a href="https://ocamlpro.com/blog/feed#firstopamfile">Your first opam file</a>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#minimalopamfile">A minimal functional opam file</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#opamlint">A real-world opam file</a>
</li>
</ul>
</li>
<li><a href="https://ocamlpro.com/blog/feed#conclusion">Conclusion</a>
</li></ul></div>


<blockquote>
<p>If you haven't yet, we recommend starting with <strong><a href="https://ocamlpro.com/blog/2024_01_23_opam_101_the_first_steps/">Opam 101: The First
steps</a></strong> to
get comfortable with installation and usage basics and <strong><a href="https://ocamlpro.com/blog/2024_03_25_opam_102_pinning_packages/">Opam 102: Pinning
Packages</a>,</strong>
which already dives quite deep into package pinning, one of the first keys to
tailoring your workflow and environment to your exact needs.</p>
<p>Also, check out the <code>tags</code> of each article to get an idea of the entry level
required for the smoothest read possible!</p>
</blockquote>
<hr>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#requisites" class="anchor-link">Prerequisites &amp; Context</a>
          </h2>
<p>Our goal across <strong>this post and the next one</strong> is to guide you through the full
life cycle of an OCaml project - from creating a directory on your machine to
publishing your package to the <a href="https://github.com/ocaml/opam-repository">official
opam-repository</a>.</p>
<p>We will walk through each step of the journey, highlighting not just how to do
things, but also why they matter in a pragmatic, real-world <code>opam</code> workflow.
You’ll see how to:</p>
<ul>
<li>Create and manage local switches
</li>
<li>Select and install packages
</li>
<li>Prepare your project for distribution
</li>
</ul>
<p>This post assumes you've read <a href="https://ocamlpro.com/blog/2024_01_23_opam_101_the_first_steps">Opam 101: The First
Step</a> -
especially the section on
<a href="https://ocamlpro.com/blog/2024_01_23_opam_101_the_first_steps/#switch">switches</a>.</p>
<p>Nevertheless, here's a quick TL;DR for those of you who would rather get
started:</p>
<blockquote>
<p>What is an <code>opam</code> <strong>switch</strong>?</p>
<p>An opam switch is a development environment in the OCaml world. <code>Opam</code>
provides you with a command-line interface for you to customise, and maintain
a safe and stable environment. It's defined by all the possible combinations
and valid operations between <strong>a specific version of the OCaml compiler</strong>,
and <strong>any set of versioned packages</strong>.</p>
<p>Functionally, it is a set of environment variables that are user-updated and
point to the different locations of installed versions of packages, binaries
and other utilities either in a <code>~/.opam</code> directory for <code>global</code> switches or
in the current <code>_opam</code> directory for <code>local</code> ones.</p>
<p><a href="https://opam.ocaml.org/doc/Usage.html#opam-switch"><strong>👉 More in the official
docs</strong></a>.</p>
</blockquote>
<p>In this tutorial, we'll use <code>local</code> switches, which are especially well-suited
for project-based workflows like the one we are building today. Furthermore,
know that this article uses <code>opam 2.1.5</code>!</p>
<p><strong>Ready? Let's dive in!</strong></p>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#setupenv" class="anchor-link">Setting up the environment</a>
          </h2>
<p>Before publishing an OCaml package, you have to develop it - and that means
setting up your environment.</p>
<p>This encompasses everything from creating the working directory of your new
project, to setting up a custom, local switch for it.</p>
<p>We will consider that you have created a new directory for your project and
have since moved <strong>into</strong> it in order to progress further in the setup process.</p>
<p><strong>Something like:</strong></p>
<pre><code class="language-shell-session">$ mkdir helloer
$ cd helloer
</code></pre>
<p>Here are the things that <code>opam</code> will help you accomplish at this stage of the
development process:</p>
<ul>
<li>Setting up a new switch (i.e, <strong>environment creation</strong>);
</li>
<li>Explore packages (libraries / tooling) available in the OCaml ecosystem (i.e,
<strong>technical exploration</strong>);
</li>
<li>Selection and installation of OCaml software inside a switch (i.e,
<strong>environment setup and tailoring</strong>);
</li>
</ul>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#localswitch" class="anchor-link">Creating a new local switch</a>
          </h3>
<p>A switch is the isolated environment in which <code>opam</code> will operate and assist
you in taking all the necessary steps towards an optimal workflow.</p>
<p>It defines a <strong>specific OCaml compiler version</strong> and a <strong>set of compatible packages</strong>,
allowing you to safely build and manage your project.O</p>
<p>So let's first create a local switch in our <code>helloer</code> directory.</p>
<pre><code class="language-shell-session">$ opam switch create .

&lt;&gt;&lt;&gt; Installing new switch packages &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
Switch invariant: ["ocaml" {&gt;= "4.05.0"}]
</code></pre>
<p>We let <code>opam</code> select the default <code>switch invariant</code> when creating a new switch
which is OCaml compiler version <code>&gt;= 4.05.0</code>. You can define any set of switch
invariants that you wish.</p>
<blockquote>
<p>In the call above, the <code>.</code> character indicates that we are asking <code>opam</code> to
create a switch <strong>inside</strong> the current directory, a <strong>local</strong> one. This
differs from a <strong>global</strong> switch, which lives in your <code>~/.opam/</code> folder.</p>
</blockquote>
<p><strong>What's a “switch invariant”?</strong></p>
<p>The idea of <code>switch invariants</code> is quite simple, they are the
parameters of the automatic solving of package dependency trees. More
specifically, this switch invariant defines the OCaml version your environment
relies on. Invariants are immutable. <code>opam</code> will never change invariants
without notifying you first and will always consider the <code>switch invariant</code> constraint
when building the graph of available/compatible packages for your current
switch, or for any other switch-altering operation for that matter.</p>
<p>So, back to our example:</p>
<pre><code class="language-shell-session">$ opam switch create .

&lt;&gt;&lt;&gt; Installing new switch packages &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
Switch invariant: ["ocaml" {&gt;= "4.05.0"}]

&lt;&gt;&lt;&gt; Processing actions &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
∗ installed base-bigarray.base
∗ installed base-threads.base
∗ installed base-unix.base
∗ installed ocaml-system.4.14.1
∗ installed ocaml-config.2
∗ installed ocaml.4.14.1
Done.
</code></pre>
<p>We can see that <code>opam</code> selected <code>ocaml-system.4.14.1</code> as opposed to
<code>ocaml-base-compiler.4.14.1</code> as the OCaml compiler to install in your current
local switch along with its dependencies. What's the difference?</p>
<ul>
<li><code>ocaml-system</code> is a system-bound compiler, typically one already installed on
your system (e.g. via <code>apt</code>, <code>brew</code>, etc.), <strong>outside</strong> of your <code>opam</code>
installation
</li>
<li><code>ocaml-base-compiler</code> would be a <strong>new</strong> compiler installed <strong>within</strong> your
<code>opam</code> installation, one that <code>opam</code> would have permission over.
</li>
</ul>
<p>If you recall <a href="https://ocamlpro.com/blog/2024_01_23_opam_101_the_first_steps/#createaswitch">this
section</a>
of <code>Opam 101</code>, you should know that creating a switch can be a fairly
time-consuming task depending on whether or not the compiler version you have
queried from <code>opam</code> is already installed somewhere on your machine. Therefore,
every time you ask <code>opam</code> to install a version of the compiler, it will first
scour your installation for a locally available version of that compiler to
save you the time necessary for downloading, compiling and installing a brand
new one. This is the reason why <code>opam</code> has selected an <code>ocaml-system.4.14.1</code>
compiler instead of installing a brand new <code>ocaml-base-compiler.4.14.1</code>.</p>
<p>A quick look at our current directory will show that an <code>_opam</code> directory can
now be found.</p>
<pre><code class="language-shell-session">$ ls
_opam
</code></pre>
<p>And <code>opam switch</code> will list the currently available switches:</p>
<pre><code class="language-shell-session">$ opam switch
#  switch                        compiler             description
→  /home/ocamler/dev/helloer     ocaml.4.14.1         /home/ocamler/dev/helloer
   my-switch                     ocaml-system.4.14.1  my-switch

[NOTE] Current switch has been selected based on the current directory.
       The current global system switch is my-switch.
</code></pre>
<p><code>opam</code> indicates that it has selected the local switch as the currently active
one with the <code>→</code> character and then tells us that the currently active <code>global</code>
switch outside of this directory is still a previously created one called
<code>my-switch</code>.</p>
<blockquote>
<p>Local switches were explained in detail in <a href="https://ocamlpro.com/blog/2024_01_23_opam_101_the_first_steps/#switchlocal">this
section</a>
of <code>Opam 101</code>. We learned in it that <code>opam</code> automatically selects the local
switch as the currently active one as soon as we move inside the directory in
which it was created.</p>
</blockquote>
<p><code>opam list</code> will show us what packages are currently <strong>installed</strong> in our
switch:</p>
<pre><code class="language-shell-session">$ opam list
# Packages matching: installed
# Name        # Installed # Synopsis
base-bigarray base
base-threads  base
base-unix     base
ocaml         4.14.1      The OCaml compiler (virtual package)
ocaml-config  2           OCaml Switch Configuration
ocaml-system  4.14.1      The OCaml compiler (system version, from outside of opam)
</code></pre>
<p>Which is simply the list of dependencies of the OCaml compiler (since it is the
only thing we have installed in our switch so far).</p>
<p>To confirm which OCaml binary is being used:</p>
<pre><code class="language-shell-session">$ ocaml -vnum
4.14.1
$ which ocaml
/usr/bin/ocaml
</code></pre>
<p>This confirms you are using the system compiler (not an opam-installed one) as
the path does not point to either the global <code>~/.opam</code> nor
<code>/home/ocamler/dev/helloer/_opam</code> directories.</p>
<p>In the case of a <code>global</code> switch, the following would be true:</p>
<pre><code class="language-shell-session">$ ocaml -vnum
4.14.1
$ which ocaml
/home/ocamler/.config/opam/my-global-switch/bin/ocaml
</code></pre>
<hr>
<p>To verify that everything works, and since we have a compiler, let's compile a
program:</p>
<pre><code class="language-shell-session">$ cat helloer.ml
let () =
  print_endline "Hello OCamlers!!"
$ ocamlc -o hello helloer.ml
$ ./hello
Hello OCamlers!!
</code></pre>
<p><strong>Nice! You've just compiled your first OCaml program in a fresh local switch. 🎉</strong></p>
<p>Of course, this isn't very exciting yet. Let’s spice things up by adding
external libraries to our <code>helloer</code> program.</p>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#gettingstarted" class="anchor-link">Getting started</a>
          </h3>
<p><code>helloer</code> is a toy project - with it we can play around with the tools at
hand and learn a thing or two about them.</p>
<p>However, if you're curious about the source code of the project, <a href="https://github.com/OCamlPro/opam_bp_examples">you can check
it out right here</a>.</p>
<p>Do keep in mind that this is rather remote from what you will encounter in the
wild. Both the code base and the structure of the repository are made
intentionally barebones.
This will allow us to smoothly introduce what we believe are the most common
features a beginner OCaml dev should get familiar with.</p>
<h4>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#necessarytools" class="anchor-link">Looking for the necessary tools with <code>opam search</code></a>
          </h4>
<p>One of the most valuable skills in OCaml development is selecting the right
libraries for the job. Over time, you will build a mental toolbox of go-to
libraries for all kinds of engineering goals.</p>
<blockquote>
<p><strong>You can explore the package ecosystem in several ways.</strong></p>
<ul>
<li>From the command line :
<ul>
<li><code>opam search &lt;keyword&gt;</code> — find packages
</li>
<li><code>opam show &lt;keyword&gt;</code> — see details of a package
</li>
</ul>
</li>
<li>From the web:
<ul>
<li><a href="https://opam.ocaml.org/packages/">opam.ocaml.org/packages</a>
</li>
<li><a href="https://ocaml.org/packages">ocaml.org/packages</a>
</li>
</ul>
</li>
</ul>
</blockquote>
<h4>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#buildsystem" class="anchor-link">Choose a build system</a>
          </h4>
<p>The first tool your OCaml project needs is a <strong>build system</strong>.</p>
<p>We are using <a href="https://dune.build/">Dune</a> in this tutorial because it is the
most widely used build system in the OCaml ecosystem today. It is well
integrated with <code>opam</code>, supports both libraries and executables, and offers
fast incremental builds with dependency tracking. Most packages in the
<a href="https://github.com/ocaml/opam-repository/"><code>opam-repository</code></a> use <code>dune</code> as
their build system.</p>
<p>That said, OCaml also has other build tools, either still used in specific
contexts or maintained for compatibility - for example, <code>ocpbuild</code>, <code>ocamlbuild</code>,
<code>topkg</code> or just <code>make</code> and <code>ocamlc</code> combined. In some cases, these alternative
tools can feel more lightweight or straightforward, especially for very small
projects or when fine-grained control is needed. Choosing the right tool often
depends on your project’s scope and your familiarity with the ecosystem. For
most new development, however, <code>dune</code> remains the most common and actively
maintained choice.</p>
<blockquote>
<p>If you happen to look for guidance or any kind of support for your OCaml
developments, keep in mind that the <a href="https://discuss.ocaml.org/">Discuss
OCaml</a> Community Forum is the best place to
engage with your peers!</p>
<p>We believe that introducing you to the current most common practices of the
OCaml Community is a solid way to get you going.</p>
<p><em>You can expect us to cover <strong>in detail</strong> how to properly begin a project
with <code>dune</code> in upcoming blogposts.</em></p>
</blockquote>
<p>A call to <code>opam install</code> will change the state of our current switch by
installing this build system:</p>
<pre><code class="language-shell-session">$ opam install dune
</code></pre>
<p>You can now get to writing your first <code>dune-project</code> file. You may either refer
to the
<a href="https://dune.readthedocs.io/en/latest/index.html">documentation</a>
or get some inspiration from the <code>dune-project</code> file we provide <a href="https://ocamlpro.com/blog/feed#opamlint">at the end of
this article</a>!</p>
<h4>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#clitooling" class="anchor-link">Adding Command-Line Tools</a>
          </h4>
<p>Now onto finding a library to help us build a neat command-line interface for
<code>helloer</code>.</p>
<p>We know that the OCaml Standard Library ships an <a href="https://v2.ocaml.org/api/Arg.html"><code>Arg</code>
module</a> which aims at allowing the parsing
of command-line arguments. However, it's quite limited and verbose. Instead,
we'll use <code>opam search</code> for something more ergonomic:</p>
<p>Using <code>opam</code>, a simple <code>opam search</code> with your keywords might help you
greatly:</p>
<pre><code class="language-shell-session">$ opam search "command line interface"
# Packages matching: match(*command line interface*)
# Name                  # Installed # Synopsis
bap-byteweight-frontend --          BAP Toolkit for training and controlling Byteweight algorithm
clim                    --          Command Line Interface Maker
cmdliner                --          Declarative definition of command line interfaces for OCaml
dream-cli               --          Command Line Interface for Dream applications
hg_lib                  --          A library that wraps the Mercurial command line interface
inquire                 --          Create beautiful interactive command line interface in OCaml
kappa-binaries          --          Command line interfaces of the Kappa tool suite
minicli                 --          Minimalist library for command line parsing
ocal                    --          An improved Unix `cal` utility
ocamline                --          Command line interface for user input
wcs                     --          Command line interface for Watson Conversation Service
</code></pre>
<p><code>cmdliner</code> is one of our favourite libraries for that matter so let's use it in
<code>helloer</code>.</p>
<p>Update the switch:</p>
<pre><code class="language-shell-session">$ opam install cmdliner
</code></pre>
<p>Now is the time to implement your first command-line with <code>cmdliner</code>! You can
check how we did it for <code>helloer</code>
<a href="https://github.com/OCamlPro/opam_bp_examples/commit/3bbdc5ad9f5e73efae02f8d954aaf86fe74ad015">here</a>
in the <code>helloer.ml</code> file. You may also refer directly to the <a href="https://erratique.ch/software/cmdliner/doc/"><code>cmdliner</code>
library documentation</a>!</p>
<pre><code class="language-shell-session">$ ./helloer.exe
Hello OCamlers!!           
$ ./helloer.exe --gentle
Welcome my dear OCamlers.
</code></pre>
<h4>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#testlibraries" class="anchor-link">Adding a Test Library</a>
          </h4>
<p>Finally, before we get to coding our little project, we should consider adding
a test library to our project. This will make writing tests much easier, less
time-consuming and less tedious.</p>
<p>Again, calling <code>opam search</code> with one or several keywords will yield many
packages that pertain to testing OCaml binaries. Our selection for today will
be <code>alcotest</code>, a well-known and wide-spread option for conducting tests on
OCaml binaries.</p>
<pre><code class="language-shell-session">$ opam search "test"
# Packages matching: match(*test*)
# Name                              # Installed # Synopsis
afl-persistent                      --          Use afl-fuzz in persistent mode
ahrocksdb                           --          A binding to RocksDB
alcotest                            --          Alcotest is a lightweight and colourful test framework
alcotest-async                      --          Async-based helpers for Alcotest
alcotest-js                         --          Virtual package containing optional JavaScript dependencies for Alcotest
alcotest-lwt                        --          Lwt-based helpers for Alcotest
alcotest-mirage                     --          Mirage implementation for Alcotest
[...]
</code></pre>
<p>Update the switch:</p>
<pre><code class="language-shell-session">$ opam install alcotest
</code></pre>
<p>You can check out how we used it in <code>helloer</code>
<a href="https://github.com/OCamlPro/opam_bp_examples/commit/d1f864d0d8fade97b9b67218f650d1914137425b">here</a>,
also refer to the
<a href="https://mirage.github.io/alcotest/alcotest/Alcotest/index.html">documentation</a>
of the library for further exploration.</p>
<p><strong>Run tour tests:</strong></p>
<pre><code class="language-shell-session">$ dune runtest
Testing `Tests'.                 
This run has ID `N39NJ5ZE'.

  [OK]          messages          0   normal.
  [OK]          messages          1   gentle.

Full test results in `~/ocamler/dev/helloer/_build/default/_build/_tests/Tests'.
Test Successful in 0.000s. 2 tests run.
</code></pre>
<hr>
<p><strong>Now that we have found and used our new tools, we need only to <em>create a package</em>
for <code>helloer</code>!</strong></p>
<p>This means writing an <code>opam</code> file. Next section will cover what information go
into it.</p>
<p>Furthermore, the distribution of your newly developed package to the rest of
the OCaml Community on the <code>opam-repository</code> will be covered in the next <code>opam</code>
blog post!</p>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#firstopamfile" class="anchor-link">Your first opam file</a>
          </h3>
<p>So how exactly does one write an <code>opam</code> file?</p>
<h4>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#minimalopamfile" class="anchor-link">A minimal functional opam file</a>
          </h4>
<p>You will find below a <strong>minimal</strong> <code>opam</code> file for the <code>helloer</code> project.</p>
<p>This file is minimal in the sense that it is complete enough for you to work
with your package on your local environment. However, there remains a few
fields that we will explain in a moment and that are necessary for you to
<strong>distribute</strong> your code.</p>
<pre><code class="language-shell-session">$ cat helloer.opam
opam-version: "2.0"
depends: [
  "cmdliner"
  "ocaml"
  "alcotest" {with-test}
]
build: [
 [ "dune" "build" "-p" name ]
 [ "dune" "runtest" ] {with-test}
]
install: [ "dune" "install" ]
</code></pre>
<p>For now, there is enough information for <code>opam</code> to install and use your OCaml
project locally.</p>
<p><strong>What are these fields for?</strong></p>
<p><code>opam-version: "2.0"</code>:</p>
<ul>
<li>Specifies that this <code>opam</code> file uses syntax compatible with <code>opam 2.0</code> or later.
</li>
<li>Required at the top of every <code>opam</code> file.
</li>
</ul>
<p><code>depends: [...]</code>:</p>
<ul>
<li>Lists the packages that your project depends on. It lists all necessary
information to build your project, and to help <code>opam</code> suggest what other
packages <strong>have to be installed</strong> prior to it.
<ul>
<li>You could optionally set lower or upper bound for specific version range
(e.g., <code>cmdliner {&gt;= "1.0.0"}</code>), but omitting that is fine for a minimal
file like this one.
</li>
</ul>
</li>
</ul>
<p><code>build: [...]</code>:</p>
<ul>
<li>Tells <code>opam</code> how to build your project.
</li>
<li><code>["dune" "build" "-p" name]</code>: Builds the package. <code>-p name</code> means <em>"build the
part of the project with the same name as the opam package"</em>.
<blockquote>
<p><code>name</code> here should match the actual <code>opam</code> package name; it’s often replaced
automatically by <code>opam</code> internally.</p>
</blockquote>
</li>
<li><code>["dune" "runtest"] {with-test}</code>: Runs the test suite, only if <code>--with-test</code> option
is passed (e.g. during CI or development).
</li>
<li>You can fill up with any command here, it will be launched by opam
in a sandboxed environment.
</li>
</ul>
<p><code>install: [...]</code>:</p>
<ul>
<li>This tells <code>opam</code> how to install the built binaries and libraries into the
<code>opam</code> environment.
</li>
<li>Dune will install any libraries, executables, and other files you've marked
as <code>public_name</code>.
</li>
</ul>
<p>That is it for the <strong>essential fields</strong> of an <code>opam</code> file. Now onto the
<strong>metadata</strong> fields which are required for you to later distribute your package
through the <a href="https://github.com/ocaml/opam-repository/">Official OCaml
<code>opam-repository</code></a>.</p>
<blockquote>
<p>An <code>opam</code> file supports about <em>thirty-ish</em> valid fields to specify a package,
again, you can look them all up
<a href="https://opam.ocaml.org/doc/Manual.html#opam">here</a>.</p>
</blockquote>
<h4>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#opamlint" class="anchor-link">A real-world opam file with <code>opam lint</code></a>
          </h4>
<p><strong>What fields are mandatory for a proper <code>opam</code> package?</strong></p>
<p>A good question, and the answer is simple since <code>opam</code> features a linting
command with <code>opam lint</code>.</p>
<p>This means that running this command on our small <code>opam</code> file will yield the
following message to help us make sense of what more is required to make our
newly developped package distributable:</p>
<pre><code class="language-shell-session">$ opam lint .
/home/ocamler/dev/helloer/helloer.opam: Errors.
    error 23: Missing field 'maintainer'
  warning 25: Missing field 'authors'
  warning 35: Missing field 'homepage'
  warning 36: Missing field 'bug-reports'
    error 57: Synopsis must not be empty
  warning 68: Missing field 'license'
</code></pre>
<p>As you can see, some of these missing fields are considered errors, and others
are considered mere warnings. Each also come with a designated error code.
You can find all warning and error codes by either running the <code>opam lint --help</code> command in your terminal, or going to the corresponding <code>opam</code>
man page <a href="https://opam.ocaml.org/doc/man/opam-lint.html">on the
interwebs</a>.</p>
<p><strong>Let's break each of them down and see how these linting errors can be fixed.</strong></p>
<ul>
<li>
<p><strong>Error 23: Missing field <code>maintainer</code></strong><br>
<strong>What:</strong> Contact email for the package maintainer.<br>
<strong>Example:</strong></p>
<pre><code class="language-opam">maintainer: ["Your Name &lt;hell@er.com&gt;"]
</code></pre>
</li>
<li>
<p><strong>Error 57: Synopsis must not be empty</strong><br>
<strong>What:</strong> One-line description of your project.<br>
<strong>Example:</strong></p>
<pre><code class="language-opam">synopsis: "A simple and polite greeter in OCaml"
</code></pre>
</li>
<li>
<p><strong>Warning 25: Missing field <code>authors</code></strong><br>
<strong>What:</strong> List of project authors.<br>
<strong>Example:</strong></p>
<pre><code class="language-opam">authors: ["Your Name &lt;hell@er.com&gt;"]
</code></pre>
</li>
<li>
<p><strong>Warning 35: Missing field <code>homepage</code></strong><br>
<strong>What:</strong> URL to your project's website or repository.<br>
<strong>Example:</strong></p>
<pre><code class="language-opam">homepage: "https://github.com/OCamlPro/opam_bp_examples"
</code></pre>
</li>
<li>
<p><strong>Warning 36: Missing field <code>bug-reports</code></strong><br>
<strong>What:</strong> URL for reporting issues.<br>
<strong>Example:</strong></p>
<pre><code class="language-opam">bug-reports: "https://github.com/OCamlPro/opam_bp_examples/issues"
</code></pre>
</li>
<li>
<p><strong>Warning 68: Missing field <code>license</code></strong><br>
<strong>What:</strong> License under which your project is distributed.<br>
<strong>Example:</strong></p>
<pre><code class="language-opam">license: "ISC"
</code></pre>
</li>
</ul>
<hr>
<blockquote>
<p>Now that you have linted an <code>opam</code> file manually, you will be very happy to
learn that <code>dune</code> can actually automatically generate that file for you. Say
for instance that you prefer the syntax of the <code>dune-project</code> file, you can
let <code>dune</code> handle it for you!</p>
</blockquote>
<p><strong>Here's what a complete <code>dune-project</code> file would look like for our little
<code>helloer</code> project.</strong></p>
<pre><code class="language-lisp">(lang dune 3.15)

(name helloer)

(license ISC)

(authors "Your Name &lt;hell@er.com&gt;")

(maintainers "You Name &lt;hell@er.com&gt;")

(source
 (uri "https://github.com/OCamlPro/opam_bp_examples"))

(homepage "https://github.com/OCamlPro/opam_bp_examples")

(bug_reports "https://github.com/RadioPotin/ocamuse/issues")

(documentation "N/A")

(generate_opam_files true)

(package
  (name helloer)
  (synopsis "A simple and polite greeter in OCaml")
  (description
    "This is an example package for article 'opam 103' on OCamlPro's blog")
  (tags (greeter opam 103 tutorial beginner))
  (depends
    ocaml
    cmdliner
    alcotest
  )
)
</code></pre>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#conclusion" class="anchor-link">Conclusion and what's next</a>
          </h3>
<p>At this point, our project is in great shape. We've seen how to setup your
<strong>local switch</strong>, <strong>integrate third-party libraries</strong>, <strong>run tests</strong>, and
<strong>write a minimal</strong> but functional <strong><code>opam</code> file</strong>. With that foundation,
you’re ready to <strong>build and manage</strong> your OCaml projects locally with
confidence.</p>
<p>But writing code for yourself is only half the journey. The next step is
<strong>sharing it with the world</strong>. In our next post, we’ll dive into how to <strong>publish
your package</strong> to the official OCaml
<a href="https://github.com/ocaml/opam-repository/">opam-repository</a> — covering
everything from the structure of an <strong>opam package submission</strong>, to working with
the community through <strong>pull requests</strong>, <strong>versioning</strong>, <strong>opam-CI</strong>, and more.</p>
<p>Thank you for trodding along the dunes with this little OCaml caravan of ours
<a href="https://www.youtube.com/watch?v=r8OipmKFDeM">🚶🚶🐫🐫🐫</a> — and until our next
<a href="https://github.com/ocaml/oasis">Oasis</a>, happy hacking!</p>


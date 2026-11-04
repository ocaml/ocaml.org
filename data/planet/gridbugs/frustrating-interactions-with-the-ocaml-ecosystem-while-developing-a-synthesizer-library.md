---
title: Frustrating Interactions with the OCaml Ecosystem while developing a Synthesizer
  Library
description: This post is about some frustrating experiences I had while developing
  my first non-trivial OCaml project - an audio synthesizer library. I generally enjoy
  programming in OCaml but I often find its development tools to be counter-intuitive
  in their UX and surprising-in-a-bad-way in their behaviour.
url: https://www.gridbugs.org/frustrating-interactions-with-the-ocaml-ecosystem-while-developing-a-synthesizer-library/
date: 2024-09-05T00:00:00-00:00
preview_image: https://www.gridbugs.org/logo.png
authors:
- Gridbugs
source:
ignore:
keywords:
- cargo
- dune
- library
- library_flags
- llama
- llama_core
- llama_midi
- rust
- sexp
- synthesizer
---

<p><img src="https://www.gridbugs.org/frustrating-interactions-with-the-ocaml-ecosystem-while-developing-a-synthesizer-library/background.jpg" alt="A landscape of a rugged mountain range"></p>
<div style="color:gray;font-style:italic">
At the time of writing I'm employed by Tarides to work on the Dune
build system, but all the opinions in this post are my own.  I wrote
the first version of this post a year ago for the Tarides blog but it
was never published.  I recently got permission to post it here
instead.
</div>
<p>This post is about some frustrating experiences I had while developing
my first non-trivial OCaml project - <a href="https://github.com/gridbugs/llama/">an audio synthesizer
library</a>.  I generally enjoy
programming in OCaml but I often find its development tools to be
counter-intuitive in their UX and surprising-in-a-bad-way in their
behaviour.  Realistic expectations are important for avoiding
disappointment and my expectations were too high when I started the
project. The goal of this post is to communicate my err…updated
expectations of OCaml development tools by listing all the times they
didn’t work the way I expected while developing my synthesizer
library.</p>
<p>This isn’t just a cathartic rant (though it’s also that).  I’m worried
that people will try out OCaml, encounter friction with its tools, and
bounce off to a more ergonomic ecosystem. Or worse, I’m worried that
users will attribute their negative experiences with OCaml’s tooling
as a deficiency in their own programming ability rather than a
deficiency in the tools themselves. I want to reach these people and
convey that if you are struggling with the tools, know that it’s not
you - it’s the tools. Almost every OCaml programmer I know struggles
to install packages with Opam, and struggles to configure Dune to do
anything non-trivial when building projects. OCaml tools are hard to
use. You are not alone.</p>
<p>My initially high expectations of OCaml tooling is possibly related to
the fact that the language I use for most of my personal programming
projects is Rust. I choose Rust for most of my hobby programming
specifically because I find it easy to manage dependencies and build
projects with Cargo. I have limited free time and I’d rather spend it
making cool stuff instead of fighting against the package manager or
build system. Which brings us to…</p>
<h2><a href="https://www.gridbugs.org/rss.xml#all-the-times-an-ocaml-dev-tool-or-library-wasted-my-time-by-doing-something-unexpected-while-i-was-developing-my-synthesizer-library" class="zola-anchor" aria-label="Anchor link for: all-the-times-an-ocaml-dev-tool-or-library-wasted-my-time-by-doing-something-unexpected-while-i-was-developing-my-synthesizer-library">All the times an OCaml dev tool or library wasted my time by doing something unexpected while I was developing my synthesizer library</a></h2>
<ul>
<li><a href="https://www.gridbugs.org/frustrating-interactions-with-the-ocaml-ecosystem-while-developing-a-synthesizer-library/#linking-against-os-specific-native-libraries-with-dune-is-hard">Linking against OS-specific native libraries with Dune is hard</a></li>
<li><a href="https://www.gridbugs.org/frustrating-interactions-with-the-ocaml-ecosystem-while-developing-a-synthesizer-library/#dune-silently-ignores-directories-starting-with-a-period-breaking-rust-interoperability">Dune silently ignores directories starting with a period, breaking Rust interoperability</a></li>
<li><a href="https://www.gridbugs.org/frustrating-interactions-with-the-ocaml-ecosystem-while-developing-a-synthesizer-library/#the-obvious-choice-of-package-for-reading-wav-files-crashes-when-reading-wav-files">The obvious choice of package for reading <code>.wav</code> files crashes when reading <code>.wav</code> files</a></li>
<li><a href="https://www.gridbugs.org/frustrating-interactions-with-the-ocaml-ecosystem-while-developing-a-synthesizer-library/#transferring-an-array-of-floats-from-rust-to-ocaml-produced-a-broken-array-this-is-now-fixed">Transferring an array of floats from Rust to OCaml produced a broken array (this is now fixed!)</a></li>
<li><a href="https://www.gridbugs.org/frustrating-interactions-with-the-ocaml-ecosystem-while-developing-a-synthesizer-library/#adding-inline-tests-to-a-library-requires-adding-over-20-runtime-dependencies">Adding inline tests to a library requires adding over 20 (runtime) dependencies</a></li>
<li><a href="https://www.gridbugs.org/frustrating-interactions-with-the-ocaml-ecosystem-while-developing-a-synthesizer-library/#dune-can-generate-opam-files-but-requires-a-workaround-for-adding-the-available-field">Dune can generate <code>.opam</code> files but requires a workaround for adding the <code>available</code> field</a></li>
<li><a href="https://www.gridbugs.org/frustrating-interactions-with-the-ocaml-ecosystem-while-developing-a-synthesizer-library/#if-some-but-not-all-of-the-interdependent-packages-in-a-project-are-released-opam-can-t-solve-the-project-s-dependencies">If some (but not all) of the interdependent packages in a project are released, Opam can’t solve the project’s dependencies</a></li>
</ul>
<h3><a href="https://www.gridbugs.org/rss.xml#linking-against-os-specific-native-libraries-with-dune-is-hard" class="zola-anchor" aria-label="Anchor link for: linking-against-os-specific-native-libraries-with-dune-is-hard">Linking against OS-specific native libraries with Dune is hard</a></h3>
<p>The first thing I needed to do was make a program that plays a simple
sound.  The most reliable cross-platform library I’m aware of for
interfacing with sound drivers is
<a href="https://crates.io/crates/cpal"><code>cpal</code></a>.  One problem: It’s a Rust
library. (I’ve since learned of
<a href="https://github.com/savonet/ocaml-ao"><code>ocaml-ao</code></a> which provides
bindings for the cross-platform audio library <code>libao</code>.)</p>
<p>Calling into Rust from OCaml was easier than I expected
thanks to the <a href="https://crates.io/crates/ocaml"><code>ocaml-rs</code></a>
library. I used <code>ocaml-rs</code> and <code>cpal</code> to make a small Rust library
named <code>low_level</code> which accepts a stream of <code>float</code>s representing
audio data, and plays them on the computer’s speakers. I compiled this
library to an archive file <code>liblow_level.a</code>, and wrote a little OCaml
library <code>llama_low_level</code> (my synthesizer library is named <code>llama</code>) to
wrap it with a higher-level interface.</p>
<p>I’m using Dune to build this project. Dune has a mechanism for linking
against native libraries like <code>liblow_level.a</code>, and the
<a href="https://zshipko.github.io/ocaml-rs/"><code>ocaml-rs</code> documentation</a> gives
some advice on how to write your <code>dune</code> file (the per-directory build
config files used by Dune). I started with this:</p>
<pre data-lang="dune" style="background-color:#ffffff;color:#323232;" class="language-dune "><code class="language-dune" data-lang="dune"><span>(</span><span style="font-weight:bold;color:#a71d5d;">library
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">name</span><span> llama_low_level)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">foreign_archives</span><span> low_level)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">c_library_flags
</span><span>  (-lpthread -lc -lm)))
</span></code></pre>
<p>Building this library gave the error:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>$ dune build
</span><span>...
</span><span>Error: No rule found for dlllow_level.so
</span></code></pre>
<p>Dune is looking for the shared library file <code>dlllow_level.so</code> for my
<code>low_level</code> library, but I only compiled <code>low_level</code> to a static
archive <code>liblow_level.a</code>. There’s no reason the linker needs to be
provided with both of these files, so I took a look through
<a href="https://dune.readthedocs.io/en/stable/dune-files.html#library">dune’s (library …) stanza documentation</a>
to see if there’s a way to only link against the static library and
discovered the <code>no_dynlink</code> field:</p>
<blockquote>
<p><code>(no_dynlink)</code> disables dynamic linking of the library. This is for advanced use only. By default, you shouldn’t set this option.</p>
</blockquote>
<p>A little intimidating but let’s give it a shot:</p>
<pre data-lang="dune" style="background-color:#ffffff;color:#323232;" class="language-dune "><code class="language-dune" data-lang="dune"><span>(</span><span style="font-weight:bold;color:#a71d5d;">library
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">name</span><span> llama_low_level)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">no_dynlink</span><span>)                 </span><span style="font-style:italic;color:#969896;">; &lt;-- the new field
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">foreign_archives</span><span> low_level)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">c_library_flags
</span><span>  (-lpthread -lc -lm)))
</span></code></pre>
<p>Running <code>dune build</code> on the <code>llama_low_level</code> library now works as expected.</p>
<p>Next step is to actually make some noise. I made a little program
simply named <code>experiment</code> which uses <code>llama_low_level</code> to play a sine
wave. Here’s its <code>dune</code> file:</p>
<pre data-lang="dune" style="background-color:#ffffff;color:#323232;" class="language-dune "><code class="language-dune" data-lang="dune"><span>(</span><span style="font-weight:bold;color:#a71d5d;">executable
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">public_name</span><span> experiment)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">libraries</span><span> llama_low_level))
</span></code></pre>
<p>Trying to build this program filled my screen with errors. The first error was:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>$ dune build
</span><span>File "bin/dune", line 2, characters 14-24:
</span><span>2 |  (public_name experiment)
</span><span>                  ^^^^^^^^^^
</span><span>Undefined symbols for architecture arm64:
</span><span>  "_AudioComponentFindNext", referenced from:
</span><span>      cpal::host::coreaudio::macos::audio_unit_from_device::h062e0db473d1abd3 in liblow_level.a...
</span></code></pre>
<p>I searched the web for <code>AudioComponentFindNext</code> which led me to some
Apple developer docs for the AudioToolbox framework. So the foreign
archive must depend on some frameworks on MacOS for doing audio
stuff and I need to tell the linker about it. Eventually I found the
appropriate linker flags to copy/paste from stack overflow:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>-framework CoreServices -framework CoreAudio -framework AudioUnit -framework AudioToolbox
</span></code></pre>
<p>Now I have to find a way to pass these flags to the linker. If this
was a C program I could pass them via the C compiler. Something like:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>clang foo.c -Wl,-framework,CoreServices,-framework,CoreAudio,-framework,AudioUnit,-framework,AudioToolbox
</span></code></pre>
<p>Dune provides a mechanism for passing additional linker flags when compiling a library:</p>
<blockquote>
<p><code>(library_flags (&lt;flags&gt;))</code> is a list of flags passed to ocamlc and ocamlopt when building the library archive files.</p>
</blockquote>
<p>And similar to the C compiler example above, the OCaml compiler also
has a way of passing custom flags along to the linker. From <code>man ocamlc</code>:</p>
<blockquote>
<p>-cclib -llibname</p>
<p>Pass the -llibname option to the C linker when linking in “custom
runtime” mode (see the -custom option). This causes the given C
library to be linked with the program.</p>
<p>-ccopt option</p>
<p>Pass the given option to the C compiler and linker, when linking
in “custom runtime” mode (see the -custom option). For instance,
-ccopt -Ldir causes the C linker to search for C libraries in
directory dir.</p>
</blockquote>
<p>It’s not immediately clear which of those two options I need. After some trial and error <code>-cclib</code> turns out to be the winner.</p>
<p>I added a <code>library_flags</code> field to the <code>dune</code> file for <code>llama_low_level</code>:</p>
<pre data-lang="dune" style="background-color:#ffffff;color:#323232;" class="language-dune "><code class="language-dune" data-lang="dune"><span>(</span><span style="font-weight:bold;color:#a71d5d;">library
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">name</span><span> llama_low_level)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">no_dynlink</span><span>)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">foreign_archives</span><span> low_level)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">c_library_flags
</span><span>  (-lpthread -lc -lm))
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">library_flags
</span><span>  (-cclib </span><span style="color:#183691;">"-framework CoreServices -framework CoreAudio -framework AudioUnit -framework AudioToolbox"</span><span>)))
</span></code></pre>
<p>That’s sufficient to get it building on MacOS and the sine wave now
playing through my speakers was music to my ears.</p>
<p>But what about on Linux?</p>
<p>On Linux <code>cpal</code> uses the library <code>libasound</code> to interface with the
sound driver. You might get away with just passing <code>-lasound</code>
to the linker but in general you should probe the current machine for
linker arguments by running <code>pkg-config --libs alsa</code>.</p>
<p>For example I run NixOS (by the way) where the correct linker arguments are:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>$ pkg-config --libs alsa
</span><span>-L/nix/store/g3a56c2y6arvxyr4kxvlg409gzfwyfp0-alsa-lib-1.2.11/lib -lasound
</span></code></pre>
<p>As an experiment I modified the <code>dune</code> file to have the output of
<code>pkg-config</code> hard-coded to see if that was enough for it to work on
Linux:</p>
<pre data-lang="dune" style="background-color:#ffffff;color:#323232;" class="language-dune "><code class="language-dune" data-lang="dune"><span>(</span><span style="font-weight:bold;color:#a71d5d;">library
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">name</span><span> llama_low_level)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">no_dynlink</span><span>)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">foreign_archives</span><span> low_level)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">c_library_flags
</span><span>  (-lpthread -lc -lm))
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">library_flags
</span><span>  (-cclib </span><span style="color:#183691;">"-L/nix/store/g3a56c2y6arvxyr4kxvlg409gzfwyfp0-alsa-lib-1.2.11/lib -lasound"</span><span>)))
</span></code></pre>
<p>This works. Interestingly passing <code>-lasound</code> causes the library to be
linked against the shared library file <code>libasound.so</code> despite the
<code>(no_dynlink)</code> setting.</p>
<p>Obviously we can’t leave the linker arguments hard-coded like
that. Instead we need to get Dune to invoke <code>pkg-config</code> at build time
so the correct arguments for the current machine are passed to the
linker. First we’ll make it so the linker arguments are loaded from a
file, then we’ll have Dune generate that file at build time by running
<code>pkg-config</code>.</p>
<p>Dune allows the contents of
<a href="https://en.wikipedia.org/wiki/S-expression">S-expression (sexp)</a> files to be
included in most fields. I made a file <code>library_flags.sexp</code> with the
contents:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>("-cclib" "-L/nix/store/g3a56c2y6arvxyr4kxvlg409gzfwyfp0-alsa-lib-1.2.11/lib -lasound")
</span></code></pre>
<p>The parentheses are necessary to make it a valid sexp file. The quotes
around <code>-cclib</code> are necessary as otherwise Dune tries to interpret
<code>-cclib</code> as a keyword instead of treating the entire sexp as a list
(similar to the <code>quote</code> keyword in some lisp dialects).</p>
<p>Now this file can be included in the <code>dune</code> file:</p>
<pre data-lang="dune" style="background-color:#ffffff;color:#323232;" class="language-dune "><code class="language-dune" data-lang="dune"><span>(</span><span style="font-weight:bold;color:#a71d5d;">library
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">name</span><span> llama_low_level)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">no_dynlink</span><span>)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">foreign_archives</span><span> low_level)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">c_library_flags
</span><span>  (-lpthread -lc -lm))
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">library_flags
</span><span>  (</span><span style="font-weight:bold;color:#a71d5d;">:include</span><span> library_flags.sexp)))  </span><span style="font-style:italic;color:#969896;">; &lt;- here!
</span></code></pre>
<p>Next we’ll need to generate <code>library_flags.sexp</code> by running
<code>pkg-config</code> at build time. This can be done using Dune’s custom rule
mechanism. See
<a href="https://dune.readthedocs.io/en/stable/reference/actions/index.html">this page</a>
for info about the different ways files can be generated by custom
rules. The <code>dune</code> file is now:</p>
<pre data-lang="dune" style="background-color:#ffffff;color:#323232;" class="language-dune "><code class="language-dune" data-lang="dune"><span>(</span><span style="font-weight:bold;color:#a71d5d;">rule
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">action
</span><span>  (</span><span style="font-weight:bold;color:#a71d5d;">with-stdout-to
</span><span>   library_flags.sexp
</span><span>   (</span><span style="font-weight:bold;color:#a71d5d;">progn
</span><span>    (</span><span style="font-weight:bold;color:#a71d5d;">echo </span><span style="color:#183691;">"(</span><span style="color:#0086b3;">\"</span><span style="color:#183691;">-cclib</span><span style="color:#0086b3;">\" \"</span><span style="color:#183691;">"</span><span>)
</span><span>    (</span><span style="font-weight:bold;color:#a71d5d;">bash </span><span style="color:#183691;">"pkg-config --libs alsa"</span><span>)
</span><span>    (</span><span style="font-weight:bold;color:#a71d5d;">echo </span><span style="color:#183691;">"</span><span style="color:#0086b3;">\"</span><span style="color:#183691;">)"</span><span>)))))
</span><span>
</span><span>(</span><span style="font-weight:bold;color:#a71d5d;">library
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">name</span><span> llama_low_level)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">no_dynlink</span><span>)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">foreign_archives</span><span> low_level)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">c_library_flags
</span><span>  (-lpthread -lc -lm))
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">library_flags
</span><span>  (</span><span style="font-weight:bold;color:#a71d5d;">:include</span><span> library_flags.sexp)))
</span></code></pre>
<p>This feels a little cumbersome to me. I need to generate a sexp file
in one place only to include it in another place, and Dune doesn’t
help at all with emitting sexp syntax, requiring me to explicitly
escape quotes and remember to include the parentheses.</p>
<p>Also this solution is specific to Linux. To add back support for MacOS
we need to conditionally enable the rule and add a second rule for
MacOS that generates a sexp file with the original linker arguments:</p>
<pre data-lang="dune" style="background-color:#ffffff;color:#323232;" class="language-dune "><code class="language-dune" data-lang="dune"><span>(</span><span style="font-weight:bold;color:#a71d5d;">rule
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">enabled_if
</span><span>  (</span><span style="font-weight:bold;color:#a71d5d;">= </span><span style="font-weight:bold;color:#795da3;">%{system}</span><span> linux))
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">action
</span><span>  (</span><span style="font-weight:bold;color:#a71d5d;">with-stdout-to
</span><span>   library_flags.sexp
</span><span>   (</span><span style="font-weight:bold;color:#a71d5d;">progn
</span><span>    (</span><span style="font-weight:bold;color:#a71d5d;">echo </span><span style="color:#183691;">"(</span><span style="color:#0086b3;">\"</span><span style="color:#183691;">-cclib</span><span style="color:#0086b3;">\" \"</span><span style="color:#183691;">"</span><span>)
</span><span>    (</span><span style="font-weight:bold;color:#a71d5d;">bash </span><span style="color:#183691;">"pkg-config --libs alsa"</span><span>)
</span><span>    (</span><span style="font-weight:bold;color:#a71d5d;">echo </span><span style="color:#183691;">"</span><span style="color:#0086b3;">\"</span><span style="color:#183691;">)"</span><span>)))))
</span><span>
</span><span>(</span><span style="font-weight:bold;color:#a71d5d;">rule
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">enabled_if
</span><span>  (</span><span style="font-weight:bold;color:#a71d5d;">= </span><span style="font-weight:bold;color:#795da3;">%{system}</span><span> macosx))
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">action
</span><span>  (</span><span style="font-weight:bold;color:#a71d5d;">write-file
</span><span>   library_flags.sexp
</span><span>   </span><span style="color:#183691;">"(</span><span style="color:#0086b3;">\"</span><span style="color:#183691;">-ccopt</span><span style="color:#0086b3;">\" \"</span><span style="color:#183691;">-framework CoreServices -framework CoreAudio -framework AudioUnit -framework AudioToolbox</span><span style="color:#0086b3;">\"</span><span style="color:#183691;">)"</span><span>)))
</span><span>
</span><span>(</span><span style="font-weight:bold;color:#a71d5d;">rule
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">enabled_if
</span><span>  (</span><span style="font-weight:bold;color:#a71d5d;">and
</span><span>   (</span><span style="font-weight:bold;color:#a71d5d;">&lt;&gt; </span><span style="font-weight:bold;color:#795da3;">%{system}</span><span> linux)
</span><span>   (</span><span style="font-weight:bold;color:#a71d5d;">&lt;&gt; </span><span style="font-weight:bold;color:#795da3;">%{system}</span><span> macosx)))
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">action
</span><span>  (</span><span style="font-weight:bold;color:#a71d5d;">write-file</span><span> library_flags.sexp </span><span style="color:#183691;">"()"</span><span>)))
</span><span>
</span><span>(</span><span style="font-weight:bold;color:#a71d5d;">library
</span><span> ...
</span></code></pre>
<p>Note that the third rule is necessary so that the
<code>library_flags.sexp</code> file is still generated on machines that are
running neither MacOS nor Linux. Also note that the comparisons <code>(= %{system} linux)</code> and <code>(= %{system} macosx)</code> are string comparisons,
so if you accidentally typed <code>macos</code> instead of <code>macosx</code> then the
condition would be false on MacOS machines.</p>
<p>In this project I found that it was getting out of hand to manage the
conditional rules and to generate sexp files using Dune’s built-in
configuration language. Fortunately there is an external library
<a href="https://opam.ocaml.org/packages/dune-configurator"><code>dune-configurator</code></a>
to help you write OCaml programs that query the current machine and
generate sexp files for inclusion in <code>dune</code> files.</p>
<p>In a separate directory, I made a little executable called <code>discover</code> with this <code>dune</code> file:</p>
<pre data-lang="dune" style="background-color:#ffffff;color:#323232;" class="language-dune "><code class="language-dune" data-lang="dune"><span>(</span><span style="font-weight:bold;color:#a71d5d;">executable
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">name</span><span> discover)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">libraries</span><span> dune-configurator))
</span></code></pre>
<p>Then I rewrote the logic from the custom Dune rules into OCaml:</p>
<pre data-lang="ocaml" style="background-color:#ffffff;color:#323232;" class="language-ocaml "><code class="language-ocaml" data-lang="ocaml"><span style="font-weight:bold;color:#a71d5d;">module </span><span>C </span><span style="font-weight:bold;color:#a71d5d;">= </span><span>Configurator.V1
</span><span>
</span><span style="font-weight:bold;color:#a71d5d;">let </span><span style="color:#0086b3;">macos_library_flags </span><span style="font-weight:bold;color:#a71d5d;">=
</span><span>  </span><span style="font-weight:bold;color:#a71d5d;">let </span><span style="color:#0086b3;">frameworks </span><span style="font-weight:bold;color:#a71d5d;">=
</span><span>    [ </span><span style="color:#183691;">"CoreServices"</span><span>; </span><span style="color:#183691;">"CoreAudio"</span><span>; </span><span style="color:#183691;">"CoreMidi"</span><span>; </span><span style="color:#183691;">"AudioUnit"</span><span>; </span><span style="color:#183691;">"AudioToolbox" </span><span>]
</span><span>  </span><span style="font-weight:bold;color:#a71d5d;">in
</span><span>  List.map (Printf.sprintf </span><span style="color:#183691;">"-framework %s"</span><span>) frameworks
</span><span>
</span><span style="font-weight:bold;color:#a71d5d;">let </span><span style="color:#0086b3;">() </span><span style="font-weight:bold;color:#a71d5d;">=
</span><span>  C.main </span><span style="color:#63a35c;">~name:</span><span style="color:#183691;">"llama_low_level" </span><span>(</span><span style="font-weight:bold;color:#a71d5d;">fun </span><span>c -&gt;
</span><span>      </span><span style="font-weight:bold;color:#a71d5d;">let </span><span style="color:#0086b3;">linker_args </span><span style="font-weight:bold;color:#a71d5d;">=
</span><span>        </span><span style="font-weight:bold;color:#a71d5d;">match </span><span>C.ocaml_config_var_exn c </span><span style="color:#183691;">"system" </span><span style="font-weight:bold;color:#a71d5d;">with
</span><span>        </span><span style="font-weight:bold;color:#a71d5d;">| </span><span style="font-style:italic;color:#969896;">"macosx" </span><span>-&gt; macos_library_flags
</span><span>        </span><span style="font-weight:bold;color:#a71d5d;">| </span><span style="font-style:italic;color:#969896;">"linux" </span><span>-&gt; (
</span><span>            </span><span style="font-weight:bold;color:#a71d5d;">let </span><span style="color:#0086b3;">default </span><span style="font-weight:bold;color:#a71d5d;">= </span><span>[ </span><span style="color:#183691;">"-lasound" </span><span>] </span><span style="font-weight:bold;color:#a71d5d;">in
</span><span>            </span><span style="font-weight:bold;color:#a71d5d;">match </span><span>C.Pkg_config.get c </span><span style="font-weight:bold;color:#a71d5d;">with
</span><span>            </span><span style="font-weight:bold;color:#a71d5d;">| </span><span>None -&gt; default
</span><span>            </span><span style="font-weight:bold;color:#a71d5d;">| </span><span>Some pc -&gt; (
</span><span>                </span><span style="font-weight:bold;color:#a71d5d;">match </span><span>C.Pkg_config.query pc </span><span style="color:#63a35c;">~package:</span><span style="color:#183691;">"alsa" </span><span style="font-weight:bold;color:#a71d5d;">with
</span><span>                </span><span style="font-weight:bold;color:#a71d5d;">| </span><span>None -&gt; default
</span><span>                </span><span style="font-weight:bold;color:#a71d5d;">| </span><span>Some conf -&gt; conf.libs))
</span><span>        </span><span style="font-weight:bold;color:#a71d5d;">| </span><span style="color:#0086b3;">_ </span><span>-&gt; </span><span style="color:#0086b3;">[]
</span><span>      </span><span style="font-weight:bold;color:#a71d5d;">in
</span><span>      </span><span style="font-weight:bold;color:#a71d5d;">let </span><span style="color:#0086b3;">cclib_arg </span><span style="font-weight:bold;color:#a71d5d;">= </span><span>String.concat </span><span style="color:#183691;">" "</span><span> linker_args </span><span style="font-weight:bold;color:#a71d5d;">in
</span><span>      C.Flags.write_sexp </span><span style="color:#183691;">"library_flags.sexp" </span><span>[ </span><span style="color:#183691;">"-cclib"</span><span>; cclib_arg ]
</span></code></pre>
<p>Finally I updated the <code>dune</code> file for <code>llama_low_level</code> to run <code>discover</code>:</p>
<pre data-lang="dune" style="background-color:#ffffff;color:#323232;" class="language-dune "><code class="language-dune" data-lang="dune"><span>(</span><span style="font-weight:bold;color:#a71d5d;">rule
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">target</span><span> library_flags.sexp)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">action
</span><span>  (</span><span style="font-weight:bold;color:#a71d5d;">run</span><span> ./config/discover.exe)))
</span><span>
</span><span>(</span><span style="font-weight:bold;color:#a71d5d;">library
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">name</span><span> llama_low_level)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">no_dynlink</span><span>)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">foreign_archives</span><span> low_level)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">c_library_flags
</span><span>  (-lpthread -lc -lm))
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">library_flags
</span><span>  (</span><span style="font-weight:bold;color:#a71d5d;">:include</span><span> library_flags.sexp)))
</span></code></pre>
<p>Now when Dune needs to generate the <code>library_flags.sexp</code> file it will
first build the <code>discover</code> executable and then run it to generate the
file, before including the contents of that file to set the extra
flags passed to the OCaml compiler to configure the linker.
While this does work, it feels like a <a href="https://en.wikipedia.org/wiki/Rube_Goldberg_machine">Rube Goldberg Machine</a>, and I was
surprised to find that such a complex solution was needed to pass
different linker flags while building on different operating systems.</p>
<h3><a href="https://www.gridbugs.org/rss.xml#dune-silently-ignores-directories-starting-with-a-period-breaking-rust-interoperability" class="zola-anchor" aria-label="Anchor link for: dune-silently-ignores-directories-starting-with-a-period-breaking-rust-interoperability">Dune silently ignores directories starting with a period, breaking Rust interoperability</a></h3>
<p>In the previous section I mentioned compiling a Rust library <code>liblow_level.a</code> and calling into it from OCaml.
Up until now I was running the commands to build it myself, but I’d rather have Dune do this for me.
I added this rule to the <code>dune</code> file for <code>llama_low_level</code>:</p>
<pre data-lang="dune" style="background-color:#ffffff;color:#323232;" class="language-dune "><code class="language-dune" data-lang="dune"><span>(</span><span style="font-weight:bold;color:#a71d5d;">rule
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">target</span><span> liblow_level.a)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">deps
</span><span>  (</span><span style="font-weight:bold;color:#a71d5d;">source_tree</span><span> low-level-rust))
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">action
</span><span>  (</span><span style="font-weight:bold;color:#a71d5d;">progn
</span><span>   (</span><span style="font-weight:bold;color:#a71d5d;">chdir
</span><span>    low-level-rust
</span><span>    (</span><span style="font-weight:bold;color:#a71d5d;">run</span><span> cargo build --release))
</span><span>   (</span><span style="font-weight:bold;color:#a71d5d;">run</span><span> mv low-level-rust/target/release/%{target} %{target}))))
</span></code></pre>
<p>Now if any of the Rust code inside the <code>low-level-rust</code> directory
changes, Dune will invoke Cargo to rebuild <code>liblow_level.a</code> before
relinking the OCaml library against the new version. One problem with
the code above is that running <code>cargo build --release</code> will download
any Rust dependencies before building the Rust library. This is a
problem because I intend to release my library on Opam, and when Opam
installs a package it doesn’t allow build commands to access the
network. The solution is to vendor any rust dependencies inside the
project so they are already available when <code>cargo build --release</code>
runs.</p>
<p>To vendor Rust dependencies just run <code>cargo vendor</code> in the Rust
project and create the file <code>.cargo/config.toml</code> at the top level of
the Rust project with the contents:</p>
<pre data-lang="toml" style="background-color:#ffffff;color:#323232;" class="language-toml "><code class="language-toml" data-lang="toml"><span>[source.crates-io]
</span><span style="color:#63a35c;">replace-with </span><span>= </span><span style="color:#183691;">"vendored-sources"
</span><span>
</span><span>[source.vendored-sources]
</span><span style="color:#63a35c;">directory </span><span>= </span><span style="color:#183691;">"vendor"
</span></code></pre>
<p>Finally, to make sure that <code>cargo build</code> doesn’t try to access the
network, I updated the <code>dune</code> file to call <code>cargo build --release --offline</code>.</p>
<p>Testing this out:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>$ dune build
</span><span>File "src/low-level/dune", line 1, characters 0-224:
</span><span> 1 | (rule
</span><span> 2 |  (target liblow_level.a)
</span><span> 3 |  (deps
</span><span> 4 |   (source_tree low-level-rust))
</span><span> 5 |  (action
</span><span> 6 |   (progn
</span><span> 7 |    (chdir
</span><span> 8 |     low-level-rust
</span><span> 9 |     (run cargo build --release --offline))
</span><span>10 |    (run mv low-level-rust/target/release/%{target} %{target}))))
</span><span>error: no matching package named `cpal` found
</span><span>location searched: registry `crates-io`
</span><span>required by package `low_level v0.1.0
</span><span>(/Users/s/src/llama/_build/default/src/low-level/low-level-rust)`
</span><span>As a reminder, you're using offline mode (--offline) which can sometimes
</span><span>cause surprising resolution failures, if this error is too confusing you
</span><span>may wish to retry without the offline flag.
</span></code></pre>
<p>Cargo claims that the <code>cpal</code> package can’t be found. This is
surprising because the vendored copy of <code>cpal</code> has definitely been
copied into the <code>_build</code> directory:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>$ ls _build/default/src/low-level/low-level-rust/vendor/cpal/
</span><span>examples  CHANGELOG.md  Cargo.toml  Dockerfile  README.md
</span><span>src       Cargo.lock    Cross.toml  LICENSE     build.rs
</span></code></pre>
<p>After poking around a bit I noticed that the <code>.cargo/config.toml</code>
wasn’t getting copied into the <code>_build</code> directory which meant that
Cargo was ignoring the vendored libraries.
It turns out that directories beginning with a <code>.</code> or <code>_</code> are ignored
when recursively copying directories specified with <code>source_tree</code>.
There’s even an <a href="https://github.com/ocaml/dune/issues/7135">issue on Dune’s github</a>
where others have run into the same problem.</p>
<p>The documentation for <code>source_tree</code> doesn’t mention this behaviour
because it’s just the default behaviour for which files in a directory
are ignored in general (it affects more that just <code>source_tree</code>). This behaviour
can be adjusted by placing a <code>dune</code> file inside the Rust project with
contents:</p>
<pre data-lang="dune" style="background-color:#ffffff;color:#323232;" class="language-dune "><code class="language-dune" data-lang="dune"><span>(dirs :standard .cargo)
</span></code></pre>
<p>…which adds the <code>.cargo</code> directory to the default set of directories to not ignore.</p>
<p>I understand wanting to avoid copying some hidden directories, such as
<code>.git</code> or <code>_build</code>. My issue with this UX is that if you’re learning
Dune by using it and reading the docs for the relevant section as you
go, I don’t see how a situation like mine could have been
avoided. There’s a layer of indirection between specifying a directory
dependency with <code>source_tree</code> and configuring which directories are
copied to <code>_build</code> with the <code>(dirs ...)</code> stanza and unless you’re
already well versed in Dune you won’t realize that if you need to copy
a file beginning with <code>.</code> or <code>_</code> you need to configure Dune to allow
it. I suspect many people who try to include a Rust library inside a
Dune project run into this problem, then check the docs for
<code>source_tree</code> and find no useful information, and get stuck.</p>
<p>As a response to this I’ve added a <a href="https://dune.readthedocs.io/en/stable/faq.html#files-and-directories-whose-names-begin-with-period-are-ignored-by-source-tree">section to Dune’s
FAQ</a>
about this specific issue so hopefully when people get stuck on this
issue in the future they can find help online.</p>
<h3><a href="https://www.gridbugs.org/rss.xml#the-obvious-choice-of-package-for-reading-wav-files-crashes-when-reading-wav-files" class="zola-anchor" aria-label="Anchor link for: the-obvious-choice-of-package-for-reading-wav-files-crashes-when-reading-wav-files">The obvious choice of package for reading <code>.wav</code> files crashes when reading <code>.wav</code> files</a></h3>
<p>I wanted to load some audio samples from <code>.wav</code> files and decided to try out
<a href="https://github.com/savonet/ocaml-mm">ocaml-mm</a> which seemed like the
obvious choice for working with media files. To learn its API I wrote
some code that reads a <code>.wav</code> file and prints its sample rate:</p>
<pre data-lang="ocaml" style="background-color:#ffffff;color:#323232;" class="language-ocaml "><code class="language-ocaml" data-lang="ocaml"><span style="font-weight:bold;color:#a71d5d;">let </span><span style="color:#0086b3;">() </span><span style="font-weight:bold;color:#a71d5d;">=
</span><span>  </span><span style="font-weight:bold;color:#a71d5d;">let </span><span style="color:#0086b3;">wav_file </span><span style="font-weight:bold;color:#a71d5d;">= new </span><span>Mm.Audio.IO.Reader.of_wav_file </span><span style="color:#183691;">"./cymbal.wav" </span><span style="font-weight:bold;color:#a71d5d;">in
</span><span>  </span><span style="font-weight:bold;color:#a71d5d;">let </span><span style="color:#0086b3;">sample_rate </span><span style="font-weight:bold;color:#a71d5d;">=</span><span> wav_file#sample_rate </span><span style="font-weight:bold;color:#a71d5d;">in
</span><span>  print_endline (Printf.sprintf </span><span style="color:#183691;">"sample_rate: %d"</span><span> sample_rate)
</span></code></pre>
<p>It printed <code>sample_rate: 44100</code> as expected. Next let’s read those samples from the file:</p>
<pre data-lang="ocaml" style="background-color:#ffffff;color:#323232;" class="language-ocaml "><code class="language-ocaml" data-lang="ocaml"><span style="font-weight:bold;color:#a71d5d;">let </span><span style="color:#0086b3;">() </span><span style="font-weight:bold;color:#a71d5d;">=
</span><span>  </span><span style="font-weight:bold;color:#a71d5d;">let </span><span style="color:#0086b3;">wav_file </span><span style="font-weight:bold;color:#a71d5d;">= new </span><span>Mm.Audio.IO.Reader.of_wav_file </span><span style="color:#183691;">"./cymbal.wav" </span><span style="font-weight:bold;color:#a71d5d;">in
</span><span>  </span><span style="font-weight:bold;color:#a71d5d;">let </span><span style="color:#0086b3;">buffer </span><span style="font-weight:bold;color:#a71d5d;">= </span><span>Mm.Audio.create </span><span style="color:#0086b3;">2 10000
</span><span>  </span><span style="font-weight:bold;color:#a71d5d;">let</span><span> _ </span><span style="font-weight:bold;color:#a71d5d;">=</span><span> wav_file#read buffer </span><span style="color:#0086b3;">0 1 </span><span style="font-weight:bold;color:#a71d5d;">in
</span><span>  </span><span style="color:#0086b3;">()
</span></code></pre>
<p>This didn’t work:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>Fatal error: exception File "src/audio.ml", line 1892, characters 21-27: Assertion failed
</span></code></pre>
<p>That failed assertion is:</p>
<pre data-lang="ocaml" style="background-color:#ffffff;color:#323232;" class="language-ocaml "><code class="language-ocaml" data-lang="ocaml"><span style="font-weight:bold;color:#a71d5d;">match</span><span> sample_size </span><span style="font-weight:bold;color:#a71d5d;">with
</span><span>  </span><span style="font-weight:bold;color:#a71d5d;">| </span><span style="color:#0086b3;">16 </span><span>-&gt; S16LE.to_audio sbuf </span><span style="color:#0086b3;">0</span><span> buf ofs len
</span><span>  </span><span style="font-weight:bold;color:#a71d5d;">| </span><span style="color:#0086b3;">8 </span><span>-&gt; U8.to_audio sbuf </span><span style="color:#0086b3;">0</span><span> buf ofs len
</span><span>  </span><span style="font-weight:bold;color:#a71d5d;">| </span><span style="color:#0086b3;">_ </span><span>-&gt; </span><span style="font-weight:bold;color:#a71d5d;">assert </span><span style="color:#0086b3;">false
</span></code></pre>
<p>My test file used 24-bit samples but I can probably live with 16-bit samples:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>$ ffmpeg -i cymbal.wav -af "aformat=s16:sample_rates=44100" cymbal-16bit.wav
</span><span>$ file cymbal-16bit.wav
</span><span>cymbal-16bit.wav: RIFF (little-endian) data, WAVE audio, Microsoft PCM, 16 bit, mono 44100 Hz
</span></code></pre>
<p>After updating the code to load the new file:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>Fatal error: exception Mm_audio.Audio.IO.Invalid_file
</span></code></pre>
<p>At this point I gave up on <code>mm</code> and solved the problem in Rust
instead. I developed the first version of my synthesizer library
during a hackathon and didn’t have time to debug <code>mm</code>. I’d
already done the work to set up Rust interoperability for this project
so it was very quick to extend my Rust library <code>low_level</code> to read
<code>.wav</code> files using the Rust library <a href="https://crates.io/crates/hound">hound</a>.</p>
<p>This worked well except I ran into an issue copying the audio data from Rust to OCaml because…</p>
<h3><a href="https://www.gridbugs.org/rss.xml#transferring-an-array-of-floats-from-rust-to-ocaml-produced-a-broken-array-this-is-now-fixed" class="zola-anchor" aria-label="Anchor link for: transferring-an-array-of-floats-from-rust-to-ocaml-produced-a-broken-array-this-is-now-fixed">Transferring an array of floats from Rust to OCaml produced a broken array (this is now fixed!)</a></h3>
<p>While adding <code>.wav</code> support to my Rust library I ran into an
interesting bug in <a href="https://crates.io/crates/ocaml"><code>ocaml-rs</code></a> - the
Rust library for ergonomically calling from OCaml into Rust. My
library reads all the samples from a <code>.wav</code> file and makes them
available to OCaml as a <code>float array</code>, but I was noticing that when
accessing the array in OCaml, all the values were zero.</p>
<p>A simple repro for this bug is this Rust function:</p>
<pre data-lang="rust" style="background-color:#ffffff;color:#323232;" class="language-rust "><code class="language-rust" data-lang="rust"><span>#[ocaml::func]
</span><span style="font-weight:bold;color:#a71d5d;">pub fn </span><span style="font-weight:bold;color:#795da3;">make_float_array</span><span>() -&gt; </span><span style="color:#0086b3;">Vec</span><span>&lt;</span><span style="font-weight:bold;color:#a71d5d;">f32</span><span>&gt; {
</span><span>    vec![</span><span style="color:#0086b3;">0.0</span><span>, </span><span style="color:#0086b3;">1.0</span><span>, </span><span style="color:#0086b3;">2.0</span><span>]
</span><span>}
</span></code></pre>
<p>Thanks to <code>ocaml-rs</code> magic this can be referred to in OCaml as:</p>
<pre data-lang="ocaml" style="background-color:#ffffff;color:#323232;" class="language-ocaml "><code class="language-ocaml" data-lang="ocaml"><span style="font-weight:bold;color:#a71d5d;">external </span><span>make_float_array : </span><span style="font-weight:bold;color:#a71d5d;">unit </span><span>-&gt; </span><span style="font-weight:bold;color:#a71d5d;">float array = </span><span style="color:#183691;">"make_float_array"
</span></code></pre>
<p>I found that I could iterate over this array with functions like
<code>Array.to_list</code> and it would work as expected but if I directly
accessed an element of the array with <code>Array.get</code> the result would
always be zero.</p>
<p>OCaml has a special way of representing arrays of floats in
memory. Usually floats are boxed in OCaml, but when they appear in an
array they are unboxed and packed contiguously in memory. <code>ocaml-rs</code>
was handling this correctly for double-precision floats but not for
single-precision floats. I made a
<a href="https://github.com/zshipko/ocaml-rs/pull/144">PR</a> and the bug is now
fixed.</p>
<h3><a href="https://www.gridbugs.org/rss.xml#adding-inline-tests-to-a-library-requires-adding-over-20-runtime-dependencies" class="zola-anchor" aria-label="Anchor link for: adding-inline-tests-to-a-library-requires-adding-over-20-runtime-dependencies">Adding inline tests to a library requires adding over 20 (runtime) dependencies</a></h3>
<p>I wanted a MIDI parser so I could <a href="https://www.youtube.com/watch?v=A8a1Dem2eKs">play other people’s songs on my
synth</a> and I elected to
write my own rather than chance the one in <code>ocaml-mm</code> (fool me once,
etc). This turned out to be really interesting and I ended up
publishing a <a href="https://ocaml.org/p/llama_midi/latest">standalone library just for parsing MIDI
data</a>.</p>
<p>MIDI encodes integers in a variable number of bytes with a special
value denoting the final byte of the integer (kind of like strings in
C). This was a little complicated so I wrote some tests:</p>
<pre data-lang="ocaml" style="background-color:#ffffff;color:#323232;" class="language-ocaml "><code class="language-ocaml" data-lang="ocaml"><span style="font-weight:bold;color:#a71d5d;">let </span><span style="font-weight:bold;color:#795da3;">parse_midi_int </span><span>a i </span><span style="font-weight:bold;color:#a71d5d;">=</span><span> ...
</span><span>
</span><span style="font-weight:bold;color:#a71d5d;">let%</span><span>test_module _ </span><span style="font-weight:bold;color:#a71d5d;">=
</span><span>  (</span><span style="font-weight:bold;color:#a71d5d;">module struct
</span><span>    </span><span style="font-style:italic;color:#969896;">(* Run the parser on an array of ints. *)
</span><span>    </span><span style="font-weight:bold;color:#a71d5d;">let </span><span style="font-weight:bold;color:#795da3;">make </span><span>ints </span><span style="font-weight:bold;color:#a71d5d;">=
</span><span>      run parse_midi_int (Array.map char_of_int (Array.of_list ints))
</span><span>
</span><span>    </span><span style="font-weight:bold;color:#a71d5d;">let%</span><span>test _ </span><span style="font-weight:bold;color:#a71d5d;">= </span><span>Int.equal </span><span style="color:#0086b3;">0 </span><span style="font-weight:bold;color:#a71d5d;">@@</span><span> make [ </span><span style="color:#0086b3;">0 </span><span>]
</span><span>    </span><span style="font-weight:bold;color:#a71d5d;">let%</span><span>test _ </span><span style="font-weight:bold;color:#a71d5d;">= </span><span>Int.equal </span><span style="color:#0086b3;">0x40 </span><span style="font-weight:bold;color:#a71d5d;">@@</span><span> make [ </span><span style="color:#0086b3;">0x40 </span><span>]
</span><span>    </span><span style="font-weight:bold;color:#a71d5d;">let%</span><span>test _ </span><span style="font-weight:bold;color:#a71d5d;">= </span><span>Int.equal </span><span style="color:#0086b3;">0x2000 </span><span style="font-weight:bold;color:#a71d5d;">@@</span><span> make [ </span><span style="color:#0086b3;">0xC0</span><span>; </span><span style="color:#0086b3;">0x00 </span><span>]
</span><span>    </span><span style="font-weight:bold;color:#a71d5d;">let%</span><span>test _ </span><span style="font-weight:bold;color:#a71d5d;">= </span><span>Int.equal </span><span style="color:#0086b3;">0x1FFFFF </span><span style="font-weight:bold;color:#a71d5d;">@@</span><span> make [ </span><span style="color:#0086b3;">0xFF</span><span>; </span><span style="color:#0086b3;">0xFF</span><span>; </span><span style="color:#0086b3;">0x7F </span><span>]
</span><span>    </span><span style="font-weight:bold;color:#a71d5d;">let%</span><span>test _ </span><span style="font-weight:bold;color:#a71d5d;">= </span><span>Int.equal </span><span style="color:#0086b3;">0x200000 </span><span style="font-weight:bold;color:#a71d5d;">@@</span><span> make [ </span><span style="color:#0086b3;">0x81</span><span>; </span><span style="color:#0086b3;">0x80</span><span>; </span><span style="color:#0086b3;">0x80</span><span>; </span><span style="color:#0086b3;">0x00 </span><span>]
</span><span>    </span><span style="font-weight:bold;color:#a71d5d;">let%</span><span>test _ </span><span style="font-weight:bold;color:#a71d5d;">= </span><span>Int.equal </span><span style="color:#0086b3;">0xFFFFFFF </span><span style="font-weight:bold;color:#a71d5d;">@@</span><span> make [ </span><span style="color:#0086b3;">0xFF</span><span>; </span><span style="color:#0086b3;">0xFF</span><span>; </span><span style="color:#0086b3;">0xFF</span><span>; </span><span style="color:#0086b3;">0x7F </span><span>]
</span><span>  </span><span style="font-weight:bold;color:#a71d5d;">end</span><span>)
</span></code></pre>
<p>These tests were defined right next to the logic for parsing MIDI
ints. I did it this way so that I wouldn’t need to expose the int
parser outside this module and to make it easy to look at the code and
the tests at the same time.</p>
<p>I followed
<a href="https://dune.readthedocs.io/en/stable/tests.html#inline-tests">Dune’s documentation</a>
for writing tests with
<a href="https://ocaml.org/p/ppx_inline_test/latest"><code>ppx_inline_test</code></a>
and it worked well. As I now need the <code>ppx_inline_test</code> package to run my tests, I added it to my project’s dependencies:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span> "ppx_inline_test" {with-test}
</span></code></pre>
<p>The <code>{with-test}</code> tells Opam that this dependency is only needed to
build the package’s tests - not to build the package itself.</p>
<p>The next time I tried installing my library I got an unexpected error:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>File "test/dune", line 6, characters 7-22:
</span><span>6 |   (pps ppx_inline_test))
</span><span>           ^^^^^^^^^^^^^^^
</span><span>Error: Library "ppx_inline_test" not found.
</span></code></pre>
<p>The machine I was using didn’t have the <code>ppx_inline_test</code> package
installed but I wasn’t trying to run my tests - just install the
library. It turns out that packages that do pre-processing like
<code>ppx_inline_test</code> cannot be marked as <code>with-test</code>; they must be
unconditional dependencies. This is because preprocessor directives
like <code>let%test</code> are not valid OCaml syntax, and the OCaml compiler is
unable to parse the files until an external preprocessor has processed
the files to remove all the preprocessor directives.</p>
<p>I was hesitant to make <code>ppx_inline_test</code> an unconditional dependency
of my MIDI parsing library because my library currently didn’t have any
dependencies at all. From a supply-chain security point of view and also in
my endless pursuit of minimalism it seemed  shame to depend on
<code>ppx_inline_test</code> unconditionally, since the transitive dependency
closure of <code>ppx_inline_test</code> is over 20 packages:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>base
</span><span>csexp
</span><span>dune-configurator
</span><span>jane-street-headers
</span><span>jst-config
</span><span>ocaml-compiler-libs
</span><span>ppx_assert
</span><span>ppx_base
</span><span>ppx_cold
</span><span>ppx_compare
</span><span>ppx_derivers
</span><span>ppx_enumerate
</span><span>ppx_globalize
</span><span>ppx_hash
</span><span>ppx_here
</span><span>ppx_inline_test
</span><span>ppx_optcomp
</span><span>ppx_sexp_conv
</span><span>ppxlib
</span><span>sexplib0
</span><span>stdio
</span><span>stdlib-shims
</span><span>time_now
</span></code></pre>
<p>That’s a lot to download and build just to get the logic for disabling
~10 lines of tests in a MIDI parser.</p>
<p>In the end I did what many libraries do and just exposed the internals
of my MIDI parser in its public interface inside of a module named
<code>For_test</code>, and then added a separate package that depends on both my
MIDI parser and <code>ppx_inline_test</code> and moved the tests there.</p>
<p>I’m used to Rust where I could have written:</p>
<pre data-lang="rust" style="background-color:#ffffff;color:#323232;" class="language-rust "><code class="language-rust" data-lang="rust"><span style="font-weight:bold;color:#a71d5d;">fn </span><span style="font-weight:bold;color:#795da3;">parse_midi_int</span><span>(...) { </span><span style="font-weight:bold;color:#a71d5d;">... </span><span>}
</span><span>
</span><span>#[test]
</span><span style="font-weight:bold;color:#a71d5d;">fn </span><span style="font-weight:bold;color:#795da3;">test_parse_midi_int </span><span>() { </span><span style="font-weight:bold;color:#a71d5d;">... </span><span>}
</span></code></pre>
<p>…and any external libraries used in the test only need to be
installed when running the test.</p>
<p>This is easier to do in Rust than in OCaml because Cargo is a build
system, package manager, <em>and</em> preprocessor, so it can impose a syntax
for denoting test code, remove tests when compiling code normally,
and only require test dependencies when actually running the
tests. This is harder in OCaml because preprocessing is handled by
external programs. Neither Dune nor the OCaml compiler itself know
what to do with preprocessor directives and require external packages
to be installed just to know how to ignore them.</p>
<p>I think there’s an opportunity to reduce some of the friction around
testing in OCaml and Dune, especially since security is one of the main selling
points of OCaml. The lower the barrier for writing tests, the more
tests people will write.</p>
<h3><a href="https://www.gridbugs.org/rss.xml#dune-can-generate-opam-files-but-requires-a-workaround-for-adding-the-available-field" class="zola-anchor" aria-label="Anchor link for: dune-can-generate-opam-files-but-requires-a-workaround-for-adding-the-available-field">Dune can generate <code>.opam</code> files but requires a workaround for adding the <code>available</code> field</a></h3>
<p>My library only works on <code>x86_64</code> and <code>arm64</code> architectures, I think
because of its Rust dependencies (I haven’t really investigated this).
OCaml is supported on many architectures, so to prevent llama from
being installed on incompatible computers, I manually added this line the
package manifest that I released to the Opam repository:</p>
<pre data-lang="diff" style="background-color:#ffffff;color:#323232;" class="language-diff "><code class="language-diff" data-lang="diff"><span> ...
</span><span> license: "MIT"
</span><span> homepage: "https://github.com/gridbugs/llama"
</span><span> bug-reports: "https://github.com/gridbugs/llama/issues"
</span><span style="background-color:#eaffea;font-weight:bold;color:#55a532;">+</span><span style="background-color:#eaffea;color:#323232;">available: arch != "arm32" &amp; arch != "ppc64" &amp; arch != "s390x" &amp; arch != "x86_32"
</span><span> depends: [
</span><span>   "dune" {&gt;= "3.0"}
</span><span>   "llama_core" {= version}
</span><span> ...
</span></code></pre>
<p>Llama’s Opam manifests are generated by Dune. The metadata in its Opam
manifests are present in its <code>dune-project</code> file as:</p>
<pre data-lang="dune" style="background-color:#ffffff;color:#323232;" class="language-dune "><code class="language-dune" data-lang="dune"><span>...
</span><span>(</span><span style="font-weight:bold;color:#a71d5d;">source</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">github</span><span> gridbugs/llama))
</span><span>(</span><span style="font-weight:bold;color:#a71d5d;">license</span><span> MIT)
</span><span>(</span><span style="font-weight:bold;color:#a71d5d;">package
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">name</span><span> llama)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">synopsis </span><span style="color:#183691;">"Language for Live Audio Module Arrangement"</span><span>)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">description </span><span style="color:#183691;">"Libraries for declaratively building software-defined modular synthesizers"</span><span>)
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">depends
</span><span>  (llama_core (</span><span style="font-weight:bold;color:#a71d5d;">=</span><span> :version))
</span><span>  ...
</span></code></pre>
<p>This looked to me like a one-to-one translation from the <code>dune-project</code> file to the Opam package manifest, so I assumed I could add an <code>available</code> field to the package’s description like:</p>
<pre data-lang="dune" style="background-color:#ffffff;color:#323232;" class="language-dune "><code class="language-dune" data-lang="dune"><span>(</span><span style="font-weight:bold;color:#a71d5d;">package
</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">name</span><span> llama)
</span><span> (available (</span><span style="font-weight:bold;color:#a71d5d;">and</span><span> (</span><span style="font-weight:bold;color:#a71d5d;">&lt;&gt;</span><span> :arch arm32) (</span><span style="font-weight:bold;color:#a71d5d;">&lt;&gt;</span><span> :arch ppc64) (</span><span style="font-weight:bold;color:#a71d5d;">&lt;&gt;</span><span> :arch s390x) (</span><span style="font-weight:bold;color:#a71d5d;">&lt;&gt;</span><span> :arch x86_32)))
</span><span> ...
</span></code></pre>
<p>But this is not supported:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>File "dune-project", line 31, characters 2-11:
</span><span>31 |  (available (and (&lt;&gt; :arch arm32) (&lt;&gt; :arch ppc64) (&lt;&gt; :arch s390x) (&lt;&gt; :arch x86_32)))
</span><span>Error: Unknown field available
</span></code></pre>
<p>I found this surprising as it really seemed like it was a one-to-one
translation. It felt like Dune’s UI had trained me to expect that it
works a certain way, only then to reveal that it actually works a
different way. The <a href="https://dune.readthedocs.io/en/stable/howto/opam-file-generation.html">docs for generating Opam
files</a>
don’t specify that the <code>available</code> field is supported and at first I
thought it was just not yet implemented. There is a <a href="https://github.com/ocaml/dune/issues/7059">github
issue</a> to support
additional fields, but from the discussion there it’s apparent that the
missing fields are omitted intentionally. There is a policy of not
adding fields that are only used by Opam, and Dune doesn’t currently
have an analog of this feature.</p>
<p>There is a workaround to add the <code>available</code> field to
the generated Opam file using an “Opam Template”. If I had read the
<a href="https://dune.readthedocs.io/en/stable/howto/opam-file-generation.html">generating Opam files
docs</a>
more carefully I would have noticed:</p>
<blockquote>
<p><code>(package)</code> stanzas do not support all opam fields or complete
syntax for dependency specifications. If the package you are
adapting requires this, keep the corresponding opam fields in a
<code>pkg.opam.template</code> file.</p>
</blockquote>
<p>So I just ended up making a <code>llama.opam.template</code> file with the contents:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>available: arch != "arm32" &amp; arch != "ppc64" &amp; arch != "s390x" &amp; arch != "x86_32"
</span></code></pre>
<h3><a href="https://www.gridbugs.org/rss.xml#if-some-but-not-all-of-the-interdependent-packages-in-a-project-are-released-opam-can-t-solve-the-project-s-dependencies" class="zola-anchor" aria-label="Anchor link for: if-some-but-not-all-of-the-interdependent-packages-in-a-project-are-released-opam-can-t-solve-the-project-s-dependencies">If some (but not all) of the interdependent packages in a project are released, Opam can’t solve the project’s dependencies</a></h3>
<p>I released my synthesizer library on Opam. It was made up of 3 packages:</p>
<ul>
<li><code>llama_core</code> defines the data types for representing audio streams and contains a library of sound effects and filters</li>
<li><code>llama</code> lets you play audio streams through your speakers</li>
<li><code>llama_interactive</code> lets you use your computer’s keyboard and mouse to control the synthesizer</li>
</ul>
<p>There’s also an unreleased package <code>llama_tests</code> that contains all the
tests. As described above, tests are in a separate package to avoid
adding unconditional testing dependencies to other packages.</p>
<p>The MIDI decoder was originally part of <code>llama_core</code> but I wanted to
split it out into a new package <code>llama_midi</code> since it’s useful on its
own outside of the context of the synthesizer library. I created the
new package but didn’t release it to the Opam repository right
away. Around this time I tried setting up the project on a new
computer, and this is when my problems started.</p>
<p>Following the convention for OCaml projects, I put an Opam package manifest for each package in the project in the root directory of the project.</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>$ ls
</span><span>...
</span><span>llama.opam
</span><span>llama_core.opam
</span><span>llama_interactive.opam
</span><span>llama_midi.opam
</span><span>llama_tests.opam
</span><span>...
</span></code></pre>
<p>On my new computer I want to install all the dependencies of all the packages in this directory which will allow me to build the project with Dune.</p>
<p>Opam supports running <code>opam install &lt;dir&gt;</code> which will install all the
packages with package manifests in <code>&lt;dir&gt;</code>, along with all their
dependencies. If you just want the dependencies and not the packages
themselves you can pass <code>--deps-only</code>. To set up the project on my new
computer, I thought the right thing to do would be running <code>opam install . --deps-only</code> from the root directory of the project.</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>$ opam install . --deps-only
</span><span>[ERROR] Package conflict!
</span><span>  * Missing dependency:
</span><span>    - llama_midi &gt;= 0.0.1
</span><span>    no matching version
</span><span>
</span><span>No solution found, exiting
</span></code></pre>
<p>This was frustrating as <code>llama_midi.opam</code> was right there. Remember
that <code>llama_midi</code> was a new package, and not yet released to the Opam
repo. Maybe Opam was trying to find <code>llama_midi</code> in the Opam repo and
failing because it’s not released yet.</p>
<p>Next I tried running <code>opam pin</code>. This does a similar thing to <code>opam install</code> except it associates local packages with the path to their
source code on disk. This shouldn’t be necessary in this case; I don’t
even want to install <code>llama_midi</code> - just the dependencies of my local
packages. I tried it anyway:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>$ opam pin .
</span><span>This will pin the following packages: llama, llama_core, llama_interactive,
</span><span>llama_midi, llama_tests. Continue? [Y/n] Y
</span><span>Processing  3/5: [llama: git] [llama_core: git] [llama_interactive: git]
</span><span>llama is now pinned to git+file:///.../llama#main (version 0.0.1)
</span><span>llama_core is now pinned to git+file:///.../llama#main (version 0.0.1)
</span><span>llama_interactive is now pinned to git+file:///.../llama#main (version 0.0.1)
</span><span>Package llama_midi does not exist, create as a NEW package? [Y/n] Y
</span><span>llama_midi is now pinned to git+file:///.../llama#main (version ~dev)
</span><span>Package llama_tests does not exist, create as a NEW package? [Y/n] Y
</span><span>llama_tests is now pinned to git+file:///.../llama#main (version ~dev)
</span><span>[ERROR] Package conflict!
</span><span>  * Missing dependency:
</span><span>    - llama_midi &gt;= 0.0.1
</span><span>    no matching version
</span><span>
</span><span>[NOTE] Pinning command successful, but your installed packages may be out of sync.
</span></code></pre>
<p>Same error as before, only this time it happened to print the version
number of each pinned package. Notice how for the three released
packages it says <code>(version 0.0.1)</code> but for the unreleased <code>llama_midi</code>
and <code>llama_tests</code> it says <code>(version ~dev)</code>. This tells me that Opam is
trying to install <code>0.0.1</code> of all the released packages, and version
<code>~dev</code> of the unreleased packages. <code>0.0.1</code> happens to be the version
number I used when releasing <code>llama_core</code>, <code>llama</code>, and
<code>llama_interactive</code>.</p>
<p>Since the initial release, I split <code>llama_midi</code> out of <code>llama_core</code>,
and made <code>llama_core</code> depend on the new <code>llama_midi</code> package. I want
to keep the versions of all the llama packages tied together, so when
one of the llama packages depends on another, I declare that
dependency as:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span># llama_core.opam
</span><span>...
</span><span>depends: [
</span><span>  "llama_midi" {= version}
</span><span>  ...
</span><span>]
</span></code></pre>
<p>The <code>{= version}</code> tells Opam that any given version of <code>llama_core</code>
depends on the <code>llama_midi</code> package with the identical version
number. And the error I’m seeing is because Opam is trying to install
version <code>0.0.1</code> of <code>llama_core</code>, but since <code>llama_midi</code> has never been
released, the only version Opam knows about is the synthetic version
number <code>~dev</code>.</p>
<p>But why was Opam installing version <code>0.0.1</code> of <code>llama_core</code> in the
first place?  Unlike some (most?) other package managers, Opam package
manifests don’t contain the version number of the package they
describe. The only place where package version numbers are recorded is
as part of a directory name inside the Opam package repository, where
manifests are stored in directories named like <code>&lt;package&gt;.&lt;version&gt;</code>
(<a href="https://github.com/ocaml/opam-repository/tree/master/packages/llama_core">for
example</a>
<code>llama_core.0.0.1</code>).  My expectation was that since it’s being
installed as a local package from a local Opam package manifest file,
<code>llama_core</code> would be given the version number <code>~dev</code>. The local
package file is clearly being read because Opam is trying to respect
the fact that <code>llama_core</code> now depends on <code>llama_midi</code>, but Opam is
still using the version number of the released version of
<code>llama_core</code>: <code>0.0.1</code>. That version number isn’t stored anywhere in
llama’s git repo, so Opam must be using information from its package
repository to choose this version number, and then it can’t solve
dependencies because there is no version of <code>llama_midi</code> with the same
version number.</p>
<p>In other words, if none of the packages in my project had been
released then I wouldn’t have this problem as Opam would consider each
package to have the version number <code>~dev</code>. If all the packages in my
project had been released then I wouldn’t have this problem as Opam
would look up the released versions of the packages in its package
repo and find matching version numbers for each package. This problem
only happens when some but not all of the interdependent packages in a
project have been released.</p>
<p>Maybe I can work around this by forcing Opam to install the
local packages with a specified version number rather than taking the
version numbers from the package repository.
I learnt that it’s possible to override the version number of packages installed with <code>opam pin</code> by passing <code>--with-version</code>.
I tried installing all the local packages with version number <code>sigh</code> as I was getting quite exasperated.</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>opam pin . --with-version sigh
</span><span>...
</span><span>#=== ERROR while compiling llama.sigh =========================================#
</span><span># context     2.1.5 | macos/arm64 | ocaml-base-compiler.4.14.1 | pinned(git+file:///.../llama#main#06deea42efa6b84653be43529daf8aa08dc106
</span><span>68)
</span><span># path        /.../_opam/.opam-switch/build/llama.sigh
</span><span># command     ~/.opam/opam-init/hooks/sandbox.sh build dune build -p llama -j 7 @install
</span><span># exit-code   1
</span><span># env-file    ~/.opam/log/llama-60822-042f19.env
</span><span># output-file ~/.opam/log/llama-60822-042f19.out
</span><span>### output ###
</span><span># error: failed to get `anyhow` as a dependency of package `low_level v0.1.0 (.../_opam/.opam-switch/build/llama.sigh/_build/default/src
</span><span>/low-level/low-level-rust)`
</span><span># [...]
</span><span># Caused by:
</span><span>#   failed to query replaced source registry `crates-io`
</span><span>#
</span><span># Caused by:
</span><span>#   download of config.json failed
</span><span>#
</span><span># Caused by:
</span><span>#   failed to download from `https://index.crates.io/config.json`
</span><span>#
</span><span># Caused by:
</span><span>#   [7] Couldn't connect to server (Failed to connect to index.crates.io port 443 a
</span><span>fter 0 ms: Couldn't connect to server)
</span></code></pre>
<p>That error is because Cargo is trying to download dependencies while
building the Rust component of the <code>llama</code> package from within Opam’s
build sandbox. Earlier in the post I described vendoring all of the
Rust dependencies as they can’t be downloaded when building the
package with Opam, as Opam’s build sandbox doesn’t have internet
access. This vendoring usually takes place in a build script that runs
as a github action. I don’t check in the vendored libraries as it
would bloat the repo, and when developing locally with Dune there is
no need to vendor them (Dune’s build sandbox <em>does</em> have internet
access).</p>
<p>Recall that I don’t even want to install <code>llama</code> with Opam - I
just want to install all the non-local dependencies of the local
packages that make up my project. There may well be a way to do this
but I couldn’t find it and nobody I asked knew how to do it so I just
ended up installing the dependencies by hand. Fortunately
there were only a few. Eventually I released <code>llama_midi</code> and so this
problem went away.</p>
<p>This was the point where I was really starting to question whether
OCaml was the right tool for this project, and for any other project I
want to develop on my own time.  It’s important to me that I can clone
a project on a machine with OCaml installed on it and be up and
running after a command or two, kind of like <code>npm install</code> or <code>cargo run</code> which in my experience tend to “just work”.  The fact that it was
such a headache to do something that I expected to be simple suggested
to me that the philosophy underpinning the UX of Opam is really
different from the way that I tend to approach software
development. Fortunately this won’t be a problem for much longer as
Dune’s package management features are quickly maturing and are
designed with this use case in mind.</p>
<h2><a href="https://www.gridbugs.org/rss.xml#the-happy-path" class="zola-anchor" aria-label="Anchor link for: the-happy-path">The “Happy Path”</a></h2>
<p>I hear from a lot of OCaml developers that tooling works well when you keep to the “Happy
Path” and I tend to agree with this. This refers to the case where all
the code in your project is written in OCaml and you use the default
configurations for everything. Lately I’ve been developing a <a href="https://github.com/gridbugs/climate">CLI
parsing library</a> in OCaml which
sticks to the Happy Path. It’s entirely written in OCaml, doesn’t link
with any external libraries, only depends on third-party packages for
its tests and is compatible with all architectures. So far I haven’t had
any issues with tooling, and even been pleasantly surprised a couple
of times.</p>
<p>Most of the negative experiences from this post happened when I
strayed from the Happy Path into parts of the ecosystem that are less
polished and battle tested, or when my assumptions ran contrary to
those made by tools.</p>
<h2><a href="https://www.gridbugs.org/rss.xml#conclusions" class="zola-anchor" aria-label="Anchor link for: conclusions">Conclusions</a></h2>
<p>This experience taught me that if you go into an OCaml project
expecting the tools to “just work”, you’re probably going to have a
bad time. Expect that the first few times you try to modify a Dune
build configuration that the syntax will be incorrect, and once that’s
fixed expect the configuration to not do what you wanted
in the first place. Expect third-party packages to be buggy and untested around
edge-cases. Expect to get into confusing situations when using Opam to
manage local packages that you’re actively developing. And expect <a href="https://en.wiktionary.org/wiki/yak_shaving">yak
shaves</a> - so many times
when one thing isn’t working correctly I run into a second, unrelated
issue while trying to resolve the first issue.</p>
<p>Normalize complaining about this stuff so that new OCaml users can
correctly set their expectations coming in and don’t get a nasty shock
the first time they leave the Happy Path. And if you find yourself
struggling with the tools, don’t beat yourself up about it. Most OCaml
users struggle. I clearly struggle. Remember, it’s not you - it’s the
tools.</p>
<p>As for my synth library, due to the friction I experienced developing
it in OCaml, and to avoid the future frustration I anticipated if I
continued the project, <a href="https://github.com/gridbugs/caw">I rewrote it in Rust</a>.</p>

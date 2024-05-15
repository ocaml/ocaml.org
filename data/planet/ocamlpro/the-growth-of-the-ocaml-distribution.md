---
title: The Growth of the OCaml Distribution
description: We recently worked on a project to build a binary installer for OCaml,
  inspired from RustUp for Rust. We had to build binary packages of the distribution
  for every OCaml version since 4.02.0, and we were surprised to discover that their
  (compressed) size grew from 18 MB to about 200 MB. This post gi...
url: https://ocamlpro.com/blog/2023_01_02_ocaml_distribution
date: 2023-01-02T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Fabrice Le Fessant\n  "
source:
---

<p></p>
<p>We recently worked on a project to build a binary installer for OCaml,
inspired from <a href="https://rustup.rs">RustUp</a> for Rust. We had to build
binary packages of the distribution for every OCaml version since
4.02.0, and we were surprised to discover that their (compressed) size
grew from 18 MB to about 200 MB. This post gives a survey of our
findings.</p>
<p></p><div>
<strong>Table of contents</strong>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#introduction">Introduction</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#trends">General Trends</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#changes">Causes and Consequences</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#distribution">Inside the OCaml Installation</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#conclusion">Conclusion</a>

</li>
</ul>
<h2>
<a class="anchor"></a>Introduction<a href="https://ocamlpro.com/blog/feed#introduction">&#9875;</a>
          </h2>
<p>One of the strengths of Rust is the ease with which it gets installed
on a new computer in user space: with a simple command copy-pasted
from a website into a terminal, you get all what you need to start
building Rust projects in a few seconds. <a href="https://rustup.rs">Rustup</a>,
and a set of prebuilt packages for many architectures, is the project
that makes all this possible.</p>
<p>OCaml, on the other hand, is a bit harder to install: you need to find
in the documentation the proper way for your operating system to
install <code>opam</code>, find how to create a switch with a compiler version,
and then wait for the compiler to be built and installed. This usually
takes much more time.</p>
<p>As a winter holiday project, we worked on a project similar to Rustup,
providing binary packages for most OCaml distribution versions. It
builds upon our experience of <code>opam</code> and
<a href="https://ocamlpro.github.io/opam-bin/"><code>opam-bin</code></a>, our plugin to
build and share binary packages for <code>opam</code>.</p>
<p>While building binary packages for most versions of the OCaml
distribution, we were surprised to discover that the size of the
binary archive grew from 18 MB to about 200 MB in 10 years.  Though on
many high-bandwidth connexions, it is not a problem, it might become
one when you go far from big towns (and fortunately, we designed our
tool to be able to install from sources in such a case, compromising
the download speed against the installation speed).</p>
<p>We decided it was worth trying to investigate this growth in more
details, and this post is about our early findings.</p>
<h2>
<a class="anchor"></a>General Trends<a href="https://ocamlpro.com/blog/feed#trends">&#9875;</a>
          </h2>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/ocaml-binary-growth-2022.svg">
      <img src="https://ocamlpro.com/blog/assets/img/ocaml-binary-growth-2022.svg" alt="In 10 years, the OCaml Distribution binary archive grew by a factor 10, from 18 MB to 198 MB, corresponding to a growth from 73 MB to 522 MB after installation, and from 748 to 2433 installed files."/>
    </a>
    </p><div class="caption">
      In 10 years, the OCaml Distribution binary archive grew by a factor 10, from 18 MB to 198 MB, corresponding to a growth from 73 MB to 522 MB after installation, and from 748 to 2433 installed files.
    </div>
  
</div>

<p>So, let's have a look at the evolution of the size of the binary OCaml
distribution in more details. Between version 4.02.0 (Aug 2014) and
version 5.0.0 (Dec 2022):</p>
<ul>
<li>
<p>The size of the compressed binary archive grew from from 18 MB to 198 MB</p>
</li>
<li>
<p>The size of the installed binary distribution grew from 73 MB to 522 MB</p>
</li>
<li>
<p>The number of installed files grew from 748 to 2433</p>
</li>
</ul>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/ocaml-sources-growth-2022.svg">
      <img src="https://ocamlpro.com/blog/assets/img/ocaml-sources-growth-2022.svg" alt="The OCaml Distribution source archive was much more stable, with a global growth smaller than 2."/>
    </a>
    </p><div class="caption">
      The OCaml Distribution source archive was much more stable, with a global growth smaller than 2.
    </div>
  
</div>

<p>On the other hand, the source distribution itself was much more stable:</p>
<ul>
<li>
<p>The size of the compressed source archive grew only from 3 MB to 5 MB</p>
</li>
<li>
<p>The size of the sources grew from 14 MB to 26 MB</p>
</li>
<li>
<p>The number of source files grew from 2355 to 4084</p>
</li>
</ul>
<p>For our project, this evolution makes the source distribution
a good alternative to binary distributions for low-bandwidth settings,
especially as OCaml is much faster than Rust at building itself. For
the record, version 5.0.0 takes about 1 minute to build on a 16-core
64GB-RAM computer.</p>
<p>Interestingly, if we plot the total size of the binary distribution,
and the total size with only files that were present in the previous
version, we can notice that the growth is mostly caused by the
increase in size of these existing files, and not by the addition of new
files:</p>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/ocaml-binary-size-2022.svg">
      <img src="https://ocamlpro.com/blog/assets/img/ocaml-binary-size-2022.svg" alt="The growth is
mostly caused by the increase in size of existing files, and not by
the addition of new files."/>
    </a>
    </p><div class="caption">
      The growth is
mostly caused by the increase in size of existing files, and not by
the addition of new files.
    </div>
  
</div>

<h2>
<a class="anchor"></a>Causes and Consequences<a href="https://ocamlpro.com/blog/feed#changes">&#9875;</a>
          </h2>
<p>We tried to identify the main causes of this growth: the growth is
linear most of the time, with sharp increases (and decreases) at some
versions. We plotted the difference in size, for the total size, the
new files, the deleted files and the same files, i.e. the files that
made it from one version to the next one:</p>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/ocaml-binary-size-diff-2022.svg">
      <img src="https://ocamlpro.com/blog/assets/img/ocaml-binary-size-diff-2022.svg" alt="The
difference of size between two versions is not big most of the time,
but some versions exhibit huge increases or decreases."/>
    </a>
    </p><div class="caption">
      The
difference of size between two versions is not big most of the time,
but some versions exhibit huge increases or decreases.
    </div>
  
</div>

<p>Let's have a look at the versions with the highest increases in size:</p>
<ul>
<li>
<p>+86 MB for 4.08.0: though there are a lot of new files (+307), they
only account for 3 MB of additionnal storage. Most of the difference
comes from an increase in size of both compiler libraries (probably
in relation with the use of Menhir for parsing) and of some binaries.
In particular:</p>
<ul>
<li>+13 MB for <code>bin/ocamlobjinfo.byte</code> (2_386_046 -&gt; 16_907_776)
</li>
<li>+12 MB for <code>bin/ocamldep.byte</code> (2_199_409 -&gt; 15_541_022)
</li>
<li>+6 MB for <code>bin/ocamldebug</code> (1_092_173 -&gt; 7_671_300)
</li>
<li>+6 MB for <code>bin/ocamlprof.byte</code> (630_989 -&gt; 7_043_717)
</li>
<li>+6 MB for <code>lib/ocaml/compiler-libs/parser.cmt</code> (2_237_513 -&gt; 9_209_256)
</li>
</ul>
</li>
<li>
<p>+74 MB for 4.03.0: again, though there are a lot of new files (+475,
mostly in <code>compiler-libs</code>), they only account for 11 MB of
additionnal storage, and a large part is compensated by the removal
of <code>ocamlbuild</code> from the distribution, causing a gain of 7 MB.</p>
<p>Indeed, most the increase in size is probably caused by the compilation with
debug information (option <code>-g</code>), that increases considerably the size of
all executables, for example:</p>
<ul>
<li>+12 MB for <code>bin/ocamlopt</code> (2_016_697 -&gt; 15_046_969)
</li>
<li>+9 MB for <code>bin/ocaml</code> (1_833_357 -&gt; 11_574_555)
</li>
<li>+8 MB for <code>bin/ocamlc</code> (1_748_717 -&gt; 11_070_933)
</li>
<li>+8 MB for <code>lib/ocaml/expunge</code> (1_662_786 -&gt; 10_672_805)
</li>
<li>+7 MB for <code>lib/ocaml/compiler-libs/ocamlcommon.cma</code> (1_713_947 -&gt; 8_948_807)
</li>
</ul>
</li>
<li>
<p>+72 MB for 4.11.0: again, the increase almost only comes from
existing files. For example:</p>
<ul>
<li>+16 MB for <code>bin/ocamldebug</code> (8_170_424 -&gt; 26_451_049)
</li>
<li>+6 MB for <code>bin/ocamlopt.byte</code> (21_895_130 -&gt; 28_354_131)
</li>
<li>+5 MB for <code>lib/ocaml/extract_crc</code> (659_967 -&gt; 6_203_791)
</li>
<li>+5 MB for <code>bin/ocaml</code> (17_074_577 -&gt; 22_388_774)
</li>
<li>+5 MB for <code>bin/ocamlobjinfo.byte</code> (17_224_939 -&gt; 22_523_686)
</li>
</ul>
<p>Again, the increase is probably related to adding more debug information in
the executable (there is a specific PR on <code>ocamldebug</code> for that, and for all
executables more debug info is available for each allocation);</p>
</li>
<li>
<p>+48 MB for 5.0.0: a big difference in storage is not surprising for
a change in a major version, but actually half of the difference
just comes from an increase of 23 MB of <code>bin/ocamldoc</code>;</p>
</li>
<li>
<p>+34 MB for 4.02.3: this one is worth noting, as it comes at a minor
version change. The increase is mostly caused by the addition of 402
new files, corresponding to <code>cmt/cmti</code> files for the <code>stdlib</code> and
<code>compiler-libs</code></p>
</li>
</ul>
<p>We could of course study some other versions, but understanding the
root causes of most of these changes would require to go deeper than
what we can in such a blog post. Yet, these figures give good hints
for experts on which versions to start investigating with.</p>
<h2>
<a class="anchor"></a>Inside the OCaml Installation<a href="https://ocamlpro.com/blog/feed#distribution">&#9875;</a>
          </h2>
<p>Before concluding, it might also be worth studying which parts of the
OCaml Installation take most of the space. 5.0.0 is a good candidate
for such a study, as libraries have been moved to separate
directories, instead of all being directly stored in <code>lib/ocaml</code>.</p>
<p>Here is a decomposition of the OCaml Installation:</p>
<ul>
<li>Total: 529 MB
<ul>
<li><code>share</code>: 1 MB
</li>
<li><code>man</code>: 4 MB
</li>
<li><code>bin</code>: 303 MB
</li>
<li><code>lib/ocaml</code>: 223 MB
<ul>
<li><code>compiler-libs</code>: 134 MB
</li>
<li><code>expunge</code>: 20 MB
</li>
</ul>
</li>
</ul>
</li>
</ul>
<p>As we can see, a large majority of the space is used by
executables. For example, all these ones are above 10 MB:</p>
<ul>
<li>28 MB	<code>ocamldoc</code>
</li>
<li>26 MB	<code>ocamlopt.byte</code>
</li>
<li>25 MB	<code>ocamldebug</code>
</li>
<li>21 MB	<code>ocamlobjinfo.byte</code>, <code>ocaml</code>
</li>
<li>20 MB	<code>ocamldep.byte</code>, <code>ocamlc.byte</code>
</li>
<li>19 MB	<code>ocamldoc.opt</code>
</li>
<li>18 MB	<code>ocamlopt.opt</code>
</li>
<li>15 MB	<code>ocamlobjinfo.opt</code>
</li>
<li>14 MB	<code>ocamldep.opt</code>, <code>ocamlc.opt</code>, <code>ocamlcmt</code>
</li>
</ul>
<p>There are both bytecode and native code executables in this list.</p>
<h2>
<a class="anchor"></a>Conclusion<a href="https://ocamlpro.com/blog/feed#conclusion">&#9875;</a>
          </h2>
<p>Our installer project would benefit from having a smaller binary OCaml
distribution, but most OCaml users in general would also benefit from
that: after a few years of using OCaml, OCaml developers usually end
up with huge <code>$HOME/.opam</code> directories, because every <code>opam</code> switch
often takes more than 1 GB of space, and the OCaml distribution takes
a big part of that. <code>opam-bin</code> partially solves this problem by
sharing equal files between several switches (when the
<code>--enable-share</code> configuration option has been used).</p>
<p>Here is a short list of ideas to test to decrease the size of the
binary OCaml distribution:</p>
<ul>
<li>
<p>Use the same executable for multiple programs (<code>ocamlc.opt</code>,
<code>ocamlopt.opt</code>, <code>ocamldep.opt</code>, etc.), using the first command
argument to choose the behavior to have. Rustup, for example, only
installs one binary in <code>$HOME/.cargo/bin</code> for <code>cargo</code>, <code>rustc</code>,
<code>rustup</code>, etc. and actually, our tool does the same trick to share
the same binary for itself, <code>opam</code>, <code>opam-bin</code>, <code>ocp-indent</code> and
<code>drom</code>.</p>
</li>
<li>
<p>Split installed files into separate <code>opam</code> packages, of which only
one would be installed as the compiler distribution. For example,
most <code>cmt</code> files of <code>compiler-libs</code> are not needed by most users,
they might only be useful for compiler/tooling developers, and even
then, only in very rare cases. They could be installed as another
<code>opam</code> package.</p>
</li>
<li>
<p>Remove the <code>-linkall</code> flag on <code>ocamlcommon.cm[x]a</code> libraries. In
general, such a flag should only be set when building an executable
that is expected to use plugins, because otherwise, this executable
will contain all the modules of the library, even the ones that are
not useful for its specific purpose.</p>
</li>
</ul>
</div>

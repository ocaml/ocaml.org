---
title: Building Static Binaries for OCaml Projects
description: Building static binaries can come in handy. Most notably, when the time
  comes to distribute executables. Fortunately, building static binaries from OCaml
  projects can be achieved pretty easily, when you know what you are doing.
url: https://soap.coffee/~lthms/posts/OCamlStaticBinaries.html
date: 2023-12-31T00:00:00-00:00
preview_image: https://soap.coffee/~lthms/img/thinking.png
authors:
- "Thomas Letan\u2019s Blog"
source:
---


        
        <h1>Building Static Binaries for OCaml Projects</h1><div><span class="icon"><svg><use href="/~lthms/img/icons.svg#tag"></use></svg></span>&nbsp;<a href="https://soap.coffee/~lthms/tags/ocaml.html" marked="" class="tag">ocaml</a> </div>
<p>Building static binaries can come in handy. Most notably, when the time comes
to distribute executables. I should know, because I spend a bit of time
recently preparing for <a href="https://soap.coffee/~lthms/posts/SpatialShell6.html" marked="">the 6th release of Spatial
Shell</a>, and part of that time was ensuring that folks on
Linux unwilling to build an OCaml project from source could still give my
project a shot.</p>
<p>Turns out, it can be achieved pretty easily, when you know what you are doing.
This is not the first article published on the Internet which explains how to
build static binaries, but (1) the ones I have found were a bit verbose and
hard to follow, and (2) the most recent versions of OCaml bring a new challenge
to tackle.</p>
<h2>Setting-Up a Dedicated <code class="hljs">dune</code> Profile</h2>
<p>At the root of your repository, create a <code class="hljs">dune</code> file containing the following
stanza:</p>
<pre><code class="hljs language-lisp">(<span class="hljs-name">env</span>
 (<span class="hljs-name">static</span>
  (<span class="hljs-name">flags</span>
   (<span class="hljs-symbol">:standard</span> -cclib -static))))
</code></pre>
<p>This tells <code class="hljs">dune</code> to passes specific arguments to the OCaml compiler when
called with the <code class="hljs">--profile=static</code> command-line argument.</p>
<p>At this point, calling <code class="hljs">dune build --profile=static</code> is likely to fail with
linking related errors. For instance, I got this one.</p>
<pre><code class="hljs">/sbin/ld: /usr/lib/gcc/x86_64-pc-linux-gnu/13.2.1/crt
beginT.o: relocation R_X86_64_32 against hidden symbol `__TMC_END__' can not be used when making a shared object
/sbin/ld: failed to set dynamic section sizes: bad value
collect2: error: ld returned 1 exit status
</code></pre>
<p>With OCaml 5.1.0 and OCaml 5.1.1, you are also likely to hit an error related
to <code class="hljs">zstd</code>, which is a new runtime dependency for OCaml programs<label for="fn1" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-right sidenote note"><span class="footnote-p">It looks like a temporary issue. If I understood correctly, the OCaml
core developers are planning to remove said dependency in future versions
of the compiler. </span>
</span>.</p>
<pre><code class="hljs">/sbin/ld: cannot find -lzstd: No such file or directory
collect2: error: ld returned 1 exit status
</code></pre>
<p>The solution for these two problems is the same.</p>
<h2>Setting Up a Specific Opam Switch</h2>
<p>The OCaml compiler has a lot of so-called variants. The most famous is probably
<a href="https://v2.ocaml.org/manual/flambda.html" marked=""><code class="hljs">flambda</code>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>, which enables a series
of optimisations for native compilation.</p>
<p>Nowadays, enabling the specific features of a given variant is achieved by
installing the related <code class="hljs">option</code> package when choosing your compiler version. In
our case, we have to install:</p>
<ul>
<li><code class="hljs">ocaml-option-static</code> (which will also enables <code class="hljs">ocaml-option-musl</code>)</li>
<li><code class="hljs">ocaml-option-no-compression</code> (for OCaml 5.1.0 and 5.1.1)</li>
</ul>
<p>The minimal Opam invocation to create such a switch is:</p>
<pre><code class="hljs language-bash">opam switch create . --packages <span class="hljs-string">"ocaml-option-static,ocaml-option-no-compression,ocaml.5.1.1"</span>
</code></pre>
<p>This particular configuration will produce static binaries using
<a href="https://musl.libc.org" marked=""><em>musl</em>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>, a lightweight libc implementation that is way
more suited than the glibc when it comes to static binaries. This means you
will have to install <em>musl</em> on your system (it is more than likely that it is
packaged by your favorite distribution).</p>
<p>Additionally, you will have to provide the static versions (<code class="hljs">.a</code>) of the system
libraries your project relies on. This part might be tricky to address, and is
very dependent on the particular system you are using. For instance, Debian
makes this a <em>lot</em> easier than Archlinux. This was typically what was happening
with <code class="hljs">zstd</code>: Archlinux only distributed dynamic libraries, so no <code class="hljs">.a</code> where
available on my laptop. Another example: if your project depends on
<a href="https://github.com/ocaml/Zarith" marked="">Zarith&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a>, then you have a dependency to <code class="hljs">gmp</code>.
You need to go and find the static library for it before moving to the next
section<label for="fn2" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-left sidenote note"><span class="footnote-p">Of course, it is also possible that you are working on a pure OCaml
project whose only real dependency is to the libc. Lucky you. </span>
</span>.</p>
<h2>Verifying the Resulting Binaries</h2>
<p>Now is the time to call Dune again, with the <code class="hljs">--profile=static</code> command-line
argument. Checking the result of your effort is as simple as calling <code class="hljs">ldd</code> on
the binary compiled by Dune.</p>
<pre><code class="hljs">    not a dynamic executable
</code></pre>
<p>If <code class="hljs">ldd</code> outputs something of this form, then you are good to go!</p>
<h2>Conclusion</h2>
<p>This is, in a nutshell, the approach I am using to produce static binaries for
Spatial Shell releases. You can find the resulting script in <a href="https://github.com/lthms/spatial-shell/blob/cc026c67a4645a01bf6cc6600e9e6baa87441fa8/scripts/prepare-release-artifacts.sh" marked="">the project
repository&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a>
if you are interested.</p>
<p>If you have spotted an error in this article, or if you think the solution
proposed here can be improved, do not hesitate to reach out to me (ideally
though my <a href="mailto:~lthms/public-inbox@lists.sr.ht" marked="">public inbox</a>). Or, even
better, open an issue on <a href="https://github.com/lthms/spatial-shell/issues" marked="">Spatial Shell
tracker&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a>! Afterall, these are
the very steps I’m relying on in order to provide static binaries, so I’d like
to know if I am doing something wrong 😅.</p>
        
      

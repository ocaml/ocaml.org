---
title: Arise Bushel, my sixth generation oxidised website
description: Learn about my sixth generation oxidised website built with a bleeding-edge
  OCaml variant.
url: https://anil.recoil.org/notes/bushel-lives
date: 2025-01-29T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<p>This website has been through quite a few iterations over the years. The first version in 1998 was written in Perl and hosted on <a href="https://anil.recoil.org/news.xml">OpenBSD</a>; the second was rewritten in 2000 when I <a href="https://anil.recoil.org/notes/commit-access-to-php">got commit access to PHP</a>; the third rewrite became a hybrid OCaml/PHP/Perl special in 2004 in <a href="https://en.wikipedia.org/wiki/Blosxom">Blosxom</a>; then the forth rewrite around 2013 got turned into a <a href="https://anil.recoil.org/projects/unikernels">unikernel</a> in MirageOS; then the <a href="https://web.archive.org/web/20220118200046/https://anil.recoil.org/">fifth</a> in 2019 then transitioned to an OCaml static site generator hosted on a prerelease <a href="https://github.com/avsm/eeww">multicore OCaml webserver</a>. So the sixth generation now needs something to continue the grand <a href="https://en.wikipedia.org/wiki/Rube_Goldberg_machine">Rube Goldberg</a> tradition of helping me learn the latest and greatest in systems technology.</p>
<p>And so here it is! The site is now written in a bleeding-edge unreleased variant of OCaml with extensions based around <a href="https://blog.janestreet.com/icfp-2024-index/">Rust-like type system features</a> activated, including rather exciting <a href="https://popl25.sigplan.org/details/POPL-2025-popl-research-papers/23/Data-Race-Freedom-la-Mode">data-race freedom</a> work that just won a best paper award at POPL 2025.  It's normally difficult to work on continuously moving compilers, but Diana Kalinichenko did a tremendous amount of work into making it usable with opam out of the box, and this post documents the journey to getting this website live.</p>
<h2>Getting the oxidised compiler</h2>
<p>Firstly, we did some groundwork a few months ago by adding support into the opam-repository for <a href="https://github.com/ocaml/opam-repository/pull/26471">bootstrap versions</a> of dune, menhir and ocamlfind. These are used to build the Jane Street version of the OCaml compiler, which is published as an <a href="https://github.com/janestreet/opam-repository/tree/with-extensions">opam-repository#with-extensions</a>.</p>
<p>The extensions there are straightforward for those familiar with opam. On a clean system you can run:</p>
<pre><code class="language-bash">$ opam init
$ opam switch create 5.2.0+flambda2 \
 --repos with-extensions=git+https://github.com/janestreet/opam-repository.git#with-extensions,default
$ eval $(opam env)
</code></pre>
<p>This creates a new opam switch known as <code>5.2.0+flambda2</code>, and we can then verify it's running the variant compiler.</p>
<pre><code>$ ocaml
OCaml version 5.2.0+jst
Enter #help;; for help.
# let () =
    let local_message : string @@ local = "Hello, World" in
    print_endline local_message
  ;;
Error: This value escapes its region.
</code></pre>
<p>That last bit is the new region magic which I'm keen to start experimenting with for this website! But before that, we need to get the rest of the ecosystem packages needed for the website working under this compiler.</p>
<h2>Installing ecosystem packages</h2>
<p>I decided to build the new site based on a content manager I've been designing
(and scrapping) for a few years, codenamed Bushel.  The basic idea behind
Bushel is to extend Markdown sufficiently with rich contextual data (such as
contacts, papers, projects, ideas and so on), and allow for cross-referencing
to <em>other</em> sites that also follow the Bushel protocol. I'll talk about that in
more detail in future posts, but for now that means that I need a more dynamic
website than the static one I used for the past few years.</p>
<p>Since the Jane Street compiler doesn't yet support the effect system from OCaml 5, I couldn't use my own Eio-based webserver. So after some discussion with <a href="https://mynameismwd.org" class="contact">Michael Dales</a> who is <a href="https://digitalflapjack.com/blog/the-partially-dynamic-web/">also porting his site to OCaml</a>, I took the opportunity to learn the the excellent <a href="https://aantron.github.io/dream/">Dream</a> server, which is based on Lwt.  I also used Daniel Bunzli's <a href="https://discuss.ocaml.org/t/ann-cmarkit-0-3-0-commonmark-parser-and-renderer-for-ocaml/13622">cmarkit</a> library for Markdown parsing, and my own <a href="https://github.com/avsm/jekyll_format">Jekyll_format</a> and <a href="https://github.com/avsm/ocaml-yaml">yaml</a> libraries.</p>
<p>Amazingly, all of these libraries worked out of the box on the Jane Street
compiler, except for one snag: the parsetree internals have changed in their
branch. This means that <a href="https://ocaml.org/docs/metaprogramming">PPX</a>
extensions will not work out-of-the-box. Thankfully, there is an abstraction
library called <a href="https://discuss.ocaml.org/t/ann-ppxlib-034-0/15952">ppxlib</a> which
has been ported to the variant compiler, and the differences in the parse tree
were easy to fix up (thanks Nathan Reb and <a href="https://patrick.sirref.org" class="contact">Patrick Ferris</a> for your recent ppxlib work!)</p>
<p>After forking and fixing just two libraries that were using ppx (and not part of the
Jane Street core libraries that were already ported), all I had to do was to pin them
and add them to my development environment.</p>
<pre><code>opam pin add ppxlib 0.33.0+jst
opam pin add dream-httpaf 1.0.0~alpha4
opam pin add hpack https://github.com/avsm/ocaml-h2.git#js-extensions-fixes
opam pin add lwt_ppx https://github.com/avsm/lwt.git#js-extensions-fixes
</code></pre>
<p>And this then installs the overridden version of packages that I needed,
with the pins making sure that the right dependencies were also present.
After that, it was plain sailing! I've now compiled up a native code version
of my webserver code, deployed it into a <a href="https://anil.recoil.org/news.xml">Docker</a> container, and
deployed it on Linux.</p>
<p>In the future, I hope to use <a href="https://preview.dune.build">dune package management</a> to ease the deployment
of the site, but it didn't work in its current preview form due to a <a href="https://github.com/ocaml/dune/issues/11405">problem
with depopts</a>. Just teething
problems with a preview, so I'll post more about that when I get it working!
I also have a half-finished port of the variant compiler to OpenBSD, so that
I can shift my website back to its familiar home rather than running on Linux.</p>
<p>I haven't yet actually taken advantage of any of the new extensions in the
Jane Street variant, since I wantd to get this site up and running first.
I'll tidy up the code, open source it in the coming weeks, and then we can
dive into some region extensions and see how far I get!</p>


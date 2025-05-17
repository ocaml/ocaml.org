---
title: Easily OPAM switching to any OCaml feature request
description: Switch between OCaml compilers easily with OPAM and GitHub pull requests.
url: https://anil.recoil.org/notes/ocaml-github-and-opam
date: 2014-03-25T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<p>Gabriel Scherer <a href="http://gallium.inria.fr/blog/patch-review-on-github/">announced an
experiment</a> to
host OCaml compiler pull requests on
<a href="https://github.com/ocaml/ocaml/pulls">GitHub</a> for six months. There is
a general feeling that GitHub would be a more modern hosting platform
than the venerable but reliable
<a href="http://caml.inria.fr/mantis/changelog_page.php">Mantis</a> setup that has
in place for over a decade, but the only way to find out for sure is by
trying it out for a while.</p>
<p>One of the great benefits of using GitHub is their excellent
<a href="http://developer.github.com/v3/">API</a> to easily automate workflows
around issues and pull requests. After a suggestion from Jeremy Yallop
and David Sheets over lunch, I decided to use this to make it easier to
locally apply compiler patches. OPAM has a great <a href="https://opam.ocaml.org/doc/Advanced_Usage.html#h2-Usingadifferentcompiler">compiler
switch</a>
feature that lets you run simultaneous OCaml installations and swap
between them easily.</p>
<p>For instance, the default setting gives you access
to:</p>
<pre><code>$ opam switch
system  C system       System compiler (4.01.0)
--     -- 3.11.2       Official 3.11.2 release
--     -- 3.12.1       Official 3.12.1 release
--     -- 4.00.0       Official 4.00.0 release
--     -- 4.00.1       Official 4.00.1 release
--     -- 4.01.0       Official 4.01.0 release
--     -- 4.01.0beta1  Beta1 release of 4.01.0
</code></pre>
<p>I used my <a href="https://github.com/avsm/ocaml-github">GitHub API bindings</a> to
knock up a script that converts every GitHub pull request into a custom
compiler switch. You can see these by passing the <code>--all</code> option to
<code>opam switch</code>, as follows:</p>
<pre><code>$ opam switch --all
--     -- 4.02.0dev+pr10              Add String.{split,rsplit}
--     -- 4.02.0dev+pr13              Add String.{cut,rcut}.
--     -- 4.02.0dev+pr14              Add absolute directory names to bytecode format for ocamldebug to use
--     -- 4.02.0dev+pr15              replace String.blit by String.unsafe_blit
--     -- 4.02.0dev+pr17              Cmm arithmetic optimisations
--     -- 4.02.0dev+pr18              Patch for issue 5584
--     -- 4.02.0dev+pr2               Parse -.x**2. (unary -.) as -.(x**2.).  Fix PR#3414
--     -- 4.02.0dev+pr20              OCamlbuild: Fix the check of ocamlfind
--     -- 4.02.0dev+pr3               Extend record punning to allow destructuring.
--     -- 4.02.0dev+pr4               Fix for PR#4832 (Filling bigarrays may block out runtime)
--     -- 4.02.0dev+pr6               Warn user when a type variable in a type constraint has been instantiated.
--     -- 4.02.0dev+pr7               Extend ocamllex with actions before refilling
--     -- 4.02.0dev+pr8               Adds a .gitignore to ignore all generated files during `make world.opt'
--     -- 4.02.0dev+pr9               FreeBSD 10 uses clang by default, with gcc not available by default
--     -- 4.02.0dev+trunk             latest trunk snapshot
</code></pre>
<p>Testing the impact of a particular compiler switch is now pretty
straightforward. If you want to play with Stephen Dolan’s <a href="https://github.com/ocaml/ocaml/pull/17">optimized
arithmetic operations</a>, for
instance, you just need to do:</p>
<pre><code>$ opam switch 4.02.0dev+pr17
$ eval `opam config env`
</code></pre>
<p>And your local environment now points to the patched OCaml compiler. For
the curious, the scripts to generate the OPAM pull requests are in my
<a href="https://github.com/avsm/opam-sync-github-prs">avsm/opam-sync-github-prs</a>
repository. It contains an example of how to query active pull requests,
and also to create a new cross-repository pull request (using the <a href="https://github.com/avsm/ocaml-github">git
jar</a> binary from my GitHub
bindings). The scripts run daily for now, and delete switches once the
corresponding pull request is closed. Just run <code>opam update</code> to retrieve
the latest switch set from the upstream <a href="https://github.com/ocaml/opam-repository">OPAM package
repository</a>.</p>


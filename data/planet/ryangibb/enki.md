---
title: Enki
description:
url: https://ryan.freumh.org/enki.html
date: 2025-04-21T00:00:00-00:00
preview_image:
authors:
- Ryan Gibb
source:
---

<article>
    <div class="container">
        
        <span>Published 21 Apr 2025.</span>
        
        
    </div>
    
        <div> Tags: <a href="https://ryan.freumh.org/research.html" title="All pages tagged 'research'." rel="tag">research</a>, <a href="https://ryan.freumh.org/projects.html" title="All pages tagged 'projects'." rel="tag">projects</a>. </div>
    
    <section>
        <blockquote>
<p><span>Enki – Sumerian god, <a href="https://en.wikipedia.org/wiki/Enki#Uniter_of_languages">Uniter of
Languages</a>.</span></p>
</blockquote>
<p><span>I started using the <a href="https://ryan.freumh.org/nix.html">Nix</a>
package manager and software deployment system as it was great for
declaratively defining software deployments for <a href="https://ryan.freumh.org/eilean.html">Eilean</a>. But I quickly ran into issues with Nix’s
operating system-centric view of packages; like other system packages
managers (see Debian’s APT, Arch’s pacman, or OpenBSD’s <code class="verbatim">pkg_add</code>) it maintains a coherent package set.
Unlike these other package managers it also packages language-ecosystem
packages; since it eschews the Filesystem Hierarchy Standard (FHS) if
you want to depend on system packages you need to build a Nix
derivation<a href="https://ryan.freumh.org/atom.xml#fn1" class="footnote-ref" role="doc-noteref"><sup>1</sup></a>.</span></p>
<p><span>But unlike language package mangers, Nix doesn’t
have version solving: it resolves dependencies on an exact version, and
doesn’t support expressing more complicated version constraints. This
seems to be an approach that doesn’t scale to disparate large open
source for ecosystems; half the failures I encounter in Nixpkgs are due
to incompatible versions of dependencies. As a result, a lot of Nix
derivations are programmatically generated from the result of resolution
from a from language-ecosystem specific tooling (be that with a lockfile
or with <a href="https://nix.dev/manual/nix/2.28/language/import-from-derivation">Import
From Derivation</a>).</span></p>
<p><span>I worked on a tool to generate Nix derivations from
an Opam version resolution this building <a href="https://ryan.freumh.org/hillingar.html">MirageOS unikernels with Nix</a>, Tweag’s <a href="https://github.com/tweag/opam-nix">opam-nix</a>. There’s a lot of
language ecosystem tooling to Nix derivation projects out there, with <a href="https://github.com/nix-community/dream2nix">dream2nix</a> aiming
to provide a unified framework to build them.</span></p>
<p><span>Something that this approach doesn’t work well for
is <a href="https://discuss.ocaml.org/t/depending-on-non-ocaml-languages-from-the-opam-repository/12585">multi-lingual
projects</a>. Projects have to <a href="https://github.com/mt-caret/polars-ocaml/pull/94">vendor</a> <a href="https://github.com/LaurentMazare/ocaml-arrow/issues/3">dependencies</a>
from foreign ecosystems and <a href="https://www.tweag.io/blog/2023-06-29-packaging-topiary-in-opam/">duplicate
packaging</a> to target other languages. This hinders visibility into
dependencies and upgradeability; what if there’s a vulnerability in one
of the dependencies, do you have to wait for upstream to re-vendor the
updated dependencies? All these package managers are functionally doing
the same thing, with varying degrees of interoperability with <a href="http://blog.ezyang.com/2015/12/the-convergence-of-compilers-build-systems-and-package-managers/">build
systems and compilers</a>.</span></p>
<p><span>What if instead of this ad-hoc and unversioned
interoperability, we could resolve dependencies across ecosystems? <a href="https://github.com/RyanGibb/enki/">Enki</a> is a cross-ecosystem
dependency solver using the <a href="https://github.com/dart-lang/pub/blob/master/doc/solver.md">Pubgrub</a>
version solving algorithm, which keeps track of the causality of
conflicts, and is built on <a href="https://github.com/pubgrub-rs/pubgrub">Rust Pubgrub</a><a href="https://ryan.freumh.org/atom.xml#fn2" class="footnote-ref" role="doc-noteref"><sup>2</sup></a>. We see a number of use-cases for
this system;</span></p>
<ol type="1">
<li><p><span><strong>System dependencies:</strong> Language
package managers have varying ways of interoperating with system package
managers; Opam has the <a href="https://opam.ocaml.org/doc/Manual.html#opamfield-depexts"><code class="verbatim">depext</code> mechanism</a> to express system
dependencies, and Cargo has <a href="https://doc.rust-lang.org/cargo/reference/build-scripts.html#-sys-packages"><code class="verbatim">*-sys</code> packages</a>. Enki can add fine-grained
and versioned system dependencies to language ecosystems. This enables
us to, for example, solve for the smallest and most up-to-date container
image that satisfies the system dependencies of a project. We can even
encode the architecture in this version formula and solve for particular
hardware.</span></p>
<p><span>De-duplication of packages across ecosystems can be
done with datasets such as <a href="https://github.com/repology/repology-rules">repology-rules</a>.</span></p></li>
<li><p><span><strong>Cross-language dependencies:</strong>
Instead of vendoring dependencies from other ecosystems or requiring
separate solves in each, we can directly express dependencies across
ecosystems and solve for the most up-to-date packages in
each.</span></p></li>
<li><p><span><strong>Portable lockfiles:</strong> By
solving for all Operating Systems and architectures we can create truly
portable lockfiles.</span></p></li>
<li><p><span><strong>Vulnerability tracking:</strong> We
can use this dependency graph to know what our dependencies all the way
down the chain are, create complete <a href="https://en.wikipedia.org/wiki/Software_supply_chain">Software Bill
of Materials</a> programmatically, and track <a href="https://cve.mitre.org/">CVE</a>s that appear in our dependencies.
We can even envision monitoring vulnerabilities in our supply chain and
dynamically solving and redeploying software to ensure continued secure
operation. I’m interested in this for use in <a href="https://ryan.freumh.org/eilean.html">Eilean</a>.</span></p></li>
<li><p><span><strong>GPU hardware requirements:</strong>
Dependencies can changed depending on the hardware available for GPU
workloads.</span></p></li>
<li><p><span><strong>Agentic AI:</strong> Large Language
Models (LLMs) that use tools often fail to interface with package
managers. They fail to express version contraints on the most recent
packages, or hallucinate packages which don’t exist <a href="https://www.theregister.com/AMP/2025/04/12/ai_code_suggestions_sabotage_supply_chain/">exposing
attack vectors</a>. We’ve written an <a href="http://me.en.ki/">MCP
server</a> to make Enki available to AI agents, and plan to expand it to
support a vector search across package metadata. This will enable agents
to perform such tasks as resolve system dependencies of a package to
create a declarative dockerfile, decide on a language to use based on
packages available, and more.</span></p></li>
</ol>
<p><span>Once we have Enki resolving dependencies across
ecosystems we can look at how we can provide them:</span></p>
<ol type="1">
<li><p><span>In a container; invoking ecosystem-specific
tooling in a containerised environment such as docker.</span></p></li>
<li><p><span>With Nix; all these ecosystem to Nix tools go
through the Nix derivation language, but perhaps we could interface with
the Nix store directly enabled by <a href="https://github.com/NixOS/rfcs/pull/134/">RFC 0134 Carve out a
store-only Nix</a>.</span></p></li>
</ol>
<p><span>Docker is good for development, and Nix is good
for deployment, but perhaps we could bridge the gap with
Enki.</span></p>
<section class="footnotes footnotes-end-of-document" role="doc-endnotes">
<hr>
<ol>
<li><p><span>One can built software in a Nix shell
in development, but there’s no guarantee’s the referenced paths in the
Nix store won’t be garbage collected if the built software isn’t a root
in the Nix store.</span><a href="https://ryan.freumh.org/atom.xml#fnref1" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span>I’m interested in using <a href="https://blog.janestreet.com/oxidizing-ocaml-locality/">OxCaml</a>
as an alternative language to implement this in.</span><a href="https://ryan.freumh.org/atom.xml#fnref2" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
</ol>
</section>
    </section>
</article>


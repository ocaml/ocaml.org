---
title: Announcing MirageOS 4.0.0 Beta Release
description:
url: https://mirage.io/blog/announcing-mirage-40-beta-release
date: 2022-02-10T00:00:00-00:00
preview_image:
featured:
authors:
- Thomas Gazagnaire
---


        <p><strong>On behalf of the Mirage team, I am delighted to announce the beta release of MirageOS 4.0!</strong></p>
<p><a href="https://mirage.io">MirageOS</a> is a library operating system that constructs unikernels for secure, high-performance network applications across a variety of hypervisor and embedded platforms. For example, OCaml code can be developed on a standard OS, such as Linux or macOS, and then compiled into a fully standalone, specialised unikernel that runs under a Xen or KVM hypervisor. The MirageOS project also supplies several protocol and storage implementations written in pure OCaml, ranging from TCP/IP to TLS to a full Git-like storage stack.</p>
<p>The beta of the MirageOS 4.00 release contains:</p>
<ul>
<li><code>mirage.4.0.0~beta</code>: the CLI tool;
</li>
<li><code>ocaml-freestanding.0.7.0</code>: a libc-free OCaml runtime;
</li>
<li>and <code>solo5.0.7.0</code>: a cross-compiler for OCaml.
</li>
</ul>
<p>They are all available in <code>opam</code> by using:</p>
<pre><code>opam install 'mirage&gt;=4.0'
</code></pre>
<p><em>Note</em>: you need to explicitly add the <code>4.0&gt;=0</code> version here, otherwise <code>opam</code> will select the latest <code>3.*</code> stable release. For a good experience, check that at least version <code>4.0.0~beta3</code> is installed.</p>
<h2>New Features</h2>
<p>This new release of MirageOS adds systematic support for cross-compilation to all supported unikernel targets. This means that libraries that use C stubs (like Base, for example) can now seamlessly have those stubs cross-compiled to the desired target.  Previous releases of MirageOS required specific support to accomplish this by adding the stubs to a central package.</p>
<p>MirageOS implements cross-compilation using <em>Dune Workspaces</em>, which can take a whole collection of OCaml code (including all transitive dependencies) and compile it with a given set of C and OCaml compiler flags. This workflow also unlocks support for familiar IDE tools (such as <code>ocaml-lsp-server</code> and Merlin) while developing unikernels in OCaml. It makes day-to-day coding much faster because builds are decoupled from configuration and package updates. This means that live-builds, such as Dune's watch mode, now work fine even for exotic build targets!</p>
<p>A complete list of features can be found on the <a href="https://mirage.io/docs/mirage-4">MirageOS 4 release page</a>.</p>
<h2>Cross-Compilation and Dune Overlays</h2>
<p>This release introduces a significant change in the way MirageOS projects are compiled based on Dune Workspaces. This required implementing a new developer experience for Opam users in order to simplify cross-compilation of large OCaml projects.</p>
<p>That new tool, called <a href="https://github.com/ocamllabs/opam-monorepo">opam-monorepo</a> (n&eacute;e duniverse), separates package management from building the resulting source code. It is an Opam plugin that:</p>
<ul>
<li>creates a lock file for the project dependencies
</li>
<li>downloads and extracts the dependency sources locally
</li>
<li>sets up a Dune Workspace so that <code>dune build</code> builds everything in one go.
</li>
</ul>
<p><a href="https://asciinema.org/a/rRf6s8cNyHUbBsDDfZkBjkf7X?speed=2"><img src="https://asciinema.org/a/rRf6s8cNyHUbBsDDfZkBjkf7X.svg" alt="asciicast"/></a></p>
<p><code>opam-monorepo</code> is already available in Opam and can be used on many projects which use <code>dune</code> as a build system. However, as we don't expect the complete set of OCaml dependencies to use <code>dune</code>, we MirageOS maintainers are committed to maintaining patches to build the most common dependencies with <code>dune</code>. Two repositories are used for that purpose:</p>
<ul>
<li><a href="https://github.com/dune-universe/opam-overlays">dune-universe/opam-overlays</a> is set up by default by <code>opam-monorepo</code> and contains most packages.
</li>
<li><a href="https://github.com/dune-universe/mirage-opam-overlays">dune-universe/mirage-opam-overlays</a> is enabled when using the Mirage CLI tool.
</li>
</ul>
<h2>Next Steps</h2>
<p>Your feedback on this beta release is very much appreciated. You can follow the tutorials <a href="https://mirage.io/docs/mirage-4">here</a>. Issues are very welcome on our <a href="https://github.com/mirage/mirage/issues">bug-tracker</a>, or come find us on Matrix in the MirageOS channel: <a href="https://matrix.to/#/%23mirageos:matrix.org">#mirageos:matrix.org</a> or on <a href="https://discuss.ocaml.org/t/mirageos-4-0-beta-release/9302">Discuss</a>.</p>
<p>The <strong>final release</strong> will happen in about a month. This release will incorporate your early feedback. It will also ensure the existing MirageOS ecosystem is compatible with MirageOS 4 by reducing the overlay packages to the bare minimum. We also plan to write more on <code>opam-monorepo</code> and all the new things MirageOS 4.0 will bring.</p>

      

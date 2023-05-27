---
title: Announcing MirageOS 4.0.0
description:
url: https://mirage.io/blog/announcing-mirage-40
date: 2022-03-28T00:00:00-00:00
preview_image:
featured:
authors:
- Thomas Gazagnaire
---


        <p><strong>On behalf of the MirageOS team, I am delighted to announce the release
of MirageOS 4.0.0!</strong></p>
<p>Since its first release in 2013, MirageOS has made steady progress
towards deploying self-managed internet infrastructure. The
project&rsquo;s initial aim was to self-host as many services as possible
aimed at empowering internet users to deploy infrastructure securely
to own their data and take back control of their privacy. MirageOS can
securely deploy <a href="https://github.com/roburio/unipi">static website
hosting</a> with &ldquo;Let&rsquo;s Encrypt&rdquo;
certificate provisioning and a <a href="https://github.com/mirage/ptt">secure SMTP
stack</a> with security
extensions. MirageOS can also deploy decentralised communication
infrastructure like <a href="https://github.com/mirage/ocaml-matrix">Matrix</a>,
<a href="https://github.com/roburio/openvpn">OpenVPN servers</a>, and <a href="https://github.com/roburio/tlstunnel">TLS
tunnels</a> to ensure data privacy
or <a href="https://github.com/mirage/ocaml-dns">DNS(SEC) servers</a> for better
authentication.</p>
<p>The protocol ecosystem now contains <a href="https://github.com/mirage/">hundreds of libraries</a> and services
millions of daily users. Over these years, major commercial users have
joined the projects. They rely on MirageOS libraries to keep their
products secure. For instance, the MirageOS networking code powers
<a href="https://www.docker.com/blog/how-docker-desktop-networking-works-under-the-hood/">Docker Desktop&rsquo;s
VPNKit</a>,
which serves the traffic of millions of containers daily. <a href="https://www.citrix.com/fr-fr/products/citrix-hypervisor/">Citrix
Hypervisor</a>
uses MirageOS to interact with Xen, the hypervisor that powers most of
today&rsquo;s public
cloud. <a href="https://www.nitrokey.com/products/nethsm">Nitrokey</a> is
developing a new hardware security module based on
MirageOS. <a href="https://robur.io/">Robur</a> develops a unikernel
orchestration system for fleets of MirageOS
unikernels. <a href="https://tarides.com/">Tarides</a> uses MirageOS to improve
the <a href="https://tezos.com/">Tezos</a> blockchain, and
<a href="https://hyper.ag/">Hyper</a> uses MirageOS to build sensor analytics and
an automation platform for sustainable agriculture.</p>
<p>In the coming weeks, our blog will feature in-depth technical content
for the new features that MirageOS brings and a tour of
the existing community and commercial users of MirageOS. Please reach out
If you&rsquo;d like to tell us about your story.</p>
<h2>Install MirageOS 4</h2>
<p>The easiest way to install MirageOS 4 is by using the <a href="https://opam.ocaml.org/">opam package
manager</a> version 2.1. Follow the
<a href="https://mirage.io/docs/install">installation guide</a> for more details.</p>
<pre><code>$ opam update
$ opam install 'mirage&gt;4'
</code></pre>
<p><em>Note</em>: if you upgrade from MirageOS 3, you will need to manually clean
the previously generated files (or call <code>mirage clean</code> before
upgrading). You would also want to read <a href="https://mirage.io/docs/breaking-changes">the complete list of API
changes</a>. You can see
unikernel examples in
<a href="https://github.com/mirage/mirage-skeleton">mirage/mirage-skeleton</a>,
<a href="https://github.com/roburio/unikernels">roburio/unikernels</a> or
<a href="https://github.com/tarides/unikernels">tarides/unikernels</a>.</p>
<h2>About MirageOS</h2>
<p>MirageOS is a library operating system that constructs unikernels for
secure, high-performance, low-energy footprint applications across
various hypervisor and embedded platforms. It is available as an
open-source project created and maintained by the <a href="https://mirage.io/community">MirageOS Core
Team</a>. A unikernel
can be customised based on the target architecture by picking the
relevant MirageOS libraries and compiling them into a standalone
operating system, strictly containing the functionality necessary
for the target. This minimises the unikernel&rsquo;s footprint, increasing
the security of the deployed operating system.</p>
<p>The MirageOS architecture can be divided into operating system
libraries, typed signatures, and a metaprogramming compiler. The
operating system libraries implement various functionalities, ranging
from low-level network card drivers to full reimplementations of the
TLS protocol, as well as the Git protocol to store versioned data. A
set of typed signatures ensures that the OS libraries are consistent
and work well in conjunction with each other. Most importantly,
MirageOS is also a metaprogramming compiler that can input OCaml
source code along with its dependencies, and a deployment target
description to generate an executable unikernel, i.e., a
specialised binary artefact containing only the code needed to run on
the target platform. Overall, MirageOS focuses on providing a small,
well-defined, typed interface with the system components of the target
architecture.</p>
<h2>What&rsquo;s New in MirageOS 4?</h2>
<p>The MirageOS4 release focuses on better integration with existing
ecosystems. For instance, parts of MirageOS are now merged into the
OCaml ecosystem, making it easier to deploy OCaml applications into a
unikernel. Plus, we improved the cross-compilation support, added more
compilation targets to MirageOS (for instance, we have an experimental
bare-metal <a href="https://github.com/mirage/mirage/pull/1253">Raspberry-Pi 4
target</a>, and made it
easier to integrate MirageOS with C and Rust libraries.</p>
<p>This release introduces a significant change in how MirageOS compiles
projects. We developed a new tool called
<a href="https://github.com/ocamllabs/opam-monorepo">opam-monorepo</a> that
separates package management from building the resulting source
code. It creates a lock file for the project&rsquo;s dependencies, downloads
and extracts the dependency sources locally, and sets up a <a href="https://dune.readthedocs.io/en/stable/dune-files.html#dune-workspace-1">dune
workspace</a>,
enabling <code>dune build</code> to build everything simultaneously. The MirageOS
4.0 release also contains improvements in the <code>mirage</code> CLI tool, a new
libc-free OCaml runtime (thus bumping the minimal required version of
OCaml to 4.12.1), and a cross-compiler for OCaml. Finally, MirageOS
4.0 now supports the use of familiar IDE tools while developing
unikernels via Merlin, making day-to-day coding much faster.</p>
<p>Review a complete list of features on the <a href="https://mirage.io/docs/mirage-4">MirageOS 4 release
page</a>. And check out <a href="https://mirage.io/docs/breaking-changes">the breaking
API changes</a>.</p>
<h2>About Cross-Compilation and opam overlays</h2>
<p>This new release of MirageOS adds systematic support for
cross-compilation to all supported unikernel targets. This means that
libraries that use C stubs (like Base, for example) can now seamlessly
have those stubs cross-compiled to the desired target. Previous
releases of MirageOS required specific support to accomplish this by
adding the stubs to a central package. MirageOS 4.0 implements
cross-compilation using <a href="https://dune.readthedocs.io/en/stable/dune-files.html#dune-workspace-1">Dune
workspaces</a>,
which can take a whole collection of OCaml code (including all
transitive dependencies) and compile it with a given set of C and
OCaml compiler flags.</p>
<p>The change in how MirageOS compiles projects that accompanies this
release required implementing a new developer experience for Opam
users, to simplify cross-compilation of large OCaml projects.</p>
<p>A new tool called
<a href="https://dune.readthedocs.io/en/stable/dune-files.html#dune-workspace-1">opam-monorepo</a>
separates package management from building the resulting source
code. It is an opam plugin that:</p>
<ul>
<li>creates a lock file for the project&rsquo;s dependencies
</li>
<li>downloads and extracts the dependency sources locally
</li>
<li>sets up a Dune workspace so that <code>dune build</code> builds everything in one
go.
</li>
</ul>
<p><code>opam-monorepo</code> is already available in opam and can be used
on many projects which use Dune as a build system. However, as we
don&rsquo;t expect the complete set of OCaml dependencies to use Dune, we
MirageOS maintainers are committed to maintaining patches that build
the most common dependencies with dune. These packages are hosted in two
separate Opam repositories:</p>
<ul>
<li><a href="https://github.com/dune-universe/opam-overlays">dune-universe/opam-overlays</a>
adds patched packages (with a <code>+dune</code> version) that compile with
Dune.
</li>
<li><a href="https://github.com/dune-universe/mirage-opam-overlays">dune-universe/mirage-opam-overlays</a>
add patched packages (with a <code>+dune+mirage</code> version) that fix
cross-compilation with Dune.
</li>
</ul>
<p>When using the <code>mirage</code> CLI tool, these repositories are enabled by default.</p>
<h2>In Memory of Lars Kurth</h2>
<p><img src="https://xenproject.org/wp-content/uploads/sites/79/2020/01/LarsK_0.jpg" width="180" heigth="180"/></p>
<p>We dedicate this release of MirageOS 4.0 to <a href="https://xenproject.org/2020/01/31/saying-goodbye-to-lars-kurth-open-source-advocate-and-friend/">Lars
Kurth</a>.
Unfortunately, he passed away early in 2020, leaving a big hole in our
community. Lars was instrumental in bringing the Xen Project to
fruition, and we wouldn&rsquo;t be here without him.</p>

      

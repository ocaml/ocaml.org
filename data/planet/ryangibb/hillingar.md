---
title: Hillingar
description:
url: https://ryan.freumh.org/hillingar.html
date: 2022-12-14T00:00:00-00:00
preview_image:
authors:
- Ryan Gibb
source:
---

<article>
    <div class="container">
        
        <span>Published 14 Dec 2022.</span>
        
        
        <span style="font-style: italic;">Last update 15 Feb 2025.</span>
        
    </div>
    
        <div> Tags: <a href="https://ryan.freumh.org/projects.html" title="All pages tagged 'projects'." rel="tag">projects</a>. </div>
    
    <section>
        

<blockquote>
<p><span><a href="https://github.com/RyanGibb/hillingar">Hillingar</a>, an <a href="https://en.wikipedia.org/wiki/Hillingar_effect">arctic mirage</a>
<span class="citation" data-cites="lehnNovayaZemlyaEffect1979"><a href="https://ryan.freumh.org/atom.xml#ref-lehnNovayaZemlyaEffect1979" role="doc-biblioref">[1]</a></span></span></p>
</blockquote>
<h2>Introduction</h2>
<p><span>The Domain Name System (DNS) is a
critical component of the modern Internet, allowing domain names to be
mapped to IP addresses, mailservers, and more<a href="https://ryan.freumh.org/atom.xml#fn1" class="footnote-ref" role="doc-noteref"><sup>1</sup></a>.
This allows users to access services independent of their location in
the Internet using human-readable names. We can host a DNS server
ourselves to have authoritative control over our domain, protect the
privacy of those using our server, increase reliability by not relying
on a third party DNS provider, and allow greater customization of the
records served (or the behaviour of the server itself). However, it can
be quite challenging to deploy one’s own server reliably and
reproducibly, as I discovered during my master’s thesis <span class="citation" data-cites="gibbSpatialNameSystem2022"><a href="https://ryan.freumh.org/atom.xml#ref-gibbSpatialNameSystem2022" role="doc-biblioref">[2]</a></span>. The Nix deployment system aims to
address this. With a NixOS machine, deploying a DNS server is as simple
as:</span></p>
<div class="sourceCode"><pre class="sourceCode nix"><code class="sourceCode nix"><span><a href="https://ryan.freumh.org/atom.xml#cb1-1" aria-hidden="true" tabindex="-1"></a><span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb1-2" aria-hidden="true" tabindex="-1"></a>  <span class="va">services</span>.<span class="va">bind</span> <span class="op">=</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb1-3" aria-hidden="true" tabindex="-1"></a>    <span class="va">enable</span> <span class="op">=</span> <span class="cn">true</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb1-4" aria-hidden="true" tabindex="-1"></a>    <span class="va">zones</span>.<span class="st">"freumh.org"</span> <span class="op">=</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb1-5" aria-hidden="true" tabindex="-1"></a>      <span class="va">master</span> <span class="op">=</span> <span class="cn">true</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb1-6" aria-hidden="true" tabindex="-1"></a>      <span class="va">file</span> <span class="op">=</span> <span class="st">"freumh.org.zone"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb1-7" aria-hidden="true" tabindex="-1"></a>    <span class="op">};</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb1-8" aria-hidden="true" tabindex="-1"></a>  <span class="op">};</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb1-9" aria-hidden="true" tabindex="-1"></a><span class="op">}</span></span></code></pre></div>
<p><span>Which we can then query
with</span></p>
<div class="sourceCode" data-org-language="sh"><pre class="sourceCode bash"><code class="sourceCode bash"><span><a href="https://ryan.freumh.org/atom.xml#cb2-1" aria-hidden="true" tabindex="-1"></a><span class="ex">$</span> dig ryan.freumh.org @ns1.ryan.freumh.org +short</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb2-2" aria-hidden="true" tabindex="-1"></a><span class="ex">135.181.100.27</span></span></code></pre></div>
<p><span>To enable the user to query our domain
without specifying the nameserver, we have to create a glue record with
our registrar pointing <code class="verbatim">ns1.freumh.org</code> to
the IP address of our DNS-hosting machine.</span></p>
<p><span>You might notice this configuration is
running the venerable bind<a href="https://ryan.freumh.org/atom.xml#fn2" class="footnote-ref" role="doc-noteref"><sup>2</sup></a>, which is written in C.
As an alternative, using functional, high-level, type-safe programming
languages to create network applications can greatly benefit safety and
usability whilst maintaining performant execution <span class="citation" data-cites="madhavapeddyMelangeCreatingFunctional2007"><a href="https://ryan.freumh.org/atom.xml#ref-madhavapeddyMelangeCreatingFunctional2007" role="doc-biblioref">[3]</a></span>. One such language is
OCaml.</span></p>
<p><span>MirageOS<a href="https://ryan.freumh.org/atom.xml#fn3" class="footnote-ref" role="doc-noteref"><sup>3</sup></a> is
a deployment method for these OCaml programs <span class="citation" data-cites="madhavapeddyUnikernelsLibraryOperating2013"><a href="https://ryan.freumh.org/atom.xml#ref-madhavapeddyUnikernelsLibraryOperating2013" role="doc-biblioref">[4]</a></span>. Instead of running them as a
traditional Unix process, we instead create a specialised ‘unikernel’
operating system to run the application, which allows dead code
elimination improving security with smaller attack surfaces and improved
efficiency.</span></p>
<p><span>However, to deploy a Mirage unikernel
with NixOS, one must use the imperative deployment methodologies native
to the OCaml ecosystem, eliminating the benefit of reproducible systems
that Nix offers. This blog post will explore how we enabled reproducible
deployments of Mirage unikernels by building them with Nix.</span></p>
<p><span>At this point, the curious reader
might be wondering, what is ‘Nix’? Please see the separate webpage on <a href="https://ryan.freumh.org/nix.html">Nix</a> for more.</span></p>
<h2>MirageOS</h2>
<figure>
<img src="https://ryan.freumh.org/images/mirage-logo.svg">
<figcaption aria-hidden="true"><a href="https://ryan.freumh.org/atom.xml#fn4" class="footnote-ref" role="doc-noteref"><sup>4</sup></a></figcaption>
</figure>
<p><span>MirageOS is a library operating system
that allows users to create unikernels, which are specialized operating
systems that include both low-level operating system code and high-level
application code in a single kernel and a single address space.<span class="citation" data-cites="madhavapeddyUnikernelsLibraryOperating2013"><a href="https://ryan.freumh.org/atom.xml#ref-madhavapeddyUnikernelsLibraryOperating2013" role="doc-biblioref">[4]</a></span>.</span></p>
<p><span>It was the first such ‘unikernel creation
framework’, but comes from a long lineage of OS research, such as the
exokernel library OS architecture <span class="citation" data-cites="englerExokernelOperatingSystem1995"><a href="https://ryan.freumh.org/atom.xml#ref-englerExokernelOperatingSystem1995" role="doc-biblioref">[5]</a></span>. Embedding application code in the
kernel allows for dead-code elimination, removing OS interfaces that are
unused, which reduces the unikernel’s attack surface and offers improved
efficiency.</span></p>
<figure class="img-transparent">
<img src="https://ryan.freumh.org/images/mirage-diagram.svg">
<figcaption>Contrasting software layers in existing VM appliances
vs.&nbsp;unikernel’s standalone kernel compilation approach <span class="citation" data-cites="madhavapeddyUnikernelsLibraryOperating2013"><a href="https://ryan.freumh.org/atom.xml#ref-madhavapeddyUnikernelsLibraryOperating2013" role="doc-biblioref">[4]</a></span></figcaption>
</figure>
<p><span>Mirage unikernels are written OCaml<a href="https://ryan.freumh.org/atom.xml#fn5" class="footnote-ref" role="doc-noteref"><sup>5</sup></a>. OCaml is more practical for systems
programming than other functional programming languages, such as
Haskell. It supports falling back on impure imperative code or mutable
variables when warranted.</span></p>
<h2>Deploying Unikernels</h2>
<p><span>Now that we understand what
Nix and Mirage are, and we’ve motivated the desire to deploy Mirage
unikernels on a NixOS machine, what’s stopping us from doing just that?
Well, to support deploying a Mirage unikernel, like for a DNS server, we
would need to write a NixOS module for it.</span></p>
<p><span>A paired-down<a href="https://ryan.freumh.org/atom.xml#fn6" class="footnote-ref" role="doc-noteref"><sup>6</sup></a>
version of the bind NixOS module, the module used in our Nix expression
for deploying a DNS server on NixOS (<a href="https://ryan.freumh.org/atom.xml#cb1">§</a>),
is:</span></p>
<div class="sourceCode"><pre class="sourceCode nix"><code class="sourceCode nix"><span><a href="https://ryan.freumh.org/atom.xml#cb3-1" aria-hidden="true" tabindex="-1"></a><span class="op">{</span> <span class="va">config</span><span class="op">,</span> <span class="va">lib</span><span class="op">,</span> <span class="va">pkgs</span><span class="op">,</span> <span class="op">...</span> <span class="op">}</span>:</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb3-2" aria-hidden="true" tabindex="-1"></a></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb3-3" aria-hidden="true" tabindex="-1"></a><span class="kw">with</span> lib<span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb3-4" aria-hidden="true" tabindex="-1"></a></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb3-5" aria-hidden="true" tabindex="-1"></a><span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb3-6" aria-hidden="true" tabindex="-1"></a>  <span class="va">options</span> <span class="op">=</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb3-7" aria-hidden="true" tabindex="-1"></a>    <span class="va">services</span>.<span class="va">bind</span> <span class="op">=</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb3-8" aria-hidden="true" tabindex="-1"></a>      <span class="va">enable</span> <span class="op">=</span> mkEnableOption <span class="st">"BIND domain name server"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb3-9" aria-hidden="true" tabindex="-1"></a></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb3-10" aria-hidden="true" tabindex="-1"></a>      <span class="va">zones</span> <span class="op">=</span> mkOption <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb3-11" aria-hidden="true" tabindex="-1"></a>        <span class="op">...</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb3-12" aria-hidden="true" tabindex="-1"></a>      <span class="op">};</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb3-13" aria-hidden="true" tabindex="-1"></a>    <span class="op">};</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb3-14" aria-hidden="true" tabindex="-1"></a>  <span class="op">};</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb3-15" aria-hidden="true" tabindex="-1"></a></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb3-16" aria-hidden="true" tabindex="-1"></a>  <span class="va">config</span> <span class="op">=</span> mkIf cfg.enable <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb3-17" aria-hidden="true" tabindex="-1"></a>    <span class="va">systemd</span>.<span class="va">services</span>.<span class="va">bind</span> <span class="op">=</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb3-18" aria-hidden="true" tabindex="-1"></a>      <span class="va">description</span> <span class="op">=</span> <span class="st">"BIND Domain Name Server"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb3-19" aria-hidden="true" tabindex="-1"></a>      <span class="va">after</span> <span class="op">=</span> <span class="op">[</span> <span class="st">"network.target"</span> <span class="op">];</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb3-20" aria-hidden="true" tabindex="-1"></a>      <span class="va">wantedBy</span> <span class="op">=</span> <span class="op">[</span> <span class="st">"multi-user.target"</span> <span class="op">];</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb3-21" aria-hidden="true" tabindex="-1"></a></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb3-22" aria-hidden="true" tabindex="-1"></a>      <span class="va">serviceConfig</span> <span class="op">=</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb3-23" aria-hidden="true" tabindex="-1"></a>        <span class="va">ExecStart</span> <span class="op">=</span> <span class="st">"</span><span class="sc">${</span>pkgs.bind.out<span class="sc">}</span><span class="st">/sbin/named"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb3-24" aria-hidden="true" tabindex="-1"></a>      <span class="op">};</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb3-25" aria-hidden="true" tabindex="-1"></a>    <span class="op">};</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb3-26" aria-hidden="true" tabindex="-1"></a>  <span class="op">};</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb3-27" aria-hidden="true" tabindex="-1"></a><span class="op">}</span></span></code></pre></div>
<p><span>Notice the reference to <code class="verbatim">pkgs.bind</code>. This is the Nixpkgs repository Nix
derivation for the <code class="verbatim">bind</code> package. Recall
that every input to a Nix derivation is itself a Nix derivation (<a href="https://ryan.freumh.org/atom.xml#nixpkgs">§</a>); in order to use a package in a Nix expression –
i.e., a NixOS module – we need to build said package with Nix. Once we
build a Mirage unikernel with Nix, we can write a NixOS module to deploy
it.</span></p>
<h2>Building Unikernels</h2>
<p><span>Mirage uses the package manager
for OCaml called opam<a href="https://ryan.freumh.org/atom.xml#fn7" class="footnote-ref" role="doc-noteref"><sup>7</sup></a>. Dependencies in opam, as is common
in programming language package managers, have a file which – among
other metadata, build/install scripts – specifies dependencies and their
version constraints. For example<a href="https://ryan.freumh.org/atom.xml#fn8" class="footnote-ref" role="doc-noteref"><sup>8</sup></a></span></p>
<pre class="example"><code>...
depends: [
  "arp" { ?monorepo &amp; &gt;= "3.0.0" &amp; &lt; "4.0.0" }
  "ethernet" { ?monorepo &amp; &gt;= "3.0.0" &amp; &lt; "4.0.0" }
  "lwt" { ?monorepo }
  "mirage" { build &amp; &gt;= "4.2.0" &amp; &lt; "4.3.0" }
  "mirage-bootvar-solo5" { ?monorepo &amp; &gt;= "0.6.0" &amp; &lt; "0.7.0" }
  "mirage-clock-solo5" { ?monorepo &amp; &gt;= "4.2.0" &amp; &lt; "5.0.0" }
  "mirage-crypto-rng-mirage" { ?monorepo &amp; &gt;= "0.8.0" &amp; &lt; "0.11.0" }
  "mirage-logs" { ?monorepo &amp; &gt;= "1.2.0" &amp; &lt; "2.0.0" }
  "mirage-net-solo5" { ?monorepo &amp; &gt;= "0.8.0" &amp; &lt; "0.9.0" }
  "mirage-random" { ?monorepo &amp; &gt;= "3.0.0" &amp; &lt; "4.0.0" }
  "mirage-runtime" { ?monorepo &amp; &gt;= "4.2.0" &amp; &lt; "4.3.0" }
  "mirage-solo5" { ?monorepo &amp; &gt;= "0.9.0" &amp; &lt; "0.10.0" }
  "mirage-time" { ?monorepo }
  "mirageio" { ?monorepo }
  "ocaml" { build &amp; &gt;= "4.08.0" }
  "ocaml-solo5" { build &amp; &gt;= "0.8.1" &amp; &lt; "0.9.0" }
  "opam-monorepo" { build &amp; &gt;= "0.3.2" }
  "tcpip" { ?monorepo &amp; &gt;= "7.0.0" &amp; &lt; "8.0.0" }
  "yaml" { ?monorepo &amp; build }
]
...
</code></pre>
<p><span>Each of these dependencies will
have its own dependencies with their own version constraints. As we can
only link one dependency into the resulting program, we need to solve a
set of dependency versions that satisfies these constraints. This is not
an easy problem. In fact, it’s NP-complete <span class="citation" data-cites="coxVersionSAT2016"><a href="https://ryan.freumh.org/atom.xml#ref-coxVersionSAT2016" role="doc-biblioref">[6]</a></span>. Opam uses the Zero Install<a href="https://ryan.freumh.org/atom.xml#fn9" class="footnote-ref" role="doc-noteref"><sup>9</sup></a> SAT solver for dependency
resolution.</span></p>
<p><span>Nixpkgs has many OCaml
packages<a href="https://ryan.freumh.org/atom.xml#fn10" class="footnote-ref" role="doc-noteref"><sup>10</sup></a> which we could provide as build
inputs to a Nix derivation<a href="https://ryan.freumh.org/atom.xml#fn11" class="footnote-ref" role="doc-noteref"><sup>11</sup></a>. However, Nixpkgs has
one global coherent set of package versions<a href="https://ryan.freumh.org/atom.xml#fn12" class="footnote-ref" role="doc-noteref"><sup>12</sup></a><span class="footnote-ref-wrapper"><sup>, </sup><a href="https://ryan.freumh.org/atom.xml#fn13" class="footnote-ref" role="doc-noteref"><sup>13</sup></a></span>. The support for installing
multiple versions of a package concurrently comes from the fact that
they are stored at a unique path and can be referenced separately, or
symlinked, where required. So different projects or users that use a
different version of Nixpkgs won’t conflict, but Nix does not do any
dependency version resolution – everything is pinned<a href="https://ryan.freumh.org/atom.xml#fn14" class="footnote-ref" role="doc-noteref"><sup>14</sup></a>.
This is a problem for opam projects with version constraints that can’t
be satisfied with a static instance of Nixpkgs.</span></p>
<p><span>Luckily, a project from Tweag
already exists (<code class="verbatim">opam-nix</code>) to deal with
this<a href="https://ryan.freumh.org/atom.xml#fn15" class="footnote-ref" role="doc-noteref"><sup>15</sup></a><span class="footnote-ref-wrapper"><sup>, </sup><a href="https://ryan.freumh.org/atom.xml#fn16" class="footnote-ref" role="doc-noteref"><sup>16</sup></a></span>. This project uses the opam
dependency versions solver inside a Nix derivation, and then creates
derivations from the resulting dependency versions<a href="https://ryan.freumh.org/atom.xml#fn17" class="footnote-ref" role="doc-noteref"><sup>17</sup></a>.</span></p>
<p><span>This still doesn’t support
building our Mirage unikernels, though. Unikernels quite often need to
be cross-compiled: compiled to run on a platform other than the one
they’re being built on. A common target, Solo5<a href="https://ryan.freumh.org/atom.xml#fn18" class="footnote-ref" role="doc-noteref"><sup>18</sup></a>,
is a sandboxed execution environment for unikernels. It acts as a
minimal shim layer to interface between unikernels and different
hypervisor backends. Solo5 uses a different <code class="verbatim">glibc</code> which requires cross-compilation. Mirage
4<a href="https://ryan.freumh.org/atom.xml#fn19" class="footnote-ref" role="doc-noteref"><sup>19</sup></a> supports cross compilation with
toolchains in the Dune build system<a href="https://ryan.freumh.org/atom.xml#fn20" class="footnote-ref" role="doc-noteref"><sup>20</sup></a>. This uses a host
compiler installed in an opam switch (a virtual environment) as normal,
as well as a target compiler<a href="https://ryan.freumh.org/atom.xml#fn21" class="footnote-ref" role="doc-noteref"><sup>21</sup></a>. But the
cross-compilation context of packages is only known at build time, as
some metaprogramming modules may require preprocessing with the host
compiler. To ensure that the right compilation context is used, we have
to provide Dune with all our sources’ dependencies. A tool called <code class="verbatim">opam-monorepo</code> was date to do just that<a href="https://ryan.freumh.org/atom.xml#fn22" class="footnote-ref" role="doc-noteref"><sup>22</sup></a>.</span></p>
<p><span>We extended the <code class="verbatim">opam-nix</code> project to support the <code class="verbatim">opam-monorepo</code> workflow with this pull request:
<a href="https://github.com/tweag/opam-nix/pull/18">github.com/tweag/opam-nix/pull/18</a>.</span></p>
<p><span>This is very low-level support
for building Mirage unikernels with Nix, however. In order to provide a
better user experience, we also date the Hillingar Nix flake: <a href="https://github.com/RyanGibb/hillingar">github.com/RyanGibb/hillingar</a>.
This wraps the Mirage tooling and <code class="verbatim">opam-nix</code>
function calls so that a simple high-level flake can be dropped into a
Mirage project to support building it with Nix. To add Nix build support
to a unikernel, simply:</span></p>
<div class="sourceCode" data-org-language="sh"><pre class="sourceCode bash"><code class="sourceCode bash"><span><a href="https://ryan.freumh.org/atom.xml#cb5-1" aria-hidden="true" tabindex="-1"></a><span class="co"># create a flake from hillingar's default template</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb5-2" aria-hidden="true" tabindex="-1"></a><span class="ex">$</span> nix flake new . <span class="at">-t</span> github:/RyanGibb/hillingar</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb5-3" aria-hidden="true" tabindex="-1"></a><span class="co"># substitute the name of the unikernel you're building</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb5-4" aria-hidden="true" tabindex="-1"></a><span class="ex">$</span> sed <span class="at">-i</span> <span class="st">'s/throw "Put the unikernel name here"/"&lt;unikernel-name&gt;"/g'</span> flake.nix</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb5-5" aria-hidden="true" tabindex="-1"></a><span class="co"># build the unikernel with Nix for a particular target</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb5-6" aria-hidden="true" tabindex="-1"></a><span class="ex">$</span> nix build .#<span class="op">&lt;</span>target<span class="op">&gt;</span></span></code></pre></div>
<p><span>For example, see the flake for
building the Mirage website as a unikernel with Nix: <a href="https://github.com/RyanGibb/mirage-www/blob/master/flake.nix">github.com/RyanGibb/mirage-www/blob/master/flake.nix</a>.</span></p>
<h2>Dependency Management</h2>
<p><span>To step back for a moment and
look at the big picture, we can consider a number of different types of
dependencies at play here:</span></p>
<ol type="1">
<li>System dependencies: Are dependencies installed through the system
package manager – <code class="verbatim">depexts</code> in opam
parlance. This is Nix for Hillingar, but another platform’s package
managers include <code class="verbatim">apt</code>, <code class="verbatim">pacman</code>, and <code class="verbatim">brew</code>.
For unikernels, these are often C libraries like <code class="verbatim">gmp</code>.</li>
<li>Library dependencies: Are installed through the programming language
package manager. For example <code class="verbatim">opam</code>, <code class="verbatim">pip</code>, and <code class="verbatim">npm</code>.
These are the dependencies that often have version constraints and
require resolution possibly using a SAT solver.</li>
<li>File dependencies: Are dependencies at the file system level of
granularity. For example, C files, Java (non-inner) classes, or OCaml
modules. Most likely this will be for a single project, but in a
monorepo, these could span many projects which all interoperate (e.g.,
Nixpkgs). This is the level of granularity that builds systems often
deal with, like Make, Dune, and Bazel.</li>
<li>Function dependencies: Are dependencies between functions or another
unit of code native to a language. For example, if function <code class="verbatim">a</code> calls function <code class="verbatim">b</code>, then <code class="verbatim">a</code>
‘depends’ on <code class="verbatim">b</code>. This is the level of
granularity that compilers and interpreters are normally concerned with.
In the realms of higher-order functions this dependance may not be known
in advance, but this is essentially the same problem that build systems
face with dynamic dependencies <span class="citation" data-cites="mokhovBuildSystemsCarte2018"><a href="https://ryan.freumh.org/atom.xml#ref-mokhovBuildSystemsCarte2018" role="doc-biblioref">[7]</a></span>.</li>
</ol>
<p><span>Nix deals well with system
dependencies, but it doesn’t have a native way of resolving library
dependency versions. Opam deals well with library dependencies, but it
doesn’t have a consistent way of installing system packages in a
reproducible way. And Dune deals with file dependencies, but not the
others. The OCaml compiler keeps track of function dependencies when
compiling and linking a program.</span></p>
<h3>Cross-Compilation</h3>
<p><span>Dune is used to support
cross-compilation for Mirage unikernels (<a href="https://ryan.freumh.org/atom.xml#building-unikernels">§</a>). We encode the cross-compilation
context in Dune using the <code class="verbatim">preprocess</code>
stanza from Dune’s DSL, for example from <a href="https://github.com/mirage/mirage-tcpip/blob/3ab30ab7b43dede75abf7b37838e051e0ddbb23a/src/tcp/dune#L9-L10"><code class="verbatim">mirage-tcpip</code></a>:</span></p>
<pre class="example"><code>(library
 (name tcp)
 (public_name tcpip.tcp)
 (instrumentation
  (backend bisect_ppx))
 (libraries logs ipaddr cstruct lwt-dllist mirage-profile tcpip.checksum
   tcpip duration randomconv fmt mirage-time mirage-clock mirage-random
   mirage-flow metrics)
 (preprocess
  (pps ppx_cstruct)))
</code></pre>
<p><span>Which tells Dune to preprocess
the opam package <code class="verbatim">ppx_cstruct</code> with the host
compiler. As this information is only available from the build manager,
this requires fetching all dependency sources to support
cross-compilation with the <code class="verbatim">opam-monorepo</code>
tool:</span></p>
<blockquote>
<p><span>Cross-compilation - the details
of how to build some native code can come late in the pipeline, which
isn’t a problem if the sources are available<a href="https://ryan.freumh.org/atom.xml#fn23" class="footnote-ref" role="doc-noteref"><sup>23</sup></a>.</span></p>
</blockquote>
<p><span>This means we’re essentially
encoding the compilation context in the build system rules. To remove
the requirement to clone dependency sources locally with <code class="verbatim">opam-monorepo</code> we could try and encode the
compilation context in the package manager. However, preprocessing can
be at the OCaml module level of granularity. Dune deals with this level
of granularity with file dependencies, but opam doesn’t. Tighter
integration between the build and package manager could improve this
situation, like Rust’s Cargo. There are some plans towards modularising
opam and creating tighter integration with Dune.</span></p>
<p><span>There is also the possibility of
using Nix to avoid cross-compilation. Nixpkg’s cross compilation<a href="https://ryan.freumh.org/atom.xml#fn24" class="footnote-ref" role="doc-noteref"><sup>24</sup></a> will not innately help us here, as
it simply specifies how to package software in a cross-compilation
friendly way. However, Nix remote builders would enable reproducible
builds on a remote machine<a href="https://ryan.freumh.org/atom.xml#fn25" class="footnote-ref" role="doc-noteref"><sup>25</sup></a> with Nix installed
that may sidestep the need for cross-compilation in certain
contexts.</span></p>
<h3>Version Resolution</h3>
<p><span>Hillingar uses the Zero Install
SAT solver for version resolution through opam. While this works, it
isn’t the most principled approach for getting Nix to work with library
dependencies. Some package managers are just using Nix for system
dependencies and using the existing tooling as normal for library
dependencies<a href="https://ryan.freumh.org/atom.xml#fn26" class="footnote-ref" role="doc-noteref"><sup>26</sup></a>. But generally, <code class="verbatim">X2nix</code> projects are numerous and created in an
<em>ad hoc</em> way. Part of this is dealing with every language’s
ecosystems package repository system, and there are existing
approaches<a href="https://ryan.freumh.org/atom.xml#fn27" class="footnote-ref" role="doc-noteref"><sup>27</sup></a><span class="footnote-ref-wrapper"><sup>, </sup><a href="https://ryan.freumh.org/atom.xml#fn28" class="footnote-ref" role="doc-noteref"><sup>28</sup></a></span> aimed at reducing code
duplication, but there is still the fundamental problem of version
resolution. Nix uses pointers (paths) to refer to different versions of
a dependency, which works well when solving the diamond dependency
problem for system dependencies, but we don’t have this luxury when
linking a binary with library dependencies.</span></p>
<figure class="img-transparent">
<img src="https://ryan.freumh.org/images/version-sat.svg">
<figcaption>The diamond dependency problem <span class="citation" data-cites="coxVersionSAT2016"><a href="https://ryan.freumh.org/atom.xml#ref-coxVersionSAT2016" role="doc-biblioref">[6]</a></span>.</figcaption>
</figure>
<p><span>This is exactly why opam uses a
constraint solver to find a coherent package set. But what if we could
split version-solving functionality into something that can tie into any
language ecosystem? This could be a more principled, elegant, approach
to the current fragmented state of library dependencies (program
language package managers). This would require some ecosystem-specific
logic to obtain, for example, the version constraints and to create
derivations for the resulting sources, but the core functionality could
be ecosystem agnostic. As with <code class="verbatim">opam-nix</code>,
materialization<a href="https://ryan.freumh.org/atom.xml#fn29" class="footnote-ref" role="doc-noteref"><sup>29</sup></a> could be used to commit a lock file
and avoid IFD. Although perhaps this is too lofty a goal to be
practical, and perhaps the real issues are organisational rather than
technical.</span></p>
<p><span>Nix allows multiple versions of
a package to be installed simultaneously by having different derivations
refer to different paths in the Nix store concurrently. What if we could
use a similar approach for linking binaries to sidestep the version
constraint solving altogether at the cost of larger binaries? Nix makes
a similar tradeoff makes with disk space. A very simple approach might
be to programmatically prepend/append functions in <code class="verbatim">D</code> with the dependency version name <code class="verbatim">vers1</code> and <code class="verbatim">vers2</code>
for calls in the packages <code class="verbatim">B</code> and <code class="verbatim">C</code> respectively in the diagram above.</span></p>
<blockquote>
<p><span>Another way to avoid
NP-completeness is to attack assumption 4: what if two different
versions of a package could be installed simultaneously? Then almost any
search algorithm will find a combination of packages to build the
program; it just might not be the smallest possible combination (that’s
still NP-complete). If <code class="verbatim">B</code> needs <code class="verbatim">D</code> 1.5 and <code class="verbatim">C</code> needs
D 2.2, the build can include both packages in the final binary, treating
them as distinct packages. I mentioned above that there can’t be two
definitions of <code class="verbatim">printf</code> built into a C
program, but languages with explicit module systems should have no
problem including separate copies of <code class="verbatim">D</code>
(under different fully-qualified names) into a program. <span class="citation" data-cites="coxVersionSAT2016"><a href="https://ryan.freumh.org/atom.xml#ref-coxVersionSAT2016" role="doc-biblioref">[6]</a></span></span></p>
</blockquote>
<p><span>Another wackier idea is, instead
of having programmers manually specific constraints with version
numbers, to resolve dependencies purely based on typing<a href="https://ryan.freumh.org/atom.xml#fn30" class="footnote-ref" role="doc-noteref"><sup>30</sup></a>.
The issue here is that solving dependencies would now involve type
checking, which could prove computationally expensive.</span></p>
<h3>Build Systems</h3>
<p><span>The build script in a Nix derivation
(if it doesn’t invoke a compiler directly) often invokes a build system
like Make, or in this case Dune. But Nix can also be considered a build
system with a suspending scheduler and deep constructive trace
rebuilding <span class="citation" data-cites="mokhovBuildSystemsCarte2018"><a href="https://ryan.freumh.org/atom.xml#ref-mokhovBuildSystemsCarte2018" role="doc-biblioref">[7]</a></span>. But Nix is at a coarse-grained
package level, invoking these finer-grained build systems to deal with
file dependencies.</span></p>
<p><span>In Chapter 10 of the original Nix
thesis <span class="citation" data-cites="dolstraPurelyFunctionalSoftware2006"><a href="https://ryan.freumh.org/atom.xml#ref-dolstraPurelyFunctionalSoftware2006" role="doc-biblioref">[8]</a></span>, low-level build management using
Nix is discussed, proposing extending Nix to support file dependencies.
For example, to build the ATerm library:</span></p>
<div class="sourceCode"><pre class="sourceCode nix"><code class="sourceCode nix"><span><a href="https://ryan.freumh.org/atom.xml#cb7-1" aria-hidden="true" tabindex="-1"></a><span class="op">{</span><span class="va">sharedLib</span> <span class="op">?</span> <span class="cn">true</span><span class="op">}</span>:</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-2" aria-hidden="true" tabindex="-1"></a></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-3" aria-hidden="true" tabindex="-1"></a><span class="kw">with</span> <span class="op">(</span><span class="bu">import</span> <span class="ss">../../../lib</span><span class="op">);</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-4" aria-hidden="true" tabindex="-1"></a></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-5" aria-hidden="true" tabindex="-1"></a><span class="kw">rec</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-6" aria-hidden="true" tabindex="-1"></a>  <span class="va">sources</span> <span class="op">=</span> <span class="op">[</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-7" aria-hidden="true" tabindex="-1"></a>    <span class="ss">./afun.c</span> <span class="ss">./aterm.c</span> <span class="ss">./bafio.c</span> <span class="ss">./byteio.c</span> <span class="ss">./gc.c</span> <span class="ss">./hash.c</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-8" aria-hidden="true" tabindex="-1"></a>    <span class="ss">./list.c</span> <span class="ss">./make.c</span> <span class="ss">./md5c.c</span> <span class="ss">./memory.c</span> <span class="ss">./tafio.c</span> <span class="ss">./version.c</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-9" aria-hidden="true" tabindex="-1"></a>  <span class="op">];</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-10" aria-hidden="true" tabindex="-1"></a></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-11" aria-hidden="true" tabindex="-1"></a>  <span class="va">compile</span> <span class="op">=</span> <span class="va">main</span><span class="op">:</span> compileC <span class="op">{</span><span class="kw">inherit</span> main sharedLib<span class="op">;};</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-12" aria-hidden="true" tabindex="-1"></a></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-13" aria-hidden="true" tabindex="-1"></a>  <span class="va">libATerm</span> <span class="op">=</span> makeLibrary <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-14" aria-hidden="true" tabindex="-1"></a>    <span class="va">libraryName</span> <span class="op">=</span> <span class="st">"ATerm"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-15" aria-hidden="true" tabindex="-1"></a>    <span class="va">objects</span> <span class="op">=</span> <span class="bu">map</span> compile sources<span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-16" aria-hidden="true" tabindex="-1"></a>    <span class="kw">inherit</span> sharedLib<span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-17" aria-hidden="true" tabindex="-1"></a>  <span class="op">};</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-18" aria-hidden="true" tabindex="-1"></a><span class="op">}</span></span></code></pre></div>
<p><span>This has the advantage over
traditional build systems like Make that if a dependency isn’t
specified, the build will fail. And if the build succeeds, the build
will succeed. So it’s not possible to make incomplete dependency
specifications, which could lead to inconsistent builds.</span></p>
<p><span>A downside, however, is that Nix
doesn’t support dynamic dependencies. We need to know the derivation
inputs in advance of invoking the build script. This is why in Hillingar
we need to use IFD to import from a derivation invoking opam to solve
dependency versions.</span></p>
<p><span>There is prior art that aims to
support building Dune projects with Nix in the low-level manner
described called <a href="https://gitlab.com/balsoft/tumbleweed">tumbleweed</a>. While this
project is now abandoned, it shows the difficulties of trying to work
with existing ecosystems. The Dune build system files need to be parsed
and interpreted in Nix, which either requires convoluted and error-prone
Nix code or painfully slow IFD. The former approach is taken with
tumbleweed which means it could potentially benefit from improving the
Nix language. But fundamentally this still requires the complex task of
reimplementing part of Dune in another language.</span></p>
<p><span>I would be very interested if anyone
reading this knows if this idea went anywhere! A potential issue I see
with this is the computational and storage overhead associated with
storing derivations in the Nix store that are manageable for
coarse-grained dependencies might prove too costly for fine-grained file
dependencies.</span></p>
<p><span>While on the topic of build systems,
to enable more minimal builds tighter integration with the compiler
would enable analysing function dependencies<a href="https://ryan.freumh.org/atom.xml#fn31" class="footnote-ref" role="doc-noteref"><sup>31</sup></a>.
For example, Dune could recompile only certain functions that have
changed since the last invocation. Taking granularity to such a fine
degree will cause a great increase in the size of the build graph,
however. Recomputing this graph for every invocation may prove more
costly than doing the actual rebuilding after a certain point. Perhaps
persisting the build graph and calculating differentials of it could
mitigate this. A meta-build-graph, if you will.</span></p>
<h2>Evaulation</h2>
<p><span>Hillingar’s primary limitations are (1)
complex integration is required with the OCaml ecosystem to solve
dependency version constraints using <code class="verbatim">opam-nix</code>, and (2) that cross-compilation
requires cloning all sources locally with <code class="verbatim">opam-monorepo</code> (<a href="https://ryan.freumh.org/atom.xml#dependency-management">§</a>). Another issue that proved an
annoyance during this project is the Nix DSL’s dynamic typing. When
writing simple derivations this often isn’t a problem, but when writing
complicated logic, it quickly gets in the way of productivity. The
runtime errors produced can be very hard to parse. Thankfully there is
work towards creating a typed language for the Nix deployment system,
such as Nickel<a href="https://ryan.freumh.org/atom.xml#fn32" class="footnote-ref" role="doc-noteref"><sup>32</sup></a>. However, gradual typing is hard,
and Nickel still isn’t ready for real-world use despite being
open-sourced (in a week as of writing this) for two years.</span></p>
<p><span>A glaring omission is that despite it
being the primary motivation, we haven’t actually written a NixOS module
for deploying a DNS server as a unikernel. There are still questions
about how to provide zonefile data declaratively to the unikernel, and
manage the runtime of deployed unikernels. One option to do the latter
is Albatross<a href="https://ryan.freumh.org/atom.xml#fn33" class="footnote-ref" role="doc-noteref"><sup>33</sup></a>, which has recently had support for
building with nix added<a href="https://ryan.freumh.org/atom.xml#fn34" class="footnote-ref" role="doc-noteref"><sup>34</sup></a>. Albatross aims to provision
resources for unikernels such as network access, share resources for
unikernels between users, and monitor unikernels with a Unix daemon.
Using Albatross to manage some of the inherent imperative processes
behind unikernels, as well as share access to resources for unikernels
for other users on a NixOS system, could simplify the creation and
improve the functionality of a NixOS module for a unikernel.</span></p>
<p><span>There also exists related work in the
reproducible building of Mirage unikernels. Specifically, improving the
reproducibility of opam packages (as Mirage unikernels are opam packages
themselves)<a href="https://ryan.freumh.org/atom.xml#fn35" class="footnote-ref" role="doc-noteref"><sup>35</sup></a>. Hillingar differs in that it only
uses opam for version resolution, instead using Nix to provide
dependencies, which provides reproducibility with pinned Nix derivation
inputs and builds in isolation by default.</span></p>
<h2>Conclusion</h2>
<p><span>To summarise, this project was motivated
(<a href="https://ryan.freumh.org/atom.xml#introduction">§</a>) by deploying unikernels on NixOS (<a href="https://ryan.freumh.org/atom.xml#deploying-unikernels">§</a>). Towards this end, we added support
for building MirageOS unikernels with Nix; we extended <code class="verbatim">opam-nix</code> to support the <code class="verbatim">opam-monorepo</code> workflow and created the Hillingar
project to provide a usable Nix interface (<a href="https://ryan.freumh.org/atom.xml#building-unikernels">§</a>). This required scrutinising the OCaml
and Nix ecosystems along the way in order to marry them; some thoughts
on dependency management were developed in this context (<a href="https://ryan.freumh.org/atom.xml#dependency-management">§</a>). Many strange issues and edge cases
were uncovered during this project but now that we’ve encoded them in
Nix, hopefully, others won’t have to repeat the experience!</span></p>
<p><span>While only the first was the primary
motivation, the benefits of building unikernels with Nix are:</span></p>
<ul>
<li>Reproducible and low-config unikernel deployment using NixOS modules
is enabled.</li>
<li>Nix allows reproducible builds pinning system dependencies and
composing multiple language environments. For example, the OCaml package
<code class="verbatim">conf-gmp</code> is a ‘virtual package’ that
relies on a system installation of the C/Assembly library <code class="verbatim">gmp</code> (The GNU Multiple Precision Arithmetic
Library). Nix easily allows us to depend on this package in a
reproducible way.</li>
<li>We can use Nix to support building on different systems (<a href="https://ryan.freumh.org/atom.xml#cross-compilation">§</a>).</li>
</ul>
<p><span>While NixOS and MirageOS take
fundamentally very different approaches, they’re both trying to bring
some kind of functional programming paradigm to operating systems. NixOS
does this in a top-down manner, trying to tame Unix with functional
principles like laziness and immutability<a href="https://ryan.freumh.org/atom.xml#fn36" class="footnote-ref" role="doc-noteref"><sup>36</sup></a>;
whereas, MirageOS does this by throwing Unix out the window and
rebuilding the world from scratch in a very much bottom-up approach.
Despite these two projects having different motivations and goals,
Hillingar aims to get the best from both worlds by marrying the
two.</span></p>
<hr>
<p><span>I want to thank some people for their
help with this project:</span></p>
<ul>
<li>Lucas Pluvinage for invaluable help with the OCaml ecosystem.</li>
<li>Alexander Bantyev for getting me up to speed with the <code class="verbatim">opam-nix</code> project and working with me on the
<code class="verbatim">opam-monorepo</code> workflow integration.</li>
<li>David Allsopp for his opam expertise.</li>
<li>Jules Aguillon and Olivier Nicole for their fellow
Nix-enthusiasm.</li>
<li>Sonja Heinze for her PPX insights.</li>
<li>Anil Madhavapeddy for having a discussion that led to the idea for
this project.</li>
<li>Björg Bjarnadóttir for her Icelandic language consultation.</li>
<li>And finally, everyone at Tarides for being so welcoming and
helpful!</li>
</ul>
<p><span>This work was completed with the support
of <a href="https://tarides.com/">Tarides</a>, and a version of this
blog post can be found <a href="https://tarides.com/blog/2022-12-14-hillingar-mirageos-unikernels-on-nixos">on
the Tarides website</a>.</span></p>
<p><span>If you have any questions or comments on
this feel free to <a href="https://ryan.freumh.org/about.html#contact">get in
touch</a>.</span></p>
<p><span>If you have a unikernel, consider trying
to build it with Hillingar, and please report any problems at <a href="https://github.com/RyanGibb/hillingar/issues">github.com/RyanGibb/hillingar/issues</a>!</span></p>
<hr>
<h2>References</h2>
<p><span><span></span></span></p>
<div class="references csl-bib-body" data-entry-spacing="0" role="list">
<div class="csl-entry" role="listitem">
<span><div class="csl-left-margin">[1] </div><div class="csl-right-inline">W. H. Lehn, <span>“The <span>Novaya
Zemlya</span> effect: <span>An</span> arctic mirage,”</span> <em>J. Opt.
Soc. Am., JOSA</em>, vol. 69, no. 5, pp. 776–781, May 1979, doi: <a href="https://doi.org/10.1364/JOSA.69.000776">10.1364/JOSA.69.000776</a>.
[Online]. Available: <a href="https://opg.optica.org/josa/abstract.cfm?uri=josa-69-5-776">https://opg.optica.org/josa/abstract.cfm?uri=josa-69-5-776</a>.
[Accessed: Oct. 05, 2022]</div></span>
</div>
<div class="csl-entry" role="listitem">
<span><div class="csl-left-margin">[2] </div><div class="csl-right-inline">R. T. Gibb, <span>“Spatial <span>Name
System</span>,”</span> Nov. 30, 2022. [Online]. Available: <a href="http://arxiv.org/abs/2210.05036">http://arxiv.org/abs/2210.05036</a>.
[Accessed: Jun. 30, 2023]</div></span>
</div>
<div class="csl-entry" role="listitem">
<span><div class="csl-left-margin">[3] </div><div class="csl-right-inline">A. Madhavapeddy, A. Ho, T. Deegan, D. Scott,
and R. Sohan, <span>“Melange: Creating a "functional" internet,”</span>
<em>SIGOPS Oper. Syst. Rev.</em>, vol. 41, no. 3, pp. 101–114, Mar.
2007, doi: <a href="https://doi.org/10.1145/1272998.1273009">10.1145/1272998.1273009</a>.
[Online]. Available: <a href="https://doi.org/10.1145/1272998.1273009">https://doi.org/10.1145/1272998.1273009</a>.
[Accessed: Feb. 10, 2022]</div></span>
</div>
<div class="csl-entry" role="listitem">
<span><div class="csl-left-margin">[4] </div><div class="csl-right-inline">A. Madhavapeddy <em>et al.</em>,
<span>“Unikernels: Library operating systems for the cloud,”</span>
<em>SIGARCH Comput. Archit. News</em>, vol. 41, no. 1, pp. 461–472, Mar.
2013, doi: <a href="https://doi.org/10.1145/2490301.2451167">10.1145/2490301.2451167</a>.
[Online]. Available: <a href="https://doi.org/10.1145/2490301.2451167">https://doi.org/10.1145/2490301.2451167</a>.
[Accessed: Jan. 25, 2022]</div></span>
</div>
<div class="csl-entry" role="listitem">
<span><div class="csl-left-margin">[5] </div><div class="csl-right-inline">D. R. Engler, M. F. Kaashoek, and J. O’Toole,
<span>“Exokernel: An operating system architecture for application-level
resource management,”</span> <em>SIGOPS Oper. Syst. Rev.</em>, vol. 29,
no. 5, pp. 251–266, Dec. 1995, doi: <a href="https://doi.org/10.1145/224057.224076">10.1145/224057.224076</a>.
[Online]. Available: <a href="https://doi.org/10.1145/224057.224076">https://doi.org/10.1145/224057.224076</a>.
[Accessed: Jan. 25, 2022]</div></span>
</div>
<div class="csl-entry" role="listitem">
<span><div class="csl-left-margin">[6] </div><div class="csl-right-inline">R. Cox, <span>“Version
<span>SAT</span>,”</span> Dec. 13, 2016. [Online]. Available: <a href="https://research.swtch.com/version-sat">https://research.swtch.com/version-sat</a>.
[Accessed: Oct. 16, 2022]</div></span>
</div>
<div class="csl-entry" role="listitem">
<span><div class="csl-left-margin">[7] </div><div class="csl-right-inline">A. Mokhov, N. Mitchell, and S. Peyton Jones,
<span>“Build systems à la carte,”</span> <em>Proc. ACM Program.
Lang.</em>, vol. 2, pp. 1–29, Jul. 2018, doi: <a href="https://doi.org/10.1145/3236774">10.1145/3236774</a>. [Online].
Available: <a href="https://dl.acm.org/doi/10.1145/3236774">https://dl.acm.org/doi/10.1145/3236774</a>.
[Accessed: Oct. 11, 2022]</div></span>
</div>
<div class="csl-entry" role="listitem">
<span><div class="csl-left-margin">[8] </div><div class="csl-right-inline">E. Dolstra, <span>“The purely functional
software deployment model,”</span> [s.n.], S.l., 2006 [Online].
Available: <a href="https://edolstra.github.io/pubs/phd-thesis.pdf">https://edolstra.github.io/pubs/phd-thesis.pdf</a></div></span>
</div>
</div>
<section class="footnotes footnotes-end-of-document" role="doc-endnotes">
<hr>
<ol>
<li><p><span><a href="https://ryan.freumh.org/dns-loc-rr.html">DNS LOC</a></span><a href="https://ryan.freumh.org/atom.xml#fnref1" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span><a href="https://www.isc.org/bind/">ISC bind</a> has many <a href="https://www.cvedetails.com/product/144/ISC-Bind.html?vendor_id=64">CVE’s</a></span><a href="https://ryan.freumh.org/atom.xml#fnref2" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span><a href="https://mirage.io">mirage.io</a></span><a href="https://ryan.freumh.org/atom.xml#fnref3" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span>Credits to Takayuki
Imada</span><a href="https://ryan.freumh.org/atom.xml#fnref4" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span>Barring the use of <a href="https://mirage.io/blog/modular-foreign-function-bindings">foreign
function interfaces</a> (FFIs).</span><a href="https://ryan.freumh.org/atom.xml#fnref5" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span>The full module
can be found <a href="https://github.com/NixOS/nixpkgs/blob/fe76645aaf2fac3baaa2813fd0089930689c53b5/nixos/modules/services/networking/bind.nix">here</a></span><a href="https://ryan.freumh.org/atom.xml#fnref6" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span><a href="https://opam.ocaml.org/">opam.ocaml.org</a></span><a href="https://ryan.freumh.org/atom.xml#fnref7" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span>For <a href="https://github.com/mirage/mirage-www">mirage-www</a> targetting
<code class="verbatim">hvt</code>.</span><a href="https://ryan.freumh.org/atom.xml#fnref8" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span><a href="https://0install.net">0install.net</a></span><a href="https://ryan.freumh.org/atom.xml#fnref9" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span><a href="https://github.com/NixOS/nixpkgs/blob/9234f5a17e1a7820b5e91ecd4ff0de449e293383/pkgs/development/ocaml-modules/">github.com/NixOS/nixpkgs
pkgs/development/ocaml-modules</a></span><a href="https://ryan.freumh.org/atom.xml#fnref10" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span>NB they are not
as complete nor up-to-date as those in <code class="verbatim">opam-repository</code> <a href="https://github.com/ocaml/opam-repository">github.com/ocaml/opam-repository</a>.</span><a href="https://ryan.freumh.org/atom.xml#fnref11" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span>Bar some
exceptional packages that have multiple major versions packaged, like
Postgres.</span><a href="https://ryan.freumh.org/atom.xml#fnref12" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span>In fact Arch has
the same approach, which is why it <a href="https://ryan.freumh.org/nix.html#nixos">doesn’t
support partial upgrades</a>.</span><a href="https://ryan.freumh.org/atom.xml#fnref13" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span>This has led to
much confusion with how to install a specific version of a package <a href="https://github.com/NixOS/nixpkgs/issues/9682">github.com/NixOS/nixpkgs/issues/9682</a>.</span><a href="https://ryan.freumh.org/atom.xml#fnref14" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span><a href="https://github.com/tweag/opam-nix">github.com/tweag/opam-nix</a></span><a href="https://ryan.freumh.org/atom.xml#fnref15" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span>Another project,
<a href="https://github.com/timbertson/opam2nix">timbertson/opam2nix</a>,
also exists but depends on a binary of itself at build time as it’s
written in OCaml as opposed to Nix, is not as minimal (higher LOC
count), and it isn’t under active development (with development focused
on <a href="https://github.com/timbertson/fetlock">github.com/timbertson/fetlock</a>)</span><a href="https://ryan.freumh.org/atom.xml#fnref16" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span>Using something
called <a href="https://nixos.wiki/wiki/Import_From_Derivation">Import
From Derivation (IFD)</a>. Materialisation can be used to create a kind
of lock file for this resolution, which can be committed to the project
to avoid having to do IFD on every new build. An alternative may be to
use opam’s built-in version pinning[fn:47].</span><a href="https://ryan.freumh.org/atom.xml#fnref17" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span><a href="https://github.com/Solo5/solo5">github.com/Solo5/solo5</a></span><a href="https://ryan.freumh.org/atom.xml#fnref18" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span><a href="https://mirage.io/blog/announcing-mirage-40">mirage.io/blog/announcing-mirage-40</a></span><a href="https://ryan.freumh.org/atom.xml#fnref19" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span><a href="https://dune.build">dune.build</a></span><a href="https://ryan.freumh.org/atom.xml#fnref20" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span><a href="https://github.com/mirage/ocaml-solo5">github.com/mirage/ocaml-solo5</a></span><a href="https://ryan.freumh.org/atom.xml#fnref21" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span><a href="https://github.com/tarides/opam-monorepo">github.com/tarides/opam-monorepo</a></span><a href="https://ryan.freumh.org/atom.xml#fnref22" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span><a href="https://github.com/tarides/opam-monorepo/blob/feeb325c9c8d560c6b92cbde62b6a9c5f20ed032/doc/faq.mld#L42">github.com/tarides/opam-monorepo</a></span><a href="https://ryan.freumh.org/atom.xml#fnref23" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span><a href="https://nixos.org/manual/nixpkgs/stable/#chap-cross">nixos.org/manual/nixpkgs/stable/#chap-cross</a></span><a href="https://ryan.freumh.org/atom.xml#fnref24" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span><a href="https://nixos.org/manual/nix/stable/advanced-topics/distributed-builds.html">nixos.org/manual/nix/stable/advanced-topics/distributed-builds.html</a></span><a href="https://ryan.freumh.org/atom.xml#fnref25" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span><a href="https://docs.haskellstack.org/en/stable/nix_integration/">docs.haskellstack.org/en/stable/nix_integration</a></span><a href="https://ryan.freumh.org/atom.xml#fnref26" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span><a href="https://github.com/nix-community/dream2nix">github.com/nix-community/dream2nix</a></span><a href="https://ryan.freumh.org/atom.xml#fnref27" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span><a href="https://github.com/timbertson/fetlock">github.com/timbertson/fetlock</a></span><a href="https://ryan.freumh.org/atom.xml#fnref28" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span><a href="https://github.com/tweag/opam-nix/blob/4e602e02a82a720c2f1d7324ea29dc9c7916a9c2/README.md#materialization"><span>https://github.com/tweag/opam-nix#materialization</span></a></span><a href="https://ryan.freumh.org/atom.xml#fnref29" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span><a href="https://twitter.com/TheLortex/status/1571884882363830273">twitter.com/TheLortex/status/1571884882363830273</a></span><a href="https://ryan.freumh.org/atom.xml#fnref30" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span><a href="https://signalsandthreads.com/build-systems/#4305">signalsandthreads.com/build-systems/#4305</a></span><a href="https://ryan.freumh.org/atom.xml#fnref31" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span><a href="https://www.tweag.io/blog/2020-10-22-nickel-open-sourcing/">www.tweag.io/blog/2020-10-22-nickel-open-sourcing</a></span><a href="https://ryan.freumh.org/atom.xml#fnref32" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span><a href="https://hannes.robur.coop/Posts/VMM">hannes.robur.coop/Posts/VMM</a></span><a href="https://ryan.freumh.org/atom.xml#fnref33" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span><a href="https://github.com/roburio/albatross/pull/120">https://github.com/roburio/albatross/pull/120</a></span><a href="https://ryan.freumh.org/atom.xml#fnref34" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span><a href="https://hannes.nqsb.io/Posts/ReproducibleOPAM">hannes.nqsb.io/Posts/ReproducibleOPAM</a></span><a href="https://ryan.freumh.org/atom.xml#fnref35" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span><a href="https://www.tweag.io/blog/2022-07-14-taming-unix-with-nix/">tweag.io/blog/2022-07-14-taming-unix-with-nix</a></span><a href="https://ryan.freumh.org/atom.xml#fnref36" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
</ol>
</section>
    </section>
</article>


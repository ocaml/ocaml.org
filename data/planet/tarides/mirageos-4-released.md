---
title: MirageOS 4 Released!
description: "Tarides is delighted to announce that MirageOS 4 is finally released!
  As core contributors to the project, we are proud to have been part of\u2026"
url: https://tarides.com/blog/2022-03-29-mirageos-4-released
date: 2022-03-29T00:00:00-00:00
preview_image: https://tarides.com/static/393425633dfedffb8749b36f48537ebd/eee8e/desert_mirage.jpg
featured:
---

<p>Tarides is delighted to announce that <a href="https://mirage.io">MirageOS 4</a> is finally released! As core contributors to the project, we are proud to have been part of the journey to 4.0.</p>
<p>What is MirageOS?
MirageOS is a library operating system that constructs unikernels for fast and secure network applications that work across a variety of cloud computing and mobile platforms. The goal of MirageOS is to give the individual control of their own data and take back control of their privacy.</p>
<p>It achieves these goals in several ways, from securely deploying <a href="https://github.com/roburio/unipi">static website hosting</a> with <em>Let&rsquo;s Encrypt</em> certificate provisioning and a secure <a href="https://github.com/mirage/ptt">SMTP stack</a>, to ensuring data privacy with decentralised communication infrastructures like <a href="https://github.com/mirage/ocaml-matrix">Matrix</a>, <a href="https://github.com/roburio/openvpn">OpenVPN Servers</a>, and <a href="https://github.com/roburio/tlstunnel">TLS tunnels</a>, as well as using <a href="https://github.com/mirage/ocaml-dns">DNS(SEC) Servers</a> for better authentication.</p>
<p>Over the years since its first release in 2013, the Mirage ecosystem has grown to include <a href="https://github.com/mirage/">hundreds of libraries</a> and service millions of daily users, along with several major commercial users that rely on MirageOS to keep their code secure. Examples of this include <a href="https://www.docker.com/blog/how-docker-desktop-networking-works-under-the-hood/">Docker Desktop&rsquo;s VPNkit</a>, the <a href="https://www.citrix.com/fr-fr/products/citrix-hypervisor/">Citrix Hypervisor</a>, as well as <a href="https://robur.io">Robur</a>, <a href="https://www.nitrokey.com/products/nethsm">Nitrokey</a>, and Tarides itself!</p>
<p>What&rsquo;s in the New Release?
The new release focuses on better integration with existing ecosystems. For example, it is now much easier to integrate with existing OCaml libraries, as MirageOS 4 is now using <code>dune</code> to build unikernels.</p>
<p>There has also been a major change in how MirageOS compiles projects with the introduction of a new tool called <a href="https://github.com/ocamllabs/opam-monorepo"><code>opam-monorepo</code></a> that separates package management from building the resulting source code. The Opam plugin can create a lock file for project dependencies, download and extract dependency sources locally, and even set up a <a href="https://dune.readthedocs.io/en/stable/dune-files.html#dune-workspace-1">Dune workspace</a>, which then enables <code>dune build</code> to build everything simultaneously.</p>
<p>The new release also adds systematic support for cross-compilation to all supported unikernel targets, meaning that libraries that use C stubs can now have those stubs seamlessly cross-compiled to a desired target.</p>
<p>To find out more about the new release please read <a href="https://mirage.io/blog/announcing-mirage-40">the official release post on Mirage.io</a>.</p>
<p>Keep an eye on <a href="https://mirage.io">mirage.io</a>'s blog over the next two weeks for more posts on the exciting new things that come with MirageOS 4.0, starting with &ldquo;Introduction to Build Contexts in MirageOS 4.0&rdquo; tomorrow!</p>

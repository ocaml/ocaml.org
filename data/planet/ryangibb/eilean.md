---
title: Eilean
description:
url: https://ryan.freumh.org/eilean.html
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
    
        <div> Tags: <a href="https://ryan.freumh.org/research.html" title="All pages tagged 'research'." rel="tag">research</a>, <a href="https://ryan.freumh.org/projects.html" title="All pages tagged 'projects'." rel="tag">projects</a>, <a href="https://ryan.freumh.org/self-hosting.html" title="All pages tagged 'self-hosting'." rel="tag">self-hosting</a>. </div>
    
    <section>
        <blockquote>
<p><span>Eilean (<em>ˈelan</em>) – Scots Gaelic:
island.</span></p>
</blockquote>
<p><span>Our digital lives are increasingly fragmented
across numerous centralised online services. This model concentrates
power, leaving us with minimal technical control over our personal data
and online identities. The long-term permanence of these platforms is
uncertain, and their commercial incentives are often misaligned with
user interests <span class="citation" data-cites="nottinghamCentralizationDecentralizationInternet2023"><a href="https://ryan.freumh.org/atom.xml#ref-nottinghamCentralizationDecentralizationInternet2023" role="doc-biblioref">[1]</a></span>.</span></p>
<p><span>We propose inverting this model: instead of
centralising our data in proprietary silos, let’s centralise our
presence under our own control using open, federated services. We
introduce the concept of ‘digital islands’, or <em>Eileans</em> –
self-hosted hubs for an individual’s or community’s online presence. By
hosting services ourselves, we regain autonomy and control.</span></p>
<p><span>Eilean is a project designed to simplify the
creation and management of these digital islands. The core idea is to
parameterise a complete operating system deployment by a domain name and
a desired set of services. This allows users to easily deploy their own
instances of federated services like <a href="https://matrix.org/">Matrix</a>, <a href="https://joinmastodon.org/">Mastodon</a>, Bluesky’s AT Protocol
<span class="citation" data-cites="kleppmannBlueskyProtocolUsable2024"><a href="https://ryan.freumh.org/atom.xml#ref-kleppmannBlueskyProtocolUsable2024" role="doc-biblioref">[2]</a></span>, and <a href="https://www.rfc-editor.org/rfc/rfc822"><span style="white-space:nowrap;">E-Mail</span></a>.</span></p>
<p><span>We utilise NixOS to enable declarative,
reproducible configuration and deployment of these services. This
provides strong guarantees about the system’s state. <a href="https://github.com/RyanGibb/eilean-nix">Eilean</a> originated from
my personal NixOS configurations for self-hosting, spun out on 1 Dec
2022. (Do <a href="https://ryan.freumh.org/about.html#contact">get in touch</a> if you’re keen
on trying it out.)</span></p>
<p><span>However, while NixOS is great for declarative OS
configuration, it presents challenges for:</span></p>
<ol type="1">
<li><p><span><strong>Managing mutable
state</strong></span></p>
<ul>
<li><p><span><strong><strong>Secrets</strong></strong>: The
Nix store is world-readable (<a href="https://github.com/NixOS/nix/pull/329">Nix PR #329</a>), making
direct embedding of secrets problematic. Secure secret injection and
rotation require external mechanisms like <a href="https://github.com/ryantm/agenix">agenix</a> or <a href="https://github.com/Mic92/sops-nix">sops-nix</a>.</span></p></li>
<li><p><span><strong><strong>Network</strong></strong>:
Services implicitly depend on resources such as IP addresses, domain
names, or certificates. For example, while HTTP servers can provision
certificates with ACME’s HTTP challenge for public-facing services,
provisioning TLS certificates for services behind firewalls or NAT
requires DNS challenges and manual integration with DNS
providers.</span></p></li>
<li><p><span><strong><strong>Data</strong></strong>: NixOS
doesn’t manage application data lifecycles like database schema
migrations. Though interesting work has been done to manage runtime
state with the software state using snapshotting filesystems <span class="citation" data-cites="denbreejenManagingStatePurely2008"><a href="https://ryan.freumh.org/atom.xml#ref-denbreejenManagingStatePurely2008" role="doc-biblioref">[3]</a></span>.</span></p></li>
</ul></li>
<li><p><span><strong>Runtime service
management</strong></span></p>
<ul>
<li><strong><strong>Dynamic reconfiguration</strong></strong>: Changing
service parameters often requires a time-consuming NixOS evaluation and
rebuild, and frequently involves downtime (breaking before making).</li>
</ul>
<ul>
<li><p><span><strong><strong>Multi-machine
coordination</strong></strong>: Deploying and coordinating services
across disparate machines requires mechanisms beyond standard NixOS
tooling.</span></p></li>
<li><p><span><strong><strong>Auto-scaling</strong></strong>: If a
service runs out of, say, storage space, it should be able to
automatically provision more. If the load on a service is too high, it
should be able to duplicate itself and split the work.</span></p></li>
</ul></li>
<li><p><span><strong>Cross-ecosystem packaging:</strong>
Nix excels at system-level reproducibility but struggles with the scale
and versioning complexities of diverse language ecosystems (lacking
built-in version solving like most language-specific package
managers).</span></p></li>
</ol>
<p><span>Tools like Docker Compose and Kubernetes offer
more flexibility in dynamic runtime management but often sacrifice the
strong reproducibility guarantees provided by Nix.</span></p>
<p><span>To address these limitations, we are exploring
several approaches:</span></p>
<ol type="1">
<li><p><span><strong><strong>Capability-based resource
management</strong></strong>: We’ve extended <a href="https://ryan.freumh.org/eon.html">Eon</a>
with a <a href="https://capnproto.org/">Cap’n Proto</a> capability-based
RPC interface for managing network resources. Currently, it offers
capabilities for:</span></p>
<ul>
<li><strong><strong>DNS management</strong></strong>: Allowing secure
delegation of DNS zone control for dynamic updates and propagation to
secondary nameservers.</li>
<li><strong><strong>TLS certificate provisioning</strong></strong>:
Enabling services (even those not publicly accessible or running HTTP
servers) to obtain certificates via the ACME DNS challenge. Eilean
heavily utilises this through a custom NixOS module.</li>
</ul>
<p><span>This capability model could be extended to manage
other resources like secrets or storage, providing a unified RPC
interface to write more integrated and composable networked
applications.</span></p></li>
<li><p><span><strong><strong>Cross-ecosystem
packaging</strong></strong>: <a href="https://ryan.freumh.org/enki.html">Enki</a> aims to bridge
this gap by resolving package dependencies across ecosystems and
preparing them for deployment via Nix or otherwise.</span></p></li>
<li><p><span><strong><strong>Modern
containerisation</strong></strong>: To able the dynamism required for
our runtime service management, as well as security, a service manager
should isolate services, such as <code class="verbatim">systemd-nspawn</code> using Linux namespaces. Patrick’s
work on <a href="https://patrick.sirref.org/shelter/index.xml">shelter</a> is
promising as a potential foundation for lightweight, secure
containerisation.</span></p></li>
</ol>
<p><span>If we can create something to fulfil these
criteria, could this model apply elsewhere? We envision creating
composable applications and self-managing systems built upon this
basis.</span></p>
<ul>
<li><p><span><strong><strong>Decentralised
infrastructure</strong></strong>: Could devices like Raspberry Pis, old
Android phones, or ESP32 chips act as remote sensors or nodes in a
larger, self-managing system? Relevant work is
<span style="font-variant: small-caps;">ReUpNix</span> which looks at
deploying NixOS on embedded devices <span class="citation" data-cites="gollenstedeReUpNixReconfigurableUpdateable2023"><a href="https://ryan.freumh.org/atom.xml#ref-gollenstedeReUpNixReconfigurableUpdateable2023" role="doc-biblioref">[4]</a></span>. I’m interested in this as
infrastructure for <a href="https://ryan.freumh.org/spatial-computing.html">spatial
computing</a>.</span></p></li>
<li><p><span><strong><strong>A Self-healing
OS</strong></strong>: Can we build systems that automatically manage
their resources and runtime state, dynamically provisioning resources,
and healing from failures?</span></p></li>
</ul>
<ul>
<li><strong><strong>Distributed capabilities</strong></strong>:
Expanding the capability RPC model could lead to more sophisticated
distributed systems where resources are securely shared and managed
across hosts and domains. <a href="https://www.gnu.org/software/shepherd/">GNU Shepherd</a>’s port to
<a href="https://spritely.institute/goblins/">Guile Goblins</a> using
the <a href="https://spritely.institute/news/introducing-ocapn-interoperable-capabilities-over-the-network.html">OCapN</a>
protocol (similar to <a href="https://capnproto.org/">Cap’n Proto</a>,
who are in the standardisation group) is a really interesting
development here.</li>
</ul>
<p><span>I also have some <a href="https://ryan.freumh.org/2024-05-27.html#nixos-modules">issues</a> with the <a href="https://ryan.freumh.org/nix.html#nixos">NixOS</a> module system and the Nix DSL and am
interested in an OCaml interface to the Nix store.</span></p>
<div class="references csl-bib-body" data-entry-spacing="0" role="list">
<div class="csl-entry" role="listitem">
<span><div class="csl-left-margin">[1] </div><div class="csl-right-inline">M. Nottingham, <span>“Centralization,
<span>Decentralization</span>, and <span>Internet
Standards</span>,”</span> Internet Engineering Task Force, Request for
Comments RFC 9518, Dec. 2023 [Online]. Available: <a href="https://datatracker.ietf.org/doc/rfc9518">https://datatracker.ietf.org/doc/rfc9518</a>.
[Accessed: Apr. 15, 2025]</div></span>
</div>
<div class="csl-entry" role="listitem">
<span><div class="csl-left-margin">[2] </div><div class="csl-right-inline">M. Kleppmann <em>et al.</em>, <span>“Bluesky
and the <span>AT Protocol</span>: <span>Usable Decentralized Social
Media</span>,”</span> in <em>Proceedings of the <span>ACM Conext-2024
Workshop</span> on the <span>Decentralization</span> of the
<span>Internet</span></em>, Dec. 2024, pp. 1–7, doi: <a href="https://doi.org/10.1145/3694809.3700740">10.1145/3694809.3700740</a>
[Online]. Available: <a href="http://arxiv.org/abs/2402.03239">http://arxiv.org/abs/2402.03239</a>.
[Accessed: Mar. 25, 2025]</div></span>
</div>
<div class="csl-entry" role="listitem">
<span><div class="csl-left-margin">[3] </div><div class="csl-right-inline">W. den Breejen, <span>“Managing state in a
purely functional deployment model,”</span> MSc Thesis, Utrecht
University, 2008 [Online]. Available: <a href="http://denbreejen.net/web/thesis.pdf">http://denbreejen.net/web/thesis.pdf</a>.
[Accessed: Jul. 05, 2024]</div></span>
</div>
<div class="csl-entry" role="listitem">
<span><div class="csl-left-margin">[4] </div><div class="csl-right-inline">N. Gollenstede, U. Kulau, and C. Dietrich,
<span>“<span class="nocase">reUpNix</span>: <span>Reconfigurable</span>
and <span>Updateable Embedded Systems</span>,”</span> in <em>Proceedings
of the 24th <span>ACM SIGPLAN</span>/<span>SIGBED International
Conference</span> on <span>Languages</span>, <span>Compilers</span>, and
<span>Tools</span> for <span>Embedded Systems</span></em>, Jun. 2023,
pp. 40–51, doi: <a href="https://doi.org/10.1145/3589610.3596273">10.1145/3589610.3596273</a>
[Online]. Available: <a href="https://dl.acm.org/doi/10.1145/3589610.3596273">https://dl.acm.org/doi/10.1145/3589610.3596273</a>.
[Accessed: Apr. 23, 2025]</div></span>
</div>
</div>
    </section>
</article>


---
title: Eon
description:
url: https://ryan.freumh.org/eon.html
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
        <p><span><a href="https://github.com/ryanGibb/eon">Eon</a>
is an Effects-based OCaml Nameserver using <a href="https://mirage.io/">MirageOS</a>’s functionally pure Domain Name
System (DNS) <a href="https://github.com/mirage/ocaml-dns">library</a>
with <a href="https://github.com/ocaml-multicore/eio">direct-style
IO</a> (as opposed to <a href="https://en.wikipedia.org/wiki/Monad_(functional_programming)#IO_monad_(Haskell)">monadic
IO</a>) using <a href="https://ocaml.org/releases/5.0.0">OCaml 5</a>’s
<a href="https://ocaml.org/manual/5.0/effects.html">effect handlers</a>
<span class="citation" data-cites="sivaramakrishnanRetrofittingEffectHandlers2021"><a href="https://ryan.freumh.org/atom.xml#ref-sivaramakrishnanRetrofittingEffectHandlers2021" role="doc-biblioref">[1]</a></span> created as the basis to implement
some of ideas from the <a href="https://ryan.freumh.org/sns.html">Spatial Name
System</a>.</span></p>
<h2>DNS Tunnelling</h2>
<p><span>DNS is well-known to be used for <a href="https://en.wikipedia.org/wiki/Data_exfiltration">data
exfiltration</a> and <a href="https://en.wikipedia.org/wiki/Tunneling_protocol">tunneling</a>,
since DNS is one of the few protocols that’s almost always allowed
through a firewall (at least through a recursive resolver) since it’s so
fundamental to the operation of the Internet. I’ve implemented a
transport layer over DNS <a href="https://github.com/RyanGibb/eon/tree/main/lib/transport">in
Eon</a>, a simple <a href="https://github.com/RyanGibb/eon/tree/main/bin/transport/netcat">netcat</a>
example shows how this can be used to transport data using DNS queries.
Many thanks to <a href="https://github.com/panglesd">Paul-Elliot</a> for
helping clean up the transport interface and making it more
idiomatically functional. At the moment there’s no multiplexing – a
server can only handle one communication at a time, but that could
addresses by adding a demultiplexing field (a ‘port’).</span></p>
<p><span>The well-defined interfaces that
OCaml gives us allows this to be combined in interesting ways, such as a
<a href="https://github.com/RyanGibb/eon/tree/main/bin/transport/sod">shell
over DNS</a> (SoD), or an <a href="https://github.com/RyanGibb/eon/tree/main/bin/transport/tunnel">IP
tunnel</a>. Note that you wouldn’t want to use this in production
without some form of encryption (maybe <a href="https://github.com/mirleft/ocaml-tls">ocaml-tls</a>?) and
authentication (e.g. public/private keys, or capabilities). A standalone
example of a capability interface to a shell can be found at <a href="https://github.com/RyanGibb/capability-shell">capability-shell</a>.</span></p>
<p><span>There’s some interesting performance
characteristics of this tunneling in a variable asymmetry of latency
between the sender and receiver, since we’re retrofitting bidirectional
packet switching onto a request response protocol. That is, for the DNS
server to send data to a client it has to have a query to respond to. We
can’t wait to respond to a query until we have data, since recursive
resolvers aggressively timeout and return a <code class="verbatim">SERVFAIL</code> in the case of a delayed reply. So we
have the client periodically poll the server with queries containing no
data, so the latency of the server to client link is bounded by the
period of this polling.</span></p>
<p><span>This is interesting as it allows us
to bootstrap communication with a nameserver using nothing but
DNS.</span></p>
<h2>Capability Interface</h2>
<p><span>DNS is an old protocol, and
has some baked-in limitations due to <a href="https://en.wikipedia.org/wiki/Protocol_ossification">protocol
ossification</a> (such as a maximum domain name length of 255 bytes).
The ‘back-end’ of the protocol, interactions between services under your
control, is easier to evolve. The AXFR zone transfers defined with the
Domain Name System <span class="citation" data-cites="DomainNamesImplementation1987"><a href="https://ryan.freumh.org/atom.xml#ref-DomainNamesImplementation1987" role="doc-biblioref">[2]</a></span> are often replaced with some form of
database replication in nameserver implementations. Dynamic updates
<span class="citation" data-cites="vixieDynamicUpdatesDomain1997"><a href="https://ryan.freumh.org/atom.xml#ref-vixieDynamicUpdatesDomain1997" role="doc-biblioref">[3]</a></span> using secret key transaction
signatures <span class="citation" data-cites="eastlake3rdSecretKeyTransaction2000"><a href="https://ryan.freumh.org/atom.xml#ref-eastlake3rdSecretKeyTransaction2000" role="doc-biblioref">[4]</a></span> are often eschewed in favour of
custom APIs<a href="https://ryan.freumh.org/atom.xml#fn1" class="footnote-ref" role="doc-noteref"><sup>1</sup></a>. While using these protocols allows
an variety of nameserver implementations to interoperate, in practice
they are often replaced with custom solutions.</span></p>
<p><span>We’ve experimented with a <a href="https://github.com/RyanGibb/eon/blob/main/lib/cap/schema.capnp">programmable
interface</a> to the nameserver with <a href="https://capnproto.org/">Cap’n Proto</a> <a href="https://en.wikipedia.org/wiki/Capability-based_security">capability</a>-<a href="http://www.erights.org/elib/capability/ode/index.html">based</a>
RPCs. This creates capabilities for dynamically updating a domain, or
receiving a zonefile and dynamic updates as a secondary nameserver.
Please feel free to try deploying it for your own domain, and get <a href="https://ryan.freumh.org/about.html">in touch</a> if you’d like to set up a reciprocal
secondarying relationship.</span></p>
<h2>Names Have Power</h2>
<p><span>Having a programmable interface
into the domain name system is powerful, because domain names are
powerful. Domain names are the root of identity for the Internet
protocol suite. Federated communication networks derive user’s identify
from domain names including <a href="https://matrix.org/">Matrix</a>, <a href="https://joinmastodon.org/">Mastodon</a>, Bluesky’s AT Protocol
<span class="citation" data-cites="kleppmannBlueskyProtocolUsable2024"><a href="https://ryan.freumh.org/atom.xml#ref-kleppmannBlueskyProtocolUsable2024" role="doc-biblioref">[5]</a></span>, and good old <a href="https://www.rfc-editor.org/rfc/rfc822">E-Mail</a>.</span></p>
<p><span>The DNS is also used to prove
owership of domains. The security of the modern internet is built on the
Transport Layer Security (TLS) protocol <span class="citation" data-cites="allenTLSProtocolVersion1999"><a href="https://ryan.freumh.org/atom.xml#ref-allenTLSProtocolVersion1999" role="doc-biblioref">[6]</a></span>, which uses X509 certificates signed
by certificate authorities. The Internet Security Research Group
(ISRG)’s Let’s Encrypt certificate authority (CA) provides the <a href="https://w3techs.com/technologies/overview/ssl_certificate">majority</a>
of the Internet’s certificates, over 500 million <a href="https://letsencrypt.org/stats/">in 2025</a>. Traditionally
provisioning a certificate was costly and manual process, but the
Automatic Certificate Management Environment (ACME) protocol <span class="citation" data-cites="barnesAutomaticCertificateManagement2019"><a href="https://ryan.freumh.org/atom.xml#ref-barnesAutomaticCertificateManagement2019" role="doc-biblioref">[7]</a></span> used by Let’s Encrypt allows for an
automated provisioning of certificates by proving ownership of a domain
by displaying a token with one of a number of challenges; HTTP,
TLS-ALPN, and DNS.</span></p>
<p><span>Only the DNS challenge is possible
if the address the domain name points to is not publicly accessible,
which is often the case for remote and resource constrained devices
behind NATs or firewalls. However, it requires a <a href="https://certbot-dns-rfc2136.readthedocs.io/en/stable/">complex
dance</a> of managing DNS UPDATE keys and specifying the subdomain and
zone which it can modify. With our <a href="https://ryan.freumh.org/atom.xml#capability-interface">capability interface</a> to the nameserver
we can expose fine-grained access control to provision a certificate for
a subdomain.</span></p>
<h2>Wake-on-DNS</h2>
<p><span>Motivated by a desire to curb the power
use of self-hosted services which are often idle for large periods of
time, such as <a href="https://ryan.freumh.org/nas.html">storage servers</a>, we implemented <a href="https://github.com/RyanGibb/eon/tree/main/bin/hibernia">hibernia</a>
nameserver than can wake a machine up on a name resolution with Eon and
a OCaml <a href="https://en.wikipedia.org/wiki/Wake-on-LAN">Wake-on-LAN</a> <a href="https://github.com/RyanGibb/ocaml-wake-on-lan">implementation</a>.
We published this idea as ‘<a href="https://ryan.freumh.org/papers.html#carbon-aware-name-resolution">Carbon-aware Name
Resolution</a>’ in <a href="https://sicsa.ac.uk/loco/loco2024/">LOCO2024</a>.</span></p>
<h2>What next?</h2>
<p><span>I’m looking at extending this interface
to support additional functionality for networked services such as
storage, identity, and more. <a href="https://ryan.freumh.org/eilean.html">Eilean</a> is an
attempt to parameterise a federated service deployment by a domain name
leveraging the NixOS deployment system to do so, but it lacks a runtime
component.</span></p>
<div class="references csl-bib-body" data-entry-spacing="0" role="list">
<div class="csl-entry" role="listitem">
<span><div class="csl-left-margin">[1] </div><div class="csl-right-inline">K. Sivaramakrishnan, S. Dolan, L. White, T.
Kelly, S. Jaffer, and A. Madhavapeddy, <span>“Retrofitting effect
handlers onto <span>OCaml</span>,”</span> in <em>Proceedings of the 42nd
<span>ACM SIGPLAN International Conference</span> on <span>Programming
Language Design</span> and <span>Implementation</span></em>, Jun. 2021,
pp. 206–221, doi: <a href="https://doi.org/10.1145/3453483.3454039">10.1145/3453483.3454039</a>
[Online]. Available: <a href="https://dl.acm.org/doi/10.1145/3453483.3454039">https://dl.acm.org/doi/10.1145/3453483.3454039</a>.
[Accessed: Mar. 04, 2022]</div></span>
</div>
<div class="csl-entry" role="listitem">
<span><div class="csl-left-margin">[2] </div><div class="csl-right-inline"><span>“Domain names - implementation and
specification,”</span> Internet Engineering Task Force, Request for
Comments RFC 1035, Nov. 1987 [Online]. Available: <a href="https://datatracker.ietf.org/doc/rfc1035">https://datatracker.ietf.org/doc/rfc1035</a>.
[Accessed: May 15, 2022]</div></span>
</div>
<div class="csl-entry" role="listitem">
<span><div class="csl-left-margin">[3] </div><div class="csl-right-inline">P. A. Vixie, S. Thomson, Y. Rekhter, and J.
Bound, <span>“Dynamic <span>Updates</span> in the <span>Domain Name
System</span> (<span>DNS UPDATE</span>),”</span> Internet Engineering
Task Force, Request for Comments RFC 2136, Apr. 1997 [Online].
Available: <a href="https://datatracker.ietf.org/doc/rfc2136">https://datatracker.ietf.org/doc/rfc2136</a>.
[Accessed: Jun. 30, 2023]</div></span>
</div>
<div class="csl-entry" role="listitem">
<span><div class="csl-left-margin">[4] </div><div class="csl-right-inline">D. E. Eastlake 3rd, Ó. Guðmundsson, P. A.
Vixie, and B. Wellington, <span>“Secret <span>Key Transaction
Authentication</span> for <span>DNS</span> (<span>TSIG</span>),”</span>
Internet Engineering Task Force, Request for Comments RFC 2845, May 2000
[Online]. Available: <a href="https://datatracker.ietf.org/doc/rfc2845">https://datatracker.ietf.org/doc/rfc2845</a>.
[Accessed: Oct. 22, 2023]</div></span>
</div>
<div class="csl-entry" role="listitem">
<span><div class="csl-left-margin">[5] </div><div class="csl-right-inline">M. Kleppmann <em>et al.</em>, <span>“Bluesky
and the <span>AT Protocol</span>: <span>Usable Decentralized Social
Media</span>,”</span> in <em>Proceedings of the <span>ACM Conext-2024
Workshop</span> on the <span>Decentralization</span> of the
<span>Internet</span></em>, Dec. 2024, pp. 1–7, doi: <a href="https://doi.org/10.1145/3694809.3700740">10.1145/3694809.3700740</a>
[Online]. Available: <a href="http://arxiv.org/abs/2402.03239">http://arxiv.org/abs/2402.03239</a>.
[Accessed: Mar. 25, 2025]</div></span>
</div>
<div class="csl-entry" role="listitem">
<span><div class="csl-left-margin">[6] </div><div class="csl-right-inline">C. Allen and T. Dierks, <span>“The <span>TLS
Protocol Version</span> 1.0,”</span> Internet Engineering Task Force,
Request for Comments RFC 2246, Jan. 1999 [Online]. Available: <a href="https://datatracker.ietf.org/doc/rfc2246">https://datatracker.ietf.org/doc/rfc2246</a>.
[Accessed: Mar. 25, 2025]</div></span>
</div>
<div class="csl-entry" role="listitem">
<span><div class="csl-left-margin">[7] </div><div class="csl-right-inline">R. Barnes, J. Hoffman-Andrews, D. McCarney, and
J. Kasten, <span>“Automatic <span>Certificate Management
Environment</span> (<span>ACME</span>),”</span> Internet Engineering
Task Force, Request for Comments RFC 8555, Mar. 2019 [Online].
Available: <a href="https://datatracker.ietf.org/doc/rfc8555">https://datatracker.ietf.org/doc/rfc8555</a>.
[Accessed: Jun. 26, 2023]</div></span>
</div>
</div>
<section class="footnotes footnotes-end-of-document" role="doc-endnotes">
<hr>
<ol>
<li><p><span>Note that prior
to TSIG introduced with DNSSEC, DNS UPDATEs and zone transfers were
typically enforced with IP-based access control.</span><a href="https://ryan.freumh.org/atom.xml#fnref1" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
</ol>
</section>
    </section>
</article>


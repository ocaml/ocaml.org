---
title: The road ahead for MirageOS in 2021
description:
url: https://hannes.robur.coop/Posts/NGI
date: 2021-01-25T12:45:54-00:00
preview_image:
featured:
---

<h2>Introduction</h2>
<p>2020 was an intense year. I hope you're healthy and keep being healthy. I am privileged (as lots of software engineers and academics are) to be able to work from home during the pandemic. Let's not forget people in less privileged situations,  and let&rsquo;s try to give them as much practical, psychological and financial support as we can these days. And as much joy as possible to everyone around :)</p>
<p>I cancelled the autumn MirageOS retreat due to the pandemic. Instead I collected donations for our hosts in Marrakech - they were very happy to receive our financial support, since they had a difficult year, since their income is based on tourism. I hope that in autumn 2021 we'll have an on-site retreat again.</p>
<p>For 2021, we (at <a href="https://robur.coop">robur</a>) got a grant from the EU (via <a href="https://pointer.ngi.eu">NGI pointer</a>) for &quot;Deploying MirageOS&quot; (more details below), and another grant from <a href="https://ocaml-sf.org">OCaml software foundation</a> for securing the opam supply chain (using <a href="https://github.com/hannesm/conex">conex</a>). Some long-awaited releases for MirageOS libraries, namely a <a href="https://discuss.ocaml.org/t/ann-first-release-of-awa-ssh">ssh implementation</a> and a rewrite of our <a href="https://discuss.ocaml.org/t/ann-release-of-ocaml-git-v3-0-duff-encore-decompress-etc/">git implementation</a> have already been published.</p>
<p>With my MirageOS view, 2020 was a pretty successful year, where we managed to add more features, fixed lots of bugs, and paved the road ahead. I want to thank <a href="https://ocamllabs.io/">OCamlLabs</a> for funding work on MirageOS maintenance.</p>
<h2>Recap 2020</h2>
<p>Here is a very subjective random collection of accomplishments in 2020, where I was involved with some degree.</p>
<h3>NetHSM</h3>
<p><a href="https://www.nitrokey.com/products/nethsm">NetHSM</a> is a hardware security module in software. It is a product that uses MirageOS for security, and is based on the <a href="https://muen.sk">muen</a> separation kernel. We at <a href="https://robur.coop">robur</a> were heavily involved in this product. It already has been security audited by an external team. You can pre-order it from Nitrokey.</p>
<h3>TLS 1.3</h3>
<p>Dating back to 2016, at the <a href="https://www.ndss-symposium.org/ndss2016/tron-workshop-programme/">TRON</a> (TLS 1.3 Ready or NOt), we developed a first draft of a 1.3 implementation of <a href="https://github.com/mirleft/ocaml-tls">OCaml-TLS</a>. Finally in May 2020 we got our act together, including ECC (ECDH P256 from <a href="https://github.com/mit-plv/fiat-crypto/">fiat-crypto</a>, X25519 from <a href="https://project-everest.github.io/">hacl</a>) and testing with <a href="https://github.com/tlsfuzzer/tlsfuzzer">tlsfuzzer</a>, and release tls 0.12.0 with TLS 1.3 support. Later we added <a href="https://github.com/mirleft/ocaml-tls/pull/414">ECC ciphersuites to TLS version 1.2</a>, implemented <a href="https://github.com/mirleft/ocaml-tls/pull/414">ChaCha20/Poly1305</a>, and fixed an <a href="https://github.com/mirleft/ocaml-tls/pull/424">interoperability issue with Go's implementation</a>.</p>
<p><a href="https://github.com/mirage/mirage-crypto">Mirage-crypto</a> provides the underlying cryptographic primitives, initially released in March 2020 as a fork of <a href="https://github.com/mirleft/ocaml-nocrypto">nocrypto</a> -- huge thanks to <a href="https://github.com/pqwy">pqwy</a> for his great work. Mirage-crypto detects <a href="https://github.com/mirage/mirage-crypto/pull/53">CPU features at runtime</a> (thanks to <a href="https://github.com/Julow">Julow</a>) (<a href="https://github.com/mirage/mirage-crypto/pull/96">bugfix for bswap</a>), using constant time modular exponentation (powm_sec) and hardens against Lenstra's CRT attack, supports <a href="https://github.com/mirage/mirage-crypto/pull/39">compilation on Windows</a> (thanks to <a href="https://github.com/avsm">avsm</a>), <a href="https://github.com/mirage/mirage-crypto/pull/90">async entropy harvesting</a> (thanks to <a href="https://github.com/seliopou">seliopou</a>), <a href="https://github.com/mirage/mirage-crypto/pull/65">32 bit support</a>, <a href="https://github.com/mirage/mirage-crypto/pull/72">chacha20/poly1305</a> (thanks to <a href="https://github.com/abeaumont">abeaumont</a>), <a href="https://github.com/mirage/mirage-crypto/pull/84">cross-compilation</a> (thanks to <a href="https://github.com/EduardoRFS">EduardoRFS</a>) and <a href="https://github.com/mirage/mirage-crypto/pull/78">various</a> <a href="https://github.com/mirage/mirage-crypto/pull/81">bug</a> <a href="https://github.com/mirage/mirage-crypto/pull/83">fixes</a>, even <a href="https://github.com/mirage/mirage-crypto/pull/95">memory leak</a> (thanks to <a href="https://github.com/talex5">talex5</a> for reporting several of these issues), and <a href="https://github.com/mirage/mirage-crypto/pull/99">RSA</a> <a href="https://github.com/mirage/mirage-crypto/pull/100">interoperability</a> (thanks to <a href="https://github.com/psafont">psafont</a> for investigation and <a href="https://github.com/mattjbray">mattjbray</a> for reporting). This library feels very mature now - being used by multiple stakeholders, and lots of issues have been fixed in 2020.</p>
<h3>Qubes Firewall</h3>
<p>The <a href="https://github.com/mirage/qubes-mirage-firewall/">MirageOS based Qubes firewall</a> is the most widely used MirageOS unikernel. And it got major updates: in May <a href="https://github.com/linse">Steffi</a> <a href="https://groups.google.com/g/qubes-users/c/Xzplmkjwa5Y">announced</a> her and <a href="https://github.com/yomimono">Mindy's</a> work on improving it for Qubes 4.0 - including <a href="https://www.qubes-os.org/doc/vm-interface/#firewall-rules-in-4x">dynamic firewall rules via QubesDB</a>. Thanks to <a href="https://prototypefund.de/project/portable-firewall-fuer-qubesos/">prototypefund</a> for sponsoring.</p>
<p>In October 2020, we released <a href="https://mirage.io/blog/announcing-mirage-39-release">Mirage 3.9</a> with PVH virtualization mode (thanks to <a href="https://github.com/mato">mato</a>). There's still a <a href="https://github.com/mirage/qubes-mirage-firewall/issues/120">memory leak</a> to be investigated and fixed.</p>
<h3>IPv6</h3>
<p>In December, with <a href="https://mirage.io/blog/announcing-mirage-310-release">Mirage 3.10</a> we got the IPv6 code up and running. Now MirageOS unikernels have a dual stack available, besides IPv4-only and IPv6-only network stacks. Thanks to <a href="https://github.com/nojb">nojb</a> for the initial code and <a href="https://github.com/MagnusS">MagnusS</a>.</p>
<p>Turns out this blog, but also robur services, are now available via IPv6 :)</p>
<h3>Albatross</h3>
<p>Also in December, I pushed an initial release of <a href="https://github.com/roburio/albatross">albatross</a>, a unikernel orchestration system with remote access. <em>Deploy your unikernel via a TLS handshake -- the unikernel image is embedded in the TLS client certificates.</em></p>
<p>Thanks to <a href="https://github.com/reynir">reynir</a> for statistics support on Linux and improvements of the systemd service scripts. Also thanks to <a href="https://github.com/cfcs">cfcs</a> for the initial Linux port.</p>
<h3>CA certs</h3>
<p>For several years I postponed the problem of how to actually use the operating system trust anchors for OCaml-TLS connections. Thanks to <a href="https://github.com/emillon">emillon</a> for initial code, there are now <a href="https://github.com/mirage/ca-certs">ca-certs</a> and <a href="https://github.com/mirage/ca-certs-nss">ca-certs-nss</a> opam packages (see <a href="https://discuss.ocaml.org/t/ann-ca-certs-and-ca-certs-nss">release announcement</a>) which fills this gap.</p>
<h2>Unikernels</h2>
<p>I developed several useful unikernels in 2020, and also pushed <a href="https://mirage.io/wiki/gallery">a unikernel gallery</a> to the Mirage website:</p>
<h3>Traceroute in MirageOS</h3>
<p>I already wrote about <a href="https://hannes.robur.coop/Posts/Traceroute">traceroute</a> which traces the routing to a given remote host.</p>
<h3>Unipi - static website hosting</h3>
<p><a href="https://github.com/roburio/unipi">Unipi</a> is a static site webserver which retrieves the content from a remote git repository. Let's encrypt certificate provisioning and dynamic updates via a webhook to be executed for every push.</p>
<h4>TLSTunnel - TLS demultiplexing</h4>
<p>The physical machine this blog and other robur infrastructure runs on has been relocated from Sweden to Germany mid-December. Thanks to UPS! Fewer IPv4 addresses are available in the new data center, which motivated me to develop <a href="https://github.com/roburio/tlstunnel">tlstunnel</a>.</p>
<p>The new behaviour is as follows (see the <code>monitoring</code> branch):</p>
<ul>
<li>listener on TCP port 80 which replies with a permanent redirect to <code>https</code>
</li>
<li>listener on TCP port 443 which forwards to a backend host if the requested server name is configured
</li>
<li>its configuration is stored on a block device, and can be dynamically changed (with a custom protocol authenticated with a HMAC)
</li>
<li>it is setup to hold a wildcard TLS certificate and in DNS a wildcard entry is pointing to it
</li>
<li>setting up a new service is very straightforward: only the new name needs to be registered with tlstunnel together with the TCP backend, and everything will just work
</li>
</ul>
<h2>2021</h2>
<p>The year started with a release of <a href="https://discuss.ocaml.org/t/ann-first-release-of-awa-ssh">awa</a>, a SSH implementation in OCaml (thanks to <a href="https://github.com/haesbaert">haesbaert</a> for initial code). This was followed by a <a href="https://discuss.ocaml.org/t/ann-release-of-ocaml-git-v3-0-duff-encore-decompress-etc/">git 3.0 release</a> (thanks to <a href="https://github.com/dinosaure">dinosaure</a>).</p>
<h3>Deploying MirageOS - NGI Pointer</h3>
<p>For 2021 we at robur received funding from the EU (via <a href="https://pointer.ngi.eu/">NGI pointer</a>) for &quot;Deploying MirageOS&quot;, which boils down into three parts:</p>
<ul>
<li>reproducible binary releases of MirageOS unikernels,
</li>
<li>monitoring (and other devops features: profiling) and integration into existing infrastructure,
</li>
<li>and further documentation and advertisement.
</li>
</ul>
<p>Of course this will all be available open source. Please get in touch via eMail (team aT robur dot coop) if you're eager to integrate MirageOS unikernels into your infrastructure.</p>
<p>We discovered at an initial meeting with an infrastructure provider that a DNS resolver is of interest - even more now that dnsmasq suffered from <a href="https://www.jsof-tech.com/wp-content/uploads/2021/01/DNSpooq_Technical-Whitepaper.pdf">dnspooq</a>. We are already working on an <a href="https://github.com/mirage/ocaml-dns/pull/251">implementation of DNSSec</a>.</p>
<p>MirageOS unikernels are binary reproducible, and <a href="https://github.com/rjbou/orb/pull/1">infrastructure tools are available</a>. We are working hard on a web interface (and REST API - think of it as &quot;Docker Hub for MirageOS unikernels&quot;), and more tooling to verify reproducibility.</p>
<h3>Conex - securing the supply chain</h3>
<p>Another funding from the <a href="http://ocaml-sf.org/">OCSF</a> is to continue development and deploy <a href="https://github.com/hannesm/conex">conex</a> - to bring trust into opam-repository. This is a great combination with the reproducible build efforts, and will bring much more trust into retrieving OCaml packages and using MirageOS unikernels.</p>
<h3>MirageOS 4.0</h3>
<p>Mirage so far still uses ocamlbuild and ocamlfind for compiling the virtual machine binary. But the switch to dune is <a href="https://github.com/mirage/mirage/issues/1195">close</a>, a lot of effort has been done. This will make the developer experience of MirageOS much more smooth, with a per-unikernel monorepo workflow where you can push your changes to the individual libraries.</p>
<h2>Footer</h2>
<p>If you want to support our work on MirageOS unikernels, please <a href="https://robur.coop/Donate">donate to robur</a>. I'm interested in feedback, either via <a href="https://twitter.com/h4nnes">twitter</a>, <a href="https://mastodon.social/@hannesm">hannesm@mastodon.social</a> or via eMail.</p>


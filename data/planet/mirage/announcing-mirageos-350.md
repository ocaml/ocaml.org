---
title: Announcing MirageOS 3.5.0
description:
url: https://mirage.io/blog/announcing-mirage-35-release
date: 2019-03-05T00:00:00-00:00
preview_image:
featured:
authors:
- Hannes Mehnert
---


        <p>We are happy to announce our MirageOS 3.5.0 release. We didn't announce post 3.0.0 releases too well -- that's why this post tries to summarize the changes in the MirageOS ecosystem over the past two years. MirageOS consists of over 100 opam packages, lots of which are reused in other OCaml projects and deployments without MirageOS. These opam packages are maintained and developed further by lots of developers.</p>
<p>On the OCaml tooling side, since MirageOS 3.0.0 we did several major changes:</p>
<ul>
<li>moved most packages to <a href="https://dune.build/">dune</a> (formerly jbuilder) and began using <a href="https://github.com/samoht/dune-release">dune-release</a> for smooth developer experience and simple releases,
</li>
<li>require <a href="https://opam.ocaml.org">opam</a> to be version 2.0.2 or later, allowing <code>pin-depends</code> in <code>config.ml</code>. <code>pin-depends</code> allows you to depend on a development branch of any opam package for your unikernel,
</li>
<li>adjusted documentation to adhere to <a href="https://github.com/ocaml/odoc/">odoc</a> requirements,
</li>
<li>the <code>mirage</code> command-line utility now emits lower and upper bounds of opam packages, allowing uncompromising deprecation of packages,
</li>
<li>support for OCaml 4.06.0 (and above), where <code>safe-string</code> is enabled by default. Strings are immutable now!!,
</li>
<li>remove usage of <code>result</code> package, which has incorporated into <code>Pervasives</code> since OCaml 4.03.0.
</li>
</ul>
<p>The 3.5.0 release contains several API improvements of different MirageOS interfaces - if you're developing your own MirageOS unikernels, you may want to read this post to adjust to the new APIs.</p>
<h2>MirageOS interface API changes:</h2>
<ul>
<li><a href="https://github.com/mirage/mirage-clock">mirage-clock</a> has the <code>type t</code> constrained to <code>unit</code> as of 2.0.0;
</li>
<li><a href="https://github.com/mirage/mirage-protocols">mirage-protocols</a> renames the <code>ETHIF</code> module type to the clearer <code>ETHERNET</code>. As of 2.0.0 it also contains keep-alive support, complies with recent TCP/IP layering rework (see below), and IPv4 now supports reassembly and fragmentation;
</li>
<li><a href="https://github.com/mirage/mirage-net">mirage-net</a> reflects revised layering API as of 2.0.0 (see below);
</li>
<li><a href="https://github.com/mirage/mirage-kv">mirage-kv</a> has a revised API and introduction of a read-write key-value store (see below).
</li>
</ul>
<h2>Major changes</h2>
<h3><a href="https://github.com/mirage/mirage-kv">Key-value store</a></h3>
<p>We improved the key-value store API, and added a read-write store. There is also <a href="https://github.com/mirage/irmin/pull/559">ongoing work</a> which implements the read-write interface using irmin, a branchable persistent storage that can communicate via the git protocol. Motivations for these changes were the development of <a href="https://github.com/roburio/caldav">CalDAV</a>, but also the development of <a href="https://github.com/mirage/wodan">wodan</a>, a flash-friendly, safe and flexible filesystem. The goal is to EOL the <a href="https://github.com/mirage/mirage-fs">mirage-fs</a> interface in favour of the key-value store.</p>
<p>Major API improvements (in <a href="https://github.com/mirage/mirage-kv/pull/14">this PR</a>, since 2.0.0):</p>
<ul>
<li>The <code>key</code> is now a path (list of segments) instead of a <code>string</code>
</li>
<li>The <code>value</code> type is now a <code>string</code>
</li>
<li>The new function <code>list : t -&gt; key -&gt; (string * [</code>Value|<code>Dictionary], error) result io</code> was added
</li>
<li>The function <code>get : t -&gt; key -&gt; (value, error) result io</code> is now provided (used to be named <code>read</code> and requiring an <code>offset</code> and <code>length</code> parameter)
</li>
<li>The functions <code>last_modified : t -&gt; key -&gt; (int * int64, error) result io</code> and <code>digest : t -&gt; key -&gt; (string, error) result io</code> have been introduced
</li>
<li>The function <code>size</code> was removed.
</li>
<li>The signature <code>RW</code> for read-write key-value stores extends <code>RO</code> with three functions <code>set</code>, <code>remove</code>, and <code>batch</code>
</li>
</ul>
<p>There is now a <a href="https://github.com/mirage/mirage-kv-mem">non-persistent in-memory implementation</a> of a read-write key-value store available. Other implementations (such as <a href="https://github.com/mirage/ocaml-crunch">crunch</a>, <a href="https://github.com/mirage/mirage-kv-unix">mirage-kv-unix</a>, <a href="https://github.com/mirage/mirage-fs">mirage-fs</a>, <a href="https://github.com/mirage/ocaml-tar">tar</a> have been adapted, as well as clients of mirage-kv (dns, cohttp, tls)).</p>
<h3><a href="https://github.com/mirage/mirage-tcpip">TCP/IP</a></h3>
<p>The IPv4 implementation now has support for <a href="https://github.com/mirage/mirage-tcpip/pull/375">fragment reassembly</a>. Each incoming IPv4 fragment is checked for the &quot;more fragments&quot; and &quot;offset&quot; fields. If these are non-zero, the fragment is processed by the <a href="https://mirage.github.io/mirage-tcpip/tcpip/Fragments/index.html">fragment cache</a>, which uses a <a href="https://github.com/pqwy/lru">least recently used</a> data structure of maximum size 256kB content shared by all incoming fragments. If there is any overlap in fragments, the entire packet is dropped (<a href="https://eprint.iacr.org/2015/1020.pdf">avoiding security issues</a>). Fragments may arrive out of order. The code is <a href="https://github.com/mirage/mirage-tcpip/blob/v3.7.1/test/test_ipv4.ml#L49-L203">heavily unit-tested</a>. Each IPv4 packet may at most be in 16 fragments (to minimise CPU DoS with lots of small fragments), the timeout between the first and last fragment is 10 seconds.</p>
<p>The layering and allocation discipline has been revised. <a href="https://github.com/mirage/ethernet"><code>ethernet</code></a> (now encapsulating and decapsulating Ethernet) and <a href="https://github.com/mirage/arp"><code>arp</code></a> (the address resolution protocol) are separate opam packages, and no longer part of <code>tcpip</code>.</p>
<p>At the lowest layer, <a href="https://github.com/mirage/mirage-net">mirage-net</a> is the network device. This interface is implemented by our different backends (<a href="https://github.com/mirage/mirage-net-xen">xen</a>, <a href="https://github.com/mirage/mirage-net-solo5">solo5</a>, <a href="https://github.com/mirage/mirage-net-unix">unix</a>, <a href="https://github.com/mirage/mirage-net-macosx">macos</a>, and <a href="https://github.com/mirage/mirage-vnetif">vnetif</a>). Some backends require buffers to be page-aligned when they are passed to the host system. This was previously not really ensured: while the abstract type <code>page_aligned_buffer</code> was required, <code>write</code> (and <code>writev</code>) took the abstract <code>buffer</code> type (always constrained to <code>Cstruct.t</code> by mirage-net-lwt). The <code>mtu</code> (maximum transmission unit) used to be an optional <code>connect</code> argument to the Ethernet layer, but now it is a function which needs to be provided by mirage-net.</p>
<p>The <code>Mirage_net.write</code> function now has a signature that is explicit about ownership and lifetime: <code>val write : t -&gt; size:int -&gt; (buffer -&gt; int) -&gt; (unit, error) result io</code>.
It requires a requested <code>size</code> argument to be passed, and a fill function which is called with an allocated buffer, that satisfies the backend demands. The <code>fill</code> function is supposed to write to the buffer, and return the length of the frame to be send out. It can neither error (who should handle such an error anyways?), nor is it in the IO monad. The <code>fill</code> function should not save any references to the buffer, since this is the network device's memory, and may be reused. The <code>writev</code> function has been removed.</p>
<p>The <a href="https://github.com/mirage/mirage-protocols">Ethernet layer</a> does encapsulation and decapsulation now. Its <code>write</code> function has the following signature:
<code>val write: t -&gt; ?src:macaddr -&gt; macaddr -&gt; Ethernet.proto -&gt; ?size:int -&gt; (buffer -&gt; int) -&gt; (unit, error) result io</code>.
It fills in the Ethernet header with the given source address (defaults to the device's own MAC address) and destination address, and Ethernet protocol. The <code>size</code> argument is optional, and defaults to the MTU. The <code>buffer</code> that is passed to the <code>fill</code> function is usable from offset 0 on. The Ethernet header is not visible at higher layers.</p>
<p>The IP layer also embeds a revised <code>write</code> signature:
<code>val write: t -&gt; ?fragment:bool -&gt; ?ttl:int -&gt; ?src:ipaddr -&gt; ipaddr -&gt; Ip.proto -&gt; ?size:int -&gt; (buffer -&gt; int) -&gt; buffer list -&gt; (unit, error) result io</code>.
This is similar to the Ethernet signature - it writes the IPv4 header and sends a packet. It also supports fragmentation (including setting the do-not-fragment bit for path MTU discovery) -- whenever the payload is too big for a single frame, it is sent as multiple fragmented IPv4 packets. Additionally, setting the time-to-live is now supported, meaning we now can implement traceroute!
The API used to include two functions, <code>allocate_frame</code> and <code>write</code>, where only buffers allocated by the former should be used in the latter. This has been combined into a single function that takes a fill function and a list of payloads. This change is for maximum flexibility: a higher layer can either construct its header and payload, and pass it to <code>write</code> as payload argument (the <code>buffer list</code>), which is then copied into the buffer(s) allocated by the network device, or the upper layer can provide the callback <code>fill</code> function to assemble its data into the buffer allocated by the network device, to avoid copying. Of course, both can be used - the outgoing packet contains the IPv4 header, and possibly the buffer until the offset returned by <code>fill</code>, and afterwards the payload.</p>
<p>The TCP implementation has <a href="https://github.com/mirage/mirage-tcpip/pull/338">preliminary keepalive support</a>.</p>
<h3><a href="https://github.com/solo5/solo5">Solo5</a></h3>
<ul>
<li>MirageOS 3.0.0 used the 0.2.0 release of solo5
</li>
<li>The <code>ukvm</code> target was renamed to <code>hvt</code>, where <code>solo5-hvt</code> is the monitoring process
</li>
<li>Support for <a href="http://bhyve.org/">FreeBSD bhyve</a> and <a href="https://man.openbsd.org/vmm.4">OpenBSD VMM</a> hypervisor (within the hvt target)
</li>
<li>Support for ARM64 and KVM
</li>
<li>New target <a href="https://muen.sk">muen.sk</a>, a separation kernel developed in SPARK/Ada
</li>
<li>New target <a href="https://genode.org">GenodeOS</a>, an operating system framework using a microkernel
</li>
<li>Debugger support: attach gdb in the host system for improved debugging experience
</li>
<li>Core dump support
</li>
<li>Drop privileges on OpenBSD and FreeBSD
</li>
<li>Block device write fixes (in <a href="https://github.com/mirage/mirage-block-solo5">mirage-block-solo5</a>)
</li>
</ul>
<h3><a href="https://github.com/mirage/mirage-random">random</a></h3>
<p>The <a href="https://github.com/mirage/mirage-random-stdlib">default random device</a> from the OCaml standard library is now properly seeded using <a href="https://github.com/mirage/mirage-entropy">mirage-entropy</a>. In the future, we plan to make the <a href="https://github.com/mirleft/ocaml-nocrypto">fortuna RNG</a> the default random number generator.</p>
<h3>Argument passing to unikernels</h3>
<p>The semantics of arguments passed to a MirageOS unikernel used to vary between different backends, now they're the same everywhere: all arguments are concatenated using the whitespace character as separator, and split on the whitespace character again by <a href="https://github.com/mirage/parse-argv">parse-argv</a>. To pass a whitespace character in an argument, the whitespace now needs to be escaped: <code>--hello=foo\\ bar</code>.</p>
<h3>Noteworthy package updates</h3>
<ul>
<li><a href="https://github.com/mirage/ocaml-cstruct">cstruct 3.6.0</a> API changes and repackaging, see <a href="https://discuss.ocaml.org/t/ann-cstruct-3-0-0-with-packaging-changes">this announcement</a> and <a href="https://discuss.ocaml.org/t/psa-cstruct-3-4-0-removes-old-ocamlfind-subpackage-aliases">this announcement</a>
</li>
<li><a href="https://github.com/mirage/ocaml-ipaddr">ipaddr 3.0.0</a> major API changes, the s-expression serialisation is a separate subpackage, macaddr is now a standalone opam package
</li>
<li><a href="https://github.com/mirage/base64">base64 3.0.0</a> performance and API changes, see <a href="https://discuss.ocaml.org/t/ann-major-release-of-base64-article">this announcement</a>
</li>
<li><a href="https://github.com/mirage/ocaml-git">git 2.0.0</a>, read <a href="https://discuss.ocaml.org/t/ann-ocaml-git-2-0">this announcement</a>, as well as <a href="https://discuss.ocaml.org/t/ocaml-git-git-design-and-implementation">its design and implementation</a>
</li>
<li><a href="https://github.com/mirage/io-page">io-page 2.0.0</a>, see <a href="https://discuss.ocaml.org/t/ann-io-page-2-0-0-with-packaging-changes">this announcement</a>
</li>
<li><a href="https://github.com/mirage/ocaml-cohttp">cohttp 2.0.0</a>, see <a href="https://discuss.ocaml.org/t/ann-major-releases-of-cohttp-conduit-dns-tcpip">this announcement</a>
</li>
<li><a href="https://github.com/mirage/ocaml-dns">dns 1.0.0</a>, see <a href="https://discuss.ocaml.org/t/ann-major-releases-of-cohttp-conduit-dns-tcpip">this announcement</a>
</li>
<li><a href="https://github.com/mirage/ocaml-conduit">conduit 1.0.0</a>, see <a href="https://discuss.ocaml.org/t/ann-major-releases-of-cohttp-conduit-dns-tcpip">this announcement</a>
</li>
</ul>
<h2>More features and bugfixes</h2>
<ul>
<li>More HTTP server choices are supported via a new <a href="https://github.com/mirage/mirage/pull/955">httpaf device</a> that permits the <a href="https://github.com/inhabitedtype/httpaf">high performance httpaf</a> stack to run as a unikernel now.
</li>
<li><a href="https://github.com/mirage/mirage/pull/903">libvirt.xml is generated for virtio target</a>
</li>
<li><a href="https://github.com/mirage/mirage/issues/861">Unix target now include -tags thread</a> (for mirage-framebuffer SDL support)
</li>
<li>Various modules (IPv6, DHCP) are explicit about their dependency to the random device
</li>
<li><a href="https://github.com/mirage/mirage/pull/807">QubesDB can be requested in config.ml when the target is Xen</a>
</li>
</ul>
<p>You may also want to read the <a href="https://discuss.ocaml.org/t/ann-mirage-3-2-0">MirageOS 3.2.0 announcement</a> and the <a href="https://discuss.ocaml.org/t/mirage-3-3-0-released">MirageOS 3.3.0 announcement</a>.</p>
<h2>Next steps</h2>
<p>We are working on <a href="https://github.com/mirage/mirage/issues/969">further</a> <a href="https://github.com/mirage/functoria/pull/167">changes</a> which revise the <code>mirage</code> internal build system to <a href="https://dune.build">dune</a>. At the moment it uses <code>ocamlbuild</code>, <code>ocamlfind</code>, <code>pkg-config</code>, and <code>make</code>. The goal of this change is to make MirageOS more developer-friendly. On the horizon we have MirageOS unikernel monorepos, incremental builds, pain-free cross-compilation, documentation generation, ...</p>
<p>Several other MirageOS ecosystem improvements are on the schedule for 2019, including an <a href="https://zshipko.github.io/irmin-tutorial/">irmin 2.0 release</a>, a <a href="https://github.com/Solo5/solo5/pull/310">seccomp target for Solo5</a>, and <a href="https://github.com/Solo5/solo5/issues/326">easier deployment and multiple interface in Solo5</a>.</p>

      

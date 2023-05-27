---
title: Introducing transport layer security (TLS) in pure OCaml
description:
url: https://mirage.io/blog/introducing-ocaml-tls
date: 2014-07-08T00:00:00-00:00
preview_image:
featured:
authors:
- Hannes Mehnert
---


        <p>We announce a <strong>beta</strong> release of <code>ocaml-tls</code>, a clean-slate implementation of
<a href="https://en.wikipedia.org/wiki/Transport_Layer_Security">Transport Layer Security</a> (TLS) in
OCaml.</p>
<h3>What is TLS?</h3>
<p>Transport Layer Security (TLS) is probably the most widely deployed
security protocol on the Internet. It provides communication privacy
to prevent eavesdropping, tampering, and message forgery. Furthermore,
it optionally provides authentication of the involved endpoints. TLS
is commonly deployed for securing web services (<a href="http://tools.ietf.org/html/rfc2818">HTTPS</a>), emails,
virtual private networks, and wireless networks.</p>
<p>TLS uses asymmetric cryptography to exchange a symmetric key, and
optionally authenticate (using X.509) either or both endpoints. It
provides algorithmic agility, which means that the key exchange
method, symmetric encryption algorithm, and hash algorithm are
negotiated.</p>
<h3>TLS in OCaml</h3>
<p>Our implementation <a href="https://github.com/mirleft/ocaml-tls">ocaml-tls</a> is already able to interoperate with
existing TLS implementations, and supports several important TLS extensions
such as server name indication (<a href="https://tools.ietf.org/html/rfc4366">RFC4366</a>, enabling virtual hosting)
and secure renegotiation (<a href="https://tools.ietf.org/html/rfc5746">RFC5746</a>).</p>
<p>Our [demonstration server][^7] runs <code>ocaml-tls</code> and renders exchanged
TLS messages in nearly real time by receiving a trace of the TLS
session setup. If you encounter any problems, please give us [feedback][^14].</p>
<p><code>ocaml-tls</code> and all dependent libraries are available via [OPAM][^18] (<code>opam install tls</code>). The <a href="https://github.com/mirleft/ocaml-tls">source is available</a>
under a BSD license. We are primarily working towards completeness of
protocol features, such as client authentication, session resumption, elliptic curve and GCM
cipher suites, and have not yet optimised for performance.</p>
<p><code>ocaml-tls</code> depends on the following independent libraries: [ocaml-nocrypto][^6] implements the
cryptographic primitives, [ocaml-asn1-combinators][^5] provides ASN.1 parsers/unparsers, and
[ocaml-x509][^8] implements the X509 grammar and certificate validation (<a href="https://tools.ietf.org/html/rfc5280">RFC5280</a>). <a href="https://github.com/mirleft/ocaml-tls">ocaml-tls</a> implements TLS (1.0, 1.1 and 1.2; <a href="https://tools.ietf.org/html/rfc2246">RFC2246</a>,
<a href="https://tools.ietf.org/html/rfc4346">RFC4346</a>, <a href="https://tools.ietf.org/html/rfc5246">RFC5246</a>).</p>
<p>We invite the community to audit and run our code, and we are particularly interested in discussion of our APIs.
Please use the [mirage-devel mailing list][^9] for discussions.</p>
<p><strong>Please be aware that this release is a <em>beta</em> and is missing external code audits.
It is not yet intended for use in any security critical applications.</strong></p>
<p>In our [issue tracker][^14] we transparently document known attacks against TLS and our mitigations
([checked][^4] and [unchecked][^11]).
We have not yet implemented mitigations against either the
[Lucky13][^12] timing attack or traffic analysis (e.g. [length-hiding padding][^13]).</p>
<h3>Trusted code base</h3>
<p>Designed to run on Mirage, the trusted code base of <code>ocaml-tls</code> is small. It includes the libraries already mentioned,
<a href="https://github.com/mirleft/ocaml-tls"><code>ocaml-tls</code></a>, [<code>ocaml-asn-combinators</code>][^5], [<code>ocaml-x509</code>][^8],
and [<code>ocaml-nocrypto</code>][^6] (which uses C implementations of block
ciphers and hash algorithms). For arbitrary precision integers needed in
asymmetric cryptography, we rely on [<code>zarith</code>][^15], which wraps
[<code>libgmp</code>][^16]. As underlying byte array structure we use
[<code>cstruct</code>][^17] (which uses OCaml <code>Bigarray</code> as storage).</p>
<p>We should also mention the OCaml runtime, the OCaml compiler, the
operating system on which the source is compiled and the binary is executed, as
well as the underlying hardware. Two effectful frontends for
the pure TLS core are implemented, dealing
with side-effects such as reading and writing from the network: <a href="http://ocsigen.org/lwt/api/Lwt_unix">Lwt_unix</a> and
Mirage, so applications can run directly as a Xen unikernel.</p>
<h3>Why a new TLS implementation?</h3>
<p><strong>Update:</strong>
Thanks to <a href="http://frama-c.com/">Frama-C</a> guys for <a href="https://twitter.com/spun_off/status/486535304426188800">pointing</a> <a href="https://twitter.com/spun_off/status/486536572792090626">out</a>
that <a href="https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2014-1266">CVE-2014-1266</a> and <a href="https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2014-0224">CVE-2014-0224</a> are <em>not</em> memory safety issues, but
logic errors. This article previously stated otherwise.</p>
<p>There are only a few TLS implementations publicly available and most
programming languages bind to OpenSSL, an open source implementation written
in C. There are valid reasons to interface with an existing TLS library,
rather than developing one from scratch, including protocol complexity and
compatibility with different TLS versions and implementations. But from our
perspective the disadvantage of most existing libraries is that they
are written in C, leading to:</p>
<ul>
<li>Memory safety issues, as recently observed by <a href="https://en.wikipedia.org/wiki/Heartbleed">Heartbleed</a> and GnuTLS
session identifier memory corruption (<a href="https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2014-3466">CVE-2014-3466</a>) bugs;
</li>
<li>Control flow complexity (Apple's goto fail, <a href="https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2014-1266">CVE-2014-1266</a>);
</li>
<li>And difficulty in encoding state machines (OpenSSL change cipher suite
attack, <a href="https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2014-0224">CVE-2014-0224</a>).
</li>
</ul>
<p>Our main reasons for <code>ocaml-tls</code> are that OCaml is a modern functional
language, which allows concise and declarative descriptions of the
complex protocol logic and provides type safety and memory safety to help
guard against programming errors. Its functional nature is extensively
employed in our code: the core of the protocol is written in purely
functional style, without any side effects.</p>
<p>Subsequent blog posts <a href="https://github.com/mirage/mirage/issues/257">over the coming
days</a> will examine in more detail
the design and implementation of the four libraries, as well as the security
trade-offs and some TLS attacks and our mitigations against them.  For now
though, we invite you to try out our <strong>[demonstration server][^7]</strong>
running our stack over HTTPS.  We're particularly interested in feedback on our <a href="https://github.com/mirleft/ocaml-tls">issue tracker</a> about
clients that fail to connect, and any queries from anyone reviewing the <a href="https://github.com/mirleft/">source code</a>
of the constituent libraries.</p>
<p>[^3]: http://www.openbsd.org/papers/bsdcan14-libressl/mgp00026.html)
[^4]: https://github.com/mirleft/ocaml-tls/issues?labels=security+concern&amp;page=1&amp;state=open
[^5]: https://github.com/mirleft/ocaml-asn1-combinators
[^6]: https://github.com/mirleft/ocaml-nocrypto
[^7]: https://tls.nqsb.io/
[^8]: https://github.com/mirleft/ocaml-x509
[^9]: http://lists.xenproject.org/archives/html/mirageos-devel/
[^10]: https://github.com/mirage/mirage-entropy
[^11]: https://github.com/mirleft/ocaml-tls/issues?labels=security+concern&amp;page=1&amp;state=closed
[^12]: http://www.isg.rhul.ac.uk/tls/Lucky13.html
[^13]: http://tools.ietf.org/html/draft-pironti-tls-length-hiding-02
[^14]: https://github.com/mirleft/ocaml-tls/issues
[^15]: https://forge.ocamlcore.org/projects/zarith
[^16]: https://gmplib.org/
[^17]: https://github.com/mirage/ocaml-cstruct
[^18]: https://opam.ocaml.org/packages/tls/tls.0.1.0/</p>
<hr/>
<p>Posts in this TLS series:</p>
<ul>
<li><a href="http://mirage.io/blog/introducing-ocaml-tls">Introducing transport layer security (TLS) in pure OCaml</a>
</li>
<li><a href="http://mirage.io/blog/introducing-nocrypto">OCaml-TLS: building the nocrypto library core</a>
</li>
<li><a href="http://mirage.io/blog/introducing-x509">OCaml-TLS: adventures in X.509 certificate parsing and validation</a>
</li>
<li><a href="http://mirage.io/blog/introducing-asn1">OCaml-TLS: ASN.1 and notation embedding</a>
</li>
<li><a href="http://mirage.io/blog/ocaml-tls-api-internals-attacks-mitigation">OCaml-TLS: the protocol implementation and mitigations to known attacks</a>
</li>
</ul>

      

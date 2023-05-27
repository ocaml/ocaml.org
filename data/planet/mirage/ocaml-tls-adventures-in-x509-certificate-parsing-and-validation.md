---
title: 'OCaml-TLS: Adventures in X.509 certificate parsing and validation'
description:
url: https://mirage.io/blog/introducing-x509
date: 2014-07-10T00:00:00-00:00
preview_image:
featured:
authors:
- Hannes Mehnert
---


        <p><em>This is the third in a series of posts that introduce new libraries for a pure OCaml implementation of TLS.
You might like to begin with the <a href="http://mirage.io/blog/introducing-ocaml-tls">introduction</a>.</em></p>
<h3>The problem of authentication</h3>
<p>The authenticity of the remote server needs to be verified while
establishing a secure connection to it, or else an
attacker (<a href="https://en.wikipedia.org/wiki/Man-in-the-middle_attack">MITM</a>) between the client and the server can eavesdrop on
the transmitted data. To the best of our knowledge, authentication
cannot be done solely in-band, but needs external
infrastructure. The most common methods used in practice rely on
public key encryption.</p>
<p><em>Web of trust</em> (used by <a href="https://en.wikipedia.org/wiki/OpenPGP">OpenPGP</a>) is a decentralised public key
infrastructure. It relies on out-of-band verification of public keys
and transitivity of trust. If Bob signed Alice's public key, and
Charlie trusts Bob (and signed his public key), then Charlie can trust
that Alice's public key is hers.</p>
<p><em>Public key infrastructure</em> (used by <a href="https://en.wikipedia.org/wiki/Transport_Layer_Security">TLS</a>) relies on trust
anchors which are communicated out-of-band (e.g. distributed with the
client software). In order to authenticate a server, a chain of trust
between a trust anchor and the server certificate (public key) is
established. Only those clients which have the trust anchor deployed
can verify the authenticity of the server.</p>
<h3>X.509 public key infrastructure</h3>
<p><a href="https://en.wikipedia.org/wiki/X.509">X.509</a> is an ITU standard for a public key infrastructure,
developed in 1988. Amongst other things, it specifies the format of
certificates, their attributes, revocation lists, and a path
validation algorithm. X.509 certificates are encoded using abstract
syntax notation one (ASN.1).</p>
<p>A <em>certificate</em> contains a public key, a subject (server name), a
validity period, a purpose (i.e. key usage), an issuer, and
possibly other extensions. All components mentioned in the certificate
are signed by an issuer.</p>
<p>A <em>certificate authority</em> (CA) receives a certificate signing request
from a server operator. It verifies that this signing request is
legitimate (e.g. requested server name is owned by the server
operator) and signs the request. The CA certificate must be trusted by
all potential clients. A CA can also issue intermediate CA
certificates, which are allowed to sign certificates.</p>
<p>When a server certificate or intermediate CA certificate is
compromised, the CA publishes this certificate in its certificate
revocation list (CRL), which each client should poll periodically.</p>
<p>The following certificates are exchanged before a TLS session:</p>
<ul>
<li>CA -&gt; Client: CA certificate, installed as trust anchor on the client
</li>
<li>Server -&gt; CA: certificate request, to be signed by the CA
</li>
<li>CA -&gt; Server: signed server certificate
</li>
</ul>
<p>During the TLS handshake the server sends the certificate chain to the
client. When a client wants to verify a certificate, it has to verify
the signatures of the entire chain, and find a trust anchor which
signed the outermost certificate. Further constraints, such as the
maximum chain length and the validity period, are checked as
well. Finally, the server name in the server certificate is checked to
match the expected identity.
For an example, you can see the sequence diagram of the TLS handshake your browser makes when you visit our <a href="https://tls.nqsb.io">demonstration server</a>.</p>
<h3>Example code for verification</h3>
<p>OpenSSL implements <a href="https://tools.ietf.org/html/rfc5280">RFC5280</a> path validation, but there is no
implementation to validate the identity of a certificate. This has to
be implemented by each client, which is rather complex (e.g. in
<a href="https://github.com/freebsd/freebsd/blob/bf1a15b165af779577b0278b3d47151edb0d47f9/lib/libfetch/common.c#L326-665">libfetch</a> it spans over more than 300 lines). A client of the
<code>ocaml-x509</code> library (such as our <a href="https://github.com/mirleft/ocaml-tls/blob/6dc9258a38489665abf2bd6cdbed8a1ba544d522/lwt/examples/http_client.ml">http-client</a>) has to
write only two lines of code:</p>
<pre><code class="language-OCaml">lwt authenticator = X509_lwt.authenticator (`Ca_dir ca_cert_dir) in
lwt (ic, oc) =
  Tls_lwt.connect_ext
    (Tls.Config.client_exn ~authenticator ())
    (host, port)
</code></pre>
<p>The authenticator uses the default directory where trust anchors are
stored (<a href="https://github.com/mirleft/ocaml-tls/blob/6dc9258a38489665abf2bd6cdbed8a1ba544d522/lwt/examples/ex_common.ml#L6">'ca_cert_dir'</a>), and this authenticator is
passed to the <a href="https://github.com/mirleft/ocaml-tls/blob/6dc9258a38489665abf2bd6cdbed8a1ba544d522/lwt/tls_lwt.ml#L227">'connect_ext'</a> function. This initiates
the TLS handshake, and passes the trust anchors and the hostname to
the TLS library.</p>
<p>During the client handshake when the certificate chain is received by
the server, the given authenticator and hostname are used to
authenticate the certificate chain (in <a href="https://github.com/mirleft/ocaml-tls/blob/6dc9258a38489665abf2bd6cdbed8a1ba544d522/lib/handshake_client.ml#L84">'validate_chain'</a>):</p>
<pre><code class="language-OCaml">match
 X509.Authenticator.authenticate ?host:server_name authenticator stack
with
 | `Fail SelfSigned         -&gt; fail Packet.UNKNOWN_CA
 | `Fail NoTrustAnchor      -&gt; fail Packet.UNKNOWN_CA
 | `Fail CertificateExpired -&gt; fail Packet.CERTIFICATE_EXPIRED
 | `Fail _                  -&gt; fail Packet.BAD_CERTIFICATE
 | `Ok                      -&gt; return server_cert
</code></pre>
<p>Internally, <code>ocaml-x509</code> extracts the hostname list from a
certificate in <a href="https://github.com/mirleft/ocaml-x509/blob/7bd25d152445263d7659c653e4a761222f43c75b/lib/certificate.ml#L134-144">'cert_hostnames'</a>, and the
<a href="https://github.com/mirleft/ocaml-x509/blob/7bd25d152445263d7659c653e4a761222f43c75b/lib/certificate.ml#L325-L346">wildcard or strict matcher</a> compares it to the input.
In total, this is less than 50 lines of pure OCaml code.</p>
<h3>Problems in X.509 verification</h3>
<p>Several weaknesses in the verification of X.509 certificates have been
discovered, ranging from cryptographic attacks due to
<a href="http://www.win.tue.nl/~bdeweger/CollidingCertificates/ddl-full.pdf">collisions in hash algorithms</a> (<a href="http://www.win.tue.nl/hashclash/rogue-ca/">practical</a>) over
<a href="http://www.blackhat.com/presentations/bh-usa-09/MARLINSPIKE/BHUSA09-Marlinspike-DefeatSSL-SLIDES.pdf">misinterpretation of the name</a> in the certificate (a C
string is terminated by a null byte), and treating X.509 version 1
certificates always as a <a href="https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2014-0092">trust anchor in GnuTLS</a>.</p>
<p>An <a href="https://crypto.stanford.edu/~dabo/pubs/abstracts/ssl-client-bugs.html">empirical study of software that does certificate
verification</a> showed that badly designed APIs are the
root cause of vulnerabilities in this area. They tested various
implementations by using a list of certificates, which did not form a
chain, and would not authenticate due to being self-signed, or
carrying a different server name.</p>
<p>Another recent empirical study (<a href="http://www.cs.utexas.edu/~suman/publications/frankencert.pdf">Frankencert</a>) generated random
certificates and validated these with various stacks. They found lots
of small issues in nearly all certificate verification stacks.</p>
<p>Our implementation mitigates against some of the known attacks: we
require a complete valid chain, check the extensions of a certificate,
and implement hostname checking as specified in <a href="https://tools.ietf.org/html/rfc6125">RFC6125</a>. We have a
<a href="https://github.com/mirleft/ocaml-x509/tree/master/tests">test suite</a> with over 3200 tests and multiple CAs. We do not yet discard
certificates which use MD5 as hash algorithm. Our TLS stack
requires certificates to have at least 1024 bit RSA keys.</p>
<h3>X.509 library internals</h3>
<p>The <code>x509</code> library uses <a href="https://github.com/mirleft/ocaml-asn-combinators">asn-combinators</a> to parse X.509 certificates and
the <a href="https://github.com/mirleft/ocaml-nocrypto">nocrypto</a> library for signature verification
(which we wrote about <a href="http://mirage.io/blog/introducing-nocrypto">previously</a>).
At the moment we do not yet
expose certificate builders from the library, but focus on certificate parsing
and certificate authentication.</p>
<p>The <a href="https://github.com/mirleft/ocaml-x509/blob/cdea2b1ae222e88a403f2d8f954a6aa31c984941/lib/x509.ml">x509</a> module provides modules which parse
PEM-encoded (<a href="https://github.com/mirleft/ocaml-x509/blob/cdea2b1ae222e88a403f2d8f954a6aa31c984941/lib/x509.ml#L18">pem</a>) certificates (<a href="https://github.com/mirleft/ocaml-x509/blob/cdea2b1ae222e88a403f2d8f954a6aa31c984941/lib/x509.ml#L85">Cert</a>)
and private keys
(<a href="https://github.com/mirleft/ocaml-x509/blob/cdea2b1ae222e88a403f2d8f954a6aa31c984941/lib/x509.ml#L105">Pk</a>), and an authenticator module
(<a href="https://github.com/mirleft/ocaml-x509/blob/cdea2b1ae222e88a403f2d8f954a6aa31c984941/lib/x509.ml#L123">Authenticators</a>).</p>
<p>So far we have two authenticators implemented:</p>
<ul>
<li><a href="https://github.com/mirleft/ocaml-x509/blob/cdea2b1ae222e88a403f2d8f954a6aa31c984941/lib/x509.ml#L137">'chain_of_trust'</a>, which implements the basic path
validation algorithm from <a href="https://tools.ietf.org/html/rfc5280">RFC5280</a> (section 6) and the hostname
validation from <a href="https://tools.ietf.org/html/rfc6125">RFC6125</a>. To construct such an authenticator, a
timestamp and a list of trust anchors is needed.
</li>
<li><a href="https://github.com/mirleft/ocaml-x509/blob/cdea2b1ae222e88a403f2d8f954a6aa31c984941/lib/x509.ml#L142">'null'</a>, which always returns success.
</li>
</ul>
<p>The method <a href="https://github.com/mirleft/ocaml-x509/blob/cdea2b1ae222e88a403f2d8f954a6aa31c984941/lib/x509.mli#L42">'authenticate'</a>, to be called when a
certificate stack should be verified, receives an authenticator, a
hostname and the certificate stack. It returns either <code>Ok</code> or <code>Fail</code>.</p>
<p>Our <a href="https://github.com/mirleft/ocaml-x509/blob/cdea2b1ae222e88a403f2d8f954a6aa31c984941/lib/asn_grammars.ml#L734">certificate type</a> is very similar to the described structure in the RFC:</p>
<pre><code class="language-OCaml">type tBSCertificate = {
  version    : [ `V1 | `V2 | `V3 ] ;
  serial     : Z.t ;
  signature  : Algorithm.t ;
  issuer     : Name.dn ;
  validity   : Time.t * Time.t ;
  subject    : Name.dn ;
  pk_info    : PK.t ;
  issuer_id  : Cstruct.t option ;
  subject_id : Cstruct.t option ;
  extensions : (bool * Extension.t) list
}

type certificate = {
  tbs_cert       : tBSCertificate ;
  signature_algo : Algorithm.t ;
  signature_val  : Cstruct.t
}
</code></pre>
<p>The certificate itself wraps the to be signed part (<a href="https://github.com/mirleft/ocaml-x509/blob/cdea2b1ae222e88a403f2d8f954a6aa31c984941/lib/asn_grammars.ml#L734">'tBSCertificate'</a>),
the used signature algorithm, and the actual signature. It consists of
a version, serial number, issuer, validity, subject, public key
information, optional issuer and subject identifiers, and a list of
extensions -- only version 3 certificates may have extensions.</p>
<p>The <a href="https://github.com/mirleft/ocaml-x509/blob/cdea2b1ae222e88a403f2d8f954a6aa31c984941/lib/certificate.mli">'certificate'</a> module implements the actual
authentication of certificates, and provides some useful getters such
as <a href="https://github.com/mirleft/ocaml-x509/blob/cdea2b1ae222e88a403f2d8f954a6aa31c984941/lib/certificate.ml#L91">'cert_type'</a>, <a href="https://github.com/mirleft/ocaml-x509/blob/cdea2b1ae222e88a403f2d8f954a6aa31c984941/lib/certificate.ml#L95">'cert_usage'</a>, and
<a href="https://github.com/mirleft/ocaml-x509/blob/cdea2b1ae222e88a403f2d8f954a6aa31c984941/lib/certificate.ml#L100">'cert_extended_usage'</a>. The main entry for
authentication is <a href="https://github.com/mirleft/ocaml-x509/blob/cdea2b1ae222e88a403f2d8f954a6aa31c984941/lib/certificate.ml#L419">'verify_chain_of_trust'</a>,
which checks correct signatures of the chain, extensions and validity
of each certificate, and the hostname of the server certificate.</p>
<p>The grammar of X.509 certificates is developed in the
<a href="https://github.com/mirleft/ocaml-x509/blob/cdea2b1ae222e88a403f2d8f954a6aa31c984941/lib/asn_grammars.ml">'asn_grammars'</a> module, and the object
identifiers are gathered in the <a href="https://github.com/mirleft/ocaml-x509/blob/cdea2b1ae222e88a403f2d8f954a6aa31c984941/lib/registry.ml">'registry'</a> module.</p>
<h3>Implementation of certificate verification</h3>
<p>We provide the function <a href="https://github.com/mirleft/ocaml-x509/blob/7bd25d152445263d7659c653e4a761222f43c75b/lib/certificate.ml#L438">'valid_cas'</a>, which takes a
timestamp and a list of certificate authorities. Each certificate
authority is checked to be <a href="https://github.com/mirleft/ocaml-x509/blob/7bd25d152445263d7659c653e4a761222f43c75b/lib/certificate.ml#L282">valid</a>, self-signed,
correctly signed, and having
<a href="https://github.com/mirleft/ocaml-x509/blob/7bd25d152445263d7659c653e4a761222f43c75b/lib/certificate.ml#L277">proper X.509 v3 extensions</a>.
As mentioned above, version 1 and version 2
certificates do not contain extensions. For a version 3 certificate,
<a href="https://github.com/mirleft/ocaml-x509/blob/7bd25d152445263d7659c653e4a761222f43c75b/lib/certificate.ml#L206">'validate_ca_extensions'</a> is called: The
basic constraints extensions must be present, and its value must be
true. Also, key usage must be present and the certificate must be
allowed to sign certificates. Finally, we reject the certificate if
there is any extension marked critical, apart from the two mentioned
above.</p>
<p>When we have a list of validated CA certificates, we can use these to
<a href="https://github.com/mirleft/ocaml-x509/blob/cdea2b1ae222e88a403f2d8f954a6aa31c984941/lib/certificate.ml#L419">verify the chain of trust</a>, which gets a
hostname, a timestamp, a list of trust anchors and a certificate chain
as input. It first checks that the <a href="https://github.com/mirleft/ocaml-x509/blob/7bd25d152445263d7659c653e4a761222f43c75b/lib/certificate.ml#L384">server certificate is
valid</a>, the <a href="https://github.com/mirleft/ocaml-x509/blob/7bd25d152445263d7659c653e4a761222f43c75b/lib/certificate.ml#L264">validity of the intermediate
certificates</a>, and that the <a href="https://github.com/mirleft/ocaml-x509/blob/7bd25d152445263d7659c653e4a761222f43c75b/lib/certificate.ml#L421">chain is complete</a>
(the pathlen constraint is not validated) and rooted in a trust
anchor. A server certificate is valid if the validity period matches
the current timestamp, the given hostname <a href="https://github.com/mirleft/ocaml-x509/blob/7bd25d152445263d7659c653e4a761222f43c75b/lib/certificate.ml#L333">matches</a>
its subject alternative name extension or common name (might be
wildcard or strict matching, <a href="https://tools.ietf.org/html/rfc6125">RFC6125</a>), and it does not have a
basic constraints extension which value is true.</p>
<h3>Current status of ocaml-x509</h3>
<p>We currently support only RSA certificates. We do not check revocation
lists or use the online certificate status protocol (<a href="http://en.wikipedia.org/wiki/Online_Certificate_Status_Protocol">OCSP</a>). Our
implementation does not handle name constraints and policies. However, if
any of these extensions is marked critical, we refuse to validate the
chain. To keep our main authentication free of side-effects, it currently uses
the timestamp when the authenticator was created rather than when it is used
(this isn't a problem if lifetime of the OCaml-TLS process is comparatively
short, as in the worst case the lifetime of the certificates can be extended by
the lifetime of the process).</p>
<p>We invite people to read through the
<a href="https://github.com/mirleft/ocaml-x509/blob/7bd25d152445263d7659c653e4a761222f43c75b/lib/certificate.ml">certificate verification</a> and the
<a href="https://github.com/mirleft/ocaml-x509/blob/7bd25d152445263d7659c653e4a761222f43c75b/lib/asn_grammars.ml">ASN.1 parsing</a>. We welcome discussion on the
<a href="http://lists.xenproject.org/archives/html/mirageos-devel/">mirage-devel mailing list</a> and bug reports
on the <a href="https://github.com/mirleft/ocaml-x509/issues">GitHub issue tracker</a>.</p>
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

      

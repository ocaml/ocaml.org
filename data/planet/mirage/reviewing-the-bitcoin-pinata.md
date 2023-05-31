---
title: Reviewing the Bitcoin Pinata
description:
url: https://mirage.io/blog/bitcoin-pinata-results
date: 2015-06-29T00:00:00-00:00
preview_image:
featured:
authors:
- Hannes Mehnert
---


        <p>TL;DR: Nobody took our BTC.  Random people from the Internet even donated
into our BTC wallet.
We showed the feasibility of a
transparent self-service bounty.  In the style of Dijkstra: security
bounties can be a very effective way to show the presence of
vulnerabilities, but they are hopelessly inadequate for showing their
absence.</p>
<h4>What are you talking about?</h4>
<p>Earlier this year, we <a href="https://mirage.io/blog/announcing-bitcoin-pinata">released a Bitcoin Pi&ntilde;ata</a>.
The <a href="http://ownme.ipredator.se">Pi&ntilde;ata</a> was a security bounty
containing 10 BTC and it's been online since 10th February 2015.
Upon successful
mutual authentication, where the Pi&ntilde;ata has only a single trust anchor, it sends the
private key to the Bitcoin address.</p>
<p><a href="https://github.com/mirleft/btc-pinata">It is open source</a>,
and exposes both the client and server side of
<a href="https://github.com/mirleft/ocaml-tls">ocaml-tls</a>, running as an 8.2MB
<a href="https://mirage.io">MirageOS</a> unikernel.  You can see the <a href="https://github.com/mirleft/btc-pinata/blob/master/opam-full.txt">code manifest</a> to find out which libraries are involved.  We put this online and invited people to attack it.</p>
<p>Any approach was permitted in attacking the Pi&ntilde;ata:
the host system, the MirageOS <a href="https://github.com/mirage/mirage-tcpip">TCP/IP
stack</a>, our TLS,
X.509 and ASN.1 implementations, as well as the Pi&ntilde;ata code.
A successful attacker could do whatever they want with the BTC, no
questions asked (though we would <a href="https://blockchain.info/address/183XuXTTgnfYfKcHbJ4sZeF46a49Fnihdh">notice the transaction</a>).</p>
<p>The exposed server could even be short-circuited to the exposed
client: you could proxy a TLS connection in which the (encrypted!)
secret was transmitted via your machine.</p>
<p>This post summarises what we've seen so far and what we've learned about attempts people have made to take the BTC.</p>
<h4>Accesses</h4>
<p>There were 50,000 unique IP addresses who accessed the website.
1000 unique IP addresses initiated more than 20,000 TLS
connections to the Pi&ntilde;ata, trying to break it.  Cumulative numbers of
the HTTP and TLS accesses are shown in the diagram:</p>
<img src="https://mirage.io/graphics/pinata_access.png" alt="Cumulative Pi&ntilde;ata accesses"/>
<p>There were more than 9000 failing and 12000 successful TLS sessions,
comprised of short-circuits described earlier, and our own tests.</p>
<p>No X.509 certificate was presented in 1200 of the failed TLS
connections.  Another 1000 failed due to invalid input as the first
bytes.  This includes attempts using telnet &mdash; I'm looking at you,
xx.xxx.74.126 <code>please give key</code> (on 10th February at 16:00) and
xx.xxx.166.143 <code>hi give me teh btcs</code> (on 11th February at 05:57)!</p>
<h4>We are not talking to everybody</h4>
<p>Our implementation first parses the record version of a client hello,
and if it fails, an unknown record version is reported.  This happened
in 10% of all TLS connections (including the 1000 with invalid input in the
last section).</p>
<p>Another big class, 6%, were attempted Heartbeat packets (popular due
to <a href="https://en.wikipedia.org/wiki/Heartbleed">Heartbleed</a>), which we
do not implement.</p>
<p>Recently, issues in the state machines of TLS implementations were
published in <a href="http://smacktls.com">smacktls</a> (and <a href="http://ccsinjection.lepidum.co.jp/">CCS
injection</a>).  3% of the Pi&ntilde;ata connections
received an unexpected handshake record at some point, which the Pi&ntilde;ata handled
correctly by shutting down the connection.</p>
<p>In 2009, the <a href="https://en.wikipedia.org/wiki/Transport_Layer_Security#Renegotiation_attack">renegotiation
attack</a>
on the TLS protocol was published, which allowed a person in the
middle to inject prefix bytes, because a renegotiated handshake was
not authenticated with data from the previous handshake.  OCaml-TLS
closes a connection if the <a href="https://tools.ietf.org/html/rfc5746">renegotiation
extension</a> is not present, which
happened in 2% of the connections.
Another 2% did not propose a ciphersuite supported by OCaml-TLS; yet
another 2% tried to talk SSL version 3 with us, which we do not
implement (for <a href="https://tools.ietf.org/html/rfc7568">good reasons</a>, such as
<a href="https://www.us-cert.gov/ncas/alerts/TA14-290A">POODLE</a>).</p>
<p>In various other (old versions of) TLS implementations, these
connections would have been successful and insecure!</p>
<h4>Attempts worth noting</h4>
<p>Interesting failures were: 31 connections which sent too many or too
few bytes, leading to parse errors.</p>
<p>TLS requires each communication partner who authenticates themselves to
present a certificate.  To prove ownership of the private key of the
certificate, a hash of the concatenated handshake records needs to be
signed and transmitted over the wire.  22 of our TLS traces had
invalid signatures.  Not verifying such signatures was the problem of Apple's famous <a href="https://www.imperialviolet.org/2014/02/22/applebug.html">goto
fail</a>.</p>
<p>Another 100 failure traces tested our X.509 validation:
The majority of these failures (58) sent us certificates which were not signed by our trust
anchor, such as <code>CN=hacker/emailAddress=hacker@hacker</code> and <code>CN=Google Internal SNAX Authority</code> and various Apple and Google IDs -- we're still trying to figure out what SNAX is, Systems Network Architecture maybe?</p>
<p>Several certificates contained invalid X.509 extensions: we require
that a server certificate does not contain the <code>BasicConstraints = true</code> extension, which marks this certificate as certificate
authority, allowing to sign other certificates.  While not explicitly
forbidden, best practices (e.g. from
<a href="https://wiki.mozilla.org/SecurityEngineering/mozpkix-testing#Behavior_Changes">Mozilla</a>)
reject them.  Any sensible systems administrator would not accept a CA
as a server certificate.</p>
<p>Several other certificates were self-signed or contained an invalid
signature: one certificate was our client certificate, but with a
different RSA public key, thus the signature on the certificate was
invalid; another one had a different RSA public key, and the signature
was zeroed out.</p>
<p>Some certificates were not of X.509 version 3, or were expired.
Several certificate chains were not pairwise signed, a <a href="https://crypto.stanford.edu/~dabo/pubs/abstracts/ssl-client-bugs.html">common attack
vector</a>.</p>
<p>Two traces contained certificate structures which our ASN.1 parser
rejected.</p>
<p>Another two connections (both initiated by ourselves) threw an
exception which lead to <a href="https://github.com/mirleft/btc-pinata/blob/master/logger.ml#L116">shutdown of the connection</a>: there
<a href="https://github.com/mirleft/ocaml-tls/commit/80117871679d57dde8c8e3b73392024ef4b42c38">was</a>
an out-of-bounds access while parsing handshake records.  This did not
lead to arbitrary code execution.</p>
<h4>Conclusion</h4>
<p>The BTC Pi&ntilde;ata was the first transparent self-service bounty, and it
was a success: people showed interest in the topic; some even donated
BTC; we enjoyed setting it up and running it; we fixed a non-critical
out of bounds access in our implementation; a large fraction of our
stack has been covered by the recorded traces.</p>
<p>There are several points to improve a future Pi&ntilde;ata: attestation that the code
running is the open sourced code, attestation that the service owns
the private key (maybe by doing transactions or signatures with input
from any user).</p>
<p>There are several applications using OCaml-TLS, using MirageOS as well
as Unix:</p>
<ul>
<li><a href="https://github.com/mirage/mirage-seal">mirage-seal</a> compiles to
a unikernel container which serves a given directory over https;
</li>
<li><a href="https://github.com/hannesm/tlstunnel">tlstunnel</a> is a
(<a href="https://github.com/bumptech/stud">stud</a> like) TLS proxy, forwarding
to a backend server;
</li>
<li><a href="https://github.com/hannesm/jackline">jackline</a> is a
(alpha version) terminal-based XMPP client;
</li>
<li><a href="https://github.com/mirage/ocaml-conduit">conduit</a> is an abstraction
over network connections -- to make it use OCaml-TLS, set
<code>CONDUIT_TLS=native</code>.
</li>
</ul>
<p>Again, a big thank you to <a href="https://ipredator.se">IPredator</a> for
hosting our BTC Pi&ntilde;ata and lending us the BTC!</p>

      

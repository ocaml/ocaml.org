---
title: 'OCaml-TLS: the protocol implementation and mitigations to known attacks'
description:
url: https://mirage.io/blog/ocaml-tls-api-internals-attacks-mitigation
date: 2014-07-14T00:00:00-00:00
preview_image:
featured:
authors:
- David Kaloper
---


        <p><em>This is the fifth in a series of posts that introduce new libraries for a pure OCaml implementation of TLS.
You might like to begin with the <a href="http://mirage.io/blog/introducing-ocaml-tls">introduction</a>.</em></p>
<p><a href="https://github.com/mirleft/ocaml-tls">ocaml-tls</a> is the new, clean-slate implementation of TLS in OCaml
that we've been working on for the past six months. In this post we
try to document some of its internal design, the reasons for the
decisions we made, and the current security status of that work. Try
our <a href="https://tls.nqsb.io">live interactive demonstration server</a> which visualises TLS
sessions.</p>
<h3>The OCaml-TLS architecture</h3>
<p>The OCaml ecosystem has several distinct ways of interacting with the outside world
(and the network in particular): straightforward <a href="http://caml.inria.fr/pub/docs/manual-ocaml/libref/Unix.html">unix</a> interfaces
and the asynchronous programming libraries <a href="http://ocsigen.org/lwt/">lwt</a> and <a href="https://realworldocaml.org/v1/en/html/concurrent-programming-with-async.html">async</a>. One of the
early considerations was not to restrict ourselves to any of those -- we wanted
to support them all.</p>
<p>There were also two distinct basic &quot;platforms&quot; we wanted to target from the
outset: the case of a simple executable, and the case of <code>Mirage</code> unikernels.</p>
<p>So one of the first questions we faced was deciding how to represent
interactions with the network in a portable way. This can be done by
systematically abstracting out the API boundary which gives access to network
operations, but we had a third thing in mind as well: we wanted to exploit the
functional nature of OCaml to its fullest extent!</p>
<p>Our various prior experiences with Haskell and Idris convinced us to adopt
what is called &quot;purely functional&quot; technique. We believe it to be an approach
which first forces the programmer to give principled answers to all the
difficult design questions (errors and global data-flow) <em>in advance</em>, and then
leads to far cleaner and composable code later on. A purely functional system
has all the data paths made completely explicit in the form of function
arguments and results. There are no unaccounted-for interactions between
components mediated by shared state, and all the activity of the parts of the
system is exposed through types since, after all, it's only about computing
values from values.</p>
<p>For these reasons, the library is split into two parts: the directory <code>/lib</code>
(and the corresponding findlib package <code>tls</code>) contains the core TLS logic, and
<code>/mirage</code> and <code>/lwt</code> (packaged as <code>tls.mirage</code> and <code>tls.lwt</code> respectively)
contain front-ends that tie the core to <code>Mirage</code> and <code>Lwt_unix</code>.</p>
<h3>Core</h3>
<p>The <a href="https://github.com/mirleft/ocaml-tls/blob/6dc9258a38489665abf2bd6cdbed8a1ba544d522/lib/engine.mli">core</a> library is purely functional. A TLS session is represented by the
abstract type <code>Tls.Engine.state</code>, and various functions consume this session
type together with raw bytes (<code>Cstruct.t</code> -- which is by itself mutable, but
<code>ocaml-tls</code> eschews this) and produce new session values and resulting buffers.</p>
<p>The central entry point is <a href="https://github.com/mirleft/ocaml-tls/blob/6dc9258a38489665abf2bd6cdbed8a1ba544d522/lib/engine.ml#L321">handle_tls</a>, which transforms an input state and a
buffer to an output state, a (possibly empty) buffer to send to the
communication partner, and an optional buffer of data intended to be received by
the application:</p>
<pre><code class="language-OCaml">type state

type ret = [
  | `Ok of [ `Ok of state | `Eof | `Alert of alert ] *
      [ `Response of Cstruct.t ] * [ `Data of Cstruct.t option ]
  | `Fail of alert * [ `Response of Cstruct.t ]
]

val handle_tls : state -&gt; Cstruct.t -&gt; ret
</code></pre>
<p>As the signature shows, errors are signalled through the <code>ret</code> type, which is a <a href="https://realworldocaml.org/v1/en/html/variants.html#polymorphic-variants">polymorphic variant</a>. This
reflects the actual internal structure: all the errors are represented as
values, and operations are composed using an error <a href="https://github.com/mirleft/ocaml-tls/blob/6dc9258a38489665abf2bd6cdbed8a1ba544d522/lib/control.ml">monad</a>.</p>
<p>Other entry points share the same basic behaviour: they transform the prior
state and input bytes into the later state and output bytes.</p>
<p>Here's a rough outline of what happens in <code>handle_tls</code>:</p>
<ul>
<li>
<p>TLS packets consist of a header, which contains the protocol
version, length, and content type, and the payload of the given
content type. Once inside our <a href="https://github.com/mirleft/ocaml-tls/blob/6dc9258a38489665abf2bd6cdbed8a1ba544d522/lib/engine.ml#L321">main handler</a>, we
<a href="https://github.com/mirleft/ocaml-tls/blob/6dc9258a38489665abf2bd6cdbed8a1ba544d522/lib/engine.ml#L150">separate</a> the buffer into TLS records, and
<a href="https://github.com/mirleft/ocaml-tls/blob/6dc9258a38489665abf2bd6cdbed8a1ba544d522/lib/engine.ml#L275">process</a> each individually. We first check that
the version number is correct, then <a href="https://github.com/mirleft/ocaml-tls/blob/6dc9258a38489665abf2bd6cdbed8a1ba544d522/lib/engine.ml#L95">decrypt</a>, and <a href="https://github.com/mirleft/ocaml-tls/blob/6dc9258a38489665abf2bd6cdbed8a1ba544d522/lib/engine.ml#L85">verify
the mac</a>.</p>
</li>
<li>
<p>Decrypted data is then <a href="https://github.com/mirleft/ocaml-tls/blob/6dc9258a38489665abf2bd6cdbed8a1ba544d522/lib/engine.ml#L240">dispatched</a> to one of four
sub-protocol handlers (Handshake, Change Cipher Spec, Alert and
Application Data). Each handler can <a href="https://github.com/mirleft/ocaml-tls/blob/6dc9258a38489665abf2bd6cdbed8a1ba544d522/lib/state.ml#L109">return</a> a new
handshake state, outgoing data, application data, the new decryption
state or an error (with the outgoing data being an interleaved list
of buffers and new encryption states).</p>
</li>
<li>
<p>The outgoing buffers and the encryption states are
<a href="https://github.com/mirleft/ocaml-tls/blob/6dc9258a38489665abf2bd6cdbed8a1ba544d522/lib/engine.ml#L48">traversed</a> to produce the final output to be sent to the
communication partner, and the final encryption, decryption and
handshake states are combined into a new overall state which is
returned to the caller.</p>
</li>
</ul>
<p>Handshake is (by far) the most complex TLS sub-protocol, with an elaborate state
machine. Our <a href="https://github.com/mirleft/ocaml-tls/blob/6dc9258a38489665abf2bd6cdbed8a1ba544d522/lib/handshake_client.ml#L285">client</a> and <a href="https://github.com/mirleft/ocaml-tls/blob/6dc9258a38489665abf2bd6cdbed8a1ba544d522/lib/handshake_server.ml#L247">server</a> encode
this state as a &quot;flat&quot; <a href="https://github.com/mirleft/ocaml-tls/blob/6dc9258a38489665abf2bd6cdbed8a1ba544d522/lib/state.ml#L61">sum type</a>, with exactly one incoming
message allowed per state. The handlers first <a href="https://github.com/mirleft/ocaml-tls/blob/6dc9258a38489665abf2bd6cdbed8a1ba544d522/lib/reader.ml#L361">parse</a> the
handshake packet (which fails in case of malformed or unknown data) and then
dispatch it to the handling function. The <a href="https://github.com/mirleft/ocaml-tls/blob/6dc9258a38489665abf2bd6cdbed8a1ba544d522/lib/state.ml#L92">handshake state</a> is
carried around and a fresh one is returned from the handler in case it needs
updates. It consists of a protocol version, the handshake state, configuration,
renegotiation data, and possibly a handshake fragment.</p>
<p>Logic of both handshake handlers is very localised, and does not mutate any
global data structures.</p>
<h3>Core API</h3>
<p>OCaml permits the implementation a module to be exported via a more
abstract <em>signature</em> that hides the internal representation
details. Our public API for the core library consists of the
<a href="https://github.com/mirleft/ocaml-tls/blob/6dc9258a38489665abf2bd6cdbed8a1ba544d522/lib/engine.mli">Tls.Engine</a> and <a href="https://github.com/mirleft/ocaml-tls/blob/6dc9258a38489665abf2bd6cdbed8a1ba544d522/lib/config.mli">Tls.Config</a> modules.</p>
<p><code>Tls.Engine</code> contains the basic reactive function <code>handle_tls</code>, mentioned above,
which processes incoming data and optionally produces a response, together with
several operations that allow one to initiate message transfer like
<code>send_application_data</code> (which processes application-level messages for
sending), <code>send_close_notify</code> (for sending the ending message) and <code>reneg</code>
(which initiates full TLS renegotiation).</p>
<p>The module also contains the only two ways to obtain the initial state:</p>
<pre><code class="language-OCaml">val client : Config.client -&gt; (state * Cstruct.t)
val server : Config.server -&gt; state
</code></pre>
<p>That is, one needs a configuration value to create it. The <code>Cstruct.t</code>
that <code>client</code> emits is the initial Client Hello since in TLS,
the client starts the session.</p>
<p><code>Tls.Config</code> synthesizes configurations, separately for client and server
endpoints, through the functions <code>client_exn</code> and <code>server_exn</code>. They take a
number of parameters that define a TLS session, check them for consistency, and
return the sanitized <code>config</code> value which can be used to create a <code>state</code> and,
thus, a session. If the check fails, they raise an exception.</p>
<p>The parameters include the pair of a certificate and its private key for the
server, and an <code>X509.Authenticator.t</code> for the client, both produced by our
<a href="https://github.com/mirleft/ocaml-x509">ocaml-x509</a> library and described in a <a href="http://mirage.io/blog/introducing-x509">previous article</a>.</p>
<p>This design reflects our attempts to make the API as close to &quot;fire and forget&quot;
as we could, given the complexity of TLS: we wanted the library to be relatively
straightforward to use, have a minimal API footprint and, above all, fail very
early and very loudly when misconfigured.</p>
<h3>Effectful front-ends</h3>
<p>Clearly, reading and writing network data <em>does</em> change the state of the world.
Having a pure value describing the state of a TLS session is not really useful
once we write something onto the network; it is certainly not the case that we
can use more than one distinct <code>state</code> to process further data, as only one
value is in sync with the other endpoint at any given time.</p>
<p>Therefore we wrap the core types into stateful structures loosely inspired by
sockets and provide IO operations on those. The structures of <code>mirage</code> and <code>lwt</code>
front-ends mirror one another.</p>
<p>In both cases, the structure is pull-based in the sense that no processing is
done until the client requires a read, as opposed to a callback-driven design
where the client registers a callback and the library starts spinning in a
listening loop and invoking it as soon as there is data to be processed. We do
this because in an asynchronous context, it is easy to create a callback-driven
interface from a demand-driven one, but the opposite is possible only with
unbounded buffering of incoming data.</p>
<p>One exception to demand-driven design is the initial session creation: the
library will only yield the connection after the first handshake is over,
ensuring the invariant that it is impossible to interact with a connection if it
hasn't already been fully established.</p>
<p><strong>Mirage</strong></p>
<p>The <code>Mirage</code> <a href="https://github.com/mirleft/ocaml-tls/blob/6dc9258a38489665abf2bd6cdbed8a1ba544d522/mirage/tls_mirage_types.mli">interface</a> matches the <a href="https://github.com/mirage/mirage/blob/ae3c966f8d726dc97208595b8005e02e39478cb1/types/V1.mli#L136">FLOW</a>
signature (with additional TLS-specific operations). We provide a functor that
needs to be applied to an underlying TCP module, to obtain a TLS transport on
top. For example:</p>
<pre><code class="language-OCaml">module Server (Stack: STACKV4) (Entropy: ENTROPY) (KV: KV_RO) =
struct

  module TLS  = Tls_mirage.Make (Stack.TCPV4) (Entropy)
  module X509 = Tls_mirage.X509 (KV) (Clock)

  let accept conf flow =
    TLS.server_of_tcp_flow conf flow &gt;&gt;= function
    | `Ok tls -&gt;
      TLS.read tls &gt;&gt;= function
      | `Ok buf -&gt;
        TLS.write tls buf &gt;&gt;= fun () -&gt; TLS.close buf

  let start stack e kv =
    TLS.attach_entropy e &gt;&gt;= fun () -&gt;
    lwt authenticator = X509.authenticator kv `Default in
    let conf          = Tls.Config.server_exn ~authenticator () in
    Stack.listen_tcpv4 stack 4433 (accept conf) ;
    Stack.listen stack

end
</code></pre>
<p><strong>Lwt</strong></p>
<p>The <code>lwt</code> interface has <a href="https://github.com/mirleft/ocaml-tls/blob/6dc9258a38489665abf2bd6cdbed8a1ba544d522/lwt/tls_lwt.mli">two layers</a>. <code>Tls_lwt.Unix</code> is loosely based
on read/write operations from <code>Lwt_unix</code> and provides in-place update of
buffers. <code>read</code>, for example, takes a <code>Cstruct.t</code> to write into and returns the
number of bytes read. The surrounding module, <code>Tls_lwt</code>, provides a simpler,
<code>Lwt_io</code>-compatible API built on top:</p>
<pre><code class="language-OCaml">let main host port =
  Tls_lwt.rng_init () &gt;&gt;= fun () -&gt;
  lwt authenticator = X509_lwt.authenticator (`Ca_dir nss_trusted_ca_dir) in
  lwt (ic, oc)      = Tls_lwt.connect ~authenticator (host, port) in
  let req = String.concat &quot;\\r\\n&quot; [
    &quot;GET / HTTP/1.1&quot; ; &quot;Host: &quot; ^ host ; &quot;Connection: close&quot; ; &quot;&quot; ; &quot;&quot;
  ] in
  Lwt_io.(write oc req &gt;&gt;= fun () -&gt; read ic &gt;&gt;= print)
</code></pre>
<p>We have further plans to provide wrappers for <a href="https://realworldocaml.org/v1/en/html/concurrent-programming-with-async.html"><code>Async</code></a> and plain <a href="http://caml.inria.fr/pub/docs/manual-ocaml/libref/Unix.html"><code>Unix</code></a> in a
similar vein.</p>
<h3>Attacks on TLS</h3>
<p>TLS the most widely deployed security protocol on the Internet and, at
over 15 years, is also showing its age. As such, a flaw is a valuable
commodity due to the commercially sensitive nature of data that is
encrypted with TLS. Various vulnerabilities on different layers of TLS
have been found - <a href="https://en.wikipedia.org/wiki/Heartbleed">heartbleed</a> and others are implementation
specific, advancements in cryptanalysis such as <a href="http://eprint.iacr.org/2005/067">collisions of
MD5</a> lead to vulnerabilities, and even others are due
to incorrect usage of TLS (<a href="http://www.theregister.co.uk/2013/08/01/gmail_hotmail_hijacking/">truncation attack</a> or
<a href="http://breachattack.com/">BREACH</a>). Finally, some weaknesses are in the protocol
itself. Extensive <a href="http://eprint.iacr.org/2013/049.pdf">overviews</a> of <a href="http://www.mitls.org/wsgi/tls-attacks">attacks on
TLS</a> are available.</p>
<p>We look at protocol level attacks of TLS and how <a href="https://github.com/mirleft/ocaml-tls">ocaml-tls</a>
implements mitigations against these.  <a href="https://tools.ietf.org/html/rfc5246#appendix-D.4">TLS 1.2 RFC</a> provides an
overview of attacks and mitigations, and we <a href="https://github.com/mirleft/ocaml-tls/issues/31">track</a> our progress in
covering them. This is slightly out of date as the RFC is roughly six years old and
in the meantime more attacks have been published, such as the <a href="http://www.educatedguesswork.org/2009/11/understanding_the_tls_renegoti.html">renegotiation
flaw</a>.</p>
<p>As <a href="http://mirage.io/blog/introducing-ocaml-tls">already mentioned</a>, we track all our
<a href="https://github.com/mirleft/ocaml-tls/issues?labels=security%20concern&amp;page=1&amp;state=closed">mitigated</a> and <a href="https://github.com/mirleft/ocaml-tls/issues?labels=security%20concern&amp;page=1&amp;state=open">open</a> security issues on our GitHub
issue tracker.</p>
<p>Due to the choice of using OCaml, a memory managed programming
language, we obstruct entire bug classes, namely temporal and spatial
memory safety.</p>
<p>Cryptanalysis and improvement of computational power weaken some
ciphers, such as RC4 and 3DES (see <a href="https://github.com/mirleft/ocaml-tls/issues/8">issue 8</a> and <a href="https://github.com/mirleft/ocaml-tls/issues/10">issue
10</a>). If we phase these two ciphers out, there wouldn't be
any matching ciphersuite left to communicate with some compliant TLS-1.0
implementations, such as Windows XP, that do not support AES.</p>
<p><strong>Timing attacks</strong></p>
<p>When the timing characteristics between the common case and the error
case are different, this might potentially leak confidential
information. Timing is a very prominent side-channel and there are a huge
variety of timing attacks on different layers, which are observable by
different attackers. Small differences in timing behaviour might
initially be exploitable only by a local attacker, but advancements to
the attack (e.g. increasing the number of tests) might allow a
remote attacker to filter the noise and exploit the different timing
behaviour.</p>
<p><strong>Timing of cryptographic primitives</strong></p>
<p>We <a href="http://mirage.io/blog/introducing-nocrypto">already mentioned</a> <a href="http://www.cs.tau.ac.il/~tromer/papers/cache.pdf">cache</a> <a href="http://cr.yp.to/antiforgery/cachetiming-20050414.pdf">timing</a>
attacks on our AES implementation, and that we use <a href="https://en.wikipedia.org/wiki/Blinding_(cryptography)">blinding</a>
techniques to mitigate RSA timing attacks.</p>
<p>By using a memory managed programming language, we open the attack
vector of garbage collector (GC) timing attacks (also mentioned <a href="http://mirage.io/blog/introducing-nocrypto">in
our nocrypto introduction</a>).</p>
<p>Furthermore, research has been done on virtual machine side channels
(<a href="http://eprint.iacr.org/2013/448.pdf">l3</a>, <a href="http://www.cs.unc.edu/~reiter/papers/2012/CCS.pdf">cross vm</a> and <a href="http://fc12.ifca.ai/pre-proceedings/paper_70.pdf">cache timing</a>), which we
will need to study and mitigate appropriately.</p>
<p><strong>For the time being we suggest to not use the stack on a multi-tenant
shared host or on a shared host which malicious users might have
access to.</strong></p>
<p><strong>Bleichenbacher</strong></p>
<p>In 1998, Daniel Bleichenbacher discovered a <a href="http://archiv.infsec.ethz.ch/education/fs08/secsem/Bleichenbacher98.pdf">timing flaw in the
PKCS1</a> encoding of the premaster secret: the TLS server
failed faster when the padding was wrong than when the decryption
failed. Using this timing, an attacker can run an adaptive chosen
ciphertext attack and find out the plain text of a PKCS1 encrypted
message. In TLS, when RSA is used as the key exchange method, this
leads to discovery of the premaster secret, which is used to derive the
keys for the current session.</p>
<p>The mitigation is to have both padding and decryption failures use the
exact same amount of time, thus there should not be any data-dependent
branches or different memory access patterns in the code. We
implemented this mitigation in <a href="https://github.com/mirleft/ocaml-tls/blob/c06cbaaffe49024d8570916b70f7839603a54692/lib/handshake_server.ml#L45">Handshake_server</a>.</p>
<p><strong>Padding oracle and CBC timing</strong></p>
<p><a href="http://www.iacr.org/archive/eurocrypt2002/23320530/cbc02_e02d.pdf">Vaudenay</a> discovered a vulnerability involving block ciphers: if an
attacker can distinguish between bad mac and bad padding, recovery of
the plaintext is possible (within an adaptive chosen ciphertext
attack). Another approach using the same issue is to use
<a href="http://lasecwww.epfl.ch/memo/memo_ssl.shtml">timing</a> information instead of separate error messages.
Further details are described <a href="https://www.openssl.org/~bodo/tls-cbc.txt">here</a>.</p>
<p>The countermeasure, which we implement <a href="https://github.com/mirleft/ocaml-tls/blob/c06cbaaffe49024d8570916b70f7839603a54692/lib/engine.ml#L100">here</a>, is to continue
with the mac computation even though the padding is
incorrect. Furthermore, we send the same alert (<code>bad_record_mac</code>)
independent of whether the padding is malformed or the mac is
incorrect.</p>
<p><strong>Lucky 13</strong></p>
<p>An advancement of the CBC timing attack was discovered in 2013, named
<a href="http://www.isg.rhul.ac.uk/tls/Lucky13.html">Lucky 13</a>. Due to the fact that the mac is computed over the
plaintext without padding, there is a slight (but measurable)
difference in timing between computing the mac of the plaintext and
computing the fake mac of the ciphertext. This leaks information. We
do not have proper mitigation against Lucky 13 in place yet.  You can
find further discussion in <a href="https://github.com/mirleft/ocaml-tls/issues/7">issue 7</a> and <a href="https://github.com/mirleft/ocaml-tls/pull/49">pull request
49</a>.</p>
<p><strong>Renegotiation not authenticated</strong></p>
<p>In 2009, Marsh Ray published a vulnerability of the TLS protocol which
lets an attacker prepend arbitrary data to a session due to
<a href="http://www.educatedguesswork.org/2009/11/understanding_the_tls_renegoti.html">unauthenticated renegotiation</a>. The attack
exploits the fact that a renegotiation of ciphers and key material is
possible within a session, and this renegotiated handshake is not
authenticated by the previous handshake. A man in the middle can
initiate a session with a server, send some data, and hand over the
session to a client. Neither the client nor the server can detect the
man in the middle.</p>
<p>A fix for this issue is the <a href="https://tools.ietf.org/html/rfc5746">secure renegotiation extension</a>,
which embeds authenticated data of the previous handshake into the
client and server hello messages. Now, if a man in the middle
initiates a renegotiation, the server will not complete it due to
missing authentication data (the client believes this is the first
handshake).</p>
<p>We implement and require the secure renegotiation extension by
default, but it is possible to configure <code>ocaml-tls</code> to not require
it -- to be able to communicate with servers and
clients which do not support this extension.</p>
<p>Implementation of the mitigation is on the server side in
<a href="https://github.com/mirleft/ocaml-tls/blob/c06cbaaffe49024d8570916b70f7839603a54692/lib/handshake_server.ml#L85">ensure_reneg</a> and on the client side in <a href="https://github.com/mirleft/ocaml-tls/blob/c06cbaaffe49024d8570916b70f7839603a54692/lib/handshake_client.ml#L50">validate_reneg</a>. The
data required for the secure renegotiation is stored in
<a href="https://github.com/mirleft/ocaml-tls/blob/c06cbaaffe49024d8570916b70f7839603a54692/lib/state.ml#L97"><code>handshake_state</code></a> while sending and receiving Finished
messages. You can find further discussion in <a href="https://github.com/mirleft/ocaml-tls/issues/3">issue 3</a>.</p>
<p><strong>TLS 1.0 and known-plaintext (BEAST)</strong></p>
<p>TLS 1.0 reuses the last ciphertext block as IV in CBC mode. If an attacker
has a (partially) known plaintext, she can find the remaining plaintext.
This is known as the <a href="http://vnhacker.blogspot.co.uk/2011/09/beast.html">BEAST</a> attack and there is a <a href="https://bugzilla.mozilla.org/show_bug.cgi?id=665814">long discussion</a>
about mitigations. Our mitigation is to prepend each TLS-1.0
application data fragment with an empty fragment to randomize the IV.
We do this exactly <a href="https://github.com/mirleft/ocaml-tls/blob/c06cbaaffe49024d8570916b70f7839603a54692/lib/engine.ml#L375">here</a>. There is further discussion in
<a href="https://github.com/mirleft/ocaml-tls/issues/2">issue 2</a>.</p>
<p>Our mitigation is slightly different from the 1/n-1 splitting proposed
<a href="https://community.qualys.com/blogs/securitylabs/2013/09/10/is-beast-still-a-threat">here</a>: we split every application data frame into a 0 byte
and n byte frame, whereas they split into a 1 byte and a n-1 byte
frame.</p>
<p>Researchers have exploited this vulnerability in 2011, although it was
known since <a href="http://eprint.iacr.org/2006/136">2006</a>. TLS versions 1.1 and 1.2 use an explicit IV,
instead of reusing the last cipher block on the wire.</p>
<p><strong>Compression and information leakage (CRIME)</strong></p>
<p>When using compression on a chosen-plaintext, encrypting this can leak
information, known as <a href="http://arstechnica.com/security/2012/09/crime-hijacks-https-sessions/">CRIME</a>. <a href="http://breachattack.com/">BREACH</a> furthermore
exploits application layer compression, such as HTTP compression. We
mitigate CRIME by not providing any TLS compression support, while we
cannot do anything to mitigate BREACH.</p>
<p><strong>Traffic analysis</strong></p>
<p>Due to limited amount of padding data, the actual size of transmitted
data can be recovered. The mitigation is to implement <a href="http://tools.ietf.org/html/draft-pironti-tls-length-hiding-02">length hiding
policies</a>. This is tracked as <a href="https://github.com/mirleft/ocaml-tls/issues/162">issue 162</a>.</p>
<p><strong>Version rollback</strong></p>
<p>SSL-2.0 is insecure, a man in the middle can downgrade the version to
SSL-2.0. The mitigation we implement is that we do not support
SSL-2.0, and thus cannot be downgraded. Also, we check that the
version of the client hello matches the first two bytes in the
premaster secret <a href="https://github.com/mirleft/ocaml-tls/blob/c06cbaaffe49024d8570916b70f7839603a54692/lib/handshake_server.ml#L55">here</a>. You can find further discussion in
<a href="https://github.com/mirleft/ocaml-tls/issues/5">issue 5</a>.</p>
<p><strong>Triple handshake</strong></p>
<p>A vulnerability including session resumption and renegotiation was
discovered by the <a href="http://www.mitls.org">miTLS team</a>, named <a href="https://secure-resumption.com/">triple
handshake</a>.  Mitigations include disallowing renegotiation,
disallowing modification of the certificate during renegotiation, or
a hello extension. Since we do not support session resumption yet, we
have not yet implemented any of the mentioned mitigations. There is
further discussion in <a href="https://github.com/mirleft/ocaml-tls/issues/9">issue 9</a>.</p>
<p><strong>Alert attack</strong></p>
<p>A <a href="http://www.mitls.org/wsgi/alert-attack">fragment of an alert</a> can be sent by a man in the
middle during the initial handshake. If the fragment is not cleared
once the handshake is finished, the authentication of alerts is
broken. This was discovered in 2012; our mitigation is to discard
fragmented alerts.</p>
<h3>EOF.</h3>
<p>Within six months, two hackers managed to develop a clean-slate TLS
stack, together with required crypto primitives, ASN.1, and X.509
handling, in a high-level pure language. We interoperate with widely
deployed TLS stacks, as shown by our <a href="https://tls.nqsb.io">demo server</a>.  The code
size is nearly two orders of magnitude smaller than OpenSSL, the most
widely used open source library (written in C, which a lot of
programming languages wrap instead of providing their own TLS
implementation). Our code base seems to be robust -- the <a href="https://tls.nqsb.io">demo
server</a> successfully finished over 22500 sessions in less than a
week, with only 11 failing traces.</p>
<p>There is a huge need for high quality TLS implementations, because
several TLS implementations suffered this year from severe security
problems, such as <a href="https://en.wikipedia.org/wiki/Heartbleed">heartbleed</a>, <a href="https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2014-1266">goto fail</a>, <a href="https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2014-3466">session
id</a>, <a href="http://armoredbarista.blogspot.de/2014/04/easter-hack-even-more-critical-bugs-in.html">Bleichenbacher</a>, <a href="https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2014-0224">change cipher
suite</a> and <a href="https://polarssl.org/tech-updates/security-advisories/polarssl-security-advisory-2014-02">GCM DoS</a>. The main cause is
implementation complexity due to lack of abstraction, and memory
safety issues.</p>
<p>We still need to address some security issues, and improve our performance. We
invite people to do rigorous code audits (both manual and automated) and try
testing our code in their services.</p>
<p><strong>Please be aware that this release is a <em>beta</em> and is missing external code audits.
It is not yet intended for use in any security critical applications.</strong></p>
<h3>Acknowledgements</h3>
<p>Since this is the final post in our series, we would like to thank all
people who reported issues so far: <a href="http://anil.recoil.org/">Anil Madhavapeddy</a>, <a href="https://github.com/edwintorok">T&ouml;r&ouml;k
Edwin</a>, <a href="http://erratique.ch/">Daniel B&uuml;nzli</a>, <a href="http://blog.andreas.org/">Andreas Bogk</a>, <a href="http://gregorkopf.de/blog/">Gregor Kopf</a>, <a href="https://twitter.com/graham_steel">Graham
Steel</a>, <a href="https://github.com/vouillon">Jerome Vouillon</a>, <a href="http://amirchaudhry.com/">Amir Chaudhry</a>,
<a href="http://ashishagarwal.org">Ashish Agarwal</a>. Additionally, we want to thank the
<a href="http://www.mitls.org">miTLS</a> team (especially Cedric and Karthikeyan) for fruitful
discussions, as well as the <a href="http://www.cl.cam.ac.uk/projects/ocamllabs/">OCaml Labs</a> and
<a href="http://mirage.io">Mirage</a> teams. And thanks to <a href="http://www.cl.cam.ac.uk/~pes20/">Peter Sewell</a> and
<a href="http://www.cs.nott.ac.uk/~rmm/">Richard Mortier</a> for funding within the <a href="http://rems.io">REMS</a>, <a href="http://usercentricnetworking.eu/">UCN</a>, and <a href="http://www.horizon.ac.uk">Horizon</a>
projects. The software was started in <a href="http://www.aftasmirleft.com/">Aftas beach house</a> in
Mirleft, Morocco.</p>
<img src="https://mirage.io/graphics/aftas-mirleft.jpg" alt="Aftas Beach"/>
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

      

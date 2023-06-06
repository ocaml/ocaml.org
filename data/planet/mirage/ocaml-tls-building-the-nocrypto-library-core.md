---
title: 'OCaml-TLS: building the nocrypto library core'
description:
url: https://mirage.io/blog/introducing-nocrypto
date: 2014-07-09T00:00:00-00:00
preview_image:
featured:
authors:
- David Kaloper
---


        <p><em>This is the second in a series of posts that introduce new libraries for a pure OCaml implementation of TLS.
You might like to begin with the <a href="https://mirage.io/blog/introducing-ocaml-tls">introduction</a>.</em></p>
<h3>What is nocrypto?</h3>
<p><a href="https://github.com/mirleft/ocaml-nocrypto">nocrypto</a> is the small cryptographic library behind the
<a href="https://github.com/mirleft/ocaml-tls">ocaml-tls</a> project. It is built to be straightforward to use, adhere to
functional programming principles and able to run in a Xen-based unikernel.
Its major use-case is <code>ocaml-tls</code>, which we <a href="https://mirage.io/blog/introducing-ocaml-tls">announced yesterday</a>, but we do intend to provide
sufficient features for it to be more widely applicable.</p>
<p>&quot;Wait, you mean you wrote your own <em>crypto library</em>?&quot;</p>
<h3>&quot;Never write your own crypto&quot;</h3>
<p>Everybody seems to recognize that cryptography is horribly difficult. Building
cryptography, it is all too easy to fall off the deep end and end up needing to
make decisions only a few, select specialists can make. Worse, any mistake is
difficult to uncover but completely compromises the security of the system. Or
in Bruce Schneier's <a href="https://www.schneier.com/essays/archives/1998/01/security_pitfalls_in.html">words</a>:</p>
<blockquote>
<p>Building a secure cryptographic system is easy to do badly, and very difficult
to do well. Unfortunately, most people can't tell the difference. In other
areas of computer science, functionality serves to differentiate the good from
the bad: a good compression algorithm will work better than a bad one; a bad
compression program will look worse in feature-comparison charts. Cryptography
is different. Just because an encryption program works doesn't mean it is
secure.</p>
</blockquote>
<p>Obviously, it would be far wiser not to attempt to do this and instead reuse
good, proven work done by others. And with the wealth of free cryptographic
libraries around, one gets to take their pick.</p>
<p>So to begin with, we turned to <a href="https://forge.ocamlcore.org/projects/cryptokit/">cryptokit</a>, the more-or-less
standard cryptographic library in the OCaml world. It has a decent coverage of
the basics: some stream ciphers (ARC4), some block ciphers (AES, 3DES and
Blowfish) the core hashes (MD5, SHA, the SHA2 family and RIPEMD) and the
public-key primitives (Diffie-Hellman and RSA). It is also designed with
composability in mind, exposing various elements as stream-transforming objects
that can be combined on top of one another.</p>
<p>Unfortunately, its API was a little difficult to use. Suppose you have a secret
key, an IV and want to use AES-128 in CBC mode to encrypt a bit of data. You do
it like this:</p>
<pre><code class="language-OCaml">let key = &quot;abcd1234abcd1234&quot;
and iv  = &quot;1234abcd1234abcd&quot;
and msg = &quot;fire the missile&quot;

let aes     = new Cryptokit.Block.aes_encrypt key
let aes_cbc = new Cryptokit.Block.cbc_encrypt ~iv aes

let cip =
  let size =
    int_of_float (ceil (float String.(length msg) /. 16.) *. 16.) in
  String.create size

let () = aes_cbc#transform msg 0 cip 0
</code></pre>
<p>At this point, <code>cip</code> contains our secret message. This being CBC, both <code>msg</code> and
the string the output will be written into (<code>cip</code>) need to have a size that is a
multiple of the underlying block size. If they do not, bad things will
happen -- silently.</p>
<p>There is also the curious case of hashing-object states:</p>
<pre><code class="language-OCaml">let md5 = Cryptokit.Hash.md5 ()

let s1 = Cryptokit.hash_string md5 &quot;bacon&quot;
let s2 = Cryptokit.hash_string md5 &quot;bacon&quot;
let s3 = Cryptokit.hash_string md5 &quot;bacon&quot;

(*
  s1 = &quot;x\\019%\\142\\248\\198\\1822\\221\\232\\204\\128\\246\\189\\166/&quot;
  s2 = &quot;'\\\\F\\017\\234\\172\\196\\024\\142\\255\\161\\145o\\142\\128\\197&quot;
  s3 = &quot;'\\\\F\\017\\234\\172\\196\\024\\142\\255\\161\\145o\\142\\128\\197&quot;
*)
</code></pre>
<p>The error here is to try and carry a single instantiated hashing object around,
while trying to get hashes of distinct strings. But with the convergence after
the second step, the semantics of the hashing object still remains unclear to
us.</p>
<p>One can fairly easily overcome the API style mismatches by making a few
specialized wrappers, of course, except for two major problems:</p>
<ul>
<li>
<p>Cryptokit is pervasively stateful. While this is almost certainly a result of
performance considerations combined with its goals of ease of
compositionality, it directly clashes with the fundamental design property of
the TLS library we wanted to use it in: our <code>ocaml-tls</code> library is stateless. We need to
be able to represent the state the encryption engine is in as a value.</p>
</li>
<li>
<p>Cryptokit operates on strings. As a primary target of <code>ocaml-tls</code> was
<a href="https://mirage.io/">Mirage</a>, and Mirage uses separate, non-managed regions of memory to
store network data in, we need to be able to handle foreign-allocated
storage. This means <code>Bigarray</code> (as exposed by <code>Cstruct</code>), and it seems just
plain wrong to negate all the careful zero-copy architecture of the stack
below by copying everything into and out of strings.</p>
</li>
</ul>
<p>There are further problems. For example, Cryptokit makes no attempts to combat
well-known timing vulnerabilities. It has no support for elliptic curves. And it
depends on the system-provided random number generator, which does not exist
when running in the context of a unikernel.</p>
<p>At this point, with the <em>de facto</em> choice off the table, it's probably worth
thinking about writing OCaml bindings to a rock-solid cryptographic library
written in C.</p>
<p><a href="http://nacl.cr.yp.to/">NaCl</a> is a modern, well-regarded crypto implementation, created by a
group of pretty famous and equally well-regarded cryptographers, and was the
first choice. Or at least its more approachable and packageable <a href="http://labs.opendns.com/2013/03/06/announcing-sodium-a-new-cryptographic-library/">fork</a>
was, which already had <a href="https://github.com/dsheets/ocaml-sodium">OCaml bindings</a>. Unfortunately, <code>NaCl</code>
provides a narrow selection of implementations of various cryptographic
primitives, the ones its authors thought were best-of-breed (for example, the
only symmetric ciphers it implements are (X-)Salsa and AES in CTR mode). And
they are probably right (in some aspects they are <em>certainly</em> right), but NaCl
is best used for implementations of newly-designed security protocols. It is
simply too opinionated to support an old, standardized behemoth like TLS.</p>
<p>Then there is <a href="https://www.openssl.org/docs/crypto/crypto.html">crypto</a>, the library OpenSSL is built on top of. It
is quite famous and provides optimized implementations of a wide range of
cryptographic algorithms. It also contains upwards of 200,000 lines of C and a
very large API footprint, and it's unclear whether it would be possible to run
it in the unikernel context. Recently, the parent project it is embedded in has
become highly suspect, with one high-profile vulnerability piling on top of
another and at least <a href="http://www.libressl.org/">two</a> <a href="https://boringssl.googlesource.com/boringssl/">forks</a> so far attempting to
clean the code base. It just didn't feel like a healthy code base to build
a new project on.</p>
<p>There are other free cryptographic libraries in C one could try to bind, but at
a certain point we faced the question: is the work required to become intimately
familiar with the nuances and the API of an existing code base, and create
bindings for it in OCaml, really that much smaller than writing one from
scratch? When using a full library one commits to its security decisions and
starts depending on its authors' time to keep it up to date -- maybe this
effort is better spent in writing one in the first place.</p>
<p>Tantalizingly, the length of the single OCaml source file in <code>Cryptokit</code> is
2260 lines.</p>
<p>Maybe if we made <strong>zero</strong> decisions ourselves, informed all our work by published
literature and research, and wrote the bare minimum of code needed, it might not
even be dead-wrong to do it ourselves?</p>
<p>And that is the basic design principle. Do nothing fancy. Do only documented
things. Don't write too much code. Keep up to date with security research. Open
up and ask people.</p>
<h3>The anatomy of a simple crypto library</h3>
<p><code>nocrypto</code> uses bits of C, similarly to other cryptographic libraries written in
high-level languages.</p>
<p>This was actually less of a performance concern, and more of a security one: for
the low-level primitives which are tricky to implement and for which known,
compact and widely used code already exists, the implementation is probably
better reused. The major pitfall we hoped to avoid that way are side-channel
attacks.</p>
<p>We use public domain (or BSD licenced) <a href="https://github.com/mirleft/ocaml-nocrypto/tree/master/src/native">C sources</a> for the
simple cores of AES, 3DES, MD5, SHA and SHA2. The impact of errors in this code
is constrained: they contain no recursion, and they perform no allocation,
simply filling in caller-supplied fixed-size buffer by appropriate bytes.</p>
<p>The block implementations in C have a simple API that requires us to provide the
input and output buffers and a key, writing the single encrypted (or decrypted)
block of data into the buffer. Like this:</p>
<pre><code class="language-C">void rijndaelEncrypt(const unsigned long *rk, int nrounds,
  const unsigned char plaintext[16], unsigned char ciphertext[16]);

void rijndaelDecrypt(const unsigned long *rk, int nrounds,
  const unsigned char ciphertext[16], unsigned char plaintext[16]);
</code></pre>
<p>The hashes can initialize a provided buffer to serve as an empty accumulator,
hash a single chunk of data into that buffer and convert its contents into a
digest, which is written into a provided fixed buffer.</p>
<p>In other words, all the memory management happens exclusively in OCaml and all
the buffers passed into the C layer are tracked by the garbage collector (GC).</p>
<h3>Symmetric ciphers</h3>
<p>So far, the only provided ciphers are AES, 3DES and ARC4, with ARC4 implemented
purely in OCaml (and provided only for TLS compatibility and for testing).</p>
<p>AES and 3DES are based on core C code, on top of which we built some standard
<a href="https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation">modes of operation</a> in OCaml. At the moment we support ECB, CBC
and CTR. There is also a nascent <a href="https://en.wikipedia.org/wiki/Galois/Counter_Mode">GCM</a> implementation which is, at the time
of writing, known not to be optimal and possibly prone to timing attacks, and
which we are still working on.</p>
<p>The exposed API strives to be simple and value-oriented. Each mode of each
cipher is packaged up as a module with a similar signature, with a pair of
functions for encryption and decryption. Each of those essentially takes a key
and a byte buffer and yields the resulting byte buffer, minimising hassle.</p>
<p>This is how you encrypt a message:</p>
<pre><code class="language-OCaml">open Nocrypto.Block

let key = AES.CBC.of_secret Cstruct.(of_string &quot;abcd1234abcd1234&quot;)
and iv  = Cstruct.of_string &quot;1234abcd1234abcd&quot;
and msg = Cstruct.of_string &quot;fire the missile&quot;

let { AES.CBC.message ; iv } = AES.CBC.encrypt ~key ~iv msg
</code></pre>
<p>The hashes implemented are just MD5, SHA and the SHA2 family. Mirroring the
block ciphers, they are based on C cores, with the HMAC construction provided in
OCaml. The API is similarly simple: each hash is a separate module with the same
signature, providing a function that takes a byte buffer to its digest, together
with several stateful operations for incremental computation of digests.</p>
<p>Of special note is that our current set of C sources will probably soon be
replaced. AES uses code that is vulnerable to a <a href="http://cr.yp.to/antiforgery/cachetiming-20050414.pdf">timing attack</a>,
stemming from the fact that substitution tables are loaded into the CPU cache
as-needed. The code does not take advantage of the <a href="https://en.wikipedia.org/wiki/AES_instruction_set">AES-NI</a>
instructions present in modern CPUs that allow AES to be hardware-assisted. SHA
and SHA2 cores turned out to be (comparatively) ill-performing, and static
analysis already uncovered some potential memory issues, so we are looking for
better implementations.</p>
<h3>Public-key cryptography</h3>
<p>Bignum arithmetic is provided by the excellent <a href="https://forge.ocamlcore.org/projects/zarith">zarith</a> library, which
in turn uses <a href="https://gmplib.org/">GMP</a>. This might create some portability problems later on,
but as GMP is widely used and well rounded code base which also includes some of
the needed auxiliary number-theoretical functions (its slightly extended
Miller-Rabin probabilistic primality test and the fast next-prime-scanning
function), it seemed like a much saner choice than redoing it from scratch.</p>
<p>The <a href="https://github.com/mirleft/ocaml-nocrypto/blob/a52bba2dcaf1c5fd45249588254dff2722e9f960/src/rsa.mli">RSA</a> module provides the basics: raw encryption and decryption,
<a href="https://en.wikipedia.org/wiki/PKCS_1">PKCS1</a>-padded versions of the same operations, and PKCS1 signing and
signature verification. It can generate RSA keys, which it does simply by
finding two large primes, in line with <a href="http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.310.4183">Rivest's</a> own
recommendation.</p>
<p>Notably, RSA implements the standard <a href="https://en.wikipedia.org/wiki/Blinding_(cryptography)">blinding</a> technique which can mitigate
some side-channel attacks, such as timing or <a href="http://www.cs.tau.ac.il/~tromer/acoustic/">acoustic</a>
cryptanalysis. It seems to foil even stronger, <a href="http://eprint.iacr.org/2013/448.pdf">cache eviction</a>
based attacks, but as of now, we are not yet completely sure.</p>
<p>The <a href="https://github.com/mirleft/ocaml-nocrypto/blob/a52bba2dcaf1c5fd45249588254dff2722e9f960/src/dh.mli">Diffie-Hellman</a> module is also relatively basic. We implement some
<a href="http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.56.1921">widely</a> <a href="http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.21.639">recommended</a> checks on the incoming public key to
mitigate some possible MITM attacks, the module can generate strong DH groups
(using safe primes) with guaranteed large prime-order subgroup, and we provide
a catalogue of published DH groups ready for use.</p>
<h3>Randomness</h3>
<p>Random number generation used to be a chronically overlooked part of
cryptographic libraries, so much so that nowadays one of the first questions
about a crypto library is, indeed, &quot;Where does it get randomness from?&quot;</p>
<p>It's an important question. A cryptographic system needs unpredictability in
many places, and violating this causes catastrophic <a href="https://www.debian.org/security/2008/dsa-1571">failures</a>.</p>
<p><code>nocrypto</code> contains its own implementation of <a href="https://www.schneier.com/fortuna.html">Fortuna</a>. Like
<a href="https://www.schneier.com/yarrow.html">Yarrow</a>, Fortuna uses a strong block cipher in CTR mode (AES in our
case) to produce the pseudo-random stream, a technique that is considered as
unbreakable as the underlying cipher.</p>
<p>The stream is both self-rekeyed, and rekeyed with the entropy gathered into its
accumulator pool. Unlike the earlier designs, however, Fortuna is built without
entropy estimators, which usually help the PRNG decide when to actually convert
the contents of an entropy pool into the new internal state. Instead, Fortuna
uses a design where the pools are fed round-robin, but activated with an
exponential backoff. There is <a href="https://eprint.iacr.org/2014/167">recent research</a> showing this
design is essentially sound: after a state compromise, Fortuna wastes no more
than a constant factor of incoming entropy -- whatever the amount of entropy is
-- before coming back to an unpredictable state. The resulting design is both
simple, and robust in terms of its usage of environmental entropy.</p>
<p>The above paper also suggests a slight improvement to the accumulator regime,
yielding a factor-of-2 improvement in entropy usage over the original. We still
haven't implemented this, but certainly intend to.</p>
<p>A PRNG needs to be fed with some actual entropy to be able to produce
unpredictable streams. The library itself contains no provisions for doing this
and its PRNG needs to be fed by the user before any output can be produced. We
are <a href="https://github.com/mirage/mirage-entropy">working with the Mirage team</a> on exposing environmental
entropy sources and connecting them to our implementation of Fortuna.</p>
<h3>Above &amp; beyond</h3>
<p><code>nocrypto</code> is still very small, providing the bare minimum cryptographic
services to support TLS and related X.509 certificate operations. One of the
goals is to flesh it out a bit, adding some more widely deployed algorithms, in
hopes of making it more broadly usable.</p>
<p>There are several specific problems with the library at this stage:</p>
<p><strong>C code</strong> - As mentioned, we are seeking to replace some of the C code we use. The hash
cores are underperforming by about a factor of 2 compared to some other
implementations. AES implementation is on one hand vulnerable to a timing attack
and, on the other hand, we'd like to make use of hardware acceleration for this
workhorse primitive -- without it we lose about an order of magnitude of
performance.</p>
<p>Several options were explored, ranging from looking into the murky waters of
OpenSSL and trying to exploit their heavily optimized primitives, to bringing
AES-NI into OCaml and redoing AES in OCaml. At this point, it is not clear which
path we'll take.</p>
<p><strong>ECC</strong> - Looking further, the library still lacks support for elliptic curve cryptography
and we have several options for solving this. Since it is used by TLS, ECC is
probably the missing feature we will concentrate on first.</p>
<p><strong>Entropy on Xen</strong> - The entropy gathering on Xen is incomplete. The current prototype uses current
time as the random seed and the effort to expose noisier sources like interrupt
timings and the RNG from dom0's kernel is still ongoing.  Dave Scott, for example, has
<a href="http://lists.xen.org/archives/html/xen-devel/2014-06/msg01492.html">submitted patches</a> to upstream Xen to make it easier to establish low-bandwidth
channels to supplies guest VMs with strong entropy from a privileged domain
that has access to physical devices and hence high-quality entropy sources.</p>
<p><strong>GC timing attacks?</strong> - There is the question of GC and timing attacks: whether doing
cryptography in a high-level language opens up a completely new surface for
timing attacks, given that GC runs are very visible in the timing profile. The
basic approach is to leave the core routines which we know are potentially
timing-sensitive (like AES) and for which we don't have explicit timing
mitigations (like RSA) to C, and invoke them atomically from the perspective of
the GC. So far, it's an open question whether the constructions built on top
of them expose further side-channels.</p>
<p>Still, we believe that the whole package is a pleasant library to work with. Its
simplicity contributes to the comparative simplicity of the entire TLS library,
and we are actively seeking input on areas that need further improvement.
Although we are obviously biased, we believe it is the best cryptographic base
library available for this project, and it might be equally suited for your next
project too!</p>
<p>We are striving to be open about the current security status of our code. You
are free to check out our <a href="https://github.com/mirleft/ocaml-nocrypto/issues?state=open">issue tracker</a> and invited to contribute
comments, ideas, and especially audits and code.</p>
<hr/>
<p>Posts in this TLS series:</p>
<ul>
<li><a href="https://mirage.io/blog/introducing-ocaml-tls">Introducing transport layer security (TLS) in pure OCaml</a>
</li>
<li><a href="https://mirage.io/blog/introducing-nocrypto">OCaml-TLS: building the nocrypto library core</a>
</li>
<li><a href="https://mirage.io/blog/introducing-x509">OCaml-TLS: adventures in X.509 certificate parsing and validation</a>
</li>
<li><a href="https://mirage.io/blog/introducing-asn1">OCaml-TLS: ASN.1 and notation embedding</a>
</li>
<li><a href="https://mirage.io/blog/ocaml-tls-api-internals-attacks-mitigation">OCaml-TLS: the protocol implementation and mitigations to known attacks</a>
</li>
</ul>

      

---
title: 'An Introduction to Tezos RPCs: Signing Operations'
description: 'In a previous blogpost, we presented the RPCs used by tezos-client to
  send a transfer operation to a tezos-node. We were left with two remaining questions:
  How to forge a binary operation, for signature

  How to sign a binary operation In this post, we will reply to these questions. We
  are still assum...'
url: https://ocamlpro.com/blog/2018_11_21_an_introduction_to_tezos_rpcs_signing_operations
date: 2018-11-21T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Fabrice Le Fessant\n  "
source:
---

<p>In a <a href="http://ocamlpro.com/2018/11/15/an-introduction-to-tezos-rpcs-a-basic-wallet/">previous blogpost</a>,
we presented the RPCs used by tezos-client to send a transfer
operation to a tezos-node. We were left with two remaining questions:</p>
<ul>
<li>
<p>How to forge a binary operation, for signature</p>
</li>
<li>
<p>How to sign a binary operation</p>
</li>
</ul>
<p>In this post, we will reply to these questions. We are still assuming
a node running and waiting for RPCs on address 127.0.0.1:9731. Since
we will ask this node to forge a request, we really need to trust it,
as a malicious node could send a different binary transaction from the
one we sent him.</p>
<p>Let&rsquo;s take back our first operation:</p>
<pre><code class="language-json">{
  &quot;branch&quot;: &quot;BMHBtAaUv59LipV1czwZ5iQkxEktPJDE7A9sYXPkPeRzbBasNY8&quot;,
  &quot;contents&quot;: [
    { &quot;kind&quot;: &quot;transaction&quot;,
      &quot;source&quot;: &quot;tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx&quot;,
      &quot;fee&quot;: &quot;50000&quot;,
      &quot;counter&quot;: &quot;3&quot;,
      &quot;gas_limit&quot;: &quot;200&quot;,
      &quot;storage_limit&quot;: &quot;0&quot;,
      &quot;amount&quot;: &quot;100000000&quot;,
      &quot;destination&quot;: &quot;tz1gjaF81ZRRvdzjobyfVNsAeSC6PScjfQwN&quot;
   } ]
}
</code></pre>
<p>So, we need to translate this operation into a binary format, more
amenable for signature. For that, we use a new RPC to forge
operations. Under Linux, we can use the tool <code>curl</code> to send the
request to the node:</p>
<pre><code class="language-shell-session">$ curl -v -X POST http://127.0.0.1:9731/chains/main/blocks/head/helpers/forge/operations -H &quot;Content-type: application/json&quot; --data '{
  &quot;branch&quot;: &quot;BMHBtAaUv59LipV1czwZ5iQkxEktPJDE7A9sYXPkPeRzbBasNY8&quot;,
  &quot;contents&quot;: [
    { &quot;kind&quot;: &quot;transaction&quot;,
      &quot;source&quot;: &quot;tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx&quot;,
      &quot;fee&quot;: &quot;50000&quot;,
      &quot;counter&quot;: &quot;3&quot;,
      &quot;gas_limit&quot;: &quot;200&quot;,
      &quot;storage_limit&quot;: &quot;0&quot;,
      &quot;amount&quot;: &quot;100000000&quot;,
      &quot;destination&quot;: &quot;tz1gjaF81ZRRvdzjobyfVNsAeSC6PScjfQwN&quot;
  } ]
}'
</code></pre>
<p>Note that we use a POST request (request with content), with a
<code>Content-type</code> header indicating that the content is in JSON format. We
get the following body in the reply :</p>
<pre><code class="language-json">&quot;ce69c5713dac3537254e7be59759cf59c15abd530d10501ccf9028a5786314cf08000002298c03ed7d454a101eb7022bc95f7e5f41ac78d0860303c8010080c2d72f0000e7670f32038107a59a2b9cfefae36ea21f5aa63c00&quot;
</code></pre>
<p>This is the binary representation of our operation, in hexadecimal
format, exactly what we were looking for to be able to include
operations on the blockchain. However, this representation is not yet
complete, since we also need the operation to be signed by the
manager.</p>
<p>To sign this operation, we will first use <code>tezos-client</code>. That&rsquo;s
something that we can do if we want, for example, to sign an operation
offline, for better security. Let&rsquo;s assume that we have saved the
content of the string (<code>ce69...3c00</code> without the quotes) in a file
<code>operation.hex</code>, we can ask <code>tezos-client</code> to sign it with:</p>
<pre><code class="language-shell-session">$ tezos-client --addr 127.0.0.1 --port 9731 sign bytes 0x03$(cat operation.hex) for bootstrap1
</code></pre>
<p>The <code>0x03$(cat operation.hex)</code> is the concatenation of the <code>0x03</code>
prefix and the hexa content of the <code>operation.hex</code>, which is equivalent
to <code>0x03ce69...3c00</code>. The prefix is used (1) to indicate that the
representation is hexadecimal (<code>0x</code>), and (2) that it should start with
<code>03</code>, which is a watermark for operations in Tezos.</p>
<p>We get the following reply in the console:</p>
<pre><code class="language-shell-session">Signature: edsigtkpiSSschcaCt9pUVrpNPf7TTcgvgDEDD6NCEHMy8NNQJCGnMfLZzYoQj74yLjo9wx6MPVV29CvVzgi7qEcEUok3k7AuMg
</code></pre>
<p>Wonderful, we have a signature, in <code>base58check</code> format ! We can use
this signature in the <code>run_operation</code> and <code>preapply</code> RPCs&hellip; but not in
the <code>injection</code> RPC, which requires a binary format. So, to inject the
operation, we need to convert to the hexadecimal version of the
signature. For that, we will use the <code>base58check</code> package of Python
(we could do it in OCaml, but then, we could just use <code>tezos-client</code>
all along, no ?):</p>
<pre><code class="language-shell-session">$ pip3 install base58check
$ python
&gt;&gt;&gt;import base58check
&gt;&gt;&gt;base58check.b58decode(b'edsigtkpiSSschcaCt9pUVrpNPf7TTcgvgDEDD6NCEHMy8NNQJCGnMfLZzYoQj74yLjo9wx6MPVV29CvVzgi7qEcEUok3k7AuMg').hex()
'09f5cd8612637e08251cae646a42e6eb8bea86ece5256cf777c52bc474b73ec476ee1d70e84c6ba21276d41bc212e4d878615f4a31323d39959e07539bc066b84174a8ff0de436e3a7'
</code></pre>
<p>All signatures in Tezos start with <code>09f5cd8612</code>, which is used to
generate the <code>edsig</code> prefix. Also, the last 4 bytes are used as a
checksum (<code>e436e3a7</code>). Thus, the signature itself is after this prefix
and before the checksum: <code>637e08251cae64...174a8ff0d</code>.</p>
<p>Finally, we just need to append the binary operation with the binary
signature for the injection, and put them into a string, and send that
to the server for injection. If we have stored the hexadecimal
representation of the signature in a file <code>signature.hex</code>, then we can
use :</p>
<pre><code class="language-shell-session">$ curl -v -H &quot;Content-type: application/json&quot; 'http://127.0.0.1:9731/injection/operation?chain=main' --data '&quot;'$(cat operation.hex)$(cat signature.hex)'&quot;'
</code></pre>
<p>and we receive the hash of this new operation:</p>
<pre><code class="language-json">&quot;oo1iWZDczV8vw3XLunBPW6A4cjmdekYTVpRxRh77Fd1BVv4HV2R&quot;
</code></pre>
<p>Again, we cheated a little, by using <code>tezos-client</code> to generate the
signature. Let&rsquo;s try to do it in Python, too !</p>
<p>First, we will need the secret key of bootstrap1. We can export from
<code>tezos-client</code> to use it directly:</p>
<pre><code class="language-shell-session">$ tezos-client show address bootstrap1 -S
Hash: tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx
Public Key: edpkuBknW28nW72KG6RoHtYW7p12T6GKc7nAbwYX5m8Wd9sDVC9yav
Secret Key: unencrypted:edsk3gUfUPyBSfrS9CCgmCiQsTCHGkviBDusMxDJstFtojtc1zcpsh
</code></pre>
<p>The secret key is exported on the last line by using the <code>-S</code>
argument, and it usually starts with <code>edsk</code>. Again, it is in
<code>base58check</code>, so we can use the same trick to extract its binary
value:</p>
<pre><code class="language-shell-session">$ python3
&gt;&gt;&gt; import base58check
&gt;&gt;&gt; base58check.b58decode(b'edsk3gUfUPyBSfrS9CCgmCiQsTCHGkviBDusMxDJstFtojtc1zcpsh').hex()[8:72]
'8500c86780141917fcd8ac6a54a43a9eeda1aba9d263ce5dec5a1d0e5df1e598'
</code></pre>
<p>This time, we directly extracted the key, by removing the first 8 hexa
chars, and keeping only 64 hexa chars (using <code>[8:72]</code>), since the key
is 32-bytes long. Let&rsquo;s suppose that we save this value in a file
<code>bootstrap1.hex</code>.</p>
<p>Now, we will use the following script to compute the signature:</p>
<pre><code class="language-python">import binascii

operation=binascii.unhexlify(open(&quot;operation.hex&quot;,&quot;rb&quot;).readline()[:-1])
seed = binascii.unhexlify(open(&quot;bootstrap1.hex&quot;,&quot;rb&quot;).readline()[:-1])

from pyblake2 import blake2b
h = blake2b(digest_size=32)
h.update(b'x03' + operation)
digest = h.digest()

import ed25519
sk = ed25519.SigningKey(seed)
sig = sk.sign(digest)
print(sig.hex())
</code></pre>
<p>The <code>binascii</code> module is used to read the files in hexadecimal (after
removing the newlines), to get the binary representation of the
operation and of the Ed25519 seed. Ed25519 is an elliptive curve used
in Tezos to manage <code>tz1</code> addresses, i.e. to sign data and check
signatures.</p>
<p>The <code>blake2b</code> module is used to hash the message, before
signature. Again, we add a watermark to the operation, i.e. <code>x03</code>,
before hashing. We also have to specify the size of the hash,
i.e. <code>digest_size=32</code>, because the Blake2b hashing function can generate
hashes with different sizes.</p>
<p>Finally, we use the ed25519 module to transform the seed
(private/secret key) into a signing key, and use it to sign the hash,
that we print in hexadecimal. We obtain:</p>
<pre><code class="language-json">637e08251cae646a42e6eb8bea86ece5256cf777c52bc474b73ec476ee1d70e84c6ba21276d41bc212e4d878615f4a31323d39959e07539bc066b84174a8ff0d
</code></pre>
<p>This result is exactly the same as what we got using tezos-client !</p>
<p><img src="https://ocamlpro.com/blog/assets/img/SignTransaction-791x1024.jpg" alt="SignTransaction-791x1024.jpg"/></p>
<p>We now have a complete wallet, i.e. the ability to create transactions
and sign them without tezos-client. Of course, there are several
limitations to this work: first, we have exposed the private key in
clear, which is usually not a very good idea for security; also, Tezos
supports three types of keys, <code>tz1</code> for Ed25519 keys, <code>tz2</code> for
Secp256k1 keys (same as Bitcoin/Ethereum) and <code>tz3</code> for P256 keys;
finally, a realistic wallet would probably use cryptographic chips, on
a mobile phone or an external device (Ledger, etc.).</p>
<h1>Comments</h1>
<p>Anthony (28 November 2018 at 2 h 01 min):</p>
<blockquote>
<p>Fabrice, you talk about signing the operation using tezos-client, which can then be used with the run_operation, however when . you talk about doing it in a script, it doesn&rsquo;t include the edsig or checksum or converted back into a usable form for run_operations. Can you explain how this is done in a script?</p>
<p>Thanks
Anthony</p>
</blockquote>
<p>Fabrice Le Fessant (29 November 2018 at 15 h 07 min):</p>
<blockquote>
<p>You are right, <code>run_operation</code> needs an <code>edsig</code> signature, not the hexadecimal encoding. To generate the <code>edsig</code>, you just need to use the reverse operation of <code>base58check.b58decode</code>, i.e. <code>base58check.b58encode</code>, on the concatenation of 3 byte arrays:</p>
<p>1/ the 5-bytes prefix that will generate the initial <code>edsig</code> characters, i.e. <code>0x09f5cd8612</code> in hexadecimal
2/ the raw signature <code>s</code>
3/ the 4 initial bytes of a checksum: the checksum is computed as <code>sha256(sha256(s))</code></p>
</blockquote>
<p>Badalona (27 December 2018 at 13 h 13 min):</p>
<blockquote>
<p>Hi Fabrice.</p>
<p>I will aprreciate if you show the coding of step 3. My checksum is always wrong.</p>
<p>Thanks</p>
</blockquote>
<p>Alain (16 January 2019 at 16 h 26 min):</p>
<blockquote>
<p>The checksum is on prefix + s.
Here is a python3 script to do it:</p>
<p>./hex2edsig.py 637e08251cae646a42e6eb8bea86ece5256cf777c52bc474b73ec476ee1d70e84c6ba21276d41bc212e4d878615f4a31323d39959e07539bc066b84174a8ff0dedsigtkpiSSschcaCt9pUVrpNPf7TTcgvgDEDD6NCEHMy8NNQJCGnMfLZzYoQj74yLjo9wx6MPVV29CvVzgi7qEcEUok3k7AuMg</p>
</blockquote>
<pre><code class="language-python">from pyblake2 import blake2b
import hashlib
import base58check
import ed25519
import sys

def sha256 (x) :
    return hashlib.sha256(x).digest()

def b58check (prefix, b) :
    x = prefix + b
    checksum = sha256(sha256(x))[0:4]
    return base58check.b58encode(x + checksum)

edsig_prefix = bytes([9, 245, 205, 134, 18])

hexsig = sys.argv[1]
bytessig = bytes.fromhex(hexsig)
b58sig = b58check (edsig_prefix, bytessig)
print(b58sig.decode('ascii'))
</code></pre>
<p>Anthony (29 November 2018 at 21 h 49 min):</p>
<blockquote>
<p>Fabrice,
Thanks for the information would you be able to show the coding as you have done in your blog?
Thanks
Anthony</p>
</blockquote>
<p>Mark Robson (9 February 2020 at 23 h 51 min):</p>
<blockquote>
<p>Great information, but can the article be updated to include the things discussed in the comments? As I can&rsquo;t see the private key of bootstrap1 I can&rsquo;t replicate locally. Been going around in circles on that point</p>
</blockquote>
<p>stacey roberts (7 May 2020 at 13 h 53 min):</p>
<blockquote>
<p>Can you help me to clear about how tezos can support to build a fully decentralized supply chain eco system?</p>
</blockquote>
<p>leesadaisy (16 September 2020 at 10 h 25 min):</p>
<blockquote>
<p>Hi there! Thanks for sharing useful info. Keep up your work.</p>
</blockquote>
<p>Alice Jenifferze (17 September 2020 at 10 h 51 min):</p>
<blockquote>
<p>Thanks for sharing!</p>
</blockquote>


---
title: 'Signing Data for Smart Contracts '
description: Smart contracts calls already provide a built-in authentication mechanism
  as transactions (i.e. call operations) are cryptographically signed by the sender
  of the transaction. This is a guarantee on which programs can rely. However, sometimes
  you may want more involved or flexible authentication sch...
url: https://ocamlpro.com/blog/2019_03_05_signing_data_for_smart_contracts
date: 2019-03-05T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    \xC7agdas Bozman\n  "
source:
---

<p>Smart contracts calls already provide a built-in authentication mechanism as transactions (i.e. call operations) are cryptographically signed by the sender of the transaction. This is a guarantee on which programs can rely.</p>
<p>However, sometimes you may want more involved or flexible authentication schemes. The ones that rely on signature validity checking can be implemented in Michelson, and Liquidity provide a built-in instruction to do so. (You still need to keep in mind that you cannot store unencrypted confidential information on the blockchain).</p>
<p>This instruction is <code>Crypto.check</code> in Liquidity. Its type can be written as:</p>
<pre><code class="language-ocaml">Crypto.check: key -&gt; signature -&gt; bytes -&gt; bool
</code></pre>
<p>Which means that it takes as arguments a public key, a signature and a sequence of bytes and returns a Boolean. <code>Crypto.check pub_key signature message</code> is <code>true</code> if and only if the signature <code>signature</code> was obtained by signing the Blake2b hash of <code>message</code> using the private key corresponding to the public key <code>pub_key</code>.</p>
<p>A small smart contract snippet which implements a signature check (against a predefined public key kept in the smart contract's storage) <a href="https://liquidity-lang.org/edit?source=type%20storage%20=%20key%0A%0Alet%25entry%20main%20((message%20:%20string)%2C%20(signature%20:%20signature))%20key%20=%0A%20%20let%20bytes%20=%20Bytes.pack%20message%20in%0A%20%20if%20not%20(Crypto.check%20key%20signature%20bytes)%20then%0A%20%20%20%20failwith%20%22Wrong%20signature%22%3B%0A%20%20(%5B%5D%20:%20operation%20list)%2C%20key%0A">can be tested online here.</a></p>
<pre><code class="language-ocaml">type storage = key

let%entry main ((message : string), (signature : signature)) key =
  let bytes = Bytes.pack message in
  if not (Crypto.check key signature bytes) then
    failwith &quot;Wrong signature&quot;;
  ([] : operation list), key
</code></pre>
<p>This smart contract fails if the string <code>message</code> was not signed with the private key corresponding to the public key <code>key</code> stored. Otherwise it does nothing.</p>
<p>This signature scheme is more flexible than the default transaction/sender one, however it requires that the signature can be built outside of the smart contract. (And more generally outside of the toolset provided by Liquidity and Tezos). On the other hand, signing a transaction is something you get for free if you use the tezos client or any tezos wallet (as is it essentially their base function).</p>
<p>The rest of this blog post will focus on various ways to sign data, and on getting signatures that can be used in Tezos and Liquidity directly.</p>
<h3>Signing Using the Tezos Client</h3>
<p>One (straightforward) way to sign data is to use the Tezos client directly. You will need to be connected to a Tezos node though as the client makes RPCs to serialize data (this operation is protocol dependent). We can only sign sequences of bytes, so the first thing we need to do is to serialize whichever data we want to sign. This can be done with the command <code>hash data</code> of the client.</p>
<pre><code class="language-shell-session">$ ./tezos-client -A alphanet-node.tzscan.io -P 80 hash data '&quot;message&quot;' of type string
Raw packed data:
  0x0501000000076d657373616765
Hash:
  exprtXaZciTDGatZkoFEjE1GWPqbJ7FtqAWmmH36doxBreKr6ADcYs
Raw Blake2b hash:
  0x01978930fd2d04d0db8c2e4ef8a3f5d63b8e732177c8723135ed0dc7d99ebed3
Raw Sha256 hash:
  0x32569319f6517036949bcead23a761bfbfcbf4277b010355884a86ba09349839
Raw Sha512 hash:
  0xdfa4ea9f77db3a98654f101be1d33d56898df40acf7c2950ca6f742140668a67fefbefb22b592344922e1f66c381fa2bec48aa47970025c7e61e35d939ae3ca0
Gas remaining: 399918 units remaining
</code></pre>
<p>This command gives the result of hashing the data using various algorithms but what we're really interested in is the first item <code>Raw packed data</code> which is the serialized version of our data (<code>&quot;message&quot;</code>) : <code>0x0501000000076d657373616765</code>.</p>
<p>We can now sign these bytes using the Tezos client as well. This step can be performed completely offline, for that we need to use the option <code>-p</code> of the client to specify the protocol we want to use (the <code>sign bytes</code> command will not be available without first selecting a valid protocol). Here we use protocol 3, designated by its hash <code>PsddFKi3</code>.</p>
<pre><code class="language-shell-session">$ ./tezos-client -p PsddFKi3 sign bytes 0x0501000000076d657373616765 for my_account
Signature:
  edsigto9QHtXMyxFPyvaffRfFCrifkw2n5ZWqMxhGRzieksTo8AQAFgUjx7WRwqGPh4rXTBGGLpdmhskAaEauMrtM82T3tuxoi8
</code></pre>
<p>The account <code>my_account</code> can be any imported account in the Tezos client. In particular, it can be an encrypted key pair (you will need to enter a password to sign) or a hardware Ledger (you will need to confirm the signature on the Ledger). The obtained signature can be used as is with Liquidity or Michelson. This one starts with <code>edsig</code> because it was obtained using an Ed25519 private key, but you can also get signatures starting with <code>spsig1</code> or <code>p2sig</code> depending on the cryptographic curve that you use.</p>
<h3>Signing Manually</h3>
<p>In this second section we detail the necessary steps and provide a Python script to sign string messages using an Ed25519 private key. This can be easily adapted for other signing schemes.</p>
<p>These are the steps that will need to be performed in order to sign a string:</p>
<ul>
<li>Assuming that the value you want to sign is a string, you first need to convert its ASCII version to hexa, for the string <code>&quot;message&quot;</code> that is <code>6d657373616765</code>.
</li>
<li>You need to produce the packed version of the corresponding Michelson expression. The binary representation can vary depending on the types of the values you want to pack but for strings it is:
</li>
</ul>
<pre><code class="language-michelson">| 0x | 0501 | [size of the string on 4 bytes] | [ascii string in hexa] |
</code></pre>
<p>for <code>&quot;message&quot;</code> (of length 7), it is</p>
<pre><code class="language-michelson">| 0x | 0501 | 00000007 | 6d657373616765 |
</code></pre>
<p>or <code>0x0501000000076d657373616765</code>.</p>
<ul>
<li>Hash this value using <a href="https://en.wikipedia.org/wiki/BLAKE_(hash_function)">Blake2b</a> (<code>01978930fd2d04d0db8c2e4ef8a3f5d63b8e732177c8723135ed0dc7d99ebed3</code>) which is 32 bytes long.
</li>
<li>Depending on your public key, you then need to sign it with the corresponding curve (ed25519 for edpk keys), the signature is 64 bytes:
</li>
</ul>
<pre><code class="language-michelson">753e013b8515a7d47eaa5424de5efa2f56620ac8be29d08a6952ae414256eac44b8db71f74600275662c8b0c226f3280e9d24e70a5fa83015636b98059b5180c
</code></pre>
<ul>
<li>Optionally convert to base58check. This is not needed because Liquidity and Michelson allow signatures (as well as keys and key hashes) to be given in hex format with a 0x:
</li>
</ul>
<pre><code class="language-michelson">0x753e013b8515a7d47eaa5424de5efa2f56620ac8be29d08a6952ae414256eac44b8db71f74600275662c8b0c226f3280e9d24e70a5fa83015636b98059b5180c
</code></pre>
<p>The following Python (3) script will do exactly this, entirely offline. Note that this is just an toy example, and should not be used in production. In particular you need to give your private key on the command line so this might not be secure if the machine you run this on is not secure.</p>
<pre><code class="language-shell-session">$ pip3 install base58check pyblake2 ed25519
&gt; python3 ./sign_string.py &quot;message&quot; edsk2gL9deG8idefWJJWNNtKXeszWR4FrEdNFM5622t1PkzH66oH3r
0x753e013b8515a7d47eaa5424de5efa2f56620ac8be29d08a6952ae414256eac44b8db71f74600275662c8b0c226f3280e9d24e70a5fa83015636b98059b5180c
</code></pre>
<h4><code>sign_string.py</code></h4>
<pre><code class="language-python">from pyblake2 import blake2b
import base58check
import ed25519
import sys

message = sys.argv[1]
seed_b58 = sys.argv[2]

prefix = b'x05x01'
len_bytes = (len(message)).to_bytes(4, byteorder='big')
h = blake2b(digest_size=32)
b = bytearray()
b.extend(message.encode())
h.update(prefix + len_bytes + b)
digest = h.digest()

seed = base58check.b58decode(seed_b58)[4:-4]
sk = ed25519.SigningKey(seed)
sig = sk.sign(digest)
print(&quot;0x&quot; + sig.hex())
</code></pre>


---
title: Adding Merkle Proofs to Tezos
description: "The Upcoming Tezos Jakarta Protocol will support compact Merkle\nproofs
  to scale the network's trust infrastructure.\nThis allows nodes that\u2026"
url: https://tarides.com/blog/2022-06-13-adding-merkle-proofs-to-tezos
date: 2022-06-13T00:00:00-00:00
preview_image: https://tarides.com/static/2c0480f27aceb19ab86b870835c01b7a/0132d/merkle-tree.jpg
featured:
---

<p>The Upcoming Tezos <a href="https://tezos.gitlab.io/protocols/013_jakarta.html#protocol-jakarta">Jakarta Protocol</a> will support compact Merkle
proofs to scale the network's trust infrastructure.
This allows nodes that do not trust each other to agree on the
validity of Tezos transactions with orders of magnitude smaller
storage requirements.
For instance, the block <a href="https://tzstats.com/2400319">2,400,319</a>,
containing 402 transactions and 638 operations,
can be validated using a Merkle proof of 6.3 MB instead of requiring
a Tezos node with at least 3.4 GB of storage, a savings of 99.8%!</p>
<p>Tarides contributed to Jakarta by extending the Tezos
storage system to support compact
storage proofs. This
feature extends the compact cryptographic representation of the ledger
state to sequences of operations. As a result, nodes that do not trust
each other can still agree on the series of operations' validity,
even if they don't know the entire contents of the ledger. The
upcoming stateless nodes (like <a href="https://tezos.gitlab.io/user/light.html">Tezos
light-client</a>),
<a href="https://tezos.gitlab.io/user/proxy.html">proxies</a>, and mechanisms that allow the exchange of trust between disjointed tamper-proof storage (like <a href="https://tezos.gitlab.io/alpha/transaction_rollups.html">L2
transactional-rollups</a>,
L2 smart-contract rollups,...) will use these proofs to scale the
Tezos trust infrastructure to <a href="https://research-development.nomadic-labs.com/tezos-is-scaling.html">new heights</a>.</p>
<p>The Merkle Proof API is one of the last major features that we integrated from
<a href="https://www.dailambda.jp/blog/2019-08-08-plebeia/">Plebeia</a>. It is
the result of a years-long collaboration between
<a href="https://www.dailambda.jp/">DaiLambda</a> and Tarides to improve the
storage system of Tezos.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#a-very-quick-tour-of-tezos" aria-label="a very quick tour of tezos permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>A (Very) Quick Tour of Tezos</h3>
<p>The Tezos network builds trust between its nodes by using two components:</p>
<ul>
<li><strong>(i)</strong> a tamper-proof database that can generate cryptographic hashes,
which uniquely and compactly represent the state of its contents; and</li>
<li><strong>(ii)</strong> a consensus algorithm to share these cryptographic hashes
across the network of (potentially adversarial) nodes.</li>
</ul>
<p>Both components have seen impressive improved performance
recently. First, for <strong>(i)</strong>, we've discussed
the improvements that we released in <a href="https://tarides.com/blog/2022-04-26-lightning-fast-with-irmin-tezos-storage-is-6x-faster-with-1000-tps-surpassed">Octez v13 to improve
the efficiency of the storage component by a factor of 6</a>. Second, for <strong>(ii)</strong>, the consensus algorithm in Ithaca 2 changed from a
Nakamoto-style algorithm (like Bitcoin) to
<a href="https://arxiv.org/abs/2001.11965">Tenderbake</a> -- a Byzantine Fault
Tolerance consensus with deterministic finality. This change
significantly improved the time it takes for converging towards a
uniquely agreeing state hash in the Tezos network.</p>
<p>The Merkle proofs that we
introduced in the Jakarta Protocol will allow us to <a href="https://research-development.nomadic-labs.com/tezos-is-scaling.html">improve the
chain's performance even
more</a>.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#the-tezos-ledger-is-a-merkle-tree" aria-label="the tezos ledger is a merkle tree permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The Tezos Ledger is a Merkle Tree</h3>
<p>Tezos represents the ledger state (for instance, the amount of tokens
owned by everyone) as a Merkle tree, using the
<a href="https://irmin.io">Irmin</a> storage library. Merkle trees are immutable
tree-like data structures where each leaf is labelled with a
cryptographic hash. Each node's hash is then obtained by
recursively hashing its children's label. Tezos then combines that
root hash computation with its consensus protocol to make sure every
node in the network agrees on the ledger's state.</p>
<p>But there is another interesting aspect of Merkle trees that was not
exposed and used by Tezos until now: <em>Merkle proofs</em>. In the protocol
<code>J</code> proposal, we are introducing a new feature: Merkle proofs for
Tezos as partial, compressed, Merkle trees. In a blockchain, as in
Tezos, Merkle proofs are an efficient way to verify the integrity of
operations over Merkle trees. For this reason, Merkle proofs are
a central part of the optimistic rollups projects that will
be available with the Tezos
<a href="https://tezos.gitlab.io/protocols/013_jakarta.html">Jakarta Protocol</a>.</p>
<p>In collaboration with DaiLambda, Marigold, Nomadic Labs, and TriliTech,
we have integrated <a href="https://github.com/camlspotter/plebeia">Plebeia</a>
Merkle proofs in Irmin. Plebeia use Patricia binary trees that are capable of
generating very compact Merkle proofs. For instance, the proof of
100 operations can be represented within 46 kB, while storing the full
Tezos context requires 3.4 GB of disk storage to store the relevant context.
This compactness comes from its specialised store structure and clever
optimisations, such as path compression and inlining. We have been
working with the DaiLambda team to unite Irmin and Plebeia's strengths
and bring built-in compact Merkle proof support to Tezos. We added
support for both the existing storage stack, where trees have a
branching factor of 32, and for new L2 storage systems that could use
binary trees directly. We have also worked with Marigold and Nomadic
Labs to propose an alternative representation of these proofs using
streams, that comes with a simplified verification algorithm.
A stream proof encodes the same information as a regular proof.
However, instead of being
encoded as a tree, the proof is encoded as a sequence of steps that
reveal a Merkle tree lazily, from root to leaves.</p>
<table>
<thead>
<tr>
<th>Kind of Proofs</th>
<th>1 op.</th>
<th>100 ops.</th>
<th>1k ops.</th>
<th>10k ops.</th>
</tr>
</thead>
<tbody>
<tr>
<td>binary Merkle trees</td>
<td>0.7kB</td>
<td>46kB</td>
<td>371kB</td>
<td>2.8MB</td>
</tr>
<tr>
<td>stream binary Merkle trees</td>
<td>1kB</td>
<td>75kB</td>
<td>602kB</td>
<td>4.5MB</td>
</tr>
<tr>
<td>Merkle B-trees (32 children)</td>
<td>3.1kB</td>
<td>158kB</td>
<td>1232kB</td>
<td>7.8MB</td>
</tr>
<tr>
<td>stream Merkle B-trees (32 children)</td>
<td>3.1kB</td>
<td>158kB</td>
<td>1238kB</td>
<td>7.9MB</td>
</tr>
</tbody>
</table>
<blockquote>
<p>The table above shows the size for such proofs, using 2.5M entries (the current number of entries in <code>/data/contracts/index</code> in the Tezos context). We are simulating 1, 100, 1000, and 10_000 random read operations on the entries, and we display the size of the related proofs.</p>
</blockquote>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#an-example" aria-label="an example permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>An Example</h3>
<p>Let's look at a simple example of a Merkle proof produced for ensuring
tamper-proof banking account statements.</p>
<p>We can model a bank that stores its customer balances in the form of a
Merkle tree. To avoid publishing the entire contents of its customer
accounts, this bank can publicly export the bank's Merkle tree's
hash. To let 3rd-parties validate an operation, it can also produce
Merkle proofs that reveal the balance of some customers. Anyone in
possession of a Merkle proof can hash it and verify that it hashes
identically to the public hash announced by the bank. This equality of
hash is proof of correctness.</p>
<p>Our bank contains the balances for Eve (30 coins), Ben (10 coins), and
Bob (20 coins). It stores the customers in a radix tree (Eve's balance
is stored under <code>&quot;e&quot;, &quot;v&quot;, &quot;e&quot;</code>).</p>
<p>Irmin stores data as hash trees: whenever data is added to the
database, the corresponding nodes in the tree are hashed in order to
then generate the hash of the root node. The hash of a commit also
acts as a reference for accessing it in the future. This storage
format is close to Merkle proofs. It suffices to blind the part of the
tree that a transaction has not accessed to generate its proof. For
example, the account statement for Eve is in green. It doesn't leak
sensitive information about the other customers: only the letter &quot;b&quot;
is leaked. The hash corresponds to Bob and Ben's subtree.</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/3f72a55ae57b0494cd400fb80392b28a/84cc5/Merkle-Proof.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 41.76470588235294%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAICAYAAAD5nd/tAAAACXBIWXMAAAsTAAALEwEAmpwYAAACYUlEQVQoz12SW0hTcQCHfztdhIQMjXpIRMmHrvRQYD2kFKQvmfQ0obkJ25xh2Nk5uiZaWEkgipfE8oZQbHJyzlnSGA0Na4KWKyGNLgd2OTuX7Wy5HD718A/rqb6X3/fwPf4AAOaPZnSSzm09ACALf9lLCEGIhPA/BRcKUFheuANAHoDdALZ9f9HlIg10Ph3oKK2xpW2wb9oPMQlmmJGsE7fSzaXlpBb9mfvURvw5JGkKrMjCGrHCtmmj2kjb9lbQEj3RpLKDHVutuVAOAjpVh+Wu5T+xirRmPDxO90cHbo5/d5d8Vr0gv6xQFA6SxKEuUgdzxIz8ZD661S5wX7mTI8JI02B0uKFybCj7wzcO0Ipa0Gl6D6Mwvc2xJt9t4a6BpGJHxOi0TxQnJ9MbL46mktNQJTfVINygGuONYH+wJ6wi7WoRW2Y7hN7jRA4YBGHKz/OOUfSEeiA55Gx3zG20pqyl+Imc1dXAMUlZqBWEed2ntWCxKM3hUSYCDABPk0+w9GXp1Jg0prdsWEoqQ9p9amKySE15ynjeeRaswjrZKLt4J3FPR4bIrqTi4aKCa1FV/edk+eV5QXAtiLKLI+GV3OsqfZqRmFf2mH2uL9FX3J5uB+aArfgM1NQMeN4JdEe6z3hl77XqTE3ewCAoUQlcSiRWrobDhixFGcqR5XdaIfb6Ikl3aJDCbi7GXeEUrhxh7FyX1zU1EaMmo8xq4qqH4nknhaqeqsMmn+lBKdHjzfxjeDydFT5fL7O2NoFgcBR+/8NWh6O9TAg+g+69GXqXvtroNRrq39bDErBQJtH0z6d+A403PH63TJJLAAAAAElFTkSuQmCC'); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/3f72a55ae57b0494cd400fb80392b28a/c5bb3/Merkle-Proof.png" class="gatsby-resp-image-image" alt="Merkle Proof" title="Merkle Proof" srcset="/static/3f72a55ae57b0494cd400fb80392b28a/04472/Merkle-Proof.png 170w,
/static/3f72a55ae57b0494cd400fb80392b28a/9f933/Merkle-Proof.png 340w,
/static/3f72a55ae57b0494cd400fb80392b28a/c5bb3/Merkle-Proof.png 680w,
/static/3f72a55ae57b0494cd400fb80392b28a/84cc5/Merkle-Proof.png 898w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<blockquote>
<p>The Figure shows the difference between a Merkle tree (on the left) and a Merkle proof (on the right). In Merkle proofs, some subtrees can be blinded and represented only by their hash. Here the subtree under H2 is blinded and replaced by its hash. Thanks to this, Merkle trees and Merkle proofs will have the same root hash. Merkle proofs are hence very useful to provide Merkle tree summaries for a subset of the full data available.</p>
</blockquote>
<p>Merkle proofs are thus partial Merkle trees, with the same root hash. But proofs
can also be represented using an alternate definition: a stream of elements
that needs to be visited in order to build the tree's root hash. There is
a one-to-one correspondence between the two representations, but stream proofs
are easier to implement as they encode the order in which nodes have to be visited to verify the proof. However, stream proofs need to carry the hash of all the intermediate nodes, while tree proofs can omit those. As a consequence, tree proofs are smaller than stream proofs, as shown in the above table.</p>
<p>For instance, in the above Figure, the equivalent stream proof is the sequence:</p>
<ul>
<li>A leaf with 30 coins;</li>
<li>A node with hash <code>H3</code> with a child (&quot;e&quot;, &quot;30 coins&quot;);</li>
<li>A node with hash <code>H1</code> with a child (&quot;v&quot;, <code>H3</code>);</li>
<li>A node with hash <code>H0</code> with two children (&quot;e&quot;, <code>H1</code>) and (&quot;b&quot;, <code>H2</code>).</li>
</ul>
<p>A verifier can just apply these elements in sequence to verify that <code>H0</code> is
a valid root hash.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#merkle-proofs-in-irmin" aria-label="merkle proofs in irmin permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Merkle Proofs in Irmin</h3>
<p>If you want more details about the Merkle proof implementation, head
over to the
<a href="https://mirage.github.io/irmin/irmin/Irmin/module-type-S/Tree/Proof/index.html">documentation</a>
or at <a href="https://github.com/mirage/irmin/pull/1802">https://github.com/mirage/irmin/pull/1802</a> for the example above
revisited in Irmin.</p>

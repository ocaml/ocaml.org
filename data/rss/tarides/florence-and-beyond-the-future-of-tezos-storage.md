---
title: 'Florence and beyond: the future of Tezos storage'
description: "In collaboration with Nomadic Labs, Marigold and DaiLambda, we're happy
  to\nannounce the completion of the next Tezos protocol proposal\u2026"
url: https://tarides.com/blog/2021-03-04-florence-and-beyond-the-future-of-tezos-storage
date: 2021-03-04T00:00:00-00:00
preview_image: https://tarides.com/static/d81c504dbb5172d29c2aa38512f1dfe3/7d5a2/florence.jpg
featured:
---

<p>In collaboration with Nomadic Labs, Marigold and DaiLambda, we're happy to
announce the completion of the next Tezos protocol proposal:
<a href="http://doc.tzalpha.net/protocols/009_florence.html"><strong>Florence</strong></a>.</p>
<p><a href="https://tezos.com/">Tezos</a> is an open-source decentralised blockchain network providing a
platform for smart contracts and digital assets. A crucial feature of Tezos is
<a href="https://tezos.com/static/white_paper-2dc8c02267a8fb86bd67a108199441bf.pdf"><em>self-amendment</em></a>: the network protocol can be upgraded
dynamically by the network participants themselves. This amendment process is
initiated when a participant makes a <em>proposal</em>, which is then subject to a
vote. After several years working on the Tezos storage stack, this is our first
contribution to a proposal; we hope that it will be the first of many!</p>
<p>As detailed in today's <a href="https://blog.nomadic-labs.com/florence-our-next-protocol-upgrade-proposal.html">announcement from Nomadic Labs</a>,
the Florence proposal contains several important changes, from the introduction
of Baking Accounts to major quality-of-life improvements for smart contract
developers. Of all of these changes, we're especially excited about the
introduction of <em>sub-trees</em> to the blockchain context API. In this post, we'll
give a brief tour of what these sub-trees will bring for the future of Tezos.
But first, what <em>are</em> they?</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#merkle-sub-trees" aria-label="merkle sub trees permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Merkle sub-trees</h3>
<p>The Tezos protocol runs on top of a versioned tree called the &ldquo;context&rdquo;, which
holds the chain state (balances, contracts etc.). Ever since the pre-Alpha era,
the Tezos context has been implemented using <a href="https://github.com/mirage/irmin">Irmin</a> &ndash; an open-source
Merkle tree database originally written for use by MirageOS unikernels.</p>
<p>For MirageOS, Irmin&rsquo;s key strength is flexibility: it can run over arbitrary
backends. This is a perfect fit for Tezos, which must be agile and
widely-deployable. Indeed, the Tezos shell has already leveraged this agility
many times, all the way from initial prototypes using a Git backend to the
optimised <a href="https://tarides.com/blog/2020-09-01-introducing-irmin-pack"><code>irmin-pack</code></a> implementation used today.</p>
<p>But Irmin can do more than just swapping backends! It also allows users to
manipulate the underlying Merkle tree structure of the store with a high-level
API. This &ldquo;<a href="https://mirage.github.io/irmin/irmin/Irmin/module-type-S/Tree/">Tree</a>&rdquo; API enables lots of interesting use-cases of
Irmin, from mergeable data types (<a href="https://kcsrk.info/papers/banyan_aplas20.pdf">MRDTs</a>) to zero-knowledge proofs.
Tezos doesn't use these more powerful features directly yet; that&rsquo;s where Merkle
proofs come in!</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#proofs-and-lightweight-tezos-clients" aria-label="proofs and lightweight tezos clients permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Proofs and lightweight Tezos clients</h3>
<p>Since the Tezos context keeps track of the current &quot;state&quot; of the blockchain,
each participant needs their own copy of the tree to run transactions against.
This context can grow to be very large, so it's important that it be stored as
compactly as possible: this goal shaped the design of <code>irmin-pack</code>, our latest
Irmin backend.</p>
<p>However, it's possible to reduce the storage requirements even further via the
magic of Merkle trees: individuals only need to store a <em>fragment</em> of the root
tree, provided they can demonstrate that this fragment is valid by sending
&ldquo;<a href="https://bentnib.org/posts/2016-04-12-authenticated-data-structures-as-a-library.html">proofs</a>&rdquo; of its membership to the other participants.</p>
<p>This property can be used to support ultra-lightweight Tezos clients, a feature
<a href="https://gitlab.com/smelc/tezos/-/commits/tweag-client-light-mode">currently being developed</a> by TweagIO. To make this a reality,
the Tezos protocol needs fine-grained access to context sub-trees in order build
Merkle proofs out of them. Fortunately, Irmin already supports this! We
<a href="https://gitlab.com/tezos/tezos/-/merge_requests/2457">extended the protocol</a> to understand sub-trees, lifting the power
of Merkle trees to the user.</p>
<p>We&rsquo;re excited to work with TweagIO and Nomadic Labs on lowering the barriers to
entering the Tezos ecosystem and look forward to seeing what they achieve with
sub-trees!</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#efficient-merkle-proof-representations" aria-label="efficient merkle proof representations permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Efficient Merkle proof representations</h3>
<p>Simply exposing sub-trees in the Tezos context API isn&rsquo;t quite enough:
lightweight clients will also need to <em>serialize</em> them efficiently, since proofs
must be exchanged over the network to establish trust between collaborating
nodes. Enter <a href="https://dailambda.jp/blog/2020-05-11-plebeia/">Plebeia</a>.</p>
<p>Plebeia is an alternative Tezos storage layer &ndash; developed by DaiLambda &ndash; with
strengths that complement those of Irmin. In particular, Plebeia is capable of
generating very compact Merkle proofs. This is partly due to its specialized
store structure, and partly due to clever optimizations such as path compression
and inlining.</p>
<p>We&rsquo;re working with the DaiLambda team to unite the strengths of Irmin and
Plebeia, which will bring built-in Merkle proof support to the Tezos storage
stack. The future is bright for Merkle proofs in Tezos!</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#baking-account-migrations" aria-label="baking account migrations permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Baking account migrations</h3>
<p>Trees don&rsquo;t just enable <em>new</em> features; they have a big impact on performance
too! Currently, indexing into the context always happens from its <em>root</em>, which
duplicates effort when accessing adjacent values deep in the tree. Fortunately,
the new sub-trees provide a natural representation for &ldquo;cursors&rdquo; into the
context, allowing the protocol to optimize its interactions with the storage
layer.</p>
<p>To take just one example, DaiLambda recently exploited this feature to reduce
the migration time necessary to introduce Baking Accounts to the network by a
factor of 15! We&rsquo;ll be teaming up with Nomadic Labs and DaiLambda to ensure that
Tezos extracts every bit of performance from its storage.</p>
<p>It's especially exciting to have access to lightning-fast storage migrations,
since this enables Tezos to evolve rapidly even as the ecosystem expands.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#storage-in-other-languages" aria-label="storage in other languages permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Storage in other languages</h3>
<p>Of course, Tezos isn&rsquo;t just an OCaml project: the storage layer also has a
performant Rust implementation as part of <a href="https://github.com/simplestaking/tezedge">TezEdge</a>. We&rsquo;re working with
<a href="https://github.com/simplestaking">Simple Staking</a> to bring Irmin to the Rust community via an
<a href="https://github.com/simplestaking/ocaml-interop">FFI toolchain</a>, enabling closer alignment between the different
Tezos shell implementations.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#conclusion" aria-label="conclusion permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Conclusion</h3>
<p>All in all, it&rsquo;s an exciting time to work on Tezos storage, with many
open-source collaborators from around the world. We&rsquo;re especially happy to see
Tezos taking greater advantage of Irmin&rsquo;s features, which will strengthen both
projects and help them grow together.</p>
<p>If all of this sounds interesting, you can play with it yourself using the
recently-released <a href="https://github.com/mirage/irmin">Irmin 2.5.0</a>. Thanks for reading, and stay tuned for
future Tezos development updates!</p>

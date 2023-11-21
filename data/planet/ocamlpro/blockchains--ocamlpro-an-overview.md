---
title: 'Blockchains @ OCamlPro: an Overview'
description: OCamlPro started working on blockchains in 2014, when Arthur Breitman
  came to us with an initial idea to develop the Tezos ledger. The idea was very challenging
  with a lot of innovations. So, we collaborated with him to write a specification,
  and to turn the specification into OCaml code. Since then...
url: https://ocamlpro.com/blog/2019_04_29_blockchains_at_ocamlpro_an_overview
date: 2019-04-29T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Fabrice Le Fessant\n  "
source:
---

<p>OCamlPro started working on blockchains in 2014, when Arthur Breitman
came to us with an initial idea to develop the Tezos ledger. The idea
was very challenging with a lot of innovations. So, we collaborated
with him to write a specification, and to turn the specification into
OCaml code. Since then, we continually improved our skills in this
domain, trained more engineers, introduced the technology to students
and to professionals, advised a dozen projects, developed tools and
libraries, made some improvements and extensions to the official Tezos
node, and conducted several private deployments of the Tezos ledger.</p>
<blockquote>
<p>For an overview of OCamlPro&rsquo;s blockchain activities see <a href="https://ocamlpro.com/blog/category/blockchains">here</a></p>
</blockquote>
<h2>TzScan: A complete Block Explorer for Tezos</h2>
<p><a href="https://tzscan.io">TzScan</a> is considered today to be the best block
explorer for Tezos. It&rsquo;s made of three main components:</p>
<ul>
<li>an indexer that queries the Tezos node and fills a relational
database,
</li>
<li>an API server that queries the database to retrieve various
informations,
</li>
<li>a web based user interface (a Javascript application)
</li>
</ul>
<p>We deployed the indexer and API to freely provide the community with
an access to all the content of the Tezos blockchain, already used by
many websites, wallets and apps. In addition, we directly use this API
within our TzScan.io instance. Our deployment spans on multiple Tezos
nodes, multiple API servers and a distributed database to scale and
reply to millions of queries per day. We also regularly release open
source versions under the GPL license, that can be easily deployed on
private Tezos networks. TzScan&rsquo;s development has been initiated in
September 2017. It represents today an enormous investment, that the
Tezos Foundation helped partially fund in July 2018.</p>
<blockquote>
<p>Contact us for support, advanced features, advertisement, or if you need a private deployment of the TzScan infrastructure.</p>
</blockquote>
<h2>Liquidity: a Smart Contract Language for Tezos</h2>
<p><a href="https://www.liquidity-lang.org">Liquidity</a> is the first high-level
language for Tezos over Michelson. Its development began in April
2017, a few months before the Tezos fundraising in July 2017. It is
today the most advanced language for Tezos: it offers OCaml-like and
ReasonML-like syntaxes for writing smart contracts, compilation and
de-compilation to/from Michelson, multiple-entry points, static
type-checking &agrave; la ML, etc. Its
<a href="https://www.liquidity-lang.org/edit">online editor</a> allows to develop smart
contracts and to deploy them directly into the alphanet or
mainnet. Liquidity has been used before the mainnet launch to
de-compile the Foundation&rsquo;s vesting smart contracts in order to review
them. This smart contract language represents more than two years of
work, and is fully funded by OCamlPro. It has been developed with
formal verification in mind, formal verification being one of the
selling points of Tezos. We have elaborated a detailed roadmap mixing
model-checking and deductive program verification to investigate this
feature. We are now searching for funding opportunities to keep
developing and maintaining Liquidity.</p>
<blockquote>
<p>See our <a href="https://www.liquidity-lang.org/edit">online editor</a> to get started ! Contact us if you need support, training, writing or in-depth analysis of your smart contracts.</p>
</blockquote>
<h2>Techelson: a testing framework for Michelson and Liquidity</h2>
<p><a href="https://ocamlpro.github.io/techelson/">Techelson</a> is our newborn in
the set of tools for the Tezos blockchain. It is a test execution
engine for the functional properties of Michelson and Liquidity
contracts. Techelson is still in its early development stage. The user
documentation <a href="https://ocamlpro.github.io/techelson/user_doc/">is available
here</a>. An example on
how to use it with Liquidity is detailed in <a href="https://adrienchampion.github.io/blog/tezos/techelson/with_liquidity/index.html">this
post</a>.</p>
<blockquote>
<p>Contact us to customize the engine to suit your own needs!</p>
</blockquote>
<h2>IronTez: an optimized Tezos node by OCamlPro</h2>
<p>IronTez is a tailored node for private (and public) deployments of
Tezos. Among its additional features, the node adds some useful RPCs,
improves storage, enables garbage collection and context pruning,
allows an easy configuration of the private network, provides
additional Michelson instructions (GET_STORAGE, CATCH&hellip;). One of its
nice features is the ability to enable adaptive baking in private /
proof-of-authority setting (eg. baking every 5 seconds in presence of
transactions and every 10 minutes otherwise, etc.).</p>
<p>A simplified version of IronTez has already been made public to allow
testing its <a href="https://ocamlpro.com/blog/2019_02_04_improving_tezos_storage_gitlab_branch_for_testers">improved storage system,
Ironmin</a>,
showing a 10x reduction in storage. Some TzScan.io nodes are also
using versions of IronTez. We&rsquo;ve also successfully deployed it along
with TzScan for a big foreign company to experiment with private
blockchains. We are searching for projects and funding opportunities
to keep developing and maintaining this optimized version of the Tezos
node.</p>
<blockquote>
<p>Don&rsquo;t hesitate to contact us if you want to deploy a blockchain with IronTez, or for more information !</p>
</blockquote>
<h1>Comments</h1>
<p>Kristen (3 May 2019 at 0 h 30 min):</p>
<blockquote>
<p>I really wanted to keep using IronTez but I ran into bugs that have not yet been fixed, the code is out of date with upstream, and there is no real avenue for support/assistance other than email.</p>
</blockquote>


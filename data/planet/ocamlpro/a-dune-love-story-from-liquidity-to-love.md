---
title: 'A Dune Love story: From Liquidity to Love'
description: By OCamlPro & Origin Labs Writing smart contacts may often be a burdensome
  task, as you need to learn a new language for each blockchain you target. In the
  Dune Network team, we are willing to provide as many possibilities as possible for
  developers to thrive in an accessible and secure framework. T...
url: https://ocamlpro.com/blog/2020_06_09_a_dune_love_story_from_liquidity_to_love
date: 2020-06-09T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Steven De Oliveira\n  "
source:
---

<div align="center">
<a href="https://ocamlpro.com/blog/2020_06_09_a_dune_love_story_from_liquidity_to_love">
<img src="https://ocamlpro.com/blog/assets/img/liq-love-1.png" width="900" height="900" alt="Liquidity &amp; Love" title="A Dune Love story: From Liquidity to Love"/>
</a>
</div>
<p><em>By OCamlPro &amp; Origin Labs</em></p>
<p>Writing smart contacts may often be a burdensome task, as you need to learn a new language for each blockchain you target. In the Dune Network team, we are willing to provide as many possibilities as possible for developers to thrive in an accessible and secure framework.</p>
<p>There are two kinds of languages on a blockchain: &ldquo;native&rdquo; languages that are directly understood by the blockchain, but with some difficulty by the developers, and &ldquo;compiled&rdquo; languages that are more transparent to developers, but need to be translated to a native language to run on the blockchain. For example, Solidity is a developer-friendly language, compiled to the native EVM language on the Ethereum blockchain.</p>
<p>Dune Network supports multiple native languages:</p>
<ul>
<li><a href="https://medium.com/dune-network/love-a-new-smart-contract-language-for-the-dune-network-a217ab2255be"><strong>Love</strong></a>, a type-safe language with a ML syntax and suited for formal verification
</li>
<li><a href="https://dune.network/docs/dune-node-mainnet/whitedoc/michelson.html"><strong>Michelson</strong></a>, inherited from <a href="https://tezos.com">Tezos</a>, also type-safe, much more difficult to read
</li>
<li><a href="https://en.wikipedia.org/wiki/Solidity"><strong>Solidity</strong></a>, the Ethereum language, of which we are currently implementing the interpreter after releasing <a href="https://medium.com/dune-network/a-solidity-parser-in-ocaml-with-menhir-e1064f94e76b">its parser in OCaml</a> a few weeks ago
</li>
</ul>
<p>On the side of compiled languages, Dune Network supports:</p>
<ul>
<li><a href="https://www.liquidity-lang.org/"><strong>Liquidity</strong></a>, a type-safe ML language suited for formal verification, that compiles to Michelson (and allows developers to decompile Michelson for auditing)
</li>
<li><a href="https://reasonml.github.io/"><strong>ReasonML</strong></a>, a JavaScript language designed by Facebook that compiles down to Michelson through Liquidity
</li>
<li>All other Tezos languages that compile to Michelson (for example <a href="https://ligolang.org/"><strong>Ligo</strong></a>, <a href="https://smartpy.io/"><strong>SmartPy</strong></a>, <a href="https://albert-lang.io/"><strong>Albert</strong></a>...)
</li>
</ul>
<p>Though Liquidity and Love are both part of the ML family, Liquidity is much more developer-friendly: types are inferred, whereas in Love they have to be explicit, and Liquidity supports the ReasonML JavaScript syntax while Love is bound to its ML syntax.</p>
<p>For all these reasons, we are pleased to announce a wedding: Liquidity now supports the Love language!</p>
<p><img src="https://ocamlpro.com/blog/assets/img/liq-love-2.png" alt="Liquidity &amp; Love"/></p>
<p><em>Liquidity now supports generating Love smart contracts</em></p>
<p>This is great news for Love, as Liquidity is easier to use, and comes with an online web editor, <a href="https://www.liquidity-lang.org/edit/">Try-Liquidity</a>. Liquidity is also being targeted by the <a href="https://arxiv.org/pdf/1907.10674.pdf">ConCert project</a>, aiming at <strong>verifying smart contracts</strong> with the formal verification framework Coq.</p>
<p><img src="https://ocamlpro.com/blog/assets/img/dune-compilers.png" alt="Dune Languages"/></p>
<p><em>The Smart Contract Framework on the Dune Network</em></p>
<p>Compiling contracts from Liquidity to Love has several benefits compared to Michelson. First, Love contracts are about 60% smaller than Michelson contracts, hence they are <strong>60% cheaper</strong> to deploy. Also, the compiler outputs a Love contract that can be easily read and audited.</p>
<p>The Love compiler is part of the <a href="https://github.com/OCamlPro/liquidity">Liquidity project</a>. It works as follows:</p>
<ul>
<li><strong>The Liquidity contract is type-checked by the Liquidity compiler.</strong> The strong type system of liquidity enforces structural &amp; semantic properties on data.
</li>
<li><strong>The typed Liquidity contract is compiled to a typed Love contract.</strong> During this step, the Liquidity contract is scanned to check if it complies with the Love requirements (correct use of operators, no reentrancy, etc.).
</li>
<li><strong>The Love contract is type-checked.</strong> Once this step is completed, the contract is ready to be deployed on the chain!
</li>
</ul>
<p>Want to try it out? Check the <a href="https://www.liquidity-lang.org/edit/">Try-Liquidity</a> website: you can now compile and deploy your Liquidity contracts in Love from the online editor directly to the Mainnet and Testnet using <a href="https://metal.dune.network">Dune Metal</a>!</p>
<hr/>
<p>These are some of the resources you might find interesting when building your own smart contracts:</p>
<ul>
<li><strong>The Love Language Documentation</strong>: https://dune.network/docs/dune-dev-docs/love-doc/introduction.html
</li>
<li><strong>Try-Liquidity:</strong> https://www.liquidity-lang.org/edit/
</li>
<li><strong>The Liquidity Website:</strong> https://www.liquidity-lang.org/
</li>
<li><strong>The Dune Network Website:</strong> https://dune.network
</li>
</ul>
<h2>About Origin Labs</h2>
<p>Origin Labs is a company founded in 2019 by the former blockchain team at  OCamlPro. At Origin Labs, they have been developing Dune Network, a fork of the Tezos blockchain, its ecosystem, and applications over the Dune  Network platform. At OCamlPro, they developed TzScan, the most popular  block explorer at the time, Liquidity, a smart contract language, and  were involved in the development of the core protocol and node. Feel free to reach out by email: contact@origin-labs.com.</p>


---
title: A Solidity parser in OCaml with Menhir
description: "This article is cross-posted on Origin Labs\u2019 Dune Network blog
  We are happy to announce the first release of our Solidity parser, written in OCaml
  using Menhir. This is a joint effort with Origin Labs, the company dedicated to
  blockchain challenges, to implement a full interpreter for the Solidity..."
url: https://ocamlpro.com/blog/2020_05_19_ocaml_solidity_parser_with_menhir
date: 2020-05-19T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    David Declerck\n  "
source:
---

<p align="center">
<a href="https://ocamlpro.com/blog/2020_05_19_ocaml_solidity_parser_with_menhir">
<img src="https://ocamlpro.com/blog/assets/img/solidity-cover.png" width="420" height="420" alt="Solidity Logo" title="A Solidity parser in OCaml with Menhir"/>
</a>
</p>
<br/>
<blockquote>
<p>This article is cross-posted on Origin Labs&rsquo; Dune Network <a href="https://medium.com/dune-network/a-solidity-parser-in-ocaml-with-menhir-e1064f94e76b">blog</a></p>
</blockquote>
<p>We are happy to announce the first release of <a href="https://gitlab.com/o-labs/solidity-parser-ocaml">our Solidity parser</a>, written in OCaml using <a href="http://gallium.inria.fr/~fpottier/menhir/">Menhir</a>. This is a joint effort with <a href="https://www.origin-labs.com/">Origin Labs</a>, the company dedicated to blockchain challenges, to implement a full interpreter for the <a href="https://solidity.readthedocs.io/en/v0.6.8/">Solidity language</a> directly in a blockchain.</p>
<p><img src="https://ocamlpro.com/blog/assets/img/logo_solidity_title.png" alt="Solidity Logo"/></p>
<p>Solidity is probably the most popular language for smart-contracts, small pieces of code triggered when accounts receive transactions on a blockchain.Solidity is an object-oriented strongly-typed language with a Javascript-like syntax.</p>
<p><img src="https://ocamlpro.com/blog/assets/img/logo_ethereum_title.png" alt="Ethereum Logo"/></p>
<p>Solidity was first implemented for the <a href="https://ethereum.org/">Ethereum</a> blockchain, with a compiler to the EVM, the Ethereum Virtual Machine.</p>
<p><img src="https://ocamlpro.com/blog/assets/img/logo_dune_title.png" alt="Dune Network Logo"/></p>
<p>Dune Network takes a different approach, as Solidity smart-contracts will be executed natively, after type-checking. Solidity will be the third native language on Dune Network, with <a href="https://dune.network/docs/dune-node-mainnet/whitedoc/michelson.html">Michelson</a>, a low-level strongly-typed language inherited from Tezos, and <a href="https://dune.network/docs/dune-node-mainnet/love-doc/introduction.html">Love</a>, an higher-level strongly-typed language, also implemented jointly by OCamlPro and Origin Labs.</p>
<p>A first step has been accomplished, with the completion of the Solidity parser and printer, written in OCaml with Menhir.</p>
<p>This parser (and its printer companion) is now available as a standalone library under the LGPLv3 license with Linking Exception, allowing its integration in all projects. The source code is available at https://gitlab.com/o-labs/solidity-parser-ocaml.</p>
<p>Our parser should support all of Solidity 0.6, with the notable exception of inline assembly (may be added in a future release).</p>
<h2>Example contract</h2>
<p>Here is an example of a very simple contract that stores an integer value and allows the contract&rsquo;s owner to add an arbitrary value to this value, and any other contract to read this value:</p>
<pre><code class="language-solidity">pragma solidity &gt;=0.6.0 &lt;0.7.0;

contract C {
    address owner;
    int x;

    constructor() public {
        owner = msg.sender;
        x = 0;
    }

    function add(int d) public {
        require(msg.sender == owner);
        x += d;
    }

    function read_x() public view returns(int) {
        return x;
    }
}
</code></pre>
<h2>Parser Usage</h2>
<h3>Executable</h3>
<p>Our parser comes with a small executable that demonstrates the library usage. Simply run:</p>
<pre><code class="language-bash">./solp contract.sol
</code></pre>
<p>This will parse the file <code>contract.sol</code> and reprint it on the terminal.</p>
<h3>Library</h3>
<p>To use our parser as a library, add it to your program&rsquo;s dependencies and use the following function:</p>
<pre><code class="language-ocaml">Solidity_parser.parse_contract_file : string -&gt; Solidity_parser.Solidity_types.module_
</code></pre>
<p>It takes a filename and returns a Solidity AST.</p>
<p>If you wish to print this AST, you may turn it into its string representation by sending it to the following function:</p>
<pre><code class="language-ocaml">Solidity_parser.Printer.string_of_code : Solidity_parser.Solidity_types.module_ -&gt; string
</code></pre>
<h2>Conclusion</h2>
<p>Of course, all of this is Work In Progress, but we are quite happy to share it with the OCaml community. We think there is a tremendous work to be done around blockchains for experts in formal methods. Do not hesitate to contact us if you want to use this library!</p>
<h2>About Origin Labs</h2>
<p>Origin Labs is a company founded in 2019 by the former blockchain team at OCamlPro. At Origin Labs, they have been developing Dune Network, a fork of the Tezos blockchain, its ecosystem, and applications over the Dune Network platform. At OCamlPro, they developed TzScan, the most popular block explorer at the time, Liquidity, a smart contract language, and were involved in the development of the core protocol and node.Do not hesitate to reach out by email: contact@origin-labs.com.</p>


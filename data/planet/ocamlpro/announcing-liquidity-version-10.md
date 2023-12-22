---
title: Announcing Liquidity version 1.0
description: Liquidity version 1.0 We are pleased to announce the release of the first
  major version of the Liquidity smart-contract language and associated tools. Some
  of the highlights of this version are detailed below. Multiple Entry Points In the
  previous versions of Liquidity, smart contracts were limited ...
url: https://ocamlpro.com/blog/2019_03_08_announcing_liquidity_version_1_0
date: 2019-03-08T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Alain Mebsout\n  "
source:
---

<h1>Liquidity version 1.0</h1>
<p>We are pleased to announce the release of the first major version of the Liquidity smart-contract language and associated tools.</p>
<p>Some of the highlights of this version are detailed below.</p>
<h3>Multiple Entry Points</h3>
<p>In the previous versions of Liquidity, smart contracts were limited to a single entry point (named <code>main</code>). But traditionally smart contracts executions path depend strongly on the parameter and in most cases they are completely distinct.</p>
<p>Having different entry points allows to separate code that do not overlap and which usually accomplish vastly different tasks. Encoding entry points with complex pattern matching constructs before was tedious and made the code not extremely readable. This new feature gives you readability and allows to call contracts in a natural way.</p>
<p>Internally, entry points are encoded with sum types and pattern matching so that you keep the strong typing guarantees that come over from Michelson. This means that you cannot call a typed smart contract with the wrong entry point or the wrong parameter (this is enforced statically by both the Liquidity typechecker and the Michelson typechecker).</p>
<h3>Modules and Contract System</h3>
<p>Organizing, encapsulating and sharing code is not always easy when you need to write thousand lines files. Liquidity now allows to write modules (which contain types and values/functions) and contracts (which define entry points in addition). Types and non-private values of contracts and modules in scope can be accessed by other modules and contracts.</p>
<p>You can even compile several files at once with the command line compiler, so that you may organize your multiple smart contract projects in libraries and files.</p>
<h3>Polymorphism and Type Inference</h3>
<p>Thanks to a new and powerful type inference algorithm, you can now get rid of almost all type annotations in the smart contracts.</p>
<p>Instead of writing something like</p>
<pre><code class="language-ocaml">let%entry main (parameter : bool) (storage : int) =
  let ops = ([] : operation list) in
  let f (c : bool) = if not c then 1 else 2 in
  ops, f parameter
</code></pre>
<p>you can now write</p>
<pre><code class="language-ocaml">let%entry main parameter _ =
  let ops = [] in
  let f c = if not c then 1 else 2 in
  ops, f parameter
</code></pre>
<p>And type inference works with polymorhpism (also a new feature of this release) so you can now write generic and reusable functions:</p>
<pre><code class="language-ocaml">type 'a t = { x : 'a set; y : 'a }

let mem_t v = Set.mem v.y v.x
</code></pre>
<p>Inference also works with contract types and entry points.</p>
<h3>ReasonML Syntax</h3>
<p>We originally used a modified version of the OCaml syntax for the Liquidity language. This made the language accessible, almost for free, to all OCaml and functional language developers. The typing discipline one needs is quite similar to other strongly typed functional languages so this was a natural fit.</p>
<p>However this is not the best fit for everyone. We want to bring the power of Liquidity and Tezos to the masses so adopting a seemingly familiar syntax for most people can help a lot. With this new version of Liquidity, you can now write your smart contracts in both an OCaml-like syntax or a <a href="https://reasonml.github.io">ReasonML</a>-like one. The latter being a lot closer to Javascript on the surface, making it accessible to people that already know the language or people that write smart contracts for other platforms like Solidity/Ethereum.</p>
<p>You can see the full changelog as well as download the latest release and binaries <a href="https://github.com/OCamlPro/liquidity/releases">at this address</a>.</p>
<p>Don't forget that you can also try all these new cool features and more directly in your browser with our <a href="https://www.liquidity-lang.org/edit/">online editor</a>.</p>


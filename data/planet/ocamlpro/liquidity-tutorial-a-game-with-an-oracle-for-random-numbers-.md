---
title: 'Liquidity Tutorial: A Game with an Oracle for Random Numbers '
description: A Game with an oracle In this small tutorial, we will see how to write
  a chance game on the Tezos blockchain with Liquidity and a small external oracle
  which provides random numbers. Principle of the game Rules of the game are handled
  by a smart contract on the Tezos blockchain. When a player decide...
url: https://ocamlpro.com/blog/2018_11_06_liquidity_tutorial_a_game_with_an_oracle_for_random_numbers
date: 2018-11-06T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Alain Mebsout\n  "
source:
---

<h1>A Game with an oracle</h1>
<p>In this small tutorial, we will see how to write a chance game on the Tezos blockchain with Liquidity and a small external oracle which provides random numbers.</p>
<h2>Principle of the game</h2>
<p>Rules of the game are handled by a smart contract on the Tezos blockchain.</p>
<p>When a player decides to start a game, she must start by making a transaction (<em>i.e.</em> a call) to the game smart contract with a number parameter (let's call it <code>n</code>) between 0 and 100 (inclusively). The amount that is sent with this transaction constitute her bet <code>b</code>.</p>
<p>A random number <code>r</code> is then chosen by the oracle and the outcome of the game is decided by the smart contract.</p>
<ul>
<li>The player <strong>loses</strong> if her number <code>n</code> is <em>greater</em> than <code>r</code>. In this case, she forfeits her bet amount and the game smart contract is resets (the money stays on the game smart contract).- The player <strong>wins</strong> if her number <code>n</code> is <em>smaller or equal</em> to <code>r</code>. In this case, she gets back her initial bet <code>b</code> plus a reward which is proportional to her bet and her chosen number <code>b * n / 100</code>. This means that a higher number <code>n</code>, while being a riskier choice (the following random number must be greater), yields a greater reward. The edge cases being <code>n = 0</code> is an always winning input but the reward is always null, and <code>n = 100</code> wins only if the random number is also <code>100</code> but the player doubles her bet.
</li>
</ul>
<h2>Architecture of the DApp</h2>
<p>Everything that happens on the blockchain is deterministic and reproducible which means that smart contracts cannot generate random numbers securely <sup>1</sup> .</p>
<p>The following smart contract works in this manner. Once a user starts a game, the smart contract is put in a state where it awaits a random number from a trusted off-chain source. This trusted source is our random generator oracle. The oracle monitors the blockchain and generates and sends a random number to the smart contract once it detects that it is waiting for one.</p>
<p><img src="https://ocamlpro.com/blog/assets/img/draw_game_arch.jpg" alt=""/></p>
<p>Because the oracle waits for a <code>play</code> transaction to be included in a block and sends the random number in a subsequent block, this means that a game round lasts at least two blocks <sup>2</sup> .</p>
<p>This technicality forces us to split our smart contract into two distinct entry points:</p>
<ul>
<li>A first entry point <code>play</code> is called by a player who wants to start a game (it cannot be called twice). The code of this entry point saves the game parameters in the smart contract storage and stops execution (awaiting a random number).- A second entry point <code>finish</code>, which can only be called by the oracle, accepts random numbers as parameter. The code of this entry point computes the outcome of the current game based on the game parameters and the random number, and then proceeds accordingly. At the end of <code>finish</code> the contract is reset and a new game can be started.
</li>
</ul>
<h2>The Game Smart Contract</h2>
<p>The smart contract game manipulates a storage of the following type:</p>
<pre><code class="language-ocaml">type game = {
  number : nat;
  bet : tez;
  player : key_hash;
}

type storage = { game : game option; oracle_id : address; }
</code></pre>
<p>The storage contains the address of the oracle, <code>oracle_id</code>. It will only accept transactions coming from this address (<em>i.e.</em> that are signed by the corresponding private key). It also contains an optional value <code>game</code> that indicates if a game is being played or not.</p>
<p>A game consists in three values, stored in a record:</p>
<ul>
<li><code>number</code> is the number chosen by the player.- <code>bet</code> is the amount that was sent with the first transaction by the player. It constitute the bet amount.- <code>player</code> is the key hash (tz1...) on which the player who made the bet wishes to be payed in the event of a win.
</li>
</ul>
<p>We also give an initializer function that can be used to deploy the contract with an initial value. It takes as argument the address of the oracle, which cannot be changed later on.</p>
<pre><code class="language-ocaml">let%init storage (oracle_id : address) =
  { game = (None : game option); oracle_id }
</code></pre>
<h3>The <code>play</code> entry point</h3>
<p>The first entry point, <code>play</code> takes as argument a pair composed of: - a natural number, which is the number chosen by the player - and a key hash, which is the address on which a player wishes to be payed as well as the current storage of the smart contract.</p>
<pre><code class="language-ocaml">let%entry play (number : nat) storage = ...
</code></pre>
<p>The first thing this contract does is validate the inputs:</p>
<ul>
<li>Ensure that the number is a valid choice, <em>i.e.</em> is between 0 and 100 (natural numbers are always greater or equal to 0).
</li>
</ul>
<pre><code class="language-ocaml">if number &gt; 100p then  failwith &quot;number must be &lt;= 100&quot;;
</code></pre>
<ul>
<li>Ensure that the contract has enough funds to pay the player in case she wins. The highest paying bet is to play <code>100</code> which means that the user gets payed twice its original bet amount. At this point of the execution, the balance of the contract is already credited with the bet amount, so this check comes to ensuring that the balance is greater than twice the bet.
</li>
</ul>
<pre><code class="language-ocaml">if 2p * Current.amount () &gt; Current.balance () then
  failwith &quot;I don't have enough money for this bet&quot;;
</code></pre>
<ul>
<li>Ensure that no other game is currently being played so that a previous game is not erased.
</li>
</ul>
<pre><code class="language-ocaml">match storage.game with
| Some&lt;/span&gt; g -&gt;
  failwith (&quot;Game already started with&quot;, g)
| None -&gt;
  (* Actual code of entry point *)
</code></pre>
<p>The rest of the code for this entry point consist in simply creating a new <code>game</code> record <code>{ number; bet; player }</code> and saving it to the smart contract's storage. This entry point always returns an empty list of operations because it does not make any contract calls or transfers.</p>
<pre><code class="language-ocaml">let bet = Current.amount () in
let storage = storage.game &lt;- Some { number; bet; player } in
(([] : operation list), storage)
</code></pre>
<p>The new storage is returned and the execution stops at this point, waiting for someone (the oracle) to call the <code>finish</code> entry point.</p>
<h3>The <code>finish</code> entry point</h3>
<p>The second entry point, <code>finish</code> takes as argument a natural number parameter, which is the random number generated by the oracle, as well as the current storage of the smart contract.</p>
<pre><code class="language-ocaml">let%entry finish (random_number : nat) storage = ...
</code></pre>
<p>The random number can be any natural number (these are mathematically unbounded natural numbers) so we must make sure it is between 0 and 100 before proceeding. Instead of rejecting too big random numbers, we simply (Euclidean) divide it by 101 and keep the remainder, which is between 0 and 100. The oracle already generates random numbers between 0 and 100 so this operation will do nothing but is interesting to keep if we want to replace the random generator one day.</p>
<pre><code class="language-ocaml">let random_number = match random_number / 101p with
  | None -&gt; failwith ()
  | Some (_, r) -&gt; r in
</code></pre>
<p>Smart contracts are public objects on the Tezos blockchain so anyone can decide to call them. This means that permissions must be handled by the logic of the smart contract itself. In particular, we don't want <code>finish</code> to be callable by anyone, otherwise it would mean that the player could choose its own random number. Here we make sure that the call comes from the oracle.</p>
<pre><code class="language-ocaml">if Current.sender () &lt;&gt; storage.oracle_id then
  failwith (&quot;Random numbers cannot be generated&quot;);
</code></pre>
<p>We must also make sure that a game is currently being played otherwise this random number is quite useless.</p>
<pre><code class="language-ocaml">match storage.game with
| None -&gt; failwith &quot;No game already started&quot;
| Some game -&gt; ...
</code></pre>
<p>The rest of the code in the entry point decides if the player won or lost, and generates the corresponding operations accordingly.</p>
<pre><code class="language-ocaml">if random_number &lt; game.number then
  (* Lose *)
  ([] : operation list)
</code></pre>
<p>If the random number is smaller that the chosen number, the player lost. In this case no operation is generated and the money is kept by the smart contract.</p>
<pre><code class="language-ocaml">else
  (* Win *)
  let gain = match (game.bet * game.number / 100p) with
    | None -&gt; 0tz
    | Some (g, _) -&gt; g in
  let reimbursed = game.bet + gain in
  [ Account.transfer ~dest:game.player ~amount:reimbursed ]
</code></pre>
<p>Otherwise, if the random number is greater or equal to the previously chosen number, then the player won. We compute her gain and the reimbursement value (which is her original bet + her gain) and generate a transfer operation with this amount.</p>
<pre><code class="language-ocaml">let storage = storage.game &lt;- (None : game option) in
(ops, storage)
</code></pre>
<p>Finally, the storage of the smart contract is reset, meaning that the current game is erased. The list of generated operations and the reset storage is returned.</p>
<h3>A safety entry point: <code>fund</code></h3>
<p>At anytime we authorize anyone (most likely the manager of the contract) to add funds to the contract's balance. This allows new players to participate in the game even if the contract has been depleted, by simply adding more funds to it.</p>
<pre><code class="language-ocaml">let%entry fund _ storage =
  ([] : operation list), storage
</code></pre>
<p>This code does nothing, excepted accepting transfers with amounts.</p>
<h3>Full Liquidity Code of the Game Smart Contract</h3>
<pre><code class="language-ocaml">[%%version 0.403]

type game = {
  number : nat;
  bet : tez;
  player : key_hash;
}

type storage = {
  game : game option;
  oracle_id : address;
}

let%init storage (oracle_id : address) =
  { game = (None : game option); oracle_id }

(* Start a new game *)
let%entry play ((number : nat), (player : key_hash)) storage =
  if number &gt; 100p then failwith &quot;number must be &lt;= 100&quot;;
  if Current.amount () = 0tz then failwith &quot;bet cannot be 0tz&quot;;
  if 2p * Current.amount () &gt; Current.balance () then
    failwith &quot;I don't have enough money for this bet&quot;;
  match storage.game with
  | Some g -&gt;
    failwith (&quot;Game already started with&quot;, g)
  | None -&gt;
    let bet = Current.amount () in
    let storage = storage.game &lt;- Some { number; bet; player } in
    (([] : operation list), storage)

(* Receive a random number from the oracle and compute outcome of the
   game *)
let%entry finish (random_number : nat) storage =
  let random_number = match random_number / 101p with
    | None -&gt; failwith ()
    | Some (_, r) -&gt; r in
  if Current.sender () &lt;&gt; storage.oracle_id then
    failwith (&quot;Random numbers cannot be generated&quot;);
  match storage.game with
  | None -&gt; failwith &quot;No game already started&quot;
  | Some game -&gt;
    let ops =
      if random_number &lt; game.number then
        (* Lose *)
        ([] : operation list)
      else
        (* Win *)
        let gain = match (game.bet * game.number / 100p) with
          | None -&gt; 0tz
          | Some (g, _) -&gt; g in
        let reimbursed = game.bet + gain in
        [ Account.transfer ~dest:game.player ~amount:reimbursed ]
    in
    let storage = storage.game &lt;- (None : game option) in
    (ops, storage)

(* accept funds *)
let%entry fund _ storage =
  ([] : operation list), storage
</code></pre>
<h2>The Oracle</h2>
<p>The oracle can be implemented using <a href="http://tezos.gitlab.io/mainnet/api/rpc.html">Tezos RPCs</a> on a running Tezos node. The principle of the oracle is the following:</p>
<ul>
<li>Monitor new blocks in the chain.
</li>
<li>For each new block, look if it includes <strong>successful</strong> transactions whose <em>destination</em> is the <em>game smart contract</em>.
</li>
<li>Look at the parameters of the transaction to see if it is a call to either <code>play</code>, <code>finish</code> or <code>fund</code>.
</li>
<li>If it is a successful call to <code>play</code>, then we know that the smart contract is awaiting a random number.
</li>
<li>Generate a random number between 0 and 100 and make a call to the game smart contract with the appropriate private key (the transaction can be signed by a Ledger plugged to the oracle server for instance).
</li>
<li>Wait a small amount of time depending on blocks intervals for confirmation.
</li>
<li>Loop.
</li>
</ul>
<p>These can be implemented with the following RPCs:</p>
<ul>
<li>Monitoring blocks: <code>/chains/main/blocks?[length=&lt;int&gt;]</code><a href="https://tezos.gitlab.io/mainnet/api/rpc.html#get-chains-chain-id-blocks">https://tezos.gitlab.io/mainnet/api/rpc.html#get-chains-chain-id-blocks</a>
</li>
<li>Listing operations in blocks: <code>/chains/main/blocks/&lt;block_id&gt;/operations/3</code><a href="https://tezos.gitlab.io/mainnet/api/rpc.html#get-block-id-operations-list-offset">https://tezos.gitlab.io/mainnet/api/rpc.html#get-block-id-operations-list-offset</a>
</li>
<li>Getting the storage of a contract: <code>/chains/main/blocks/&lt;block_id&gt;/context/contracts/&lt;contract_id&gt;/storage</code><a href="https://tezos.gitlab.io/mainnet/api/rpc.html#get-block-id-context-contracts-contract-id-storage">https://tezos.gitlab.io/mainnet/api/rpc.html#get-block-id-context-contracts-contract-id-storage</a>
</li>
<li>Making transactions or contract calls:
<ul>
<li>Either call the <code>tezos-client</code> binary (easiest if running on a server).
</li>
<li>Call the <code>liquidity file.liq --call ...</code> binary (private key must be in plain text so it is not recommended for production servers).
</li>
</ul>
</li>
</ul>
<p>An implementation of a random number Oracle in OCaml (which uses the liquidity client to make transactions) can be found in this repository: <a href="https://github.com/OCamlPro/liq_game/blob/master/src/crawler.ml">https://github.com/OCamlPro/liq_game/blob/master/src/crawler.ml</a>.</p>
<h3>Try a version on the mainnet</h3>
<p>This contract is deployed on the Tezos mainnet at the following address:<a href="https://tzscan.io/KT1GgUJwMQoFayRYNwamRAYCvHBLzgorLoGo">KT1GgUJwMQoFayRYNwamRAYCvHBLzgorLoGo</a>, with the minor difference that the contract refunds 1 &mu;tz if the player loses to give some sort of feedback. You can try your luck by sending transactions (with a non zero amount) with a parameter of the form <code>Left (Pair 99 &amp;quot;tz1LWub69XbTxdatJnBkm7caDQoybSgW4T3s&amp;quot;)</code> where <code>99</code> is the number you want to play and <code>tz1LWub69XbTxdatJnBkm7caDQoybSgW4T3s</code> is your refund address. You can do so by using either a wallet that supports passing parameters with transactions (like Tezbox) or the command line Tezos client:</p>
<pre><code>tezos-client transfer 10 from my_account to KT1GgUJwMQoFayRYNwamRAYCvHBLzgorLoGo --fee 0 --arg 'Left (Pair 50 &quot;tz1LWub69XbTxdatJnBkm7caDQoybSgW4T3s&quot;)'
</code></pre>
<h2>Remarks</h2>
<ul>
<li>In this game, the oracle must be trusted and so it can cheat. To mitigate this drawback, the oracle can be used as a random number generator for several games, if random values are stored in an intermediate contract.
</li>
<li>If the oracle looks for events in the last baked block (head), then it is possible that the current chain will be discarded and that the random number transaction appears in another chain. In this case, the player that sees this happen can play another game with a chosen number if he sees the random number in the mempool. In practice, the oracle operation is created only on the branch where the first player started, so that this operation cannot be put on another branch, removing any risk of attack.
</li>
</ul>
<p><strong>Footnotes</strong></p>
<ul>
<li>
<p>Some contracts on Ethereum use block hashes as sources of randomness but these are easily manipulated by miners so they are not safe to use. There are also ways to have participants contribute parts of a random number with enforceable commitments <a href="https://github.com/randao/randao">https://github.com/randao/randao</a>.</p>
</li>
<li>
<p>The random number could technically be sent in the same block by monitoring the mempool but it is not a good idea because the miner could reorder the transactions which will make both of them fail, or worse she could replace her bet accordingly once she sees a random number in her mempool.</p>
</li>
</ul>
<hr class="featurette-divider"/>
<p><strong>Alain Mebsout</strong>: Alain is a senior engineer at OCamlPro. Alain was involved in Tezos early in 2017, participating in the design of the ICO infrastructure and in particular, the Bitcoin and Ethereum smart contracts. Since then, Alain has been developing the Liquidity language, compiler and online editor, and has started working on the verification of Liquidity smart contracts. Alain also contributed some code in the Tezos node to improve Michelson. Alain holds a PhD in Computer Science on formal verification of programs.</p>
<h1>Comments</h1>
<p>Luiz Milfont (14 December 2018 at 17 h 21 min):</p>
<blockquote>
<p>Hello Mr. Alain Mebsout. My name is Milfont and I am the author of TezosJ SDK library, that allows to interact with Tezos blockchain through Java programming language.I did&rsquo;t know this game before and got interested. I wonder if you would like me to create an Android version of your game, that would be an Android APP that would create a wallet automatically for the player and then he would pull a jackpot handle, sending the transaction with the parameters to your smart contract. I would like to know if you agree with this, and allow me to do it, using your already deployed game. Thanks in advance. Milfont. Twitter: @luizmilfont</p>
</blockquote>
<p>michsell (1 October 2019 at 15 h 29 min):</p>
<blockquote>
<p>Hello Alain,</p>
<p>I just played the game you designed, the problem is I cannot get any feedback even that 1utz for losing the game. Is the game retired? If so, can anyone help to remove it from tzscan dapps page: https://tzscan.io/dapps. Also, by any chance I may get the tezzies back&hellip;</p>
<p>Many thanks!
Best regards,
Michshell</p>
</blockquote>


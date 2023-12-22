---
title: 'An Introduction to Tezos RPCs: a Basic Wallet'
description: 'In this technical blog post, we will briefly introduce Tezos RPCs through
  a simple example: we will show how the tezos-client program interacts with the tezos-node
  during a transfer command. Tezos RPCs are HTTP queries (GET or POST) to which tezos-node
  replies in JSON format. They are the only way f...'
url: https://ocamlpro.com/blog/2018_11_15_an-introduction_to_tezos_rpcs_a_basic_wallet
date: 2018-11-15T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Fabrice Le Fessant\n  "
source:
---

<p>In this technical blog post, we will briefly introduce Tezos RPCs
through a simple example: we will show how the <code>tezos-client</code> program
interacts with the <code>tezos-node</code> during a <code>transfer</code> command. Tezos RPCs
are HTTP queries (<code>GET</code> or <code>POST</code>) to which <code>tezos-node</code> replies in JSON
format. They are the only way for wallets to interact with the
node. However, given the large number of RPCs accepted by the node, it
is not always easy to understand which ones can be useful if you want
to write a wallet. So, here, we use <code>tezos-client</code> as a simple example,
that we will complete in another blog post for wallets that do not
have access to the Tezos Protocol OCaml code.</p>
<p>As for the basic setup, we run a sandboxed node locally on port 9731,
with two known addresses in its wallet, called bootstrap1 and
bootstrap2.</p>
<p>Here is the command we are going to trace during this example:</p>
<pre><code class="language-shell-session">tezos-client --addr 127.0.0.1 --port 9731 -l transfer 100 from bootstrap1 to bootstrap2
</code></pre>
<p>With this command, we send just 100 tezzies between the two accounts,
paying only for the default fees (0.05 tz).</p>
<p>We use the <code>-l</code> option to request <code>tezos-client</code> to log all the RPC
calls it uses on the standard error (the console).</p>
<p>The first query issued by <code>tezos-client</code> is:</p>
<pre><code>&gt;&gt;&gt;&gt;0: http://127.0.0.1:9731/chains/main/blocks/head/context/contracts/tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx/counter
&lt;&lt;&lt;&lt;0: 200 OK
&quot;2&quot;
</code></pre>
<p><code>tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx</code> is the Tezos address
corresponding to bootstrap1 the payer of the operation. In Tezos, the
payer is the address responsible for paying the fees and burn
(storage) of the transaction. In our case, it is also the source of
the transfer. Here, <code>tezos-client</code> requests the counter of the payer,
because all operations must have a different counter. This is an
important feature, here, it will prevent bootstrap2 from sending the
same operation over and over, emptying the account of bootstrap1.</p>
<p>Here, the counter is 2, probably because we already issued some former operations, so the next operation should have a counter of 3. The request is done on the block head of the main chain, an alias for the last block baked on the chain.</p>
<p>The next query is:</p>
<pre><code class="language-json">&gt;&gt;&gt;&gt;1: http://127.0.0.1:9731/chains/main/blocks/head/context/contracts/tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx/manager_key
&lt;&lt;&lt;&lt;1: 200 OK
{ &quot;manager&quot;: &quot;tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx&quot;,
  &quot;key&quot;: &quot;edpkuBknW28nW72KG6RoHtYW7p12T6GKc7nAbwYX5m8Wd9sDVC9yav&quot; }
</code></pre>
<p>This time, the client requests the key of the account manager. For a keyhash address (tz&hellip;), the manager is always itself, but this query is needed to know if the public key of the manager has been revealed. Here, the key field contains a public key, which means a revelation operation has already been published. Otherwise, the client would have had to also create this revelation operation prior to the transfer (or together, actually). The revelation is mandatory, because all the nodes need to know the public key of the manager to validate the signature of the transfer.</p>
<p>Let&rsquo;s see the next query:</p>
<pre><code class="language-json">&gt;&gt;&gt;&gt;2: http://127.0.0.1:9731/monitor/bootstrapped
&lt;&lt;&lt;&lt;2: 200 OK
{ &quot;block&quot;: &quot;BLyypN89WuTQyLtExGP6PEuZiu5WFDxys3GTUf7Vz4KvgKcvo2E&quot;,
  &quot;timestamp&quot;: &quot;2018-10-13T00:32:47Z&quot; }
</code></pre>
<p>This time, the client checks whether the node it is using is well connected to the network. A node is bootstrapped if it has enough connections to other nodes, and its chain is synchronized with them. This step is needed to prevent the operation from being sent on an obsolete fork of the chain.</p>
<p>Now, the next query requests the current configuration of the network.</p>
<pre><code class="language-json">&gt;&gt;&gt;&gt;3: http://127.0.0.1:9731/chains/main/blocks/head/context/constants
&lt;&lt;&lt;&lt;3: 200 OK
{ &quot;proof_of_work_nonce_size&quot;: 8,
  &quot;nonce_length&quot;: 32,
  &quot;max_revelations_per_block&quot;: 32,
  &quot;max_operation_data_length&quot;: 16384,
  &quot;preserved_cycles&quot;: 5,
  &quot;blocks_per_cycle&quot;: 4096,
  &quot;blocks_per_commitment&quot;: 32,
  &quot;blocks_per_roll_snapshot&quot;: 512,
  &quot;blocks_per_voting_period&quot;: 32768,
  &quot;time_between_blocks&quot;: [ &quot;60&quot;, &quot;75&quot; ],
  &quot;endorsers_per_block&quot;: 32, 
  &quot;hard_gas_limit_per_operation&quot;: &quot;400000&quot;,
  &quot;hard_gas_limit_per_block&quot;: &quot;4000000&quot;,
  &quot;proof_of_work_threshold&quot;: &quot;-1&quot;,
  &quot;tokens_per_roll&quot;: &quot;10000000000&quot;,
  &quot;michelson_maximum_type_size&quot;: 1000,
  &quot;seed_nonce_revelation_tip&quot;: &quot;125000&quot;,
  &quot;origination_burn&quot;: &quot;257000&quot;,
  &quot;block_security_deposit&quot;: &quot;512000000&quot;,
  &quot;endorsement_security_deposit&quot;: &quot;64000000&quot;, 
  &quot;block_reward&quot;: &quot;16000000&quot;,
  &quot;endorsement_reward&quot;: &quot;2000000&quot;,
  &quot;cost_per_byte&quot;: &quot;1000&quot;,
  &quot;hard_storage_limit_per_operation&quot;: &quot;60000&quot;
}
</code></pre>
<p>These constants may differ for different protocols, or different
networks. They are for example different on mainnet, alphanet and
zeronet. Among these constants, some of them are useful when issuing a
transaction: mainly <code>hard_gas_limit_per_operation</code> and
<code>hard_storage_limit_per_operation</code> . The first one is the maximum gas
that can be set for a transaction, and the second one is the maximum
storage that can be used. We don&rsquo;t plan to use them directly, but we
will use them to compute an approximation of the gas and storage that
we will set for the transaction.</p>
<pre><code class="language-json">&gt;&gt;&gt;&gt;4: http://127.0.0.1:9731/chains/main/blocks/head/hash
&lt;&lt;&lt;&lt;4: 200 OK
&quot;BLyypN89WuTQyLtExGP6PEuZiu5WFDxys3GTUf7Vz4KvgKcvo2E&quot;
</code></pre>
<p>This query is a bit redundant with the <code>/monitor/bootstrapped</code> query,
which already returned the last block baked on the chain. Anyway, it
is useful if we are not working on the main chain.</p>
<p>The next query requests the chain_id of the main chain, which is
typically useful to verify that we know the format of operations for
this chain id:</p>
<pre><code class="language-json">&gt;&gt;&gt;&gt;5: http://127.0.0.1:9731/chains/main/chain_id
&lt;&lt;&lt;&lt;5: 200 OK
&quot;NetXdQprcVkpaWU&quot;
</code></pre>
<p>Finally, the client tries to simulate the transaction, using the
maximal gas and storage limits requested earlier. Since it is in
simulation mode, the transaction is only ran locally on the node, and
immediately backtracked. It is used to know if the transactions
executes successfully, and to know the gas and storage actually used
(to avoid paying fees for an erroneous transaction) :</p>
<pre><code class="language-json">&gt;&gt;&gt;&gt;6: http://127.0.0.1:9731/chains/main/blocks/head/helpers/scripts/run_operation
{ &quot;branch&quot;: &quot;BLyypN89WuTQyLtExGP6PEuZiu5WFDxys3GTUf7Vz4KvgKcvo2E&quot;,
  &quot;contents&quot;: [
    { &quot;kind&quot;: &quot;transaction&quot;,
      &quot;source&quot;: &quot;tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx&quot;,
      &quot;fee&quot;: &quot;50000&quot;,
      &quot;counter&quot;: &quot;3&quot;,
      &quot;gas_limit&quot;: &quot;400000&quot;,
      &quot;storage_limit&quot;: &quot;60000&quot;,
      &quot;amount&quot;: &quot;100000000&quot;,
      &quot;destination&quot;: &quot;tz1gjaF81ZRRvdzjobyfVNsAeSC6PScjfQwN&quot; } 
    ],
  &quot;signature&quot;:
    &quot;edsigtXomBKi5CTRf5cjATJWSyaRvhfYNHqSUGrn4SdbYRcGwQrUGjzEfQDTuqHhuA8b2d8NarZjz8TRf65WkpQmo423BtomS8Q&quot;
}
</code></pre>
<p>The operation is related to a branch, and you can see that the branch
field is here set to the hash of the last block head. The branch field
is used to prevent an operation from being executed on an alternative
head, and also for garbage collection: an operation can be inserted
only in one of the 64 blocks after the branch block, or it will be
deleted.</p>
<p>The result looks like this:</p>
<pre><code class="language-json">&lt;&lt;&lt;&lt;6: 200 OK
{ &quot;contents&quot;: [ 
    { &quot;kind&quot;: &quot;transaction&quot;,
      &quot;source&quot;: &quot;tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx&quot;,
      &quot;fee&quot;: &quot;50000&quot;,
      &quot;counter&quot;: &quot;3&quot;,
      &quot;gas_limit&quot;: &quot;400000&quot;,
      &quot;storage_limit&quot;: &quot;60000&quot;,
      &quot;amount&quot;: &quot;100000000&quot;,
      &quot;destination&quot;: &quot;tz1gjaF81ZRRvdzjobyfVNsAeSC6PScjfQwN&quot;,
      &quot;metadata&quot;: { 
        &quot;balance_updates&quot;: [ 
         { &quot;kind&quot;: &quot;contract&quot;,
           &quot;contract&quot;: &quot;tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx&quot;,
           &quot;change&quot;: &quot;-50000&quot; },
         { &quot;kind&quot;: &quot;freezer&quot;, 
           &quot;category&quot;: &quot;fees&quot;,
           &quot;delegate&quot;: &quot;tz1Ke2h7sDdakHJQh8WX4Z372du1KChsksyU&quot;,
           &quot;level&quot;: 0, 
           &quot;change&quot;: &quot;50000&quot; } 
          ],
        &quot;operation_result&quot;:
          { &quot;status&quot;: &quot;applied&quot;,
            &quot;balance_updates&quot;: [
             { &quot;kind&quot;: &quot;contract&quot;,
               &quot;contract&quot;: &quot;tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx&quot;,
               &quot;change&quot;: &quot;-100000000&quot; },
             { &quot;kind&quot;: &quot;contract&quot;,
               &quot;contract&quot;: &quot;tz1gjaF81ZRRvdzjobyfVNsAeSC6PScjfQwN&quot;,
               &quot;change&quot;: &quot;100000000&quot; } 
             ], 
        &quot;consumed_gas&quot;: &quot;100&quot; } } } 
   ] 
}
</code></pre>
<p>Notice the consumed_gas field in the metadata section, that&rsquo;s the gas
that we can expect the transaction to use on the real chain. Here,
there is no storage consumed, otherwise, a storage_size field would be
present. The returned status is applied, meaning that the transaction
could be successfully simulated by the node.</p>
<p>However, in the query, there was a field that we cannot easily infer:
it is the signature field. Indeed, the <code>tezos-client</code> knows how to
generate a signature for the transaction, knowing the public/private
key of the manager. How can we do that in our wallet ? We will explain
that in a next Tezos blog post.</p>
<p>Again, the <code>tezos-client</code> requests the last block head:</p>
<pre><code class="language-json">&gt;&gt;&gt;&gt;7: http://127.0.0.1:9731/chains/main/blocks/head/hash
&lt;&lt;&lt;&lt;7: 200 OK
&quot;BLyypN89WuTQyLtExGP6PEuZiu5WFDxys3GTUf7Vz4KvgKcvo2E&quot;
</code></pre>
<p>and the current chain id:</p>
<pre><code class="language-json">&gt;&gt;&gt;&gt;8: http://127.0.0.1:9731/chains/main/chain_id
&lt;&lt;&lt;&lt;8: 200 OK
&quot;NetXdQprcVkpaWU&quot;
</code></pre>
<p>The last simulation is a prevalidation of the transaction, with the
exact same parameters (gas and storage) with which it will be
submitted on the official blockchain:</p>
<pre><code class="language-json">&gt;&gt;&gt;&gt;9: http://127.0.0.1:9731/chains/main/blocks/head/helpers/preapply/operations
[ { &quot;protocol&quot;: &quot;PsYLVpVvgbLhAhoqAkMFUo6gudkJ9weNXhUYCiLDzcUpFpkk8Wt&quot;,
    &quot;branch&quot;: &quot;BLyypN89WuTQyLtExGP6PEuZiu5WFDxys3GTUf7Vz4KvgKcvo2E&quot;,
    &quot;contents&quot;: [ 
     { &quot;kind&quot;: &quot;transaction&quot;, 
       &quot;source&quot;: &quot;tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx&quot;, 
       &quot;fee&quot;: &quot;50000&quot;,
       &quot;counter&quot;: &quot;3&quot;,
       &quot;gas_limit&quot;: &quot;200&quot;,
       &quot;storage_limit&quot;: &quot;0&quot;,
       &quot;amount&quot;: &quot;100000000&quot;,
       &quot;destination&quot;: &quot;tz1gjaF81ZRRvdzjobyfVNsAeSC6PScjfQwN&quot; 
     } ], 
    &quot;signature&quot;: &quot;edsigu5Cb8WEmUZzoeGSL3sbSuswNFZoqRPq5nXA18Pg4RHbhnFqshL2Rw5QJBM94UxdWntQjmY7W5MqBDMhugLgqrRAWHyH5hD&quot; 
} ]
</code></pre>
<p>Notice that, in this query, the gas_limit was set to
200. <code>tezos-client</code> is a bit conservative, adding 100 to the gas
returned by the first simulation. Indeed, the gas can be different
when the transaction is ran for inclusion, for example if a baker
introduced another transaction before that interferes with this one
(for example, a transaction that empties an account has an additionnal
gas cost of 50).</p>
<pre><code class="language-json">&lt;&lt;&lt;&lt;9: 200 OK
[ { &quot;contents&quot;: [
     { &quot;kind&quot;: &quot;transaction&quot;, 
       &quot;source&quot;: &quot;tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx&quot;,
       &quot;fee&quot;: &quot;50000&quot;,
       &quot;counter&quot;: &quot;3&quot;,
       &quot;gas_limit&quot;: &quot;200&quot;,
       &quot;storage_limit&quot;: &quot;0&quot;,
       &quot;amount&quot;: &quot;100000000&quot;,
       &quot;destination&quot;: &quot;tz1gjaF81ZRRvdzjobyfVNsAeSC6PScjfQwN&quot;,
       &quot;metadata&quot;: { 
         &quot;balance_updates&quot;: [ 
          { &quot;kind&quot;: &quot;contract&quot;,
            &quot;contract&quot;: &quot;tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx&quot;,
            &quot;change&quot;: &quot;-50000&quot; },
          { &quot;kind&quot;: &quot;freezer&quot;,
            &quot;category&quot;: &quot;fees&quot;,
            &quot;delegate&quot;: &quot;tz1Ke2h7sDdakHJQh8WX4Z372du1KChsksyU&quot;,
            &quot;level&quot;: 0,
            &quot;change&quot;: &quot;50000&quot; } ],
         &quot;operation_result&quot;: 
          { &quot;status&quot;: &quot;applied&quot;,
            &quot;balance_updates&quot;: [ 
             { &quot;kind&quot;: &quot;contract&quot;,
               &quot;contract&quot;: &quot;tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx&quot;,
               &quot;change&quot;: &quot;-100000000&quot; },
             { &quot;kind&quot;: &quot;contract&quot;,
               &quot;contract&quot;: &quot;tz1gjaF81ZRRvdzjobyfVNsAeSC6PScjfQwN&quot;,
               &quot;change&quot;: &quot;100000000&quot; } ],
         &quot;consumed_gas&quot;: &quot;100&quot; } 
     } } ], 
    &quot;signature&quot;: &quot;edsigu5Cb8WEmUZzoeGSL3sbSuswNFZoqRPq5nXA18Pg4RHbhnFqshL2Rw5QJBM94UxdWntQjmY7W5MqBDMhugLgqrRAWHyH5hD&quot;
 } ]
</code></pre>
<p>Again, the <code>tezos-client</code> had to sign the transaction with the manager
private key. This will be explained in a next blog post.</p>
<p>Since this prevalidation was successful, the client can now inject the
transaction on the block chain:</p>
<pre><code class="language-json">&gt;&gt;&gt;&gt;10: http://127.0.0.1:9731/injection/operation?chain=main
&quot;a75719f568f22f279b42fa3ce595c5d4d0227cc8cf2af351a21e50d2ab71ab3208000002298c03ed7d454a101eb7022bc95f7e5f41ac78d0860303c8010080c2d72f0000e7670f32038107a59a2b9cfefae36ea21f5aa63c00eff5b0ce828237f10bab4042a891d89e951de2c5ad4a8fa72e9514ee63fec9694a772b563bcac8ae0d332d57f24eae7d4a6fad784a8436b6ba03d05bf72e4408&quot;
&lt;&lt;&lt;&lt;10: 200 OK
&quot;ooUo7nUZAbZKhTuX5NC999BuHs9TZBmtoTrCWT3jFnW7vMdN25U&quot;
</code></pre>
<p>We can see that this request does not contain the JSON encoding of the
transaction, but a binary version (in hexadecimal format). This binary
version is what is stored in the blockchain, to decrease the size of
the storage. It contains both a binary encoding of the transaction,
and the signature of the transaction. <code>tezos-client</code> knows this binary
format, but if we want to create our own wallet, we will need a way to
compute it by ourselves.</p>
<p>The node replies with the operation hash of the injected operation:
the operation is now waiting for inclusion in the mempool of the node,
and will be forwarded to other nodes so that the next baker can
include it in the next block.</p>
<p>I hope you have now a better understanding of how a wallet can use
Tezos RPCs to issue a transaction. We now have two remaining
questions, for a next blog post:</p>
<p>How to generate the binary format of an operation, from the JSON
encoding ?  How to sign an operation, so that we can include this
signature in the run, preapply and injection RPCs ?</p>
<p>If we can reply to these questions, we will also be able to sign
operations offline.</p>
<h1>Comments</h1>
<p>lizhihohng (5 May 2019 at 6 h 59 min):</p>
<blockquote>
<p>Before forge or sign a transaction, how to get a gas or gas limit, not a hard gas limit from contants?</p>
</blockquote>
<p>Juliane (16 November 2019 at 15 h 29 min):</p>
<blockquote>
<p>Good answer back in return of this difficulty with solid arguments and explaining all on the topic of that.</p>
</blockquote>


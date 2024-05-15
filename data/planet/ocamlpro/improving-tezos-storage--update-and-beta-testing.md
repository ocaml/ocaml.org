---
title: 'Improving Tezos Storage : update and beta-testing'
description: In a previous post, we presented some work that we did to improve the
  quantity of storage used by the Tezos node. Our post generated a lot of comments,
  in which upcoming features such as garbage collection and pruning were introduced.
  It also motivated us to keep working on this (hot) topic, and we ...
url: https://ocamlpro.com/blog/2019_01_30_improving_tezos_storage_update_and_beta_testing
date: 2019-01-30T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Fabrice Le Fessant\n  "
source:
---

<p>In a <a href="http://ocamlpro.com/2019/01/15/improving-tezos-storage/">previous post</a>, we
presented some work that we did to improve the quantity of storage
used by the Tezos node. Our post generated a lot of comments, in which
upcoming features such as garbage collection and pruning were
introduced. It also motivated us to keep working on this (hot) topic,
and we present here our new results, and current state. Irontez3 is a
new version of our storage system, that we tested both on real traces
and real nodes. We implemented a garbage-collector for it, that is
triggered by an RPC on our node (we want the user to be able to choose
when it happens, especially for bakers who might risk losing a baking
slot), and automatically every 16 cycles in our traces.</p>
<p>In the following graph, we present the size of the context database
during a full trace execution (~278 000 blocks):</p>
<p><img src="https://ocamlpro.com/blog/assets/img/plot_sizes-2.png" alt="plot_size-2.png"/></p>
<p>There is definitely quite some improvement brought to the current
Tezos implementation based on Irmin+LMDB, that we reimplemented as
IronTez0. IronTez0 allows an IronTez node to read a database generated
by the current Tezos and switch to the IronTez3 database. At the
bottom of the graph, IronTez3 increases very slowly (about 7 GB at the
end), and the garbage-collector makes it even less expensive (about
2-3 GB at the end). Finally, we executed a trace where we switched
from IronTez0 to IronTez3 at block 225 000. The graph shows that,
after the switch, the size immediately grows much more slowly, and
finally, after a garbage collection, the storage is reduced to what it
would have been with IronTez3.</p>
<p>Now, let&rsquo;s compare the speed of the different storages:</p>
<p><img src="https://ocamlpro.com/blog/assets/img/plot_times-2.png" alt="plot_times-2.png"/></p>
<p>The graph shows that IronTez3 is about 4-5 times faster than
Tezos/IronTez0. Garbage-collections have an obvious impact on the
speed, but clearly negligible compared to the current performance of
Tezos. On our computer used for the traces, a Xeon with an SSD disk,
the longest garbage collection takes between 1 and 2 minutes, even
when the database was about 40 GB at the beginning.</p>
<p>In the former post, we didn&rsquo;t check the amount of memory used by our
storage system. It might be expected that the performance improvement
could be associated with a more costly use of memory&hellip; but such is not
the case :</p>
<p><img src="https://ocamlpro.com/blog/assets/img/plot_mem.png" alt="plot_mem.png"/></p>
<p>At the top of the graph is our IronTez0 implementation of the current
storage: it uses a little more memory than the current Tezos
implementation (about 6 GB), maybe because it shares data structures
with IronTez3, with fields that are only used by IronTez3 and could be
removed in a specialized version. IronTez3 and IronTez3 with garbage
collection are at the bottom, using about 2 GB of memory. It is
actually surprising that the cost of garbage collections is very
limited.</p>
<p>On our current running node, we get the following storage:</p>
<pre><code class="language-shell-session">$ du

1.4G ./context
4.9G ./store
6.3G .
</code></pre>
<p>Now, if we use our new RPC to revert the node to Irmin (taking a little less than 8 minutes on our computer), we get :</p>
<pre><code class="language-shell-session">$ du
14.3G ./context
 4.9G ./store
19.2G .
</code></pre>
<h2>Beta-Testing with Docker</h2>
<p>If you are interested in these results, it is now possible to test our
node: we created a docker image, similar to the ones of Tezos. It is
available on Docker Hub (one image that works for both Mainnet and
Alphanet). Our script mainnet.sh (http://tzscan.io/irontez/mainnet.sh)
can be used similarly to the alphanet.sh script of Tezos to manage the
container. It can be run on an existing Tezos database, it will switch
it to IronTez3. Note that such a change is not irreversible, still it
might be a good idea to backup your Tezos node directory before, as
(1) migrating back might take some time, (2) this is a beta-testing
phase, meaning the code might still hide nasty bugs, and (3) the
official node might introduce a new incompatible format.</p>
<h2>New RPCS</h2>
<p>Both of these RPCs will make the node TERMINATE once they have
completed. You should restart the node afterwards.</p>
<p>The RPC <code>/ocp/storage/gc</code> : it triggers a garbage collection using the
RPC <code>/ocp/storage/gc</code> . By default, this RPC will keep only the
contexts from the last 9 cycles. It is possible to change this value
by using the ?keep argument, and specify another number of contexts to
keep (beware that if this value is too low, you might end up with a
non-working Tezos node, so we have set a minimum value of 100). No
garbage-collection will happen if the oldest context to keep was
stored in the Irmin database.  The RPC <code>/ocp/storage/revert</code> : it
triggers a migration of the database fron Irontez3 back to Irmin. If
you have been using IronTez for a while, and want to go back to the
official node, this is the way. After calling this RPC, you should not
run IronTez again, otherwise, it will restart using the IronTez3
format, and you will need to revert again. This operation can take a
lot of time, depending on the quantity of data to move between the two
formats.</p>
<h2>Following Steps</h2>
<p>We are now working with the team at Nomadic Labs to include our work
in the public Tezos code base. We will inform you as soon as our Pull
Request is ready, for more testing ! If all testing and review goes
well, we hope it can be merged in the next release !</p>
<h1>Comments</h1>
<p>Jack (30 January 2019 at 15 h 30 min):</p>
<blockquote>
<p>Please release this as a MR on gitlab so those of us not using docker can start testing the code.</p>
</blockquote>
<p>Fabrice Le Fessant (10 February 2019 at 15 h 39 min):</p>
<blockquote>
<p>That was done: <a href="https://ocamlpro.com/2019/02/04/improving-tezos-storage-gitlab-branch-for-testers/">here</a></p>
</blockquote>


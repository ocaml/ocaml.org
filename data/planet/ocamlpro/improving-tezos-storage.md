---
title: Improving Tezos Storage
description: Running a Tezos node currently costs a lot of disk space, about 59 GB
  for the context database, the place where the node stores the states corresponding
  to every block in the blockchain, since the first one. Of course, this is going
  to decrease once garbage collection is integrated, i.e. removing ve...
url: https://ocamlpro.com/blog/2019_01_15_improving_tezos_storage
date: 2019-01-15T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Fabrice Le Fessant\n  "
source:
---

<p>Running a Tezos node currently costs a lot of disk space, about 59 GB
for the context database, the place where the node stores the states
corresponding to every block in the blockchain, since the first
one. Of course, this is going to decrease once garbage collection is
integrated, i.e. removing very old information, that is not used and
cannot change anymore
(<a href="https://gitlab.com/tezos/tezos/merge_requests/720#note_125296853">PR720</a>
by Thomas Gazagnaire, Tarides, some early tests show a decrease to
14GB ,but with no performance evaluation). As a side note, this is
different from pruning, i.e. transmitting only the last cycles for
&ldquo;light&rdquo; nodes
(<a href="https://gitlab.com/tezos/tezos/merge_requests/663">PR663</a> by Thomas
Blanc, OCamlPro). Anyway, as Tezos will be used more and more,
contexts will keep growing, and we need to keep decreasing the space
and performance cost of Tezos storage.</p>
<p>As one part of our activity at OCamlPro is to allow companies to
deploy their own private Tezos networks, we decided to experiment with
new storage layouts. We implemented two branches: our branch
<code>IronTez1</code> is based on a full LMDB database, as Tezos currently, but
with optimized storage representation ; our branch <code>IronTez2</code> is based
on a mixed database, with both LMDB and file storage.</p>
<p>To test these branches, we started a node from scratch, and recorded
all the accesses to the context database, to be able to replay it with
our new experimental nodes. The node took about 12 hours to
synchronize with the network, on which about 3 hours were used to
write and read in the context database. We then replayed the trace,
either only the writes or with both reads and writes.</p>
<p>Here are the results:</p>
<p><img src="https://ocamlpro.com/blog/assets/img/plot_sizes.png" alt="plot_sizes.png"/></p>
<p>The mixed storage is the most interesting: it uses half the storage of a standard Tezos node !</p>
<p><img src="https://ocamlpro.com/blog/assets/img/plot_times-1.png" alt="plot_times-1.png"/></p>
<p>Again, the mixed storage is the most efficient : even with reads and
writes, <code>IronTez2</code> is five time faster than the current Tezos storage.</p>
<p>Finally, here is a graph that shows the impact of the two attacks that
happened in November 2018, and how it can be mitigated by storage
improvement:</p>
<p><img src="https://ocamlpro.com/blog/assets/img/plot_diffs.png" alt="plot_diffs.png"/></p>
<p>The graph shows that, using mixed storage, it is possible to restore the storage growth of Tezos to what it was before the attack !</p>
<p>Interestingly, although these experiments have been done on full traces, our branches are completely backward-compatible : they could be used on an already existing database, to store the new contexts in our optimized format, while keeping the old data in the ancient format.</p>
<p>Of course, there is still a lot of work to do, before this work is finished. We think that there are still more optimizations that are possible, and we need to test our branches on running nodes for some time to get confidence (TzScan might be the first tester !), but this is a very encouraging work for the future of Tezos !</p>


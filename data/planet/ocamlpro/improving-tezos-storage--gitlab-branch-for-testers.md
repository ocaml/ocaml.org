---
title: 'Improving Tezos Storage : Gitlab branch for testers'
description: This article is the third post of a series of posts on improving Tezos
  storage. In our previous post, we announced the availability of a docker image for
  beta testers, wanting to test our storage and garbage collector. Today, we are glad
  to announce that we rebased our code on the latest version of ...
url: https://ocamlpro.com/blog/2019_02_04_improving_tezos_storage_gitlab_branch_for_testers
date: 2019-02-04T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Fabrice Le Fessant\n  "
source:
---

<p>This article is the third post of a series of posts on improving Tezos
storage. In <a href="http://ocamlpro.com/2019/01/30/improving-tezos-storage-update-and-beta-testing/">our previous
post</a>,
we announced the availability of a docker image for beta testers,
wanting to test our storage and garbage collector. Today, we are glad
to announce that we rebased our code on the latest version of
<code>mainnet-staging</code>, and pushed a branch <code>mainnet-staging-irontez</code> on our
<a href="https://gitlab.com/tzscan/tezos/commits/mainnet-staging-irontez">public Gitlab
repository</a>.</p>
<p>The only difference with the previous post is a change in the name of
the RPCs : <code>/storage/context/gc</code> will trigger a garbage collection
(and terminate the node afterwards) and <code>/storage/context/revert</code> will
migrate the database back to Irmin (and terminate the node
afterwards).</p>
<p>Enjoy and send us feedback !!</p>
<h1>Comments</h1>
<p>AppaDude (10 February 2019 at 15 h 12 min):</p>
<blockquote>
<p>I must be missing something. I compiled and issued the required rpc trigger:</p>
<p>/storage/context/gc with the command</p>
<p>~/tezos/tezos-client rpc get /storage/context/gc
But I just got an empty JSON response of {} and the size of the .tezos-node folder is unchanged. Any advice is much appreciated.
Thank you!</p>
</blockquote>
<p>Fabrice Le Fessant (10 February 2019 at 15 h 47 min):</p>
<blockquote>
<p>By default, garbage collection will keep 9 cycles of blocks (~36000 blocks). If you have fewer blocks, or if you are using Irontez on a former Tezos database, and fewer than 9 cycles have been stored in Irontez, nothing will happen. If you want to force a garbage collection, you should tell Irontez to keep fewer block (but more than 100, that&rsquo;s the minimum that we enforce):</p>
<p>~/tezos/tezos-client rpc get &lsquo;/storage/context/gc?keep=120&rsquo;</p>
<p>should trigger a GC if the node has been running on Irontez for at least 2 hours.</p>
</blockquote>
<p>AppaDude (10 February 2019 at 16 h 04 min):</p>
<blockquote>
<p>I think it did work. I was confused because the total disk space for the .tezos-node folder remained unchanged. Upon closer inspection, I see these contents and sizes:</p>
<p>These are the contents of .tezos-node, can I safely delete context.backup?</p>
<p>4.0K config.json
269M context
75G context.backup
4.0K identity.json
4.0K lock
1.4M peers.json
5.4G store
4.0K version.json</p>
</blockquote>
<blockquote>
<p>Is it safe to delete context.backup if I do not plan to revert? (/storage/context/revert)</p>
</blockquote>
<p>Fabrice Le Fessant (10 February 2019 at 20 h 51 min):</p>
<blockquote>
<p>Yes, normally. Don&rsquo;t forget it is still under beta-testing&hellip;</p>
<p>Note that <code>/storage/context/revert</code> works even if you remove <code>context.backup</code>.</p>
</blockquote>
<p>Jack (23 February 2019 at 0 h 24 min):</p>
<blockquote>
<p>Have there been any issues reported with missing endorsements or missing bakings with this patch? We have been using this gc version (https://gitlab.com/tezos/tezos/merge_requests/720) for the past month and ever since we switched we have been missing endorsements and missing bakings. The disk space savings is amazing, but if we keep missing ends/bakes, it&rsquo;s going to hurt our reputation as a baking service.</p>
</blockquote>
<p>Fabrice Le Fessant (23 February 2019 at 6 h 58 min):</p>
<blockquote>
<p>Hi,</p>
<p>I am not sure what you are asking for. Are you using our version (https://gitlab.com/tzscan/tezos/commits/mainnet-staging-irontez), or the one on the Tezos repository ? Our version is very different, so if you are using the other one, you should contact them directly on the merge request. On our version, we got a report last week, and the branch has been fixed immediately (but not yet the docker images, should be done in the next days).</p>
</blockquote>
<p>Jack (25 February 2019 at 15 h 53 min):</p>
<blockquote>
<p>I was using the 720MR and experiencing issues with baking/endorsing. I understand that 720MR and IronTez are different. I was simply asking if your version has had any reports of baking/endorsing troubles.</p>
</blockquote>
<p>Jack (25 February 2019 at 15 h 51 min):</p>
<blockquote>
<p>Is there no way to convert a &ldquo;standard node&rdquo; to IronTez? I was running the official tezos-node, and my datadir is around 90G. I compiled IronTez and started it up on that same dir, then ran <code>rpc get /storage/context/gc</code> and nothing is happening. I thought this was supposed to convert my datadir to irontez? If not, what is the RPC to do this? Or must I start from scratch to be 100% irontez?</p>
</blockquote>
<p>Fabrice Le Fessant (25 February 2019 at 16 h 24 min):</p>
<blockquote>
<p>There are two ways to get a full Irontez DB:</p>
<ul>
<li>Start a node from scratch and wait for one or two days&hellip;
</li>
<li>Use an existing node, run Irontez on it for 2 hours, and then call <code>rpc get /storage/context/gc?keep=100</code> . 100 is the number of blocks to be kept. After 2 hours, the last 120 blocks should be stored in the IronTez DB, so the old DB will not be used anymore. Note that Irontez will not delete the old DB, just rename it. You should go there and remove the file to recover the disk space.
</li>
</ul>
</blockquote>
<p>Jack (27 February 2019 at 1 h 24 min):</p>
<blockquote>
<p>Where do we send feedback/get help? Email? Slack? Reddit?</p>
</blockquote>
<p>Banjo E. (3 March 2019 at 2 h 40 min):</p>
<blockquote>
<p>There is a major problem for bakers who want to use the irontez branch. After garbage collection, the baker application will not start because the baker requests a rpc call for the genesis block information. That genesis block information is gone after the garbage collection. Please address this isssue soon. Thank you!</p>
</blockquote>
<p>Fabrice Le Fessant (6 March 2019 at 21 h 44 min):</p>
<blockquote>
<p>I pushed a new branch with a tentative fix: https://gitlab.com/tzscan/tezos/tree/mainnet-staging-irontez-fix-genesis . Unfortunately, I could not test it (I am far away from work for two weeks), so feedback is really welcome, before pushing in the irontez branch.</p>
</blockquote>


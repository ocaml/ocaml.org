---
title: 'Lightning Fast with Irmin: Tezos Storage is 6x faster with 1000 TPS surpassed'
description: "Over the last year, the Tarides\nstorage team has been focused on scaling
  the storage layer of Octez,\nthe most popular node implementation\u2026"
url: https://tarides.com/blog/2022-04-26-lightning-fast-with-irmin-tezos-storage-is-6x-faster-with-1000-tps-surpassed
date: 2022-04-26T00:00:00-00:00
preview_image: https://tarides.com/static/efce619e39c2a72fb0b935be481a220b/0132d/banner.jpg
featured:
authors:
- Tarides
source:
---

<p>Over the last year, the Tarides
storage team has been focused on scaling the storage layer of <a href="https://tezos.gitlab.io/">Octez</a>,
the most popular node implementation for the <a href="https://tezos.com/">Tezos</a> blockchain. With
the upcoming release of Octez v13, we are reaching our performance goal of
<strong>supporting one thousand transactions per second</strong> (TPS) in the
storage layer! This is a <strong>6x improvement</strong> over Octez 10. Even better, this
release also <strong>makes the storage layer orders of magnitude more stable</strong>,
with a <strong>12x improvement in the mean latency of operations</strong>. At the
same time, we <strong>reduced the memory usage by 80%</strong>.
Now Octez requires a mere 400 MB of RAM to bootstrap nodes!</p>
<p>In this post, we'll explain how we achieved these milestones thanks to
<a href="https://irmin.org">Irmin 3</a>, the new major release of the <a href="https://mirage.io">MirageOS</a>-compatible
storage layer developed and maintained by Tarides and used by Tezos.
We'll also explain what this means for the Tezos community now and
in the future.</p>
<p>As explained by a <a href="https://research-development.nomadic-labs.com/tps-evaluation.html">recent post on Nomadic Labs
blog</a>,
there are various ways to evaluate the throughput of Tezos. Our
purpose is to optimise the Tezos storage and identify and fix
bottlenecks. Thus, our benchmarking setup replays actual data (the
150k first blocks of the Hangzhou Protocol on Tezos Mainnet,
corresponding to the period Dec 2021 &ndash; Jan 2022) and explicitly
excludes the networking I/O operations and protocol computations to
focus on the context I/O operations only. Thanks to this setup we
managed to identify, fix, and verify that we removed the main
I/O bottlenecks present in Octez:</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/f859bd5c186c91df46c59f296d8f40b6/58a91/transactions_per_second.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 68.23529411764706%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAOCAYAAAAvxDzwAAAACXBIWXMAAC4jAAAuIwF4pT92AAACOElEQVR42rWSX0hTcRTHj7lnTROikAKJcGEuFfpnKr3FNP+8RRTSiyRp9WBlIAkF0UNEhBkEvRhBSC8pBFmjKCgwl3NDdGkoy7vNXb129Tf7bff+7jd2r1uyRVTUgS/n/M45v8/v8OMQERGALAAb+vv7s7u7X9ks3236RD6pxDld6+pZlGk1NqLtG4mKcol25BDl5xDl5RJtKSAqzCfaWWDVEkrUtm4ioux0im3gxdttnPM6xplTVVmdyiwxzmvdo5Mn3rwfPTXsHj/5bmSsWVHVoxyoZUCdAtQzrjk55/XLy9yeIsqy0gDLBDLNSBOMqAp59jO+ySFA6Ppa380UUJLkxkRG13UhhMAvZQBK7xlIZysQ7jwMPjdlAoUW+3vg4p0WhNocCHdUgn/xZwJlWan/I2DPaYTayxC+WA0+9ykTGAiEm/4pUFZUc8IETTcvGdCFAcMwIIQV68kc1gOrEJN+8ofhsNyQnNCE6BpgwsQaVIPQ41b8OxNK0kJTcm2Gxpdw3xXAk5EFaLqBqQjHjWcSrg0E4JpYNpuW7rYicq4ccmc14sFpa22E9gMYiSw6NS0u4vH4ypFbPlbY8YHZu9xs/utqdMi3EC29Mrqyq+sju/p0lgGIzt9uiQbbylaCF6rYasBvvqLFYtdTwN7eR3kej6fE7/fba7sGHUXH71VWnH9c7vVOFvcNDpccaO07uLf94f5LD1wOaWam+OXlY6U9jfsOPW+u2eN7PWQfm5jY7fV6N9P/sO8HOc+Go2/nugAAAABJRU5ErkJggg=='); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/f859bd5c186c91df46c59f296d8f40b6/c5bb3/transactions_per_second.png" class="gatsby-resp-image-image" alt="Bar chart of mean transactions per second for various Irmin
configurations" title="" srcset="/static/f859bd5c186c91df46c59f296d8f40b6/04472/transactions_per_second.png 170w,
/static/f859bd5c186c91df46c59f296d8f40b6/9f933/transactions_per_second.png 340w,
/static/f859bd5c186c91df46c59f296d8f40b6/c5bb3/transactions_per_second.png 680w,
/static/f859bd5c186c91df46c59f296d8f40b6/b12f7/transactions_per_second.png 1020w,
/static/f859bd5c186c91df46c59f296d8f40b6/b5a09/transactions_per_second.png 1360w,
/static/f859bd5c186c91df46c59f296d8f40b6/58a91/transactions_per_second.png 1990w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<blockquote>
<p>Comparison of the Transactions Per Second (TPS) performance between Octez 10,
11, 12 and 13 while replaying the 150k
first blocks of the Hangzhou Protocol on Tezos Mainnet<sup><a href="https://tarides.com/feed.xml#fn-1" class="footnote-ref">1</a></sup>.
Octez 13 reaches 1043 TPS on average which is a <strong>6x improvement</strong> over Octez 10.</p>
</blockquote>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#merkle-databases-to-index-or-not-to-index" aria-label="merkle databases to index or not to index permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Merkle databases: to index or not to index</h3>
<p>A Tezos node keeps track of the blockchain state in a database called the
<em>context</em>. For each block observed by the node, the context stores a
corresponding <a href="https://en.wikipedia.org/wiki/Merkle_tree">tree</a> that witnesses the state of the chain at that
block.</p>
<p>Each leaf in the tree contains some data (e.g., the balance of a particular
wallet) which has a unique hash. Together these leaf hashes uniquely determine
the hashes of their parent nodes all the way up to the root hash of the tree.
In the other direction &ndash; moving down the tree from the root &ndash; these hashes form
<em>addresses</em> that allow each node to later be recovered from disk. In the Octez
node, the context is implemented using <a href="https://irmin.org">Irmin</a>, an open-source OCaml
library that solves exactly this problem: storing trees of data in which each
node is addressed by its hash.</p>
<p>As with any database, a crucial aspect of Irmin's implementation is its
<a href="https://en.wikipedia.org/wiki/Database_index">index</a>, the component that maps addresses to data locations
(in this case, mapping hashes to offsets within a large append-only data file).
Indexing each object in the store by hash has some important advantages: for
instance, it ensures that the database is totally
<a href="https://en.wikipedia.org/wiki/Data_deduplication">deduplicated</a> and enables fast random access to any
object in the store, regardless of position in the tree.</p>
<p>As discussed in <a href="https://tarides.com/2020-09-01-introducing-irmin-pack - [404 Not Found]">our <code>irmin-pack</code> post</a>, the context index was
optimised for very fast reads at the cost of needing to perform an expensive
maintenance operation at regular intervals. This design was very effective in
the early months of the Tezos chain, but our <a href="https://tarides.com/2021-10-04-the-new-replaying-benchmark-in-irmin - [404 Not Found]">recent work on benchmarking the
storage layer</a> revealed two problems with it:</p>
<ul>
<li>
<p><strong>content-addressing bottlenecks transaction throughput</strong>. Using hashes as
object addresses adds overhead to both reads and writes: each read requires
consulting the index, and each write requires adding a new entry to it. At
the current block rate and block size in Tezos Mainnet, these overheads are
not a limiting factor, but this will change as the protocol and shell become
faster. Our overall goal is to support a future network throughput of <strong>1000
transactions per second</strong>, and doing this required rethinking our reliance on
the index.</p>
</li>
<li>
<p><strong>maintaining a large index impacts the stability of the node</strong>. The larger
the index becomes, the longer it takes to perform regular maintenance
operations on it. For sufficiently large contexts (i.e., on archive nodes),
the store may be unable to perform this maintenance quickly enough, leading
to long pauses as the node waits for service from the storage layer.
In the context of Tezos, this can lead to users occasionally exceeding the
maximum time allowed for baking or endorsing a block, losing out on the
associated rewards.</p>
</li>
</ul>
<p>Over the last few months, the storage team at Tarides has been hard at work
addressing these issues by switching to a <em>minimal indexing</em> strategy in the
context. This feature is now ready to ship, and we are delighted to present the
results!</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#consistently-fast-transactions-surpassing-the-1000-tps-threshold" aria-label="consistently fast transactions surpassing the 1000 tps threshold permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Consistently fast transactions: surpassing the 1000 TPS threshold</h3>
<p>The latest release of Irmin ships with a <a href="https://github.com/mirage/irmin/pull/1510">new core feature</a>
that enables object addresses that are not hashes. This feature unlocks many
future optimisations for the Octez context, including things like automatic
inlining and layered storage. Crucially, it has allowed us to <a href="https://github.com/mirage/irmin/pull/1659">switch to using
direct pointers</a> between internal objects in the Octez
context, eliminating the need to index such objects entirely! This has two
immediate benefits:</p>
<ul>
<li>
<p><strong>read operations no longer need to search the index</strong>, improving the overall
speed of the storage considerably;</p>
</li>
<li>
<p><strong>the index can be shrunk by a factor of 360</strong> (from 21G to 59MB in our tests!). We now only need to index
<em>commit</em> objects in order to be able to recover the root tree for a given
block at runtime. This &quot;minimal&quot; indexing strategy results in indices that
fit comfortably in memory and don't need costly maintenance. As of Octez 13,
<a href="https://gitlab.com/tezos/tezos/-/merge_requests/4714">minimal indexing is now the default</a> node
behaviour<sup><a href="https://tarides.com/feed.xml#fn-2" class="footnote-ref">2</a></sup>.</p>
</li>
</ul>
<p>So what is the performance impact of this change? As detailed in our <a href="https://tarides.com/2021-10-04-the-new-replaying-benchmark-in-irmin - [404 Not Found]">recent
post on replay benchmarking</a>, we were able to isolate and
measure the consequences of this change by &quot;replaying&quot; a previously-recorded
trace of chain activity against the newly-improved storage layer. This process
simulates a node that is bottlenecked purely by the storage layer, allowing us
to assess its limits independently of the other components of the shell.</p>
<p>For these benchmarks, we used a replay trace containing the first 150,000
blocks of the Hangzhou Protocol deployment on Tezos Mainnet (corresponding to
the period December 2021 &ndash; January 2022)<sup><a href="https://tarides.com/feed.xml#fn-3" class="footnote-ref">3</a></sup>.</p>
<p>One of the most important metrics collected by our benchmarks is overall
throughput, measured in <em>transactions</em> processed per second (TPS). In this
context, a &quot;transaction&quot; is an individual state transition within a particular
block (e.g., a balance transfer or a smart contract activation). We
queried the <a href="https://tzstats.com/docs/api#tezos-api">TzStats API</a> in order to determine the number
of transactions in each block and thus, our measured transaction throughput.
As shown in the graph above, doing this for the last few releases of Octez
reveals that storage TPS has skyrocketted from ~200 in Octez 12 to more than
1000 in Octez 13! &#128640;</p>
<p>As a direct consequence, the total time necessary to replay our Hangzhou trace
on the storage layer has decreased from ~1 day to ~4 hours. We're nearly 6
times faster than before!</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/7d4ca3167883d6cdcafbc1b29a6fecc0/11214/cpu_time.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 70%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAOCAYAAAAvxDzwAAAACXBIWXMAAC4jAAAuIwF4pT92AAACoUlEQVR42rXRX0hTURwH8EMqBGFmNssVwcw0XQQVCbl8VB8c9mQQlE4io+gh6MFmD0sfssDqpQizSS8SDA3/QOayQoxS5p1/pnO62bRyi8jltrvtunPv/cau25zlgy994cf93XPO/XAuP0KiAbCttrYlRafTJet0H5INBiRF1v6uyL7BYEiKVKyP7ZF/c2wHIelphBzYTUh2GiFpuwjZJyNEnkFI7p61PmcnIQfT197zUgnJSCWEbMQApAAoBVBOgXIA6khRyqm/LLrPjYzNaBiL/eJnZqbG4wuc5ShVewNcReTJcpyaUloBQBUHBwY+7QewgrWIwWAI4XAYCRETakNEUeSjrSkOulw+Gc8LEvhy+KdYo5/F5Rd2mJx+6WSY8vB5fdgsm4JGIyPnwlQCtZ0LYuYNE7JujqJ3fBmCIKCx5xu0HU48ef8DoiBIa7HieV4CBUFYBycn5/euRsGG7kXx0C0GefVmGKc88IcoiposON4wgcqnNkDcAjg4aM2KgXe6F0VFHYPDWjP6pzwIcBRlD6dRfM8CTZt9a6DxIyMPcateCexaB99YPGBDYZQ8mIaqyYIqvR2iwIPnKYRoUUolkOf5xKG4ZDQ6lIaer3HQOP0bwbAQB6v19vgwqCBCkOa+yVAcDndmmPLSDRt7v4vZ2nHk3p7AW6tXAksf2XDmvhWatnnpS97twMpIH9jRfvDLriiY8Mtzcy5ZkFt1AwKn63KyijoTm6M1sX2TvwK+ABcoabb4VXcn/FUtVlYAAp6O5sDSVSW7dOUI6xvq8EUuSjluKA5WV+u2MwyTv7AwV3Dt8Tul/EJLkULTdkr/erjAbJ4qOHm9vVB5qVVVVt95YtbpzB971qh8Xll0uv18caHlVWu+1eE4arPZFOR/5A/EW7alDaEAbAAAAABJRU5ErkJggg=='); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/7d4ca3167883d6cdcafbc1b29a6fecc0/c5bb3/cpu_time.png" class="gatsby-resp-image-image" alt="Bar chart of CPU time elapsed during replay for various Irmin configurations" title="" srcset="/static/7d4ca3167883d6cdcafbc1b29a6fecc0/04472/cpu_time.png 170w,
/static/7d4ca3167883d6cdcafbc1b29a6fecc0/9f933/cpu_time.png 340w,
/static/7d4ca3167883d6cdcafbc1b29a6fecc0/c5bb3/cpu_time.png 680w,
/static/7d4ca3167883d6cdcafbc1b29a6fecc0/b12f7/cpu_time.png 1020w,
/static/7d4ca3167883d6cdcafbc1b29a6fecc0/b5a09/cpu_time.png 1360w,
/static/7d4ca3167883d6cdcafbc1b29a6fecc0/11214/cpu_time.png 1943w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<blockquote>
<p>Comparison of CPU time elapsed between Octez 10, 11, 12, and 13 while replaying the 150k
first blocks of the Hangzhou Protocol on Tezos Mainnet<sup><a href="https://tarides.com/feed.xml#fn-1" class="footnote-ref">1</a></sup>. While Octez 10 took 1 day to complete
the replay, Octez 13 only takes 4 hours and is nearly <strong>6 times faster</strong> than
before!</p>
</blockquote>
<p>Overall throughput is not the only important metric, however. It's also
important that the <em>variance</em> of storage performance is kept to a minimum, to
ensure that unrelated tasks such as endorsement can be completed promptly. To
see the impact of this, we can inspect how the total block time varies
throughout the replay:</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/ece9651cd311f011c589c2d69159a3fb/41b28/block_time.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 68.82352941176471%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAOCAYAAAAvxDzwAAAACXBIWXMAAC4jAAAuIwF4pT92AAACfklEQVR42rWST0gUURzHn1kR9MfMJIPIS2BQqNm9Lt1cDwXeOgTBHjpEh6A87SmIkCg6eejSKRZqwWRDWDFTMUyyzTWyUnNHd92Z3XHGebMz+/7MN2Z2zU2Xbn3hy/vN7/fe5/3ejyGkrDoAe6LRaH04HN4XiUT2+va/ffu1ioN9kchoUNvas1UnNVRPyKljhLQdJqT1KCFnjpRXP3e2iZDmFkJON5bjxoZyrfXATkjdld57DZmMeklV1dAvRenOZtWQrus9lNLu9Nr61bGp5I3p2fnribGPN5eVzDU/r+tmj2maIT+mlIYYY5cB1AfE/v6B4xuUpYoMyOYK0ty04XkeKvJ2+C/ljKKshD8AHAqA95+9bnJtmvKEwLqmS9OiEEJASrnLft7nFl2GdZ1iakGV6YKDUolvA8N3Hp9kjKX8axhjknMeHKxlH7ZpO0gu5/FuPoevq5tyZtmCbrnbwNt9T05wzgMg51zWhnGUGEc6Z2B2qYDPKyZ+rtugbkkyD2C8qsO+B8+bORcBUAghaz3Vl2oUMblQwKruQkgZzFlKISvnqoFP/wCrO/S8Mki3HHxazGPqex6Ww4N8MM/yTHcD/ScLUX4yJJeQAlJwGNSBolmY+KYhlTaxQUvwJEcw44o5Y7LSyDbw1t1HLYbN5y0OKAVHrhQYljQHXxQLc4oFh0n8Q7t/m4cD0YbFJWUmu5aR2bWsZWg528yr1DXytrQKtmvkqa2rdnEjT6tt65pt65pV1DXuFu0kgIMBsLc3sj85MdI292GkY2J0uHN6cvL828HBrvHxkXOx2FDn8NBQZywau/g+EW+vXhOJePurV4Nd8Xj8wouXbzrI/9Bv8eQCA8jzo1EAAAAASUVORK5CYII='); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/ece9651cd311f011c589c2d69159a3fb/c5bb3/block_time.png" class="gatsby-resp-image-image" alt="Line graph of block time during replay for various Irmin configurations" title="" srcset="/static/ece9651cd311f011c589c2d69159a3fb/04472/block_time.png 170w,
/static/ece9651cd311f011c589c2d69159a3fb/9f933/block_time.png 340w,
/static/ece9651cd311f011c589c2d69159a3fb/c5bb3/block_time.png 680w,
/static/ece9651cd311f011c589c2d69159a3fb/b12f7/block_time.png 1020w,
/static/ece9651cd311f011c589c2d69159a3fb/b5a09/block_time.png 1360w,
/static/ece9651cd311f011c589c2d69159a3fb/41b28/block_time.png 1967w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<blockquote>
<p>Comparison of block time latencies between Octez 10, 11, 12, and 13 while replaying the 150k
first blocks of the Hangzhou Protocol on Tezos Mainnet<sup><a href="https://tarides.com/feed.xml#fn-1" class="footnote-ref">1</a></sup>. Octez 13's mean block validation time is
23.2 &plusmn; 2.0 milliseconds while Octez v10 was down from 274 &plusmn; 183 milliseconds
(and a worst-case peak of 800 milliseconds!). This <strong>12x improvement in
opearation's mean latency</strong> leads to much more consistent endorsement rights for bakers.</p>
</blockquote>
<p>Another performance metric that has a big impact on node maintainers is the
<em>maximum memory usage</em> of the node, since this sets a lower bound on the
hardware that can run Octez. Tezos prides itself on being deployable to very
resource-constrained hardware (such as the Raspberry Pi), so this continues
to be a focus for us. Thanks to the reduced index size, Octez 13 greatly
reduces the memory requirements of the storage layer:</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/1d03d5bf0827a0964a9fabb3b753e7ec/8b4e6/memory_usage.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 69.41176470588235%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAOCAYAAAAvxDzwAAAACXBIWXMAAC4jAAAuIwF4pT92AAACgUlEQVR42rWST0hUQRzHp7JTRaWZSZG1mbraqUO2JEGHCFKjoEukEQp2zYL802EhiJRuQoZpCkVEC4YamoQgFGKt7rru2qarUb1thbJczff0vTdv5hvz3q6t6MFLX/gyw8z8PvOdP4TEBGCDs78/yeVybRJ2OvuThAFsFHNiTPTj83FXVDRtjq8hq5W9jZB9yYTYthOSsYOQ1K2E7N9JSOoeQnJSCEnfZY2nxNbFTVbCAIhdTlFKixVFKQZQJPqU0sLw9I+LA+6PZb7AZOmA218Wjf45TykKFVUtFqYUZwGImoJlYDD4PYVxJsES11QNmqYjQTzBK8Q5N2LtiDi6CezsG0zTdGoCXe6fvLw1hLLWEAZCc2YRNQwwxta0YRgmkDH2DyhJc8mabpjAO10ST78xjN2VQ3jhnokBmUiwphljq4EioapZCet7wjyr1ovMGg/aPRZQ0ykY5yLNehNKywnresI8s8YLW7UH7cO/TKDBOJhBxUWtP+GSqodNYHcMWOXBy1jCt+NRdLoj+PB53jw+E0lNUxiUrn2HOmXfEhMerPKga+Q3VJ2hqGEcjntjuNw8iSXdrIdqcNPxV14B7OsbTNOp9W3qX0f44dujsNX48Go0Cs3guNA4iYL6IK62TUETxdIYZnvbMNvbChoet75NInBMkpIXNX1CPGhdt7RwqHpIPnBrSO7wziiKqivnGoKy4+6ofKXpk7wIKPPdjUrkWo4cqciW5960LTBRqKmDTqfTAp4uubnF5/NlTX8N5V5/9C4vo7TFsbfkcf7Djve5gUDAfrzy2bG88uYTZ2rbjwYmvti9T+/ntlw66XhSUpAfeP7AHgxOHfH7/TbyP/QXU7PamJYN6osAAAAASUVORK5CYII='); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/1d03d5bf0827a0964a9fabb3b753e7ec/c5bb3/memory_usage.png" class="gatsby-resp-image-image" alt="Bar chart of maximal memory usage during replay for various Irmin configurations" title="" srcset="/static/1d03d5bf0827a0964a9fabb3b753e7ec/04472/memory_usage.png 170w,
/static/1d03d5bf0827a0964a9fabb3b753e7ec/9f933/memory_usage.png 340w,
/static/1d03d5bf0827a0964a9fabb3b753e7ec/c5bb3/memory_usage.png 680w,
/static/1d03d5bf0827a0964a9fabb3b753e7ec/b12f7/memory_usage.png 1020w,
/static/1d03d5bf0827a0964a9fabb3b753e7ec/b5a09/memory_usage.png 1360w,
/static/1d03d5bf0827a0964a9fabb3b753e7ec/8b4e6/memory_usage.png 1953w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<blockquote>
<p>Comparison of maximal memory usage (as reported by <code>getrusage(2)</code>) between
Octez 10, 11, 12, and 13 while replaying the 150k first blocks of the Hangzhou
Protocol on Tezos Mainnet<sup><a href="https://tarides.com/feed.xml#fn-1" class="footnote-ref">1</a></sup>. <strong>The peak memory usage is x5 less</strong>
in the Octez 13 storage layer compared to  Octez 10**, owing to the
significantly reduced size of the index. 400 MB of RAM is now enough
to bootstrap Octez 13!</p>
</blockquote>
<p>Finally, without an index the context store can no longer guarantee to have perfect object deduplication. Our tests and benchmarks show that this choice has relatively little impact on the context size as a whole, particularly since it no longer needs to store an index entry for every object!</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/523e2c8043f4c5d2849fe0df928c6bb2/5551c/storage_size.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 66.47058823529413%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAANCAYAAACpUE5eAAAACXBIWXMAAAsTAAALEwEAmpwYAAACV0lEQVR42rXSX0hTURwH8PNQLhUMLSxlTtGVwywYc3OSoWV/JKmHxF6CopferUCwP+DIh9Sieiikh15CX5SghyZFjZFDs9q8mxcsqUzJ650Su5une+/v3nt+4d0o17P94AfnwI8P39/hEJJVdgshlcWkwFpEttsKCbEVkjz3bpJrt6a7upTk1+4iBTVFJM9RQvIriwlx7Mg2SEdOMpmsAYB6SqlbWJXqExQ8QoJ6AMAdic01P3v5/uTbKf7oqD/U9unL90MA1C1JUj0A9QClbgCoAwCvLMtVhNhbLbpuhDBdhmHoCIqCG4oZuo6qIrP1c6bRYIgaywwwpmdmhwkpb9qmatr4+k2UFP1R4Ae7659nj4MCS8kaW02p7Mm4gINvFnFoUsSUojOUUyw1F2ErsXdMmeeZDqqWAYdMUFZUMyG3kDT2dIexoiuMjmthjEsKzi5R9PbG0NMbw8O3o7j8C1H/FkGh04tipwfF7haExIqZ0NC04SxwZjFluHwc7r8ZQc+tKK4kVfy8TPHYHR6P9PN46j6PcRPkULjaiMJlL4rXT/wD2lstsvoXdPZwuO9GBOt8HMbXQYFiywCPzX0z2HaPR9EEp1G4cjADHv/fYE1HzuaCVm/uxjfclJUVNf1tNgd0XdpKZcVMGF2QDGfP9B9QTMg4u7SWBS6vIWpfI1mg8lM0QQAYJoQ0bfH7/SUfQ6Hy0cCkteLcw+rS0z6n/fxg1VgwWPZ05HW542x/7d72vgOuCw8cz199sHEvRq0DZxocXa0NzpGLjZVTwbGywMRERSAQ2PkbI/banxhhFNQAAAAASUVORK5CYII='); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/523e2c8043f4c5d2849fe0df928c6bb2/c5bb3/storage_size.png" class="gatsby-resp-image-image" alt="Line graph of storage size during replay for various Irmin configurations" title="" srcset="/static/523e2c8043f4c5d2849fe0df928c6bb2/04472/storage_size.png 170w,
/static/523e2c8043f4c5d2849fe0df928c6bb2/9f933/storage_size.png 340w,
/static/523e2c8043f4c5d2849fe0df928c6bb2/c5bb3/storage_size.png 680w,
/static/523e2c8043f4c5d2849fe0df928c6bb2/b12f7/storage_size.png 1020w,
/static/523e2c8043f4c5d2849fe0df928c6bb2/b5a09/storage_size.png 1360w,
/static/523e2c8043f4c5d2849fe0df928c6bb2/5551c/storage_size.png 1763w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<blockquote>
<p>Comparison of storage size between Octez 10, 11, 12, and 13 while replaying the 150k
first blocks of the Hangzhou Protocol on Tezos Mainnet<sup><a href="https://tarides.com/feed.xml#fn-1" class="footnote-ref">1</a></sup>. Octez 13's uses similar disk resources
than previous versions: the duplicated data is fully compensated by the
reduced indexed size.</p>
</blockquote>
<p>What this means for users of the Octez shell:</p>
<ul>
<li><strong>The general I/O performance of the storage layer is vastly improved</strong>, as
the storage operations are 6 times faster and a have 12 times lower mean
latency while the memory usage is divided by 5.</li>
<li>In particular, this mode <strong>eliminates the risk of losing baking rewards</strong>
due to long index merges.</li>
</ul>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#migrating-your-octez-node-to-use-the-newer-storage" aria-label="migrating your octez node to use the newer storage permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Migrating your Octez node to use the newer storage</h3>
<p>Irmin 3 is included with <a href="http://tezos.gitlab.io/releases/version-13.html">Octez v13-rc1</a>, which has just been released today.
The storage format is <strong>fully
backwards-compatible</strong> with Octez 12, and no migration process is required to
upgrade.</p>
<p>Newly-written data after the shell upgrade will automatically benefit from the
new, direct internal pointers, and existing data will continue being read as
before. Performing a bootstrap (or importing a snapshot) with Octez 13 will
build a context containing only direct pointers. Node operators should upgrade
as soon as possible to benefit.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#the-future-of-the-octez-storage-layer" aria-label="the future of the octez storage layer permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The future of the Octez storage layer</h3>
<p>Irmin 3 is just the beginning of what the Tarides storage team has in store for
2022. Our next focus is on implementing the next iteration of the <em>layered
store</em>, a garbage collection strategy for rolling nodes. Once this has landed,
we will collaborate with the Tarides Multicore Applications team to help
migrate Octez to using the newly-merged Multicore OCaml.</p>
<p>If this work sounds interesting, the Irmin team at Tarides is <a href="https://tarides.com/jobs/senior-software-engineer-irmin - [404 Not Found]">currently
hiring</a>!</p>
<p>Thanks for reading, and <a href="https://twitter.com/tarides_ - [1 Client error: Number of redirects hit maximum amount]">stay tuned</a> for future updates from
the Irmin team!</p>
<div class="footnotes">
<hr/>
<ol>
<li>Our benchmarks compare Octez 10.2, 11.1, 12.0, and 13.0-rc1 by replaying the 150k first blocks of the Hangzhou Protocol on Tezos Mainnet (corresponding to the period Dec 2021 &ndash; Jan 2022) on <a href="https://metal.equinix.com/product/servers/c3-small/">an Intel Xeon E-2278G processor</a> constrained to use at most 8 GB RAM. Our benchmarking setup explicitly excludes the networking I/O operations and protocol computations to focus on the context I/O operations only. Octez 10.2 uses Irmin 2.7.2, while both Octez 11.1 and 12.0 use Irmin 2.9.1 (which explains why the graphs are similar). Octez v13-rc1 uses Irmin 3.2.1, which we just released this month (Apr 2022).<a href="https://tarides.com/feed.xml#fnref-1" class="footnote-backref">&#8617;</a></li>
<li>The trade-off here is that without an index the context store can no longer guarantee to have perfect deduplication, but our testing and benchmarks indicate that this has relatively little impact on the size of the context as a whole (particularly after accounting for no longer needing to store an index entry for every object!).<a href="https://tarides.com/feed.xml#fnref-2" class="footnote-backref">&#8617;</a></li>
<li>To reproduce these benchmarks, you can download the replay trace we used <a href="http://data.tarides.com/lib_context/hangzou-level2.tgz - [1 Client error: Failed writing received data to disk/application]">here</a> (14G). This trace can be replayed against a fork of <code>lib_context</code> available <a href="https://github.com/ngoguey42/tezos/tree/new-action-trace-recording">here</a>.<a href="https://tarides.com/feed.xml#fnref-3" class="footnote-backref">&#8617;</a></li>
</ol>
</div>

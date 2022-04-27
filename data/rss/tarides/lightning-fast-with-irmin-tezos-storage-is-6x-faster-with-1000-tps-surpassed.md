---
title: 'Lightning Fast with Irmin: Tezos Storage is 6x faster with 1000 TPS surpassed'
description: "Over the last year, the Tarides\nstorage team has been focused on scaling
  the storage layer of Octez,\nthe most popular node implementation\u2026"
url: https://tarides.com/blog/2022-04-26-lightning-fast-with-irmin-tezos-storage-is-6x-faster-with-1000-tps-surpassed
date: 2022-04-26T00:00:00-00:00
preview_image: https://tarides.com/static/efce619e39c2a72fb0b935be481a220b/0132d/banner.jpg
featured:
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
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 68.23529411764706%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAOCAYAAAAvxDzwAAAACXBIWXMAAC4jAAAuIwF4pT92AAAC9ElEQVQ4y22S20tUURTGlzNBKRX0BxQV1EtGlpWZZV7ypYcegqBeKigqUIOuEEVEr1FUD+pLBIWRFREkXawwulipXWzKwdG56JmbOqPjXDpn39aKfTpeKDd8rHPW2vt3vnXWhhftnaBXNDaaR6hcbW863dlszuXzG+6BYNhNRC4iynOiraFI3PXTG3BnMlm7ZpqWi3PuYowBTAJTE2kwIsP6cQ4ALACA+QBQAAD5ALDQ0aIZtXlObq7XFwQiAsY4QOvLjjxdDEdHCqUUldlsbttoYqw6MZaqGk+lK8PR4ZrWto69bz9+3/X09ac9Xd+8O1OZXOU4o8qkidWJDKvinJUzxioYYwWQmsjMcegtiEhKKYH/LCISRCSdqEgJ/J0cxngogDKXRoWISil9dhWEhmI20LJYi05KKYWUkmYV56SIyAr9ovi5GgofL6Wxm6d1DqUQJKVYBc6PBnMKqLhSCmeTFFzbRSvQg7ETmzBWuxqTDbWoiNRMoHuyZce2cAD0n4Qg3b8V/EHxU1soWr+Wkk3H7I8oKTR1Gmia1v0ZLeOsLQun5YAGllG0roiSjfU41bKYAeRc3CN7KCikQpQKSSpFeiZCKtLvwnHIQp5pYNMxnUJUklAPZRJoWeyedkGouK4TSXujEH8jEZ/KmYEejJ8qw2hdEToO1X8Of5vsvj6XyHD5qCtOze8GqTuYIb2eesbpcmuQbrQZFDeJ1JCHYifLKPbXoe1aSak1DczkzLv6ir3vG7eWnuniS05380O3fPreiaO3+3nhhe+s8PwX/jXCBRkeET6xmUfriniioV4IIi44I86ZDbT1/mP3yvCgv+TJh951Kw63VCw/cGf7/mtvN6ZHBouPXH9Vtqn+bs3Wkw8rnnX6NkQ+txU/2Vda3rx7/fauSwdK/INDxb6+vo1eb2/+FPBzdw+Mxgx40O6BZZcCsPRKGvY1foURww9nHxuw4wFBdWMU2n9GINjxHOjcGqCLi8G4ehAGQgYEA34Y6O+HP1H+VAv46d16AAAAAElFTkSuQmCC'); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/f859bd5c186c91df46c59f296d8f40b6/c5bb3/transactions_per_second.png" class="gatsby-resp-image-image" alt="Bar chart of mean transactions per second for various Irmin
configurations" title="Bar chart of mean transactions per second for various Irmin
configurations" srcset="/static/f859bd5c186c91df46c59f296d8f40b6/04472/transactions_per_second.png 170w,
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
<p>As discussed in <a href="https://tarides.com/2020-09-01-introducing-irmin-pack">our <code>irmin-pack</code> post</a>, the context index was
optimised for very fast reads at the cost of needing to perform an expensive
maintenance operation at regular intervals. This design was very effective in
the early months of the Tezos chain, but our <a href="https://tarides.com/2021-10-04-the-new-replaying-benchmark-in-irmin">recent work on benchmarking the
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
<p>So what is the performance impact of this change? As detailed in our <a href="https://tarides.com/2021-10-04-the-new-replaying-benchmark-in-irmin">recent
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
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 70%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAOCAYAAAAvxDzwAAAACXBIWXMAAC4jAAAuIwF4pT92AAADVUlEQVQ4y21Sb2hTVxQ/SwKr7sOYDPzglEKHnzbUtZnMqiVVi6yDFsU60cFwsOo2lcKsxS+i26xFC2Lj1M0/80/nrEI2horQtVED4ky1NbZ5a9K0Js1LU9smS9LkvXfvPWfc1+fY5i78+J1zLvd3f/eeA0QEn37ZCkRk+/mmzxGKjNpj8XH7wOCIXdaI6KV/Yjqv2Z7XE8lJM06lsyY/HogAeG74AGY5YWLqTwAABwC8YmG2xa8BwKsWZDzL2pNxkcylqalUBswlE4A5kp1CCFc6k3dl80alRDqbrwwPx9/v8j2qu3s/sP6W98EmdWyiajqvuZ5NpldLzubylYjkIqKluekCQCY7De+sqS8yGAtzzomIBNM15IaGRIRCCIGIcoMjEZPpfyDkOc55TAhhA8YYbKz/ysG4CEm1rmBa7LgUol3tYfIqaZpZgnKZjNQnxBcgLI4hog2exsagtGpbUUEzTMFjnXH++q7fcW7DAzzRrZou2zpVPPDLCLp/U7GgM0QhkHP+HNxyGOWc2yD5bAqqt+x1aAYzBb+7nRAlTT20cO9D+sGXNP1VtfbT4v19tPpIP2ULzHTKuSAhTAiLZ54sHS77YMfLBX1G8KQ3IYr39JAUPXt3zDy8/rhCK1ue0LrjyowgCuno/wV7+v4A59rtRXnNCJuC3S8K1rqDVN4coJq2IGULBpHgxBkjwZjkv5tiPjmmjsPmzw/adSYGpeApb4IXN/qxpKkHz/mS5h/WuhUsbw5gTVsQcxoza9Inl7fJ7gshmxI1m3K6/Tqs+2Sfo6CzIUsQ/+2QqNat0HLLYc5AwlSCUo+8lO69TWw8ikLOAeejKLgNrnfeg60Nh+35gq7IC090xfXiRr9R0uQ3ztxRmRzL2ragUd78WK85GjCyRCzX3c7ULxYb6va3jNSv3+pySA1dG8mlp2zwXvVn8MaSOsfD3sCi5GjE+c1P/rJ5H11YNf/jH10tHX5n/GmktKLRU/F2ffuaikbPiieReNngVXdZx4dO15W60sqB881loWj83UFFWXT50kWAlTU7YUHpRgj0KzCZiMKha73w5pFJWNiiQqunD6LDQ7D58gRUXyHY8P0wBKNJCF89BrR7LlDDHAid/xqG1SREhsLgudYBfwFkZiA6cfeoNgAAAABJRU5ErkJggg=='); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/7d4ca3167883d6cdcafbc1b29a6fecc0/c5bb3/cpu_time.png" class="gatsby-resp-image-image" alt="Bar chart of CPU time elapsed during replay for various Irmin configurations" title="Bar chart of CPU time elapsed during replay for various Irmin configurations" srcset="/static/7d4ca3167883d6cdcafbc1b29a6fecc0/04472/cpu_time.png 170w,
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
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 68.82352941176471%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAOCAYAAAAvxDzwAAAACXBIWXMAAC4jAAAuIwF4pT92AAADE0lEQVQ4y22TzWsUSRjGy5mDCGEV/CD/xV52iWPUNebgQU/Lsgh79KAHUfCg+IGXRbwIBj0tK571khWWaIjZTBJjYkgMak9mkjjTkxkzM5n+mJn+7q56q16p7mZJxIKnnqqXqh9PvVCEEEKOnbtMbMfNfCqWs6Nj09nF94XsZ7We3aw3M4gotScVkT4+tZiV9Wqtka1sNjJhGGZ83894nk/iMfzbNbJRqcvDcttHCNn3jR9I/WDq+1Pvk3eSu5z4fgLckzt7+Ye2bvyk6caQWq0PNZrbQ23NON3p9obWy7Uzr/5b+D0/t/Lr6NjsHxvl2hlZb7S04e22cdpxnF8c1zvled7PURhk4lT3Hzw5pFt+Qes4uNXUwLJdAQBCcC6EEBwRIRWTe0jqAhGF3vN4RJlclhwv7IuBd0eeHYxcp+DaDrY0k9uOh4wxBIBdYiwRosAgpNixPXy3rvGaZmMU0RIiJsCL1x/2U0oVxihSSoExFif8nhCFcP1QfFB1Mb+mCeWLDXMlHS0vKv4PvHL70RHKWCFNAnGaXclYLEoZNnQLl8sGfqrbuN5y0Q8Z73lUJi8BsAR4/c+/DgOAwjlH4LJFHOM18BgouGwjYtcJ8E3JwIrmo2ytrAseT/J8CYAnwJv3/j7EAJSdCaVQJCDXj1DZ7OByxUTdjjAFpC/gXLoEcp4Cr955fIQDU5BLiIwEAjkIxwtF03TF/Jou3qtd0XHCuC57vEOQtqTIABLgpRsj/ZZPV9tWiHXDE6rmY7nt4kq1i8tqF50QMBkCgQvkYpeEdOB8jUvgkqKSe4+f769Utz62mtvYam5HHV1jPUNnoWUy4XVZZJks6Jk06Jmy9q2HgWViFAZKwLGPnL9wi5w9f23vxsrCj8Wl+WMfF2ZzyuLbo4sz+cGlt28G8pNTubl8Pjc+9urkwsxMbnJ84vj89HRu4uX4iXezM0enJl4PzuXzgy/+nRiQ/5wkH94mtFEkUbNEUP9MTFUhTCuT5voHYlZXY2HQInqlQLBXI4a6StDdIu2yQkBXSbdWijkjT/8hXwE3BnIGsGbYugAAAABJRU5ErkJggg=='); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/ece9651cd311f011c589c2d69159a3fb/c5bb3/block_time.png" class="gatsby-resp-image-image" alt="Line graph of block time during replay for various Irmin configurations" title="Line graph of block time during replay for various Irmin configurations" srcset="/static/ece9651cd311f011c589c2d69159a3fb/04472/block_time.png 170w,
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
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 69.41176470588235%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAOCAYAAAAvxDzwAAAACXBIWXMAAC4jAAAuIwF4pT92AAAC/UlEQVQ4y32SS2hTQRSGj1FEfIMLN0akBkQUxDdWF32JLty5EDcVN9KCYl1IW0VcqIggFMGVIGKxWq2PhSIqTavxbU2qaZuatGmitaltcnOTm9rczOMcmcmtigUH/vk5w5mfbx5ARMAYByJyvXj7eabyxI+Ua3TMcGWtny4imqF6HJ8hpHSlM5Za12p7+GKWckRUNUA+X1DNEI0nAADmAMACAJgLAPOdWvkSAFgEAIsBYJ6zvtDpXaD2IyJ4XwYAstaECpxNRKW2zcqTaatyIs8qzFy+YmLSLu8Lx/c8fd61/9X7nr3tPv++pJGp+jlpl6dNqzKdsSrzdqGMiCqIaJ0mVFPSyCxHRAMRiYikKNhIkqtCSRIRJyLhOFKxUQsRhSoRsVNR6sA3Xb0exrihelrfj+PRlkGquzlIPcM5vY8xTkII4kJo/0fC8U4hRDFwctJexoVMKbxjrTG59FgXKj3pMTUFFxL/M7hD2PGb8OPncImtCYlO3ovLVScCpNTel1ZLZDNOXEji/L+EHb8Js9aEmwupA0/ci0tPo588DX5qD5n0Zwg9OzR/S0wj/NDdv3KKsPFuMXBlg5+8obS+w3cDJj3rTlBoJFek4pwkZ1qC8+mEZjbnnrrDxiIhltT78WUki6kcw11NISw934s1zVFEKfW92kTIii/NUcrphAUm0k4geRoDVNLgJ184QymrQLubQrTtXJBqmgf1H7JjQRr3tlKq8w6xsbiU+q/99cpJI+MuMD5ePHKMeRr8rKT+I/N9MXkya/PdTX2FbeeCrOZ6hEkibrZd4Ima1SxRu4blXj+w9UdlhXZNqMaBw2cX9ob6149+i246dNm3ZXl1c5X74K2y297gpkBvZOPWo3cq1h5q2bn3zOMdQ8MjG4NXTm++sX971YPq7WUDj65tCA993RruD60yDKMYWHv8IkQGojA6HIO6659g9SULPGeHoO15H3QFw7CvLQ+7WgQcuRWDSPw7DF09BXRqKdDxFRC6fwXiIz8gOjgApmnCL2AjS3seOrEuAAAAAElFTkSuQmCC'); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/1d03d5bf0827a0964a9fabb3b753e7ec/c5bb3/memory_usage.png" class="gatsby-resp-image-image" alt="Bar chart of maximal memory usage during replay for various Irmin configurations" title="Bar chart of maximal memory usage during replay for various Irmin configurations" srcset="/static/1d03d5bf0827a0964a9fabb3b753e7ec/04472/memory_usage.png 170w,
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
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 66.47058823529413%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAANCAYAAACpUE5eAAAACXBIWXMAAAsTAAALEwEAmpwYAAADOUlEQVQ4y2WTa2gcVRSADz5WquKr+Ai6NiI1dqXVxoWmXWrLjA2G+kN/tH8EpaD/CtK0oqxE24qPNrGKggjqP/2rrUrFajUmtdbGZN+maKK7m8zM7maSmWXncWfuuffI7K5K9MLlHA7c737ncC/A9SnwfR/KVR2ICADgBgC4BgDWdPdNANADALcCwC0AcGO3vhYArgOAq/+saICcA2MMAG5TYitWMxkEwaDnM8V2fNULuLrSdFXOuTJf1h6duFjck79Ufmz8p/yeRb0xxAOmsJatUuipodNUfN9XGGODjLH7AeDaK8KQTwkhiEgSEVLgORQt2a61Mwp8t5sKEpKIE5GLnRNCSBICSQhxBgD6rmJB+D2RIMPyg2Onq3j40z9w9KsFtJ0AG02G73yziGOny/j+dxraHkfpNbFVOIdLU2fRm72AyPwAhSBE/AwAbo+xgP8QXV5adLAvPSPven5G3pOekZrF5G81V259rSC3vFqQO97IS90hKcpZqe/fLGv7N0ljeKvkVh2jXgTyUwAQj7mePxEZ/qq1MHk0RxtfylDylRxpKx79XnNo15slUkaLtPvtEuktSbycJ+O5h8g4uI3qL+6iYKWOPBpDGEbAO2MsCNuGs7qL/UeylBjJUBQNi9Fc3SN1rEQ7jxdp6ESRai6RqBRIP5Qi48AA1dIqcbvRNcSOoc+CiWi8s5qzCqhbPs3V3FVAwyHCSn4VMLQ6QOTtlnuu9NuGkmb1/wL/b2i0DVcD+d9A/Bc43jXk/UeyIjGSEVHULSbm6q5Qx0pi5/GiGDpRFIZDAit5oR9MCePAgKilVRFajbBreBIAemNByM91Z0j9R3N030i2HQ2b0fw/hiUaeqvUmWG1QMahFNWGB6iefpi4vdR5j4hfRl/tspbjfkEYeoWK3dj88rSZSE8tR7G61DIvaU1TOZYzd7yeXX5kLGcu2Nxk8xmzOrzNXHh2y7L2gmJ6S3qdcfSZ730Msfjg5WfHJ3uKuUzv1z/m7lj/1Ef3xh8fTfY9/cn6yYvZ+MlvL6zb+OR7mxJPvPvAg898mDhzPrtufuLz+Ad7UxsO796ePLVv+92Fnyfj05ls7/QvUzf/BXYt5hgXrlHTAAAAAElFTkSuQmCC'); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/523e2c8043f4c5d2849fe0df928c6bb2/c5bb3/storage_size.png" class="gatsby-resp-image-image" alt="Line graph of storage size during replay for various Irmin configurations" title="Line graph of storage size during replay for various Irmin configurations" srcset="/static/523e2c8043f4c5d2849fe0df928c6bb2/04472/storage_size.png 170w,
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
<p>If this work sounds interesting, the Irmin team at Tarides is <a href="https://tarides.com/jobs/senior-software-engineer-irmin">currently
hiring</a>!</p>
<p>Thanks for reading, and <a href="https://twitter.com/tarides_">stay tuned</a> for future updates from
the Irmin team!</p>
<div class="footnotes">
<hr/>
<ol>
<li>Our benchmarks compare Octez 10.2, 11.1, 12.0, and 13.0-rc1 by replaying the 150k first blocks of the Hangzhou Protocol on Tezos Mainnet (corresponding to the period Dec 2021 &ndash; Jan 2022) on <a href="https://metal.equinix.com/product/servers/c3-small/">an Intel Xeon E-2278G processor</a> constrained to use at most 8 GB RAM. Our benchmarking setup explicitly excludes the networking I/O operations and protocol computations to focus on the context I/O operations only. Octez 10.2 uses Irmin 2.7.2, while both Octez 11.1 and 12.0 use Irmin 2.9.1 (which explains why the graphs are similar). Octez v13-rc1 uses Irmin 3.2.1, which we just released this month (Apr 2022).<a href="https://tarides.com/feed.xml#fnref-1" class="footnote-backref">&#8617;</a><a href="https://tarides.com/feed.xml#fnref-1" class="footnote-backref">&#8617;</a></li>
<li>The trade-off here is that without an index the context store can no longer guarantee to have perfect deduplication, but our testing and benchmarks indicate that this has relatively little impact on the size of the context as a whole (particularly after accounting for no longer needing to store an index entry for every object!).<a href="https://tarides.com/feed.xml#fnref-2" class="footnote-backref">&#8617;</a><a href="https://tarides.com/feed.xml#fnref-2" class="footnote-backref">&#8617;</a></li>
<li>To reproduce these benchmarks, you can download the replay trace we used <a href="http://data.tarides.com/lib_context/hangzou-level2.tgz">here</a> (14G). This trace can be replayed against a fork of <code>lib_context</code> available <a href="https://github.com/ngoguey42/tezos/tree/new-action-trace-recording">here</a>.<a href="https://tarides.com/feed.xml#fnref-3" class="footnote-backref">&#8617;</a><a href="https://tarides.com/feed.xml#fnref-3" class="footnote-backref">&#8617;</a></li>
</ol>
</div>

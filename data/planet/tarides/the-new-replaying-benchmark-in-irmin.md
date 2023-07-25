---
title: The New Replaying Benchmark in Irmin
description: "As mentioned in our Tezos Storage / Irmin Summer 2021 Update on the
  Tezos Agora forum, the Irmin team's goal has been to improve Irmin's\u2026"
url: https://tarides.com/blog/2021-10-04-the-new-replaying-benchmark-in-irmin
date: 2021-10-04T00:00:00-00:00
preview_image: https://tarides.com/static/37ab792f992f4bdb89846ecd0bda664c/2ae3d/footprints.jpg
featured:
authors:
- Tarides
source:
---

<p>As mentioned in our <a href="https://forum.tezosagora.org/t/tezos-storage-irmin-summer-2021-update/3744">Tezos Storage / Irmin Summer 2021 Update</a> on the Tezos Agora forum, the Irmin team's goal has been to improve Irmin's performance in order to speed up the <em>Baking Account</em> migration process in Octez, and we managed to make it 10x faster in the first quarter of 2021. Since then, we've been working on a new benchmark program for Irmin that's based on the interactions between Irmin and Octez. This won't just help make Irmin even faster, it will also help speed up the Tezos blockchain process and enable us to monitor Irmin's behavior in Octez.</p>
<p>Octez is the <a href="https://gitlab.com/tezos/tezos">Tezos node implementation</a> that uses Irmin to store the blockchain state, so Irmin is a core component of Octez that's responsible for virtually all the filesystem operations. Whether a node is launched to produce new blocks (aka &ldquo;bake&rdquo;) or just to participate in peer-to-peer sharing of existing blocks, it must first update itself by rebuilding blocks individually until it reaches the head of the blockchain. This first phase is called <em>bootstrapping</em>, and once it reaches the blockchain head, we say it has been <em>bootstrapped</em>. Currently, the <em>bootstrapped</em> phase processes 2 block per minute, which is the rate at which the Tezos blockchain progresses. The next goal is to increase that rate to 12 blocks per minute.</p>
<p>Irmin stores the content of the Tezos blockchain on a disk using the <code>irmin-pack</code> library. There is one-to-one correspondence between the Tezos block and the Irmin commits. Each time Tezos produces a block, Irmin produces a commit, and then the Tezos block hash is computed using the Irmin commit hash. The Irmin developers are working on improving the <code>irmin-pack</code> performance which in turn will improve the performance of Octez.</p>
<p>A benchmark program is considered &ldquo;fair&rdquo; when it's representative of how the benchmarked code is used in the real world&mdash;for example, the access-patterns to Irmin. A standard database benchmark would first insert random data and then remove it. Such a synthetic benchmark would fail to reproduce the bottlenecks that occur when the insertions and removal are interleaved. Our solution to &ldquo;fairness&rdquo; is radical: <em>replaying</em>. Within a sandboxed environment, we <em>replay</em> a real world situation.</p>
<p>Basically, our new benchmark program makes use of a benchmarked code and records statistics for later analysis. The program is stored in the <code>irmin-bench</code> library and makes use of operation traces (called <em>action traces</em>) when Octez runs with Irmin. Later, the program replays the recorded operations one at a time while simultaneously recording tonnes of statistics (called stat traces). Data analysis of the stat traces may reveal many interesting facts about the behaviour of Irmin, especially if we tweak:</p>
<ul>
<li>the configuration of Irmin (e.g., what&rsquo;s the impact of doubling the size of a certain cache?)</li>
<li>the replay parameters (e.g., does Irmin's performance decay over time? Does <code>irmin-pack</code> perform as well after 24 hours of replay as after 1 minute of replay?)</li>
<li>the hardware (e.g., does <code>irmin-pack</code> perform well on a Raspberry Pi?)</li>
<li>the code of Irmin (e.g., does this PR have an impact on performance?)</li>
</ul>
<p>This benchmarking process is similar to the record-replay feature available with <a href="https://docs.tezedge.com/tezedge/record-replay - [1 Client error: Couldn't resolve host name]">TezEdge</a>.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#recording-the-action-trace" aria-label="recording the action trace permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Recording the Action Trace</h3>
<p>By adding logs to Tezos, we can record the Tezos-Irmin interactions and thus capture the Irmin &ldquo;view&rdquo; of Tezos. We&rsquo;ve recorded <em>action traces</em> during the <em>bootstrapping</em> phase of Tezos nodes, which started from <em>Genesis</em>&mdash;the name of the very first Tezos block inserted into an empty Irmin store.</p>
<p>The interaction surface between Irmin and Octez is quite simple, so we were able to reduce it to eight (8) elementary operations:</p>
<ul>
<li><code>checkout</code>, to pull an Irmin tree from disk;</li>
<li><code>find</code>, <code>mem</code> and <code>mem_tree</code>, read only operations on an Irmin tree;</li>
<li><code>add</code>, <code>remove</code> and <code>copy</code>, write only operations on an Irmin tree;</li>
<li><code>commit</code>, to push an Irmin tree to disk.</li>
</ul>
<p>It&rsquo;s important to remember that Irmin behaves much like Git. It has built-in snapshotting and is compatible with Git itself when using the <code>irmin-git</code> library. In fact, these operations are very similar to Git, too.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#sequence-of-operations" aria-label="sequence of operations permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Sequence of Operations</h3>
<p>To illustrate further, here's a concrete example of an operation sequence inside an action trace:</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/d133a7455102c1b17e30fae407e04c78/7131f/ygWh3cg.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 48.23529411764706%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAKCAYAAAC0VX7mAAAACXBIWXMAAAsTAAALEwEAmpwYAAABUElEQVR42p2S246DMAxE+f9f7FOhlJCbAyUhNzorp6uq25furiVrHAWdjG26SVpITRCKcJkUyDlYaxFjBMf9fv+hn6JT2sJYB20IQswgogZ0zkFrDSll05TS74DX2YBdssPhKqGNaQBjDJRSTXPOLUspH51253OP4TLiMo449wPGcQRZwtAPEEKg73ucTqfmlN3zKBh6HAdqra1+faSTysLQAqUJ5G7Q1kAaAalmKPuArOuKbdua8ii4vt1u7Y6VnT+B46QwzQoMFrOC8xYmCISyIdX9+eGrk/f6bYYW4nvTo9AwRMgl47/RbT5gjwmsIUaEsGMPO0IIrTVOPnvvse8P5Y1zq8EHpBKxF496r63uLpOGMgt425rW9guZmbDYFc4s8FtATrlBOPkhXgaDeUG5JOQaG7AcGZ1zK7wPILc0l8uyIIaEHApqrqj5+FPLXwLCB+BdtA6oAAAAAElFTkSuQmCC'); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/d133a7455102c1b17e30fae407e04c78/c5bb3/ygWh3cg.png" class="gatsby-resp-image-image" alt="ygWh3cg" title="" srcset="/static/d133a7455102c1b17e30fae407e04c78/04472/ygWh3cg.png 170w,
/static/d133a7455102c1b17e30fae407e04c78/9f933/ygWh3cg.png 340w,
/static/d133a7455102c1b17e30fae407e04c78/c5bb3/ygWh3cg.png 680w,
/static/d133a7455102c1b17e30fae407e04c78/7131f/ygWh3cg.png 710w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<p>This shows Octez&rsquo;s first interaction with Irmin at the very beginning of the blockchain! The first block, <em>Genesis</em>, is quite small (it ends at operation #5), but the second one is massive (it ends at operation #309273). It contains no transactions because it only sets up the entire structure of the tree. It precedes the beginning of Tezos' initial protocol called &ldquo;Alpha I&rdquo;.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#benchmark-benefits" aria-label="benchmark benefits permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Benchmark Benefits</h3>
<p>Our benchmark results convey the sheer magnitude of the Tezos blockchain and the role that Irmin plays within it. We&rsquo;ve recorded a trace that covers the blocks from the beginning the blockchain in June 2018 all the way up to May 2021. It weighs <strong>96GB</strong>.</p>
<p>Although it took <strong>34 months</strong> for Tezos to reach that state, bootstrapping so far takes only <strong>170 hours</strong>, and replaying it takes a mere <strong>37 hours</strong> on a section of the blockchain that contains <strong>1,343,486 blocks</strong>. On average, this corresponds to <strong>1 per minute</strong> when the blocks were created, <strong>132 per minute</strong> when bootstrapping, and <strong>611 per minute</strong> during replay.</p>
<p>On this particular section of the blockchain, Octez had <strong>1,089,853,521 interactions</strong> with Irmin. On average, this corresponds to <strong>12 per second</strong> when the blocks were created, <strong>1782 per second</strong> during bootstrapping, and <strong>8258 per second</strong> during replay.</p>
<p>The chart below demonstrates how many of each Irmin operation occur per block (on average):</p>
<center>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 500px; ">
      <a href="https://tarides.com/static/c87031f583955f306e8c64611c474c01/0b533/4yKd8iQ.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 100%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAACXBIWXMAAAsTAAALEwEAmpwYAAACOElEQVR42q2Uz0/TYBjHy8HEg2f/Ds+evPlPGGLiycSLiRdPHkjwByEDTdQYjQeDkoBcCBc9gMHEEHVCHCAZW7sNV1jX9V3LurZ7249Z2YAxBsPwJE/apM/zeZ/v0+d9FE6xKIpi79eUfgObTD+MYg9POEDpmQ2UnRqaqqLregek+Rr9T4V6dZdyuRwT7EDyIidIqBaGL/fAJwFlGMXeVWzreeOXjvIxhTK1wvWlQtf3DuBhOUelNa3iSy5/2mTg7TwX3nzm0twGfxyvFd+jwqWC4Itq0TgUISMQQiCsCtcWsyiTSZTJn1xZUHFbcXE/D01CDJxYLjJwdwblzhSPFjL745KvS9azKrZZJut43E6VuLmyTcrxOxR0VTj4bhll8BXKrddcTXztkC6lJAzDrlmsyYikHVAUVUzDoGQYuK67B5xd3+Hi/TmUe7O8XMrHCW3pruuxurZG1XEIgSAMaQQB+q7L9E6NVHGHgqpStW183z/o4YZR4/e20yUjkBLPdWN9zWHRyhaZdJqtv1s49fp+ezokR8f82XQtYFp3eF+0+SY8gmbjAbvu4bVApw52yAHscdbkiWYxmq8ytGkyV9rt634rxw3xjO4woglGVgsM/dhgPFdlXLOoBL1vyInAD0WbUU0wnEzzYHGFsaxJQrPY9hpnBLYiv4s6wxmTMU3wNCd4mKkwUbT3W3Lm9SWjiHmzxvO84FnOYlJ3MPqQ2xPYThKNkJIvaZzHgg2PHBCdx8Y+C6gN/AdwOvk4iuviYwAAAABJRU5ErkJggg=='); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/c87031f583955f306e8c64611c474c01/0b533/4yKd8iQ.png" class="gatsby-resp-image-image" alt="4yKd8iQ" title="" srcset="/static/c87031f583955f306e8c64611c474c01/04472/4yKd8iQ.png 170w,
/static/c87031f583955f306e8c64611c474c01/9f933/4yKd8iQ.png 340w,
/static/c87031f583955f306e8c64611c474c01/0b533/4yKd8iQ.png 500w" sizes="(max-width: 500px) 100vw, 500px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
</center>
<p>This next chart displays where the time is spent during replay:</p>
<center>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/85cffd35d784692988f8aa1f04e9180a/78797/u5Fv2Zb.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 50%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAKCAYAAAC0VX7mAAAACXBIWXMAAAsTAAALEwEAmpwYAAAB+0lEQVR42m2S3UuTURzHTzOCoIjoIor+gYKEgijzKgqEbqMuuiq8DkbgRV0UBE0kI3GJXgw0CvKikiJoCQ5xa26SaKwXnRbMVuGm5V6e9/M8n9jjszfrB+dwXr7nw+/3O1+BFw5gA6ZpIqV01/+Lis6SNoqiuDrHAacyeSFqQu9MUTVMy2o6a4S5w3FYXc1h6AaaqlIuK3Vg9Y0ubQKzWU69+Mi5V58Z+7peg0A9i/yGyvWHEU50PuLayw/M/y5AJdMq0PaE/ngG0TtFS38McX8KEUzyOlty7yy7nur5rmeII7fY0d5D65MErZNpoj/WQJouVJiaxvLPHPv6I4hgDN9QguOjc1wYDnMjGGJ5caEGS6RW8J2+i6+9m72XQxyOZmgZmyOQWnF/wLDkZg+zRZVdg3HEQBzfYJLO8U+8mZjgwb0e4tPTWJZ0geHYF7a13UG0BTh0dYSOt0vsH4zQnVygtJanUCwiqo2/GE67JW8fiCP63nHw8TyJ73m0YgFTbgI1Q3LsyjDi6G12d/TRNbnIyVCUpzNLGKUNdMOsA38pJpfG0+wJzXBg5D03ExkM6VAulcjl8uiG4epS3/Kc9Y+y80wv/uezpDUNXdOxPGf8Y5s/ukXZanahbdvuoOHH1wsquikxdQ3bq6AZ2GARF9JgQmfLumm/xfh/AdfyvSRRvmoCAAAAAElFTkSuQmCC'); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/85cffd35d784692988f8aa1f04e9180a/c5bb3/u5Fv2Zb.png" class="gatsby-resp-image-image" alt="u5Fv2Zb" title="" srcset="/static/85cffd35d784692988f8aa1f04e9180a/04472/u5Fv2Zb.png 170w,
/static/85cffd35d784692988f8aa1f04e9180a/9f933/u5Fv2Zb.png 340w,
/static/85cffd35d784692988f8aa1f04e9180a/c5bb3/u5Fv2Zb.png 680w,
/static/85cffd35d784692988f8aa1f04e9180a/b12f7/u5Fv2Zb.png 1020w,
/static/85cffd35d784692988f8aa1f04e9180a/78797/u5Fv2Zb.png 1125w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
</center>
<p>With <code>irmin-pack</code>, an OCaml thread managed by the <a href="https://github.com/mirage/index/"><code>index</code> library</a> is running concurrently to the main thread (i.e., the <em>merge</em> thread), a fraction of the durations (shown above) are actually spent in that thread. Refer to this <a href="https://tarides.com/blog/2020-09-01-introducing-irmin-pack">blog post</a> for more details on <code>index</code>'s <em>merges</em>.</p>
<p>The following chart illustrates how memory usage evolves during replay:</p>
<center>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/fda8364be92a0ed94a1228298ea88b68/20c85/F0bORTg.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 40%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAICAYAAAD5nd/tAAAACXBIWXMAAAsTAAALEwEAmpwYAAABPklEQVR42lVR2ZKDMAzj/z+yQ4G2U66E3Ld2bBZm98EjJbFlW+kAwDmHWWmsxt74ly/a3HhxftcGX22wKY1hGLDvOzprLZZlQUoZpQGRsDaOi6dckEu98X7PBSEXxJSglMJxHOhSSkxKyQDaia1xlHzyWgpaq6j1RMqj+1bprv6+N96001pjnmfknDn5Er7F0ViICksp/0R9SFDGw1gPIQSklOhijHy4BLX10C5C24hDOxgXIZXDIgy+u2ZcpWWchYHUnmu2bWOdjsZc1pUTduXPBBehSJC6+8SipVZkmrCduB8On88H/eOBcRgwjuPpIf3ytgvIQ4P8pE/KKXF475DzibQJNQ8hIIQIGwLe7zfGccLr9WJujEFH3kzTxD7SyH3/hHMe67pyVyEk+ueTV6JCChInPymH6gi99+zzDyuFal8TivU4AAAAAElFTkSuQmCC'); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/fda8364be92a0ed94a1228298ea88b68/c5bb3/F0bORTg.png" class="gatsby-resp-image-image" alt="F0bORTg" title="" srcset="/static/fda8364be92a0ed94a1228298ea88b68/04472/F0bORTg.png 170w,
/static/fda8364be92a0ed94a1228298ea88b68/9f933/F0bORTg.png 340w,
/static/fda8364be92a0ed94a1228298ea88b68/c5bb3/F0bORTg.png 680w,
/static/fda8364be92a0ed94a1228298ea88b68/20c85/F0bORTg.png 999w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
</center>
<p>On a logarithmic scale, this last chart shows the evolution of the <em>write amplification</em>, which indicates the amount of rewriting (e.g., at the end of the replay, 20TB of data have been written to disk in order to create a store that weighs 73GB).</p>
<center>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/865f6695d4f8132e84cadef0cd099f38/20c85/PhNqloN.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 50%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAKCAYAAAC0VX7mAAAACXBIWXMAAAsTAAALEwEAmpwYAAABoElEQVR42l2SiY7iMBBE8//fyAADTMhB7CSObzs1qs6CRmvJ8iH36+5yNQAQQoDSGnqe0fc9hmGAUgrbtsFaC2ctvHOyOmexGgu9GMyrwag0brebvMs5o0kpYSBkMVDG4vz1hev3N4IPqLWi7jt8KggF0C5iCRkmFqwhYw0FajFof34wTRPWdUXDCud5hjEG+74jxYicEmKumGyAcgnKBmypIOaMXCpDUEtBDB4xRqmOK0fDKrTW0h4HAyYbMfsMn5IkqbUckFrlzNa89yilHEWkhHEcsSwLGoK6vpcsO4DBBIT0FwDEUsAbFyI27+EILFWmcV40ZALCG2Yj3W4bFl/gYkauFaHusLkca4zYBBYQqask21G4r1VgHyDL1kpBLSuUzwilymS11IWTLvjbMschRf20/Hq95B8aXozDgF4t0Im5D404CXsH/g98vyHMOfdJ2rx/7N4NaF8Ks1biRz5iRmpLsXmmLbjnJ16vV1wuF5xOJ5zPZ3GKtEwg237c76Jl27ZSPoMfjwe6rhPRaXZCaHgGEvB8PsV/7CT9c8Qv74AHIrmjuNoAAAAASUVORK5CYII='); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/865f6695d4f8132e84cadef0cd099f38/c5bb3/PhNqloN.png" class="gatsby-resp-image-image" alt="PhNqloN" title="" srcset="/static/865f6695d4f8132e84cadef0cd099f38/04472/PhNqloN.png 170w,
/static/865f6695d4f8132e84cadef0cd099f38/9f933/PhNqloN.png 340w,
/static/865f6695d4f8132e84cadef0cd099f38/c5bb3/PhNqloN.png 680w,
/static/865f6695d4f8132e84cadef0cd099f38/20c85/PhNqloN.png 999w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
</center>
<p>The <em>merge</em> operations of the <code>index</code> library are the source of this poor <em>write amplification</em>. The Irmin team is working hard on improving this metric:</p>
<ul>
<li>on the one hand, the new <em>structured keys</em> feature of the upcoming Irmin 3.0 release will help to reduce the pressure on the <code>index</code> library,</li>
<li>on the other hand, we are working on algorithmic improvements of <code>index</code> itself.</li>
</ul>
<p>Another nice way to use the trace is for testing. When replaying a trace, we can recompute the commit hashes and check that they correspond to the trace hashes, so the benchmark acts as additional tests to ensure we don't compromise the hashes computed in Tezos.</p>
<p>Complex changes to Tezos can be simulated first in Irmin. For example, the <a href="https://gitlab.com/tezos/tezos/-/merge_requests/2771">path flattening in Tezos</a> feature (merged in August 2021) can now be tested earlier in the process with our benchmark. Prior to the trace benchmarks, we first had to make the changes in Tezos to understand their repercussions on Irmin directly from the Tezos benchmarks.</p>
<p>Lastly, we continue to test alternative libraries and compare them with the ones integrated in Tezos; however, using these alternative libraries to build Tezos nodes has proven to be more complicated than merely adding them in Irmin and running our benchmarks. While testing continues on most new libraries, we can definitely use replays to compare our <a href="https://github.com/mirage/cactus/">new <code>cactus</code> library</a> as a replacement for our <a href="https://github.com/mirage/index/"><code>index</code> library</a>.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#future-directions" aria-label="future directions permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Future Directions</h3>
<p>While the <em>action trace</em> recording was only made possible on a development branch of Octez, we would next like to upstream the feature to the main branch of Octez, which would give all users the option to record Tezos-Irmin interactions. This would simplify bug reporting overall.</p>
<p>Although the first version only deals with the <em>bootstapping</em> phase of Tezos, an upcoming goal is to make it possible to benchmark the <em>boostrapped</em> phase of Tezos as well. Additionally, we plan to replay the multiprocess aspects of a Tezos node in the near future.</p>
<p>The first stable version of this benchmark has existed in Irmin&rsquo;s development branch since Q2 2021, and we will release it as part of <code>irmin-bench</code> for Irmin 3.0 in Q4 2021. This release will allow integration into the <a href="https://github.com/ocaml-bench/sandmark">Sandmark OCaml</a> benchmarking suite.</p>
<p>Follow the Tarides blog for future Irmin updates.</p>

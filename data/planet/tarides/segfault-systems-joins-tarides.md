---
title: Segfault Systems Joins Tarides
description: "We are delighted to announce that Segfault Systems, a spinout from IIT-Madras,\nis
  joining Tarides. Tarides has worked closely with Segfault\u2026"
url: https://tarides.com/blog/2022-03-01-segfault-systems-joins-tarides
date: 2022-03-01T00:00:00-00:00
preview_image: https://tarides.com/static/19d3cf7fb9f5a092cd62793230669e7a/0132d/chennai.jpg
featured:
authors:
- Tarides
source:
---

<p>We are delighted to announce that Segfault Systems, a spinout from IIT-Madras,
is joining Tarides. Tarides has worked closely with Segfault Systems over the
last couple of years, most notably on the award-winning Multicore OCaml project
and the upstreaming plans for OCaml 5.0. This alliance furthers the goals of
Tarides, bringing the compiler and benchmarking expertise of the Segfault team
directly into the Tarides organisation.</p>
<p>KC Sivaramakrishnan, CEO &amp; CTO of Segfault Systems says that &ldquo;Segfault Systems
was founded to secure the foundations of scalable systems programming in OCaml.
We have successfully incorporated cutting-edge research on
<a href="https://dl.acm.org/doi/10.1145/3453483.3454039">concurrent</a> and
<a href="https://dl.acm.org/doi/10.1145/3408995">parallel</a> programming into OCaml. This
addresses the long-standing need of OCaml developers to utilise the widely
available multicore processing on modern machines. Tarides is at the forefront
of OCaml developer tooling and platform support, and we are excited to join the
team to make OCaml the best tool for industrial-strength concurrent and parallel
programming.&rdquo;</p>
<p>&ldquo;We&rsquo;re thrilled to have the Segfault Systems team join Tarides,&rdquo; says Thomas
Gazagnaire, CTO of Tarides. &ldquo;They have been integral to the success of the
Multicore OCaml project, which has combined cutting edge research and
engineering with consistent communication, promoting Multicore OCaml as an
upstream candidate to the core developer team, as well as
<a href="https://discuss.ocaml.org/tag/multicore-monthly">publishing monthly reports</a>
for the wider community. We look forward to working with our new partners to
make OCaml the tool of choice for developers.&rdquo;</p>
<p>All of Segfault Systems&rsquo; existing responsibilities and open-source commitments
will migrate over to Tarides, where work will continue towards the three main
objectives in 2022:</p>
<ul>
<li>Releasing OCaml 5.0 with support for domains and effect handlers</li>
<li>Supporting the ecosystem to migrate the OCaml community over to OCaml 5.0</li>
<li>Improving developer productivity for OCaml 5.0 by releasing the best platform
tools</li>
</ul>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#ocaml-50" aria-label="ocaml 50 permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>OCaml 5.0</h1>
<p>The next major release of OCaml, version 5.0, will feature primitive support for
parallel and concurrent programming through domains and effect handlers. The
goal is to ensure that the fine balance that OCaml has struck between ease of
use, correctness and performance over the past 25 years continues into the
future with these additional features.</p>
<p>Domains enable shared-memory parallel programming allowing OCaml programs to run
on multiple cores: with domains, OCaml programs will scale better by exploiting
multicore processing. Effect handlers are a mechanism for concurrent
programming: with the introduction of effect handlers, simple direct-style OCaml
code will be flexible, easy to develop, debug and maintain (no more monads for
concurrency!). These features will benefit the entire ecosystem and community,
and we expect it to attract many new users to the language.</p>
<p>As part of the Multicore OCaml project, the team developed
<a href="https://github.com/ocaml-bench/sandmark">Sandmark</a>, a suite of sequential and
parallel benchmarks together with the infrastructure necessary to carefully run
the programs and analyse the results. Sandmark has been instrumental in
assessing and tuning the scalability of parallel OCaml programs and ensuring
that OCaml 5.0 does not introduce performance regressions for existing
sequential programs compared to OCaml 4.</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/12df31eaf97ae56b3834fd6308095524/bce1e/scalability.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 74.11764705882352%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAPCAYAAADkmO9VAAAACXBIWXMAAAsTAAALEwEAmpwYAAACQ0lEQVR42k2U25akMAhF/f9PrdJozA0I5MwC7Z5+SFkSCORscFNV673jPE9c14njPCFzgpmRUsK+7xhjYM4Z7+53HAeu6wrbfd9I6Vw5Z49JWynFzAxqC1cXXH2CZGKZYa0VK/ZVf99/ltt8D8DyH54zbZ/Px6YtfO+OThIO9nuYvQc/NjXF4CehryeR4ay08lDkTmmrtdhRBmgq8Gae+gZOfZZMDBYclZGH4KaJQhI+eyF0nlGhmaWNZZpvMBH6GBBmqBlSHficd6yzdAyZ6MSg0cE0sEzjRrUPt6055dFQRMy1KKWGwETkyULwWgpqLZgiYfO987zCz/c9rtaKnPNqrTm8tF3XZfYHQFx5alT53/ZAsffdGYga5AVlZv+v7FAiu0zcnbG7nk55GRpPVBI0ktDVE9chSIVwVg4gbmvEi3R5fNrGGJbKwFEpgt3Bg/d7IHdBcQidHyiFkBuDX4Buc7+r8RoaRbmG07z83hpyvqA6oydlathaq0/P2cJdG0q5Q1tyQKK474Jy5+WgmOip0KvyyfCJ+OnDqFQEgygq82ARCTC5dux3D13f7lj+f3pjp5TsLxC/igUA11Cjz6KJXwBXY1zNpXEY+j4fKKqWtuM44kAX/h6CQhMsGoFn49+p8edZKXyc8s/opUrYb1qZzGPSxswxKVejINh5xuFXpajWSXpgGxxA1jtuXt3dCKUz8FPhfKAIs+idsx77rqM3FRFlJj3PU/d919aauo8w6ff71ZSSjjHCb/TuPvP92nz/AcCWknYEqb1mAAAAAElFTkSuQmCC'); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/12df31eaf97ae56b3834fd6308095524/c5bb3/scalability.png" class="gatsby-resp-image-image" alt="Matrix of graphs showing scalability of various multicore OCaml workloads" title="" srcset="/static/12df31eaf97ae56b3834fd6308095524/04472/scalability.png 170w,
/static/12df31eaf97ae56b3834fd6308095524/9f933/scalability.png 340w,
/static/12df31eaf97ae56b3834fd6308095524/c5bb3/scalability.png 680w,
/static/12df31eaf97ae56b3834fd6308095524/b12f7/scalability.png 1020w,
/static/12df31eaf97ae56b3834fd6308095524/b5a09/scalability.png 1360w,
/static/12df31eaf97ae56b3834fd6308095524/bce1e/scalability.png 1696w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<p align="center"><i>Scalability of compute intensive OCaml programs</i></p>
<p>Sandmark is now run as <a href="https://sandmark.ocamllabs.io">a nightly service</a>
monitoring the performance of OCaml 5 as it is being developed. Development will
continue to make it even easier to use and more practical by fully integrating
it with <a href="https://github.com/ocurrent/current-bench">current-bench</a> (the continuous
benchmarking system based on OCurrent).
<a href="https://tarides.com/company/">Get in touch</a> if you want to know more.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#ecosystem" aria-label="ecosystem permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Ecosystem</h1>
<p>At Tarides we want all OCaml users to benefit from the new features that OCaml
5.0 will bring, and this means ensuring that the ecosystem is fully prepared. We
aim to develop and maintain a robust set of libraries that work with domains and
effects, together with a diverse parallel benchmarking and performance profiling
suite to use with OCaml 5 applications. The
<a href="https://discuss.ocaml.org/t/eio-0-1-effects-based-direct-style-io-for-ocaml-5/9298">first version of Eio</a>,
the effects-based direct-style IO stack for OCaml 5.0, has been released,
generating lots of interesting discussion within the community. Eio not only
makes it easier to develop, debug and maintain applications utilising
asynchronous IO, but is also able to take advantage of multiple cores when
available.</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/873029eb073713d1fbaf8ad64bcee1cd/133ae/http_load.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 66.47058823529413%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAANCAYAAACpUE5eAAAACXBIWXMAABYlAAAWJQFJUiTwAAABpklEQVR42pVT2Y7bMAzc//+5oi8B+hQkdhs01k3dB2dhx4A3TfOwFAZDUfKAFM2P3vsfAAmABxC+g3H4xEAfY/z8YGY9xoDShhcbQETQWsNai1rrW5RS0FtFSAV34wce9usj56xzzhDLnZffF0zTjNPphNvtBmZ+wRgM7L7LHdIFCCEOQSLSWhtoI1mGG6QUmKYJxpjto/9ZagzlPIJTQNYoXh6C3nsthYAj4tLbnsXYcNhDuPUBYx2cumNEDYyyxUspzxkuywLvPb9mtO97AxkJJf6iBANw+3qKkvMhGGPUSik45/4R3P3RMNwddS3vjb1kKIRYu7sL8rYeNz2aX+ALQVULWyxMNhvb8mBTDOTXN3TOaSnlVvLgR7y0BG9nGDvDVQ9bHHJLWM8792eggxI9N+XIELBJYdZnUFRYb73r9NuSa63a+wBtFJskIZNAHx3fsSfBdVJWjwLxfJ8x2timJaW0Yf3pY4wbrxOyxlb23m+xnQ/BMca8z6NLMVGphWKMFEKg8/lMl8uF5nmm6/VK0zRteyEEpZSo1kreewJgAVRm/vEJckDz870337gAAAAASUVORK5CYII='); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/873029eb073713d1fbaf8ad64bcee1cd/c5bb3/http_load.png" class="gatsby-resp-image-image" alt="Line chart showing the scalability of HTTP server implementations in OCaml, Rust and Go" title="" srcset="/static/873029eb073713d1fbaf8ad64bcee1cd/04472/http_load.png 170w,
/static/873029eb073713d1fbaf8ad64bcee1cd/9f933/http_load.png 340w,
/static/873029eb073713d1fbaf8ad64bcee1cd/c5bb3/http_load.png 680w,
/static/873029eb073713d1fbaf8ad64bcee1cd/b12f7/http_load.png 1020w,
/static/873029eb073713d1fbaf8ad64bcee1cd/b5a09/http_load.png 1360w,
/static/873029eb073713d1fbaf8ad64bcee1cd/133ae/http_load.png 1424w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<p align="center"><i>HTTP server performance using 24 cores</i></p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/d0eff71860d106c6e544df7b61f23d7b/2a08f/http_cores.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 66.47058823529413%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAANCAYAAACpUE5eAAAACXBIWXMAABYlAAAWJQFJUiTwAAAB0UlEQVR42o2Ti2obMRBF8/9fV2hpoA6Uljq2d7W29X7PKdqN4wTSx8Blh1l0pLkjPfTe5957BgIQb+pv8v+QBwT48gDYWitaa8k5c1Mpm3JOnG1kMRHrE8ZHjAubfOTqIqeL6Wzx7SGlZGOMWGultYaIgAg2Fi4ucYkNtSjm4x7rPcZ5TKyv0rGxGH8HWmutUmoFrjCgts7PJZC7IMlBvED1UBxkC+kK2SAtgWRy+gDonJPet/o1FGJt28JkeB+jgw69IWnANVnP74Gn0wljjIxWaxfOvsD1F+Twwths2HyXO/qlo5zzHei9X0+4AoG9Lrirghr4V3wINMbYZVlwYygC83REoiZLJbeELZY5zkxhwhTDNWt01luersQWcdHdgVrrVw9dzNjzkdg8R3dEF03thSaN2uv6HcqtEWql9YYvntm88dA5t57QhyBnNfN8+Y4Z0xT5Y6s+JNRiGOue98+oWd2BpRTrvWeaJ3n68Zks6W+ubUCvOJ937HZPPD5+5XA43IG3lzKrSZSe1zXOOUIIjGs08nHxN5Bf67lWFq3HINd/Sql3wENrzeecba3Ntt7Gy1k1NhuW7Pd7O03TsMaOlzXq0Qcbb3mMupRSgE+/AQXK8wbpvTSdAAAAAElFTkSuQmCC'); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/d0eff71860d106c6e544df7b61f23d7b/c5bb3/http_cores.png" class="gatsby-resp-image-image" alt="Line chart showing the load response of HTTP server implementations in OCaml, Rust and Go" title="" srcset="/static/d0eff71860d106c6e544df7b61f23d7b/04472/http_cores.png 170w,
/static/d0eff71860d106c6e544df7b61f23d7b/9f933/http_cores.png 340w,
/static/d0eff71860d106c6e544df7b61f23d7b/c5bb3/http_cores.png 680w,
/static/d0eff71860d106c6e544df7b61f23d7b/b12f7/http_cores.png 1020w,
/static/d0eff71860d106c6e544df7b61f23d7b/b5a09/http_cores.png 1360w,
/static/d0eff71860d106c6e544df7b61f23d7b/2a08f/http_cores.png 1422w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<p align="center"><i>HTTP server scaling maintaining a constant load of 1.5 million requests per second</i></p>
<p>The early results are quite promising. An HTTP server based on Eio is able to
serve 1M+ requests/sec on 24 cores, outperforming Go's <code>nethttp</code> and closely
matching Rust's <code>hyper</code> performance. Eio is still heavily under development.
Expect even better numbers for its stable release planned later this year.</p>
<p>The next step is to iterate on the design in collaboration with the community
and our partners. <a href="https://tarides.com/company/">Get in touch</a> if you have
performance-sensitive applications that you'd like to port to Eio, so we can
discuss how the design can meet your needs.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#ocaml-platform" aria-label="ocaml platform permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>OCaml Platform</h1>
<p>In collaboration with community members and commercial funders, Tarides has been
developing and defining the
<a href="https://v3.ocaml.org/learn/platform - [404 Not Found]">OCaml platform tool suite</a> for the last
four years. The goal of the platform is to provide OCaml developers with easy
access to high-quality, practical development tools to build any and every
project. We will continue to develop and maintain these tools, and make them
available for OCaml 5. <a href="https://tarides.com/company/">Reach out to us</a> if you
have specific feature requests to make your developer teams more efficient.</p>
<p>This alliance brings the headcount of Tarides up to 60+ people, all working
towards making OCaml the best language for any and every project.
<a href="https://tarides.com/company/">Join us</a>!</p>

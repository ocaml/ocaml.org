---
title: 'Debugging memory in OCaml: any advice?'
description:
url: https://www.donadeo.net/post/2012/debugging-memory-in-ocaml-any-advice
date: 2012-02-27T23:37:00-00:00
preview_image:
featured:
authors:
- pdonadeo
---

<div>
<a href="https://www.donadeo.net/static/2012/02/server_rss.png" title="Memory consumption chart" class="zoom-box-image"><img src="https://www.donadeo.net/static/2012/02/server_rss_small.png" class="little left" alt="Memory consumption chart"/></a>

<p class="noindent">A server I just deployed (written in OCaml, of course) seems to eat RAM at breakfast. This is the chart of the RSS field of &quot;ps&quot; in the past 24h (click to enlarge). The program starts with almost 6 Mb and is now reaching 40 Mb, in a linear trend that has nothing good to say.</p>

<p class="noindent">Any advice on how to debug the memory consumption?</p>
</div>

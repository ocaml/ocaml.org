---
title: Self Adjusting DOM and Diffable Data
description: In my last post, I gave some simple examples showing howyou could useself
  adjusting computations,or SAC, as embodied by our Incremental library, toincrementa...
url: https://blog.janestreet.com/self-adjusting-dom-and-diffable-data/
date: 2016-02-10T00:00:00-00:00
preview_image: https://blog.janestreet.com/static/img/header.png
featured:
---

<p>In my last <a href="https://blog.janestreet.com/self-adjusting-dom/">post</a>, I gave some simple examples showing how
you could use
<a href="http://www.umut-acar.org/self-adjusting-computation">self adjusting computations</a>,
or SAC, as embodied by our <a href="https://blog.janestreet.com/introducing-incremental/">Incremental</a> library, to
incrementalize the computation of virtual dom nodes. In this post, I&rsquo;d like to
discuss how we can extend this approach to more realistic scales, and some of
the extensions to Incremental itself that are required to get there.</p>



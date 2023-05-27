---
title: Creating Static Linux Binaries in OCaml
description:
url: http://rgrinberg.com/posts/static-binaries-tutorial/
date: 2017-11-03T00:00:00-00:00
preview_image:
featured:
authors:
- Rudi Grinberg
---

<p>Creating truly static binaries for Linux like golang is a capability that is
occasionally useful. I&rsquo;ve seen questions about it on IRC a few times, and I&rsquo;ve
personally found this approach is particularly useful when deploying to
environments where installing libraries isn&rsquo;t easy, such as AWS Lambda.
Unfortunately for me, the approach that I will explain in this article wasn&rsquo;t as
approachable. So I&rsquo;ve prepared a quick tutorial on how to easily create a static
binary in OCaml and test it.</p>


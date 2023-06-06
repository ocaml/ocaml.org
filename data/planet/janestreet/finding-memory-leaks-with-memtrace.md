---
title: Finding memory leaks with Memtrace
description: "Memory issues can be hard to track down. A function that onlyallocates
  a few small objects can cause a space leak if it\u2019s calledoften enough and those
  object..."
url: https://blog.janestreet.com/finding-memory-leaks-with-memtrace/
date: 2020-10-06T00:00:00-00:00
preview_image: https://blog.janestreet.com/finding-memory-leaks-with-memtrace/memory-leak.jpg
featured:
---

<p>Memory issues can be hard to track down. A function that only
allocates a few small objects can cause a space leak if it&rsquo;s called
often enough and those objects are never collected. Even then, many
objects are <em>supposed</em> to be long-lived. How can a tool, armed with data
on allocations and their lifetimes,
help sort out the expected from the suspicious?</p>



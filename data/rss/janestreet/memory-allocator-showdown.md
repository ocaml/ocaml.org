---
title: Memory allocator showdown
description: "Since version 4.10, OCaml offers a new best-fit memory allocatoralongside
  its existing default, the next-fit allocator. At JaneStreet, we\u2019ve seen a big
  impro..."
url: https://blog.janestreet.com/memory-allocator-showdown/
date: 2020-09-15T00:00:00-00:00
preview_image: https://blog.janestreet.com/memory-allocator-showdown/MemoryAllocator.jpg
featured:
---

Since version 4.10, OCaml offers a new best-fit memory allocator
alongside its existing default, the next-fit allocator. At Jane
Street, we've seen a big improvement after switching over to the new
allocator.

This post isn't about how the new allocator works. For that, the best
source is these notes from a talk by its
author.  Instead, this post is about just how tricky it is to compare two
allocators in a reasonable way, especially for a garbage-collected
system.
  


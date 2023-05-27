---
title: For the Right Hand
description: Useful generic functions are usually the result of composing useful generic
  functions; the fact that these are easy to write is, however, no...
url: https://alaska-kamtchatka.blogspot.com/2012/02/for-right-hand.html
date: 2012-02-22T13:43:00-00:00
preview_image:
featured:
authors:
- "Mat\xEDas Giovannini"
---

Useful generic functions are usually the result of composing useful generic functions; the fact that these are easy to write is, however, not an excuse for not having them in a rich prelude. Given a total function for splitting a list at a given point:
let rec split_at n = function
| []            -&gt; [], []
| l when n == 0 -&gt; [], l
| x :: xs       -&gt;
  let l, r = split_at (pred n) xs in
  x :: l,

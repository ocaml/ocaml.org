---
title: A minor branch off Braun Trees
description: Revisiting the post on Braun Trees  I noticed that, while pedagogical,
  the implementation of the root replacement operation rep  can be stre...
url: https://alaska-kamtchatka.blogspot.com/2012/07/minor-branch-off-braun-trees.html
date: 2012-07-12T15:00:00-00:00
preview_image:
featured:
authors:
- "Mat\xEDas Giovannini"
---

Revisiting the post on Braun Trees I noticed that, while pedagogical, the implementation of the root replacement operation rep can be streamlined a bit. By inlining the mutually recursive siftdown, specializing on the matches and adding guards, the result is as follows:


let rec rep compare e = function
| N (_, (N (el, _, _) as l), E)
  when compare el e  &lt; 0 -&gt;
  N (el, rep compare e l, E)
| N 

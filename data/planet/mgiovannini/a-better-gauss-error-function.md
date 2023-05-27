---
title: A Better (Gauss) Error Function
description: If you do statistics you know of erf  and erfc ; if you work in OCaml
  you surely miss them. It is not very difficult to port the canonical i...
url: https://alaska-kamtchatka.blogspot.com/2011/12/better-gauss-error-function.html
date: 2011-12-21T14:53:00-00:00
preview_image:
featured:
authors:
- "Mat\xEDas Giovannini"
---

If you do statistics you know of erf and erfc; if you work in OCaml you surely miss them. It is not very difficult to port the canonical implementation given by Numerical Recipes (which I won't show and not just for licensing reasons); if you Google for a coefficient you'll see that this approximation is, indeed, ubiquitous. There exists a better approximation in the literature, one that is more 

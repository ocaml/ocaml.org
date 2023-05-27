---
title: A First-Principles GIF Encoder
description: Also, quasicrystals . Have you ever found yourself wanting to do generated
  animations but didn't know how to visualize them? Since I couldn'...
url: https://alaska-kamtchatka.blogspot.com/2011/10/first-principles-gif-encoder.html
date: 2011-10-28T19:58:00-00:00
preview_image: //2.bp.blogspot.com/-T0tvKxVPtBA/TqsJCUxziaI/AAAAAAAAAQk/JvmSxw0GNac/w1200-h630-p-k-no-nu/quasicrystal.gif
featured:
authors:
- "Mat\xEDas Giovannini"
---

Also, quasicrystals. Have you ever found yourself wanting to do generated animations but didn't know how to visualize them? Since I couldn't find a self-contained GIF encoder, I made myself one. Even though it is not fast, I think its 220 lines are clear enough to be a good reference implementation to build upon. The encoder conforms to the following interface:
type palette
val palette : ?

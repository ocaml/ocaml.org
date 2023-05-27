---
title: Assessing Abstractions
description: Back to OCaml! Catching up with StackOverflow's OCaml questions , I found
  an interesting one  about private type abbreviations  in module si...
url: https://alaska-kamtchatka.blogspot.com/2012/07/assessing-abstractions.html
date: 2012-07-02T15:00:00-00:00
preview_image:
featured:
authors:
- "Mat\xEDas Giovannini"
---

Back to OCaml! Catching up with StackOverflow's OCaml questions, I found an interesting one about private type abbreviations in module signatures. One thing in that conversation that struck me as odd was the assertion that the compiler optimizes single-constructor variants, thereby subsuming the semantics of Haskell's all three declarators, data, type and newtype, into one. Definitive proof would

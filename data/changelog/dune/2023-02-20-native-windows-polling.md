---
title: Native polling mode for Windows
date: "2023-02-20-03"
tags: [dune, platform, feature]
---

Starting from Dune 3.7, Dune watch mode is now available on Windows!

[@yams-yams](https://github.com/yams-yams) and [@nojb](https://github.com/nojb)
from Lexifi have been working on integrating Windows native polling API with
Dune to supplement the support for `fswatch`, which is unavailable on Windows.

Windows users can now run `dune build -w` out of the box!

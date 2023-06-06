---
title: Embedding and projection in Lua-ML
description:
url: https://www.baturin.org/blog/lua-ml-embedding-and-projection
date: 2020-08-28T00:00:00-00:00
preview_image:
featured:
authors:
- Daniil Baturin
---


    One thing I find odd about many interpreter projects is that they are designed as standalone and can't be used as embedded
scripting languages. Lua-ML is completely different in that regard: it's designed as an extension language first and offers
some unique features for that use case, including a reconfigurable runtime library. You can remove modules from its standard library or replace
them with your own implementations. Of course, you can also pass OCaml values to Lua code and take them back in a type-safe manner too.
That aspect isn't very obvious or well-documented, so in this post we'll try to uncover it.
    

---
title: Abandoning Async
description:
url: http://rgrinberg.com/posts/abandoning-async/
date: 2014-12-11T00:00:00-00:00
preview_image:
featured:
authors:
- Rudi Grinberg
---

<p>There is an old and great schism in the OCaml community. The schism is
between two concurrency libraries - Async and Lwt. As usual for these
things, the two are very similar, and outsiders would wonder what the
big deal is about. The fundamental problem of course is that they&rsquo;re
mutually incompatible. The result of this is a split OCaml world with
almost no interoperability, and duplication of efforts.</p>


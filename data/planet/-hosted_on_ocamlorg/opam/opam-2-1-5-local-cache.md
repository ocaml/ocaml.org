---
title: "Security in opam's cache handling (before 2.1.5)"
authors: [ "Reynir", "Hannes"]
date: 2023-05-31T00:00:00-00:00
description: We are pleased that opam 2.1.5 has hit the road, since it contains a security fix since the local cache is considered trusted, and not all checksums are verified.
source:
  name: Opam blog
  url: ""
  tag: "personnal blog"
---

We are pleased that opam 2.1.5 has hit the road, since it contains a security fix since the local cache is considered trusted, and not all checksums are verified.

Opam uses a download cache since 2.0.0: if a source artifact is needed, first its hash is looked up in the local cache (`~/.opam/download-cache/<hash-algorihm>/<hash>`). Opam supports multiple hash algorithms, a cache lookup goes through all hash algorithms present in the opam file to build, unpack, or install. Before 2.1.5, the hash algorithm that lead to the cache hit was not checked (but all others were).

If a package specifies only a single (non-weak) hash algorithm, this lead to the source artifact taken as is, any error while writing the artifact into the cache, or reading it from the cache, was not detected. Also, in certain setups, if the download cache is shared (writable) across containers (for example in some CI systems), this leads to the possibility of cache poisoning.

Thanks to Raja and Kate, the issue was fixed in [PR 5538](https://github.com/ocaml/opam/pull/5538)

The timeline of this issue is as follows:
- Feb 23rd 2023 conducted black-box security audit of opam
- Feb 24th 2023 reported to the opam team
- Feb 27th 2023 video meeting with the opam team, explaining the issue further
- Mar 27th 2023 initial review meeting of the patches developed by the opam team
- May 9th 2023 public PR fixing the issue discovered
- May 25th 2023 release of opam 2.1.5

Why we are interested in the security of opam? We plan to improve the supply chain security for opam, and develop [conex](https://github.com/hannesm/conex). While developing conex, we validate the assumptions conex uses about opam. We did that in February 2023 with opam 2.1.2, and reported the missed assumptions to the opam development team.

As methodology we used a blackbox-testing, i.e. we used the opam binary for installing packages from a custom opam repository. We did not study the source code of opam extensively, neither did we exhaustively check opam: we only tested the assumptions that came to our mind while working on conex.

The collaborative work with the opam development team was great, they were open to our reporting and answered quickly. We have no knowledge of this issue being exploited in the wild - on some systems, the [opam sandbox](https://opam.ocaml.org/doc/FAQ.html#What-changes-does-opam-do-to-my-filesystem) avoids writing to the download-cache from within the opam file.


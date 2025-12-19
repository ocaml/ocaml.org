---
title: "OCaml Infrastructure: Relocating opam.ci.ocaml.org and ocaml.ci.dev"
tags: [infrastructure]
---

About six months ago, [`opam-repo-ci` (opam.ci.ocaml.org)](https://opam.ci.ocaml.org) suffered from a lack of system memory ([issue 220](https://github.com/ocurrent/opam-repo-ci/issues/220)) which caused it to be moved to the machine hosting [`ocaml-ci` (ocaml.ci.dev)](https://ocaml.ci.dev).

Subsequently, that machine suffered from BTRFS volume corruption ([issue 51](https://github.com/ocaml/infrastructure/issues/51)). Therefore, we moved both services to a larger new server. The data was efficiently migrated using BTRFS tools: `btrfs send | btrfs receive`.

Since the move, we have seen issues with BTRFS metadata. Plus, we have suffered from a build-up of subvolumes, as reported by other users: [Docker gradually exhausts disk space on BTRFS](https://github.com/moby/moby/issues/27653).

Unfortunately, both services went down on Friday evening ([issue 85](https://github.com/ocaml/infrastructure/issues/85)). Analysis showed over 500 BTRFS subvolumes, a shortage of metadata space, and insufficient space to perform a BTRFS _rebalance_.

Returning to the original configuration of splitting the `ci.dev` and OCaml.org services, they have been moved onto new and separate hardware. The underlying filesystem is now a RAID1-backed ext4, formatted with `-i 8192` in order to ensure the availability of sufficient inodes. Docker uses Overlayfs. RSYNC was used to copy the databases and logs from the old server. This change should add resilience and has doubled the capacity for storing history logs.

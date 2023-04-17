---
title: Dune-release 0.3.0
date: "2018-07-10"
tags: [dune-release, platform]
changelog: |
  - Store config files in `~/.config/dune/` instead of `~/.dune`
    to match what `dune` is doing (#27, @samoht)
  - Support opam 1.2.2 when linting (#29, @samoht)
  - Use `-p <pkg>` instead of `-n <pkg>` to follow dune convention
    (#30, #42, @samoht)
  - Default to `nano` if the EDITOR environment variable is not set. (#32, @avsm)
  - Fix location of documentation when `odoc` creates an `_html` subdirectory
    (#34, @samoht)
  - Remove the browse command (#36, @samoht)
  - Re-add the publish delegatation mechanism to allow non-GitHub users to
    publish packages (see `dune-release help delegate`) (#37, @samoht)
  - Fix dropping of `v` at the beginning of version numbers in `dune-release opam`
    (#40, @let-def)
  - Add basic token validation (#40, @let-def)
---

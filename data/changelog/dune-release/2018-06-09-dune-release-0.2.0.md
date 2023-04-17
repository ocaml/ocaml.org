---
title: Dune-release 0.2.0
date: "2018-06-09"
tags: [dune-release, platform]
changelog: |
  - Remove opam lint warnings for 1.2 files (#2, @samoht)
  - Add a `--keep-v` option to not drop `v` at the beginning of version
    numbers (#6, @samoht)
  - Pass `-p <package>` to jbuilder (#8, @diml)
  - Fix a bug in `Distrib.write_subst` which could cause an infinite loop
    (#10, @diml)
  - Add a `--dry-run` option to avoid side-effects for all commands (@samoht)
  - Rewrite issues numbers in changelog to point to the right repository
    (#13, @samoht)
  - Stop force pushing tags to `origin`. Instead, just force push the release
    tag directly to the `dev-repo` repository (@samoht)
  - Fix publishing distribution when the the tag to publish is not the repository
    HEAD (#4, @samoht)
  - Do not depend on `opam-publish` anymore. Use configuration files stored
    in `~/.dune` to parametrise the publishing workflow. (@samoht)
---

---
title: Dune-release 1.0.0
date: "2018-09-23"
tags: [dune-release, platform]
changelog: |
  - Determine opam-repository fork user from URI (#64, @NathanReb and @diml)
  - All subcommands now support multiple package names (@samoht)
  - Do not remove `Makefile` from the distribution archives (#71, @samoht)
  - Do not duplicate version strings in opam file (#72, @samoht)
  - Fix configuration file upgrade from 0.2 (#55, @samoht)
  - Add a `--tag` option to select the release tag (@samoht)
  - Add a `--version` option to select the release version (@samoht)
  - Fix `--keep-v` (#70, @samoht)
  - Make `dune-release <OPTIONS>` a shorchut to  `dune-release bistro <OPTIONS>`
    (#75, @samoht)
  - Add a --no-open option to not open a browser after creating a new P
    (#79, @samoht)
  - Control `--keep-v` and `--no-auto-open` via options in the config file
    (#79, @samoht)
  - Be flexible with file names (#86 and #20, @anuragsoni)
---

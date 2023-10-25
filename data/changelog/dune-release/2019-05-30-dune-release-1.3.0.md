---
title: Dune-release 1.3.0
date: "2019-05-30"
tags: [dune-release, platform]
changelog: |
  - Add confirmation prompts in some commands. (#144, #146, @NathanReb)
  - Use github returned archive URL instead of guessing it. Fixes a bug
    when releasing a version with URL incompatible characters to github.
    (#143, @NathanReb)
  - Add logs to better describe commands behaviour. (#141, #137, #135, #150,
    #153, @NathanReb)
  - Fix a bug when publishing documentation to a repo for the first time
    (#136, @NathanReb)
  - Allow to submit package to a different opam-repository hosted on github.
    (#140, #152, @NathanReb)
  - Use `dune subst` for watermarking. (#147, @NathanReb)
  - Fix linting step so it checks for `CHANGES`, `LICENSE` and `README` again
---

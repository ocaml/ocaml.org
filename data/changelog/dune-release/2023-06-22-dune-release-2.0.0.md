---
title: Dune-release 2.0.0
date: "2023-06-22"
tags: [dune-release, platform, release]
changelog: |
  ### Added

  - Adopt the OCaml Code of Conduct (#473, @rikusilvola)
  - Added support for projects that have their OPAM files in the `opam/`
    subdirectory. (#466, @Leonidas-from-XIV)
  
  ### Changed
  
  - Running `dune-release check` now attempts to discover and parse the change
    log, and a new flag `--skip-change-log` disables this behaviour. (#458,
    @gridbugs)
  - List the main package and amount of subpackages when creating the PR to avoid
    very long package lists in PRs (#465, @emillon)
  
  ### Fixed
  
  - Avoid collision between branch and tag name. Tag detection got confused when
    branch was named the same as tag. Now it searches only for tag refs, instead
    of all refs. (#452, @3Rafal)
  - Fix project name detection from `dune-project`. The parser could get confused
    when opam file generation is used. Now it only considers the first `(name X)`
    in the file. (#445, @emillon)
  
  ### Removed
  
  - Remove support for delegates.
    Previous users of this feature should now use `dune-release delegate-info`
    and wrap dune-release calls in a script. See #188 for details.
    (#428, @NathanReb)
  - Removed support for the OPAM 1.2.2 client. This means `dune-release` expects
    the `opam` binary to be version 2.0 at least. (#406, #411,
    @Leonidas-from-XIV)
---

We're excited to announce the release of Dune-release 2.0.0!

This release brings support for putting your `.opam` files in a `opam/` directory. If your project contains dozens of packages, you'll be able to unclutter your root directory from all of these opam files!

Another notable change is the removal of delegates. Users of dune-release who want to publish their packages to another platform than GitHub can now use the `dune-release delegate-info` and use the output to build their own publication workflows.

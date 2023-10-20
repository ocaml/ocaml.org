---
title: "OPAM 1.1.0 release candidate out"
authors: [ "Louis Gesbert" ]
date: "2013-10-14"
description: "Release announcement for OPAM 1.1.0~rc1"
tags: [opam, platform]
changelog: |
   Too many to list here, see
   [https://raw.github.com/OCamlPro/opam/1.1.0-RC/CHANGES](https://raw.github.com/OCamlPro/opam/1.1.0-RC/CHANGES)

   For packagers, some new fields have appeared in the OPAM description format:
   - `depexts` provides facilities for dealing with system (non ocaml) 
   dependencies
   - `messages`, `post-messages` can be used to notify the user or help her troubleshoot at package installation.
   - `available` supersedes `ocaml-version` and `os` constraints, and can contain
   more expressive formulas
---

**OPAM 1.1.0 is ready**, and we are shipping a release candidate for
packagers and all interested to try it out.

This version features several bug-fixes over the September beta release, and
quite a few stability and usability improvements. Thanks to all beta-testers 
who have taken the time to file reports, and helped a lot tackling the 
remaining issues.

## Repository change to opam.ocaml.org

This release is synchronized with the migration of the main repository from 
ocamlpro.com to ocaml.org. A redirection has been put in place, so that all 
up-to-date installation of OPAM should be redirected seamlessly.
OPAM 1.0 instances will stay on the old repository, so that they won't be 
broken by incompatible package updates.

We are very happy to see the impressive amount of contributions to the OPAM 
repository, and this change, together with the licensing of all metadata under 
CC0 (almost pubic domain), guarantees that these efforts belong to the 
community.

# If you are upgrading from 1.0

The internal state will need to be upgraded at the first run of OPAM 1.1.0.
THIS PROCESS CANNOT BE REVERTED. We have tried hard to make it fault-
resistant, but failures might happen. In case you have precious data in your 
`~/.opam folder`, it is advised to **backup that folder before you upgrade to 1.1.0**.

## Installing

Using the binary installer:
- download and run http://www.ocamlpro.com/pub/opam_installer.sh

You can also get the new version either from Anil's unstable PPA:
   add-apt-repository ppa:avsm/ppa-testing
   apt-get update
   sudo apt-get install opam

or build it from sources at :
- http://www.ocamlpro.com/pub/opam-full-1.1.0.tar.gz
- https://github.com/OCamlPro/opam/releases/tag/1.1.0-RC

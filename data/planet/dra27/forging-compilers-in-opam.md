---
title: Forging compilers in opam
description: "As we settle into 2026, I have been doing a little early spring-cleaning.
  A few years ago, we had a slightly chaotic time in opam-repository over what should
  have been a migration from gforge.inria.fr to a new GitLab instance. Unfortunately,
  some release archives effectively disappeared from official locations, and although
  the content was available elsewhere, the precise archives weren\u2019t generally
  available, which is a problem for the checksums in opam files. We\u2019ve had similar
  problems with GitHub in the past. As a \u2018temporary solution\u2019, @avsm created
  ocaml/opam-source-archives to house copies of these archives (I think it\u2019s
  a somewhat prescient sha for that first commit!). As is so often the case with temporary
  solutions, it\u2019s grown somewhat. Rather against my personal better judgement,
  the repo got used to house files which used to be shipped as part of ocaml/opam-repository.
  Removing the files from the repository was a good change, because they were always
  being shipped as part of opam update, but unfortunately moving them to an \u201Carchive\u201D
  repository has made it rather too tempting to add new files, making an archive repository
  a primary source."
url: https://www.dra27.uk/blog/platform/2026/01/11/ocaml-config.html
date: 2026-01-11T00:00:00-00:00
preview_image:
authors:
- ""
source:
ignore:
---

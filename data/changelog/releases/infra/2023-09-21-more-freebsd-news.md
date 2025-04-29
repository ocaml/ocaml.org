---
title: "OCaml Infrastructure: FreeBSD Available in More Parts of the Infrastructure "
tags: [infrastructure]
---

Previously the infrastructure team had made FreeBSD available for [`opam-repo-ci`](https://opam.ci.ocaml.org). 
Now we can announce that the same support has been added to [`ocaml-ci`](https://ocaml.ci.dev), giving coverage for both OCaml 
4.14 and the new OCaml 5.1 release.  `opam-repo-ci` has also been upgraded to support OCaml 5.1. We aim to support both 4.14 as
the Long Term Support release and the latest 5.* release.

Additionally an [`opam-health-check` instance](http://freebsd-health-check.ocamllabs.io:8080) has been setup to provide 
continuous checking of opam repository packages against FreeBSD 13.2 x86_64 for both the 4.14 and 5.1 releases of OCaml. 
This will allow the community to check whether packages work on FreeBSD and provide fixes to `opam-repository` that will 
then get tested on FreeBSD. Closing the loop and giving the community the tools to support OCaml on FreeBSD effectively.

We hope the community finds the FreeBSD support useful. 

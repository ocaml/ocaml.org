---
title: "OCaml Infrastructure: Renaming opam.ci.ocaml.org / opam.ci3.ocamllabs.io"
tags: [infrastructure]
---

The intention is to retire the _ocamllabs.io_ domain.
Therefore any services using the domain will be redirected.
From today, the Web UI for Opam Repo CI is available on both
[opam-ci.ci3.ocamllabs.io](https://opam-ci.ci3.ocamllabs.io)
and [opam.ci.ocaml.org](https://opam.ci.ocaml.org)
with the service available at both
[opam-repo-ci.ci3.ocamllabs.io](https://opam-repo-ci.ci3.ocamllabs.io)
and [opam-repo.ci.ocaml.org](https://opam-repo.ci.ocaml.org).  In time,
the ocamllabs.io sites will issue HTTP 301 permanent redirect messages.

Previously, [opam.ci.ocaml.org](https://opam.ci.ocaml.org)
targetted a web server which issued an HTTP 302 redirect to
[opam.ci3.ocamllabs.io](https://opam.ci3.ocamllabs.io).  This redirection
has been removed.  [opam.ci.ocaml.org](https://opam.ci.ocaml.org) points
to the actual site.


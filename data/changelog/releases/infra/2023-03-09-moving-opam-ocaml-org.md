---
title: "OCaml Infrastructure: opam.ocaml.org Moves to Scaleway"
tags: [infrastructure]
---

Following @avsm post on [discuss.ocaml.org](https://discuss.ocaml.org/t/migration-opam-ocaml-org-moving-providers-this-week/11606), we are pleased to announce that DNS names have now been switched over.

> We are moving the opam.ocaml.org 2 servers between hosting providers, and wanted to give everyone clear notice that this happening. Over the next 24-48 hours, if you notice any unexpected changes in the way your opam archives work (for example, in your CI or packaging systems), then please do let us know immediately, either here or in ocaml/infrastructure#19 2.
> 
> The reason for the move is to take advantage of Scaleway’s generous sponsorship of ocaml.org, and to use their energy efficient renewable infrastructure 4 for our machines.
> 
> This also marks a move to building the opam website via the ocurrent 1 infrastructure, which leads to faster and more reliable updates to the hosted package archives (see here for the service graph and build logs 4). There are also now multiple machines behind the opam.ocaml.org 2 DNS (via round-robin DNS), and this makes it easier for us to publish the archives to a global CDN in the future.
> 
> But in the very short term, if something explodes unexpectedly, please do let us know.

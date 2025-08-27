---
title: "OCaml Infrastructure: Now using Tarsnap for VM Backups"
tags: [infrastructure]
---

Some of our ocaml.org services such as <watch.ocaml.org> involve storing user uploaded content.  We need a way to make sure these are backed up in case of information loss, and to date this has been adhoc (involving rsyncing to another machine).

We now have a [Tarsnap](https://tarsnap.com) account as `tarsnap@ocaml.org`, and it is first being used to store backups of the videos uploaded to the <watch.ocaml.org> service.  We'll expand its use to other infrastructures that also have precious data.

Other suggestions for backup services are welcome.  In general, we're looking for solutions that do not involve a lot of key management, and a reasonable amount of redundancy (but backing up across 2-3 other machines in different datacentres is probably sufficient).

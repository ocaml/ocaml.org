---
title: The Unison File Synchronizer
image: unison-thumb.jpg
url: http://www.cis.upenn.edu/%7Ebcpierce/unison/
---

[Unison](http://www.cis.upenn.edu/%7Ebcpierce/unison/) is a popular
file-synchronization tool for Windows and most flavors of Unix. It
allows two replicas of a collection of files and directories to be
stored on different hosts (or different disks on the same host),
modified separately, and then brought up to date by propagating the
changes in each replica to the other. Unlike simple mirroring or backup
utilities, Unison can deal with updates to both replicas: updates that
do not conflict are propagated automatically and conflicting updates are
detected and displayed. Unison is also resilient to failure: it is
careful to leave the replicas and its own private structures in a
sensible state at all times, even in case of abnormal termination or
communication failures.

*[Benjamin C. Pierce](http://www.cis.upenn.edu/%7Ebcpierce/) (University
of Pennsylvania), Unison project leader, says:* “I think Unison is a
very clear success for OCaml – in particular, for the extreme
portability and overall excellent engineering of the compiler and
runtime system. OCaml's strong static typing, in combination with its
powerful module system, helped us organize a large and intricate
codebase with a high degree of encapsulation. This has allowed us to
maintain a high level of robustness through years of work by many
different programmers. In fact, Unison may be unique among large OCaml
projects in having been *translated* from Java to OCaml midway through
its development. Moving to OCaml was like a breath of fresh air.”

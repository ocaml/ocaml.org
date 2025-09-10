---
title: Ocaml Security Disclosure Process
description: This page details the step-by-step process for how the OCaml security team handles the reporting, patching, and disclosure of security vulnerabilities.
meta_title: OCaml Security Disclosure Process
meta_description: This page details the step-by-step process for how the OCaml security team handles the reporting, patching, and disclosure of security vulnerabilities.
---

1. Someone (the *reporter*) reports a security issue to [security@ocaml.org](mailto:security@ocaml.org) or as a private GitHub issue in [ocaml/security-advisories](https://github.com/ocaml/security-advisories) repository.
2. The *OCaml security team* replies with "we have received your mail, we'll be back within a week" within three working days; "do you want your identity being disclosed to the upstream author and/or general public?"
3. The *OCaml security team* figures out who (the *responder*) wants to take the issue within the security team.
4. The *responder* looks at the issue, and if it is valid, it contacts the *upstream maintainer(s)* of the package, and/or the *opam maintainer(s)* or *author(s)* as appropriate (the *maintainer(s)*)
   - (4a.) The *responder* applies for a CVE number unless the *reporter* already has one.
   - (4b.) The *responder* figures out (with upstream authors) which versions are affected.
5. The *reporter*, *responder*, and *maintainer* discuss about the embargo &mdash; the usual period is 90 days (but publishing it earlier if there's a patch available is fine)
6. When the patch is available, discussion between *reporter*, *maintainer(s)*, and *responder* whether this fixes the issue (the *reporter* may have some test environment and can confirm it).
7. Potentially a pre-announcement about which package and when the advisory and patch will be published for core opam packages and high impact vulnerabilities.
8. The *responder* publishes the security advisory
   - (8b.) The advisory is sent to the [mailing list for security announcements](https://sympa.inria.fr/sympa/info/ocsf-ocaml-security-announcements)
   - (8c.) The *maintainer(s)* (or the *responder*) publishes the fixed opam package to opam.ocaml.org (and mark vulnerable packages unavailable)
   - (8d.) The *responder* publishes the security announcement also on the [database](https://github.com/ocaml/security-advisories), which is an input source for [OSV](https://osv.dev)

---
title: Ocaml Security
description: This page details the OCaml security disclosure process, including how to report vulnerabilities, the role and members of the OCaml Security Response Team (SRT), and their publications.
meta_title: OCaml Security
meta_description: This page details the OCaml security disclosure process, including how to report vulnerabilities, the role and members of the OCaml Security Response Team (SRT), and their publications.
---

## Reporting security issues

The [OCaml security advisory database](https://github.com/ocaml/security-advisories) documents known issues in OCaml libraries and open source tools. Anyone can report historical or low-impact issues as a PR to the security advisory database.

High-impact vulnerabilities should be reported privately to [security@ocaml.org](mailto:security@ocaml.org) (we do not use PGP). Alternatively, high-impact vulnerabilities can be reported via a [private GitHub issue](https://github.com/ocaml/security-advisories/security/advisories/new).

The Security Response Team (SRT) maintains a [security disclosure process](https://github.com/ocaml/security-advisories?tab=readme-ov-file#reporting-vulnerabilities) to coordinate security responses. Factors that influence whether or not we will deal with a report and embargo it include:

- How severe is the vulnerability?
- How widely used is the library or tool in which the issue occurs?
- Does the issue also affect other ecosystems, or is there already a security response underway? (We will not break someone else’s embargo.)

For example, a high-severity vulnerability affecting the OCaml toolchain or a popular library would likely warrant an embargo. If you are unsure, please contact the Security Response Team and we will help assess the impact.

## OCaml Security Response Team

The OCaml Security Response Team coordinates security response for high-impact vulnerabilities, and maintains the advisory database and associated tooling.

The current members of the SRT are:

- Hannes Mehnert - [@hannesm](https://github.com/hannesm) - individual, robur.coop
- Mindy Preston - [@yomimono](https://github.com/yomimono) - individual
- Joe - [@cfcs](https://github.com/cfcs) - individual
- Edwin Török - [@edwintorok](https://github.com/edwintorok) - individual
- Nicolás Ojeda Bär - [@nojb](https://github.com/nojb) - LexiFi
- Louis Roché - [@Khady](https://github.com/Khady) - ahrefs
- Boning Dong - Bloomberg

The SRT is an initiative of the [OCaml Software Foundation](https://ocaml-sf.org/)

### Former members

- May 2025 until December 2025: Maxim Grankin - [@maxim092001](https://github.com/maxim092001) - Bloomberg

## Mailing List For Security Announcements

On the public [mailing list ocsf-ocaml-security-announcements](https://sympa.inria.fr/sympa/info/ocsf-ocaml-security-announcements) every security advisory will be published. Everyone can subscribe to the mailing list - it is only for security advisories (i.e. there won't be any discussion on the mailing list).

## Security Guides

The SRT publishes security guides for OCaml programmers and project maintainers. Guides will be added or updated over time.

## SRT Reports

The SRT reports quarterly on our completed and ongoing work, and future plans.

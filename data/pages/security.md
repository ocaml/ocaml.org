---
title: Ocaml Security
description: This page details the OCaml security disclosure process, including how to report vulnerabilities, the role and members of the OCaml Security Response Team (SRT), and their publications.
meta_title: OCaml Security
meta_description: This page details the OCaml security disclosure process, including how to report vulnerabilities, the role and members of the OCaml Security Response Team (SRT), and their publications.
---

## Reporting security issues

The [OCaml security advisory database](https://github.com/ocaml/security-advisories) documents known issues in OCaml libraries and open source tools. Anyone can report historical or low-impact issues as a PR to the security advisory database.

High-impact vulnerabilities should be reported privately to security@ocaml.org (we do not use PGP). Alternatively, high-impact vulnerabilities can be reported via a private GitHub issue as follows:
- On GitHub, navigate to the main page of the repository. (https://github.com/ocaml/security-advisories)
- Under the repository name, click Security. ...
- Click Report a vulnerability to open the advisory form.
- Fill in the advisory details form. ...
- At the bottom of the form, click Submit report.

The Security Response Team maintains a [security disclosure process](/security-reporting) to coordinate security responses. Factors that influence whether or not we will deal with a report and embargo it include:

- How severe is the vulnerability?
- How widely used is the library or tool in which the issue occurs?
- Does the issue also affect other ecosystems, or is there already a security response underway? (We will not break someone else’s embargo.)

For example, a high-severity vulnerability affecting the OCaml toolchain or a popular library would likely warrant an embargo. If you are unsure, please contact the Security Response Team and we will help assess the impact.

## OCaml Security Response Team

The OCaml Security Response Team (SRT) coordinates security response for high-impact vulnerabilities, and maintains the advisory database and associated tooling.

The current members of the SRT are:

- Hannes Mehnert - @hannesm - individual, robur.coop
- Mindy Preston - @yomimono - individual
- Joe - @cfcs - individual
- Edwin Török - @edwintorok - individual
- Nicolás Ojeda Bär - @nojb - LexiFi
- Louis Roché - @Khady - ahrefs
- Maxim Grankin - @maxim092001 - Bloomberg

The SRT is an initiative of the OCaml Software Foundation

## Security Guides

The SRT publishes security guides for OCaml programmers and project maintainers. Guides will be added or updated over time.

### How to secure GitHub repositories

## SRT Reports

The SRT reports quarterly on our completed and ongoing work, and future plans.

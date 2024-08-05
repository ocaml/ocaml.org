---
title: "OCaml.org Newsletter: July 2024"
description: Monthly update from the OCaml.org maintainers.
date: "2024-08-05"
tags: [ocamlorg]
---

Welcome to the July 2024 edition of the OCaml.org newsletter! This update has been compiled by the OCaml.org maintainers. You can find [previous updates](https://discuss.ocaml.org/tag/ocamlorg-newsletter) on Discuss.

Our goal is to make OCaml.org the best resource for anyone who wants to get started and be productive in OCaml. The OCaml.org newsletter provides an update on our progress towards that goal and an overview of the changes we are working on.

We couldn't do it without all the amazing people who help us review, revise, and create better OCaml documentation and work on issues. Your participation enables us to so much more than we could just by ourselves. Thank you!

This newsletter covers:
- **Community-Driven Development of OCaml.org**
- **Recipes for the OCaml Cookbook:** Help us make the OCaml Cookbook really useful by contributing and reviewing recipes for common tasks!
- **Community & Marketing Pages Rework:** Implementation work in progress.
- **General Improvements:** As usual, we also worked on general maintenance and improvements, so we're highlighting some of the work that happened below.

## Community-Driven Development of OCaml.org

After reworking most of the OCaml.org website to be more useful, more usable, and nicer to look at, the team at Tarides that has been working on OCaml.org is disbanding. However, OCaml.org will continue to be maintained and extended by by the OCaml Platform and OCaml compiler contributors, as well as by the wider OCaml community.

You can reach out to [the OCaml.org maintainers](https://github.com/ocaml/ocaml.org?tab=readme-ov-file#maintainers) to discuss any bigger changes or additions you'd like to make. Contributions to improve existing features and bug fixes are always welcome!

### Open Issues for Contributors

You can find [open issues for contributors here](https://github.com/ocaml/ocaml.org/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22+no%3Aassignee)!


## Recipes for the OCaml Cookbook

The OCaml Cookbook is a place where OCaml developers share how to solve common tasks using packages from the ecosystem.

A recipe is a code sample and explanations on how to perform a task using a combination of open-source libraries.

The Cookbook is live at [ocaml.org/cookbook](https://ocaml.org/cookbook).

Here's how you can help:

1. Help review the [open pull requests for cookbook recipes](https://github.com/ocaml/ocaml.org/pulls?q=is%3Apr+is%3Aopen+label%3ACookbook)!
2. Contribute new recipes and tasks for the cookbook!

Thank you all for the many contributions! One area where we could use help is in reviewing and improving the suggested recipes and tasks.

**Relevant PRs and Activities:**
- (open) PR: cookbook recipes for parse-command-line-arguments [ocaml/ocaml.org#2573](https://github.com/ocaml/ocaml.org/pull/2573) by [@richardhuxton](https://github.com/richardhuxton)
- (open) PR: Cookbook Check a Webpage for Broken Links [ocaml/ocaml.org#2581](https://github.com/ocaml/ocaml.org/pull/2581)  by [@ggsmith842](https://github.com/ggsmith842)
- (open) PR: cookbook: "create and await promises": Lwt, Async [ocaml/ocaml.org#2584](https://github.com/ocaml/ocaml.org/pull/2584) by [@richardhuxton](https://github.com/richardhuxton)
- (open) PR: CookBook: read-csv - basic example of reading records from a CSV string [ocaml/ocaml.org#2589](https://github.com/ocaml/ocaml.org/pull/2589) by [@danielclarke](https://github.com/danielclarke)
- (open) PR: Cookbook: Email regex patch [ocaml/ocaml.org#2591](https://github.com/ocaml/ocaml.org/pull/2591) by [@F-Loyer](https://github.com/F-Loyer)
- Fixes and Improvements to existing recipes:
    - PR: Update 00-uri.ml: missing arg [ocaml/ocaml.org#2618](https://github.com/ocaml/ocaml.org/pull/2618) by [@ttamttam](https://github.com/ttamttam)

## Community & Marketing Pages Rework

We have [UI designs for the reworked and new pages of the community section](https://www.figma.com/file/7hmoWkQP9PgLTfZCqiZMWa/OCaml-Community-Pages?type=design&node-id=637%3A4539&mode=design&t=RpQlGvOpeg1a93AZ-1), and implementation is being worked on by [@oyenuga17](https://github.com/oyenuga17), our former Outreachy intern!

**Relevant PRs and Activities:**
- PR: Implement new community overview page [ocaml/ocaml.org#2605](https://github.com/ocaml/ocaml.org/pull/2605) by [@oyenuga17](https://github.com/oyenuga17)
- PR: Fix typo and case inconsistencies on community page [ocaml/ocaml.org#2616](https://github.com/ocaml/ocaml.org/pull/2616) by [@pjlast](https://github.com/pjlast)
- PR: Redesign OCaml Planet Page [ocaml/ocaml.org#2617](https://github.com/ocaml/ocaml.org/pull/2617) by [@oyenuga17](https://github.com/oyenuga17)


## General Improvements and Data Additions

**Summary:**

* The selected OS is now part of the anchor tag of the URL on the https://ocaml.org/install page. This allows people to link to quick install instructions for a specific OS.
* We appreciate the contributions to the OCaml documentation!
* We're checking for backlinks to OCaml.org again with Ahrefs.

**Relevant PRs and Activities:**
- (open) PR: Build on OCaml 5 (ocamlnet -safe-string workaround) [ocaml/ocaml.org#2609](https://github.com/ocaml/ocaml.org/pull/2609) by [@aantron](https://github.com/aantron)
- PR: Ahref tag [ocaml/ocaml.org#2571](https://github.com/ocaml/ocaml.org/pull/2571)  by [@cuihtlauac](https://github.com/cuihtlauac)
- PR: Issue #2583: Added OS Anchor Tags to ocaml.org/install [ocaml/ocaml.org#2600](https://github.com/ocaml/ocaml.org/pull/2600) by [@SisyphianLiger](https://github.com/SisyphianLiger)
- PR: Performance: cache search index digest until ocaml-docs-ci computes it [ocaml/ocaml.org#2620](https://github.com/ocaml/ocaml.org/pull/2620)  by [@sabine](https://github.com/sabine)
- Documentation
    - PR: Unwrapped libraries [ocaml/ocaml.org#2562](https://github.com/ocaml/ocaml.org/pull/2562)  by [@cuihtlauac](https://github.com/cuihtlauac)
    - PR: Explain folders bin, lib and _build [ocaml/ocaml.org#2568](https://github.com/ocaml/ocaml.org/pull/2568) by [@cuihtlauac](https://github.com/cuihtlauac)
    - PR: Use `layout opam` in `.envrc` in opam path doc [ocaml/ocaml.org#2597](https://github.com/ocaml/ocaml.org/pull/2597) by [@smorimoto](https://github.com/smorimoto)
    - PR: Use sudo in install tutorial [ocaml/ocaml.org#2558](https://github.com/ocaml/ocaml.org/pull/2558) by [@cuihtlauac](https://github.com/cuihtlauac)
    - PR: Add documentation about comments to Tour of Ocaml [ocaml/ocaml.org#2613](https://github.com/ocaml/ocaml.org/pull/2613) by [@NoahTheDuke](https://github.com/NoahTheDuke)
    - PR: Fix Example referencing Type not yet Defined [ocaml/ocaml.org#2606](https://github.com/ocaml/ocaml.org/pull/2606) by [@avlec](https://github.com/avlec)
- Refactor + Code health:
    - PR: Open Data_intf in data.mli [ocaml/ocaml.org#2563](https://github.com/ocaml/ocaml.org/pull/2563)  by [@cuihtlauac](https://github.com/cuihtlauac)
    - PR: Make data error file path copy-paste ready [ocaml/ocaml.org#2567](https://github.com/ocaml/ocaml.org/pull/2567)  by [@cuihtlauac](https://github.com/cuihtlauac)
    - PR: Test ocaml/setup-ocaml v3 [ocaml/ocaml.org#2570](https://github.com/ocaml/ocaml.org/pull/2570)  by [@cuihtlauac](https://github.com/cuihtlauac)
    - PR: Update ocaml/setup-ocaml to v3 [ocaml/ocaml.org#2565](https://github.com/ocaml/ocaml.org/pull/2565) by [@smorimoto](https://github.com/smorimoto)
    - PR: Refactoring parts from PR #2443 [ocaml/ocaml.org#2576](https://github.com/ocaml/ocaml.org/pull/2576)  by [@cuihtlauac](https://github.com/cuihtlauac)
    - PR: Bump peter-evans/create-pull-request from 5 to 6 [ocaml/ocaml.org#2588](https://github.com/ocaml/ocaml.org/pull/2588)  by [@dependabot](https://github.com/dependabot)
    - PR: Set OCaml to 4.14.2 [ocaml/ocaml.org#2587](https://github.com/ocaml/ocaml.org/pull/2587) by [@cuihtlauac](https://github.com/cuihtlauac)
    - PR: fix: write directory instead of folder [ocaml/ocaml.org#2572](https://github.com/ocaml/ocaml.org/pull/2572) by [@ashish0kumar](https://github.com/ashish0kumar)
    - PR: sync debug-ci and ci [ocaml/ocaml.org#2582](https://github.com/ocaml/ocaml.org/pull/2582)  by [@cuihtlauac](https://github.com/cuihtlauac)
- Data
    - PR: changelog: dune 3.16.0 [ocaml/ocaml.org#2566](https://github.com/ocaml/ocaml.org/pull/2566) by [@emillon](https://github.com/emillon)
    - PR: (data) add OCaml.org newsletter June 2024 [ocaml/ocaml.org#2575](https://github.com/ocaml/ocaml.org/pull/2575)  by [@sabine](https://github.com/sabine)
    - PR: Add changelog for the latest merlin releases [ocaml/ocaml.org#2580](https://github.com/ocaml/ocaml.org/pull/2580)  by [@voodoos](https://github.com/voodoos)
    - PR: Add changelog for the latest ocaml-lsp release [ocaml/ocaml.org#2593](https://github.com/ocaml/ocaml.org/pull/2593)  by [@PizieDust](https://github.com/PizieDust)
    - PR: Add missing changelog for opam 2.2.0 [ocaml/ocaml.org#2598](https://github.com/ocaml/ocaml.org/pull/2598)  by [@kit-ty-kate](https://github.com/kit-ty-kate)
    - PR: Add changelog entry for ppxlib.0.33.0 release [ocaml/ocaml.org#2615](https://github.com/ocaml/ocaml.org/pull/2615) by [@NathanReb](https://github.com/NathanReb)

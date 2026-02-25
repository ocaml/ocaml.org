---
title: "OCaml.org Newsletter: April 2024"
description: Monthly update from the OCaml.org team.
date: "2024-05-08"
tags: [ocamlorg]
---

Welcome to the April 2024 edition of the OCaml.org newsletter! This update has been compiled by the OCaml.org team. You can find [previous updates](https://discuss.ocaml.org/tag/ocamlorg-newsletter) on Discuss.

Our goal is to make OCaml.org the best resource for anyone who wants to get started and be productive in OCaml. The OCaml.org newsletter provides an update on our progress towards that goal and an overview of the changes we are working on.

We couldn't do it without all the amazing people who help us review, revise, and create better OCaml documentation and work on issues. Your participation enables us to so much more than we could just by ourselves. Thank you!

This newsletter covers:
- **OCaml Cookbook:** We shipped a new, community-driven section in the Learn area. Help us make it really useful by contributing and reviewing recipes for common tasks!
- **Community & Marketing Pages Rework:** We have UI designs for the reworked and new pages of the community section and are starting work to implement these.
- **General Improvements:** As usual, we also worked on general maintenance and improvements, so we're highlighting some of the work that happened below.

## Open Issues for Contributors

You can find [open issues for contributors here](https://github.com/ocaml/ocaml.org/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22+no%3Aassignee)!

Here's some new (and as of time of writing this newsletter still open) issues that were opened this month:

- Package Versions page is missing dark mode styles [ocaml/ocaml.org#2341](https://github.com/ocaml/ocaml.org/issues/2341)  by [@sabine](https://github.com/sabine)
- (Data) Extend the Data Model of Academic Institution to Record Information about Course Materials [ocaml/ocaml.org#2328](https://github.com/ocaml/ocaml.org/issues/2328)  by [@sabine](https://github.com/sabine)
  
## The OCaml Cookbook

We shipped a new, community-driven section in the Learn area: the OCaml Cookbook!

The OCaml Cookbook is a place where OCaml developers share how to solve common tasks using packages from the ecosystem.

A task is something that needs to be done inside a project. A recipe is a code sample and explanations on how to perform a task using a combination of open source libraries.

The Cookbook now live at [ocaml.org/cookbook](https://ocaml.org/cookbook), but there are not a lot of recipes published yet.

Here's how we need your help:

1. Help review [open pull requests for cookbook recipes](https://github.com/ocaml/ocaml.org/pulls?q=is%3Apr+is%3Aopen+label%3ACookbook)!
2. Contribute new recipes and tasks for the cookbook!
3. Suggest improvements to existing recipes and the UI.

**Relevant PRs and Activities:**
- Open PRs in need of reviewers:
  - PR: Cookbook geodesic [ocaml/ocaml.org#2381](https://github.com/ocaml/ocaml.org/pull/2381) by [@F-Loyer](https://github.com/F-Loyer)
  - PR: Cookbook / subprocess creation [ocaml/ocaml.org#2382](https://github.com/ocaml/ocaml.org/pull/2382)  by [@F-Loyer](https://github.com/F-Loyer)
  - PR: Cookbook getenv [ocaml/ocaml.org#2383](https://github.com/ocaml/ocaml.org/pull/2383)  by [@F-Loyer](https://github.com/F-Loyer)
  - PR: Cookbook : linalg [ocaml/ocaml.org#2386](https://github.com/ocaml/ocaml.org/pull/2386)  by [@F-Loyer](https://github.com/F-Loyer)
   - PR: Use camlzip and with_open_text [ocaml/ocaml.org#2371](https://github.com/ocaml/ocaml.org/pull/2371)  by [@cuihtlauac](https://github.com/cuihtlauac)
   - PR: Deserialise and post-process YAML recipes [ocaml/ocaml.org#2372](https://github.com/ocaml/ocaml.org/pull/2372)  by [@cuihtlauac](https://github.com/cuihtlauac)
   - PR: Rebased database recipes [ocaml/ocaml.org#2376](https://github.com/ocaml/ocaml.org/pull/2376)  by [@cuihtlauac](https://github.com/cuihtlauac)
   - PR: Rebased basic concurrency recipe [ocaml/ocaml.org#2377](https://github.com/ocaml/ocaml.org/pull/2377)  by [@cuihtlauac](https://github.com/cuihtlauac)
   - PR: Rebased sorting recipe [ocaml/ocaml.org#2378](https://github.com/ocaml/ocaml.org/pull/2378)  by [@cuihtlauac](https://github.com/cuihtlauac)
   - PR: Rebased ascii and utf-8 recipes [ocaml/ocaml.org#2379](https://github.com/ocaml/ocaml.org/pull/2379)  by [@cuihtlauac](https://github.com/cuihtlauac)

## Community & Marketing Pages Rework

We have [UI designs for the reworked and new pages of the community section](https://www.figma.com/file/7hmoWkQP9PgLTfZCqiZMWa/OCaml-Community-Pages?type=design&node-id=637%3A4539&mode=design&t=RpQlGvOpeg1a93AZ-1) and are starting work to implement these. We are opening small issues for contributors to help. :orange_heart: 

**Relevant PRs and Activities:**
- PR: UI: Added  DateTime of Event on the Client Side in the User's Timezone [ocaml/ocaml.org#2339](https://github.com/ocaml/ocaml.org/pull/2339) by [@maha-sachin](https://github.com/maha-sachin)
- PR: Create new Events page with routing under Community [ocaml/ocaml.org#2338](https://github.com/ocaml/ocaml.org/pull/2338) by [@shakthimaan](https://github.com/shakthimaan)
- PR: Add event_type field to Events, and render tag in Event cards [ocaml/ocaml.org#2366](https://github.com/ocaml/ocaml.org/pull/2366) by [@csaltachin](https://github.com/csaltachin)

## General Improvements and Data Additions

**Relevant PRs and Activities:**
- Bugfixes
    - PR: fix: add .modules style for odoc-generated documentation pages [ocaml/ocaml.org#2355](https://github.com/ocaml/ocaml.org/pull/2355)  by [@sabine](https://github.com/sabine)
    - PR: Fix: correct text color on community resource card [ocaml/ocaml.org#2329](https://github.com/ocaml/ocaml.org/pull/2329)  by [@sabine](https://github.com/sabine)
    - PR: fix: Make Community card about LearnOCaml point to the correct URL [ocaml/ocaml.org#2331](https://github.com/ocaml/ocaml.org/pull/2331)  by [@yurug](https://github.com/yurug)
- Documentation
    - PR: OCaml Tour: -New sections- Introduction and Before We Begin. Added REPL definition and double semicolon use [ocaml/ocaml.org#2336](https://github.com/ocaml/ocaml.org/pull/2336) by [@Alfredo-Carlon](https://github.com/Alfredo-Carlon)
    - PR: Minor line editing on "Values and Functions" Tutorial [ocaml/ocaml.org#2321](https://github.com/ocaml/ocaml.org/pull/2321) by [@jeuxdeau](https://github.com/jeuxdeau)
- Data
    - PR: [planet]: add melange blog [ocaml/ocaml.org#2362](https://github.com/ocaml/ocaml.org/pull/2362) by [@anmonteiro](https://github.com/anmonteiro)
    - PR: (data) add april OUPS meetup [ocaml/ocaml.org#2360](https://github.com/ocaml/ocaml.org/pull/2360)  by [@sabine](https://github.com/sabine)
    - PR: Add TUM as an academic institution  [ocaml/ocaml.org#2347](https://github.com/ocaml/ocaml.org/pull/2347) by [@PumPum7](https://github.com/PumPum7)
    - PR: Add Routine job post. [ocaml/ocaml.org#2325](https://github.com/ocaml/ocaml.org/pull/2325) by [@mefyl](https://github.com/mefyl)
    - PR: (data) Add OCaml Workshop to Upcoming Events [ocaml/ocaml.org#2326](https://github.com/ocaml/ocaml.org/pull/2326) by [@sabine](https://github.com/sabine)
    - PR: (data) add ReasonSTHLM meetup [ocaml/ocaml.org#2308](https://github.com/ocaml/ocaml.org/pull/2308)  by [@sabine](https://github.com/sabine)
    - PR: Add missing Mdx changelogs [ocaml/ocaml.org#2368](https://github.com/ocaml/ocaml.org/pull/2368) by [@tmattio](https://github.com/tmattio)
    - PR: Fix small typo in Dune 3.14 announcement [ocaml/ocaml.org#2315](https://github.com/ocaml/ocaml.org/pull/2315) by [@Leonidas-from-XIV](https://github.com/Leonidas-from-XIV)
    - PR: Dune 3.15.0 announcement [ocaml/ocaml.org#2316](https://github.com/ocaml/ocaml.org/pull/2316) by [@Leonidas-from-XIV](https://github.com/Leonidas-from-XIV)
    - PR: OCaml 5.2.0-beta2 changelog entry [ocaml/ocaml.org#2343](https://github.com/ocaml/ocaml.org/pull/2343)  by [@Octachron](https://github.com/Octachron)
    - PR: (data) add March 2024 OCaml.org newsletter [ocaml/ocaml.org#2317](https://github.com/ocaml/ocaml.org/pull/2317) by [@sabine](https://github.com/sabine)
    - PR: Add the announement for opam 2.2.0~beta2 [ocaml/ocaml.org#2334](https://github.com/ocaml/ocaml.org/pull/2334) by [@kit-ty-kate](https://github.com/kit-ty-kate)
    - PR: jobs: remove XenServer positions [ocaml/ocaml.org#2387](https://github.com/ocaml/ocaml.org/pull/2387) by [@edwintorok](https://github.com/edwintorok)
- Move of the OCaml Language Manual from v2.ocaml.org to ocaml.org
    - PR: fix: Serve manual under /lts and /latest URLs [ocaml/ocaml.org#2345](https://github.com/ocaml/ocaml.org/pull/2345)  by [@sabine](https://github.com/sabine)
    - PR: Remove /manual/lts URL, fix broken route for /manual/latest [ocaml/ocaml.org#2348](https://github.com/ocaml/ocaml.org/pull/2348)  by [@sabine](https://github.com/sabine)
    - PR: Add /api/** redirection [ocaml/ocaml.org#2352](https://github.com/ocaml/ocaml.org/pull/2352) by [@mtelvers](https://github.com/mtelvers)
    - PR: Handle lts, default and missing version in middleware [ocaml/ocaml.org#2358](https://github.com/ocaml/ocaml.org/pull/2358) by [@cuihtlauac](https://github.com/cuihtlauac)
    - PR: Add served pages to sitemap [ocaml/ocaml.org#2363](https://github.com/ocaml/ocaml.org/pull/2363) by [@cuihtlauac](https://github.com/cuihtlauac)
    - PR: Skip unreleased manuals from sitemap [ocaml/ocaml.org#2367](https://github.com/ocaml/ocaml.org/pull/2367)  by [@cuihtlauac](https://github.com/cuihtlauac)
    - PR: Turn some v2 redirects into local [ocaml/ocaml.org#2356](https://github.com/ocaml/ocaml.org/pull/2356)  by [@cuihtlauac](https://github.com/cuihtlauac)
- Refactor / Code health
    - PR: Remove Commit module from Global [ocaml/ocaml.org#2319](https://github.com/ocaml/ocaml.org/pull/2319)  by [@cuihtlauac](https://github.com/cuihtlauac) (created/merged: 2024-04-05T14:17:31Z)
     - PR: chore: remove learn_sidebar.eml, which was not used anymore [ocaml/ocaml.org#2342](https://github.com/ocaml/ocaml.org/pull/2342)  by [@sabine](https://github.com/sabine)
     - PR: Add link to deploy.ci.ocaml.org in HACKING [ocaml/ocaml.org#2354](https://github.com/ocaml/ocaml.org/pull/2354) by [@cuihtlauac](https://github.com/cuihtlauac)
     - PR: Use type annotation for data parameters [ocaml/ocaml.org#2384](https://github.com/ocaml/ocaml.org/pull/2384)  by [@cuihtlauac](https://github.com/cuihtlauac)

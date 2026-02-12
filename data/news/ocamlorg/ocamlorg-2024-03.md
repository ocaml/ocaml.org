---
title: "OCaml.org Newsletter: March 2024"
description: Monthly update from the OCaml.org team.
date: "2024-04-04"
tags: [ocamlorg]
---

Welcome to the March 2024 edition of the OCaml.org newsletter! This update has been compiled by the OCaml.org team. You can find [previous updates](https://discuss.ocaml.org/tag/ocamlorg-newsletter) on Discuss.

Our goal is to make OCaml.org the best resource for anyone who wants to get started and be productive in OCaml. The OCaml.org newsletter provides an update on our progress towards that goal and an overview of the changes we are working on.

We couldn't do it without all the amazing OCaml community members who help us review, revise, and create better OCaml documentation. Your feedback enables us to better prioritise our work. Thank you!

This newsletter covers:
- **OCaml Cookbook:** A prototype of an OCaml cookbook that provides short code examples that solve practical problems using packages from the OCaml ecosystem is on staging.ocaml.org/cookbook.
- **Dark Mode:** We enabled the dark mode on all pages of OCaml.org, based on your operating system / browser settings.
- **Community & Marketing Pages Rework:** We are seeking feedback on wireframes for the community section and for the marketing-related pages.
- **General Improvements:** As usual, we also worked on general maintenance and improvements based on user feedback, so we're highlighting some of our work below.

## Open Issues for Contributors

You can find [open issues for contributors here](https://github.com/ocaml/ocaml.org/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22+no%3Aassignee)!

## Upcoming OCaml Cookbook

We're in the process of adding a community-driven section to the Learn area: the OCaml Cookbook. This cookbook is designed as a collection of recipes, offering code samples for tackling real-world tasks using packages from the OCaml ecosystem. It's a practical effort to enrich our learning resources, making them more applicable and useful for our community.

This month, our focus shifted towards finalizing the cookbook for release. This includes
- restructuring the directory structure and placement of recipe files, and
- adding tasks to the cookbook, so that you can contribute recipes for these tasks (we took inspiration from the excellent [Rust Cookbook](https://rust-lang-nursery.github.io/rust-cookbook/)).

It will always be possible to propose more tasks for the OCaml Cookbook. The main criteria here are:
1. task must require more than just a single Standard Library function call to solve,
2. task must be focused on common problems that occur when trying to build products,
3. if in doubt, make the task more specific, instead of more generic.

A good place to give feedback on the cookbook is [this discuss thread](https://discuss.ocaml.org/t/feedback-help-wanted-upcoming-ocaml-org-cookbook-feature/14127/10).

**Relevant PRs and Activities:**
- [(WIP) Cookbook compression / decompression](https://github.com/ocaml/ocaml.org/pull/2133) by @F-Loyer
- [Cookbook : fix in Lwt (type mismatch with iter_s/iter_p functions)](https://github.com/ocaml/ocaml.org/pull/2127) by @F-Loyer
- [Update 00-caqti-ppx-rapper.ml - fix caqti-driver-sqlite -> caqti-driver-sqlite3](https://github.com/ocaml/ocaml.org/pull/2126) by @F-Loyer


## Dark Mode Released

We're happy to anounce that we shipped the Dark Mode for OCaml.org. Dark mode is activated based on your operating system / browser settings. If you see anything wrong, please open an issue and include the URL on which you're seeing a problem.

**Relevant PRs and Activities:**
- [Announce Dark Mode on Discuss](https://discuss.ocaml.org/t/announcing-the-new-dark-mode-on-ocaml-org/14273)
- [Add Preliminary Dark Mode for Package Documentation](https://github.com/ocaml/ocaml.org/pull/2159) by @sabine
- [Fix: dark text color on blue background](https://github.com/ocaml/ocaml.org/pull/2138) by @amarachigoodness74
- [(dark mode) adjust breadcrumbs text color](https://github.com/ocaml/ocaml.org/pull/2161) by @sabine
- [(ui) Activate Dark Mode](https://github.com/ocaml/ocaml.org/pull/2160) by @sabine
- [Correctly invert text on "Is OCaml Web" page](https://github.com/ocaml/ocaml.org/pull/2191) by @SquidDev
- [fix: add missing darkmode styles for in-package search results](https://github.com/ocaml/ocaml.org/pull/2299) by @sabine
- [Remove legacy tailwind colors and styles, tidy up darkmode colors](https://github.com/ocaml/ocaml.org/pull/2301) by @sabine

## Homepage & Marketing Pages Rework

The Home page project kicked off with an analysis of user surveys and interviews, and the development of an initial wireframe for the homepage and the "Industrial Users" and "Academic Users" pages.

We've been [reaching out to the community on Discuss](https://discuss.ocaml.org/t/academic-ocaml-users-testimonials/14338) and Twitter to find what people say about OCaml, so we can give a bit more context through testimonials on the "Academic Users" page.

Besides this, we've been [asking on Twitter for ideas for the main tagline of the homepage](https://x.com/sabine_s_/status/1772264108479467629?s=20)

You can comment on the wireframes in Figma [here](https://www.figma.com/file/eLNSdvayxqvvfBsRsdbJXN/OCaml-Home-Page?type=design&node-id=5%3A2500&mode=design&t=hHclskuVpoOzKP2u-1).

If you have opinions on the homepage, feel free to share them in [this discuss thread](https://discuss.ocaml.org/t/your-feedback-needed-on-ocaml-home-page-wireframe/14366)!

## Community Section Rework


This week, we focused on creating wireframes for the Event, Job, Internship, and Workshop pages, followed by soliciting feedback from the community via Discuss. Concurrently, work commenced on the UI design for the Community Landing page, as well as the Event and Job pages.

We also made some improvements to the Events section on the Community page. This involves better treatment of start/end times of events, as well as listing more upcoming events.

If you have opinions on the community section, feel free to share them in [this discuss thread](https://discuss.ocaml.org/t/looking-for-ideas-for-the-community-page-at-ocaml-org/14032/9)!

**Relevant PRs and Activities:**
- Invite people to add events to events directory: https://discuss.ocaml.org/t/add-your-ocaml-events-to-the-community-page-on-ocaml-org/14251
- [Improve Events Directory](https://github.com/ocaml/ocaml.org/pull/2132) by @sabine
- [Fix template bug on upcoming events list](https://github.com/ocaml/ocaml.org/pull/2136) by @sabine 
- [Make clear upcoming event time is UTC](https://github.com/ocaml/ocaml.org/pull/2307) by @sabine
- Data contributed to events:
    - [(data) Add S-REPLS event](https://github.com/ocaml/ocaml.org/pull/2135) by @sabine
    - [(data) fix wrong date on event](https://github.com/ocaml/ocaml.org/pull/2143) by @sabine
    - [(data) Add OCaml Retreat Auroville](https://github.com/ocaml/ocaml.org/pull/2134) by @D8kTwoXfSUWLdpXruFrQiw 
    - [(data) add OCaml Manila Meetup](https://github.com/ocaml/ocaml.org/pull/2305) by @sabine

## Outreachy Application Period & Internship

In March, OCaml.org hosted the application period for one [Outreachy internship](https://www.outreachy.org/) on creating an interactive experience for solving OCaml exercises.

The process of selecting an Outreachy intern involved creating and managing 15 issues, reviewing 61 pull requests from 8 applicants. The tasks were similar in nature and dealt with restructuring the exercises to enable an interactive experience, adding test cases and solutions (where missing).

**Relevant PRs and Activities:**
- [Create practice folder](https://github.com/ocaml/ocaml.org/pull/2166) by @cuihtlauac
- [Sort exercises by slug before emitting template](https://github.com/ocaml/ocaml.org/pull/2227) by @csaltachin
- Turning exercises into practice @Ozyugoo, @mnaibei, @divyankachaudhari, @Kxrishx03, @maha-sachin, @MissJae, @jahielkomu, @Appleeyes

## General Improvements and Data Additions

**Relevant PRs and Activities:**
- (WIP) we're moving the OCaml Language Manual from v2.ocaml.org to ocaml.org
- set up dlvr.it to automatically post RSS feed items from OCaml Planet and OCaml Changelog to new ocaml_org Twitter account
- [Link to recently added videos on watch.ocaml.org](https://github.com/ocaml/ocaml.org/pull/2128) by @sabine
- [Change twitter account from OCamlLang to ocaml_org](https://github.com/ocaml/ocaml.org/pull/2111) by @sabine
- [fix: small improvements on news.eml](https://github.com/ocaml/ocaml.org/pull/2295) by @sabine
- [is yet category slug](https://github.com/ocaml/ocaml.org/pull/2303) by @cuihtlauac
- [Add a badge from the green web foundation to the carbon footprint page](https://github.com/ocaml/ocaml.org/pull/2241) by @0xrotense
- Deployment of odoc 2.4.1 to package documentation pipeline:
    - [Compatibility with odoc.2.4.1](https://github.com/ocaml-doc/voodoo/pull/128) by @gpetiot
    - [Patch for voodoo / odoc 2.4.1 upgrade](https://github.com/ocaml/ocaml.org/pull/2300) by @sabine
    - [chore: set doc url to live, after voodoo upgrade](https://github.com/ocaml/ocaml.org/pull/2304) by @sabine
- Data:
    - [(data) add ocaml.org newsletter February](https://github.com/ocaml/ocaml.org/pull/2154) by @sabine
    - [Changelog entry for OCaml 4.14.2~rc1](https://github.com/ocaml/ocaml.org/pull/2145) by @Octachron
    - [Add dune.3.14.2 announcement](https://github.com/ocaml/ocaml.org/pull/2190) by @Leonidas-from-XIV
    - [OCaml 4.14.2 release and changelog pages](https://github.com/ocaml/ocaml.org/pull/2225) by @Octachron
    - [OCaml 4.14.2: fix release year](https://github.com/ocaml/ocaml.org/pull/2286) by @edwintorok
    - [Add Platform changelogs for February 2024](https://github.com/ocaml/ocaml.org/pull/2288) by @tmattio
    - [Changelog entry for OCaml 5.2.0~beta1](https://github.com/ocaml/ocaml.org/pull/2291) by @Octachron
    - [Add Outreachy winter 2023 round](https://github.com/ocaml/ocaml.org/pull/2244) by @patricoferris
- Documentation:
  - [DOC: note about windows ppx_show](https://github.com/ocaml/ocaml.org/pull/2094) by @heathhenley
  - [(docs) Fix small typos](https://github.com/ocaml/ocaml.org/pull/2152) by @kenranunderscore
  - [(docs) Add link for instances of Array](https://github.com/ocaml/ocaml.org/pull/2146) by @rmeis06
  - [Linking exercise to tutorials](https://github.com/ocaml/ocaml.org/pull/2148) by @rmeis06
  - [Explain why t-first works with labels ](https://github.com/ocaml/ocaml.org/pull/2157) by @mikhailazaryan
  - [Document that begin ... end use](https://github.com/ocaml/ocaml.org/pull/2147) by @rmeis06
  - [Use uniform syntax for eval steps](https://github.com/ocaml/ocaml.org/pull/2183) by @cuihtlauac 
  - [Linking mentions of atomic module to doc](https://github.com/ocaml/ocaml.org/pull/2153) by @rmeis06
  - [Linking Bigarray references](https://github.com/ocaml/ocaml.org/pull/2163) by @rmeis06
  - [(docs) fix example in 'Libraries With Dune'](https://github.com/ocaml/ocaml.org/pull/2247) by @0xRamsi
  - [Fix typo in 4ad_01_operators.md](https://github.com/ocaml/ocaml.org/pull/2219) by @vog
  - [(docs) Use DkML 2.1.0](https://github.com/ocaml/ocaml.org/pull/2249) by @jonahbeckford

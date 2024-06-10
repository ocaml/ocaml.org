---
title: "OCaml.org Newsletter: May 2024"
description: Monthly update from the OCaml.org team.
date: "2024-06-10"
tags: [ocamlorg]
---

Welcome to the May 2024 edition of the OCaml.org newsletter! This update has been compiled by the OCaml.org team. You can find [previous updates](https://discuss.ocaml.org/tag/ocamlorg-newsletter) on Discuss.

Our goal is to make OCaml.org the best resource for anyone who wants to get started and be productive in OCaml. The OCaml.org newsletter provides an update on our progress towards that goal and an overview of the changes we are working on.

We couldn't do it without all the amazing people who help us review, revise, and create better OCaml documentation and work on issues. Your participation enables us to so much more than we could just by ourselves. Thank you!

This newsletter covers:
- **Recipes for the OCaml Cookbook:** Help us make the OCaml Cookbook really useful by contributing and reviewing recipes for common tasks!
- **Community & Marketing Pages Rework:** We have UI designs for the reworked and new pages of the community section and are starting to implement these. We made progress towards showing videos from the community on the OCaml Planet.
- **General Improvements:** As usual, we also worked on general maintenance and improvements, so we're highlighting some of the work that happened below.

## Open Issues for Contributors

You can find [open issues for contributors here](https://github.com/ocaml/ocaml.org/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22+no%3Aassignee)!

Here are some (as of writing this newsletter) open issues:

- [Running OCaml Receipes in repl.it #2456](https://github.com/ocaml/ocaml.org/issues/2456)
- [Use uucp caselesseq instead of structural equality and String.ascii_lowercase #2444](https://github.com/ocaml/ocaml.org/issues/2444)
- [OG images for OCaml Packages #1786](https://github.com/ocaml/ocaml.org/issues/1786)
  
## Recipes for the OCaml Cookbook

The OCaml Cookbook is a place where OCaml developers share how to solve common tasks using packages from the ecosystem.

A recipe is a code sample and explanations on how to perform a task using a combination of open source libraries.

The Cookbook is live at [ocaml.org/cookbook](https://ocaml.org/cookbook), but there are not a lot of recipes published yet.

When the cookbook was merged, all pull requests to the cookbook branch were automatically closed. We recreated these pull requests and they are ready for review.

Here's how you can help:

1. Review [open pull requests for cookbook recipes](https://github.com/ocaml/ocaml.org/pulls?q=is%3Apr+is%3Aopen+label%3ACookbook)!
2. Contribute new recipes and tasks for the cookbook!

**Relevant PRs and Activities:**
- PR: Add a checklist for OCaml Cookbook recipe review [ocaml/ocaml.org#2419](https://github.com/ocaml/ocaml.org/pull/2419) by [@sabine](https://github.com/sabine)
- PR: Cookbook filesystem [ocaml/ocaml.org#2399](https://github.com/ocaml/ocaml.org/pull/2399)
- PR: Cookbook networking [ocaml/ocaml.org#2400](https://github.com/ocaml/ocaml.org/pull/2400)
- PR: Cookbook xml [ocaml/ocaml.org#2401](https://github.com/ocaml/ocaml.org/pull/2401)
- PR: cookbook httpclient [ocaml/ocaml.org#2402](https://github.com/ocaml/ocaml.org/pull/2402)
- PR: cookbook uri [ocaml/ocaml.org#2403](https://github.com/ocaml/ocaml.org/pull/2403)
- PR: Cookbook regexp2 [ocaml/ocaml.org#2404](https://github.com/ocaml/ocaml.org/pull/2404)
- PR: Cookbook unzip [ocaml/ocaml.org#2405](https://github.com/ocaml/ocaml.org/pull/2405)
- PR: Cookbook linalg [ocaml/ocaml.org#2406](https://github.com/ocaml/ocaml.org/pull/2406)
- PR: Cookbook getenv [ocaml/ocaml.org#2407](https://github.com/ocaml/ocaml.org/pull/2407)
- PR: Cookbook shell [ocaml/ocaml.org#2408](https://github.com/ocaml/ocaml.org/pull/2408)
- PR: Cookbook geodesic [ocaml/ocaml.org#2409](https://github.com/ocaml/ocaml.org/pull/2409)
- PR: Add cookbooks for JSON serialisation and deserialisation [ocaml/ocaml.org#2415](https://github.com/ocaml/ocaml.org/pull/2415) by [@gpopides](https://github.com/gpopides)
- PR: Cookbook Encode and Decode Bytestrings from Hex-Strings [ocaml/ocaml.org#2445](https://github.com/ocaml/ocaml.org/pull/2445) by [@ggsmith842](https://github.com/ggsmith842)

## Community & Marketing Pages Rework

This month, we made some progress towards adding videos from the OCaml community (e.g., from YouTube and watch.ocaml.org) to the OCaml Planet.

Since the size of the OCaml Planet RSS feed grew so large that automation tools (`dlvr.it`) could no longer process it, we reduced the timeframe for posts to show up in the RSS feed to the last 90 days.

Contributor [@ishar19](https://github.com/ishar19) opened a pull request to add an RSS feed for the Community/Events page. This will allow posting new events to various social media automatically and allow you to subscribe to the Events RSS feed with a RSS reader of your choice.

We have [UI designs for the reworked and new pages of the community section](https://www.figma.com/file/7hmoWkQP9PgLTfZCqiZMWa/OCaml-Community-Pages?type=design&node-id=637%3A4539&mode=design&t=RpQlGvOpeg1a93AZ-1) and we are opening small issues for contributors to help. :orange_heart: 

**Relevant PRs and Activities:**
- The OCaml Planet
    - PR: Community videos scraping and list page [ocaml/ocaml.org#2441](https://github.com/ocaml/ocaml.org/pull/2441) by [@cuihtlauac](https://github.com/cuihtlauac)
    - PR: Scrape watch.ocaml.org as an RSS feed [ocaml/ocaml.org#2428](https://github.com/ocaml/ocaml.org/pull/2428)  by [@cuihtlauac](https://github.com/cuihtlauac)
    - PR: No longer feature posts on the OCaml Planet [ocaml/ocaml.org#2430](https://github.com/ocaml/ocaml.org/pull/2430) by [@cuihtlauac](https://github.com/cuihtlauac)
    - PR: Set the cutoff date for the OCaml Planet RSS feed to 90 days [ocaml/ocaml.org#2416](https://github.com/ocaml/ocaml.org/pull/2416)  by [@sabine](https://github.com/sabine)
    - PR: Filter OCaml Planet Blog posts for "OCaml" keyword [ocaml/ocaml.org#2443](https://github.com/ocaml/ocaml.org/pull/2443) by [@cuihtlauac](https://github.com/cuihtlauac)
    - PR: add redirect for /blog to /ocaml-planet [ocaml/ocaml.org#2450](https://github.com/ocaml/ocaml.org/pull/2450)  by [@sabine](https://github.com/sabine)
    - PR: Dedupe RSS feed creation logic [ocaml/ocaml.org#2461](https://github.com/ocaml/ocaml.org/pull/2461) by [@cuihtlauac](https://github.com/cuihtlauac)
- Events page
    - PR: Feat/events rss feed [ocaml/ocaml.org#2437](https://github.com/ocaml/ocaml.org/pull/2437) by [@ishar19](https://github.com/ishar19)

## Outreachy Internship on Interactive Exercises

On May 27, [Divyanka Chaudhari](https://github.com/divyankachaudhari) started working with the team, as an Outreachy intern. She's implementing support for running the exercises as a stand-alone project, either in GitHub Codespace, in `repl.it`, using Jupyter or LearnOcaml.

**Relevant PRs and Activities:**
- PR: Fix 007 answer folder not running test cases [ocaml/ocaml.org#2458](https://github.com/ocaml/ocaml.org/pull/2458) by [@divyankachaudhari](https://github.com/divyankachaudhari)

## General Improvements and Data Additions

**Notable Changes:**
* We restructured the main navigation to have a "Tools" section that holds the OCaml Platform page and the OCaml compiler releases page. This should make the OCaml Platform page easier to find.
* The Changelog can now be found under "News", from the main navigation. You can also find the OCaml Planet and the Newsletters in this new section.
* The OCaml Language Manual is now served from OCaml.org, instead of v2.ocaml.org.
* We added some more links to learning resources to the Resources page at https://ocaml.org/resources.
* Some documentation updates on "Is OCaml Web Yet?", "Is OCaml GUI Yet?", the ThreadSanitizer tutorial, and the "Functors" tutorial. 

**Relevant PRs and Activities:**
- Features
    - PR: Introduce a tools section for platform page, releases page, and a news section for changelog, OCaml Planet and Newsletters [ocaml/ocaml.org#2410](https://github.com/ocaml/ocaml.org/pull/2410) by [@sabine](https://github.com/sabine)
- Migration of the Language Manual from v2.ocaml.org to OCaml.org
    - PR: fix: language manual redirect, remove unnecessary append of index.html [ocaml/ocaml.org#2470](https://github.com/ocaml/ocaml.org/pull/2470)  by [@sabine](https://github.com/sabine)
    - PR: Fix: redirect to downloadable manual files [ocaml/ocaml.org#2439](https://github.com/ocaml/ocaml.org/pull/2439)  by [@sabine](https://github.com/sabine)
    - PR: Simplify and extend /releases/ redirects from legacy v2.ocaml.org URLs [ocaml/ocaml.org#2448](https://github.com/ocaml/ocaml.org/pull/2448) by [@cuihtlauac](https://github.com/cuihtlauac)
    - PR: Fix #2465 [ocaml/ocaml.org#2468](https://github.com/ocaml/ocaml.org/pull/2468)  by [@cuihtlauac](https://github.com/cuihtlauac)
    - PR: Fix more redirect [ocaml/ocaml.org#2471](https://github.com/ocaml/ocaml.org/pull/2471) by [@cuihtlauac](https://github.com/cuihtlauac)
- Data
    - PR: (data) add some learning resources [ocaml/ocaml.org#2474](https://github.com/ocaml/ocaml.org/pull/2474)  by [@sabine](https://github.com/sabine)
    - PR: Add University of Bologna as academic institution [ocaml/ocaml.org#2394](https://github.com/ocaml/ocaml.org/pull/2394) by [@boozec](https://github.com/boozec)
    - PR: (data) Update ocaml.org community meeting zoom link [ocaml/ocaml.org#2413](https://github.com/ocaml/ocaml.org/pull/2413)  by [@sabine](https://github.com/sabine)
    - PR: (data) jobs: add a XenServer position again [ocaml/ocaml.org#2414](https://github.com/ocaml/ocaml.org/pull/2414) by [@edwintorok](https://github.com/edwintorok)
    - PR: (data) add ocaml.org newsletter April 2024 [ocaml/ocaml.org#2417](https://github.com/ocaml/ocaml.org/pull/2417)  by [@sabine](https://github.com/sabine)
    - PR: OCaml 5.2.0 announce and release page [ocaml/ocaml.org#2421](https://github.com/ocaml/ocaml.org/pull/2421) by [@Octachron](https://github.com/Octachron)
    - PR: Update OCamlPro's logo [ocaml/ocaml.org#2436](https://github.com/ocaml/ocaml.org/pull/2436) by [@hra687261](https://github.com/hra687261)
    - PR: Changelog entry for OCaml 5.2.0~rc1 [ocaml/ocaml.org#2391](https://github.com/ocaml/ocaml.org/pull/2391) by [@Octachron](https://github.com/Octachron)
    - PR: changelog: add Dune 3.15.1 and 3.15.2 [ocaml/ocaml.org#2389](https://github.com/ocaml/ocaml.org/pull/2389) by [@emillon](https://github.com/emillon)
    - PR: Add changelog entry for Merlin 5.0 [ocaml/ocaml.org#2472](https://github.com/ocaml/ocaml.org/pull/2472) by [@pitag-ha](https://github.com/pitag-ha)
- Bugfixes
    - PR: fix dark style of package version pages [ocaml/ocaml.org#2438](https://github.com/ocaml/ocaml.org/pull/2438) by [@FrugBatt](https://github.com/FrugBatt)
    - GitHub actions CI broke due to an OpenSSL issue on MacOS
         - PR: Update debug-ci.yml [ocaml/ocaml.org#2397](https://github.com/ocaml/ocaml.org/pull/2397)  by [@cuihtlauac](https://github.com/cuihtlauac)
         - PR: Update debug-ci.yml [ocaml/ocaml.org#2398](https://github.com/ocaml/ocaml.org/pull/2398)  by [@cuihtlauac](https://github.com/cuihtlauac)
         - PR: Do brew update before installing openssl@3 to fix macos CI [ocaml/ocaml.org#2420](https://github.com/ocaml/ocaml.org/pull/2420)  by [@sabine](https://github.com/sabine)
         - PR: (ci) Restrict openssl on macos to 3.2 to see if that fixes CI [ocaml/ocaml.org#2390](https://github.com/ocaml/ocaml.org/pull/2390)  by [@sabine](https://github.com/sabine)
- Documentation
    - PR: Explain how to avoid cyclic abbreviation error with functor application [ocaml/ocaml.org#2457](https://github.com/ocaml/ocaml.org/pull/2457) by [@cuihtlauac](https://github.com/cuihtlauac)
    - PR: Update tutorial “Transitioning to Multicore with ThreadSanitizer” [ocaml/ocaml.org#2459](https://github.com/ocaml/ocaml.org/pull/2459) by [@OlivierNicole](https://github.com/OlivierNicole)
    - PR: (docs) web.md: jsonchema->atd exists [ocaml/ocaml.org#2454](https://github.com/ocaml/ocaml.org/pull/2454) by [@Khady](https://github.com/Khady)
    - PR: Update is_ocaml_yet/gui.md: Plotting [ocaml/ocaml.org#2452](https://github.com/ocaml/ocaml.org/pull/2452) by [@lukstafi](https://github.com/lukstafi)

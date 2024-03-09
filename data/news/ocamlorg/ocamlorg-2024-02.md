---
title: "OCaml.org Newsletter: February 2024"
description: Monthly update from the OCaml.org team.
date: "2024-03-09"
tags: [ocamlorg]
---

Welcome to the February 2024 edition of the OCaml.org newsletter! This update has been compiled by the OCaml.org team. You can find [previous updates](https://discuss.ocaml.org/tag/ocamlorg-newsletter) on Discuss.

Our goal is to make OCaml.org the best resource for anyone who wants to get started and be productive in OCaml. The OCaml.org newsletter provides an update on our progress towards that goal and an overview of the changes we are working on.

We couldn't do it without all the amazing OCaml community members who help us review, revise, and create better OCaml documentation. Your feedback enables us to better prioritise our work. Thank you!

This newsletter covers:
- **OCaml Documentation:** New documentation has been released, and existing documentation has been improved.
- **OCaml Cookbook:** A prototype of an OCaml cookbook that provides short code examples that solve practical problems using packages from the OCaml ecosystem is on staging.ocaml.org/cookbook.
- **Dark Mode:** We're almost ready to release dark mode now.
- **Community Section Rework:** We are preparing wireframes for the community section to better present the existing content. In addition, we started preliminary work towards a dedicated "Events" page.
- **General Improvements:** As usual, we also worked on general maintenance and improvements based on user feedback, so we're highlighting some of our work below.

## Open Issues for Contributors & Outreachy Application Period

There are open issues for external contributors. However, since github.com/ocaml/ocaml.org participates in the Outreachy application period, we might have a shortage of open issues in March, since Outreachy applicants will quickly take them on.

You can find [open issues for contributors here](https://github.com/ocaml/ocaml.org/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22+no%3Aassignee)!

## OCaml Documentation

**User Testing**

Twenty-one brave newbies accepted being observed for one hour while discovering OCaml through the online docs and completing a couple of programming tasks. Many thanks to all the participants of the user testing sessions we held!

Half of the user testing participants used the recently [updated tutorials](https://ocaml.org/docs), the other half used  [v2.ocaml.org/docs](https://v2.ocaml.org/docs). Our takeaway from this is:
- Learning OCaml isn't hard. However, learning functional programming is. Most participants who had previous FP experience successfully completed the tasks.
- The updated docs do a little better than the manual at teaching both OCaml and FP to participants without FP experience. A few of them succeeded at the more complex tasks using the new tutorials, while all participants without FP experience failed using the old documentation.

By observing the participants try to make sense of the tasks and find relevant materials in the documentation, we have identified many smaller changes that are likely to improve the user experience on the documentation pages.

**Relevant PRs and Activities:**

- **In Progress:**
- **In Review (internal):**
  - [Higher-Order Functions](https://github.com/ocaml/ocaml.org/pull/2044)
- **In Review (community):**
  - [File Manipulation](https://github.com/ocaml/ocaml.org/pull/1400) (see [Discuss Thread](https://discuss.ocaml.org/t/help-review-the-new-file-manipulation-tutorial-on-ocaml-org/12638))
  - [Polymorphic Variants](https://github.com/ocaml/ocaml.org/pull/1531) (see [Discuss Thread](https://discuss.ocaml.org/t/new-draft-tutorial-on-polymorphic-variants/13485))
- **Published:**
  - [Maps](https://github.com/ocaml/ocaml.org/pull/2045)
  - [Sets](https://github.com/ocaml/ocaml.org/pull/948)
  - [Options](https://github.com/ocaml/ocaml.org/pull/1800)
  - [Modules, Functors, Libraries With Dune](https://github.com/ocaml/ocaml.org/pull/1778) (see [Discuss](https://discuss.ocaml.org/t/draft-tutorials-on-modules-functors-and-libraries/))
  - [Labelled Arguments](https://github.com/ocaml/ocaml.org/pull/1881)
  - [The OCaml Playground](https://github.com/ocaml/ocaml.org/pull/1880) by [@The-Amoghavarsha](https://github.com/The-Amoghavarsha)
  - [Running Commands in an opam Switch](https://github.com/ocaml/ocaml.org/pull/1825)
  - [Mutable State / Imperative Programming](https://github.com/ocaml/ocaml.org/pull/1529) (see [Discuss Thread](https://discuss.ocaml.org/t/draft-tutorial-on-mutability-loops-and-imperative-programming/13504))
  - Announcement on Discuss: [New Tutorials on Basics of OCaml](https://discuss.ocaml.org/t/new-tutorials-on-basics-of-ocaml/13396)
  - [Basic Data Types](https://github.com/ocaml/ocaml.org/pull/1514) (see [Discuss Thread](https://discuss.ocaml.org/t/ocaml-org-tutorial-revamping-contd-basic-datatypes/12985))
  - [Functions and Values](https://github.com/ocaml/ocaml.org/pull/1512) (see [Discuss Thread](https://discuss.ocaml.org/t/ocaml-org-tutorial-revamping-cond-values-and-functions/13005))
  - [Installing OCaml](https://ocaml.org/docs/installing-ocaml) (see [Discuss Thread](https://discuss.ocaml.org/t/help-revamping-the-getting-started-tutorials-in-ocaml-org/12749))
  - [A Tour Of OCaml](https://ocaml.org/docs/tour-of-ocaml) (see [Discuss Thread](https://discuss.ocaml.org/t/help-revamping-the-getting-started-tutorials-in-ocaml-org/12749))
  - [Your First OCaml Program](https://ocaml.org/docs/your-first-program) (see [Discuss Thread](https://discuss.ocaml.org/t/help-revamping-the-getting-started-tutorials-in-ocaml-org/12749))
  - [Introduction to opam Switches](https://ocaml.org/docs/opam-switch-introduction)
  - [Fix Homebrew Errors on Apple M1](https://ocaml.org/docs/arm64-fix)
  - [Operators](https://ocaml.org/docs/operators)
  - [Error Handling](https://ocaml.org/docs/error-handling) (see [Discuss Thread](https://discuss.ocaml.org/t/ann-new-get-started-documentation-on-ocaml-org/13269))
  - [Arrays](https://ocaml.org/docs/arrays) (see [Discuss Thread](https://discuss.ocaml.org/t/feedback-needed-new-arrays-tutorial-on-ocaml-org/12683))
  - [Sequences](https://ocaml.org/docs/sequences) (see [Discuss Thread](https://discuss.ocaml.org/t/creating-a-tutorial-on-sequences/12091))
- **Other Activity**:
  - [(docs) Basic Data Types: Add link to module Str](https://github.com/ocaml/ocaml.org/pull/2060)
  - [First class module (Learning/Language/Module System)](https://github.com/ocaml/ocaml.org/pull/2090) by [@F-Loyer](https://github.com/F-Loyer)
  - [Update bp_03_run_executables_and_tests.md](https://github.com/ocaml/ocaml.org/pull/2092) by [@F-Loyer](https://github.com/F-Loyer)
  - [DOC: replace dream with yojson in first program](https://github.com/ocaml/ocaml.org/pull/2093) by [@heathhenley](https://github.com/heathhenley)
  - [Update typo + change from append to prepend](https://github.com/ocaml/ocaml.org/pull/2095) by [@danipoma](https://github.com/danipoma)
  - [Add workspace file for use with dune-pkg](https://github.com/ocaml/ocaml.org/pull/2105) by [@gridbugs](https://github.com/gridbugs)
  - [Fix typos in guidelines](https://github.com/ocaml/ocaml.org/pull/2115) by [@cionx](https://github.com/cionx)
  - [Removing dune from setup instructions](https://github.com/ocaml/ocaml.org/pull/2020) by [@The-Amoghavarsha](https://github.com/The-Amoghavarsha)
  - [Improve some wording in the functors tutorial](https://github.com/ocaml/ocaml.org/pull/2023) by [@neuroevolutus](https://github.com/neuroevolutus)
  - [Add link from operators to monads](https://github.com/ocaml/ocaml.org/pull/2054) by [@cuihtlauac](https://github.com/cuihtlauac)
  - [(doc) Improve wording in "Libraries with Dune" tutorial](https://github.com/ocaml/ocaml.org/pull/2047) by [@The-Amoghavarsha](https://github.com/The-Amoghavarsha)
  - [Replace Variable by Parameter](https://github.com/ocaml/ocaml.org/pull/2059) by [@cuihtlauac](https://github.com/cuihtlauac)
  - [(docs) Adding an example of a closure that contains mutable state in Mutable State & Imperative Tutorial](https://github.com/ocaml/ocaml.org/pull/2046) by [@The-Amoghavarsha](https://github.com/The-Amoghavarsha)
  - [(docs) Recommend dune watch mode](https://github.com/ocaml/ocaml.org/pull/2064) by [@yawaramin](https://github.com/yawaramin)
  - [(docs) Set “Sets“ as Set's tutorial title](https://github.com/ocaml/ocaml.org/pull/2073) by [@cuihtlauac](https://github.com/cuihtlauac)
  - [(docs) Correct map to map_error in Error Handling Guide](https://github.com/ocaml/ocaml.org/pull/2087) by [@cuihtlauac](https://github.com/cuihtlauac)
  - [Omit mention of Merlin](https://github.com/ocaml/ocaml.org/pull/2117) by [@yawaramin](https://github.com/yawaramin)


## Upcoming OCaml Cookbook

We made some progress towards adding a new, community-driven section to the Learn area: the OCaml Cookbook. The cookbook aims to be a compilation of recipes that provide code samples that solve practical-minded tasks using packages from the OCaml ecosystem.

Here is the design we are considering:
- Category: High-level groups of tasks, e.g., networking, data compression, or command line arguments.
- Task: Single thing to be done in a category, e.g., write to a file, make an HTTP GET request, or return an exit status.
- Recipe: Version of task using a package, e.g., HTTP GET using `curly` or `cohttp`.

A rough prototype is on staging.ocaml.org/cookbook. The contributions and the user feedback we received suggest that the structure of the cookbook needs to be refined one more time until it is ready to be released.

A good place to give feedback on the cookbook is [this discuss thread](https://discuss.ocaml.org/t/feedback-help-wanted-upcoming-ocaml-org-cookbook-feature/14127/10).

**Relevant PRs and Activities:**
- [Prototype OCaml Cookbook](https://github.com/ocaml/ocaml.org/pull/1839)
- Contributions to the Cookbook:
  - (WIP) [Cookbook : filesystem](https://github.com/ocaml/ocaml.org/pull/2099) by [@F-Loyer](https://github.com/F-Loyer)
  - (WIP) [Cookbook networking](https://github.com/ocaml/ocaml.org/pull/2112) by [@F-Loyer](https://github.com/F-Loyer)
  - (WIP) [Cookbook xml](https://github.com/ocaml/ocaml.org/pull/2121) by [@F-Loyer](https://github.com/F-Loyer)
  - (WIP) [Cookbook : Web / simple HTTP client](https://github.com/ocaml/ocaml.org/pull/2123) by [@F-Loyer](https://github.com/F-Loyer)
  - (WIP) [Cookbook Web / uri](https://github.com/ocaml/ocaml.org/pull/2124) by [@F-Loyer](https://github.com/F-Loyer)
  - (WIP) [Cookbook: Regexp (ppx_regexp)](https://github.com/ocaml/ocaml.org/pull/2125) by [@F-Loyer](https://github.com/F-Loyer)
  - [Cookbook : encoding](https://github.com/ocaml/ocaml.org/pull/2097) by [@F-Loyer](https://github.com/F-Loyer)
  - [Cookbook : and Sorting list and arrays](https://github.com/ocaml/ocaml.org/pull/2098) by [@F-Loyer](https://github.com/F-Loyer)
  - [Cookbook textprocessing](https://github.com/ocaml/ocaml.org/pull/2104) by [@F-Loyer](https://github.com/F-Loyer)
  - [Cookboot : Add a Database / ezsqlite entry](https://github.com/ocaml/ocaml.org/pull/2100) by [@F-Loyer](https://github.com/F-Loyer)
  - [Cookbook concurrency : Lwt](https://github.com/ocaml/ocaml.org/pull/2107) by [@F-Loyer](https://github.com/F-Loyer)
  - [Cookbook caqti ppx rapper](https://github.com/ocaml/ocaml.org/pull/2108) by [@F-Loyer](https://github.com/F-Loyer)
  - [Cookbook Ezsqlite - typo and rewriting](https://github.com/ocaml/ocaml.org/pull/2119) by [@F-Loyer](https://github.com/F-Loyer)
  - [Cookbook Sorting - typo](https://github.com/ocaml/ocaml.org/pull/2118) by [@F-Loyer](https://github.com/F-Loyer)

## Dark Mode

In December, [oyenuga17](https://github.com/oyenuga17) started to implement the new dark mode on OCaml.org.

By now, the new dark mode is mostly complete, but it hasn't been reviewed or tested sufficiently.

We have enabled the dark mode on staging.ocaml.org, based on your browser / operating system preferences. If you want to help, you can view the dark mode on staging.ocaml.org and report anything you see by opening an issue.

**Completed Pages:**
- [Learn/Get Started + Language + Guides](https://github.com/ocaml/ocaml.org/pull/1897) by [@oyenuga17](https://github.com/oyenuga17)
- [Learn/Excercises](https://github.com/ocaml/ocaml.org/pull/1902) by [@oyenuga17](https://github.com/oyenuga17)
- [Learn/Books](https://github.com/ocaml/ocaml.org/pull/1903) by [@oyenuga17](https://github.com/oyenuga17)
- [Learn/Platform Tools](https://github.com/ocaml/ocaml.org/pull/1919) by [@oyenuga17](https://github.com/oyenuga17)
- [Packages Search Results](https://github.com/ocaml/ocaml.org/pull/1946) by [@oyenuga17](https://github.com/oyenuga17)
- [Packages + Community](https://github.com/ocaml/ocaml.org/pull/1973) by [@oyenuga17](https://github.com/oyenuga17)
- [Blog + Jobs + Changelog](https://github.com/ocaml/ocaml.org/pull/2001) by [@oyenuga17](https://github.com/oyenuga17)
- [Learn/Overview](https://github.com/ocaml/ocaml.org/pull/1836) by [@oyenuga17](https://github.com/oyenuga17)
- [Install + Papers + Logos and Policy Pages](https://github.com/ocaml/ocaml.org/pull/2032) by [@oyenuga17](https://github.com/oyenuga17)
- [Governance + Outreachy Internships Page](https://github.com/ocaml/ocaml.org/pull/2053) by [@oyenuga17](https://github.com/oyenuga17)
- [Komepage + Tutorial Search Results Page](https://github.com/ocaml/ocaml.org/pull/2069) by [@oyenuga17](https://github.com/oyenuga17)
- [OCaml Workshop + Success Stories](https://github.com/ocaml/ocaml.org/pull/2109) by [@oyenuga17](https://github.com/oyenuga17)


## Community Section Rework

This month, we have started to do user research on the community area and gathered feedback and ideas on the current pages. Among others, we have identified these:
- the Community section needs a better Events directory
- the Jobs page needs to be more easily reachable from the community page
- it would be great to highlight Open Source projects from the OCaml ecosystem that are looking for contributors

If you have opinions on the community section, feel free to share them in [this discuss thread](https://discuss.ocaml.org/t/looking-for-ideas-for-the-community-page-at-ocaml-org/14032/9)!

**Relevant PRs and Activities:**
  - [Create Community Subnav to put Jobs under Community](https://github.com/ocaml/ocaml.org/pull/2018) by [@sabine](https://github.com/sabine)
  - [Add Title for Breadcrumb Subnav (e.g. "Learn" / "Community")](https://github.com/ocaml/ocaml.org/pull/2022) by [@sabine](https://github.com/sabine)

## General Improvements

Many thanks go out to the many contributors who helped improve OCaml.org in February. Find them listed below!

**Relevant PRs and Activities:**
- General:
  - [Make tutorial field short_title optional](https://github.com/ocaml/ocaml.org/pull/2024) by [@amarachigoodness74](https://github.com/amarachigoodness74)
  - [(build) Dont Crunch the data/ Folder](https://github.com/ocaml/ocaml.org/pull/2016) by [@sabine](https://github.com/sabine)
  - [Refine Learn Landing Page Styles to meet Figma Design](https://github.com/ocaml/ocaml.org/pull/2028) by [@sabine](https://github.com/sabine)
  - [Remove obsolete text on difficulty symbols on exercises page](https://github.com/ocaml/ocaml.org/pull/2040) by [@cuihtlauac](https://github.com/cuihtlauac)
  - [make the github links on ocaml.org point to the ocaml org](https://github.com/ocaml/ocaml.org/pull/2048) by [@v-gb](https://github.com/v-gb)
  - [feat: create ocaml playground mobile view ](https://github.com/ocaml/ocaml.org/pull/2076) by [@FatumaA](https://github.com/FatumaA)
  - [Add OCaml Language Manual button on Learn Overview hero section](https://github.com/ocaml/ocaml.org/pull/2120) by [@sabine](https://github.com/sabine)
  - [Bugfix: Remove the duplicated "Docs" link and make it looks like the figma](https://github.com/ocaml/ocaml.org/pull/2116) by [@kiyov09](https://github.com/kiyov09)
  - [Advertise atom feed in head using link](https://github.com/ocaml/ocaml.org/pull/2075) by [@cuihtlauac](https://github.com/cuihtlauac)
  - [adjust list bullet color](https://github.com/ocaml/ocaml.org/pull/2067) by [@egmaleta](https://github.com/egmaleta)
  - [Make the playground cursor more obvious](https://github.com/ocaml/ocaml.org/pull/2071) by [@sabine](https://github.com/sabine)
  - [Add Two Packages to "Is OCaml Web Yet?"](https://github.com/ocaml/ocaml.org/pull/2078) by [@F-Loyer](https://github.com/F-Loyer)
- Data parsing:
  - [(ood-gen) Make optional list types in 'tutorials' type non-optional](https://github.com/ocaml/ocaml.org/pull/2039) by [@egmaleta](https://github.com/egmaleta)
  - [(ood-gen) Adjust type of fields with `list option` type to `list` in Changelog, News, Planet, and Workshop](https://github.com/ocaml/ocaml.org/pull/2042) by [@egmaleta](https://github.com/egmaleta)
  - [(ood-gen) Unify Data.Event / Data.Meetup into Data.Event / Data.Event/RecurringEvent](https://github.com/ocaml/ocaml.org/pull/2102) by [@sabine](https://github.com/sabine)
  - [(ood-gen) Adjust type of fields with `option` type in Workshop](https://github.com/ocaml/ocaml.org/pull/2068) by [@egmaleta](https://github.com/egmaleta)
  - [Do not generate empty data/watch.yml](https://github.com/ocaml/ocaml.org/pull/2063) by [@cuihtlauac](https://github.com/cuihtlauac)
  - [Don't let get_ok swallow error causes](https://github.com/ocaml/ocaml.org/pull/2061) by [@cuihtlauac](https://github.com/cuihtlauac)
  - [(ood-gen) Adjust type of fields with bool option type to bool in Release](https://github.com/ocaml/ocaml.org/pull/2055) by [@egmaleta](https://github.com/egmaleta)
- Data:
  - [Changelog entry for OCaml 5.2.0~alpha1](https://github.com/ocaml/ocaml.org/pull/2025) by [@Octachron](https://github.com/Octachron)
  - [Add changelog entry for ppxlib.0.32.0 release](https://github.com/ocaml/ocaml.org/pull/2036) by [@NathanReb](https://github.com/NathanReb)
  - [changelog: add dune.3.13.1](https://github.com/ocaml/ocaml.org/pull/2050) by [@emillon](https://github.com/emillon)
  - [Add missing changelogs for January](https://github.com/ocaml/ocaml.org/pull/2096) by [@tmattio](https://github.com/tmattio)
  - [(data) add MirageOS hack retreat](https://github.com/ocaml/ocaml.org/pull/2113) by [@sabine](https://github.com/sabine)
  - [Add changelog for dune.3.14.0](https://github.com/ocaml/ocaml.org/pull/2058) by [@emillon](https://github.com/emillon)

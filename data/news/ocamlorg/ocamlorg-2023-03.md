---
title: "OCaml.org Newsletter: March 2023"
description: Monthly update from the OCaml.org team.
date: "2023-05-04"
tags: [ocamlorg]
---

Welcome to the inaugural edition of the OCaml.org newsletter!

Following the example of the now-retired Multicore monthlies, and the  Compiler newsletter, we'll be running a monthly newsletter on the progress we're making on the development of OCaml.org.

This newsletter has been compiled by @sabine and @tmattio and offers a recap' of the work we've been doing on OCaml.org in March.

We highlight the work we've been doing in three distinct areas:

- **Package Documentation**: Following user feedback, in the past months, we've been focusing on improving the package documentation area. It started earlier this year with the team running a survey and user interviews, and we're nearing the end of the improvements.
- **Learn Area**: As a next milestone after improving the package documentation, we started work on the learn area with the aim to improve the learning experience of new OCaml users and offer new documentation resources to both beginners and experienced developers.
- **General Maintenance**: We also worked on general maintenance and improvements, and we'll highlight some of them.

Many thanks to all of the community members who contributed by participating in surveys, giving feedback on Discuss, and opening issues and Pull Requests! Your contributions and feedback enable us to make progress on making OCaml.org the best resource to learn OCaml and discover OCaml packages!

## Package Documentation

When we started to work on the package documentation navigation, we reached out to the community on the OCaml Discuss forums with a survey on the Package and Learn areas on OCaml.org. The goal behind this was to enable our new team member, a UX/UI designer, to quickly get up to speed and make impactful contributions to OCaml.org. Thanks to the active participation of the community, this turned out to be a highly effective method to identify the most impactful issues to work on.

This month, we completed [personas](https://github.com/ocaml/ocaml.org/tree/main/doc/personas.md) representing different types of users which includes mid-level developer, student, team lead, senior developer, academic instructor/researcher. 

We designed the UI and user flows for two possible design options of the package section (which includes the package overview page, package documentation, the package search results, as well as an upcoming page that lists all versions of a package). You can access the designs on [Figma](https://www.figma.com/file/Aqk5y03fsaCuhTSywmmY06/OCaml.org-Public-Designs).

We've been making good progress on a (low-fidelity) implementation of the designs we have in Figma, and we still have a few UI elements to rework to align the site to the designs.

Relevant PRs/Issues:

1. We now [display README/CHANGELOG/LICENSE on the package overview layout](https://github.com/ocaml/ocaml.org/pull/994), instead of within the documentation layout. This better reflects their status as "files that accompany the package".
2. The [source code download button and source hash display was reworked](https://github.com/ocaml/ocaml.org/pull/986) to have a better UX.
3. [The package overview page was rearranged](https://github.com/ocaml/ocaml.org/pull/987). This improves the styling and placement of dependencies, tags, description, publication date.
4. The [authors/maintainers display was improved](https://github.com/ocaml/ocaml.org/pull/1001) to (1) render an automatically-generated avatar if we don't have one for the given user, and (2) hide excessive amounts of authors/maintainers behind a "show more" button.
5. To make it easier to scan for relevant dependencies, we [separate the dependencies into "development dependencies" and regular dependencies](https://github.com/ocaml/ocaml.org/pull/1006)
6. After [moving the package overview sidebar to the left](https://github.com/ocaml/ocaml.org/pull/1003), the package overview page and the package documentation page were [unified to use the same layout](https://github.com/ocaml/ocaml.org/pull/1015)
7. We now [render a table of contents on the package overview pages](https://github.com/ocaml/ocaml.org/pull/1017)

## Learn Area

We started the discovery phase in which we are taking inventory of the current content and structure of the OCaml.org Learn area. We reviewed the user interview videos from the Q1 survey on the Learn and Package areas to extract user needs and pain points. We also started preparing a survey that specifically targets new OCaml users (both programming beginners and experienced developers). At the time we publish this newsletter, we've already completed the survey and we'll be sharing the results in the next issue of this newsletter.

Improving the Learn Area will be our biggest focus in the coming months, so expect more updates on this in the following newsletters.

## General Maintenance

### User-facing changes

1. [Display of README/LICENSE/CHANGELOG now uses the package overview page layout](https://github.com/ocaml/ocaml.org/pull/994), instead of the documentation layout.
2. @YassineHaouzane [added the display of exercise difficulty](https://github.com/ocaml/ocaml.org/pull/955) to the problems in the exercises section. Thank you very much!
3. The [package search dropdown in the top navigation bar now allows you to navigate the search results using your keyboard](https://github.com/ocaml/ocaml.org/pull/978).
4. When [using the version switcher dropdown on the package documentation pages, the current path within the docs is now preserved](https://github.com/ocaml/ocaml.org/pull/983).
5. (WIP) We made progress on [adding a page to the community section that highlights the Outreachy internship projects](https://github.com/ocaml/ocaml.org/pull/1009).
6. (WIP) We made progress on [exposing check.ocamllabs.io build information on the package overview page](https://github.com/ocaml/ocaml.org/pull/977).
7. (WIP) We started work on [adding a dedicated “Install” page](https://github.com/ocaml/ocaml.org/pull/1038), together with the community: Discuss thread [Please Improve my Draft of an “Install” Page on OCaml.org](https://discuss.ocaml.org/t/please-improve-my-draft-of-an-install-page-on-ocaml-org/11837).

### Updates to OCaml.org’s data:

1. Following the announcement of the jobs section on the OCaml Discuss forums, the team reviewed and merged job listings submitted by external contributors. Thank you everyone!
2. The [videos for the Outreachy projects have been added](https://github.com/ocaml/ocaml.org/pull/970) but are not yet exposed via a dedicated page.

### Internal maintenance, code health, and bug fixes

1. The code of “ood” (OCaml.org’s data library and data parser) received some refactoring in order to make it easier for people to contribute to OCaml.org.
2. All internal links to (subdomains of) ocaml.org were changed to use https in order to avoid unnecessary redirects.
3. [README/LICENSE/CHANGELOG files were not properly picked up](https://github.com/ocaml/ocaml.org/pull/985) by OCaml.org after the odoc upgrade. Now they are.
4. @voodoos [fixed the non-operational Merlin in the OCaml Playground](https://github.com/ocaml/ocaml.org/pull/996).
5. When a new build was deployed, package information used to be unavailable for around a minute. Now, the [Issue: When package info is regenerating, package info is unavailable](https://github.com/ocaml/ocaml.org/issues/980) has been fixed.
6. Bug fix: [don't crash on packages that have avoid-version on all versions](https://github.com/ocaml/ocaml.org/pull/989).
7. The [package breadcrumbs template now uses the breadcrumbs data coming from odoc](https://github.com/ocaml/ocaml.org/pull/1000).
8. Introduced a short-circuiting 404 let-binding operator to the handler functions: [PR: Return 404 on not found](https://github.com/ocaml/ocaml.org/pull/1010).
9. We kept having spurious CI build failures because the CI would use the most current version of opam-repository. Now, we pin opam-repository in all three places: 1) Makefile, 2) Dockerfile, 3) GitHub actions.
10. Version upgrades: ocaml to 4.14.1, actions/checkout@v3 in GitHub Actions, dune to 3.6.
11. After visually highlighting targeted headings was added in [#628](https://github.com/ocaml/ocaml.org/pull/628), there were two sets of hover styles being applied to the anchor targets in the headings of the package documentation. This has been resolved: [PR: Remove duplicate doc.css anchor target styles, adjust hover styles](https://github.com/ocaml/ocaml.org/pull/1014).
12. There was a problem with the right sidebar not showing up when you navigated to the tutorial coming from the "Learn" page. Thanks to [#1021](https://github.com/ocaml/ocaml.org/pull/1021) and [#1041](https://github.com/ocaml/ocaml.org/pull/1041), the sidebar now works properly with the AJAX-navigation provided by HTMX.
13. A user reported problems with font-sizing / layout. We [changed Tailwind’s px-based breakpoints to em-based breakpoints](https://github.com/ocaml/ocaml.org/pull/1032) - in order to respect people's browser and OS font size settings.
14. (WIP) Work on [adding a sitemap.xml](https://github.com/ocaml/ocaml.org/pull/830) to help search engines to index all of OCaml.org’s pages is in progress.

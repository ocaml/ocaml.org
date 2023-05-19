---
title: "OCaml.org Newsletter: April 2023"
description: Monthly update from the OCaml.org team.
date: "2023-05-17"
tags: [ocamlorg]
---

Welcome to the April 2023 edition of the OCaml.org newsletter! As with the [previous update](https://ocaml.org/news/ocamlorg-2023-03), this has been compiled by @sabine and @tmattio.

The OCaml.org newsletter provides an overview of changes on the OCaml.org website and gives you a glimpse into what has been going on behind the scenes. You can find a [list of previous issues here](https://discuss.ocaml.org/tag/ocamlorg-newsletter).

Our goal is to make OCaml.org the best resource for anyone who wants to get started and be productive in OCaml. We couldn't do it without all the amazing OCaml community members who help us review, revise and create better OCaml documentation. Your feedback enables us to better prioritise our work and make progress towards our goal. Thank you!

We present the work we've been doing this month in three sections:
* **Learn area:** To make sure that we focus on the changes that truly have an impact on the success of OCaml and its community, we conducted a user survey targeted at OCaml newcomers. The survey allowed us to better understand their outlook on the existing site and their needs and wishes for the upcoming changes.
* **Package documentation:** Following the recent changes to the package area, we've continued to make improvements to the usability of the package overview and documentation pages.
* **General Improvements:** We also worked on general maintenance and improvements, and we'll highlight some of them.

## Learn Area

### 1. User Survey

This month, we published [the survey](https://discuss.ocaml.org/t/you-started-to-learn-ocaml-less-than-12-months-ago-please-help-us-with-our-user-survey-on-the-ocaml-org-learning-area/11945) that we started preparing in March. The survey was promoted on various platforms, including the official OCaml Discuss platform, Discord, LinkedIn, Twitter, and received a lot of engagement: in total, we got 57 responses before we had to close the survey in order to analyze the results adequately.

Apart from this, we reviewed recordings of the previous round of user interviews we did on the Learn and Package areas, to group and prioritise the user feedback for use in upcoming user interviews. We also provided a [public summary of the survey results on the OCaml Discuss](https://discuss.ocaml.org/t/you-started-to-learn-ocaml-less-than-12-months-ago-please-help-us-with-our-user-survey-on-the-ocaml-org-learning-area/11945/2).

Overall, we're now in a very good position to understand which changes should be made to the Learn area in order to improve the learning experience on OCaml.org. Our work will continue in May with the first wireframes for the new Learn area.

### 2. Work-in-progress Improvements on Documentation Pages

In addition to the high-level overhaul of the Learn area we're working on, outlined above, we also made several smaller improvements on the documentation to continuously improve the content of the documentation.

Many of the [outstanding pull requests on ocaml/ocaml.org](https://github.com/ocaml/ocaml.org/issues?q=is%3Apr+is%3Aopen+label%3Adocumentation) contain updates to the existing documentation pages of the Learn area. We aim to merge the majority of these in May.

We are incredibly thankful for your feedback, suggestions, and help along the way. We are striving to make learning OCaml frictionless by providing high-quality content on OCaml.org. It's quite a big task, and everyone's help is essential to allow us to make this happen.

## Package Documentation

Following the recent changes in the package area, we continued to make improvements to the layout. Notably, we added a small footer to the Learn and Package sections, which solves the issue of sticky-positioned sidebars moving out of the screen when scrolling into the footer. To better highlight the currently active section when scrolling through the document, we reworked the table of contents UI in both the Package and Learn sections.

We now collapse the reverse dependencies section on the package overview page when it has more than 100 entries. To make room for upcoming package status badges, we moved the breadcrumbs in the package area above the main content area in line with the [Figma designs](https://www.figma.com/file/Aqk5y03fsaCuhTSywmmY06/OCaml.org-Public-Designs?type=design&node-id=0%3A1&t=XYxilCb5hHk4mrDk-1). We also updated the styles of the package search results page to be more compact, collapsing author lists with more than five items, styling package tags the same as on the package overview page, and we added a link to go directly to the package documentation.

Relevant PRs/Issues:

  1. The Learn section and the Package section now have a [small footer attached to the bottom of the screen (ocaml/ocaml.org#1018)](https://github.com/ocaml/ocaml.org/pull/1018). This resolves the UX issue where the sticky-positioned sidebars would move upwards out of the screen when scrolling into the footer. An alternative solution where the sidebars shrink as the footer comes into view has been explored but ultimately discarded due to higher complexity and maintenance needs.

  2. The table of contents UI in the Package section as well as in the Learn section is reworked to [highlight the currently active section when scrolling through the document (ocaml/ocaml.org#1094)](https://github.com/ocaml/ocaml.org/pull/1094). This makes it easier to see progress in reading the content and easier to relate to where we are in a larger document.

  3. The [layout of the package documentation section is now wide (ocaml/ocaml.org#1097)](https://github.com/ocaml/ocaml.org/pull/1097), with an increased gap on the `xl` screen size.

  4. Since there can be hundreds or even thousands of reverse dependencies for a package, we're now [collapsing the reverse dependencies section when there are more than 100 items (ocaml/ocaml.org#1101)](https://github.com/ocaml/ocaml.org/pull/1101).

  5. The [breadcrumbs in the package area are now above the main content area (ocaml/ocaml.org#1133)](https://github.com/ocaml/ocaml.org/pull/1133) with the intent to make room next to the package name for upcoming badges that, e.g., provide information on the build status.

  6. We [updated the styles of the package search results page to be more compact (ocaml/ocaml.org#1134)](https://github.com/ocaml/ocaml.org/pull/1134): (a) author lists with more than five items are collapsed by listing the first five authors and "et al.", (b) package tags are now styled the same as on the package overview page, (c) a link to go directly to the package documentation is provided.

### Work in Progress: Basic In-Package Search

During the last month, we made progress on bringing basic in-package search functionality to the OCaml.org package documentation. Work on a prototype is ongoing on [staging.ocaml.org](https://staging.ocaml.org) (see [this Discuss post](https://discuss.ocaml.org/t/a-minimal-prototype-of-in-package-search-is-on-staging-ocaml-org/12163)), and we plan to roll out a rudimentary version of in-package search in May. 

We'll be rolling out the initial version as experimental, so it may have some issues and will be quite limited. We are releasing this early, as we find that having in-package search is vital for the usability of the package documentation. The upside of this process is that we're able to adapt to your feedback and ideas as we design the final product later on.

## General Improvements

We made improvements to the [OCaml.org dashboard](https://ocaml.org/dashboard) and GitHub actions workflows. The dashboard now displays the Git commit hash and memory consumption in bytes. We worked on fixing the RSS feed scraping workflow, which resulted in the ability to trigger the scraper to run via the GitHub UI and the ability to run workflows on a local machine. The scraping workflow was made more robust against the temporary unavailability of sources, and individual feeds for the Blog page are now scraped separately and merged into a global feed.

We are currently working on exposing the build status data for packages on the package overview pages. We also started to work on a dedicated "Install" page for OCaml with the help of the OCaml community. The new page will provide shorter instructions on how to set up OCaml quickly and the corresponding patch includes an overall revision of the "Get Up and Running" documentation.

In addition to all of this, the team has diligently tackled numerous bug fixes and quality-of-life improvements to enhance the overall user experience.

Relevant PRs/Issues:

  1. We improved the [ocaml.org dashboard](https://ocaml.org/dashboard) to [display the Git commit hash from which the currently running instance has been built (ocaml/ocaml.org#1136)](https://github.com/ocaml/ocaml.org/pull/1136), and to [display the memory consumption in bytes (ocaml/ocaml.org#1060)](https://github.com/ocaml/ocaml.org/pull/1060). For this, the build needed to happen in a Git-enabled folder which required [enabling the "include Git" option on the deployment pipeline (ocurrent/ocurrent-deployer#184)](https://github.com/ocurrent/ocurrent-deployer/pull/184).

  2. RSS feed scraping (which provides the data we display on the "Blog" page) broke in January when Git LFS was introduced to store the OCaml Playground assets. Another issue we observed was that [HTTP requests to some sources would time out (kayceesrk/river#8)](https://github.com/kayceesrk/river/issues/8). We worked on fixing the scraping workflow and ultimately succeeded. As a consequence of this work, we now enjoy improvements to the GitHub actions workflows, such as the ability to trigger the scraper to run via the GitHub UI, and the [ability to run workflows on a local machine (ocaml/ocaml.org#1068)](https://github.com/ocaml/ocaml.org/pull/1068). Subsequently, the scraping workflow was [made more robust against temporary unavailability of sources (ocaml/ocaml.org#1120)](https://github.com/ocaml/ocaml.org/pull/1120), and, instead of building a global feed by scraping all sources at the same time, [individual feeds are now scraped separately and merged into a global feed (ocaml/ocaml.org#1144)](https://github.com/ocaml/ocaml.org/pull/1144).

  3. We are working on [exposing the build status data for packages on the package overview pages (ocaml/ocaml.org#977)](https://github.com/ocaml/ocaml.org/pull/977#pullrequestreview-1404343612). As part of this effort,   [check.ocamllabs.io has already been moved to check.ci.ocaml.org (ocaml/infrastructure#40)](https://github.com/ocaml/infrastructure/issues/40) by the infrastructure team.

  4. To provide better statistics on the programming languages used in the ocaml/ocaml.org repository, we now [exclude vendored files from stats (ocaml/ocaml.org#1074)](https://github.com/ocaml/ocaml.org/pull/1074).

  5. Some AlpineJS-related bugfixes and cleanups on the [search dropdown (ocaml/ocaml.org#1069)](https://github.com/ocaml/ocaml.org/pull/1069) and [sidebar (ocaml/ocaml.org#1061)](https://github.com/ocaml/ocaml.org/pull/1061).

  6. Upgrade AlpineJS to 3.12.0, HTMX to 1.9.0 (resolves [ocaml/ocaml.org#877](https://github.com/ocaml/ocaml.org/issues/877)).

  7. We started working on an "Install" page for OCaml with the help of the OCaml community at https://discuss.ocaml.org/t/please-improve-my-draft-of-an-install-page-on-ocaml-org/11837. The intent of this page is to provide short instructions on how to set up OCaml quickly by leveraging OS detection via JavaScript. The upcoming patch includes an overall revision of the "Get Up and Running" documentation to provide better section headings and to clarify instructions while removing noise from the document.

  8. In response to an [inquiry about package documentation failing to build](https://github.com/ocaml/ocaml.org/issues/1042), the CI team helped us by investigating why the solver fails for the package in question. It turns out that, currently, the solver appears to only use two OCaml versions: 4.14 and 5.0.0. Until this changes, any package that does not work with either of these OCaml versions will not have its package documentation built successfully.

  9. A [new page that highlights all the previous Outreachy internships conducted by the OCaml community (ocaml/ocaml.org#1009)](https://github.com/ocaml/ocaml.org/pull/1009#pullrequestreview-1380824224) has been added to the Community section.

  10. We improved the HACKING.md documentation to [mention prerequisites on the development environment and to link to the Docker images built by the CI which are stored on Docker Hub (ocaml/ocaml.org#1102)](https://github.com/ocaml/ocaml.org/pull/1102). The intent of this is to make it simpler for new contributors to join the project.

  11. [Rearranged the "featured" section on the Blog page to allow featuring less than three posts (ocaml/ocaml.org#1082)](https://github.com/ocaml/ocaml.org/pull/1082).

  12. [Bugfix for a Unicode rendering problem (ocaml/ocaml.org#1083)](https://github.com/ocaml/ocaml.org/pull/1083) when searching for the empty string on the package search results page.

  13. [Added 'Roboto Mono' as a dedicated monospace font (ocaml/ocaml.org#1085)](https://github.com/ocaml/ocaml.org/pull/1085) to achieve a consistent display of code sections for all users.

  14. Errors in the documentation were reported by OCaml users. Thank you! We fixed them immediately: (1) Resolve unused for-loop index i Error [ocaml/ocaml.org#1084](https://github.com/ocaml/ocaml.org/pull/1084), (2) remove incorrect mention of utop [ocaml/ocaml.org#1086](https://github.com/ocaml/ocaml.org/pull/1086), and (3) Explain how to activate -dtypedtree in `utop-full` [ocaml/ocaml.org#1089](https://github.com/ocaml/ocaml.org/pull/1089)

  15. We vendored an experimental YAML parsing tool [tmattio/yoshi](https://github.com/tmattio/yoshi) into the ocaml.org repository to explore if that is a suitable way to simplify the YAML parsing aspect of the current `ood-gen` tool of ocaml.org.

  16. The package autocomplete search input in the top navigation bar now reacts faster since the [throttling delay has been removed (ocaml/ocaml.org#1122)](https://github.com/ocaml/ocaml.org/pull/1122).

  17. We made the [share button of the OCaml Playground more obvious (ocaml/ocaml.org#1117)](https://github.com/ocaml/ocaml.org/pull/1117) by adding a caption.

  18. We worked on the [experimental changelog page](https://ocaml.org/changelog).

  19. Considering that there are some unmet caching needs in our web stack (e.g., in the package documentation section: looking at the many HTTP requests and rendering the module tree menu), we [reached out to the OCaml community](https://discuss.ocaml.org/t/is-there-a-drop-in-solution-for-serving-responses-from-cache-in-dream/11985) to understand what the ecosystem is like at the moment and if there is a meaningful opportunity to contribute to the OCaml ecosystem as part of our work on OCaml.org.

  20. There is an open PR for [adding WIP dev-container](https://github.com/ocaml/ocaml.org/pull/1126) that can make it easier to get started developing on the ocaml/ocaml.org repository.

  21. The ["Contribute" link on the documentation pages now links to the commit from which the content was rendered (ocaml/ocaml.org#1139](https://github.com/ocaml/ocaml.org/pull/1139)

  22. The OCaml.org project [officially adopted the OCaml Code of Conduct by adding `CODE_OF_CONDUCT.md` to its GitHub repository
  (ocaml/ocaml.org#1135)](https://github.com/ocaml/ocaml.org/pull/1135) and by [adding ocaml/ocaml.org to the list of adopters (ocaml/code-of-conduct#6)](https://github.com/ocaml/code-of-conduct/pull/6)

  23. The [problems in the exercises section of the Learn area can now be filtered by difficulty (ocaml/ocaml.org#1141)](https://github.com/ocaml/ocaml.org/pull/1141#pullrequestreview-1403923329).

  24. Bugfix: the problem difficulty symbols in the exercise section would be cut off in the too-small margins. Now the [problem difficulty symbols in the exercises section only show up in the margin on `xl` screen size (ocaml/ocaml.org#1138).](https://github.com/ocaml/ocaml.org/pull/1138)

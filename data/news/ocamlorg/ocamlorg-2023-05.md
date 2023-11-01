---
title: "OCaml.org Newsletter: May 2023"
description: Monthly update from the OCaml.org team.
date: "2023-06-26"
tags: [ocamlorg]
---

Welcome to the May 2023 edition of the OCaml.org newsletter! As with the [previous update](https://ocaml.org/news/ocamlorg-2023-04), this has been compiled by @sabine and @tmattio.

The OCaml.org newsletter provides an overview of changes on the OCaml.org website and gives you a glimpse into what has been going on behind the scenes. You can find a [list of previous issues here](https://discuss.ocaml.org/tag/ocamlorg-newsletter).

Our goal is to make OCaml.org the best resource for anyone who wants to get started and be productive in OCaml. We couldn't do it without all the amazing OCaml community members who help us review, revise, and create better OCaml documentation. Your feedback enables us to better prioritise our work and make progress towards our goal. Thank you!

We present the work we've been doing this month in three sections:
* **Learn area:** We're working towards making OCaml.org a great resource to learn OCaml and discover its ecosystem. This month, we worked on the first wireframes of the new Learn section, and we published a couple of new documentation pages.
* **Package documentation search:** In-package search is now available for every package on OCaml.org! We released the first, minimal version of the feature and will continue to improve it in the coming months.
* **General Improvements:** We also worked on general maintenance and improvements. We'll highlight some of them in this newsletter.

## Learn Area

### 1. Redesign of the Learn Area

As part of our effort to make OCaml.org a great resource to learn OCaml, we published a survey to conduct user research in April. We received tons of insightful feedback. This month, we analysed all the results we got (57 answers!) and we conducted user interviews with those who volunteered to be interviewed.

As a follow-up to the user survey conducted last month, we posted a [summary for the Learn area survey](https://discuss.ocaml.org/t/you-started-to-learn-ocaml-less-than-12-months-ago-please-help-us-with-our-user-survey-on-the-ocaml-org-learning-area/11945/2).

After we analysed the interview data, created user insight cards, and went through all the resources recommended by the survey responses, we prioritised tasks and began creating wireframes for the Learn section. The work-in-progress wireframes are accessible on [Figma](https://www.figma.com/file/Aqk5y03fsaCuhTSywmmY06/OCaml.org-Public-Designs?type=design&node-id=114-175&mode=design).

In June, we'll start gathering user feedback on the wireframes and eventually start creating designs for the new Learn pages.

### 2. OCaml Documentation

We completed the [Sequences](https://ocaml.org/docs/sequences) and [Error Handling](https://ocaml.org/docs/error-handling) tutorials. The [Install page](https://ocaml.org/install) went live, and improvements were made to the [First Day tutorial](https://ocaml.org/docs/first-hour).

Asking the community to help review the initial versions of the new documentation page has been successful, so we're planning on opening more Discuss posts for pages that are ready to review in the coming months.

We're deeply grateful to all the contributors who helped review the documentation, either by sharing insights on Discuss or participating in the PR review on GitHub. This is exactly how we envisioned the effort on creating the new OCaml.org Documentation, so we're appreciative of everyone who engaged to make this a community initiative!

**Relevant PRs and Activities:**
- Reached out for community feedback on the new *Error Handling* documentation page https://discuss.ocaml.org/t/updating-the-error-handling-tutorial/12022
- *First Hour* improvement [ocaml/ocaml.org#1153](https://github.com/ocaml/ocaml.org/pull/1153)
- Line editing for *Functors* [ocaml/ocaml.org#1127](https://github.com/ocaml/ocaml.org/pull/1127)
- Rewrite *Functional Programming* doc introduction [ocaml/ocaml.org#971](https://github.com/ocaml/ocaml.org/pull/971)
- Import rewritten Set tutorial from V2 PR [ocaml/ocaml.org#948](https://github.com/ocaml/ocaml.org/pull/948)
- Documentation: *Sequences* [ocaml/ocaml.org#791](https://github.com/ocaml/ocaml.org/pull/791)
- Add a dedicated 'install' page [ocaml/ocaml.org#1038](https://github.com/ocaml/ocaml.org/pull/1038)
- Editing/testing *If Statements* [ocaml/ocaml.org#974](https://github.com/ocaml/ocaml.org/pull/974)
- Update *Labels* [ocaml/ocaml.org#1040](https://github.com/ocaml/ocaml.org/pull/1040)
- Remove `ppa/avsm` package from install instruction [ocaml/ocaml.org#1186](https://github.com/ocaml/ocaml.org/pull/1186)
- By External Contributors:
    - Typo in *Up-and-Running* [ocaml/ocaml.org#1162](https://github.com/ocaml/ocaml.org/pull/1162)
    - Fix a couple grammar bugs [ocaml/ocaml.org#1188](https://github.com/ocaml/ocaml.org/pull/1188)
    - Updated text to remove references to highlighted code that was not highlighted. [ocaml/ocaml.org#1213](https://github.com/ocaml/ocaml.org/pull/1213)
    - Fix `Sys.getenv_opt` type signature in tutorial [ocaml/ocaml.org#1228](https://github.com/ocaml/ocaml.org/pull/1228)
    - Update *Metaprogramming* [ocaml/ocaml.org#1232](https://github.com/ocaml/ocaml.org/pull/1232)

## In-Package Documentation Search

In April, we started working on building an in-package search feature for OCaml packages on OCaml.org. We continued this effort through May, and we released the feature at the end of the month. In-package search is now accessible for every package on OCaml.org! :tada:

Note that this is the first, minimal version of the feature. We're planning many improvements in the coming months, especially as the `odoc` team is currently working on adding search capabilities to `odoc`.

**Relevant PRs and Activities:**
- Fix incomplete search index [ocaml-doc/voodoo#59](https://github.com/ocaml-doc/voodoo/pull/59#pullrequestreview-1408753903)
- Integrate experimental in-browser search [ocaml/ocaml.org#1165](https://github.com/ocaml/ocaml.org/pull/1165)
- Get community feedback for the minimal prototype of in-package search [on Discuss](https://discuss.ocaml.org/t/a-minimal-prototype-of-in-package-search-is-on-staging-ocaml-org/12163/1)


## General Improvements

We approved and merged numerous changes, including serving OCaml.org's static assets under cache-busting URLs, refactorings for better code health, and scraping OCaml Planet feeds individually. A big thank you to the contributors!

We initiated work on a design system for OCaml.org, emphasising buttons, dropdowns, and typography. As part of this work, we invested time researching potential improvements to our CSS, including a potential migration from Tailwind to UnoCSS for better custom rules support. We opened an issue with UnoCSS to explore options for a standalone CLI and have begun to create Dream components for UI elements that occur repeatedly.

We began working on adding tags to facilitate blog search and added several RSS feeds from the old OCaml Planet to the OCaml blog. As a consequence, we had to address issues relating to these new RSS sources.

**Relevant PRs and Activities:**
- Bugfixes:
    - Close `form` tag in changelog.eml [ocaml/ocaml.org#1155](https://github.com/ocaml/ocaml.org/pull/1155)
    - Install page: only distinguish between Windows and everything else; fix wrong default selection [ocaml/ocaml.org#1191](https://github.com/ocaml/ocaml.org/pull/1191)
- Data:
    - Bump Ahrefs job, as it's still relevant [ocaml/ocaml.org#1168](https://github.com/ocaml/ocaml.org/pull/1168)
- By External Contributors:
    - Use `OCamlorg_static.Media.url` for media [ocaml/ocaml.org#1163](https://github.com/ocaml/ocaml.org/pull/1163#pullrequestreview-1427954152)
    - Add O(1) labs in Industrial User page [ocaml/ocaml.org#1180](https://github.com/ocaml/ocaml.org/pull/1180#pullrequestreview-1427841365)
- OCaml Planet:
    - Add Signal and Threads as an RSS source [ocaml/ocaml.org#1197](https://github.com/ocaml/ocaml.org/pull/1197)
    - Fix RSS sources filename [ocaml/ocaml.org#1198](https://github.com/ocaml/ocaml.org/pull/1198)
    - Create RSS feed `planet` folder, if missing [ocaml/ocaml.org#1200](https://github.com/ocaml/ocaml.org/pull/1200)
    - Add Archives of OCaml Weekly News to `/blog` [ocaml/ocaml.org#1201](https://github.com/ocaml/ocaml.org/pull/1201)
    - Fix scraping path management [ocaml/ocaml.org#1204](https://github.com/ocaml/ocaml.org/pull/1204)
    - Add Caml Weekly News RSS feed [ocaml/ocaml.org#1207](https://github.com/ocaml/ocaml.org/pull/1207)
    - Add Signal and Threads RSS feed [ocaml/ocaml.org#1209](https://github.com/ocaml/ocaml.org/pull/1209)
    - Add emelle.tv RSS feed [ocaml/ocaml.org#1217](https://github.com/ocaml/ocaml.org/pull/1217)
    - Add ocaml.org hand-picked RSS feed [ocaml/ocaml.org#1218](https://github.com/ocaml/ocaml.org/pull/1218)
- Other:
    - Serve dashboard assets from file system [ocaml/ocaml.org#1167](https://github.com/ocaml/ocaml.org/pull/1167)

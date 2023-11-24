---
title: "OCaml.org Newsletter: June 2023"
description: Monthly update from the OCaml.org team.
date: "2023-07-14"
tags: [ocamlorg]
---

Welcome to the June 2023 edition of the OCaml.org newsletter! As with the [previous update](https://discuss.ocaml.org/t/ocaml-org-newsletter-may-2023/12485), this has been compiled by @sabine and @tmattio.

The OCaml.org newsletter provides an overview of changes on the OCaml.org website and gives you a glimpse into what has been going on behind the scenes. You can find a [list of previous issues here](https://discuss.ocaml.org/tag/ocamlorg-newsletter).

Our goal is to make OCaml.org the best resource for anyone who wants to get started and be productive in OCaml. We couldn't do it without all the amazing OCaml community members who help us review, revise, and create better OCaml documentation. Your feedback enables us to better prioritise our work and make progress towards our goal. Thank you!

We present the work we've been doing this month in three sections:
- **Learn Area:** We're working towards making OCaml.org a great resource to learn OCaml and discover its ecosystem. This month, we continued working on the wireframes and designs of the new Learn area. We also focused on writing the new documentation with a couple of tutorials on Dune and S-Expressions.
- **Governance Page:** The OCaml Platform team is working towards making the decision-making processes and ongoing development more transparent and community-driven (including the work on the [OCaml Platform roadmap](https://discuss.ocaml.org/t/a-roadmap-for-the-ocaml-platform-seeking-your-feedback/12238)). To support the initiative, we're working on a governance page that lists the teams and maintainers of the OCaml organisation.
- **General Improvements:** As usual, we also worked on general maintenance and improvements and we’ve highlighted some of them in this newsletter.

## Learn Area

### 1. Redesign of the Learn Area

Last month, we started working on the wireframes and the designs for the new Learn area, based on user feedback.

This month, we made amendments to the wireframes and designs for the landing page in the learning area and subsequently created the wireframes for other necessary pages, namely “Get Started,” “Language,” “Tutorials,” “Exercises,” “Books,” and “Search Results.” We also held a interactive session with the OCaml.org team to review and rework the wireframes.

At the end of the month, we also [shared the updated designs](https://discuss.ocaml.org/t/help-us-make-the-new-learn-area-on-ocaml-org-awesome/12508.) to get feedback from the community.

The work-in-progress designs are accessible on [Figma](https://www.figma.com/proto/Aqk5y03fsaCuhTSywmmY06/OCaml.org-Public-Designs?type=design&node-id=130-767&t=7ICA3gfxHteFI0le-0&scaling=min-zoom&page-id=130%3A754).

Next month, we'll continue to improve the designs based on the feedback we received, and we'll start sending Pull Requests to implement the UI.

### 2. OCaml Documentation

In addition to a complete redesign of the Learn area, our work involves a full revision of the documentation content, as well as the creation of new documentation. 

Last month, we completed the [Sequences](https://ocaml.org/docs/sequences) and [Error Handling](https://ocaml.org/docs/error-handling) tutorials.

This month, we held a workshop on writing new documentation with the OCaml.org team in order to kickstart the creation of many more documentation pages. The collaboration to write outlines for the new tutorials proved to be helpful, so we plan to hold regular workshops. We're also planning to open these workshops to the community. Stay tuned!

We created an entirely new tutorial on “File Manipulation” that is going to enter the community review phase soon. In addition, we worked on a new “Dune” tutorial and a new “S-Expressions” tutorial, and we created outlines for “Basic Datatypes” and “Values & Functions” tutorials.

### 3. "Is OCaml X Yet?" Pages

As part of the our work on the new Learn area, we started exploring the [addition of "Is OCaml X yet?" pages](https://github.com/ocaml/ocaml.org/pull/1226), inspired by Rust's excellent ["Are we web yet?" page](https://www.arewewebyet.org/).

As stated in the Pull Request, the goal of these pages is three-fold:

- For newcomers, it offers an overview of the usability of OCaml for certain applications.
- For OCaml users, it can help the discovery of libraries and frameworks to perform certain tasks.
- For community members, it can serve as a roadmap to focus our efforts on addressing specific pain points to make OCaml competitive with other languages for specific use cases.

We've engaged the community and authors of packages related to web development, and we received excellent feedback on the Pull Request.

Next, we plan to focus the work on a single "Is OCaml Web Yet?" page and tackle other pages separately. We'll continue to explore the ecosystem and merge an initial version of the page that we'll aim to continuously improve to reflect the state of web development in OCaml.

### 4. Preparing the Move of the opam Documentation to OCaml.org

We worked on a patch that moves the opam documentation under the "Platform Tools" page in the Learn area.

The intent behind this is to retire the public-facing website at opam.ocaml.org, now that we have a centralised directory for package documentation on ocaml.org.

The long-term plan for the opam manual is to generate it via the package documentation pipeline. However, to realise this, the opam manual needs to be ported to `odoc`. As seen in in the OCaml Platform newsletter, the `odoc` team is currently working on improving `odoc`'s capabilities to create rich and easily navigable manuals.

## Towards a More Transparent Governance For OCaml

In May, we merged [a PR](https://github.com/ocaml/ocaml.org/pull/1175) that extends the OCaml.org governance policy to include the governance of the OCaml Platform, including its lifecycle and the requirements for each stage.

This month, we worked on a [new governance page](https://github.com/ocaml/ocaml.org/pull/1239) that lists the teams and maintainers of the ecosystem.

The main challenge is to list the maintainers of each project accurately, going forward. To that end, we're discussing [using GitHub teams](https://github.com/ocaml/infrastructure/issues/55) to get an up-to-date list of maintainers for each project.

## General Improvements

A lot of work went on general maintenance and improvements this month!

Have a look a the list of relevant PRs and activities below for our highlights.

**Relevant PRs and Activities:**

- We designed a banner for the OCaml home page and announced the ACM SIGPLAN award that OCaml received. -- [#1327](https://github.com/ocaml/ocaml.org/pull/1327)
- We began investigating how to load packages into the OCaml Playground.
- We now recognise and display a Long-Term-Support version of OCaml (currently 4.14.1) on the main landing page, and the releases section has been moved from the Learn area to the main landing page. -- [#1277](https://github.com/ocaml/ocaml.org/pull/1277) & [#1313](https://github.com/ocaml/ocaml.org/pull/1313)
- We added 55 RSS feeds from v2.ocaml.org to the blog aggregator on ocaml.org and discovered some faulty URLs in two of them. -- [#1329](https://github.com/ocaml/ocaml.org/pull/1329)
- We made a bit of progress towards a dark mode for ocaml.org by tidying up the Tailwind configuration, giving colors more semantic names, and factoring out repeated HTML into components. -- [#1350](https://github.com/ocaml/ocaml.org/pull/1350)
- We began working on enabling filtering by tags for blogs on ocaml.org. We sought [community input on preferred filters/tags](https://discuss.ocaml.org/t/which-filters-would-you-like-to-see-on-the-ocaml-blog-at-ocaml-org/12429).
- We worked on refining the documentation pipeline, specifically the tool [`voodoo`](https://github.com/ocaml-doc/voodoo), by removing dead legacy code and optimising the process for detecting README, LICENSE, and CHANGELOG files, with the aim of reducing the number of HTTP requests that ocaml.org makes to docs-data.ocaml.org.
- A new broken link checker tool [tarides/olinkcheck](https://github.com/tarides/olinkcheck) has been created. Efforts to integrate the tool with the package documentation pipeline are in progress, and a workflow that runs `tarides/olinkcheck` has been added to the GitHub repository. The tool extracts Hyperlinks from documents of the supported formats plaintext, S-expressions, YAML, and HTML, and it checks whether the given URL responds with a HTTP status 200. -- [#1345](https://github.com/ocaml/ocaml.org/pull/1345)

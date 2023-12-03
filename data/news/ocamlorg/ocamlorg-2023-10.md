---
title: "OCaml.org Newsletter: October 2023"
description: Monthly update from the OCaml.org team.
date: "2023-11-21"
tags: [ocamlorg]
---

Welcome to the October 2023 edition of the OCaml.org newsletter! This update has been compiled by the OCaml.org team. You can find [previous updates](https://discuss.ocaml.org/tag/ocamlorg-newsletter) on Discuss.

Our goal is to make OCaml.org the best resource for anyone who wants to get started and be productive in OCaml. The OCaml.org newsletter provides an update on our progress towards that goal and an overview of the changes we are working on.

We couldn't do it without all the amazing OCaml community members who help us review, revise, and create better OCaml documentation. Your feedback enables us to better prioritize our work and make progress towards our goal. Thank you!

This month, our priorities were:
- **Learn Area:** We continue our efforts to make OCaml.org a great resource for learning OCaml. This month, we've validated a new version of the designs for the Learn area, and we've published two new documentation pages!
- **Outreachy Internship Application Period**: OCaml.org is participating in the Outreachy Internship Program with two internship projects. As part of the application period, we've received tons of fantastic contributions from Outreachy applicants!
- **General Improvements:** As usual, we also worked on general maintenance and improvements based on user feedback, so we're highlighting some of our work below.

## Learn Area

### 1. Redesign of the Learn Area

After going back to the drawing board on the new designs for the Learn area, we've designed a new version of the landing page, alongside updated variants of the Community and Package landing pages, to ensure they are visually consistent. We've validated the new design direction and will be updating the designs for the rest of the Learn area pages next. Once the designs are available for all the pages, we'll be ready to start implementing them. We're very excited to get the new version of the pages live; we hope you are too! Stay tuned!

| Learn | Community | Package |
| -------- | -------- | -------- |
| ![ocamlorg-october-image1](upload://qaFRJ9SMshV36CJDidJOzg7cOMJ.jpeg) | ![ocamlorg-october-image2](upload://gaq41xnhZHR7dqez8SoJT21KiSM.png) | ![ocamlorg-october-image3](upload://fTO3KBbJHC4QT022ImymIcHyrxL.jpeg)|



**Relevant PRs and Activities:**

- Continued work on [Figma UX/UI designs](https://www.figma.com/file/Aqk5y03fsaCuhTSywmmY06/OCaml.org-Public-Designs?type=design&node-id=506%3A2172&mode=design&t=yHZfn6UccCjm5QCn-1) for the new Learn area
- Books page redesign - [ocaml/ocaml.org#1536](https://github.com/ocaml/ocaml.org/pull/1536)
- Added a short description to all exercises [ocaml/ocaml.org#1681](https://github.com/ocaml/ocaml.org/pull/1681)
- Collapse tab navigation to breadcrumbs for mobile view on learn area - [ocaml/ocaml.org#1541](https://github.com/ocaml/ocaml.org/pull/1541)

### 2. OCaml Documentation

Last month, we announced the publication of the [new Get Started documentation](https://discuss.ocaml.org/t/ann-new-get-started-documentation-on-ocaml-org/13269). After publishing this section, we're turning our focus to the Language section of the documentation.

This month, we've published two new documentation pages: [Basic Data Types](https://github.com/ocaml/ocaml.org/pull/1514) and [Functions & Values](https://github.com/ocaml/ocaml.org/pull/1512). Together, they teach the basics of OCaml from the very beginning, starting with what a value and a function are. Having witnessed newcomers such as Outreachy interns struggle to learn OCaml from the OCaml.org documentation because it required a lot of prior programming knowledge, we're excited to have this new content available for Outreachy interns and all newcomers. This is a first version of the pages, and we've already received [excellent feedback](https://discuss.ocaml.org/t/new-tutorials-on-basics-of-ocaml/13396) to improve it. Don't hesitate to share more, whether you're a beginner struggling to get up and running, or an OCaml developer with opinions on how we should teach OCaml!

We're currently reviewing two other documentation pages on Mutability and Polymorphic Variants. They should be ready for community review soon.

Stay tuned, and please, keep the feedback on the new documentation coming; it's been a blast to see so much engagement from the community!

**Relevant PRs and Activities:**

- **In Progress:**
  - Sets
  - Maps
- **In Review (internal):**
  - [Mutable State / Imperative Programming](https://github.com/ocaml/ocaml.org/pull/1529)
  - [Polymorphic Variants](https://github.com/ocaml/ocaml.org/pull/1531)
- **In Review (community):**
  - [File Manipulation](https://github.com/ocaml/ocaml.org/pull/1400) (see [Discuss Thread](https://discuss.ocaml.org/t/help-review-the-new-file-manipulation-tutorial-on-ocaml-org/12638))
- **Published:**
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

## Outreachy

OCaml.org is participating in the [Outreachy Internship Program](https://www.outreachy.org/). Outreachy provides internships to people subject to systemic bias and impacted by underrepresentation in the technical industry where they are living.

A substantial part of this month has been spent on creating issues, reviewing pull requests, and mentoring Outreachy applicants on the OCaml Discord server.

The contributions include small fixes, implementing Figma designs, and small feature additions. Notably, the [OCaml Changelog](https://ocaml.org/changelog) now has an RSS feed, and some outstanding designs for the package area have been applied.

8 out of the 21 medium difficulty issues have been completed in October, while only 6 out of 30 simple outreachy issues remain open. For the remaining issues, we will support the contributors in finishing their work, and free any abandoned issues so that community members can pick them up.

**Relevant PRs and Activities:**

- Opened [30 simple issues tagged "outreachy"](https://github.com/ocaml/ocaml.org/issues?q=is%3Aissue+is%3Aopen+label%3Aoutreachy), and [21 issues tagged "outreachy-medium"](https://github.com/ocaml/ocaml.org/issues?q=is%3Aissue+is%3Aopen+label%3Aoutreachy-medium)
- Refactor + simplify learn layout in preparation for new footer - [ocaml/ocaml.org#1590](https://github.com/ocaml/ocaml.org/pull/1590)
- [@ademolaomosanya](https://github.com/ademolaomosanya) contributed: Rearranged and changed links in footer - [ocaml/ocaml.org#1616](https://github.com/ocaml/ocaml.org/pull/1616)
- [@IdaraNabuk](https://github.com/IdaraNabuk) contributed: Update Tailwind Configuration to Resolve Warnings - [ocaml/ocaml.org#1620](https://github.com/ocaml/ocaml.org/pull/1620)
- [@oyenuga17](https://github.com/oyenuga17) contributed: Add a RSS feed for changelog - [ocaml/ocaml.org#1593](https://github.com/ocaml/ocaml.org/pull/1593)
- [@sophiatunji](https://github.com/sophiatunji) contributed: Renamed "problems" with "exercises" in filenames and codebase - [ocaml/ocaml.org#1592](https://github.com/ocaml/ocaml.org/pull/1592)
- [@kalio007](https://github.com/kalio007) contributed: Add a "Standard Library API" link to the mobile navigation menu - [ocaml/ocaml.org#1600](https://github.com/ocaml/ocaml.org/pull/1600)
- [@RWUBAKWANAYO](https://github.com/RWUBAKWANAYO) contributed: Fix search bar on medium-sized screens - [ocaml/ocaml.org#1665](https://github.com/ocaml/ocaml.org/pull/1665)
- [@shyusu4](https://github.com/shyusu4) contributed: Fix jump to definition on in-package search for Safari - [ocaml/ocaml.org#1634](https://github.com/ocaml/ocaml.org/pull/1634)
- [@FatumaA](https://github.com/FatumaA) contributed: Fix horizontal scrolling on ocaml ecosystem section of homepage - [ocaml/ocaml.org#1668](https://github.com/ocaml/ocaml.org/pull/1668)
- [@AndroGenius-codes](https://github.com/AndroGenius-codes) contributed: Applied new design for Package Search Dropdown - [ocaml/ocaml.org#1608](https://github.com/ocaml/ocaml.org/pull/1608)
- [@henilGondalia](https://github.com/henilGondalia) contributed: Applied New Styles to Package Documentation Module Navigation - [ocaml/ocaml.org#1638](https://github.com/ocaml/ocaml.org/pull/1638)
- [@Girish-Jangam](https://github.com/Girish-Jangam) contributed: Paginate package search results - [ocaml/ocaml.org#1657](https://github.com/ocaml/ocaml.org/pull/1657)
- [@sophiatunji](https://github.com/sophiatunji) contributed: Fixed js-of-ocaml link on home - [ocaml/ocaml.org#1707](https://github.com/ocaml/ocaml.org/pull/1707)
- [@Burnleydev1](https://github.com/Burnleydev1) contributed: Add Abongwa's summer internship info - [ocaml/ocaml.org#1647](https://github.com/ocaml/ocaml.org/pull/1647)
- [@RWUBAKWANAYO](https://github.com/RWUBAKWANAYO) contributed: Add link to English edition of the book "Développement d'applications avec Objective Caml [ocaml/ocaml.org#1659](https://github.com/ocaml/ocaml.org/pull/1659)
- [@AryanGodara](https://github.com/AryanGodara) contributed:
    - Add Blog Post for Outreachy Summer internship, Summer'23 - [ocaml/ocaml.org#1649](https://github.com/ocaml/ocaml.org/pull/1649)
    - Add Blog link in the summer internship post - [ocaml/ocaml.org#1703](https://github.com/ocaml/ocaml.org/pull/1703#pullrequestreview-1691241483)
- [@mohdaquib171](https://github.com/mohdaquib171) contributed: Tutorial Bottom Section Styles (#1603) [ocaml/ocaml.org#1617](https://github.com/ocaml/ocaml.org/pull/1617) - status: waiting for completion of another issue
- [@IdaraNabuk](https://github.com/IdaraNabuk) contributed: Add Capability for a Book Entry to have Multiple Languages - #1666 [ocaml/ocaml.org#1679](https://github.com/ocaml/ocaml.org/pull/1679)
- [@oyenuga17](https://github.com/oyenuga17) contributed: Add a Jump To Top Button [ocaml/ocaml.org#1702](https://github.com/ocaml/ocaml.org/pull/1702)
- [@sophiatunji](https://github.com/sophiatunji) contributed: Learn Area Footer Redesign - [ocaml/ocaml.org#1645](https://github.com/ocaml/ocaml.org/pull/1645)

## General Improvements

This month, we’re welcoming 1 new contributor:

- [@davesnx](https://github.com/davesnx) changes 'Unknown documentation status' from `a` to a `span` - [ocaml/ocaml.org#1628](https://github.com/ocaml/ocaml.org/pull/1628)

**Relevant PRs and Activities:**
  
- We now log a message instead of crashing when failing to parse the opam file - [ocaml/ocaml.org#1575](https://github.com/ocaml/ocaml.org/pull/1575)

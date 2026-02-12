---
title: "OCaml.org Newsletter: November + December 2023"
description: Monthly update from the OCaml.org team.
date: "2023-01-18"
tags: [ocamlorg]
---

Welcome to the November and December 2023 edition of the OCaml.org newsletter! This update has been compiled by the OCaml.org team. You can find [previous updates](https://discuss.ocaml.org/tag/ocamlorg-newsletter) on Discuss.

Our goal is to make OCaml.org the best resource for anyone who wants to get started and be productive in OCaml. The OCaml.org newsletter provides an update on our progress towards that goal and an overview of the changes we are working on.

We couldn't do it without all the amazing OCaml community members who help us review, revise, and create better OCaml documentation. Your feedback enables us to better prioritise our work and make progress towards our goal. Thank you!

This newsletter covers:
- **Learn Area:** We made substantial changes to the Learn Area UI, introducing a new landing page and improving various elements on the Learn Area's subpages. Work on a documentation search feature is in progress, and new documentation has been added or substantially improved!
- **Upcoming Dark Mode**: We completed the UI designs for the upcoming dark mode and our Outreachy intern has started to implement the changes.
- **Announcing the Outreachy Interns**: We're happy to welcome two interns to work on OCaml projects!
- **General Improvements:** As usual, we also worked on general maintenance and improvements based on user feedback, so we're highlighting some of our work below.

## Open Issues for Contributors

We created many issues for external contributors. The majority of them are suitable for OCaml beginners, and we're happy to review and provide feedback on your pull requests!

You can find [open issues for contributors here](https://github.com/ocaml/ocaml.org/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22+no%3Aassignee)!


## Learn Area

### 1. Redesign of the Learn Area


OCaml.org is undergoing an exciting transformation, and we're thrilled to share some key updates with you. Our main focus has been the finalisation and approval of a new user interface (UI) design, aimed at enhancing your experience. This update isn't just about looks; we're ensuring the website is fully optimised for mobile and tablet devices.

The collaboration between our team and users like you has been instrumental in shaping the project. Your input and support have been invaluable, and we're grateful for the community's involvement in making this website the best it can be.

Our design system has seen several updates, including new components like a variable landing page button, diverse icons (including social media and OCaml icons like Dune and opam), enhanced text styles, updated color variables, and more.

We've completed the designs for all pages of the Learn area. Each page has been designed with attention to detail, ensuring consistency and coherence across all versions.

If you’re curious and want to take a closer look at the designs, you can access our [Figma Design Files](https://www.figma.com/file/6BSOEqSsyQeulwLo2pjs9r/Untitled?type=design&node-id=0%3A1&mode=design&t=GwVxvrXItX7k8pP9-1). Please be aware that the content shown on the pages is not always accurate. We aim to provide our designer with better content for the mockups and UI going forward.

The work on implementing the new designs for the light mode of the Learn area have been completed in December!

**Relevant PRs and Activities:**
- Implemented Learn UI from Figma [ocaml/ocaml.org#1798](https://github.com/ocaml/ocaml.org/pull/1798)
- [@FatumaA](https://github/com/FatumaA) contributed: Improve platform page card styles [ocaml/ocaml.org#1752](https://github.com/ocaml/ocaml.org/pull/1752)
- [@florentdrousset](https://github.com/florentdrousset) contributed: Link exercises to tutorials [ocaml/ocaml.org#1753](https://github.com/ocaml/ocaml.org/pull/1753)
- Add book links based on Figma design - [ocaml/ocaml.org#1834](https://github.com/ocaml/ocaml.org/pull/1834)
- WIP: Documentation Search Feature - [ocaml/ocaml.org#1871](https://github.com/ocaml/ocaml.org/pull/1871)


### 2. OCaml Documentation

In November, we focussed on addressing and incorporating community feedback on the "Getting Started" documents. The comments and discussion on Discuss were so helpful. We encourage more of that!

We also worked on polishing "Basic Data Types" and "Values and Functions." Plus the team has been working on new "Modules," "Functors," and "Libraries With Dune" documents, hoping to have it, and the ones in community review (below), published before the end of the year.

**Relevant PRs and Activities:**

- **In Progress:**
  - Sets
  - Maps
  - Higher Order Functions
- **In Review (internal):**
  - [Options](https://github.com/ocaml/ocaml.org/pull/1800)
  - [Running Commands in a Switch](https://github.com/ocaml/ocaml.org/pull/1825)
  - [Labelled Arguments](https://github.com/ocaml/ocaml.org/pull/1881)
- **In Review (community):**
  - [Modules, Functors, Libraries With Dune](https://github.com/ocaml/ocaml.org/pull/1778) (see [Discuss](https://discuss.ocaml.org/t/draft-tutorials-on-modules-functors-and-libraries/))
  - [File Manipulation](https://github.com/ocaml/ocaml.org/pull/1400) (see [Discuss Thread](https://discuss.ocaml.org/t/help-review-the-new-file-manipulation-tutorial-on-ocaml-org/12638))
  - [Polymorphic Variants](https://github.com/ocaml/ocaml.org/pull/1531) (see [Discuss Thread](https://discuss.ocaml.org/t/new-draft-tutorial-on-polymorphic-variants/13485))
- **Published:**
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
    - We integrated pages from OCaml books into the Learn area, reproduced on OCaml.org with permission - [ocaml/ocaml.org#1766](https://github.com/ocaml/ocaml.org/pull/1766):
        - Compiler & Runtime pages from [Real World OCaml](https://dev.realworldocaml.org/), and
        - Memoisation & Monads from [OCaml Programming: Correct + Efficient + Beautiful](https://cs3110.github.io/textbook/cover.html)
    - Rearranged the sections on the Language documentation tab - [ocaml/ocaml.org#1756](https://github.com/ocaml/ocaml.org/pull/1756)
    - Documentation formatting: Replace unsemantic blockquotes by highlighting [ocaml/ocaml.org#1759](https://github.com/ocaml/ocaml.org/pull/1759)
    - We improved the "Is OCaml Web Yet?" page, adding many more packages and reworking the text to more accurately capture the current state of the OCaml web ecosystem - [ocaml/ocaml.org#1843](https://github.com/ocaml/ocaml.org/pull/1843)
    - Editing on Basic Data Types - [ocaml/ocaml.org#1827](https://github.com/ocaml/ocaml.org/pull/1827)
    - Values & Functions :: Addressing suggestions from Issue #1762 - [ocaml/ocaml.org#1812](https://github.com/ocaml/ocaml.org/pull/1812)
- **Contributions:**
    - [@benjamin-thomas](https://github.com/benjamin-thomas) improved the `Map` document by providing a better example that uses different types for the key and value [ocaml/ocaml.org#1743](https://github.com/ocaml/ocaml.org/pull/1743)
    - [@leostera](https://github.com/leostera) simplified the "Bootstrapping a Project with Dune" guide - [ocaml/ocaml.org#1792](https://github.com/ocaml/ocaml.org/pull/1792)
    - [@FatumaA](https://github/com/FatumaA) fixed a typo in "Tour of OCaml" [ocaml/ocaml.org#1739](https://github.com/ocaml/ocaml.org/pull/1739)
    - [@binwang-dev](https://github.com/binwang-dev) contributed: Fix type inconsistency in tutorial [ocaml/ocaml.org#1757](https://github.com/ocaml/ocaml.org/pull/1757)
    - [@J3RN](https://github.com/J3RN) contributes: Fix escaping in "Your First OCaml Program" - [ocaml/ocaml.org#1846](https://github.com/ocaml/ocaml.org/pull/1846)
    - [@Sc4ramouche](https://github.com/Sc4ramouche) contributes: Add comparison of std containers guide to v3 docs - [ocaml/ocaml.org#1828](https://github.com/ocaml/ocaml.org/pull/1828)
    - [@Sc4ramouche](https://github.com/Sc4ramouche) contributes: Fix typo in Tour of OCaml - [ocaml/ocaml.org#1820](https://github.com/ocaml/ocaml.org/pull/1820)
    - [@J3RN](https://github.com/J3RN) contributes: Fix broken "Install Platform Tools" link - [ocaml/ocaml.org#1841](https://github.com/ocaml/ocaml.org/pull/1841)

We started opening issues marked with "help wanted" to enable external contributors to help improve the docs. The response has been overwhelmingly positive, and we're thrilled to keep this up and make the OCaml documentation truly great with your help!


## Upcoming Dark Mode

In December, [oyenuga17](https://github.com/oyenuga17) started to implement the new dark mode on OCaml.org. Plans are to complete and activate the dark mode based on browser / operating system preferences by early March.

We continuously merge small patches into ocaml.org, and you can take a look at completed dark mode pages on https://staging.ocaml.org. We placed a button at the bottom of the page to toggle the dark mode on staging (this is not going to be released, it is only a means for us to review the dark mode pages).

**Relevant Activities and PRs:**
- Implement dark mode on learn area landing page - [ocaml/ocaml.org#1836](https://github.com/ocaml/ocaml.org/pull/1836)
- UI design for dark mode on all OCaml.org pages, and resulting Design System changes

## Announcing the Outreachy Interns

In November, we reviewed and rated the Outreachy contributions for the dark mode project and the GUI project and selected the two interns. [@oyenuga17](https://github.com/oyenuga17) is working with the OCaml.org team on implementing the dark mode, while [@IdaraNabuk](https://github.com/IdaraNabuk) has been selected for the GUI project. Congratulations [@IdaraNabuk](https://github.com/IdaraNabuk) and [@oyenuga17](https://github.com/oyenuga17)!

Since the Outreachy application period ended in October, we list all the remaining pull requests done on Outreachy Issues in the "General Improvements" section below.

## General Improvements

**Most Important Changes TLDR**:
* There's now a self-hosted Plausible.io instance for OCaml.org, accessible at https://plausible.ci.dev/ocaml.org!
* You can see the different OCaml teams (Compiler, Platform, Packaging, Infrastructure, OCaml.org) and the maintainers of relevant repositories at the new governance page at https://ocaml.org/governance!
* The OCaml Logo now has a dedicated page at https://ocaml.org/logo!
* We’re now displaying a package's README on the package overview page.
* You can now [list upcoming events](https://github.com/ocaml/ocaml.org/blob/main/CONTRIBUTING.md#content-upcoming_event) with date and time on https://ocaml.org/community.
* OCaml.org now has social media images, so that sharing OCaml.org links looks nicer.

Many thanks go out to the many contributors who helped improve OCaml.org in November and December. Find them listed below!

**Relevant PRs and Activities:**
- Features / Improvements:
  - Added a governance page that lists the maintainers and dev meetings of the compiler, all the projects of the OCaml Platform, and the ocaml.org infrastructure - [ocaml/ocaml.org#1239](https://github.com/ocaml/ocaml.org/pull/1239)
  - [@IdaraNabuk](https://github.com/IdaraNabuk) contributed: Added the ability to record upcoming events to the community page - [ocaml/ocaml.org#1717](https://github.com/ocaml/ocaml.org/pull/1717)
  - [@Girish-Jangam](https://github.com/Girish-Jangam) contributed: Added a page for the OCaml logo - [ocaml/ocaml.org#1711](https://github.com/ocaml/ocaml.org/pull/1711)
  - Add ability to disable an OCaml Planet source / fix scraper and scrape missing planet posts - [ocaml/ocaml.org#1734](https://github.com/ocaml/ocaml.org/pull/1734)
  - [@leostera](https://github.com/leostera) contributed: Package search UX improvements - [ocaml/ocaml.org#1691](https://github.com/ocaml/ocaml.org/pull/1691)
    - Added an OpenSearch manifest, so you can add the OCaml packages search to your browser search bar
    - Made search input in main navbar gain tab-focus earlier
    - Set tabindex="1" for the in-package search input on the package documentation page
    - Autofocus the search inupt on the package search results page
  - [@mays4](https://github.com/mays4) contributed: Add links to CONTRIBUTING.md for all data items that can be contributed - [ocaml/ocaml.org#1682](https://github.com/ocaml/ocaml.org/pull/1682)
  - [@m-spitfire](https://github.com/m-spitfire) contributed: Entries on the changelog page are now paginated - [ocaml/ocaml.org#1751](https://github.com/ocaml/ocaml.org/pull/1751)
  - Add missing social media images to OCaml.org HTML metadata. Now, posts shared on social media have the OCaml logo as image, which is much better than having no image - [ocaml/ocaml.org#1784](https://github.com/ocaml/ocaml.org/pull/1784)
  - We're now displaying a package's README on the package overview page. This was part of one of the design options from the package area redesign earlier this year. However, it wasn't entirely clear that this was the right thing to do. More confirmation came up in terms of people asking for this, so we did it. - [ocaml/ocaml.org#1832](https://github.com/ocaml/ocaml.org/pull/1832)
  - Update to Tailwind CSS 3.3.6 - [ocaml/ocaml.org#1850](https://github.com/ocaml/ocaml.org/pull/1850)
  - Added table of contents to jump to individual sections on "Is OCaml Web yet" - [ocaml/ocaml.org#1849](https://github.com/ocaml/ocaml.org/pull/1849)
  - [@RWUBAKWANAYO](https://github.com/RWUBAKWANAYO) contributed: Improved responsive layout on releases page - [ocaml/ocaml.org#1716](https://github.com/ocaml/ocaml.org/pull/1716)
  - [@kiyov09](https://github.com/kiyov09) contributed: Reduced the number of news items in the blog page to have a similar height to the OCaml Planet column - [ocaml/ocaml.org#1754](https://github.com/ocaml/ocaml.org/pull/1754)
  - [@oyenuga17](https://github.com/oyenuga17) contributed: Improved responsive collapsing of the table on the papers page - [ocaml/ocaml.org#1741](https://github.com/ocaml/ocaml.org/pull/1741)
- Bugfixes:
  - Adjust CSS order of elements of main nav, starting from 0 - [ocaml/ocaml.org#1745](https://github.com/ocaml/ocaml.org/pull/1745)
  - Set correct background color on learn tabs select element - [ocaml/ocaml.org#1746](https://github.com/ocaml/ocaml.org/pull/1746)
  - [@Solar-Rays](https://github.com/Solar-Rays) contributed: Remove links from outreachy project description to prevent overflow - [ocaml/ocaml.org#1764](https://github.com/ocaml/ocaml.org/pull/1764)
  - Patch upstream dependency `river` to fall back to feed entry's `id` if `links` tag does not exist. This allows more feeds to be scraped successfully. - [tarides/river#11](https://github.com/tarides/river/pull/11)
  - Added missing Code of Conduct Route - [ocaml/ocaml.org#1781](https://github.com/ocaml/ocaml.org/pull/1781)
  - Added missing 'Platform Tools' link in footer - [ocaml/ocaml.org#1788](https://github.com/ocaml/ocaml.org/pull/1788)
  - [@AndroGenius-codes](https://github.com/AndroGenius-codes) contributed: Fixed a bug in pagination where the page number "1" was displayed twice when all the results would fit on a single page - [ocaml/ocaml.org#1729](https://github.com/ocaml/ocaml.org/pull/1729)
  - [@Demmythetechie](https://github.com/Demmythetechie) contributed: Add `word-wrap: break-word` to the Tailwind Typography prose class to prevent long URLs in content areas from overflowing - [ocaml/ocaml.org#1722](https://github.com/ocaml/ocaml.org/pull/1722)
  - [@AndroGenius-codes](https://github.com/AndroGenius-codes) contributed: Shorten text on Outreachy Projects link on the community page to prevent overflow - [ocaml/ocaml.org#1749](https://github.com/ocaml/ocaml.org/pull/1749)
  - [@oyenuga17](https://github.com/oyenuga17) contributed: Render search query as input value on the papers page and the releases page - [ocaml/ocaml.org#1747](https://github.com/ocaml/ocaml.org/pull/1747)
  - [@FatumaA](https://github/com/FatumaA) contributed: Added spacing below "See All Releases" button on homepage - [ocaml/ocaml.org#1740](https://github.com/ocaml/ocaml.org/pull/1740)
  - [@RWUBAKWANAYO](https://github.com/RWUBAKWANAYO) contributed: Resolve text styling issue in release list headers [ocaml/ocaml.org#1773](https://github.com/ocaml/ocaml.org/pull/1773)
  - [@kevanantha](https://github.com/kevanantha) contributed: Fix invalid link for exercises [ocaml/ocaml.org#1802](https://github.com/ocaml/ocaml.org/pull/1802)
- Other:
  - [@oyenuga17](https://github.com/oyenuga17) contributed: Replaced dependency `omd` with `cmarkit` - [ocaml/ocaml.org#1642](https://github.com/ocaml/ocaml.org/pull/1642). Thanks for this excellent and challenging contribution!
  - Remove Yoshi tool - [ocaml/ocaml.org#1735](https://github.com/ocaml/ocaml.org/pull/1735)
  - Removed dream-dashboard, it was replaced a self-hosted plausible.io instance - [ocaml/ocaml.org#1736](https://github.com/ocaml/ocaml.org/pull/1736)
  - Rename Tutorials->Documentation in meta title of Learn Area - [ocaml/ocaml.org#1789](https://github.com/ocaml/ocaml.org/pull/1789)
- Content:
  - Added "Introduction to Functional Programming and the Structure of Programming Languages using OCaml" to the books section - [ocaml/ocaml.org#1744](https://github.com/ocaml/ocaml.org/pull/1744)
  - Added the changelog for opam.2.2.0~alpha3 - [ocaml/ocaml.org#1771](https://github.com/ocaml/ocaml.org/pull/1771)
  - Update title of Platform Roadmap document to 'OCaml Platform Roadmap' - [ocaml/ocaml.org#1790](https://github.com/ocaml/ocaml.org/pull/1790)
  - Add some feeds to the OCaml Planet - [ocaml/ocaml.org#1779](https://github.com/ocaml/ocaml.org/pull/1779)
  - Added "Practical OCaml" blog to the Planet - [ocaml/ocaml.org#1806](https://github.com/ocaml/ocaml.org/pull/1806)
  - [@caisar-platform](https://github.com/caisar-platform) contributed: Fix broken link in CEA Research Engineer offer. [ocaml/ocaml.org#1787](https://github.com/ocaml/ocaml.org/pull/1787)
  - [@KihongHeo](https://github.com/KihongHeo) contributed: Add KAIST as an academic institution [ocaml/ocaml.org#1791](https://github.com/ocaml/ocaml.org/pull/1791)
  - [@hetzenmat](https://github.com/hetzenmat) contributes: Fix wrong release date for 5.1.1 - [ocaml/ocaml.org#1858](https://github.com/ocaml/ocaml.org/pull/1858)
  - [@zapashcanon](https://github.com/zapashcanon) contributes: Fix order of presentations - [ocaml/ocaml.org#1859](https://github.com/ocaml/ocaml.org/pull/1859)
  - [@oyenuga17](https://github.com/oyenuga17) contributes: add outreachy blog | introduce yourself - [ocaml/ocaml.org#1848](https://github.com/ocaml/ocaml.org/pull/1848)
  - [@IdaraNabuk](https://github.com/IdaraNabuk) contributed: Add Outreachy Blog Post to OCaml Planet [ocaml/ocaml.org#1878](https://github.com/ocaml/ocaml.org/pull/1878)
  - Added 'Retrofitting Parallelism onto OCaml' paper - [ocaml/ocaml.org#1875](https://github.com/ocaml/ocaml.org/pull/1875)

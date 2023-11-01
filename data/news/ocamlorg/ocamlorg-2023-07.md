---
title: "OCaml.org Newsletter: July 2023"
description: Monthly update from the OCaml.org team.
date: "2023-08-11"
tags: [ocamlorg]
---

Welcome to the July 2023 edition of the OCaml.org newsletter! As with the [previous issues](https://discuss.ocaml.org/tag/ocamlorg-newsletter), this update has been compiled by @sabine and @tmattio.

Our goal is to make OCaml.org the best resource for anyone who wants to get started and be productive in OCaml. The OCaml.org newsletter provides an update of our progress towards that goal and an overview of changes we are working on.

We couldn't do it without all the amazing OCaml community members who help us review, revise, and create better OCaml documentation. Your feedback enables us to better prioritise our work and make progress towards our goal. Thank you!

This month, our priorities were:
- **Learn Area:** We're working towards making OCaml.org a great resource to learn OCaml and discover its ecosystem. This month, we continued writing the new documentation content and iterating on community feedback. We also finalised the Figma light desktop designs and started implementing the UI.
- **JavaScript Toplevels**: We started exploring how to generate JavaScript toplevels for OCaml packages, with the goal of allowing users to load packages into the [OCaml Playground](https://ocaml.org/play), and adding a new toplevel feature to the [OCaml Packages area](https://ocaml.org/packages). Ultimately, we aim to make every code block on OCaml.org interactive!
- **General Improvements:** As usual, we also worked on general maintenance and improvements based on user feedback, and we're highlighting some of our work.

In addition to our work on the site, we introduced new ways for the team to interact with the community. We've created an [#ocaml.org Discord channel](https://discord.com/channels/436568060288172042/1126433906976112700), and we started holding [public OCaml.org dev meetings](https://discuss.ocaml.org/t/you-can-attend-the-new-ocaml-org-community-meetings/12656/1). Don't hesitate to reach out to us on Discord and join the dev meetings. We're always looking for new insights on things to improve!

## Learn Area

### 1. Redesign of the Learn Area

As the designs for the new Learn area are nearing completion, we started implementing the UI. If you have visited the documentation in the past few weeks, you've probably noticed a few changes. The most prominent one being the new tabs to navigate the different parts of the documentation.

On the design front, our focus will now be directed to the mobile views and dark mode.

**Relevant PRs and Activities:**

- Continued work on [Figma UX/UI designs](https://www.figma.com/file/Aqk5y03fsaCuhTSywmmY06/OCaml.org-Public-Designs?type=design&node-id=130-754&mode=design&t=XvVCMukq5AR3oxRf-0) for the new Learn area:
    - Finalised the light theme designs
    - Created color variants and a color palette in Figma, aiming for consistency with Figma to the Tailwind configuration, and established naming conventions for light and dark mode colors.
    - Designed various button variants on Figma, including Extra large, Large, Small, Large Ghost, Ghost, and Level tag styles.
- Started implementing new components for the Learn Area:
    - Tab -- [ocaml/ocaml.org#1389](https://github.com/ocaml/ocaml.org/pull/1389)
    - Tutorial block -- [ocaml/ocaml.org#1387](https://github.com/ocaml/ocaml.org/pull/1387)
    - Language Manual banner -- [ocaml/ocaml.org#1406](https://github.com/ocaml/ocaml.org/pull/1406)
    - Skill level tag -- [ocaml/ocaml.org#1427](https://github.com/ocaml/ocaml.org/pull/1427)
- Introduced new tabs to navigate the OCaml documentation by section -- [ocaml/ocaml.org#1429](https://github.com/ocaml/ocaml.org/pull/1429)

### 2. OCaml Documentation

We also continued the work on the new documentation content. As we've been through the lifecycle of new pages a couple times, we're getting more structured. Each new page goes through the following steps: Outline Approval, Drafting, Internal Review and, finally, Community Review. We have two new pages that are in the final stage (community review), namely the File Manipulation tutorial and Arrays guide. They should be ready to merge in the coming weeks. We also have a completely new Getting Started tutorial that aims to replace the existing "Your First Day with OCaml." It's currently in the internal review stage and should be shared on Discuss for community review soon.

Plus, we've got a lot more content in the drafting stage.

Stay tuned, as we'll be sharing more and more new documentation pages for community review!

**Relevant PRs and Activities:**

- Created a tentative [high-level outline](https://hackmd.io/p-JHDQUCSS6z3n2NYa8Qzw?view) and [meta-issue]((https://github.com/ocaml/ocaml.org/issues/1415)) to track our progress.
- Worked on the new documentation content
  - File Manipulation (status: community review)
    - [Pull Request](https://github.com/ocaml/ocaml.org/pull/1400)
    - [Discuss thread](https://discuss.ocaml.org/t/help-review-the-new-file-manipulation-tutorial-on-ocaml-org/12638)
  - New Arrays tutorial (status: community review)
    - [Pull Request](https://github.com/ocaml/ocaml.org/pull/1405)
    - [Discuss thread](https://discuss.ocaml.org/t/feedback-needed-new-arrays-tutorial-on-ocaml-org/12683)
  - Tour of OCaml (status: internal review)
    - [Pull Request](https://github.com/ocaml/ocaml.org/pull/1431)
  - S-Expressions tutorial (internal review)
  - Maps and Sets guides (status: drafting)
  - Basic Datatypes guide (status: drafting)
- Watched TheVimeagen ["Learning OCaml Part 1"](https://www.youtube.com/watch?v=mhkoWp5Akww) and ["Learn OCaml Part 2"](https://www.youtube.com/watch?v=EgigQXpadFw). Subsequently, made it clearer how to activate the opam switch on the install page  -- [ocaml/ocaml.org#1390](https://github.com/ocaml/ocaml.org/pull/1390)
- Incorporating feedback from reviews:
  - Include [@gmevel](https://github.com/gmevel) proof-reading of Seq tutorial [ocaml/ocaml.org#1376](https://github.com/ocaml/ocaml.org/pull/1376)
- Other documentation improvements
  - Line edits on existing Labels tutorial [ocaml.org#1040](https://github.com/ocaml/ocaml.org/pull/1040)
  - Moved the Error Handling guide from Language to the Guides section -- [ocaml.org#1383](https://github.com/ocaml/ocaml.org/pull/1383)
  - Converted example from LaTeX to markdown in the If Statements, Loops, and Recursion tutorial -- [ocaml.org#1439](https://github.com/ocaml/ocaml.org/pull/1439)
  - Replaced `dune build @runtest` by `dune runtest` in the Running Executables and Tests with Dune tutorial -- [ocaml.org#1430](https://github.com/ocaml/ocaml.org/pull/1430)

### 3. Preparing the Move of the opam Documentation to OCaml.org

The next step for the centralised package documentation is to serve the documentation of critical OCaml packages, including the OCaml manual and the Platform tools documentation. This requires a lot of work on `odoc` to remove the blockers that prevents project from moving from their current documentation generator to `odoc`. As an intermediate step, we'll be moving the opam documentation to OCaml.org's Learn area, so we can retire the frontend of opam.ocaml.org and redirect all the trafic to ocaml.org.

We've been working towards these goals this month. You can follow our progress on [this PR](https://github.com/ocaml/ocaml.org/pull/1367).

**Relevant PRs and Activities:**

- ocaml/opam:
  - Move opam documentation from opam.ocaml.org to ocaml.org -- [ocaml/ocaml.org#1367](https://github.com/ocaml/ocaml.org/pull/1367)
  - Convert man pages to Markdown with YAML header -- [ocaml/opam#5594](https://github.com/ocaml/opam/pull/5594)
  - Changing the Markdown files in `doc/pages` to be amenable for use on OCaml.org -- [ocaml/opam#5593](https://github.com/ocaml/opam/pull/5593)
- ocaml-opam/opam2web:
  - Rearrange `opam2web` to remove all package info, build only opam archive, keep public key, and create redirections from opam.ocamlorg to ocaml.org in a Caddyfile. Current WIP branch at https://github.com/sabine/opam2web/tree/strip_to_bare_minimum
- ocaml/ocaml.org:
  - [Give Local Blogs a Page and RSS Feeds](https://github.com/ocaml/ocaml.org/pull/1459). This introduces the concept of a "blog hosted on OCaml.org." This way, we can host the non-changelog posts of the opam blog in such a way that we can redirect `opam.ocaml.org/blog/feed.xml` to `ocaml.org/blog/opam/feed.xml`

## JavaScript Toplevels

Always with the aim to improve the learning experience, we're exploring how to generate JavaScript toplevels for all the OCaml packages (the ones that are JavaScript-compatible, that is).

This would enable a few very neat new features:

- Loading OCaml packages from the OCaml Playground: to enable the use of any JavaScript-compatible package. This is very handy to share code snippets to beginners, which is currently limited to using the standard library.
- Toplevels for OCaml packages on the centralised documentation: to spawn a toplevel while navigating the documentation.
- Interactive toplevels for every code block: This includes the OCaml packages that contain code examples, but also every code block and exercices on the Learn area. You'd be able to run the code, edit it, run it again and inspect the result directly from the browser. Every documentation page becomes a Jupyter notebook!

We're very excited at the possibilities this brings to improving the learning experience. Let us know what you think, and stay tuned for updates on our explorations!

**Relevant PRs and Activities:**

- Process `.cma`'s, `.cmi`'s and toplevel `.js` files -- [ocaml-doc/voodoo#114](https://github.com/ocaml-doc/voodoo/pull/114)

## General Improvements

This month, we're welcoming no less than 4 new contributors:
- [@contificate](https://github.com/contificate) improved the OCaml Playground layout with [@StonedHesus](https://github.com/StonedHesus) doing a review
- [@just-max](https://github.com/just-max) fixed an issue with code sharing on the OCaml Playground
- [@AshineFoster](https://github.com/AshineFoster) updated the dev setup to be able to run the site without an internet connection.
- [@theteachr](https://github.com/theteachr) contributed a typo fix to the homepage.
- [@brandoncc](https://github.com/brandoncc) contributed a typo fix to the First Day with OCaml tutorial

Thanks a lot to all the contributors this month! It's lovely to see more and more people making contributions to the site!

**Relevant PRs and Activities:**

- OCaml Playground:
  - [@contificate](https://github.com/contificate) resolved the layout problem of the playground's bottom bar and thoroughly tested it in different browsers with a review from [@StonedHesus](https://github.com/StonedHesus) -- [ocaml.org#1384](https://github.com/ocaml/ocaml.org/pull/1384)
  - Building the playground was challenging due to a script incompatibility with POSIX  -- [ocaml.org#1456](https://github.com/ocaml/ocaml.org/pull/1456)
  - [@just-max](https://github.com/just-max) discovered and resolved an issue with Base64-encoded URLs generated by the Playground share button, ensuring backward compatibility  -- [ocaml.org#1434](https://github.com/ocaml/ocaml.org/pull/1434)
- OCaml.org package documentation:
  - Voodoo output format was updated to list README/LICENSE/CHANGELOG as part of `status.json`  -- [voodoo#68](https://github.com/ocaml-doc/voodoo/pull/68), [ocaml.org#1435](https://github.com/ocaml/ocaml.org/pull/1435)
  - Voodoo now includes a `Voodoo_serialize` module for data serialisation and deserialisation  -- [voodoo#103](https://github.com/ocaml-doc/voodoo/pull/103), [ocaml.org#1442](https://github.com/ocaml/ocaml.org/pull/1442)
  - Compile step issues with documentation pipeline generation tool addressed  -- [voodoo#115](https://github.com/ocaml-doc/voodoo/pull/115)
  - In case of missing documentation, users are now redirected to the last documented version  -- [ocaml.org#1438](https://github.com/ocaml/ocaml.org/pull/1438)
- Bug fixes and miscellaneous improvements:
  - [@AshineFoster](https://github.com/AshineFoster) made ocaml.org run offline during development  -- [ocaml.org#1366](https://github.com/ocaml/ocaml.org/pull/1366)
  - OCaml Changelog is no longer experimental  -- [ocaml.org#1369](https://github.com/ocaml/ocaml.org/pull/1369)
  - Resolved OCaml Changelog tags' overflow issue  -- [ocaml.org#1358](https://github.com/ocaml/ocaml.org/pull/1358)
  - Fixed unreadable components due to tailwind configuration changes  -- [ocaml.org#1375](https://github.com/ocaml/ocaml.org/pull/1375), [ocaml.org#1377](https://github.com/ocaml/ocaml.org/pull/1377), [ocaml.org#1428](https://github.com/ocaml/ocaml.org/pull/1428)
  - Dark mode navigation's logo color was corrected for mobile view  -- [ocaml.org#1385](https://github.com/ocaml/ocaml.org/pull/1385)
  - Applied `odoc`'s styles to package documentation pages  -- [ocaml.org#1378](https://github.com/ocaml/ocaml.org/pull/1378)
  - Improved CONTRIBUTING.md instructions  -- [ocaml.org#1365](https://github.com/ocaml/ocaml.org/pull/1365)
  - Added a Be Sport social network success story  -- [ocaml.org#1362](https://github.com/ocaml/ocaml.org/pull/1362)
  - Published "Invitation to Contribute to OCaml.org" news entry  -- [ocaml.org#1363](https://github.com/ocaml/ocaml.org/pull/1363)
  - URLs in the `data/` folder are now routinely checked by `tarides/olinkcheck`.

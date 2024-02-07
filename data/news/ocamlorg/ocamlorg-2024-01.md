---
title: "OCaml.org Newsletter: January 2024"
description: Monthly update from the OCaml.org team.
date: "2024-02-07"
tags: [ocamlorg]
---

Welcome to the January 2024 edition of the OCaml.org newsletter! This update has been compiled by the OCaml.org team. You can find [previous updates](https://discuss.ocaml.org/tag/ocamlorg-newsletter) on Discuss.

Our goal is to make OCaml.org the best resource for anyone who wants to get started and be productive in OCaml. The OCaml.org newsletter provides an update on our progress towards that goal and an overview of the changes we are working on.

We couldn't do it without all the amazing OCaml community members who help us review, revise, and create better OCaml documentation. Your feedback enables us to better prioritise our work. Thank you!

This newsletter covers:
- **OCaml Documentation:** New documentation has been released, and existing documentation has been improved.
- **Dark Mode:** There's been good progress on implementing the upcoming dark mode.
- **General Improvements:** As usual, we also worked on general maintenance and improvements based on user feedback, so we're highlighting some of our work below.

## Open Issues for Contributors

We created many issues for external contributors. The majority of them are suitable for OCaml beginners, and we're happy to review and provide feedback on your pull requests!

You can find [open issues for contributors here](https://github.com/ocaml/ocaml.org/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22+no%3Aassignee)!

## OCaml Documentation

We released multiple new documents, most notably on Modules, Functors, Libraries with Dune, as well as a new tutorial on using the OCaml.org Playground. The documentation on Labelled Arguments, Sets, and Options has been improved.

To better understand how effective the new documentation is, we are running user tests (announced [on Discuss](https://discuss.ocaml.org/t/request-for-feedback-take-the-ocaml-org-learn-area-user-satisfaction-survey/13928) and [on Twitter/X](https://x.com/sabine/status/1752272173383717171?s=20)) to compare the old documentation content on v2.ocaml.org with the new documentation on ocaml.org. A sufficient number of newcomers to OCaml volunteered to help us with this. Thanks so much!

In addition, there is an open survey that asks you to rate the new documentation in relation to the old content: We would love to have your input on [this survey](https://forms.gle/b2BS5NEiFaUVScJTA), even if you only drop us some numeric ratings!

**Relevant PRs and Activities:**

- **In Progress:**
  - Maps
  - Higher Order Functions
- **In Review (internal):**
- **In Review (community):**
  - [File Manipulation](https://github.com/ocaml/ocaml.org/pull/1400) (see [Discuss Thread](https://discuss.ocaml.org/t/help-review-the-new-file-manipulation-tutorial-on-ocaml-org/12638))
  - [Polymorphic Variants](https://github.com/ocaml/ocaml.org/pull/1531) (see [Discuss Thread](https://discuss.ocaml.org/t/new-draft-tutorial-on-polymorphic-variants/13485))
- **Published:**
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
    - [Fix code example in Values & Functions tutorial](https://github.com/ocaml/ocaml.org/pull/1892) by [@cuihtlauac](https://github.com/cuihtlauac)
    - [Improve 'Managing Dependencies with opam'](https://github.com/ocaml/ocaml.org/pull/1886) by [@sabine](https://github.com/sabine)
    - [(doc) Mention `dune-release` opam package in "Publishing a Package"](https://github.com/ocaml/ocaml.org/pull/1883) by [@sabine](https://github.com/sabine)
    - [Add how to generate `odoc` `.mld` documentation pages with Dune to the "Generating Documentation With `odoc`"](https://github.com/ocaml/ocaml.org/pull/1882) by [@sabine](https://github.com/sabine)
    - [Prepend `opam exec --` on all `dune` commands](https://github.com/ocaml/ocaml.org/pull/1905) by [@sabine](https://github.com/sabine)
    - [Mention record update syntax](https://github.com/ocaml/ocaml.org/pull/1909) by [@srj31](https://github.com/srj31)
    - [Fix Getting Started documentation](https://github.com/ocaml/ocaml.org/pull/1914) by [@akindofyoga](https://github.com/akindofyoga)
    - [Fix wording on Getting Started page](https://github.com/ocaml/ocaml.org/pull/1920) by [@akindofyoga](https://github.com/akindofyoga)
    - [Fix typos in Your First OCaml Program tutorial](https://github.com/ocaml/ocaml.org/pull/1924) by [@cuihtlauac](https://github.com/cuihtlauac)
    - [(doc) Fix small typo on Getting Started page](https://github.com/ocaml/ocaml.org/pull/1926) by [@akindofyoga](https://github.com/akindofyoga)
    - [Remove links to V2 in docs](https://github.com/ocaml/ocaml.org/pull/1925) by [@cuihtlauac](https://github.com/cuihtlauac)
    - [(doc) Some misc minor doc nits ](https://github.com/ocaml/ocaml.org/pull/1941) by [@heathhenley](https://github.com/heathhenley)
     - [Code test for Set V2 Tutorial](https://github.com/ocaml/ocaml.org/pull/1948) by [@christinerose](https://github.com/christinerose)
     - [(doc) Remove Functional Programming document](https://github.com/ocaml/ocaml.org/pull/1940) by [@sabine](https://github.com/sabine)
     - [(doc) Remove Unfold an Option section](https://github.com/ocaml/ocaml.org/pull/1954) by [@cuihtlauac](https://github.com/cuihtlauac)
     - [(doc) Minor line editing for Labelled Arguments](https://github.com/ocaml/ocaml.org/pull/1947) by [@christinerose](https://github.com/christinerose)
     - Issue [Use "parameter" and "argument" appropriately](https://github.com/ocaml/ocaml.org/issues/1911) has been resolved by multiple PRs from [@PoorlyDefinedBehaviour](https://github.com/PoorlyDefinedBehaviour)
    - [Fix link in 'Other installation methods' collapsible](https://github.com/ocaml/ocaml.org/pull/1958) by [@norskeld](https://github.com/norskeld)
    - [(doc) Updated "Operators," adding a link to the operator table in the language manual](https://github.com/ocaml/ocaml.org/pull/1960) by [@cuihtlauac](https://github.com/cuihtlauac)
    - [Use a filename different from the library name in Your First OCaml Program](https://github.com/ocaml/ocaml.org/pull/1923) by [@cuihtlauac](https://github.com/cuihtlauac)
    - [Mention labelled parameters in A Tour of OCaml](https://github.com/ocaml/ocaml.org/pull/1951) by [@PoorlyDefinedBehaviour](https://github.com/PoorlyDefinedBehaviour)
    - [Mention labelled parameters in Values and Functions](https://github.com/ocaml/ocaml.org/pull/1952) by [@PoorlyDefinedBehaviour](https://github.com/PoorlyDefinedBehaviour)
    - [(doc) add more info about multiple files](https://github.com/ocaml/ocaml.org/pull/1942) by [@heathhenley](https://github.com/heathhenley)
    - [Include text on if-then-else and begin-end](https://github.com/ocaml/ocaml.org/pull/1957) by [@cuihtlauac](https://github.com/cuihtlauac)
    - [Fix a typo in programming guidelines](https://github.com/ocaml/ocaml.org/pull/1998) by [@presenthee](https://github.com/presenthee)
    - [Fixing #1979 Link on privacy policy page 404](https://github.com/ocaml/ocaml.org/pull/1996) by [@The-Amoghavarsha](https://github.com/The-Amoghavarsha)
    - [Fix typo in the tutorial on optional params](https://github.com/ocaml/ocaml.org/pull/2002) by [@julbinb](https://github.com/julbinb)
    - [(typo) Add missing space on packages page](https://github.com/ocaml/ocaml.org/pull/2003) by [@sabine](https://github.com/sabine) 
    - [Improve documentation on Editor Support](https://github.com/ocaml/ocaml.org/pull/1949) by [@PizieDust](https://github.com/PizieDust)

We started opening issues marked with "help wanted" to enable external contributors to help improve the docs. The response has been overwhelmingly positive, and we're thrilled to keep this up and make the OCaml documentation truly great with your help!


## Upcoming Dark Mode

In December, [oyenuga17](https://github.com/oyenuga17) started to implement the new dark mode on OCaml.org. Plans are to complete and activate the dark mode based on browser/operating system preferences by early March. It looks like we are on track to achieve this.

We continuously merge small patches into OCaml.org, and you can take a look at completed dark mode pages on https://staging.ocaml.org. We placed a button at the bottom of the page to toggle the dark mode on staging. (This is not going to be released. It is only a means for us to review the dark mode pages.)

**Completed Pages:**
- [Learn/Get Started + Language + Guides](https://github.com/ocaml/ocaml.org/pull/1897) by [@oyenuga17](https://github.com/oyenuga17)
- [Learn/Excercises](https://github.com/ocaml/ocaml.org/pull/1902) by [@oyenuga17](https://github.com/oyenuga17)
- [Learn/Books](https://github.com/ocaml/ocaml.org/pull/1903) by [@oyenuga17](https://github.com/oyenuga17)
- [Learn/Platform Tools](https://github.com/ocaml/ocaml.org/pull/1919) by [@oyenuga17](https://github.com/oyenuga17)
- [Packages Search Results](https://github.com/ocaml/ocaml.org/pull/1946) by [@oyenuga17](https://github.com/oyenuga17)
- [Packages + Community](https://github.com/ocaml/ocaml.org/pull/1973) by [@oyenuga17](https://github.com/oyenuga17)
- [Blog + Jobs + Changelog](https://github.com/ocaml/ocaml.org/pull/2001) by [@oyenuga17](https://github.com/oyenuga17)
- [Learn/Overview](https://github.com/ocaml/ocaml.org/pull/1836) by [@oyenuga17](https://github.com/oyenuga17)

## General Improvements

**Most Notable Changes TLDR**:
- We merged a basic documentation search feature to enable search inside the OCaml documentation. It is available on the [Learn area "Overview" page](https://ocaml.org/docs)! There's room for improvements here, the most notable of which would be adding typo correction, and unifying package and documentation search in the top navigation bar's search box.
- A long-standing bug where wrong library names were displayed in the package documentation module tree view has been fixed!
- The package overview page now links to a new page that lists all package versions with their publication dates.
- The changelog is now reachable from the main landing page.
- We now link the prerequisites of tutorials and recommended next tutorials in the YAML metadata of the tutorial's Markdown page. This ensures that these links between tutorials will stay valid.

Many thanks go out to the many contributors who helped improve OCaml.org in January. Find them listed below!

**Relevant PRs and Activities:**
- General:
    - [Documentation Search Feature](https://github.com/ocaml/ocaml.org/pull/1871) by [@SaySayo](https://github.com/SaySayo) and [@sabine](https://github.com/sabine)
    - [(feat) add recommended_next_tutorials capability](https://github.com/ocaml/ocaml.org/pull/1928) by [@enoonan](https://github.com/enoonan)
    - [Add precompile check for Recommended Next Tutorials](https://github.com/ocaml/ocaml.org/pull/1943) by [@enoonan](https://github.com/enoonan)
    - [(feat) add prerequisite_tutorials capability](https://github.com/ocaml/ocaml.org/pull/1965) by [@PoorlyDefinedBehaviour](https://github.com/PoorlyDefinedBehaviour)
    - [Add Package Versions Page](https://github.com/ocaml/ocaml.org/pull/1799) by [@sabine](https://github.com/sabine)
    - [Make changelog reachable from the landing page](https://github.com/ocaml/ocaml.org/pull/1870) by [@FatumaA](https://github.com/FatumaA)
    - [Fixing #1989 Misaligned select drop down on jobs page](https://github.com/ocaml/ocaml.org/pull/1994) by [@The-Amoghavarsha](https://github.com/The-Amoghavarsha)
    - [Implement active state on exercise sidebar](https://github.com/ocaml/ocaml.org/pull/2000) by [@oyenuga17](https://github.com/oyenuga17)
    - [Update `Utils.human_date` to use the newer Timedesc API](https://github.com/ocaml/ocaml.org/pull/2009) by [@darrenldl](https://github.com/darrenldl)
    - [Fix language manual banner HTML](https://github.com/ocaml/ocaml.org/pull/1922) by [@sabine](https://github.com/sabine)
    - [In case `docs-data.ocaml.org` is unreachable, fail more gracefully](https://github.com/ocaml/ocaml.org/pull/1939) by [@sabine](https://github.com/sabine)
    - [(bug) Fix String.sub exception if changelog length < 100](https://github.com/ocaml/ocaml.org/pull/1956) by [@sabine](https://github.com/sabine)
    - [Gitignore *:OECustomProperty](https://github.com/ocaml/ocaml.org/pull/1937) by [@sabine](https://github.com/sabine)
    - [Remove The OCaml System from home](https://github.com/ocaml/ocaml.org/pull/1982) by [@cuihtlauac](https://github.com/cuihtlauac)
    - [Simplify typing of recommended next tutorials](https://github.com/ocaml/ocaml.org/pull/1967) by [@cuihtlauac](https://github.com/cuihtlauac)
- Package documentation:
    - [The `docs-ci` pipeline no longer pins `odoc`, allowing Voodoo to take control of its dependencies for better separation of concerns.](https://github.com/ocurrent/ocaml-docs-ci/pull/169) by [@sabine](https://github.com/sabine)
    - [Refactor: Improve naming of different index modules](https://github.com/ocaml-doc/voodoo/pull/138) by [@sabine](https://github.com/sabine)
    - [Bugfix: Read Library Names from Packages Correctly](https://github.com/ocaml-doc/voodoo/pull/136) by [@sabine](https://github.com/sabine)
    - [Bugfix: Move H1 Title Rendering to the Correct Location](https://github.com/ocaml-doc/voodoo/pull/137) by [@sabine](https://github.com/sabine) 
- Data parsing (`ood-gen`):
    - [Report file name on YAML error](https://github.com/ocaml/ocaml.org/pull/1974) by [@cuihtlauac](https://github.com/cuihtlauac)
    - [Changelog: infer date from slug if not in metadata](https://github.com/ocaml/ocaml.org/pull/1984) by [@emillon](https://github.com/emillon) 
    - [`ood-gen`: call crunch on each directory separately](https://github.com/ocaml/ocaml.org/pull/1987) by [@emillon](https://github.com/emillon) 
    - [Tutorial titles only as metadata](https://github.com/ocaml/ocaml.org/pull/1981) by [@PoorlyDefinedBehaviour](https://github.com/PoorlyDefinedBehaviour)
- Data:
    - [Add two individual blog post entries](https://github.com/ocaml/ocaml.org/pull/1980) by [@IdaraNabuk](https://github.com/IdaraNabuk)
    - [Changelog for Dune 3.13.0](https://github.com/ocaml/ocaml.org/pull/1976) by [@emillon](https://github.com/emillon)
    - [changelog: opam.2.2.0~beta1](https://github.com/ocaml/ocaml.org/pull/1986) by [@kit-ty-kate](https://github.com/kit-ty-kate)
    - [Add Laval University as an academic user of OCaml](https://github.com/ocaml/ocaml.org/pull/1904) by [@bktari](https://github.com/bktari)
    - [Add 2 XenServer jobs](https://github.com/ocaml/ocaml.org/pull/1898) by [@edwintorok](https://github.com/edwintorok)
    - [(data) Added `priver.dev` OCaml feed](https://github.com/ocaml/ocaml.org/pull/1961) by [@emilpriver](https://github.com/emilpriver)
    - [Add changelog for Dune 3.12.2](https://github.com/ocaml/ocaml.org/pull/1950) by [@emillon](https://github.com/emillon)
    - [Use Yaml dashes for lists](https://github.com/ocaml/ocaml.org/pull/1983) by [@cuihtlauac](https://github.com/cuihtlauac)
    - [Add missing Platform changelogs](https://github.com/ocaml/ocaml.org/pull/1991) by [@tmattio](https://github.com/tmattio)
- Repository docs:
    - [Fix broken links in CONTRIBUTING.md](https://github.com/ocaml/ocaml.org/pull/1908) by [@cuihtlauac](https://github.com/cuihtlauac)
    - [(doc) Mention in CONTRIBUTING.md how to add images](https://github.com/ocaml/ocaml.org/pull/1906) by [@sabine](https://github.com/sabine)

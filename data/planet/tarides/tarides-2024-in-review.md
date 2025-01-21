---
title: 'Tarides: 2024 in Review'
description: Tarides advanced OCaml in 2024 with the Dune Developer Preview, the first
  stable multicore release, 8x WebAssembly boosts, and expanded Windows support.
url: https://tarides.com/blog/2025-01-20-tarides-2024-in-review
date: 2025-01-20T00:00:00-00:00
preview_image: https://tarides.com/blog/images/review-1360w.webp
authors:
- Tarides
source:
---

<p>At <a href="https://tarides.com/">Tarides</a>, we believe in making OCaml a
mainstream programming language by improving its tooling and
integration with other successful ecosystems. In 2024, we focused our
efforts on initiatives to advance this vision by addressing key
technical challenges and engaging with the community to build a
stronger foundation for OCaml’s growth. This report details our work,
the rationale behind our choices, and the impact achieved. We are very
interested in getting your feedback: <a href="https://tarides.com/contact/">please get in
touch</a> (or respond to the
<a href="https://discuss.ocaml.org/t/tarides-2024-in-review/15990">Discuss thread</a>)
if you believe we are going in the right direction.</p>
<p><em>TL;DR – In 2024, Tarides focused on removing adoption friction with
better documentation and tools; and on improving adoption via the
integration with three key thriving ecosystems: multicore programming,
web development, and Windows support. Updates to
<a href="http://ocaml.org">ocaml.org</a> improved onboarding and documentation,
while the <a href="https://preview.dune.build/">Dune Developer Preview</a>
simplified workflows with integrated package management. Merlin added
support for <a href="https://tarides.com/blog/2024-08-28-project-wide-occurrences-a-new-navigation-feature-for-ocaml-5-2-users/">project-wide reference
support</a>
and <a href="https://discuss.ocaml.org/t/odoc-3-0-planning/14360">odoc 3</a>,
which is about to be released. OCaml 5.3 marked the first stable
multicore release, and <code>js_of_ocaml</code> achieved up to 8x performance
boosts in real-world commercial applications thanks to added support
for WebAssembly. On Windows, opam 2.2 brought full compatibility and
CI testing to all Tier 1 platforms on <code>opam-repository</code>, slowly moving
community packages towards reliable and better support for
Windows. Tarides’ community support included organising the first <a href="https://fun-ocaml.com/">FUN
OCaml conference</a>, many local meetups, and two
rounds of Outreachy internships.</em></p>
<h2>Better Tools: Toward a 1-Click Installation of OCaml</h2>
<p>Our primary effort in 2024 was to continue delivering on the <a href="https://ocaml.org/tools/platform-roadmap">OCaml
Platform roadmap</a> published
last year.  We focused on making it easier to get started with OCaml
by removing friction in the installation and onboarding process. Our
priorities were guided by the latest <a href="https://discuss.ocaml.org/t/ann-ocaml-user-survey-2023/13469">OCSF User
Survey</a>,
direct user interviews, and
<a href="https://discuss.ocaml.org/tag/user-feedback">feedback</a> gathered from
the OCaml community. Updates from Tarides and other OCaml Platform
maintainers were regularly shared in the <a href="https://discuss.ocaml.org/tag/platform-newsletter">OCaml Platform
Newsletter</a>.</p>
<h3>OCaml.org</h3>
<p>OCaml.org is the main entry point for new users of OCaml. Tarides
engineers are key members of the OCaml.org team. Using
<a href="https://plausible.ci.dev/ocaml.org">privacy-preserving analytics</a>,
the team tracked visitor behaviour to identify key areas for
improvement. This led to a redesign of the <a href="https://ocaml.org/install">installation
page</a>, simplifying the setup process, and a
revamp of the <a href="https://ocaml.org/docs/tour-of-ocaml">guided tour of
OCaml</a> to better introduce the
language. Both pages saw significant traffic increases compared to
2023, with the installation page recording 69k visits, the tour
reaching 65k visits and a very encouraging total number of visits
increasing by +33% between Q3 and Q4 2024</p>
<p><img src="https://tarides.com/blog/images/average-monthly-visits-1360w~QEQSqhe66fLVpZwWodcg1Q.webp" sizes="(min-width: 1360px) 1360px, (min-width: 680px) 680px, 100vw" srcset="/blog/images/average-monthly-visits-170w~rWkwpgfVt8kpp1wxcxjlSQ.webp 170w, /blog/images/average-monthly-visits-340w~vuPLxIzmE3UZnKWYuRVFpA.webp 340w, /blog/images/average-monthly-visits-680w~VZYDziJj9q4nYy-zZzJkRw.webp 680w, /blog/images/average-monthly-visits-1360w~QEQSqhe66fLVpZwWodcg1Q.webp 1360w" alt="Average Monthly Visits"></p>
<p>Efforts to improve user experience included a satisfaction survey
where 75% of respondents rated their experience positively, compared
to 17% for the previous version of the site. User testing sessions
with 21 participants provided further actionable insights, and these
findings informed updates to the platform. The redesign of OCaml.org
community sections was completed using this feedback. It introduced
several new features: a new <a href="https://ocaml.org/community">Community landing
page</a>, an <a href="https://ocaml.org/academic-users">academic institutions
page</a> with course listings, and an
<a href="https://ocaml.org/industrial-users">industrial users showcase</a>. The
team also implemented an automated <a href="https://ocaml.org/events">event
announcement</a> system to inform the community
of ongoing activities.</p>
<p>Progress and updates were regularly shared through the <a href="https://discuss.ocaml.org/tag/ocamlorg-newsletter">OCaml.org
newsletters</a>,
keeping the community informed about developments. Looking ahead, the
team will continue refining the platform by addressing feedback,
expanding resources, and monitoring impact through analytics to
support both new and experienced OCaml users. Lastly, the
infrastructure they build is starting to be used by other communities:
<a href="https://rocq-prover.org/">Rocq</a> just announced their brand new
website, built using the same codebase as ocaml.org!</p>
<h3>Dune as the Default Frontend of the OCaml Platform</h3>
<p>One of the main goals of the OCaml Platform is to make it easier for
users—especially newcomers—to adopt OCaml and build projects with
minimal friction. A critical step toward this goal is having a single
CLI to serve as the frontend for the entire OCaml development
experience (codenamed
<a href="https://speakerdeck.com/avsm/ocaml-platform-2017?slide=34">Bob</a> in
the past). This year, we made significant progress in that direction
with the release of the <a href="https://preview.dune.build/">Dune Developer
Preview</a>.</p>
<p>Setting up an OCaml project currently requires multiple tools: <code>opam</code>
for package management, <code>dune</code> for builds, and additional
installations for tools like OCamlFormat or Odoc. While powerful, this
fragmented workflow can make onboarding daunting for new users. The
Dune Developer Preview consolidates these steps under a single CLI,
making OCaml more approachable. With this preview, setting up and
building a project is as simple as:</p>
<ol>
<li><code>dune pkg lock</code> to lock the dependencies.</li>
<li><code>dune build</code> to fetch the dependencies and compile the project.</li>
</ol>
<p>This effort is also driving broader ecosystem improvements. The
current OCaml compiler relies on fixed installation paths, making it
difficult to cache and reuse across environments, so it cannot be
shared efficiently between projects. To address this, we are working
on making the compiler relocatable (<a href="https://hackmd.io/@dra27/ry56XtKii">ongoing
work</a>). This change will enable
compiler caching, which means faster project startup times and fewer
rebuilds in CI. As part of this effort, we also
<a href="https://github.com/ocaml-dune/opam-overlays/tree/main/packages">maintain</a>
patches to core OCaml projects to make them relocatable – and we
worked with upstream to merge (like <a href="https://github.com/ocaml/ocamlfind/pull/72">for
ocamlfind</a>). Tarides
engineers also continued to maintain Dune and other key Platform
projects, ensuring stability and progress. This included organising
and participating in regular development meetings (for
<a href="https://discuss.ocaml.org/tag/dev-meetings">Dune</a>,
<a href="https://github.com/ocaml/opam/wiki/2024-Developer-Meetings">opam</a>,
<a href="https://github.com/ocaml/merlin/wiki/Public-dev%E2%80%90meetings">Merlin</a>,
<a href="https://github.com/ocaml-ppx/ppxlib/wiki#dev-meetings">ppxlib</a>, etc.)
to prioritise community needs and align efforts across tools like Dune
and opam to avoid overlapping functionality.</p>
<p>The Dune Developer Preview is an iterative experiment. Early user
feedback has been promising (the Preview’s NPS went from +9 in Q3
2024 to +27 in Q4 2024), and future updates will refine the
experience further. We aim to ensure that experimental features in the
Preview are upstreamed into stable releases once thoroughly
tested. For instance, the package management feature is already in
Dune 3.17. We will announce and document it more widely when we believe
it is mature enough for broader adoption.</p>
<h3>Editors</h3>
<p>In 2024, Tarides focused on improving editor integration to lower
barriers for new OCaml developers and enhance the experience for
existing users. Editors are the primary way developers interact with
programming languages, making seamless integration essential for
adoption. With more than <a href="https://survey.stackoverflow.co/2024/technology#1-integrated-development-environment">73% of developers using Visual Studio Code
(VS
Code)</a>,
VS Code is particularly important to support, especially for new
developers and those transitioning to OCaml. As part of this effort,
Tarides wrote and maintained the <a href="https://marketplace.visualstudio.com/items?itemName=ocamllabs.ocaml-platform">official VS Code plugin for
OCaml,</a>
prioritising feature development for this editor. We also support
other popular editors like Emacs and Vim—used by many Tarides
engineers—on a best-effort basis. Improvements to
<a href="https://github.com/ocaml/ocaml-lsp">OCaml-LSP</a> and
<a href="https://github.com/ocaml/merlin">Merlin</a>, both maintained by Tarides,
benefit all supported editors, ensuring a consistent and productive
development experience.</p>
<p><img src="https://tarides.com/blog/images/total-vscode-plugin-installations-1360w~zl9hCa9ruBd7ugqHXK6h3Q.webp" sizes="(min-width: 1360px) 1360px, (min-width: 680px) 680px, 100vw" srcset="/blog/images/total-vscode-plugin-installations-170w~Gj2LhiFKGPb93gxsonkSmA.webp 170w, /blog/images/total-vscode-plugin-installations-340w~2yRY5sTJFJ4_cqCg8xzuEg.webp 340w, /blog/images/total-vscode-plugin-installations-680w~z3ZaCVsrZgVBhLjuYefEKA.webp 680w, /blog/images/total-vscode-plugin-installations-1360w~zl9hCa9ruBd7ugqHXK6h3Q.webp 1360w" alt="Total VSCode Plugin Installation"></p>
<p>While several plugins for OCaml exist (<a href="https://marketplace.visualstudio.com/items?itemName=freebroccolo.reasonml">OCaml and Reason
IDE</a>–128k
installs,
<a href="https://marketplace.visualstudio.com/items?itemName=hackwaly.ocaml">Hackwaly</a>–90k
installs), our <a href="https://marketplace.visualstudio.com/items?itemName=ocamllabs.ocaml-platform">OCaml VS Code
plugin</a>
–now with over 208k downloads– is a key entry point for developers
adopting OCaml in 2024. This year, we added integration with the Dune
Developer Preview, allowing users to leverage Dune's package
management and tooling directly from the editor. Features such as
real-time diagnostics, autocompletion, and the ability to fetch
dependencies and build projects without leaving VS Code simplify
development and make OCaml more accessible for newcomers.</p>
<p>The standout update in 2024 was the addition of <a href="https://tarides.com/blog/2024-08-28-project-wide-occurrences-a-new-navigation-feature-for-ocaml-5-2-users/">project-wide
reference
support</a>,
a long-requested feature from the OCaml community and a top priority
for commercial developers. This feature allows users to locate all
occurrences of a term across an entire codebase, making navigation and
refactoring significantly easier—especially in large
projects. Delivering this feature required coordinated updates across
the ecosystem, including changes to the OCaml compiler, Merlin, OCaml
LSP, Dune, and related tools. The impact is clear: faster navigation,
reduced cognitive overhead, and more efficient workflows when working
with complex projects.</p>
<p>Additional improvements included support for new Language Server
Protocol features, such as <code>signature_help</code> and <code>inlay_hint</code>, which
enhance code readability and provide more contextual
information. These updates enabled the introduction of new commands,
such as the "Destruct" command. This <a href="https://tarides.com/blog/2024-05-29-effective-ml-through-merlin-s-destruct-command/">little-known but powerful
feature</a>
automatically expands a variable into a pattern-matching expression
corresponding to its inferred type, streamlining tasks that would
otherwise be tedious.</p>
<p align="center">
<img src="https://tarides.com/blog/images/2024-05-21.merlin-destruct/merlin-destruct-1~kHA8_iC67tU-2us0hsjbhQ.gif" alt="Destruct on expression">
</p>
<h3>Documentation</h3>
<p>Documentation was identified as the number one pain point in the
latest <a href="https://discuss.ocaml.org/t/ann-ocaml-user-survey-2023/13469">OCSF
survey</a>. It
is a critical step in the OCaml developer journey, particularly after
setting up the language and editor. Tarides prioritised improving
<code>odoc</code> to make it easier for developers to find information, learn the
language, and navigate the ecosystem effectively. High-quality
documentation and tools to help developers get "unstuck" are essential
to reducing friction and ensuring a smooth adoption experience.</p>
<p>Tarides is the primary contributor and maintainer of
<a href="https://github.com/ocaml/odoc"><code>odoc</code></a>, OCaml’s main documentation
tool. In preparation for the <a href="https://discuss.ocaml.org/t/odoc-3-0-planning/14360">odoc 3
release</a>, our
team introduced two significant updates. First, the <a href="https://tarides.com/blog/2024-02-28-two-major-improvements-in-odoc-introducing-search-engine-integration/"><code>odoc</code> Search
Engine</a>
was integrated, allowing developers to search directly within OCaml
documentation via the <a href="https://ocaml.org/docs">Learn page</a>. Second,
the <a href="https://tarides.com/blog/2024-09-17-introducing-the-odoc-cheatsheet-your-handy-guide-to-ocaml-documentation/"><code>odoc</code>
Cheatsheet</a>
provides a concise reference for creating and consuming OCaml
documentation. We would like to believe that these updates, deployed
on ocaml.org, were the main cause of a <strong>45% increase in package
documentation usage</strong> on
<a href="https://ocaml.org/pkg/">https://ocaml.org/pkg/</a> in Q4 2024!</p>
<p><img src="https://tarides.com/blog/images/discussions-and-documentation-1360w~VS_UyGh1l5BVh7iKz3avZw.webp" sizes="(min-width: 1360px) 1360px, (min-width: 680px) 680px, 100vw" srcset="/blog/images/discussions-and-documentation-170w~tuRRmxDfTszCAQgbxrGAEQ.webp 170w, /blog/images/discussions-and-documentation-340w~61eG6BHNSEW-LQKNrjrA1w.webp 340w, /blog/images/discussions-and-documentation-680w~CnFo9MN0V1JT_kcPKd9DEQ.webp 680w, /blog/images/discussions-and-documentation-1360w~VS_UyGh1l5BVh7iKz3avZw.webp 1360w" alt="Discussions and Documentations"></p>
<p>Another area where developers often get stuck is debugging programs
that don’t work as expected. Alongside reading documentation, live
debuggers are crucial for understanding program issues. Tarides worked
to improve native debugging for OCaml, focusing on macOS, where LLDB
is the only supported debugger. Key progress included a <a href="https://github.com/ocaml/ocull/pull/13050">name mangling
fix</a> to improve symbol
resolution, restoring ARM64 backtraces, and introducing Python shims
for code sharing between LLDB and GDB.</p>
<p>OCaml’s error messages remain a common pain point, particularly for
syntax errors. Unlike <a href="https://doc.rust-lang.org/error_codes/error-index.html">Rust’s error
index</a>, OCaml
does not (yet!) have a centralised repository of error
explanations. Instead, we are focused on making error messages more
self-explanatory. This requires developing new tools, such as
<a href="https://github.com/let-def/lrgrep"><code>lrgrep</code></a>, a domain-specific
language for analysing grammars built with Menhir. <code>lrgrep</code> enables
concise definitions of error cases, making it possible to identify and
address specific patterns in the parser more effectively. This
provides a practical way to improve error messages without requiring
changes to the compiler. In December 2024, @let-def successfully
defended his PhD (a collaboration between Inria and Tarides) on this
topic, so expect upstreaming work to start soon.</p>
<h3>OCaml Package Ecosystem</h3>
<p>The last piece of friction we aimed to remove in 2024 was ensuring
that users wouldn’t encounter errors when installing a package from
the community. This required catching issues early—before packages are
accepted into <code>opam-repository</code> and made available to the broader
ecosystem. To achieve this, Tarides has built and maintained extensive
CI infrastructure, developed tools to empower contributors, and guided
package authors to uphold the high quality of the OCaml package
ecosystem.</p>
<p>In 2024, Tarides’ CI infrastructure supported the OCaml community at
scale, handling approximately <strong>20 million jobs on 68 machines
covering 5 hardware architectures</strong>. This infrastructure continuously
tested packages to ensure compatibility across a variety of platforms
and configurations, including OCaml’s Tier 1 platforms: x86, ARM,
RISC-V, s390x, and Power. It played a critical role during major
events, such as new OCaml releases, by validating the ecosystem’s
readiness and catching regressions before they impacted
users. Additionally, this infrastructure supported daily submissions
to <code>opam-repository</code>, enabling contributors to identify and resolve
issues early, reducing downstream problems. To improve transparency
and accessibility, we introduced a CI pipeline that automates
configuration updates, ensuring seamless deployments and allowing
external contributors to propose and apply changes independently.</p>
<p>In addition to maintaining the infrastructure, Tarides developed and
maintained the CI framework running on top of it. A major focus in
2024 was making CI checks available as standalone CLI tools
distributed via <code>opam</code>. These tools enable package authors to run
checks locally, empowering them to catch issues before submitting
their packages to <code>opam-repository</code>. This approach reduces reliance on
central infrastructure and allows developers to work more
efficiently. The CLI tools are also compatible with GitHub Actions,
allowing contributors to integrate tests into their own workflows. To
complement these efforts, we enhanced <code>opam-repo-ci</code>, which remains an
essential safety net for packages entering the repository. Integration
tests for linting and reverse dependencies were introduced, enabling
more robust regression detection and improving the reliability of the
ecosystem.</p>
<p>To uphold the high standards of the OCaml ecosystem, every package
submission to <code>opam-repository</code> is reviewed and validated to ensure it
meets quality criteria. This gatekeeping process minimises errors
users might encounter when installing community packages, enhancing
trust in the ecosystem. In 2024, Tarides continued to be actively
<a href="https://github.com/ocaml/opam-repository/blob/master/governance/README.md#maintenance">involved</a>
in maintaining the repository, ensuring its smooth operation. We also
worked to guide new package authors by updating the <a href="https://github.com/ocaml/opam-repository/blob/master/CONTRIBUTING.md">contributing
guide</a>
and creating a detailed
<a href="https://github.com/ocaml/opam-repository/wiki">wiki</a> with actionable
instructions for adding and maintaining packages. These resources were
<a href="https://discuss.ocaml.org/t/opam-repository-updated-documentation-retirement-and-call-for-maintainers/14325">announced on
Discuss</a>
to reach the community and simplify the process for new contributors,
improving the overall quality of submissions.</p>
<h2>Playing Better with the Larger Ecosystem</h2>
<h3>Concurrent &amp; Parallel Programming in OCaml</h3>
<div class="text-center text-sm">
<em>"Shared-memory multiprocessors have never really 'taken off', at
least in the general public. For large parallel computations, clusters
(distributed-memory systems) are the norm. For desktop use,
monoprocessors are plenty fast."</em></div>
<div class="text-right text-xs mt-2">
  —
<a href="https://sympa.inria.fr/sympa/arc/caml-list/2002-11/msg00274.html">
    Xavier Leroy, November 2002
</a></div>
<p>Twenty+ years after this statement, processors are multicore by
default, and OCaml has adapted to this reality. Thanks to the combined
efforts of the OCaml Labs and Tarides team, the OCaml 5.x series
introduced multicore support after <a href="https://tarides.com/blog/2023-03-02-the-journey-to-ocaml-multicore-bringing-big-ideas-to-life/">a decade of research and
experimentation.</a>
While this was a landmark achievement, the path to making multicore
OCaml stable, performant, and user-friendly has required significant
collaboration and continued work. In 2024, Tarides remained focused on
meeting the needs of the broader community and commercial users.</p>
<p>OCaml 5.3 (released last week) was an important milestone in this
journey. With companies such as <a href="https://routine.co/">Routine</a>,
<a href="https://hyper.systems">Hyper</a>, and
<a href="https://tarides.com/blog/2024-09-19-eio-from-a-user-s-perspective-an-interview-with-simon-grondin/">Asemio</a>
adopting OCaml 5.x, and advanced experimentation ongoing at Jane
Street, Tezos, Semgrep, and others, OCaml 5.3 is increasingly seen as
the first “stable” release of the multicore series. While some
<a href="https://github.com/ocaml/ocaml/issues/13733">performance issues</a>
remain in specific parts of the runtime, we are working closely with
the community to address them in OCaml 5.4. Tarides contributed
extensively to the
<a href="https://tarides.com/blog/2024-05-15-the-ocaml-5-2-release-features-and-fixes/">5.2</a>
and
<a href="https://tarides.com/blog/2025-01-09-ocaml-5-3-features-and-fixes/">5.3</a>
releases by directly contributing to <strong>nearly two-thirds of the merged
pull requests</strong>. Since Multicore OCaml was incorporated upstream in
2023, we have been continuously involved in the compiler and language
evolution in collaboration with Inria and the broader OCaml ecosystem.</p>
<p>Developing correct concurrent and parallel software is inherently
challenging, and this applies as much to the runtime as to
applications built on it. In 2024, we focused on advanced testing
tools to help identify and address subtle issues in OCaml’s runtime
and libraries. The <a href="https://github.com/ocaml-multicore/multicoretests">property-based test
suite</a> reached
maturity this year, uncovering over 40 critical issues, with 28
resolved by Tarides engineers. Trusted to detect subtle bugs, such as
<a href="https://github.com/ocaml/ocaml/pull/13580#issuecomment-2478454501">issues with orphaned
ephemerons</a>,
the suite has become an integral part of OCaml’s development
workflow. Importantly, it is accessible to contributors without deep
expertise in multicore programming, ensuring any changes in the
compiler or the runtime do not introduce subtle concurrency bugs.</p>
<p><img src="https://tarides.com/blog/images/false-alarms-plot-errors-only-1360w~wOpCubYg66VDTbHXaZMcZw.webp" sizes="(min-width: 1360px) 1360px, (min-width: 680px) 680px, 100vw" srcset="/blog/images/false-alarms-plot-errors-only-170w~5YZPBXgUoTrAIc0KQle6iw.webp 170w, /blog/images/false-alarms-plot-errors-only-340w~5HTdqWao21Ru8BWhPQSXJA.webp 340w, /blog/images/false-alarms-plot-errors-only-680w~ulyPw_CnsHR2OYtym2eM_A.webp 680w, /blog/images/false-alarms-plot-errors-only-1360w~wOpCubYg66VDTbHXaZMcZw.webp 1360w" alt="A stacked histogram illustrating the outcome of CI workflow runs split, focusing only on the 'ci', 'genuine', and 'other' error categories"></p>
<p>Another critical effort was extending ThreadSanitizer (TSAN) support
to most Tier 1 platforms and <a href="https://tarides.com/blog/2024-08-21-how-tsan-makes-ocaml-better-data-races-caught-and-fixed/">applying it extensively to find and fix
data races in the
runtime</a>. This
work has improved the safety and reliability of OCaml’s multicore
features and is now part of the standard testing process, further
ensuring the robustness of the runtime.</p>
<p>Beyond testing, we also worked to enhance library support for
multicore programming. The release of the <a href="https://tarides.com/blog/2024-12-11-saturn-1-0-data-structures-for-ocaml-multicore/">Saturn
library</a>
introduced lock-free data structures tailored for OCaml 5.x. To
validate these structures, we developed
<a href="https://tarides.com/blog/2024-04-10-multicore-testing-tools-dscheck-pt-2/">DSCheck</a>,
a static analyser for verifying lock-free algorithms. These tools,
along with Saturn itself, provide developers with reliable building
blocks for scalable multicore applications.</p>
<p>Another promising development in 2024 was the introduction of the
<a href="https://ocaml-multicore.github.io/picos/doc/picos/index.html">Picos</a>
framework. Picos aims to provide a low-level foundation for
concurrency, simplifying interoperability between libraries like Eio,
Moonpool, Miou, Riot, Affect, etc. Picos offers a simple,
unopinionated, and safe abstraction layer for concurrency. We believe
it can potentially standardise concurrency patterns in OCaml, but we
are not there yet. Discussions are underway to integrate parts of
Picos into higher-level libraries and, eventually, the standard
library. We still have a long way to go, and getting feedback from
people who actively tried it in production settings would be very
helpful!</p>
<h3>Web</h3>
<p>Web development remains one of the most visible and impactful domains
for programming languages; <a href="https://survey.stackoverflow.co/2024/technology#most-popular-technologies-language">JavaScript, HTML, and CSS are the most
popular
technologies</a>
in 2024. For OCaml to grow, it must integrate well with this
ecosystem. Fortunately, the OCaml community has already built a solid
foundation for web development!</p>
<p>On the frontend side, in 2024, Tarides focused on strengthening key
tools like <a href="https://github.com/ocsigen/js_of_ocaml"><code>js_of_ocaml</code></a>
by expanding its support for WebAssembly
(Wasm). <code>js_of_ocaml</code> (JSOO) has long been the backbone of OCaml’s web
ecosystem, enabling developers to compile OCaml bytecode into
JavaScript. This year, we <a href="https://github.com/ocsigen/js_of_ocaml/pull/1494">merged Wasm support back into
JSOO</a>, unifying the
toolchain and simplifying adoption for developers. The performance
gain of Wasm has been very impressive so far: CPU-intensive
applications in commercial settings have seen <strong>2x to 8x speedups</strong>
using Wasm compared to traditional JSOO. We also worked on better
support for effect handlers in <code>js_of_ocaml</code> to ensure applications
built with OCaml 5 can run as fast in the browser as they used to with
OCaml 4.</p>
<p>On the backend side, Tarides maintained and contributed to Dream, a
lightweight and flexible web framework. Dream powers projects like
<a href="https://tarides.com/">our own website</a> and the
<a href="https://mirageos.org">MirageOS website</a>, where we maintain a fork to make
Dream and MirageOS work well together. Additionally, in 2024, we
enhanced <code>cohttp</code>, adding <a href="https://github.com/mirage/ocaml-cohttp/pull/847">proxy
support</a> to address
modern HTTP requirements.</p>
<p>While Tarides focused on JSOO, <code>wasm_of_ocaml</code>, Dream, and Cohttp, the
broader community made significant strides elsewhere. Tools like
Melange offer an alternative for compiling OCaml to JavaScript, and
frameworks like Ocsigen, which integrates backend and frontend
programming, continue to push the boundaries of what’s possible with
OCaml on the web. Notably, Tarides will build on this momentum in 2025
through a <a href="https://nlnet.nl/project/OCAML-directstyle/">grant</a> to
improve direct-style programming for Ocsigen.</p>
<h3>Windows</h3>
<p>Windows is the most widely used operating system, making first-class
support for it critical to OCaml’s growth. In 2024, <strong>31% of visitors
to <a href="https://ocaml.org">ocaml.org</a></strong> accessed the site from Windows,
yet the platform’s support historically lagged behind Linux and
macOS. This gap created barriers for both newcomers and commercial
users. We saw these challenges firsthand, with Outreachy interns
struggling to get started due to tooling issues, and commercial users
reporting difficulties with workflow reliability and compilation
speed.</p>
<p>To address these pain points, Tarides, in collaboration with the OCaml
community, launched the <a href="https://tarides.com/blog/2024-05-22-launching-the-first-class-windows-project/">Windows Working
Group</a>. A
key milestone that our team contributed to was the release this year
of <strong>opam 2.2</strong>, three years after its predecessor. This release made
the upstream <code>opam-repository</code> fully compatible with Windows for the
first time, removing the need for a separate repository and providing
Windows developers access to the same ecosystem as Linux and macOS
users. The impact has been clear: feedback on the updated installation
workflow has been overwhelmingly positive, with developers reporting
that it "just works." The <a href="https://ocaml.org/install">install page</a>
for Windows is now significantly shorter and simpler!</p>
<p>In the OCaml 5.3 release, Tarides restored the MSVC Windows port,
ensuring native compatibility and improving performance for Windows
users. To further support the ecosystem, Tarides added Windows
machines to the opam infrastructure, enabling automated testing for
Windows compatibility on every new package submitted to opam. This has
already started to improve package support, with ongoing fixes from
Tarides and the community. The results are publicly visible at
<a href="https://windows.check.ci.dev/">windows.check.ci.dev</a>, which we run on
our infrastructure, providing transparency and a way to track progress
on the status of our ecosystem. While package support is not yet on
par with other platforms, we believe that the foundations laid in
2024—simplified installation, improved tooling, and continuous package
testing—represent a significant step forward.</p>
<h2>Community Engagement and Outreach</h2>
<p>In 2024, Tarides contributed to building a stronger OCaml community
through events, internships, and support for foundational
projects. The creation of <a href="https://fun-ocaml.com/">FUN OCaml 2024</a> in
Berlin was the first dedicated OCaml-only event for a long time
(similar to how the OCaml Workshop was separated from ICFP in the
past). Over 75 participants joined for two days of talks, workshops,
and hacking, and the event has already reached <a href="https://www.youtube.com/channel/UC3TI-fmhJ_g3_n9fHaXGZKA">5k+ views on
YouTube</a>. Tarides
also co-chaired the OCaml Workshop at <a href="https://icfp24.sigplan.org/">ICFP
2024</a> in Milan, bringing together
contributors from academia, industry, and open-source
communities. These events brought together two different kinds of
OCaml developers (with some overlap), bringing an interesting energy
to our community.</p>
<p>To expand local community involvement, Tarides organised OCaml hacking
meetups in
<a href="https://discuss.ocaml.org/t/announcing-ocaml-manila-meetups/14300">Manila</a>
and
<a href="https://discuss.ocaml.org/t/chennai-ocaml-meetup-october-2024/15417">Chennai</a>. To
make it easier for others to host similar events, we curated a list of
interesting hacking issues from past <a href="https://tarides.com/blog/2023-03-22-compiler-hacking-in-cambridge-is-back/">Cambridge
sessions</a>,
now available on
<a href="https://github.com/tarides/compiler-hacking/wiki">GitHub</a>.</p>
<p>As part of the Outreachy program, Tarides supported two rounds of
internships in 2024, with results published on
<a href="https://discuss.ocaml.org/tag/outreachy">Discuss</a> and
<a href="https://watch.ocaml.org">watch.ocaml.org</a>. These internships not only
provided great contributions to our ecosystem but also brought fresh
insights into the challenges faced by new users. For example, interns
identified key areas where documentation and tooling could be
improved, directly informing future updates.</p>
<p>Tarides also maintained its commitment to funding critical open-source
projects and maintainers. We continued funding
<a href="https://blog.robur.coop/articles/finances.html">Robur</a> for their
maintenance work on MirageOS (most of those libraries are used by many
–including us– even in non-MirageOS context) and <a href="https://github.com/sponsors/dbuenzli">Daniel
Bünzli</a>, whose libraries like
<code>cmdliner</code> are essential for some of our development.</p>
<p>Finally, Tarides extended sponsorships to non-OCaml-specific events,
including <a href="https://jfla.inria.fr/jfla2024.html">JFLA</a>,
<a href="https://bobkonf.de/2025/en/">BobConf</a>,
<a href="https://www.fsttcs.org.in/">FSTTCS</a>, and <a href="https://www.youtube.com/watch?v=fMy0XhFdLAE">Terminal
Feud</a> (which garnered
over 100k views). These events expanded OCaml’s visibility to new
audiences and contexts, introducing the language to a broader
technical community that –we hope– will discover OCaml and enjoy using
it as much as we do.</p>
<h2>What’s Next?</h2>
<p>As we begin 2025, Tarides remains committed to making OCaml a
mainstream language. Our focus this year is to position OCaml as a
robust choice for mission-critical applications by enhancing developer
experience, ecosystem integration, and readiness for high-assurance
use cases.</p>
<p>We aim to build on the Dune Developer Preview to further improve
usability across all platforms, with a particular emphasis on Windows,
to make OCaml more accessible to a broader range of
developers. Simultaneously, we will ensure OCaml is ready for critical
applications in industries where reliability, performance, and
security are essential. Projects like
<a href="https://tarides.com/blog/2023-07-31-ocaml-in-space-welcome-spaceos/">SpaceOS</a>
showcase the potential of memory- and type-safe languages for
safety-critical systems. Built on MirageOS and OCaml’s
unique properties, SpaceOS is part of the EU-funded
<a href="https://orchide.pages.upb.ro/">Orchide</a> project and aims to set a new
standard for edge computing in space. Additionally, SpaceOS is being
launched in the US through our spin-off
<a href="https://parsimoni.co">Parsimoni</a>. However, these needs are not
limited to Space: both the <a href="https://digital-strategy.ec.europa.eu/en/policies/cyber-resilience-act">EU Cyber Resilience
Act</a>
and the <a href="https://tarides.com/blog/2024-03-07-a-time-for-change-our-response-to-the-white-house-cybersecurity-press-release/">US cybersecurity
initiatives</a>
highlight the growing demand for type-safe, high-assurance software to
address compliance and security challenges in sensitive
domains. Tarides believes that OCaml has a decisive role to play here
in 2025!</p>
<p>I’d like to personally thank our sponsors and customers, especially
Jane Street, for their unwavering support over the years, and to
<a href="https://github.com/dangdennis">Dennis Dang</a>, our single recurring
GitHub sponsor. Finally, to every member of Tarides who worked so hard
in 2024 to make all of this happen: thank you. I’m truly lucky to be
sailing with you on this journey!</p>
<p><em>We are looking for <a href="https://github.com/sponsors/tarides">sponsors on
GitHub</a>, are happy to
<a href="https://tarides.com/innovation/">collaborate on innovative projects</a>
involving OCaml or MirageOS and offer <a href="https://tarides.com/services/">commercial
services</a> for open-source projects –
including long-term support, development of new tools, or assistance
with porting projects to OCaml 5 or Windows.</em></p>


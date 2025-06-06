---
title: 'Opam Health Check: or How we Got to 90+% of Packages Building with Dune Package
  Management'
description: A follow-up to the previous blog post about Dune package management,
  highlighting more bug fixes and summarising the project
url: https://tarides.com/blog/2025-06-05-opam-health-check-or-how-we-got-to-90-of-packages-building-with-dune-package-management
date: 2025-06-05T00:00:00-00:00
preview_image: https://tarides.com/blog/images/opampkgmain-1360w.webp
authors:
- Tarides
source:
ignore:
---

<p>We have <a href="https://tarides.com/blog/2025-04-11-expanding-dune-package-management-to-the-rest-of-the-ecosystem/">recently
posted</a>
about the process of enabling Dune to build as many packages as possible. Since then,
we've been hard at work, going through the failures and fixing issues as we go
along. In today's post, I'll give you an overview of what we have achieved so
far, as well as an idea of what is yet to come.</p>
<h2>What Has Improved Since Last Time</h2>
<p>If you check our <a href="https://github.com/ocaml/dune/issues/11601">tracking issue</a>,
you'll notice there are significantly more items there than there were before.</p>
<p>We've made enhancements in how <code>dune pkg</code> and the health check handle
dependencies - including depexts - and aligned them better with how <code>opam</code>
does it. There are, however, some intentional differences between how <code>dune pkg</code> and <code>opam</code> do things. Inspecting their repository health has led
to fixes aligning <code>dune pkg</code> more with <code>opam</code> semantics and sometimes improving
the correctness of the metadata on <code>opam-repository</code>. Below, we'll go through some
of these improvements.</p>
<ul>
<li>A lot of packages in <code>opam</code> did not declare <code>ocaml</code> as a dependency. In
theory, <code>opam</code> is OCaml-agnostic and can install packages written in any
language (<a href="https://opam.ocaml.org/packages/topiary/">Topiary</a> is written in
Rust, for example). However, in practice, most packages on <code>opam</code> require
OCaml, so when a package does not declare a dependency on OCaml, and none of
its dependencies capture an OCaml compiler in their dependency cone, then
Dune Package Management locks a solution without a compiler. In many cases,
this will fail, so many packages have had their metadata updated to include
<code>ocaml</code> as a dependency on <code>opam-repository</code> and, where possible, upstream.</li>
<li>When <code>opam</code> encounters undefined variables, it evaluates them to 'false'.
When locking a solution, we translate the build and install instructions into
Dune's own variable format. However, in the Dune semantics, unknown variables
are not evaluated as false by default. We changed the way we translate
variables to wrap the variables with <code>catch_undefined_var</code> in
<a href="https://github.com/ocaml/dune/pull/11512">#11512</a>, thus matching the
semantics of the original expressions.</li>
<li>Some packages depend on <code>ez-conf-lib</code>, which is a package that records the
place of its executable when it is built. Unfortunately, in the case of Dune
package management, that would be a sandbox location, so when other packages
attempted to access it, it would not exist at that location anymore. This
made the package non-relocatable. In
<a href="https://github.com/ocaml/dune/issues/11598">#11598</a>, this was changed to use
<code>opam</code> and Dune-provided variables, which are set to the appropriate location
when building so that users can find them.</li>
<li>When packages build, they often need additional dependencies from the
operating system: these are called <code>depexts</code>. In Opam-Health-Check, we used
<code>opam</code> to install these, but sometimes there was no valid solution, and
<code>opam</code> would fail. Unfortunately, the failure displayed an error message, but
the process still succeeded with exit code 0. We changed our code to detect
the error message in
<a href="https://github.com/ocurrent/opam-health-check/pull/103">#103</a> and ended up
reporting the issue upstream to <code>opam</code> as
<a href="https://github.com/ocaml/opam/issues/6488">#6488</a>.</li>
<li>When users locked a solution with <code>dune pkg</code>, it would also record the
detected <code>depexts</code>. However, differences in how optional packages were
handled between <code>opam</code> and <code>dune</code> could lead to not enough packages being
installed if we used <code>opam</code> to install depexts. In
<a href="https://github.com/ocurrent/opam-health-check/pull/104">#104</a>, we changed
the logic to use Dune to create the list of <code>depexts</code> and install these in a
separate step. This way, there should be no confusion between what <code>opam</code> and
Dune consider a dependency.</li>
<li>While most source archives ship with <code>.opam</code> files, they are technically not
required. <code>Opam</code> never reads them when installing (since it uses the
information from <code>opam-repository</code>), and Dune does not need them as it can
read all the required information from <code>dune-project</code>. However,
Opam-Health-Check used them to determine which package names existed, so when
it encountered packages without <code>.opam</code> files, it assumed there were no
packages to build in the source archive. With
<a href="https://github.com/ocurrent/opam-health-check/pull/97">#97</a>, we read the
package names from <code>.opam</code> files and from <code>dune-project</code> to ensure we capture
all names.</li>
<li>When <code>opam</code> builds packages with Dune, for the most part, it uses <code>dune build -p &lt;pkg-name&gt;</code>. The <code>-p</code> flag is a special flag which is mainly used for
releasing and implies <code>--release --only-packages &lt;pkg-name&gt;</code>. We couldn't use
the same <code>-p</code> flag, as <code>--release</code> itself expanded to a lot of other
configuration options, among these <code>--ignore-lock-dir</code>. It meant that if
<code>dune pkg lock</code> and then <code>dune build</code> were used, <code>--release</code> would ignore the
lock directory. This was implemented so that introducing <code>dune pkg</code> would not
break packages in <code>opam-repository</code> that used lock files. However, there
aren't many packages in <code>opam-repository</code> that use <code>--release</code> and building
packages with Dune package management in <code>release</code> mode is useful. Dune was
patched in <a href="https://github.com/ocaml/dune/pull/11378">#11378</a> to move
<code>--ignore-lock-dir</code> to <code>-p</code>. This allows you to use <code>--release</code> with package
management, and <a href="https://github.com/ocurrent/opam-health-check/pull/96">#96</a>
was merged to take advantage of it. The use of <code>--release</code> better represents
an <code>opam</code> build and enables the building of several key packages, such as
<code>base</code> and <code>core</code>, for which <code>--release</code> disables building
Jane-Street-internal tests.</li>
<li>When we looked for which packages to build, we accidentally used a subset
search instead of an exact name match. Thus, we would sometimes accidentally
pick packages to build that were not meant to be built. This was fixed in
<a href="https://github.com/ocurrent/opam-health-check/pull/99">#99</a>, ensuring that
when determining whether <code>lab</code> should be built, accidentally matching on
<code>gitlab</code> would not give us false positives.</li>
</ul>
<h2>Maybe Some Packages Just Don't Build</h2>
<p>It turns out some packages that are on <code>opam-repository</code> just do not build.
This can be due to a lot of reasons. Some packages don't support OCaml 5.3 (the
most recent release at the time of writing and the one we run the checks on),
and others don't support the platform we are running on. Some can't be
downloaded because the server that hosted them disappeared. In such cases,
there is nothing that Dune package management can do besides fail.</p>
<p>Thus, to make a fair comparison, we <a href="https://github.com/ocurrent/opam-health-check/pull/95">patched
Opam-Health-Check</a> and
extended it so it can build the same package with Dune and <code>opam</code> in the same
run. That way, we see that if a package doesn't build on <code>opam</code>, it is
unlikely to magically work when using Dune package management (although that
can happen, e.g. on transient network failures, which would prevent <code>opam</code> from
downloading the source tarball).</p>
<h2>Some Things We Don't Support</h2>
<p>There are some packages that will not work. Often, this is because the packages
fail due to how Opam-Health-Check works, which is not something we expect a
user of Dune package management to encounter.</p>
<h3>Complex Build Commands</h3>
<p>When selecting the packages that we plan to build, we make sure to only pick
Dune packages. However, the definition of a package 'using Dune' is not
clear-cut.</p>
<p>A source might have a <code>dune-project</code> file but never call Dune. A build might
call Dune but also do an arbitrary number of other steps. In <code>opam</code>, this
process is simple because <code>opam</code> will just execute all steps in the <code>build</code> and
<code>install</code> entries, be it launching Dune, calling <code>make</code>, or any other command.</p>
<p>For the health check, we decided to set the limit at <code>dune build</code>. This means
that packages that require extra instructions will most likely fail to build in
the health check.</p>
<p>The reason why we are setting the limit here is twofold:</p>
<ol>
<li>Interpreting which commands to run in the health-check would require us to
implement and evaluate the filters that <code>opam</code> supports for running the
commands. Making sure we evaluate things exactly like <code>opam</code> does would be a
non-trivial undertaking.</li>
<li>Packages that need extra commands to run usually run just fine when these
commands are run manually; thus users of <code>dune pkg</code> can most likely use Dune
package management when using it on their machines.</li>
</ol>
<p>Another bonus reason is that not that many packages are affected by this, so it
didn't seem worth the time investment.</p>
<h2>What Work is There Still Left to Do?</h2>
<p>There are still categories of errors that make it difficult to adopt package
management. The most notorious issue is
<a href="https://github.com/ocaml/dune/issues/10855">#10855</a>, colloquially called the
"in and out of workspace" bug.</p>
<p>It occurs when a project has dependencies, and these dependencies, in turn,
depend on a package that is in the project's workspace. Usually, this is a
circular dependency, but such a configuration can reasonably happen in some
cases, such as when a test dependency uses something from your project. For
example, if Lwt uses a test tool that, in turn, depends on Lwt, it is currently
impossible to build it with Dune package management, as Lwt would be part of
both the build and its own dependencies.</p>
<p>There are not many packages affected, but the ones that are are some of the
most used packages in OCaml. Among these are Lwt, Odoc, and, unfortunately,
Dune (due to lots of projects depending on <code>dune-configurator</code>). Thus, at the
moment, Dune package management cannot be used to develop Dune itself.</p>
<p>While addressing these issues was outside the scope of this particular project,
we plan to tackle them through future initiatives. Ultimately, our goal is to
provide a seamless user experience with Dune package management.</p>
<h2>Until Next Time</h2>
<p>If you're using Dune Package Management and have feedback or questions, please
share your thoughts on <a href="https://discuss.ocaml.org">Discuss</a>. Our teams are
always looking for input in order to improve tools and features, and your
feedback can help us make everyone's experience better.</p>
<p>Stay in touch with Tarides on <a href="https://bsky.app/profile/tarides.com">Bluesky</a>,
<a href="https://mastodon.social/@tarides">Mastodon</a>,
<a href="https://www.threads.net/@taridesltd">Threads</a>, and
<a href="https://www.linkedin.com/company/tarides">LinkedIn</a>. We look forward to
hearing from you!</p>


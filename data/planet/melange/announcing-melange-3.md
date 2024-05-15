---
title: Announcing Melange 3
description:
url: https://melange.re/blog/posts/announcing-melange-3
date: 2024-02-13T00:00:00-00:00
preview_image:
authors:
- Melange Blog
source:
---

<p>We are excited to announce the release of <a href="https://github.com/melange-re/melange/releases/tag/3.0.0-51" target="_blank" rel="noreferrer">Melange
3</a>, the latest
version of our backend for the OCaml compiler that emits JavaScript.</p>
<p>This new version comes packed with significant changes, improvements, and a few
necessary removals to ensure a more streamlined and efficient experience for our
users. This new version is both leaner and more robust. We focused on fixing
crashes and removing obsolete functionality, improving the developer and
troubleshooting experience, increasing OCaml compatibility and JavaScript FFI
integration.</p>
<hr/>
<p>Here's a rundown of the key updates in Melange 3. Check the <a href="https://melange.re/v3.0.0/" target="_blank" rel="noreferrer">Melange
documentation</a> for further resources.</p>
<h2 tabindex="-1">Major Changes and Removals <a href="https://melange.re/blog/feed.rss#major-changes-and-removals" class="header-anchor" aria-label="Permalink to &quot;Major Changes and Removals&quot;"></a></h2>
<p>In Melange 3, <code>Belt</code> is no longer a dependency for the Melange <code>Stdlib</code>.
Libraries that depend on the Belt modules will need to include <code>(libraries melange.belt)</code> in their build configuration.</p>
<p>The <code>@bs</code> / <code>@bs.*</code> attributes have been replaced. Users of Melange should now
utilize <code>[@u]</code> for uncurried application and <code>[@mel.*]</code> for FFI attributes.
Additionally:</p>
<ul>
<li><code>[@mel.val]</code> has been removed as it was redundant in the Melange FFI&#8203;&#8203;.</li>
<li><code>[@mel.splice]</code> was removed in favor of <code>[@mel.variadic]</code></li>
</ul>
<p>For this release, most modules in the <code>Js</code> namespace had their APIs unified,
deduplicated and refactored. In cases such as <code>Js.Int</code>, <code>Js.Date</code>, <code>Js.Re</code>,
<code>Js.Float</code>, <code>Js.String</code>, some functions were changed from pipe-first to
pipe-last and labeled arguments were added; and incorporating those made others
obsolete, which we removed. Modules such as <code>Js.List</code>, <code>Js.Null_undefined</code>,
<code>Js.Option</code>, <code>Js.Result</code> and <code>Js.Cast</code> are also no longer present in Melange 3.
Alternatives within <code>Stdlib</code> or <code>Belt</code> are instead&#8203;&#8203; recommended.</p>
<h2 tabindex="-1">New Features and Enhancements <a href="https://melange.re/blog/feed.rss#new-features-and-enhancements" class="header-anchor" aria-label="Permalink to &quot;New Features and Enhancements&quot;"></a></h2>
<p>Melange 3 includes a few interesting new features and enhancements. From syntax
and preprocessing to interop with JavaScript, runtime and error messages, here are some
we chose to highlight:</p>
<h3 tabindex="-1">Multiple OCaml-version releases <a href="https://melange.re/blog/feed.rss#multiple-ocaml-version-releases" class="header-anchor" aria-label="Permalink to &quot;Multiple OCaml-version releases&quot;"></a></h3>
<p>A few users have expressed concerns related to Melange having a 1:1 relationship to its
OCaml version. This limitation exists because we vendor and modify OCaml's typechecker,
which is usually version-dependent.</p>
<p>In Melange 1, we made some strides to solve this at the syntax level &ndash; one Melange version
could work across many compiler switches. But that has a pretty big limitation: editor tooling,
documentation generation and everything else that reads from <code>.cmt</code> artifact files needed to be
in the same compiler switch as the version of the typechecker in use.</p>
<p>Starting in Melange 3, we will be adopting the recent Merlin release strategy: Melange has a
release for every compiler version that it supports, suffixed with the OCaml version that it
corresponds to, e.g. Melange 3 on OCaml 4.14 is <code>v3.0.0-414</code>.</p>
<h3 tabindex="-1">Interop <a href="https://melange.re/blog/feed.rss#interop" class="header-anchor" aria-label="Permalink to &quot;Interop&quot;"></a></h3>
<ul>
<li>Modules can be renamed with <code>@mel.as</code></li>
<li><code>@mel.obj</code> and <code>%mel.obj</code> allow renaming the JS object keys with <code>@mel.as</code></li>
<li><code>@mel.new</code> can now be used alongside <code>@mel.send</code> and <code>@mel.send.pipe</code></li>
<li><code>[@@deriving abstract]</code> is now deprecated and split into its two main
features:
<ul>
<li><code>[@@deriving jsProperties]</code> derives a JS object creation function that can
generate a JS object with optional keys (when using <code>@mel.optional]</code>)</li>
<li><code>[@@deriving getSet]</code> derives getter / setter functions for the JS object
derived by the underlying record.</li>
</ul>
</li>
</ul>
<h3 tabindex="-1">Error messages &amp; Hints <a href="https://melange.re/blog/feed.rss#error-messages-hints" class="header-anchor" aria-label="Permalink to &quot;Error messages &amp; Hints&quot;"></a></h3>
<p>Melange 3 provides more informative error messages originating from both the
<code>melange.ppx</code> and the compiler core&#8203;&#8203;&#8203;&#8203;.</p>
<p>In this release, we also introduce a new <code>unprocessed</code> alert to detect code that
has made it to the Melange compiler without having been processed by the Melange
PPX. Besides hinting users to add <code>(preprocess (pps melange.ppx))</code> to their <code>dune</code>
file, this alert more explicitly exposes a common failure mode that puzzles
beginners quite often.</p>
<p>Additionally:</p>
<ul>
<li>The Melange playground now has improved reporting of PPX alerts.</li>
<li>Runtime error rendering in the playground renders better error information.</li>
<li>The JS parser within Melange has been upgraded to Flow v0.225.1.</li>
</ul>
<h3 tabindex="-1">Runtime &amp; <code>Stdlib</code> <a href="https://melange.re/blog/feed.rss#runtime-stdlib" class="header-anchor" aria-label="Permalink to &quot;Runtime &amp; `Stdlib`&quot;"></a></h3>
<p>Melange 3 implements more functions in the following modules of the <code>Stdlib</code>:
<code>String</code>, <code>Bytes</code>, <code>Buffer</code>, <code>BytesLabels</code> and <code>StringLabels</code>. Specifically, the
new unicode parsing functions upstream are now available in Melange as well.</p>
<p>Some keys with legacy names have been updated for consistency, such as renaming
<code>RE_EXN_ID</code> to <code>MEL_EXN_ID</code> and <code>BS_PRIVATE_NESTED_SOME_NONE</code> to
<code>MEL_PRIVATE_NESTED_SOME_NONE</code>&#8203;&#8203; in the Melange generated JS runtime.</p>
<p>The team also took a look at unicode strings in this version of Melange. A few
noteworthy changes:</p>
<ul>
<li><code>{j| ... |j}</code> interpolation&#8203;&#8203;&#8203;&#8203; now only allows interpolating strings; other
usages of interpolation have started to produce type errors.</li>
<li>Unicode strings such as <code>{js| &hellip; |js}</code> can now be used as <code>Format</code> strings.</li>
</ul>
<h2 tabindex="-1">Conclusion <a href="https://melange.re/blog/feed.rss#conclusion" class="header-anchor" aria-label="Permalink to &quot;Conclusion&quot;"></a></h2>
<p>Melange 3 marks a significant step forward in the OCaml-to-JavaScript
compilation process. With these updates, we aim to provide a more robust,
efficient, and user-friendly tool for developers. We encourage users to upgrade
to this new version to take full advantage of the improvements and to adapt to
the breaking changes for a smoother development experience. For a full list of
the changes that made it into this release, feel free to consult the
<a href="https://github.com/melange-re/melange/blob/main/Changes.md#300-2024-01-28" target="_blank" rel="noreferrer">changelog</a>.</p>
<p>Stay tuned for more updates and enhancements as we continue to improve Melange
and support the developer community!</p>


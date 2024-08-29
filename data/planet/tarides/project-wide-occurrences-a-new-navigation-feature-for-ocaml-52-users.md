---
title: 'Project-Wide Occurrences: A New Navigation Feature for OCaml 5.2 Users'
description: "Project-Wide Occurrences With the release of merlin-lib 5.1-502 and
  associated ocaml-lsp-server, we\nbrought a new, exciting feature to OCaml\u2026"
url: https://tarides.com/blog/2024-08-28-project-wide-occurrences-a-new-navigation-feature-for-ocaml-5-2-users
date: 2024-08-28T00:00:00-00:00
preview_image: https://tarides.com/static/dc6f8054892fd492e3a6e3b950bf9d6c/47930/camls_2.jpg
authors:
- Tarides
source:
---

<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#project-wide-occurrences" aria-label="project wide occurrences permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Project-Wide Occurrences</h1>
<p>With the release of <code>merlin-lib</code> <code>5.1-502</code> and associated <code>ocaml-lsp-server</code>, we
brought a new, exciting feature to OCaml's editor tooling: project-wide
occurrences.</p>
<p>The traditional "occurrences" query in Merlin modes, named "Find All
References" in LSP-based mode, was used to only return results in the active buffer.
This is no longer the case!</p>
<p>Occurrences queries will now return every usage of
the selected identifier across all of the project's source files.</p>
<blockquote>
<p>There are some limitations that come with this initial release. When queried
from an identifier's <em>usage</em> or its <em>definition</em>, all other <em>usages</em> of it
are returned, but related <em>declarations</em> are not. In particular, this means
that queries should be made from implementation files, not interfaces (<code>.mli</code>).</p>
</blockquote>
<p>In this post, we will give an overview of the ecosystem's various parts that
need to work together for this feature to work.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#try-it" aria-label="try it permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Try It!</h2>
<p>Before diving into technical details, let's see how it works. You can try it on any project that builds with Dune and is compatible with OCaml 5.2.</p>
<p>Update your switch by running <code>opam update &amp;&amp; opam upgrade</code> to get the required tool versions:</p>
<ul>
<li>Dune <code>&gt;= 3.16.0</code></li>
<li>Merlin <code>&gt;= 5.1-502</code></li>
<li>OCam-LSP <code>&gt;= 1.19.0</code></li>
</ul>
<p>Since we are looking for all occurrences, we need to build an index for Merlin
and LSP. Fortunately, this is well integrated in Dune, and you can build the index
for your project by running:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">dune build @ocaml-index</code></pre></div>
<p>This alias ensures that all the artifacts needed by Merlin are built. You can
also add <code>--watch</code> to always keep the configuration and the indexes up to date
while you edit your source files.</p>
<blockquote>
<p>Note that unlike <code>dune build @check</code>, the <code>@ocaml-index</code> will build the entire project, including tests.</p>
</blockquote>
<p>Once the index is ready, you can query for project-wide occurrences:</p>
<ul>
<li><code>merlin-project-occurrences</code> in Emacs</li>
<li><code>MerlinOccurrencesProjectWide</code> in Vim</li>
<li><code>Find All References</code> in LSP-based plugins.</li>
</ul>
<p>Here is a comparison of a references query before, and after building the index:</p>
<center>
<video autoplay="" loop="" style="width: 100%">
  <source src="/blog/2024-08-29.pwo/pwo_side_by_side.webm" type="video/webm">
</video>
</center>
<p>Now, let's dive into more technical details.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#high-level-overview" aria-label="high level overview permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>High-Level Overview</h2>
<p>The base design is fairly simple. We want to iterate on every identifier of
every source file, determine their definition, and group together those that
share the same definition. This forms an index. Tools can then query that index
to get the location list of identifiers that share the same definition.</p>
<p>The following section describes how we implemented that workflow:</p>
<ol>
<li>Compute definitions using two-step shape reduction</li>
<li>Driving of the indexer tool by the build system</li>
<li>Changes to Merlin to properly answer queries</li>
</ol>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#two-step-shape-reduction" aria-label="two step shape reduction permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Two-Step Shape Reduction</h2>
<p>Finding an identifier's definition in OCaml is a difficult problem, mostly
because of its powerful module system. A solution to this problem has been recently described
in <a href="https://icfp22.sigplan.org/details/mlfamilyworkshop-2022-papers/10/Module-Shapes-for-Modern-Tooling">a presentation at the ML
Workshop</a>: shapes.
In short, shapes are terms of a simple lambda-calculus that represent an
abstraction of the module system. To find an identifier's definition, one
can build a shape from its path and reduce (as in beta-reduction) that shape.
The result should be a leaf with a UID that uniquely represents the
definition.</p>
<p>This has been implemented in the compiler, and Merlin already takes advantage of
it to provide a precise <code>jump-to-definition</code> feature.</p>
<p>For project-wide occurrences, we perform shape reduction in two steps:</p>
<p>First, at the end of a module's compilation, the compiler iterates on the
Typedtree and <em>locally</em> reduces every identifier's shape. If the
identifier is locally (in the same unit) defined, the result will be a
fully-reduced shape holding the definition's UID. However, if the identifier is
identified in another compilation unit, the result is a partially-reduced
shape, because we cannot load the <code>.cmt</code> files of other compilation
units (that are required to finish the reduction) without breaking the
separate compilation assumptions. These resulting UIDs or partially-reduced
shapes are stored in the unit's <code>.cmt</code> file:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> cmt_infos <span class="token operator">=</span> <span class="token punctuation">{</span>
  <span class="token operator">..</span><span class="token punctuation">.</span>
  cmt_ident_occurrences <span class="token punctuation">:</span>
    <span class="token punctuation">(</span>ident_with_loc <span class="token operator">*</span> def_uid_or_shape<span class="token punctuation">)</span> list
<span class="token punctuation">}</span></code></pre></div>
<p>Then, an external tool (called <code>ocaml-index</code>) will read that list and finish
the reduction of the shapes when necessary. This step might load the <code>.cmt</code> files
of any transitive dependency the unit relies on.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#indexation-by-the-build-system" aria-label="indexation by the build system permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Indexation by the Build System</h2>
<p>The tool we just introduced, <code>ocaml-index</code>, plays two roles:</p>
<ol>
<li>It finishes the reduction of the shapes stored in the <code>.cmt</code> files.</li>
<li>It aggregates locations that share the same definition's UID.</li>
</ol>
<p>The result is an index that is written to a file. Additionally, the tool
can merge multiple indexes together. This allows build systems to handle
indexation in the way they decide.</p>
<p>We only provide rules for Dune right now, but the tools themselves are built
system agnostic. The Dune rules are as follow:</p>
<p>For every stanza <code>library</code> or <code>executable</code>, we index every <code>.cmt</code> file and store
the results into an <code>index</code> file for the stanza.</p>
<ul>
<li>This process, similar to linking, depends on every transitive dependency of
the stanza being indexed, since shape reduction might require loading those
<code>cmt</code> files.</li>
<li>Additionally, if any of the dependencies' indexes have changed, each stanza's index must be rebuilt.</li>
</ul>
<p>This is a somewhat simple but heavy process, and it could be refined in the future. Right now it performs well enough to provide a usable watch mode in small to fairly large projects (like Dune itself).</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#index-configuration-and-reading" aria-label="index configuration and reading permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Index Configuration and Reading</h2>
<p>Last but not least, we need a way for Merlin to know were the <code>index</code> files are
located and how to read them.</p>
<p>This is done by using a new configuration directive <code>INDEX</code>. It can be used to
provide one or more <code>index</code> files to Merlin. Then, querying for all the usages of
the identifier under the cursor is done in the following way:</p>
<ul>
<li>Identify the path of the identifier under the cursor</li>
<li>Reduce the shape corresponding to this path to get the definition's UID.</li>
<li>Lookup this UID in the <code>index</code> files and in the current buffer's index
(which is computed by Merlin).</li>
<li>Return all the locations</li>
</ul>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#future-work" aria-label="future work permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Future Work</h2>
<p>Thank you for reading this post! We hope you will have a lot of fun exploring
your codebases using this new feature. We have a lot of exciting improvements on
our roadmap, some of which involve returning the declarations linked to an
identifier and providing project-wide renaming queries.</p>
<p>If you are interested to learn more about these features or to contribute,
please have a look at <a href="https://github.com/ocaml/merlin/issues/1780">this tracking
issue</a>. You can also have a look at
the
<a href="https://discuss.ocaml.org/t/ann-project-wide-occurrences-in-merlin-and-lsp/14847">announcement</a>
and <a href="https://github.com/ocaml/merlin/wiki/Get-project%E2%80%90wide-occurrences">wiki
page</a>.
Finally, feel free to attend future <a href="https://github.com/ocaml/merlin/wiki/Public-dev%E2%80%90meetings">Merlin public
meetings</a> and
watch the <a href="https://icfp24.sigplan.org/details/ocaml-2024-papers/3/Project-wide-occurrences-for-OCaml-a-progress-report">talk at the OCaml
Workshop</a>
during ICFP!</p>
<blockquote>
<p>Tarides is an open-source company first. Our top priorities are to establish and tend to the OCaml community. Similarly, we’re dedicated to the <a href="https://github.com/sponsors/tarides">development of the OCaml language</a> and enjoy collaborating with industry partners and individual engineers to continue improving the performance and features of OCaml. We want you to join the OCaml community, test the language and tools, and actively be part of the language’s evolution.</p>
</blockquote>
<blockquote>
<p>Tarides is always happy to discuss commercial opportunities around OCaml. There are many areas where we can help industrial users to adopt OCaml 5 more quickly, including training, support, custom developments, etc. Please <a href="https://tarides.com/company">contact us</a> if you are interested in discussing your needs.</p>
</blockquote>

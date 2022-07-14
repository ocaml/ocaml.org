---
title: Faster Incremental Builds with Dune 3
description: "In February 2022, we released Dune 3.0. This updated version is the
  result of considerable development work over the previous six months\u2026"
url: https://tarides.com/blog/2022-07-12-faster-incremental-builds-with-dune-3
date: 2022-07-12T00:00:00-00:00
preview_image: https://tarides.com/static/2bb629edfbfd9e573f4010d717bd4714/46798/speed_watch.jpg
featured:
---

<p>In February 2022, we released Dune 3.0. This updated version is the result of considerable development work over the previous six months. Dune 3.0 contains many new features, one of which is &ldquo;watch mode,&rdquo; an exciting new feature explained below.</p>
<p>As a build system, Dune&rsquo;s main goal is to build targets. These targets can be either files (like an executable file) or &ldquo;aliases,&rdquo; a group of targets that can have a visible outcome (like running tests). By default, when running a build, Dune receives a target. Dune will then build it and exit. For example <code>dune build</code> (an alias for <code>dune build @all</code>) will build everything it knows about, then exit.</p>
<p>When working on a piece of code, many developers use an edit-save-build loop:</p>
<ul>
<li>Edit a piece of code</li>
<li>Save the corresponding file</li>
<li>Run a build command</li>
</ul>
<p>Using the outcome of the build (i.e., Did the build work? Did the tests all pass?), developers start a new iteration of this loop manually, but it&rsquo;s more efficient to have a quick, automated iteration process. This is the goal of the &ldquo;watch mode.&rdquo;</p>
<p>When active, Dune will watch the source files in a project, and when one of them has changed, it will re-execute the same build command automatically and display the results of the build. It doesn&rsquo;t exit automatically, so it continues watching for changes. This is more efficient because the developer can stay focussed in their text editor and see the build start automatically when the file is saved. You can enable watch mode by passing the <code>-w</code> flag to <code>dune</code>, like <code>dune build -w</code>.</p>
<p>A simple implementation is to have a special process check for file changes in the source tree and run the build command when something has changed. This works, but it isn&rsquo;t a very precise solution. First because the external process doesn&rsquo;t know about the relationships between the files, so it will run more builds than necessary. For example, changing a README file usually should not trigger a new build because it isn&rsquo;t a source file. But also, there are various subtleties to handle. If a file is changed while a build is running, a new build should be started, but the previous one should also be cancelled.</p>
<p>For these reasons, it&rsquo;s more efficient to have the build system itself &ldquo;drive&rdquo; the watch mode. This is how it&rsquo;s implemented in Dune 1.x and Dune 2.x. When starting a build in watch mode for a certain target, Dune computes the set of files that can influence this target (using the build rules) and calls an external process that can subscribe to file changes. When a file changes, Dune cancels existing builds and will start a new one.</p>
<p>This is better, but it&rsquo;s still not very efficient. To see why, let&rsquo;s see what Dune does and how it can be fast.</p>
<p>To run a build, Dune needs to do two things:</p>
<ul>
<li>Load the rules: detect the workspace (determine which files to consider), parse the <code>dune</code> files (open them, transform them into s-expressions and stanzas), and interpret them (execute the logic to transform the stanzas into rules)</li>
<li>Execute the rules: copy files around, call external processes, etc.</li>
</ul>
<p>The time it takes to load the rules is related to the size of the current workspace (number and size of <code>dune</code> files). This is particularly noticeable in organisations that use a monorepo (all the source code in a large Dune workspace). It's difficult to make this step fast because it has a lot of work to do, but it's doable by avoiding computing the same things over and over, made possible by an internal memoisation framework. An initial version of this system is described <a href="https://dune.build/blog/new-computation-model/">in this blog post</a>.</p>
<p>The time it takes to execute the rules depends on the amount of work necessary. For example, a clean build needs to execute most of the build actions, while a second full build usually needs to execute no rule at all. To make this step fast, Dune tries to avoid executing actions that wouldn't change the final outcome (a technique called early cutoff), and it executes independent actions in parallel.</p>
<p>In the context of the watch mode, whenever a new build starts, Dune has to forget everything it knows about the workspace, so it will reload all the rules. This is pretty wasteful.</p>
<p>To do better, the new watch mode in Dune 3 makes rule loading incremental. For example, if a <code>dune</code> file is edited to add a stanza, Dune parses it again, only adding the new rule. The other ones are not interpreted. This ensures very fast iteration times.</p>
<p>This project was challenging because for it to work, everything in the Dune core had to be ported to the memoisation API. For instance, the library loading code (which looks for library definitions in the current opam switch and in the Dune workspace) relied on a &ldquo;classic&rdquo; cache (a global hash table) to avoid parsing files repeatedly. However, this does not play nice with the memoisation API, which assumes that the functions it caches are all pure. So, in Dune 3, this piece of code has been rewritten on top of the memoisation API. This has another benefit: since file system accesses (&ldquo;does this file exist?&rdquo;) are cached too, the memoisation API now has an idea of which functions can read which files. This is used to re-evaluate only the affected parts of the rule graph once a file is modified.</p>
<p>Thanks to that work, watch mode is now a lot more responsive than in Dune 2.x. This performance improvement is barely noticeable in small-to-medium-sized projects, but it is essential in a workspace with several million lines of OCaml code. In such a setting, re-evaluating rules over and over (either by manually running <code>dune build</code> or by using the strategy in Dune 2.x) means that the feedback loop takes dozens of seconds instead being almost instantaneous.</p>
<p>As Dune performance improves, it's able to support workspaces that are larger and larger. This means that the bottlenecks shift to different places. We'll continue to improve Dune so that it stays a build system that's convenient to use and endlessly scalable.</p>

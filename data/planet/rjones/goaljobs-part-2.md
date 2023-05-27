---
title: Goaljobs, part 2
description: "In part 1 I showed how a simple make rule could be converted to a special
  \u201Cgoal\u201D function and I hinted that we were not limited to just the \u201Cfile
  is older than\u201D semantics im\u2026"
url: https://rwmj.wordpress.com/2013/09/20/goaljobs-part-2/
date: 2013-09-20T09:04:11-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- rjones
---

<p><a href="https://rwmj.wordpress.com/2013/09/19/goaljobs-part-1/">In part 1</a> I showed how a simple make rule could be converted to a special &ldquo;goal&rdquo; function and I hinted that we were not limited to just the &ldquo;file is older than&rdquo; semantics implicit in make.</p>
<p>So let&rsquo;s have a look at <a href="http://git.annexia.org/?p=goals.git%3Ba=tree">the goals I wrote</a> to <a href="https://rwmj.wordpress.com/2013/09/14/ocaml-4-01-0-entering-rawhide/">automate the recent OCaml rebuild in Fedora</a>.</p>
<p>Recall from part 1: Targets are a contractual promise that you make in goaljobs.  They are a promise that some condition will be true after running the goal.  Requirements are conditions that must be true before the goal can start running.</p>
<p>For a Fedora package to achieve the goal of being rebuilt, the target is that the Koji build state of the current release must be &ldquo;Completed&rdquo;.  The requirements are that every dependency of the package has been rebuilt.  So:</p>
<pre>
let goal <b>rebuilt pkg</b> =
  <b>target (koji_build_state (fedora_verrel pkg branch)
               == `Complete);</b>

  <i>(* Require the rebuild to have started: *)</i>
  <b>require (rebuild_started pkg);</b>

  <i>... some code to wait for the build to finish ...</i>
</pre>
<p>The above code is not complete (it&rsquo;s a complex, real-world working example after all).</p>
<p>I split the <code>rebuilt</code> goal into two separate goals for reasons that will become clear later.  But the first goal above says that the package rebuild must have been started off, and we&rsquo;ll wait for the package build to complete.</p>
<p>Note that once the build is complete, the target promise is true.</p>
<p>The subgoal <code>rebuild_started</code> is defined like this:</p>
<pre>
let goal <b>rebuild_started pkg</b> =
  <i>(* The dependencies of this package: *)</i>
  let deps = List.assoc pkg pkg_deps in

  <b>target (
     match koji_build_state (fedora_verrel pkg branch) with
          | `Building | `Complete -&gt; true
          | _ -&gt; false
    );</b>

  <i>(* All dependent packages must have been fully rebuilt: *)</i>
  List.iter (fun dep -&gt; <b>require (rebuilt dep)</b>) deps;

  <i>(* Rebuild the package in Koji. *)</i>
  koji_build pkg branch
</pre>
<p>It&rsquo;s saying that the target (promise) will be that the Koji package will either be building or may even be complete.  And that we first of all require that every build dependency of this package has been completely, successfully rebuilt.  If those requirements are met, we tell Koji to start building the package (but in this goal we don&rsquo;t need to wait for it to complete).</p>
<p>Why did I split the goal into two parts?</p>
<p>The reason is that I want to define a make-like <code>all</code> goal:</p>
<pre>
let goal <b>all</b> () =
  List.iter (fun pkg -&gt; <b>require (rebuild_started pkg)</b>)
    source_packages
</pre>
<p>This iterates over all my source packages and <i>starts</i> rebuilding them.</p>
<p>Note it doesn&rsquo;t wait for each one to be rebuilt &hellip; <i>unless</i> they are required as dependencies of another package, in which case the <code>require (rebuilt dep)</code> will kick in and wait for them before rebuilding the dependent package.</p>
<p>In other words, this code automatically resolves dependencies, waiting where necessary, but otherwise just kicking off builds, which is exactly what I wanted.</p>
<hr/>
<p>Finally a bit about how you use a goaljobs script.  Unlike <code>make</code> you have to compile the script into a binary.  To compile the script, use the convenient wrapper <code>goaljobs</code> (it&rsquo;s a simple shell script that invokes the OCaml compiler):</p>
<pre>
goaljobs fedora_ocaml_rebuild.ml
</pre>
<p>This makes a binary called <code>fedora_ocaml_rebuild</code> which is the program for mass-rebuilding the whole of Fedora&rsquo;s OCaml subset.</p>
<p>When you run it with no arguments, it searches for a goal called <code>all</code> and &ldquo;requires&rdquo; that goal (just like <code>make</code>).</p>
<p>You can also run other goals directly.  Any goal which is &ldquo;published&rdquo; can be run from the command line.  All goals that have no parameters &mdash; such as <code>all</code> &mdash; are published automatically.</p>
<p>For goals that take parameters, if you want to use them from the command line you have to publish them manually.  The reason is that you have to provide a small code snippet to convert the command line parameters to goal parameters, which may involve type conversion or other checks (since OCaml is strongly typed and parameters can be any type, not just strings or filenames).</p>


---
title: Goaljobs, part 3
description: "In part 2 I introduced an example goaljobs script that can rebuild a
  set of packages in Fedora in the right order. It\u2019s time to take a closer look
  at targets \u2014 the promise that you make\u2026"
url: https://rwmj.wordpress.com/2013/09/20/goaljobs-part-3/
date: 2013-09-20T11:03:05-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- rjones
---

<p>In <a href="https://rwmj.wordpress.com/2013/09/20/goaljobs-part-2/">part 2</a> I introduced an example goaljobs script that can rebuild a set of packages in Fedora in the right order.</p>
<p>It&rsquo;s time to take a closer look at <b>targets</b> &mdash; the promise that you make that some condition will be true by the time a goal has run.</p>
<p>In the Fedora rebuild script the goal targets looked like this:</p>
<pre>
let goal rebuilt pkg =
  <b>target (koji_build_state (fedora_verrel pkg branch)
               == `Complete);</b>
  ...
</pre>
<p><code>koji_build_state</code> is a regular function.  It&rsquo;s implemented using the <code>koji buildinfo</code> command line tool for querying <a href="http://koji.fedoraproject.org/koji/">the Koji build system</a>.  (The koji command line tool is annoyingly hard to automate, but as we&rsquo;ve got a complete programming language available &mdash; not just bash &mdash; <a href="http://git.annexia.org/?p=goals.git%3Ba=blob%3Bf=fedora.ml%3Bhb=HEAD">the implementation of <code>koji_build_state</code></a> is tedious and long, but doable).</p>
<p>Querying Koji takes a few seconds and we don&rsquo;t want to do it every time we check a goal.  Goaljobs offers a feature called &ldquo;The Memory&rdquo; which lets you <a href="http://perl.plover.com/Memoize/doc.html#description">memoize</a> functions.  &ldquo;The Memory&rdquo; is just a fancy name for a key/value store which is kept in <code>~/.goaljobs-memory</code> and persists across goaljobs sessions:</p>
<pre>
let koji_build_state verrel =
  let key = sprintf &quot;koji_build_complete_%s&quot; verrel in
  if <b>memory_exists key</b> then
    `Complete
  else (
    <i>(* tedious code to query koji *)</i>
    if state == `Complete then
      <b>memory_set key &quot;1&quot;</b>;
    state
  )
</pre>
<p>With strategic use of memoization, evaluating goaljobs goals can be very fast and doesn&rsquo;t change the fundamental contract of targets.</p>
<p>Finally in this part: a note on how targets are implemented.</p>
<p>A target is a boolean expression which is evaluated once near the beginning of the goal.  If it evaluates to true at the beginning of the goal then the rest of the goal can be skipped because the goal has already been achieved / doesn&rsquo;t need to be repeated.</p>
<p>And since targets are just general expressions, they can be anything at all, from accessing a remote server (as here) to checking the existence of a local file (like make).  As long as something can be tested quickly, or can be tested slowly and memoized, it&rsquo;s suitable to be a target.</p>


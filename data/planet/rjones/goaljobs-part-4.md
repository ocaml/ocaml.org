---
title: Goaljobs, part 4
description: "In part 3 I described how to write targets which can access network
  resources, and how to use memoization to make them run fast. In this (last) part
  of the series, I\u2019ll describe the final fea\u2026"
url: https://rwmj.wordpress.com/2013/09/20/goaljobs-part-4/
date: 2013-09-20T20:57:21-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- rjones
---

<p>In <a href="https://rwmj.wordpress.com/2013/09/20/goaljobs-part-3/">part 3</a> I described how to write targets which can access network resources, and how to use memoization to make them run fast.  In this (last) part of the series, I&rsquo;ll describe the final feature of goaljobs &mdash; periodic jobs.</p>
<p>If you wanted to use <code>make</code> to monitor a git repository and do a build when a new commit appears there would I guess be three choices: You could just run the <code>make</code> command manually over and over again.  You could have a git hook that runs <code>make</code>.  Or you have a cron job the periodically checks the git repository.</p>
<p>The git hook is the ideal solution for goaljobs too, but goaljobs also has cron-like <b>periodic jobs</b> built in, and they are very easy to use:</p>
<pre>
every 30 minutes (fun () -&gt;
  let commit =
    shout &quot;cd %s &amp;&amp; git rev-parse HEAD&quot; repo in
  require (git_commit_tested commit)
)
</pre>
<p><code>every 30 minutes</code> is self-explanatory (right?).  The function that runs every half-an-hour is two lines of code.  The first line uses <code>shout</code> to run a <b>sh</b>ell command and capture the <b>out</b>put.  In this case git prints the current commit.  The second command requires that the <code>git_commit_tested</code> goal is reached for this commit.</p>
<p>One way to implement this goal would be:</p>
<pre>
let goal git_commit_tested commit =
  let key = sprintf &quot;repo-tested-%s&quot; commit in
  target (memory_exists key);

  sh &quot;
      git clone %s test
      cd test
      ./configure
      make
      make check
  &quot; repo_url;

  memory_set key &quot;1&quot;
</pre>
<p>This code clones the repository and runs <code>make check</code> to test it.  It uses the Memory (ie. memoization) to ensure that the tests are run at most once per commit.</p>
<p>Actually this is not quite true: the tests run successfully once, but if the test fails, it will keep running every 30 minutes and nag you about it.  It&rsquo;s trivial to change the memoization to remember failures as well as successes, or you could consider the repeated nagging to be a feature not a bug &hellip;</p>
<p>That&rsquo;s it!  The goaljobs website <i>will</i> be this (I&rsquo;ve not uploaded it yet, but will do in the next day or two):</p>
<p><a href="http://people.redhat.com/~rjones/goaljobs" rel="nofollow">http://people.redhat.com/~rjones/goaljobs</a></p>
<p>You can also download the code from the <a href="http://git.annexia.org/?p=goaljobs.git%3Ba=summary">git repository</a> and the goals I&rsquo;ve written from <a href="http://git.annexia.org/?p=goals.git%3Ba=summary">this repository</a>.</p>


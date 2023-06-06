---
title: Goaljobs, part 1
description: "A little more than a year ago I released whenjobs which was an attempt
  to create a practical language for automating complex \u201Cbusiness rules\u201D.
  The kind of thing I\u2019m talking about \u2026"
url: https://rwmj.wordpress.com/2013/09/19/goaljobs-part-1/
date: 2013-09-19T22:16:03-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- rjones
---

<p>A little more than a year ago I released <a href="http://people.redhat.com/~rjones/whenjobs/">whenjobs</a> which was an attempt to create a practical language for automating complex &ldquo;business rules&rdquo;.  The kind of thing I&rsquo;m talking about is managing the many diverse steps between me <a href="https://github.com/libguestfs/libguestfs/commit/4d955be4fb9fe304d5ab4222f0e9592f5fc1ef5b">tagging a libguestfs commit with a version number</a> and a <a href="http://libguestfs.org/download/1.23-development/">fully tested tarball appearing on the website</a>.  Or the hundreds of steps that go into <a href="https://rwmj.wordpress.com/2013/09/14/ocaml-4-01-0-entering-rawhide/">100 OCaml packages being updated and rebuilt for Rawhide</a>.</p>
<p>Whenjobs wasn&rsquo;t the right answer.  <a href="http://git.annexia.org/?p=goaljobs.git%3Ba=summary">Goaljobs [very early alpha]</a> might possibly be.</p>
<p>What I need is something which is flexible, can deal with failures (both hard and intermittent), and can be killed and restarted at any point.</p>
<p>The first observation is that <a href="https://en.wikipedia.org/wiki/Make_(software)">make</a> is nearly the right tool.  It&rsquo;s goal-based, meaning that you set down a target that you want to have happen, and some rules to make that happen, and this lets you break down a problem from the larger goal (&ldquo;build my program!&rdquo;) to smaller subgoals (&ldquo;compile this source file&rdquo;).</p>
<pre>
program: main.o utils.o
  cc $^ -o $@
</pre>
<p>The goal is &ldquo;<code>program</code> is built&rdquo;.  There are some requirements (<code>main.o</code>, <code>utils.o</code>), and there&rsquo;s a recipe (run <code>cc</code>).  You can also kill make in the middle and restart it, and it&rsquo;ll usually continue from where it left off.</p>
<p>Make also lets you parameterize goals, although only in very simple ways:</p>
<pre>
%.o: %.c
  cc -c $&lt; -o $@
</pre>
<p>Implicit in the &ldquo;:&rdquo; (colon) character is make&rsquo;s one simple rule, which is roughly this: &ldquo;if the target file doesn&rsquo;t exist, or the prerequisite files are newer than the target, run the recipe below&rdquo;.</p>
<p>In fact you could translate the first make rule into an ordinary function which would look something like this:</p>
<pre>
function build_program ()
{
  if (!file_exists (&quot;program&quot;) ||
      file_older (&quot;program&quot;, &quot;main.o&quot;) ||
      file_older (&quot;program&quot;, &quot;utils.o&quot;)) {
    shell (&quot;cc -c %s -o %s&quot;, &quot;main.o utils.o&quot;,
           &quot;program&quot;);
  }
}
</pre>
<p>Some points arise here:</p>
<ul>
<li> Why can&rsquo;t we change the target test to something other than &ldquo;file exists or is newer&rdquo;?<br/>How about &ldquo;remote URL exists&rdquo; (and if not, we need to upload a file)?<br/>How about &ldquo;Koji build completed successfully&rdquo; (and if not we need to do a Fedora build)?
</li><li> What could happen if we could add parameters to <code>build_program</code>?
</li></ul>
<p>Goaljobs attempts to answer these questions by turning make-style rules into &ldquo;goals&rdquo;, where goals are specialized functions similar to the one above that have a target, requirement(s), a recipe to implement them, and any number of parameters.</p>
<p>For example, a <a href="http://git.annexia.org/?p=goaljobs.git%3Ba=blob%3Bf=examples/compile-c/compile.ml%3Bh=151e8b79ec3ca82aecbff533bcf514be2cfb8ff2%3Bhb=HEAD">&ldquo;compile *.c to *.o&rdquo; goal</a> looks like this:</p>
<pre>
let goal compiled c_file =
  <i>(* convert c_file &quot;foo.c&quot; -&gt; &quot;foo.o&quot;: *)</i>
  let o_file = change_file_extension &quot;o&quot; c_file in

  target (more_recent [o_file] [c_file]);

  sh &quot;
    cd $builddir
    cc -c %s -o %s
  &quot; c_file o_file
</pre>
<p>The <code>goal</code> is called <code>compiled</code> and it has exactly one parameter, the name of the C source file that must be compiled.</p>
<p>The <code>target</code> is a promise that after the recipe has been run the *.o file will be more recent than the *.c file.  The target is both a check used to skip the rule if it&rsquo;s already true, but also a contractual promise that the developer makes (and which is checked by goaljobs) that some condition holds true at the end of the goal.</p>
<p><code>sh</code> is a lightweight way to run a shell script fragment, with printf-like semantics.</p>
<p>And the whole thing is wrapped in a proper programming language (preprocessed OCaml) so you can do things which are more complicated than are easily done in shell.</p>


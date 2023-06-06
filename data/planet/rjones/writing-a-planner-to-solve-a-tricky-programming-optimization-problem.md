---
title: Writing a Planner to solve a tricky programming optimization problem
description: "Suppose a monkey is in one corner of a room, a box is in another corner
  of a room, and a banana is hanging from the ceiling in the middle of the room. The
  monkey can\u2019t reach the banana withou\u2026"
url: https://rwmj.wordpress.com/2013/12/14/writing-a-planner-to-solve-a-tricky-programming-optimization-problem/
date: 2013-12-14T13:54:49-00:00
preview_image: http://libguestfs.org/virt-builder.svg
featured:
authors:
- rjones
---

<p>Suppose a monkey is in one corner of a room, a box is in another corner of a room, and a banana is hanging from the ceiling in the middle of the room.  The monkey can&rsquo;t reach the banana without standing on the box, but he first has to move the box under the banana.  The problem of how to get a computer to work out that the monkey has to move the box first, then climb on the box second, was solved by Nils Nilsson&rsquo;s <a href="https://en.wikipedia.org/wiki/STRIPS">STRIPS</a> system in 1971.  STRIPS is now an A.I. standard, and is used in <a href="http://web.media.mit.edu/~jorkin/goap.html">game A.I.</a> and elsewhere.</p>
<p>Suppose you have a disk image template that you want to uncompress, convert to another format, and resize.  You can run <code>xzcat</code>, followed by <code>qemu-img convert</code> followed by <a href="http://libguestfs.org/virt-resize.1.html">virt-resize</a>.  But <code>virt-resize</code> can also do format conversion, so you don&rsquo;t need to run <code>qemu-img convert</code>.  Unless the user was happy with the original size, in which case <code>qemu-img convert</code> is faster than virt-resize.  But what if the original template <i>isn&rsquo;t</i> compressed and is already in the right format and size?  You can just run <code>cp</code>.</p>
<p><img src="https://i0.wp.com/libguestfs.org/virt-builder.svg" width="200" style="float:right;"/> How can a computer work out the right sequence of steps to convert the disk image most efficiently?  <a href="http://libguestfs.org/virt-builder.1.html">Virt-builder</a> has exactly this problem, and it solves it using a STRIPS-inspired planner.</p>
<p>The STRIPS planner in virt-builder is only 50 lines of code, was easy to write, finds the near optimal plan for almost any user input, and is a useful technique that can be applied to many programming problems.  This article will explain how it works.  I have changed some of the academic terms and simplified things to make this easier to understand.</p>
<p>First of all I&rsquo;ll introduce <q>tags</q> on the original template.  These define the state of that template:</p>
<p>Input tags: <b>&#10010;xz</b> <b>&#10010;template</b> <b>&#10010;size=4G</b> <b>&#10010;format=raw</b></p>
<p>Secondly I&rsquo;ll set up my goal state:</p>
<p>Goal tags: <b><img src="https://s0.wp.com/wp-content/mu-plugins/wpcom-smileys/twemoji/2/72x72/274c.png" alt="&#10060;" class="wp-smiley" style="height: 1em; max-height: 1em;"/>xz</b> <b><img src="https://s0.wp.com/wp-content/mu-plugins/wpcom-smileys/twemoji/2/72x72/274c.png" alt="&#10060;" class="wp-smiley" style="height: 1em; max-height: 1em;"/>template</b> <b>&#10010;size=4G</b> <b>&#10010;format=qcow2</b></p>
<p>where <b><img src="https://s0.wp.com/wp-content/mu-plugins/wpcom-smileys/twemoji/2/72x72/274c.png" alt="&#10060;" class="wp-smiley" style="height: 1em; max-height: 1em;"/></b> means the tag MUST NOT exist in the final state.</p>
<p>I want my planner to find me the best path from my input state to my goal.  As it can&rsquo;t go straight from the input to the goal in one step, I have to tell the planner what <q>transitions</q> are possible, using a function:</p>
<pre>
transitions (input_tags) {
  if &#10010;xz then {
    you could run 'xzcat'
        which will &#10060;xz and &#10060;template;
  }
  else /* no xz tag */ {
    you could run 'virt-resize'
       which will change &#10010;format and &#10010;size, and &#10060;template;
    or:
    you could run 'qemu-img convert'
       which will change &#10010;format, and &#10060;template;
    or:
    etc...
  }

  or:
  you could run 'cp'
      which will &#10060;template;
}
</pre>
<p>Notice that the transitions function returns a list of all possible transitions from the input state.  It&rsquo;s not judgemental about which one should be taken, although it won&rsquo;t return impossible transitions (for example, running <code>virt-resize</code> is not possible on xz-compressed files).  The actual transitions function also returns a weight for each transition, so that the planner can choose the least expensive plan if there are several plans possible.</p>
<p>The <b>&#10010;template</b> tag may appear a bit mysterious.  It&rsquo;s there to make sure that the planner always copies the original template, even if the original template already has the desired goal size and format.  Since <code>xzcat</code>, <code>virt-resize</code> and <code>qemu-img convert</code> always copy the disk image, they drop the template tag (<b><img src="https://s0.wp.com/wp-content/mu-plugins/wpcom-smileys/twemoji/2/72x72/274c.png" alt="&#10060;" class="wp-smiley" style="height: 1em; max-height: 1em;"/>template</b>).</p>
<p>The transitions function in virt-builder can be found <a href="https://github.com/libguestfs/libguestfs/blob/62cc7d3361127b4e007f8e23028213852be09124/builder/builder.ml#L308">here</a>.</p>
<p>The planner does a breadth-first search over the tree of transitions, starting with the input state, finishing when it finds any branch that satisfies the output goals, or when it reaches a maximum depth in which case it gives up (and the user sees an error message).</p>
<p><img src="https://i0.wp.com/oirase.annexia.org/rwmj.wp.com/strips.svg" width="400"/></p>
<p>The planner in virt-builder (50 lines of code) can be found <a href="https://github.com/libguestfs/libguestfs/blob/62cc7d3361127b4e007f8e23028213852be09124/mllib/planner.ml#L28">here</a>.</p>
<p>If the planner finds several paths that satisfy the goals, the planner chooses the one with the smallest weight.  However my planner is not clever enough to look deeper in the tree to see if a longer path might have a smaller weight (it&rsquo;s not very likely in virt-builder).</p>
<p>Also my planner is not smart enough to prune bogus paths.  For example, if a path runs <code>cp</code> in adjacent steps, then that path should be pruned.</p>
<p>Nevertheless the planner always gets the right result, and it is considerably simpler than the original hand-written code.  The old code had become unmaintainable and wasn&rsquo;t even efficient: it sometimes made unnecessary copies in order to make the code simpler, wasting end-user time.  Because of the ease of maintenance I was able to add new functionality: virt-builder can now run <code>qemu-img resize</code> to expand a disk by &lt; 256&nbsp;MB, a case where virt-resize doesn&rsquo;t work (previously the user would have got an error).</p>
<p>Applying old academic techniques like this one doesn&rsquo;t need to be hard and can help with real world problems.  I hope this technique helps others with similar optimization problems.</p>
<p><b>Edit:</b> The <a href="https://news.ycombinator.com/item?id=6905887">Hacker News discussion</a> includes links to alternative solving tools.</p>


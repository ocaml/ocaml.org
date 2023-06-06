---
title: 'Half-baked ideas: C strings with implicit length field'
description: "For more half-baked ideas, see the ideas tag. If you prefer just to
  see the code, then it\u2019s here. Chris Siebenmann wrote a couple of interesting
  articles about C\u2019s null terminated strin\u2026"
url: https://rwmj.wordpress.com/2016/01/08/half-baked-ideas-c-strings-with-implicit-length-field/
date: 2016-01-08T17:12:06-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- rjones
---

<p><i>For more half-baked ideas, see <a href="https://rwmj.wordpress.com/tag/ideas/">the ideas tag</a>.</i></p>
<p><i>If you prefer just to see the code, then it&rsquo;s <a href="http://git.annexia.org/?p=ilenstr.git%3Ba=summary">here</a>.</i></p>
<p>Chris Siebenmann wrote a couple of interesting articles about <a href="https://utcc.utoronto.ca/~cks/space/blog/programming/CNullStringsDefense">C&rsquo;s null terminated strings</a> and <a href="https://utcc.utoronto.ca/~cks/space/blog/unix/UnixEarlyStrings">how they pre-date C</a>.</p>
<p>Chris notes an alternative is a length + string representation, as used in Pascal.  Although there are libraries for this in C, there are several drawbacks and approximately no one uses them.</p>
<p>However it&rsquo;s possible to have the best of both worlds: <b>Strings using an <i>implicit length field</i> that takes up no extra storage.  These strings are backwards compatible with ordinary C strings &mdash; you can literally pass them to legacy functions or cast them to <code>char&nbsp;*</code> &mdash; yet the equivalent of a strlen operation is O(1).</b></p>
<p>There are two ideas here: Firstly, when you use the C malloc function, <a href="https://stackoverflow.com/questions/5813078/is-it-possible-to-find-the-memory-allocated-to-the-pointer-without-searching-fo/5813450#5813450">malloc stashes some extra metadata about your allocation</a>, and with most malloc implementations there is a function to obtain the size of the allocation from a pointer.  In glibc, the function is called <code>malloc_usable_size</code>.  Note that because of alignment concerns, the amount allocated is usually larger than the amount you originally requested.</p>
<p>The second idea comes from OCaml.  <a href="https://rwmj.wordpress.com/2009/08/05/ocaml-internals-part-2-strings-and-other-types/">OCaml stores strings in a clever internal representation</a> which is both backwards compatible with C (a fancy way to say they are null terminated), and it allows you to get the real length of the string even though OCaml &mdash; like C &mdash; allocates more than requested for alignment reasons.</p>
<p>So here&rsquo;s how we do it: When allocating an &ldquo;implicit length string&rdquo; (<code>ilenstr</code>) we store extra data in the final byte of the &ldquo;full&rdquo; malloced space, in the byte marked <b>B</b> in the diagram below:</p>
<pre>
+-------------------------+----+------------+----+
| the string              | \0 |   ....     | B  |
+-------------------------+----+------------+----+
&lt;----- malloc we requested ----&gt;
&lt;----------- malloc actually allocated ----------&gt;
</pre>
<p>If malloc allocated exactly the same amount of space as is used by our string + terminating null, then B is simply the terminating <code>\0</code>:</p>
<pre>
+-------------------------+----+
| the string              | \0 |
+-------------------------+----+
</pre>
<p>If malloc allocated 1 spare byte, we store B = 1:</p>
<pre>
+-------------------------+----+----+
| the string              | \0 | 1  |
+-------------------------+----+----+
</pre>
<p>If malloc allocated 4 spare bytes, we store B = 4:</p>
<pre>
+-------------------------+----+----+----+----+----+
| the string              | \0 |   ....       | 4  |
+-------------------------+----+----+----+----+----+
</pre>
<p>Getting the true length of the string is simply a matter of asking malloc for the allocated length (ie. calling <code>malloc_usable_size</code>), finding the last byte (B) and subtracting it.  So we can get the true string length in an O(1) operation (usually, although this may depend on your malloc implementation).</p>
<p><code>ilenstr</code> strings can contain <code>\0</code> characters within the string.</p>
<p><code>ilenstr</code> strings are also backwards compatible, in that we can pass one to any &ldquo;legacy&rdquo; C function, and assuming the string itself doesn&rsquo;t contain any <code>\0</code> inside it, everything just works.</p>
<p>Alright.  This is terrible.  <b>DO NOT USE IT IN PRODUCTION CODE!</b>  It breaks all kinds of standards, is unportable etc.  There are security issues with allowing \0-containing strings to be passed to legacy functions.  Still, it&rsquo;s a nice idea.  With proper cooperation from libc, standards authorities and so on, it could be made to work.</p>
<p>Here is my git repo:</p>
<p><a href="http://git.annexia.org/?p=ilenstr.git%3Ba=summary">http://git.annexia.org/?p=ilenstr.git;a=summary</a></p>


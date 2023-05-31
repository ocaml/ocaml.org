---
title: ocaml 3.11 in testing
description:
url: http://upsilon.cc/~zack/blog/posts/2009/04/ocaml_3.11_in_testing/
date: 2009-04-06T13:17:11-00:00
preview_image:
featured:
authors:
- szacchiroli
---

<h1>OCaml 3.11 has migrated to testing</h1>
<p><a href="http://lists.debian.org/debian-ocaml-maint/2009/04/msg00029.html">Quoting</a>
from <a href="http://chistera.yi.org/~adeodato/blog/planetd.html">Dato</a>:</p>
<pre><code>* St&eacute;phane Glondu [Sat, 04 Apr 2009 14:01:35 +0200]:
&gt; Adeodato Sim&oacute; a &eacute;crit :
&gt; &gt;&gt; Please schedule the attached requests for the OCaml 3.11.0 transition.
&gt; &gt; Scheduled, with the glitches noted below. Please get back to us with the
&gt; &gt; needed wanna-build actions.
&gt; All packages that needed recompilation or sourceful uploads for the
&gt; OCaml 3.11.0 transition are now compiled and available in unstable.
&gt; I guess migrating ocaml to testing can now be considered...

This is now done:

ocaml  | 3.11.0-5 | testing
ocaml  | 3.11.0-5 | unstable

Congratulations for making of this transition one of the less painful
I&rsquo;ve ever had to deal with, though I guess being a quite self-contained
set of packages and not having ties to other ongoing
transitions really
helped. ;-)

Thanks!,
</code></pre>
<p>IOW <strong>OCaml 3.11 has just migrated to Debian
testing</strong> YAY \o/</p>
<p>Congrats and thanks to all the people who contributed. Special
kudos go to the (not so) newbies of the <a href="http://wiki.debian.org/Teams/OCamlTaskForce">Debian OCaml Task
Force</a>, and in particular to <em>Stephane Glondu</em> and
<em>Mehdi Dogguy</em>: they have contributed work to a lot of
packages and have also developed <a href="http://glondu.net/debian/ocaml_transition_monitor.html">new
tools</a> which helped monitoring the transition effectively.</p>
<p>Keep up the good work.</p>



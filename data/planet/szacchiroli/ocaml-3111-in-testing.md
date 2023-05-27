---
title: ocaml 3.11.1 in testing
description:
url: http://upsilon.cc/~zack/blog/posts/2009/08/ocaml_3.11.1_in_testing/
date: 2009-08-04T19:48:32-00:00
preview_image:
featured:
authors:
- szacchiroli
---

<h1>... and other Debian OCaml bits</h1>
<p>As <a href="http://blogs.turmzimmer.net/2009/08/03#squeeze-1">anticipated by
Aba</a>, today the <strong>OCaml 3.11.1 transition to testing has
finished</strong>. Beside turning the latest stable OCaml version
into a release-ready product, this transition has also
<strong>switched the standard library path</strong> to
<code>/usr/lib/ocaml</code> (it used to be
<code>/usr/lib/ocaml/X.Y.Z</code>). The change is justified by the
observation that, in fact, we have never supported (and never will)
more than one OCaml ABI at the same time in a given Debian
release.</p>
<p>Some more OCaml bit(s):</p>
<ul>
<li>
<p>during <a href="http://debconf9.debconf.org">DebCamp</a>, the
<a href="http://wiki.debian.org/Teams/OCamlTaskForce">OCaml
team</a> has worked on <strong>revising OCaml dependency
schema</strong>, on the basis of <a href="http://upsilon.cc/~zack/stuff/ocaml-debian-deps.pdf">a
proposal</a> I advanced a while ago. Once implemented, the proposal
in essence will mean:</p>
<ol>
<li>
<p>linkability ensured by regular Debian dependencies (no longer
&quot;inconsistent assumptions ...&quot; errors, as long as your package
manager is happy)</p>
</li>
<li>
<p>automatic computation of dependencies between OCaml-related
packages (i.e., <code>${ocaml:Depends}</code> substvar)</p>
</li>
</ol>
<p>Beside (maybe) some tiny teeny supervision bits, all the kudos
for that goes to Sylvain Le Gall, Mehdi Dogguy, and Stephane
Glondu; the 3 of them have worked tirelessly during all DebConf on
the design bits that were needing changes as well as on the
implementation / revamp of involved tools (e.g.
<code>dh_ocaml</code>, which I drafted (too) many years ago for not
being in production yet).<br/>
I guess you'll soon hear from them for more details.</p>
</li>
</ul>
<p>As observed by Stephane, the transition to the new schema and
tools do not need to be &quot;all or nothing&quot;.<br/>
Hence, the current plan is to release in Squeeze most of the
packages migrated to the new infrastructure, while not necessarily
all of them.</p>



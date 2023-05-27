---
title: Florian's OCaml compiler weekly, 11 April 2023
description:
url: http://gallium.inria.fr/blog/florian-compiler-weekly-2023-04-11
date: 2023-04-11T08:00:00-00:00
preview_image:
featured:
authors:
- gallium
---



  <p>This series of blog post aims to give a short weekly glimpse into my
(Florian Angeletti) daily work on the OCaml compiler. This week, the
focus is on the newly tagged OCaml 5.1 branch.</p>


  

<h3>A branch for OCaml 5.1</h3>
<p>Last week, I have mostly worked on preparing the branching of OCaml
5.1. Before creating the new branch I try to check that there are no new
features that are really on the fence to be integrated and that there
are no bugs that would hinder the CI process on the new branch.</p>
<p>For this new branch, it was the last point that was an unexpected
source of delays.</p>
<p>Indeed, during a refactoring of the parsetree AST (Abstract syntax
tree) I had introduced a bug in ocamldep that was not caught by CI tests
for ocamldep itself. However, once I updated the bootstrapped compiler
when cutting the new branch, the bug surfaced when compiling the
dependency graph of the compiler itself.</p>
<p>Consequently, I had to interrupt the publication of the new branch to
fix this issue in <a href="https://github.com/ocaml/ocaml/pull/12164">a
short pull request</a>. The fix was merged last week, and I have
published the fixed OCaml 5.1 branch today.</p>
<h3>Retrospective
on my work before OCaml 5.1 feature freeze</h3>
<p>Now that we have a branch for OCaml 5.1, the branch will only receive
bug fixes until the final release in summer (probably in July?). It thus
seems a good time to reflect a bit on my work in this first half of
OCaml 5.1 release cycle. Beware however that new features can still be
released before the first beta of OCaml 5.1.0.</p>
<p>Overall, I have reviewed 19 pull requests, written 9 pull requests
implementing new features, and 3 pull requests implementing bug
fixes.</p>
<p>Overall, the merged pull requests should provide an incremental but
noticeable improvement to error messages which where the main theme of
most the pull requests that I reviewed or authored.</p>
<h4>Reviewing pull requests</h4>
<p>Looking at my reviewed pull requests, I have indeed reviewed 9 pull
requests improving error messages. Then with 4 reviews, the type system
was another area where my work was focused.</p>
<h5>Error messages</h5>
<ul>
<li><p>Most of the improvements for error messages made the messages
more explicit by trying to present more contextual information to the
user:</p>
<ol type="1">
<li><p><a href="https://github.com/ocaml/ocaml/issues/11530">#11530</a>:
Include kinds in kind mismatch error message. (Leonhard Markert, review
by Gabriel Scherer and Florian Angeletti)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/11888">#11888</a>:
Improve the error message when type variables cannot be deduced from the
type parameters. (Stefan Muenzel, review by Florian Angeletti and
Gabriel Scherer)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/12051">#12051</a>:
Improve the error messages when type variables cannot be generalized
(Stefan Muenzel, review by Florian Angeletti)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/10818">#10818</a>:
Preserve integer literal formatting in type hint. (Leonhard Markert,
review by Gabriel Scherer and Florian Angeletti)</p></li>
</ol></li>
<li><p>Other pull requests improved the structure of the error messages
by making a better use of highlights and locations:</p>
<ol start="5" type="1">
<li><p><a href="https://github.com/ocaml/ocaml/issues/11679">#11679</a>:
Improve the error message about too many arguments to a function (Jules
Aguillon, review by Gabriel Scherer and Florian Angeletti)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/12116">#12116</a>:
Don&rsquo;t suggest to insert a semicolon when the type is not unit (Jules
Aguillon, review by Florian Angeletti)</p></li>
</ol></li>
<li><p>There were also two formatting improvements:</p>
<ol start="7" type="1">
<li><p><a href="https://github.com/ocaml/ocaml/issues/11646">#11646</a>:
Add colors to error message hints. (Christiana Anthony, review by
Florian Angeletti)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/12024">#12024</a>:
insert a blank line between separate compiler messages (Gabriel Scherer,
review by Florian Angeletti, report by David Wong)</p></li>
</ol></li>
<li><p>Finally, there was one improvement on the ability to
cross-reference the reference manual within error or warning
messages:</p>
<ol start="9" type="1">
<li><a href="https://github.com/ocaml/ocaml/issues/12125">#12125</a>:
Add Misc.print_see_manual and modify <span class="citation" data-cites="manual_ref">[@manual_ref]</span> to accept lists for simpler
printing of manual references (Stefan Muenzel, review by Florian
Angeletti)</li>
</ol></li>
</ul>
<h5>Type system</h5>
<p>On the type system side, I have most reviewed internal refactoring
changes that are probably not that user visible (even when they remove
some bugs).</p>
<ol start="10" type="1">
<li><p><a href="https://github.com/ocaml/ocaml/issues/6941">#6941</a>,
<a href="https://github.com/ocaml/ocaml/issues/11187">#11187</a>:
prohibit using classes through recursive modules inheriting or including
a class belonging to a mutually-recursive module would previous behave
incorrectly, and now results in a clean error. (Leo White, review by
Gabriel Scherer and Florian Angeletti)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/11912">#11912</a>:
Refactoring handling of scoped type variables (Richard Eisenberg, review
by Gabriel Scherer and Florian Angeletti)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/11569">#11569</a>:
Remove hash type encoding (Hyunggyu Jang, review by Gabriel Scherer and
Florian Angeletti)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/11984">#11984</a>:
Add dedicated syntax for generative functor application. Previously,
OCaml did not disinguish between <code>F ()</code> and
<code>F (struct end)</code>, even though the latter looks applicative.
Instead, the decision between generative and applicative functor
application was made based on the type of <code>F</code>. With this
patch, we now distinguish these two application forms; writing
<code>F (struct end)</code> for a generative functor leads to new
warning 73. (Frederic Bour and Richard Eisenberg, review by Florian
Angeletti)</p></li>
</ol>
<h5>Internal refactoring</h5>
<ol start="14" type="1">
<li><a href="https://github.com/ocaml/ocaml/issues/11745">#11745</a>:
Debugger and toplevels: embed printer types rather than reading their
representations from topdirs.cmi at runtime]. (S&eacute;bastien Hinderer,
review by Florian Angeletti, Nicol&aacute;s Ojeda B&auml;r and Gabriel Scherer)</li>
</ol>
<h5>CLI interface</h5>
<ol start="15" type="1">
<li><p><a href="https://github.com/ocaml/ocaml/issues/11653">#11653</a>:
Add the -no-absname option to ocamlc, ocamlopt and ocamldep. (Abiola
Abdulsalam, review by S&eacute;bastien Hinderer and Florian Angeletti)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/11696">#11696</a>:
Add the -no-g option to ocamlc and ocamlopt. (Abiola Abdulsalam, review
by S&eacute;bastien Hinderer, Nicol&aacute;s Ojeda B&auml;r and Florian Angeletti)</p></li>
</ol>
<h5>Standard library</h5>
<ol start="17" type="1">
<li><p><a href="https://github.com/ocaml/ocaml/issues/11128">#11128</a>:
Add In_channel.isatty, Out_channel.isatty. (Nicol&aacute;s Ojeda B&auml;r, review by
Gabriel Scherer and Florian Angeletti)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/12103">#12103</a>,
<a href="https://github.com/ocaml/ocaml/issues/12104">#12104</a>: fix a
concurrency memory-safety bug in Buffer (Gabriel Scherer, review by
Florian Angeletti, report by Samuel Hym)</p></li>
</ol>
<h5>Documentation</h5>
<ol start="19" type="1">
<li><a href="https://github.com/ocaml/ocaml/issues/11676">#11676</a>:
Fix missing since annotation in the <code>Sys</code> and
<code>Format</code> modules (Github user Bukolab99, review by Florian
Angeletti)</li>
</ol>
<h4>Authored feature pull
requests</h4>
<p>As it is was the case before the OCaml 5.0 multicore freeze, my
personal contribution was focused on error messages during the last
month with 5 pull requests on this thematic for a total of 9 pull
requests.</p>
<h5>Error messages</h5>
<ul>
<li><p>In particular, the new release will hopefully see an improvement
in the way that types are printed in error messages, both when
identifiers collide</p>
<ol type="1">
<li><p><a href="https://github.com/ocaml/ocaml/issues/11286">#11286</a>,
<a href="https://github.com/ocaml/ocaml/issues/11515">#11515</a>:
disambiguate identifiers by using how recently they have been bound in
the current environment (Florian Angeletti, review by Gabriel
Scherer)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/11910">#11910</a>:
Simplify naming convention for shadowed or ephemeral identifiers in
error messages (eg:
<code>Illegal shadowing of included type t/2 by t</code>) (Florian
Angeletti, review by Jules Aguillon)</p></li>
</ol></li>
<li><p>or when a weak row type variable rears its head:</p>
<ol start="3" type="1">
<li><a href="https://github.com/ocaml/ocaml/issues/12107">#12107</a>:
use aliases to mark weak row variables: <code>_[&lt; ... ]</code>,
<code>&lt; _..&gt;</code>, <code>_#ct</code> are now rendered as
<code>[&lt; ...] as '_weak1</code> ,
<code>&lt; .. &gt; as '_weak1</code>, and <code>#ct as '_weak1</code>.
(Florian Angeletti, suggestion by Stefan Muenzel, review by Gabriel
Scherer)</li>
</ol></li>
<li><p>I also implemented or participated to two relatively small
improvement on warnings:</p>
<ol start="4" type="1">
<li><p><a href="https://github.com/ocaml/ocaml/issues/11235">#11235</a>,
<a href="https://github.com/ocaml/ocaml/issues/11864">#11864</a>: usage
warnings for constructors and fields can now be disabled on
field-by-field or constructor-by-constructor basis (Florian Angeletti,
review by Gabriel Scherer)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/10931">#10931</a>:
Improve warning 14 (illegal backslash) with a better explanation of the
causes and how to fix it. (David Allsopp, Florian Angeletti, Lucas De
Angelis, Gabriel Scherer, review by Nicol&aacute;s Ojeda B&auml;r, Florian
Angeletti, David Allsopp and Gabriel Scherer)</p></li>
</ol></li>
</ul>
<h5>OCamldoc maintenance</h5>
<p>I still keep maintaining ocamldoc in a minimal working state, but I
hope to switch to odoc for the manual in time for the release of OCaml
5.1 .</p>
<ol start="6" type="1">
<li><p><a href="https://github.com/ocaml/ocaml/issues/11889">#11889</a>,
<a href="https://github.com/ocaml/ocaml/issues/11978">#11978</a>:
ocamldoc: handle injectivity annotations and wildcards in type
parameters. (Florian Angeletti, report by Wiktor Kuchta, review by Jules
Aguillon)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/12165">#12165</a>:
ocamldoc, use standard doctype to avoid quirk mode. (Florian Angeletti,
review by Gabriel Scherer)</p></li>
</ol>
<h5>Documentation</h5>
<ol start="8" type="1">
<li><a href="https://github.com/ocaml/ocaml/issues/12028">#12028</a>:
Update format documentation to make it clearer that
<code>pp_print_newline</code> flushes its newline (Florian Angeletti,
review by Gabriel Scherer)</li>
</ol>
<h5>Internal refactoring</h5>
<ol start="9" type="1">
<li><a href="https://github.com/ocaml/ocaml/issues/12119">#12119</a>:
mirror type constraints on value binding in the parsetree: the
constraint <code>typ</code> in <code>let pat : typ = exp</code> is now
directly stored in the value binding node in the parsetree. (Florian
Angeletti, review by Richard Eisenberg)</li>
</ol>
<h4>Authored bug fixes:</h4>
<ul>
<li><p>Least but not last, I have fixed two of my mistakes in previous
pull requests</p>
<ol type="1">
<li><p><a href="https://github.com/ocaml/ocaml/issues/11450">#11450</a>,
<a href="https://github.com/ocaml/ocaml/issues/12018">#12018</a>: Fix
erroneous functor error messages that were too eager to cast
<code>struct end</code> functor arguments as unit modules in
<code>F(struct end)</code>. (Florian Angetti, review by Gabriel
Scherer)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/12061">#12061</a>,
<a href="https://github.com/ocaml/ocaml/issues/12063">#12063</a>: don&rsquo;t
add inconsistent equalities when computing high-level error messages for
functor applications and inclusions. (Florian Angeletti, review by
Gabriel Scherer)</p></li>
</ol></li>
<li><p>and fixed what was maybe one of the fastest bug to trigger in
OCaml history</p>
<ol start="3" type="1">
<li><a href="https://github.com/ocaml/ocaml/issues/11824">#11824</a>:
Fix a crash when calling <code>ocamlrun -b</code> (Florian Angeletti,
review by S&eacute;bastien Hinderer)</li>
</ol></li>
</ul>
<p>since the bug did not require any code source to trigger.</p>


  

---
title: OCaml App for iOS 8.1 (Sources)
description:
url: http://psellos.com/2014/12/2014.12.ocaml-portland-app.html
date: 2014-12-14T19:00:00-00:00
preview_image:
featured:
authors:
- Psellos
---

<div class="date">December 14, 2014</div>

<p>I coded up a simple OCaml iOS app to run in iOS 8.1. Instructions for
downloading, building, and running the app are here:</p>

<blockquote>
  <p><a href="http://psellos.com/ocaml/example-app-portland.html">Portland: Which Way Is Up on iOS?</a></p>
</blockquote>

<p>You can download the sources directly here:</p>

<blockquote>
  <p><a href="http://psellos.com/pub/portland/portland-ios-2.0.3.tgz">Portland 2.0.3, OCaml app for iOS 8.1 (29 KB)</a></p>
</blockquote>

<p>This is a revamped version of Portland, the first example OCaml iOS app
I made a few years ago. For maximum clarity it doesn&rsquo;t do anything
particularly impressive. It really just shows how to code an iOS app in
OCaml.</p>

<p>Here are some things I learned while revamping.</p>

<ul>
<li><p>Remember to call <code>caml_main()</code> in your main program (see <code>main.m</code>). If
you forget, you&rsquo;ll get the &ldquo;undefined atom table&rdquo; error at link time.
I wrote about this in <a href="http://psellos.com/2014/10/2014.10.atom-table-undef.html">Undefined caml_atom_table</a>.</p></li>
<li><p>If you keep disembodied OCaml values in the Objective C world,
remember to register them as global roots using
<code>caml_register_global_root</code>. Otherwise you&rsquo;ll experience chaos at the
first GC. I wrote about this in <a href="http://psellos.com/2014/12/2014.12.objc-rule-four.html">OCaml, Objective C, Rule 4</a>.</p></li>
<li><p>Automatic Reference Counting imposes some restrictions on what you can
do in wrapper code. For the Portland example (and probably for many
real-world apps) it&rsquo;s enough to have a table of Objective C objects
that are conceptually referenced from OCaml. That is, the table in the
Objective C world references the objects as a proxy for references
from the OCaml world. You can see the code for this in <code>wrap.m</code>. I
hope to write more about this. Maybe you, reader, have some ideas for
a better approach.</p></li>
<li><p>Modern day iOS apps are based on View Controllers rather than on
Views. In particular, it&rsquo;s usual to define a custom subclass of
<code>UIViewController</code> for each piece of the interface. This is tricky for
OCaml on iOS, as it&rsquo;s not (currently) possible to define an OCaml
subclass of an Objective C class. For Portland I&rsquo;m using an Objective
C subclass of <code>UIViewController</code> that delegates to an OCaml object.
Here too, this is probably good enough for many real-world apps. I
hope to write more about this also.</p></li>
<li><p>There are several cyclic dependencies among the classes of Cocoa
Touch used in Portland. To represent them in OCaml I use a common set
of definitions named <code>ui.mli</code>, where the cycles can be accommodated
using <code>class type a =</code> &hellip; <code>and b =</code> &hellip; . It seems to me this is a
strength of OCaml&rsquo;s structural typing for objects. That is, it&rsquo;s
possible to define class types independently of particular classes. In
this way cycles can be represented without forward-reference
loopholes. (However it&rsquo;s possible that the number of cycles in a full
interface to Cocoa Touch would become overwhelming.)</p></li>
</ul>

<p>It&rsquo;s dark, chilly, and wet here by Puget Sound; I&rsquo;m going to retire now
to my tent and my dreams. The next thing on my OCaml-on-iOS schedule is
to update to the latest OCaml compiler. I&rsquo;m getting serious polymathic
help on this, as I hope you&rsquo;ll hear about soon.</p>

<p>If you have any trouble (or success) with the Portland app, or have any
other comments, leave them below or email me at <a href="mailto:jeffsco@psellos.com">jeffsco@psellos.com</a>.</p>

<p>Posted by: <a href="http://psellos.com/aboutus.html#jeffreya.scofieldphd">Jeffrey</a></p>

<p></p>


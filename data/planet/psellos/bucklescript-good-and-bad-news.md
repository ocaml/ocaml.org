---
title: BuckleScript Good and Bad News
description:
url: http://psellos.com/2020/08/2020.08.east-van-girls.html
date: 2020-08-26T19:00:00-00:00
preview_image:
featured:
authors:
- Psellos
---

<div class="date">August 26, 2020</div>

<p>Since last year I&rsquo;ve been using BuckleScript to build web apps in OCaml
and have been enjoying it very much. However, when I went to the
project&rsquo;s home page recently I found that BuckleScript has been renamed
to <a href="http://rescript-lang.org/">ReScript</a> and that all reference to OCaml
has been removed from the project (as far as I can tell).</p>

<p>In particular, there&rsquo;s no documentation that describes how to use the
standard OCaml syntax with the BuckleScript compiler. Previously there
were parallel documents for a new JavaScript-like syntax (based on
Reason) and for the standard OCaml syntax. But now there is just a
JavaScript-like syntax (different from but similar to Reason).</p>

<table class="morelikealist" style="margin-top: 0.4em;">
<tr><td>
<a href="http://psellos.com/ocaml/example-app-slide24.html">
<img src="http://psellos.com/images/slide242-220-sepia.png"/><br/>
</a>
</td></tr>
</table>

<p>Although the project
<a href="http://reasonml.org/blog/a-note-on-bucklescripts-future-commitments">blog</a>
says they will continue to support the OCaml syntax for a long time, in
practice it will be impossible to use OCaml syntax with BuckleScript
unless there is documentation. There&rsquo;s no way to determine the methods
used for interoperation with the browser environment. Guessing and
on-line chat are not workable replacements.</p>

<p>Unless documentation appears pretty soon, I can&rsquo;t really recommend using
BuckleScript if you want to build web apps using OCaml syntax. Since I&rsquo;d
like my work to be at least a little bit useful to others, I&rsquo;ll most
likely be switching to
<a href="https://ocsigen.org/js_of_ocaml/3.1.0/manual/overview">Js_of_OCaml</a> for
future work.</p>

<p>The good news (such as it is) is that OCaml syntax still does work with
the BuckleScript compiler. I rewrote the Slide24 example to work with
the latest BuckleScript release I could find (version 8.2.0), and it
works as well as ever. But it was a bittersweet, nostalgic experience.
(Unless, as I say, the BuckleScript team is willing to document the
OCaml syntax interoperation interfaces.)</p>

<p>While I was at it, I spent a few days reading up on heuristic search
methods (on Wikipedia). I was able to improve the solutions produced by
the <em>Solve</em> button significantly using ideas from the <a href="http://en.wikipedia.org/wiki/Fringe_search">fringe
search</a> page. These newest
solutions are getting a little closer to the inhumanly awesome solutions
I have been hoping to see.</p>

<p>You can try out the puzzle and get the sources at the
<a href="http://psellos.com/ocaml/example-app-slide24.html">Slide24</a> page.</p>

<p>Posted by: <a href="http://psellos.com/aboutus.html#jeffreya.scofieldphd">Jeffrey</a></p>

<p></p>


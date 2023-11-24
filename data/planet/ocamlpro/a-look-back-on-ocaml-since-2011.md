---
title: A look back on OCaml since 2011
description: "A look back on OCaml since 2011 As you already know if you\u2019ve read
  our last blogpost, we have updated our OCaml cheat sheets starting with the language
  and stdlib ones. We know some of you have students to initiate in September and
  we wanted these sheets to be ready for the start of the school yea..."
url: https://ocamlpro.com/blog/2019_09_20_look_back_ocaml_since_2011
date: 2019-09-20T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Thomas Blanc\n  "
source:
---

<p><a href="https://ocamlpro.com/blog/2019_09_20_look_back_ocaml_since_2011"><img src="https://ocamlpro.com/blog/assets/img/ocaml-2011-e1600870731841.jpeg" alt="A look back on OCaml since 2011"/></a></p>
<p>As you already know if you&rsquo;ve read <a href="https://ocamlpro.com/blog/2019_09_13_updated_cheat_sheets_language_stdlib_2">our last blogpost</a>, we have updated our OCaml cheat sheets starting with the language and stdlib ones. We know some of you have students to initiate in September and we wanted these sheets to be ready for the start of the school year! We&rsquo;re working on more sheets for OCaml tools like opam or Dune and important libraries such as ~~Obj~~ Lwt or Core. Keep an eye on our blog or the <a href="https://github.com/OCamlPro/ocaml-cheat-sheets">repo on GitHub</a> to follow all the updates.</p>
<p>Going through the documentation was a journey to the past: we have looked back on 8 years of evolution of the OCaml language and library. New feature after new feature, OCaml has seen many changes. Needless to say, upgrading our cheat sheets to OCaml 4.08.1 was a trip down memory lane. We wanted to share our throwback experience with you!</p>
<h2>2011</h2>
<p>Fabrice Le Fessant first published our cheat sheets in 2011, the year OCamlPro was created! At the time, OCaml was in its 3.12 version and just <a href="https://inbox.ocaml.org/caml-list/E49008DC-30C0-4B22-9939-85827134C8A6@inria.fr/">got its current name</a> agreed upon. <a href="https://caml.inria.fr/pub/docs/manual-ocaml/manual028.html">First-class modules</a> were the new big thing, Camlp4 and Camlp5 were battling for the control of the syntax extension world and Godi and Oasis were the packaging rage.</p>
<h2>2012</h2>
<p>Right after 3.12 came the switch to OCaml 4.00 which brought a major change: <a href="https://caml.inria.fr/pub/docs/manual-ocaml/manual033.html">GADTs</a> (generalized algebraic data types). Most of OCaml&rsquo;s developers don&rsquo;t use their almighty typing power, but the possibilities they provide are really helpful in some cases, most notably the format overhaul. They&rsquo;re also a fun way to troll a beginner asking how to circumvent the typing system on Stack Overflow. Since most of us might lose track of their exact syntax, GADTs deserve their place in the updated sheet (if you happen to be OCamlPro&rsquo;s CTO, <em>of course</em> the writer of this blogpost remembers how to use GADTs at all times).</p>
<p>On the standard library side, the big change was the switch of <code>Hashtbl</code> to Murmur 3 and the support for seeded randomization<a href="https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2012-0839">.</a></p>
<h2>2013</h2>
<p>With OCaml 4.01 came <a href="https://github.com/ocaml/ocaml/issues/5759">constructor disambiguation</a>, but there isn&rsquo;t really a way to add this to the sheet. This feature allows you to avoid misguided usage of polymorphic variants, but that&rsquo;s a matter of personal taste (there&rsquo;s a well-known rule that if you refresh the comments section enough times, someone &mdash;usually called Daniel&mdash; will appear to explain polymorphic variants&rsquo; superiority to you). <code>-ppx</code> rewriters were introduced in this version as well.</p>
<p>The standard library got a few new functions. Notably, <code>Printexc.get_callstack</code> for stack inspection, the optimized application operators <code>|&gt;</code> and <code>@@</code> and <code>Format.asprintf</code>.</p>
<h2>2014</h2>
<p><em>Gabriel Scherer, on the Caml-list, end of January:</em></p>
<blockquote>
<p>TL;DR: During the six next months, we will follow pull requests (PR) posted on the github mirror of the OCaml distribution, as an alternative to the mantis bugtracker. This experiment hopes to attract more people to participate in the extremely helpful and surprisingly rewarding activity of patch reviews.</p>
</blockquote>
<p>Can you guess which change to the cheat-sheets came with 4.02? It&rsquo;s a universally-loved language feature added in 2014. Still don&rsquo;t know? It is <em>exceptional</em>! Got it?</p>
<p>Drum roll&hellip; it is the <code>match with exception</code> <a href="https://caml.inria.fr/pub/docs/manual-ocaml/patterns.html#sec131">construction</a>! It made our codes simpler, clearer and in some cases more efficient. A message to people who want to improve the language: please aim for that.</p>
<p>This version also added the <code>{quoted|foo|quoted}</code> <a href="https://caml.inria.fr/pub/docs/manual-ocaml/lex.html#string-literal">syntax</a> (which broke comments), generative functors, attributes and <a href="https://caml.inria.fr/pub/docs/manual-ocaml/manual036.html">extension nodes</a>, extensible data types, module aliases and, of course, immutable strings (which was optional at the time). Immutable strings is the one feature that prompted us to <em>remove</em> a line from the cheat sheets. More space is good. Camlp4 and Labltk moved out of the distribution.</p>
<p>In consequence of immutable strings, <code>Bytes</code> and <code>BytesLabel</code> were added to the library. For the great pleasure of optimization addicts, <code>raise_notrace</code> popped up. Under the hood, the <code>format</code> type was re-implemented using GADTs.</p>
<h2>2015</h2>
<p>This release was so big that 4.02.2 feels like a release in itself, with the adding of <code>nonrec</code> and <code>#...</code> operators.</p>
<p>The standard library was spared by this bug-fix themed release. Note that this is the last comparatively slow year of OCaml as the transition to GitHub would soon make features multiply, as hindsight teaches us.</p>
<h2>2016</h2>
<p>Speaking of a major release, we&rsquo;re up to OCaml 4.03! It introduced <a href="https://caml.inria.fr/pub/docs/manual-ocaml/manual040.html">inline records</a>, a GADT exhaustiveness check on steroids (with <code>-&gt; .</code> to denote unreachability) and standard attributes like <code>warning</code>, <code>inlined</code>, <code>unboxed</code> or <code>immediate</code>. Colors appeared in the compiler and last but not least, it was the dawn of a new option called <a href="http://ocamlpro.com/tag/flambda2-en/">Flambda</a>.</p>
<p>The library saw a lot of useful new functions coming in: lots of new iterators for <code>Array</code>, an <code>equal</code> function in most basic type modules, <code>Uchar</code>, the <code>*_ascii</code> alternatives and, of course, <code>Ephemeron</code>.</p>
<p>4.04 was much more restrained, but it was the second release in a single year. Local opening of module with the <code>M.{}</code> syntax was added along with the <code>let exception ...</code> in construct. <code>String.split_on_char</code> was notably added to the stdlib which means we don&rsquo;t have to rewrite it anymore.</p>
<h2>2017</h2>
<p>We now get to 4.05&hellip; which did not change the language. Not that the development team wasn&rsquo;t busy, OCaml just got better without any change to the syntax.</p>
<p>On the library side however, much happened, with the adding of <code>*_opt</code> functions pretty much everywhere. If you&rsquo;re using the OCaml compiler from <a href="https://packages.debian.org/sid/ocaml">Debian</a>, this is where you might think the story ends. You&rsquo;d be wrong&hellip;</p>
<p>&hellip;because 4.06 added a lot! My own favorite feature from this release has to be user-defined <a href="https://caml.inria.fr/pub/docs/manual-ocaml/manual042.html">indexing operators</a>. This is also when <code>safe-string</code> became the default, giving worthwhile work to every late maintainer in the community. This release also added one awesome function in the standard library: <code>Map.update</code>.</p>
<h2>2018</h2>
<p>4.07 was aimed towards solidifying the language. It added empty variants and type-based selection of GADT constructors to the mix.</p>
<p>On the library side, one old and two new modules were added, with the integration of <code>Bigarray</code>, <code>Seq</code> and <code>Float</code>.</p>
<h2>2019</h2>
<p>And here we are with 4.08, in the present day! We can now put exceptions under or-patterns, which is the only language change from this release we propagated to the sheet. Time will tell if we need to add custom <a href="https://caml.inria.fr/pub/docs/manual-ocaml/manual046.html">binding operators</a> or <code>[@@alert]</code>. <code>Pervasives</code> is now deprecated in profit of <code>Stdlib</code> and new modules are popping up (<code>Int</code>, <code>Bool</code>, <code>Fun</code>, <code>Result</code>&hellip; did we miss one?) while <code>Sort</code> made its final deprecation warning.</p>
<p>We did not add 4.09 to this journey to the past, as this release is still solidly in the <em>now</em> at the time of this blogpost. Rest assured, we will see much more awesome features in OCaml in the future! In the meantime, we are working on updating more cheat sheets: keep posted!</p>
<h1>Comments</h1>
<p>Micheal Bacarella (23 September 2019 at 18 h 17 min):</p>
<blockquote>
<p>For a blog-post from a company called OCaml PRO this seems like a rather tone-deaf PR action.</p>
<p>I wanted to read this and get hyped but instead I&rsquo;m disappointed and I continue to feel like a chump advocating for this language.</p>
<p>Why? Because this is a rather underwhelming summary of <em>8 years</em> of language activity. Perhaps you guys didn&rsquo;t intend for this to hit the front of Hacker News, and maybe this stuff is really exciting to programming language PhDs, but I don&rsquo;t see how the average business OCaml developer would relate to many of these changes at all. It makes OCaml (still!) seem like an out-of-touch academic language where the major complaints about the language are ignored (multicore, Windows support, programming-in-the-large, debugging) while ivory tower people fiddle with really nailing type-based selection in GADTs.</p>
<p>I expect INRIA not to care about the business community but aren&rsquo;t you guys called OCaml PRO? I thought you <em>liked</em> money.</p>
<p>You clearly just intended this to be an interesting summary of changes to your cheatsheet but it&rsquo;s turned into a PR release for the language and leaves normals with the continued impression that this language is a joke.</p>
</blockquote>
<p>Thomas Blanc (24 September 2019 at 14 h 57 min):</p>
<blockquote>
<p>Yes, latency can be frustrating even in the OCaml realm. Thanks for your comment, it is nice to see people caring about it and trying to remedy through contributions or comments.</p>
<p>Note that we only posted on discuss.ocaml.org expecting to get one or two comments. The reason for this post was that while updating the CS we were surprised to see how much the language had changed and decided to write about it.</p>
<p>You do raise some good points though. We did work on a full windows support back in the day. The project was discontinued because nobody was willing to buy it. We also worked on memory profiling for the debugging of memory leaks (before other alternatives existed). We did not maintain it because the project had no money input. I personally worked on compile-time detection of uncaught exception until the public funding of that project ran out. We also had a proposal for namespaces in the language that would have facilitated programming-in-the-large (no funding) and worked on multicore (funding for one man for one year).</p>
</blockquote>


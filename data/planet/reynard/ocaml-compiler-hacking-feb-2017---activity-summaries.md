---
title: OCaml Compiler Hacking Feb 2017 - Activity Summaries
description:
url: http://reynard.io/2017/02/10/CompHackSummary.html
date: 2017-02-10T00:00:00-00:00
preview_image:
featured:
authors:
- reynard
---

<p>Thanks to everyone who joined us for a relaxed but productive evening of <a href="https://ocamllabs.github.io/compiler-hacking/">OCaml compiler hacking</a> on Tuesday 7th February. We focussed on fixing bugs and tidying up documentation during this session, and we had a high proportion of people who are relatively new to OCaml getting stuck into the internals.</p>

<div>
<img src="http://reynard.io/images/FebCHPembroke.JPG" style="float:right; -webkit-transform:rotate(90deg); transform:rotate(90deg);" alt="Olivier, Maxime, David and Fred talk all things compiler" width="200"/>
</div>

<h3>Compiler Projects</h3>

<ul>
  <li>
    <p>Mark Shinwell focussed on the next version of <a href="https://blogs.janestreet.com/flambda/">Flambda</a>.</p>
  </li>
  <li>
    <p>Olivier Nicole and Maxime Lesourd continued with their work on a <a href="https://github.com/ocamllabs/compiler-hacking/wiki/Things-to-work-on#signatured-open-command">signatured open command</a>. They didn&rsquo;t quite manage to finish it, but spent some time thinking of the best way to implement it <a href="https://github.com/OlivierNicole/ocaml/commits/signatured_open">here</a>.</p>
  </li>
</ul>

<h3>Bug Fixing</h3>

<ul>
  <li>
    <p>Tadeu Zagallo from <a href="https://www.uber.com/en-GB/cities/london/">Uber</a> <a href="http://reynard.io/2016/11/16/CompHack.html">returned</a> with increased OCaml knowledge and found a fix for <a href="https://caml.inria.fr/mantis/view.php?id=7060">printing exceptions that happen within custom printers installed in the OCaml toplevel</a> (which are currently being swallowed). A PR will be on the way soon for review.</p>
  </li>
  <li>
    <p>Marek Bern&aacute;t from <a href="http://metail.com/">Metail</a> joined us for the first time to learn more about OCaml, and perused some Mantis bugs. He worked on finding a fix for <a href="https://caml.inria.fr/mantis/view.php?id=6604">expressions ignored by the toplevel and compiler</a> and prepared a change that issues warnings when the line directive is found in inappropriate positions or with inappropriate arguments. A PR will be incoming soon - this is great progress for a first session, with little prior understanding of the OCaml compiler!</p>
  </li>
</ul>

<h3>Documentation</h3>

<ul>
  <li>Dhruv Makwana worked on updating our <a href="https://github.com/ocamllabs/ocaml-internals/wiki">compiler documentation</a> by starting writing up about the <a href="https://github.com/ocamllabs/ocaml-internals/wiki/The-Parse-Tree-(AST)">Parse Tree</a>, and completing the <a href="https://github.com/ocamllabs/ocaml-internals/wiki/Source-code">Source Code</a> section.</li>
</ul>

<h3>Other projects</h3>

<ul>
  <li>Frederic Bour worked on some <a href="https://github.com/ocaml/merlin">Merlin</a> fixes, specifically:
    <ul>
      <li>Emacs mode rewrite fixes:
        <ul>
          <li>To do syntax highlighting, merlin-mode checks if tuareg-mode or caml-mode are enabled and use the same mode for highlighting information reported to the user. Mode detection was broken, hence no more colors in Merlin interactions. This is fixed.</li>
          <li>A simple heuristic determines whether information should be reported in mini-buffer or in a split window: 8 lines or less go into the mini-buffer, anything bigger goes into its own window. Except this check was mostly ignored and everything went to minibuffer.</li>
        </ul>
      </li>
      <li>General OCaml-Merlin fixes:
        <ul>
          <li>When completing an identifier, Merlin didn&rsquo;t put parentheses around operators (e.g when completing <code class="highlighter-rouge">Monad.(&gt;&gt;=)</code>. Now it checks whether the completion is a qualified operator and add parentheses accordingly.</li>
        </ul>
      </li>
    </ul>
  </li>
</ul>

<p>He also managed to finally track a tricky regression he&rsquo;d been chasing for some time: When asking for the signature of a module alias or when asking for the type of an expression, Merlin would just refuse to load a module. It turned out to be related to the printing of types in the compiler(!). short-path is a feature that finds the shortest alias that refer to a given type. This is mostly useful with large libraries, such as Core or Async, where canonical names of types can be very long. Previous versions of the compiler would load new modules to look for shorter names, causing <a href="https://caml.inria.fr/mantis/view.php?id=7134">inconsistent behaviors</a>, (depending on modules that are not directly used by the current file).
So a new feature, <code class="highlighter-rouge">Env.without_cmis</code> prevent the compiler from loading new modules when in &ldquo;printing mode&rdquo;. This broke Merlin which roughly works this way: read input file, set the printing environment to where the user cursor is, then process the query. So any query requiring the use of new modules would fail. That&rsquo;s no longer the case thanks to <code class="highlighter-rouge">Env.with_cmis</code> when a module is really needed.</p>

<ul>
  <li>
    <p>Christian Lindig and I talked about his plans to use some <a href="https://github.com/ocaml/opam">OPAM</a> features in his next project at Citrix - Thomas Gazagnaire will follow up.</p>
  </li>
  <li>
    <p>Takayuki Imada continued with delving into <a href="https://github.com/TImada">MirageOS performance</a>, specifically looking at if and how server-side virtualisation might be a factor.</p>
  </li>
  <li>
    <p>Ciaran Lawlor and Matt Harrison were busy with their Part II projects and preparing for presentations next week. Ciaran is working on incremental parsing under the supervision of Stephen Dolan, whilst Matt&rsquo;s project aims to provide secure, user-controlled sharing of personal data. Matt is supervised by KC Sivaramakrishnan and is linked with the <a href="http://www.databoxproject.uk/">Databox</a> project.</p>
  </li>
</ul>


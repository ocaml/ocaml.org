---
title: OCaml Weekly 2025 w29
description:
url: https://patrick.sirref.org/ocaml-weekly-2025-w29/
date: 2025-07-15T00:00:00-00:00
preview_image:
authors:
- https://patrick.sirref.org/Patrick%20Ferris/
source:
ignore:
---


        <section>
          <header>
            <h2>Ppxlib</h2>
          </header>
          <p>I met with <a href="https://patrick.sirref.org/nathanreb/">Nathan</a> this week to discuss future plans for <a href="https://patrick.sirref.org/ppxlib/">ppxlib</a>. The current state of affairs is that <a href="https://patrick.sirref.org/ppxlib/">ppxlib</a> is becoming unmaintainable. This is primarily a knock-on effect from changes being made to OCaml's parsetree (e.g. labelled tuples being added in 5.4).  <a href="https://patrick.sirref.org/nathanreb/">Nathan</a> has a plan that will provide two key properties.</p>
          <ol>
            <li>
              <p>Migrations, which allow old compilers to be used with new <a href="https://patrick.sirref.org/ppxlib/">ppxlib</a> releases, will be more compatible. For example, we will be able to migrate new features downwards and back up without raising an error.</p>
            </li>
            <li>
              <p>Ppx authors will be able to use new features in an opt-in workflow, rather than <a href="https://patrick.sirref.org/ppxlib/">ppxlib</a> bumping the internal AST (like we did <a href="https://patrick.sirref.org/ppxlib-5-2/">in ppxlib.0.36.0</a>). This will reduce the maintenance burden  significantly whilst still allowing users to write ppxes for new OCaml features.</p>
            </li>
          </ol>
          <p>I also started looking into some older issues in <a href="https://patrick.sirref.org/ppxlib/">ppxlib</a> related to performance. This is work-in-progress, but I am trying to improve the performance of some passes done by <a href="https://patrick.sirref.org/ppxlib/">ppxlib</a>. To better understand what was making <a href="https://patrick.sirref.org/ppxlib/">ppxlib</a> slow, I wanted to use <a href="https://github.com/tarides/runtime_events_tools">runtime_events_tools</a> but I was dismayed to see it wanting to install over 100 packages! I <a href="https://github.com/tarides/runtime_events_tools/pull/57">opened a PR to reduce the number of packages</a>. I think this kind of work goes a little unrecognised as it is not very glamorous. However, I think it really benefits the OCaml community in the long run.</p>
        </section>
        <section>
          <header>
            <h2>Outreachy</h2>
          </header>
          <p>In <a href="https://patrick.sirref.org/outreachy/">Outreachy</a> news, we had a wonderful mid-internship video call with all the interns and mentors to catch-up on how everyone is getting along. Seeing the progress everyone has made was great! I am very grateful for the work that <a href="https://patrick.sirref.org/mdales/">Michael</a> and <a href="https://github.com/gridbugs">Steve</a> have put in so far to make this a very successful Outreachy round for OCaml.</p>
          <p>In sadder news, an email was shared with all <a href="https://patrick.sirref.org/outreachy/">Outreachy</a> mentors detailing the increasingly critical financial situation the project finds itself in. There are ongoing discussions about how costs can be cut including potentially only running a single round a year.</p>
        </section>
        <section>
          <header>
            <h2>Graft</h2>
          </header>
          <p>With the release of <a href="https://patrick.sirref.org/Forester/">Forester.5.0</a>, I made a plan to make a release of <a href="https://patrick.sirref.org/Graft/">Graft.0.1</a>. Unfortunately this is blocked by a new release of <a href="https://github.com/ocaml/opam-repository/pull/28172">hilite</a>, a tool I built for doing build-time syntax highlighting for OCaml code. This powers the syntax highlighting on <a href="https://ocaml.org/">ocaml.org</a>.</p>
        </section>
      

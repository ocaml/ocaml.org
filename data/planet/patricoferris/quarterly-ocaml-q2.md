---
title: Quarterly OCaml Q2
description:
url: https://patrick.sirref.org/ocaml-quarterly-q2/
date: 2025-07-18T00:00:00-00:00
preview_image:
authors:
- https://patrick.sirref.org/Patrick%20Ferris/
source:
ignore:
---


        <p>Thanks to <a href="https://patrick.sirref.org/tarides/">Tarides</a> sponsorship, I get to work on open-source OCaml. This quarterly is a companion to my <a href="https://patrick.sirref.org/weeklies/">weeklies</a>, summarising the last three months of development, peppered with ideas and thoughts about OCaml, its community and its future.</p>
        <section>
          <header>
            <h2>What I wanted to work on?</h2>
          </header>
          <p>There were two main things I hoped to <em>continue</em> working on: <strong>ppxlib</strong> and <strong>outreachy</strong>. These are projects that I was previously working on, and in the case of Outreachy I have now been involved for many years.</p>
          <p>In addition to this, all of my <a href="https://patrick.sirref.org/part-ii-2024/">Part II</a> projects this year used OCaml in some regard. In general, I want to see more adoption of OCaml. Over the years this has taken many forms including <a href="https://ocaml-explore.netlify.app/">my initial work on developing workflows for OCaml that just turned five years old</a>. This directly fed into the rebranding and rethinking of <a href="https://ocaml.org/">ocaml.org</a> itself.</p>
        </section>
        <section>
          <header>
            <h2>What I worked on?</h2>
          </header>
          <section>
            <header>
              <h3>Ppxlib</h3>
            </header>
            <p><a href="https://patrick.sirref.org/ppxlib/">Ppxlib</a> is the de facto standard library for building OCaml preprocessors. At the time of writing, <code>opam list --depends-on=ppxlib</code> informs me that there are 267 reverse dependencies. <a href="https://www.janestreet.com/">Janestreet</a> is a heavy user of ppxes and has <a href="https://github.com/orgs/janestreet/repositories?language=&amp;q=ppx&amp;sort=&amp;type=all">authored many</a>.</p>
            <p>One of the main accomplishments this quarter was <a href="https://patrick.sirref.org/ppxlib-5-2/">bumping the internal AST to 5.2</a>. This allows ppx authors to use new OCaml language features in their ppxes. In bumping the AST, we knowingly broke compatability for pretty much every single reverse dependency. As best we can, we have been sending patches to ppx libraries and helping users migrate to the latest <a href="https://patrick.sirref.org/ppxlib/">ppxlib</a>.</p>
            <p>There is an interesting dicussion to had about the nature of open-source, and its interaction with industrial monorepos and community tended package repositories. Package ecosystems thrive whenever there is a dedicated community creating, maintaining and publishing packages. The idea is that the published world should be healthy. The publishing medium can act as natural limiting factor in the churn of breaking changes (in the case of OCaml this is via <a href="https://github.com/ocaml/opam-repository/">PRs to the opam-repository</a>). This, I  have come to notice, reacts poorly to changes coming from internally consistent monorepos where introducing breaking changes is easily fixed by applying patches there and then. Whatsmore, OCaml is often stated as an incredibly safe language to perform large refactorings thanks to its type system.</p>
            <p><a href="https://patrick.sirref.org/ppxlib/">Ppxlib</a> sits awkwardly in the space of possible breaking changes. Tied to OCaml's parsetree, impacts of changes there ripple down to <a href="https://patrick.sirref.org/ppxlib/">ppxlib</a>. The compiler itself can remain internally consistent, and is protected as it need only parse source code. <a href="https://patrick.sirref.org/ppxlib/">Ppxlib</a>, on the other hand, exposes the parsetree to users and thus any changes to the parsetree will likely be felt by ppx authors. Since I started working on <a href="https://patrick.sirref.org/ppxlib/">ppxlib</a>, it feels as though the number of syntax changes has gone up (primarily from Janestreet work). Unless we make changes to how we provide  support for these, maintainers of <a href="https://patrick.sirref.org/ppxlib/">ppxlib</a> will forever be stuck doing busy work! Thankfully, <a href="https://patrick.sirref.org/nathanreb/">Nathan</a> <a href="https://patrick.sirref.org/ocaml-weekly-2025-w29/">has thoughts on how to improve this</a>.</p>
            <p>There are a slew of other features I have added to <a href="https://patrick.sirref.org/ppxlib/">ppxlib</a> including:</p>
            <ul>
              <li>
                <p>Support for deriving from classes.</p>
              </li>
              <li>
                <p>Support for deriving from module bindings and signatures.</p>
              </li>
              <li>
                <p>Fixing compiler and ppxlib dummy locations.</p>
              </li>
              <li>
                <p>Bumping to 5.3.</p>
              </li>
              <li>
                <p>Migrations for 5.4.</p>
              </li>
            </ul>
          </section>
          <section>
            <header>
              <h3>Outreachy</h3>
            </header>
            <p>Our two projects this year, one on <a href="https://github.com/claudiusFX/claudius">claudius</a> and one on <a href="https://github.com/ocaml/dune">dune</a>, are going extremely well. At the time of writing, we just had <a href="https://patrick.sirref.org/ocaml-weekly-2025-w29/">a mid-internship call to catch up</a>, and I was blown away by the progress each intern has made. Unfortunately, <a href="https://patrick.sirref.org/outreachy/">Outreachy</a> is struggling with funding and the next round is perhaps not going to happen. This is a real shame and I am hoping that it will not be the case.</p>
            <p>Outreachy has been a wonderful source of new, committed OCaml developers. If you haven't already, do peruse the <a href="https://ocaml.org/outreachy">webpage on OCaml.org</a> to see past internships or <a href="https://watch.ocaml.org/c/outreachy_ocaml/videos">watch the demo day presentations</a>. For the mentors involved, I believe it has also been a rewarding experience (though at times a challenging one).  We are always looking for new mentors and project ideas, please <a href="https://patrick.sirref.org/patrickferris/">do reach out to me</a> if you are interested.</p>
          </section>
          <section>
            <header>
              <h3>Hazel</h3>
            </header>
            <p>OCaml's feature set allows it to shine at writing programming languages (and  things of that ilk: compilers, interpretters, static analysis tools). <a href="https://patrick.sirref.org/hazel/">Hazel</a> is a research programming language with typed holes written completely in OCaml (via the <a href="https://reasonml.github.io/">reason dialect</a>).</p>
            <p>Relating this back to the original intent of my work, to improve OCaml adoption, I believe this also means keeping existing users happy. In the last quarter I developed a compiler from <a href="https://patrick.sirref.org/hazel_of_ocaml/">OCaml to Hazel</a>. Whilst new features are still being added to <a href="https://patrick.sirref.org/hazel/">Hazel</a>, I hope this could serve as a tool to help develop test-suites and standard library functions using existing OCaml solutions. In a student's work ( <a href="https://patrick.sirref.org/part-ii-hazel/">Typed Debugging for Hazel</a>), we used this tool to build a corpus of ill-typed  <a href="https://patrick.sirref.org/hazel/">Hazel</a> programs to great effect.</p>
            <p>OCaml should continue to be a world-class programming language for building other programming languages. I hope to upstream some of this work to <a href="https://patrick.sirref.org/hazel/">Hazel</a> and provide some low effort maintenance to help keep their compiler in good shape.</p>
          </section>
          <section>
            <header>
              <h3>Systems Programming in OCaml</h3>
            </header>
            <p>In a cross-over with my own research, I have been developing many tools related to systems programming in OCaml including:</p>
            <ul>
              <li>
                <p>An eBPF-based <a href="https://patrick.sirref.org/open-trace/"><code>open</code> syscall tracing tool</a>.</p>
              </li>
              <li>
                <p>A library in OCaml for <a href="https://github.com/quantifyearth/void">spawning void processes</a>.</p>
              </li>
              <li>
                <p>A <a href="https://patrick.sirref.org/shelter/">shell session manager</a> that uses <a href="https://irmin.org/">Irmin</a> to manage sessions. It is nice to see a new push to <a href="https://github.com/mirage/irmin/pull/2149">finally land the direct-style Irmin PR</a>!</p>
              </li>
            </ul>
            <p>This work is means to develop the underlying libraries that support it. For example, I have opened a few PRs to <a href="https://github.com/ocaml-multicore/eio">Eio</a> to add new "fork actions" to the spawn API. I also investigated the feasibility of changing the underlying mechanisms in <a href="https://patrick.sirref.org/eio/">Eio</a> to use <a href="https://github.com/ocaml-multicore/picos">Picos</a>. In the future, I think this could be important avoid further splitting the OCaml ecosystem.</p>
            <section>
              <header>
                <h4>OxCaml</h4>
              </header>
              <p>I dabbled a little with <a href="https://oxcaml.org/">OxCaml</a> and build <a href="https://patrick.sirref.org/try-oxcaml/">try-oxcaml</a> to let people take it for a spin without having to perform opam repository gymnastics. It turned into a lot of work to track down some pretty inane bugs (type definitions differeing between js_of_ocaml and the OxCaml compiler, resulting  in different Javascript runtime representations...).</p>
              <p>This unblocked a few of my colleagues to get OxCaml working on tools like <a href="https://jon.recoil.org/notebooks/foundations/foundations1.html">odoc_notebooks</a> and <a href="https://github.com/art-w/x-ocaml">x-ocaml</a>.</p>
            </section>
          </section>
          <section>
            <header>
              <h3>Forester</h3>
            </header>
            <p>A good proportion of my work this quarter has been focused on how to present the very work that I am doing. <a href="https://patrick.sirref.org/jonmsterling/">Jon Sterling</a> has been developing a tool for scientific thought called <a href="https://patrick.sirref.org/forester/">Forester</a> which seemed like a possible candidate for writing and sharing my work.</p>
            <p>Porting my existing blog posts and website content from markdown to Forester's LaTeX-inspired syntax didn't seem like an option. In particular, many of my posts made use of additional markdown-based tools (like <a href="https://github.com/realworldocaml/mdx">ocaml-mdx</a>).</p>
            <p>This lead to the development of <a href="https://patrick.sirref.org/graft/">Graft</a>: a preprocessor for Forester forests, converting markdown and bibtex to trees.</p>
          </section>
        </section>
        <section>
          <header>
            <h2>What's next?</h2>
          </header>
          <p>So, I worked on most of what I wanted to work on and then some! Going forward I hope to keep maintaining <a href="https://patrick.sirref.org/ppxlib/">ppxlib</a> in some capacity and coordinating the OCaml community's <a href="https://patrick.sirref.org/outreachy/">Outreachy</a> efforts.</p>
          <p>I hope to continue my small experiments (e.g. converting Eio to Picos). My own  research makes heavy use of Irmin, and I would be interested to help with that too. More recently, a new library has been released for working with numerical data in OCaml called <a href="https://github.com/raven-ml/">Raven</a>: I am interested to use this library in <a href="https://patrick.sirref.org/geocaml/">Geocaml</a>, a suite of geospatial tools written in OCaml that I maintain.</p>
          <p>I feel conflicted about the <a href="https://patrick.sirref.org/oxcaml/">OxCaml</a> efforts. I admit, I am not fully aware of the full benefits of the features, but I worry about some proliferation of modes that make the type system in OCaml unbearable to use. On top of this, with my <a href="https://patrick.sirref.org/ppxlib/">ppxlib</a> hat on, I worry about the impact of changing the compiler so frequently, placing strain on an already small community. That being said, by releasing <a href="https://patrick.sirref.org/oxcaml/">OxCaml</a> separately I do believe running it as an experimental set of packages will help understand the tool better. But I would not be building anything I intend to maintain or research with right now as that ecosystem is far too volatile.</p>
          <p>Finally, over the past two years I have done a lot of teaching. From <a href="https://patrick.sirref.org/part-ii/">Part II projects</a> to <a href="https://patrick.sirref.org/focs/">supervisions</a>. Going into next (academic) year, I  intend to reduce my in-person teaching to focus on my research. However, I am interested in producing more materials for learning, maybe some of this in OCaml, perhaps something similar to <a href="https://beautifulracket.com/">Beautiful Racket</a>. I have tried in the past to do these sorts of things, for example <a href="https://patricoferris.github.io/irmin-book/">The Irmin Book</a>.</p>
        </section>
        <section>
          <header>
            <h2>Thank you</h2>
          </header>
          <p>Thank you for reading this wrap up! And thank you again to <a href="https://patrick.sirref.org/tarides/">Tarides</a> for letting me work so freely on things that I think are good for the OCaml community.</p>
        </section>
      

---
title: OCaml Weekly 2025 w30 and w31
description:
url: https://patrick.sirref.org/ocaml-weekly-2025-w30-w31/
date: 2025-07-31T00:00:00-00:00
preview_image:
authors:
- https://patrick.sirref.org/Patrick%20Ferris/
source:
ignore:
---


        <p>A bumper edition today, a fortnightly.</p>
        <section>
          <header>
            <h2>Opam Releases</h2>
          </header>
          <p>I did a little personal spring-cleaning of packages I maintain and pushed a few releases to opam. This included a <a href="https://github.com/ocaml/opam-repository/pull/28187">0.1.0 release</a> of <a href="https://patrick.sirref.org/graft/">graft</a>! There is some light documentation online at <a href="https://graft.sirref.org/">https://graft.sirref.org</a>.</p>
          <p>Elsewhere, <a href="https://github.com/patricoferris/hilite">Hilite</a> got a <a href="https://github.com/ocaml/opam-repository/pull/28172">0.5.0 release</a>. This release makes the core syntax highlighting separate from the markdown part of the library. You can now <a href="https://ocaml.org/p/hilite/latest/doc/hilite/Hilite/index.htmlval-src_code_to_pairs">generate pairs of tokens and identifiers</a> to plug into any "OCaml sourcecode to format" tool you might be building (e.g.  <a href="https://patrick.sirref.org/graft/">graft</a>!).</p>
        </section>
        <section>
          <header>
            <h2>Interactive OCaml Presentations</h2>
          </header>
          <p>I had fun trying to fuse slipshow and x-ocaml!</p>
          <section>
            <header>
              <h3>Slipshow x x-ocaml</h3>
            </header>
            <p>A short, explanatory post about combining two very fun pieces of work in OCaml.</p>
            <p><a href="https://github.com/panglesd">Paul-Elliot</a> has been building <a href="https://github.com/panglesd/slipshow">Slipshow</a> for some time now where slides are <em>slips</em> and your presentations run vertically. More recently, <a href="https://patrick.sirref.org/artw/">Arthur</a> has built <a href="https://github.com/art-w/x-ocaml">x-ocaml</a>, a web component library for executable OCaml cells embedded into OCaml.</p>
            <p>Using <a href="https://github.com/patricoferris/xocmd">xocmd</a>, a small tool I built for translating markdown codeblocks to x-ocaml components, your Slipshow's can now be <em>executable</em>!</p>
            <pre>xocmd learn-effects.md | slipshow compile - &gt; learn-effects.html</pre>
            <p>
    Take a look at 
    <a href="https://patrick.sirref.org/bafkrmictvc3ap2ah37cbcdoo6rsl7vxqu6srogmgzx6iml45bq7zz5weo4.html">an example</a>!
    (or the 
    <a href="https://patrick.sirref.org/bafkrmib3jugpkznxcftqjvhbbtfqgx4oz2m32p5xloh4nxia3lhxy2momq.md">source markdown</a>).
</p>
            <p>I really like this light-weight approach to building interactive presentations for explaining things in OCaml (e.g. over running a jupyter notebook server).</p>
          </section>
          <p>I tried using x-ocaml with <a href="https://irmin.org/">Irmin</a> and something is not quite right with some of the runtime JS code being generated ( <a href="https://github.com/art-w/x-ocaml/issues/11">see the issue in case you can help</a>). This was  intended to be used alongside a longer-form retrospective I am writing on my use of Irmin over the years.</p>
        </section>
        <section>
          <header>
            <h2>Outreachy</h2>
          </header>
          <p>I have been helping <a href="https://patrick.sirref.org/mdales/">Michael's</a> intern whilst he has been away on their project <a href="https://github.com/claudiusFX/claudius">Claudius</a>. It has reminded me, again, how inpenetretable some of OCaml's tooling is. In this case the generation of opam files from dune-project files, and in particular, the required <em>manual</em> steps when you wish to remove a dependency (1. remove it from  the <code>dune-project</code> file, 2. run <code>dune build</code> to update the opam file, 3. remove all occurences of the library from <code>dune</code> files across your project).</p>
        </section>
        <section>
          <header>
            <h2>Ppxlib</h2>
          </header>
          <p>Work on <a href="https://patrick.sirref.org/ppxlib/">Ppxlib</a> has been fairly varied this past two weeks. I mentioned before about an exiting plan <a href="https://patrick.sirref.org/nathanreb/">Nathan</a> has planned to help ease the burden on ppxlib maintainers and ppx authors whenever there is an OCaml parsetree bump. That, however, is currently shelved as we are dealing with the fall out of <a href="https://patrick.sirref.org/ppxlib-5-2/">the 5.2 bump</a>. <a href="https://github.com/mirage/repr/pull/110">Repr</a> got some fixes pushed to it, but this unconvered <a href="https://github.com/ocaml-ppx/ppxlib/pull/588">more issues</a>.</p>
        </section>
        <section>
          <header>
            <h2>Misc.</h2>
          </header>
          <p>I spent some time cleaning up <a href="https://github.com/quantifyearth/container-image">container-image</a>, a tool primarily written by <a href="https://github.com/samoht">Thomas G.</a> to fetch OCI images from repositories. The <a href="https://github.com/quantifyearth/container-image/pull/5">tidy up</a> went surprisingly well, except for some spurious HTTP errors with AWS. Maybe I'll spend some proper time trying to help the state of HTTP clients in OCaml (of which there  are many, but few that work very well out of the box in my experience).</p>
        </section>
      

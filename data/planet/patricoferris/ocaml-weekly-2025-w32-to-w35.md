---
title: OCaml Weekly 2025 w32 to w35
description:
url: https://patrick.sirref.org/ocaml-weekly-2025-w32-w35/
date: 2025-09-02T00:00:00-00:00
preview_image:
authors:
- https://patrick.sirref.org/Patrick%20Ferris/
source:
ignore:
---


        <p>I have been working on a few different OCaml-related projects over the last few weeks. This is also coinciding with me moving across the UK, which has made finding time to write <a href="https://patrick.sirref.org/weeklies/">weeklies</a> and <a href="https://patrick.sirref.org/posts/">posts</a> a little tricky. Nevertheless, here are some of the things I have been thinking about and working on!</p>
        <p>I managed to publish one signficant post this month: a <a href="https://patrick.sirref.org/irmin-retro/">retrospective on Irmin</a>.</p>
        <section>
          <header>
            <h2>Eio</h2>
          </header>
          <p>Increasingly, I'm feeling the dream of a unified framework for asynchronous IO slipping through the OCaml community's fingers. It is perhaps not such a bad thing, and I think with the right library authoring we can at least get to a place where it isn't so bad, for example <a href="https://github.com/geocaml/ocaml-tiff/blob/0dd98659642d1d9741068bb1eb943b4edeb5b5d6/src/tiff.mlL2">providing read functions</a> as opposed to using an opinionated IO library directly.</p>
          <p>That being said, I am a very happy user of <a href="https://patrick.sirref.org/eio/">Eio</a> when those choices do not matter, as is the case in building your own application (e.g. <a href="https://patrick.sirref.org/shelter/">Shelter</a>). To this end,  I have spent a good bit of time upstreaming support for various missing pieces in Eio's API including:</p>
          <ul>
            <li>
              <p><a href="https://github.com/ocaml-multicore/eio/pull/803">Setuid and setgid</a> fork action's for the process API.</p>
            </li>
            <li>
              <p><a href="https://github.com/ocaml-multicore/eio/pull/802">Set process group</a> support for job control in the process API.</p>
            </li>
            <li>
              <p><a href="https://github.com/ocaml-multicore/eio/pull/796">Responding to <code>Buf_write.of_flow</code></a> request, and tinkering with the example there. I think this does highlight the awkwardness of making code portable across concurrency mechanisms, particularly with Eio's structured concurrency.</p>
            </li>
            <li>
              <p>I did <a href="https://github.com/ocaml-multicore/eio/issues/788issuecomment-3224454812">some investigating into <code>EINTR</code> bug</a> which seems to be stemming from a known-issue on Uring in that writes are not buffered which usually does not matter except perhaps when there are parallel writes to <code>stdout</code>.</p>
            </li>
            <li>
              <p><a href="https://github.com/ocaml-multicore/eio/issues/807">Spent some time thinking about the fiber local storage across domains issue</a>, I've passed on some thoughts to folks working on this.</p>
            </li>
          </ul>
        </section>
        <section>
          <header>
            <h2>Vpnkit</h2>
          </header>
          <p>You might recall <a href="https://patrick.sirref.org/vpnkit-upgrade/">I was interested in using vpnkit</a>. <a href="https://hannes.robur.coop/">Hannes</a> has done an amazing amount of work (patching and releasing) a series of packages to get this into a place that is  much better and could be considered soon for merging. This defunctorisation is actually very useful for the Eio port I wrote a long time ago.</p>
          <section>
            <header>
              <h3>Papers and Talks at ICFP</h3>
            </header>
            <p>Somehow, I have ended up on lots of papers and talks at ICFP and the co-located events in October. The vaguely OCaml-related ones include:</p>
            <ul>
              <li>
                <p>Essentially a <a href="https://icfp25.sigplan.org/details/icfp-2025-papers/21/Functional-Networking-for-Millions-of-Docker-Desktops-Experience-Report-">Vpnkit Experience Report</a>.</p>
              </li>
              <li>
                <p>An extended abstract on generating a corpus of ill-typed Hazel programs was accepted into <a href="https://conf.researchr.org/home/icfp-splash-2025/tyde-2025">TyDe workshop</a>.</p>
              </li>
              <li>
                <p>Relatedly, the work that project supported was accepted into HATRA which was the <a href="https://patrick.sirref.org/part-ii-hazel/">Part II project I supervised</a>: <a href="https://conf.researchr.org/details/icfp-splash-2025/hatra-2025-papers/2/Decomposable-Type-Highlighting-for-Bidirectional-Type-and-Cast-Systems">Decomposable Type Highlighting for Bidirectional Type and Cast Systems</a>.</p>
              </li>
              <li>
                <p>And <a href="https://conf.researchr.org/home/icfp-splash-2025/propl-2025">two PROPL talks</a>!</p>
              </li>
            </ul>
          </section>
        </section>
        <section>
          <header>
            <h2>Outreachy</h2>
          </header>
          <p>We have come to the end of another Outreachy round! I will write more on this soon in its own separate post. But for now I am very grateful to this round's mentors <a href="https://www.gridbugs.org/">gridbugs</a> and <a href="https://patrick.sirref.org/mdales/">mdales</a>, and also our fantastic interns. If you are interested, please do watch our demo day presentations.</p>
          <div style="text-align: center">
    <iframe title="Outreachy May 2025 Demo Day" width="560" height="315" src="https://watch.ocaml.org/videos/embed/kZJRFM6iw9ug9BLNjEgKeH" frameborder="0" allowfullscreen="" sandbox="allow-same-origin allow-scripts allow-popups allow-forms">
</div>
          <p>The next round is fast approaching and we still need to work out the logistics. But I had a good conversation with <a href="https://patrick.sirref.org/mdales/">mdales</a> about possible <a href="https://patrick.sirref.org/geocaml/">Geocaml</a> projects that I intend to submit!</p>
        </section>
      </iframe></div></section>

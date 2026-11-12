---
title: '.plan-26-45: Welcome to the House of Fun'
description: Tessera wins the OpenUK software award, local AI agents pass the Red
  List exam, FoCS lecturing wraps up, OxCaml ox9 and an OpenWrt router rebellion,
  Eio sandbox fixes, a brief-powered Tangled spindle, a DuckDB index of UK labels,
  Tom Loosemore on personal agents, Taposaur, Rex, and a Madagascar field app.
url: https://anil.recoil.org/notes/2026w45
date: 2026-11-08T00:00:00-00:00
preview_image: https://anil.recoil.org/images/w45-5.640.webp
authors:
- Anil Madhavapeddy
source:
ignore:
keywords:
- agents
- effect
- eio
- odoc
- ox9
- oxcaml
- rex
- spindle
- symlink
- tom
---

<p><img src="https://anil.recoil.org/images/w45-5.webp" alt="%rc">
What a fun week! <a href="https://anil.recoil.org/projects/tessera">Tessera</a> won the open source <a href="https://anil.recoil.org/notes/openuk-tessera-award">software project of the year</a> at the OpenUK Awards in the House of Commons. I was very inspired to hear from Enrica Porcari of CERN who mentioned that we may be able to get tours inside the now-shut-down LHC, which I will drop anything to attend!</p>
<p>Congratulations also to <a href="https://shaneweisz.com">Shane Weisz</a> on his new preprint on how <a href="https://anil.recoil.org/notes/ai-red-list-exam">local AI agents can now pass the IUCN Red List assessor exam</a>. The headline result is that while frontier models comfortably clear the 75% pass mark at 96%, a self-hosted Qwen3.8 Flash on the Mac Studio on his desk <em>also</em> passes with 81%. This opens up all sorts of offline field uses for sensitive species data.</p>
<p>It's also a wrap for my 1A <a href="https://anil.recoil.org/notes/focs">Foundations of Computer Science</a> lecture course for this year. I very much enjoyed handing over to <a href="https://jonmsterling.com">Jon Sterling</a>, whose Discrete Maths course comes right after mine. Jon's also now lecturing <a href="https://www.jonmsterling.com/2026-W45/">slide-free</a> and using the document camera to write down maths by hand. I'd <a href="https://amok.recoil.org/@avsm/117586425001021630">like</a> to head in this direction next year and do more explanations by writing them down when teaching the basics.</p>
<p><img src="https://anil.recoil.org/images/w45-3.webp" alt="%c"></p>
<h2><a href="https://anil.recoil.org/news.xml#hacking-for-the-week" class="anchor" aria-hidden="true"></a>Hacking for the week</h2>
<h3><a href="https://anil.recoil.org/news.xml#oxcaml-540ox9-and-my-fomenting-router-rebellion" class="anchor" aria-hidden="true"></a>OxCaml 5.4.0+ox9 and my fomenting router rebellion</h3>
<p>After <a href="https://www.dra27.uk">David Allsopp</a> released a new revision of <a href="https://anil.recoil.org/projects/oxcaml">OxCaml</a>, I wrote up my analysis of <a href="https://anil.recoil.org/notes/oxcaml-ox9-improvements">what changed in this OxCaml 5.4.0+ox9 release</a>.
They include many performance-oriented features such as improved unboxed values, atomic fields, safer effects, and experimental layout and mode polymorphism. My <a href="https://tangled.org/anil.recoil.org/ox">personal monorepo</a> is now pinned to ox9, and I also pushed a working odoc 3.2.2+ox to the <a href="https://github.com/oxcaml/opam-repository/pull/67">OxCaml opam repository</a> with a matching <a href="https://github.com/ocaml/odoc/pull/1520">odoc PR</a>.</p>
<p>While messing around with deploying my website, I also got sufficiently <a href="https://x.com/avsm/status/2119425506047398099">pissed off</a> by my household Netgear routers that were still running a 2018 (!) Linux that's <a href="https://thehackernews.com/2026/10/linux-kernel-tcp-flaw-with-98-cvss.html">vulnerable to attack</a>. So I also built a custom OpenWrt image with Linux 7.4-rc1, and bundled an OxCaml webserver with a Cap'n Proto endpoint running on the router itself. Wifi performance is now noticeably better on the new kernel (it is the latest one after all), and CLI management beats the vendor web UI by a mile.</p>
<h3><a href="https://anil.recoil.org/news.xml#eio-sandbox-escapes" class="anchor" aria-hidden="true"></a>Eio sandbox escapes</h3>
<p>I also fixed even more sandbox escapes in various Eio backends, with the
first one being a really surprising one reported by <a href="https://github.com/samoht">Thomas Gazagnaire</a>.
It involves a <a href="https://github.com/ocaml-multicore/eio/pull/967">trailing slash on a symlink</a>. A path like <code>foo/</code> should only ever refer to a directory, but the Eio POSIX backend treated the last component like a symlink it could follow. A link pointing outside the sandbox could therefore escape it by having a slash on the end. Argh! The fix treats <code>foo/</code> as <code>foo/.</code>, which forces <code>foo</code> to resolve as a directory.</p>
<p>I also opened up a <a href="https://github.com/ocaml-multicore/eio/pull/968">Windows PR with symlink and junction support</a>. I'm finding Windows filesystems extraordinarily complex to navigate, since they allow directory hardlinks ('junctions') and how these interact with the (relatively new) symlink support is the stuff of nightmares.</p>
<p>I also ran security scans over uring and opened up <a href="https://github.com/ocaml-multicore/ocaml-uring/pull/167">more hardening for the OCaml bindings</a>, which cover a number of edge cases.</p>
<h2><a href="https://anil.recoil.org/news.xml#a-custom-tangled-spindle-for-auto-ci" class="anchor" aria-hidden="true"></a>A custom Tangled spindle for auto CI</h2>
<p><a href="https://oppi.li/">Akshay Oppiliappan</a> did get the big v2 upgrade of Tangled live, which meant I couldn't resist having a go at an OxCaml spindle so we can experiment with distributed workflows on ATProto at last!</p>
<p>My first cut of a custom <a href="https://tangled.org">Tangled</a> CI spindle is now <a href="https://bsky.app/profile/anil.recoil.org/post/3mzsv34fb422u">up and running</a>.  It uses <a href="https://nesbitt.io">Andrew Nesbitt</a>'s <a href="https://github.com/git-pkgs/brief">brief</a> project detector to probe the languages and toolchains in a repository and route it to the right workflow. This lets repositories get CI without writing a pipeline file, using the per-language metadata and guessing the right commands to run. There's OCaml and OxCaml support first of course, and I'm messing around with Python support via uv and pytest as the second route (e.g. for my Evidence TAP <a href="https://tangled.org/anil.recoil.org/parsosaur">parsosaur</a> library which I'll talk more about later).</p>
<p>Behind the scenes of the spindle OCaml logic is a set of libraries to handle opam solving, and then it hands it off to our existing <a href="https://github.com/ocurrent/ocluster">OCluster</a> Cap'n Proto submission system, so this interops really well with the existing GitHub infrastructure too and doesn't require duplicating all the runners.</p>
<p>I'll write up more on this in a separate post next week, as I'd also like to get <a href="https://mynameismwd.org">Michael Dales</a> up and running with a LIFE pipeline to validate the use of this for larger jobs.</p>
<h2><a href="https://anil.recoil.org/news.xml#labels-duckdb-and-a-visitor" class="anchor" aria-hidden="true"></a>Labels, DuckDB and a visitor</h2>
<p>The <a href="https://anil.recoil.org/notes/2026w44">UK label map</a> I started last week has now progressed to include 400+ data sources, all held in a single <a href="https://duckdb.org">DuckDB</a> spatial index, and a tile server for raster tiles.
The hard part was harmonisation of the licences, as several datasets need clickthroughs; right now I'm keeping it private but tracking all these individually in each table.</p>
<p><img src="https://anil.recoil.org/images/w45-1.webp" alt="%c">
<img src="https://anil.recoil.org/images/w45-2.webp" alt="%c"></p>
<p>While I'm assembling all these, I was also delighted to meet <a href="https://loosemore.com/">Tom Loosemore</a> in Cambridge after many years, for an invigorating plotting session. Tom has been an inspiration to me since <a href="https://upmystreet.org/about">Up My Street</a> back in 1998, and his pioneering work establishing the UK Government Digital Service.</p>
<p><img src="https://anil.recoil.org/images/w45-4.webp" alt="%rc">
Tom's <a href="https://loosemore.com">recently</a> been exploring how personal AI agents could be useful for normal people, like his <a href="https://loosemore.com/2026/10/09/how-agents-show-up-what-muse-and-other-agents-reveal-when-they-use-whenisbins/">bin-collection site</a> and what data they leak about you!
He's also been conducting <a href="https://loosemore.com/2026/11/09/user-research-with-ai-agents-to-disprove-a-hypothesis/">user research</a> using agents, which struck me as a similar approach to the DeepMind <a href="https://github.com/google-deepmind/concordia">Concordia</a> simulations from our <a href="https://anil.recoil.org/notes/foundational-ecosystem-workshop">ARIA ecosystem resilience workshop</a> last year.
He's also encouraging those developing public services to prepare for the looming impact when <a href="https://loosemore.com/2026/10/26/here-be-dragons/">agents arrive en masse</a>:</p>
<blockquote>
<p>Those running public services should be considering what they can do to shape
how agents engage with their services. Do not wait for them to arrive en
mass. You may dismiss my anxieties as premature, since there are minuscule
numbers of people using AI agents in the UK at the moment. Remember
Hemingway’s quotation on being asked how he went bankrupt: “Two ways.
Gradually, then suddenly.”
<cite>-- <a href="https://loosemore.com/2026/10/26/here-be-dragons/">Here be dragons, Tom Loosemore, 2026</a></cite></p>
</blockquote>
<h2><a href="https://anil.recoil.org/news.xml#evidence-taposaur" class="anchor" aria-hidden="true"></a>Evidence TAPosaur</h2>
<p>I've been continuing to develop the latest version of the Taposaur website
for internal use, as a growing number of colleagues such as <a href="https://www.zoo.cam.ac.uk/people/andrea-manica">Andrea Manica</a>
and Neil Burgess from UNEP-WCMC are querying our metadata for various research tasks.</p>
<p>Now that we have around 30m fulltexts, the next phase is to finish mirroring OpenAlex's PDF
connection (~80m) and doing a run through <a href="https://tangled.org/anil.recoil.org/parsosaur">Parsosaur</a>
to get reliable TEI XML metadata. I'll talk more about this stack in the coming weeks, as we're
running it over our classic <a href="https://anil.recoil.org/projects/ce">Conservation Evidence</a> butterflies and moths review corpus.</p>
<p><img src="https://anil.recoil.org/images/w45-6.webp" alt="%c"></p>
<h2><a href="https://anil.recoil.org/news.xml#rex-as-a-daily-driver" class="anchor" aria-hidden="true"></a>Rex as a daily driver</h2>
<p>I got into the closed beta for <a href="https://superlogical.com">Rex</a> from Superlogical last week and it has totally become my default terminal. It's a terminal multiplexer that instantly resumes connections. Its notification system tells me when a remote pty is waiting for input (or has finished), and sessions can be named and grouped logically.
A cool side effect is that my coding agents now rename their own Rex session to describe the task they're working on, so the sidebar is a handy project todo list. I'm regularly SSHed into over 10 servers these days so the instant resume is also very cool!</p>
<h2><a href="https://anil.recoil.org/news.xml#links-around-the-web" class="anchor" aria-hidden="true"></a>Links around the web</h2>
<p>I spent the weekend hacking on the <a href="https://anil.recoil.org/notes/2026w43">Android Tessera labelling app</a> for <a href="https://www.bangor.ac.uk/staff/sens/julia-patricia-gordon-jones-010356/en">Julia P.G. Jones</a>, and she now has it working on her phone for her Madagascar field trip. She is currently en route to the rainforests with <a href="https://www.linkedin.com/in/miranda-lam-a088561b4">Miranda Lam</a> to try it out against real habitats!</p>
<p>Finley Stirk's weeknotes now have an <a href="https://finleystirk.github.io/weeknotes/feed.xml">Atom feed</a>!</p>
<p>Next week: I'm giving an IUCN webinar on Tessera with <a href="https://coomeslab.org">David Coomes</a>, so come along if you're free!</p>
<p><img src="https://anil.recoil.org/images/iucn-webinar26.webp" alt="%c"></p><h1>References</h1><ul><li>Madhavapeddy (2025). Foundations of Computer Science. <a href="https://doi.org/10.59350/qms3q-ymn65" target="_blank"><i>10.59350/qms3q-ymn65</i></a></li>
<li>Madhavapeddy (2026). Checking out the latest features in OxCaml 5.4.0+ox9. <a href="https://doi.org/10.59350/r852a-fja33" target="_blank"><i>10.59350/r852a-fja33</i></a></li>
<li>Madhavapeddy (2026). .plan-26-44: Commons People. <a href="https://doi.org/10.59350/94p1z-tk116" target="_blank"><i>10.59350/94p1z-tk116</i></a></li>
<li>Madhavapeddy (2025). Foundational AI for Ecosystem Resilience workshop. <a href="https://doi.org/10.59350/26hy6-rry61" target="_blank"><i>10.59350/26hy6-rry61</i></a></li></ul>

---
title: OCaml Labs
description:
url: https://anil.recoil.org/projects/ocamllabs
date: 2012-01-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<div>
  <h1>OCaml Labs</h1>
  <p></p><p>I founded a research group called OCaml Labs at the University of Cambridge, with the goal of pushing OCaml and functional programming forward as a platform, making it a more effective tool for all users (including large-scale industrial deployments), while at the same time growing the appeal of the language, broadening its applicability and popularity. Over a decade, we retrofitted multicore parallelism into the mainline OCaml manager, wrote a popular book on the language, and helped start and grow an OCaml package and tooling ecosystem that is thriving today.</p>
<h2>Background</h2>
<p>In my PhD work on <a href="https://anil.recoil.org/projects/melange">Functional Internet Services</a> in around 2003-2007, I developed high performance and reliable protocol implementations in OCaml.  Subsequently from 2010, I worked on <a href="https://anil.recoil.org/projects/perscon">Personal Containers</a> to build high assurance private data processing platforms.  This research lead me to really appreciate functional programming as a powerful approach to building robust software, and I got involved in the <a href="https://cufp.org">Commercial Users of Functional Programming</a> workshop, first as a speaker and then an <a href="https://anil.recoil.org/papers/2011-cufp-scribe">organiser</a> and member of the steering committee.</p>
<p>It was around this time in 2011 that my work on <a href="https://anil.recoil.org/projects/unikernels">Unikernels</a> and MirageOS was starting to materialise into a real project, but the OCaml language that we wrote everything in didn't have a unified open source community. Instead, there were islands of developers all over the world: the core maintainers concentrated in Inria in France, and academics teaching it in various universities, and some industrial shops like Jane Street or my own experiences from <a href="https://anil.recoil.org/papers/2010-icfp-xen">Using functional programming within an industrial product group: perspectives and perceptions</a>.   I put my head together with <a href="https://github.com/yminsky" class="contact">Yaron Minsky</a> in Tokyo at IFCP 2011 to see if we could try something a little unique for the time – establishing a centre for excellence in functional programming that would focus on the open-source and community building aspects of functional programming as well as traditional academic research.</p>
<h2>Early Days (2012-2014)</h2>
<p>In 2012, we launched the centre from the Cambridge Computer Lab in <a href="https://anil.recoil.org/notes/announcing-ocaml-labs">Announcing OCaml Labs</a>. Things moved very quickly indeed as the group quickly grew to around 6 full time postdocs and engineers, with lots of interns coming through our doors.  Our general strategy at this point was to understand the basic problems we were going to tackle, and so started with a few concrete projects to bootstrap the ecosystem:</p>
<ul>
<li>publishing <a href="https://anil.recoil.org/papers/rwo">Real World OCaml: Functional Programming for the Masses</a> with O'Reilly, which sold lots of copies in the early days and created plenty of buzz for OCaml. It was quite fun attending author signings around the world and having lines of people queuing up for a signature!</li>
<li>I worked closely with <a href="https://github.com/samoht" class="contact">Thomas Gazagnaire</a> (then CTO at OCamlPro) who lead the development of the first version of the <a href="https://opam.ocaml.org">opam</a> package manager.  Both of us were also establishing the MirageOS project at the time, and so we ended up bootstrapping a big chunk of the <a href="https://github.com/ocaml/opam-repository">opam-repository</a> for use by it, and we also took a (in hindsight excellent) decision to use the nascent GitHub platform as the primary mechanism for managing packages instead of hosting a database.  After a few releases in 2012 and then <a href="https://anil.recoil.org/notes/opam-1-1-beta">OPAM 1.1 beta available, with pretty colours</a>, the package manager rapidly established itself as the defacto standard for the OCaml ecosystem. I've been the chief maintainer of the opam-repository ever since then (with many wonderful co-maintainers who do much of the heavy lifting, of course!).  As of 2021, there are over 20000 packages in the repository. I've been less active since about 2023, but still the repository administrator.</li>
</ul>
<p>We also began organising community events, both online and offline:</p>
<ul>
<li>Didier Remy and I organised the inaugral <a href="https://ocaml.org/meetings/ocaml/2012/">OCaml Users and Developer's workshop</a> in 2012, which morphed in subsequent years into the OCaml Workshop. See <a href="https://anil.recoil.org/notes/ocaml-users-group">Camel Spotting in Paris</a> for an earlier user group meeting as well.</li>
<li><a href="https://ocamllabs.io/compiler-hacking/">Cambridge Compiler Hacking</a> sessions ran from 2013 to 2017 and served as introductions to new developers with experienced mentors on hand.</li>
<li>the conference highlight of the year were undoubtedly the CUFP workshops at ICFP as they combined a really active academic and industrial crowd. The writeups are in <a href="https://anil.recoil.org/papers/2011-cufp-scribe">CUFP 2011 Workshop Report</a>, <a href="https://anil.recoil.org/papers/2012-cufp-scribe">Commercial users of functional programming workshop report</a> and <a href="https://anil.recoil.org/papers/2013-cufp-scribe">CUFP'13 scribe's report</a> to give you a sense of what went on.</li>
<li>we worked with Ashish Agarwal and Christophe Troestler to develop a brand new website to replace the original https://caml.inria.fr one, and this eventually became ocaml.org in around 2012. Almost a decade later, I announced the replacement of this one with a <a href="https://discuss.ocaml.org/t/v3-ocaml-org-a-roadmap-for-ocamls-online-presence/8368/18">v3</a> version as well.</li>
<li>helping to open up OCaml compiler development by improving the GitHub infrastructure and starting the <code>ocaml</code> organisation there, such as via <a href="https://web.archive.org/web/20181130130707/https://anil.recoil.org/2014/03/25/ocaml-github-and-opam.html">OCaml/GitHub integration</a>.  Eventually, compiler development moved over entirely to GitHub thanks to a big push from the core developer team.</li>
</ul>
<p>There was enough activity in the early days that I managed to capture it in annual blog posts:</p>
<ul>
<li><a href="https://anil.recoil.org/notes/the-year-in-ocamllabs">Reviewing the first year of OCaml Labs in 2013</a></li>
<li><a href="https://anil.recoil.org/notes/ocaml-labs-at-icfp-2014">Talks from OCaml Labs during ICFP 2014</a></li>
<li><a href="https://anil.recoil.org/notes/ocamllabs-2014-review">Reviewing the second year of OCaml Labs in 2014</a></li>
</ul>
<p>After 2014 though, things had grown to the point where it was just too difficult for me to keep up with the flurry of movement.  We then aggregated into a "middle age" research project around 2015 with the following projects that would take the next few years.</p>
<h2>The OCaml Platform</h2>
<p>One of the main thrusts in OCaml Labs was to construct the tools to enable effective development workflows for OCaml usage at an industrial scale, while remaining maintainable with a small community that needed to migrate from existing workflows.  This effort was dubbed the "OCaml Platform" and really picked up stream after our release of the opam package manager, since it began the process of unifying the OCaml community around a common package collection.</p>
<p>While much of the work was lead from OCaml Labs, it's also been highly collaborative with other organisations and individuals in the community.  And of course, 100% of the work was released as open source software under a liberal license.  I've been giving annual talks since 2013 or so about the steady progress we've been making towards building, testing, documentation and package management for OCaml.</p>
<ul>
<li><a href="https://anil.recoil.org/papers/rwo">Real World OCaml: Functional Programming for the Masses</a> was the book published by O'Reilly that explained how to use OCaml with the Core library.</li>
<li>My 2013 talk on <a href="https://anil.recoil.org/papers/2013-oud-platform">The OCaml Platform v0.1</a> first introduced the OCaml Platform just after opam was first released.</li>
<li>My 2014 talk on <a href="https://anil.recoil.org/papers/2014-oud-platform">The OCaml Platform v1.0</a> continued the steady adoption of opam within the OCaml community, to start bringing a standard package database across the different users.</li>
<li><a href="https://www.youtube.com/watch?v=dEUMNuE4rxc&amp;list=PLnqUlCo055hU46uoONmhYGUbYAK27Y6rS&amp;index=8">My 2015 Platform talk</a> then introduced continous integration for opam, as well the start of the central documentation efforts (which were finally completed in 2021 after some <a href="https://watch.ocaml.org/videos/watch/9bb452d6-1829-4dac-a6a2-46b31050c931">herculean efforts</a>!).</li>
<li>By my <a href="https://speakerdeck.com/avsm/ocaml-platform-2017">2017 Platform talk</a> in Oxford, we had most of the OCaml community using opam and released opam 2.0, started contributing to the new jbuilder build tool from Jane Street, and began the shift from camlp4 to ppx and the development of the new <a href="https://github.com/ocaml/odoc">odoc</a> tool.</li>
<li>In my <a href="https://speakerdeck.com/avsm/the-ocaml-platform-1-dot-0-2018">2018 Platform talk</a> in Missouri, we had helped evolve jbuilder into the Dune build system (now the build tool of choice in OCaml), and started to combine packaging and build into a cohesive platform. The key challenge so far had been to fill in gaps in functionality, and now we could begin to weave together the components we'd built.</li>
<li>My <a href="https://speakerdeck.com/avsm/workflows-in-the-ocaml-platform">2019 Platform talk</a> in Berlin focussed on how workflows using all these tools would work, such as for package managers or application developers or end users.</li>
<li>My <a href="https://speakerdeck.com/avsm/ocaml-platform-2020">2020 Platform talk</a> saw the unveiling of the <a href="https://github.com/ocamllabs/vscode-ocaml-platform">VSCode OCaml Platform plugin</a>, which provided a seamless integration with the IDE to let all the workflows and tools from earlier years "just work" out of the box.</li>
<li>In 2021, we embarked on a huge mission to <a href="https://discuss.ocaml.org/t/v3-ocaml-org-a-roadmap-for-ocamls-online-presence/8368/27">rebuild the ocaml.org online presence</a> with a central documentation site that built 20000 packages with cross-referenced HTML documentation.</li>
</ul>
<p>As you can see, it's quite a journey to build community-driven development tools. A key to our approach was to "leave no OCaml project behind", and we spent considerable effort ensuring that every step of the tooling evolution had a migration path for older OCaml projects. As a result, it's often still possible to compile 20 year old OCaml code using the modern tooling.</p>
<h2>Multicore OCaml</h2>
<p>The other big research project we drove from OCaml Labs was the effort to bring multicore parallelism to OCaml. While this might seem straightforward, we quickly realised that the challenge was in preserving <em>existing</em> sequential performance while also allowing new code to take advantage of multicore CPUs.</p>
<p>The first talk we gave was in 2014 on <a href="https://anil.recoil.org/papers/2014-oud-multicore">Multicore OCaml</a>. Little did we know how much work it would take to get this production worthy!
After several years of hacking, we finally had several breakthroughs:</p>
<ul>
<li>Any multicore-capable language needs a well-defined memory model, and we realised that none of the existing ones (e.g. in C++ or Java) were particularly satisfactory. Our PLDI paper on <a href="https://anil.recoil.org/papers/2018-pldi-memorymodel">Bounding data races in space and time</a> defined a sensible and novel memory model for OCaml that was predictable for developers.</li>
<li>Our garbage collector and runtime design won the best paper award at ICFP for its systematic approach to the design and evaluation of several minor heap collectors, in <a href="https://anil.recoil.org/papers/2020-icfp-retropar">Retrofitting parallelism onto OCaml</a>.</li>
</ul>
<h2>Algebraic Effects</h2>
<p>While working on parallelism in OCaml with <a href="https://github.com/lpw25" class="contact">Leo White</a> and <a href="https://github.com/stedolan" class="contact">Stephen Dolan</a>, <a href="https://kcsrk.info" class="contact">KC Sivaramakrishnan</a> joined our group after completing his PhD at Purdue, and started us down the path of using algebraic effects to express concurrency in OCaml code.</p>
<ul>
<li>The <a href="https://anil.recoil.org/papers/2017-ml-effects">Effectively tackling the awkward squad</a> and <a href="https://anil.recoil.org/papers/2017-tfp-effecthandlers">Concurrent System Programming with Effect Handlers</a> papers were our first forays into using the effect system for realistic usecases such as Unix systems programming.</li>
<li>We then spent a few years engineering a full production-quality version of runtime fibres in <a href="https://anil.recoil.org/papers/2021-pldi-retroeff">Retrofitting effect handlers onto OCaml</a>, again with a focus on maintaining tooling compatibility (e.g. with debuggers) and also having a minimal impact on sequential performance for existing code.</li>
</ul>
<p>In around 2020, I started publishing <a href="https://discuss.ocaml.org/tag/multicore-monthly">multicore monthlies</a> on the OCaml discussion forum. This was because we had begin the journey to upstream our feature into the mainline OCaml compiler.  At the end of 2020, <a href="https://kcsrk.info" class="contact">KC Sivaramakrishnan</a> opened up a pull request to the mainline OCaml repository (<a href="https://github.com/ocaml/ocaml/pull/10831">#10831</a>) and it got merged in early 2022, adding domains-parallelism and runtime fibres into OCaml 5.0!  The amount of work that we put into multicore has been way more than I expected at the outset of the project, but the results are deeply satisfying. I'm finding that coding using effects in a mainstream PL like OCaml to be really fun, and anticipate this having a big boost for <a href="https://anil.recoil.org/projects/unikernels">Unikernels</a> in MirageOS that are struggling somewhat under the weight of over-functorisation for portability. It was also really fun seeing <a href="https://news.ycombinator.com/item?id=29878605">how much online attention</a> we got as we went through the upstreaming journey.</p>
<h2>OCaml Labs to Tarides (2021-present)</h2>
<p>The OCaml Labs research project at the University of Cambridge finally came to
a happy end in 2021, after almost ten years.  After the first decade of fundamental
research and early engineering, the maintainership and stewarding of the resulting code has only
picked up pace as the OCaml userbase grows.  There are now <em>three</em> commercial
companies who have taken over the work from the University, all run by research
staff originally in the Computer Lab group (<a href="https://anil.recoil.org/news.xml" class="contact">Gemma Gordon</a>, <a href="https://kcsrk.info" class="contact">KC Sivaramakrishnan</a> and <a href="https://github.com/samoht" class="contact">Thomas Gazagnaire</a>).</p>
<ul>
<li><a href="https://ocamllabs.io">OCaml Labs Consultancy</a> is based in Cambridge in the UK.</li>
<li><a href="https://tarides.com">Tarides</a> is based in Paris, France.</li>
<li><a href="https://segfault.systems">Segfault Systems</a> is based in Chennai, India.</li>
</ul>
<p>All of those groups merged into one unified Tarides in 2022 (<a href="https://tarides.com/blog/2022-01-27-ocaml-labs-joins-tarides/">OCLC</a> and <a href="https://segfault.systems">Segfault</a>), making it easier to manage a growing community of maintainers.  There's really exciting work happening there to continue the upstreaming of the
multicore OCaml features into mainline OCaml, making unikernels and MirageOS ever more practical and robust to deploy, and shipping end-to-end Windows support in the OCaml toolchain. You can read about all this and more on the <a href="https://tarides.com/blog/">Tarides blog</a>, which is regularly updated with news on their projects.</p>
<p></p>
</div>


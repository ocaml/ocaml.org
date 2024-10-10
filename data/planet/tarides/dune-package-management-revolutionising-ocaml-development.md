---
title: 'Dune Package Management: Revolutionising OCaml Development'
description: "At Tarides, we\u2019ve been working on an initiative to improve the
  OCaml development experience: Dune Package Management. As outlined in the Platform
  Roadmap, which was created through community collaboration, the aim is to unify
  all OCaml development workflows under a single, streamlined tool. After \u2026"
url: https://tarides.com/blog/2024-10-09-dune-package-management-revolutionising-ocaml-development
date: 2024-10-09T00:00:00-00:00
preview_image: https://tarides.com/blog/images/DPM-1360w~yOfV2uaaTYCAMmh4atiLfg.webp
authors:
- Tarides
source:
---

<p>At Tarides, we’ve been working on an initiative to improve the OCaml development experience: Dune Package Management. As outlined in the <a href="https://github.com/tarides/ocaml-platform-roadmap">Platform Roadmap</a>, which was created through community collaboration, the aim is to unify all OCaml development workflows under a single, streamlined tool. After successfully completing a Minimal Viable Product (MVP) in Q1 2024, Dune will be the recommended tool for all OCaml development.</p>
<p>The motivation behind Dune Package Management is clear. For years, the OCaml community has called for a single tool to address all the development concerns: building projects, managing dependencies, testing on different compiler versions, etc. By integrating package management directly into Dune, we want to resolve the above long-standing pain points that can make OCaml cumbersome to work with, both for newcomers and experienced developers.</p>
<h2>The Vision for Dune</h2>
<p>Our long-term goal is to make Dune the central tool for OCaml development. That means more than just feature additions! It's about radically simplifying how developers work with the OCaml platform. By making installation painless and simplifying frustrating workflows, such as the handling of dependencies and testing against multiple compiler versions, Dune will address all your OCaml needs.</p>
<p>Dune integrates package management by using opam as a libary in essential parts of our approach. Two commands lie at the heart of integration: <code>dune pkg lock</code> and <code>dune build</code>. <code>dune pkg lock</code> creates a generated lock file, whereas <code>dune build</code> depends on this lock file to manage project dependencies. You can now handle everything from project initialisation to dependency management using these simple commands.</p>
<h3>What We’ve Achieved So Far</h3>
<p>We've accomplished a lot in these past few months! The work we have done for Dune Package Management can already handle such complex projects as <strong>OCaml.org</strong> and <strong>Bonsai</strong> using the new package management features. Both were successfully built using these new features. These early successes confirm our hypothesis: we are on the right track, because this proves the solution's viability in real world scenarios.</p>
<p>But this is not the end of the work. In the future, we plan to further improve the UX so that Dune is not only correct but also easy and productive for developers to use. The remaining challenges are yet to be overcome, and we hope to make Dune Package Management the standard tooling for all OCaml workflows.</p>
<h3>The Road Ahead</h3>
<p>Now that we hit the milestone for MVP, the subsequent phase will have testing, validation, and enhancement of the developer experience. Our main focuses going ahead will include:</p>
<ul>
<li><strong>Smoothening UX:</strong> We want to make the Dune Package Management interface as intuitive as possible, so developers can get their projects underway quickly.</li>
<li><strong>Optimising Performance:</strong> This means shorter compilation times, quicker install times for dependencies, and ensuring all operations work seamlessly.</li>
<li><strong>Simplify Tooling:</strong> We're starting to include things like testing, formatting, documentation generation, and more! This way developers will no longer have to run several different tools to manage their projects.</li>
<li><strong>Providing Clear Documentation:</strong> Thorough, user-friendly documentation will be essential in helping developers adopt these new features.</li>
</ul>
<h3>A Unified Future for OCaml</h3>
<p>Package Management brings in a new era of OCaml development. Dune will now be the only tool engineers will need, making OCaml development as seamless and effective for both complete beginners and experienced developers on the platform.</p>
<p>We look forward to the future and what Dune Package Management will facilitate within the OCaml community. Stay tuned, and prepare to take part in a more integrated and seamless OCaml development experience with Dune.</p>
<blockquote>
<p><a href="https://tarides.com/contact/">Contact Tarides</a> to see how OCaml can benefit your business and/or for support while learning OCaml. Follow us on <a href="https://twitter.com/tarides_">Twitter</a> and <a href="https://www.linkedin.com/company/tarides/">LinkedIn</a> to ensure you never miss a post We've also created new accounts on <a href="https://mastodon.social/@tarides">Mastodon</a> and <a href="https://www.threads.net/@taridesltd">Threads</a>, if you prefer. Be sure to join the OCaml discussion on <a href="https://discuss.ocaml.org/">Discuss</a>!</p>
</blockquote>


---
title: We're Moving Ocsigen from Lwt to Eio!
description: Announcing a new project transitioning the web development framework
  Ocsigen from Lwt to Eio and effects, creating new tools and workflows.
url: https://tarides.com/blog/2025-03-13-we-re-moving-ocsigen-from-lwt-to-eio
date: 2025-03-13T00:00:00-00:00
preview_image: https://tarides.com/blog/images/3dwebapps-1360w.webp
authors:
- Tarides
source:
---

<p>Among the <a href="https://tarides.com/blog/2023-03-02-the-journey-to-ocaml-multicore-bringing-big-ideas-to-life/">big changes</a> that came with OCaml 5, concurrency via effect handlers was introduced alongside the I/O library <a href="https://github.com/ocaml-multicore/eio">Eio</a>, letting users take advantage of effects to write <a href="https://tarides.com/blog/2024-09-19-eio-from-a-user-s-perspective-an-interview-with-simon-grondin/">more efficient</a> concurrent programs. In an exciting new project, we are transitioning one of the biggest OCaml open source projects, Ocsigen, from <a href="https://ocsigen.org/lwt/latest/manual/manual"><code>Lwt</code></a> concurrency to concurrency using effects.</p>
<p>The most exciting part of this project is that we will develop tools to automate parts of the transition and document how we achieve it, which will be great resources for the wider OCaml community. This work is made possible thanks to a grant from the <a href="https://nlnet.nl/">NLnet Foundation</a>, which funds research and development projects furthering internet technologies and the open internet, and the <a href="https://nlnet.nl/core/">NGI Zero Core fund</a> of the European commission. This post will give you an overview of the tools, the goals of the project, and some of the methods we will use.</p>
<h2>Why Ocsigen and Why Eio?</h2>
<p><a href="https://ocsigen.org">Ocsigen</a> is a web and mobile framework composed of several projects and libraries including <a href="https://ocsigen.org/eliom/latest/manual/overview">Eliom</a>, <a href="https://ocsigen.org/js_of_ocaml/latest/manual/overview">Js_of_ocaml</a>, <a href="https://ocsigen.org/ocsigenserver/latest/manual/quickstart">Ocsigen Server</a>, and <a href="https://ocsigen.org/lwt/latest/manual/manual">Lwt</a>. Ocsigen lets you build a variety of applications, from simple server-side web sites to complex client-server web and mobile apps. It is built using OCaml and benefits from its strong type system to reduce development time, simplify refactoring, and reduce the likelihood of bugs. It is one of the biggest open source projects in OCaml, and is used commercially to run the <a href="https://www.besport.com/group/10902">BeSport</a> app.</p>
<p>Choosing a large and established project like Ocsigen will give the community a well-documented proof-of-concept of what the transition between different concurrency models looks like.</p>
<p>Lwt, a monadic-style concurrent programming library for OCaml, is developed as part of the Ocsigen umbrella. It has served as a way of managing I/O operations using promises for many different OCaml projects, and it is significant that Lwt’s own inventor and biggest user Ocsigen is now making the switch to effects.</p>
<p>The monadic style has several advantages over more traditional concurrency models (like preemptive threading or interaction loops) including fewer data races and straightforward writing, but also comes with drawbacks in comparison to direct-style effects-based concurrency. Namely, creating an abundance of heap allocations and introducing the <a href="https://journal.stuffwithstuff.com/2015/02/01/what-color-is-your-function/">function colouring problem</a> to the user’s programs. With direct-style concurrency it is possible to write code in a natural, direct, style as opposed to callback-style with considerations for which code is concurrent and which is not. For more information about concurrency using effect handlers, check out our <a href="https://tarides.com/blog/2024-03-20-eio-1-0-release-introducing-a-new-effects-based-i-o-library-for-ocaml/">blog post on Eio</a>.</p>
<p>Switching to effects is also a first step towards enabling the use of multicore features, which is not fully possible with Lwt.</p>
<h2>Goals of the Project</h2>
<p>The aim of the project is to create a straight-forward path for developers who want to transition projects to OCaml 5 and its new direct-style concurrency libraries. To this end, the team will develop tools for rewriting monadic syntax into direct style, rewrite interfaces, and automate the use of libraries like <a href="https://ocaml.org/p/picos/0.4.0/doc/Picos_lwt/index.html">picos-lwt</a> and <a href="https://github.com/ocaml-multicore/lwt_eio">eio-lwt</a>.  They will also develop heuristics for detecting places in the code where manual intervention is required, simplifying the developer workflow.</p>
<p>Put simply, we are going to:</p>
<ul>
<li>Automate the aspects of transforming monadic style concurrency to direct style concurrency that we can,</li>
<li>Make manual intervention as smooth as possible,</li>
<li>Document the process so that it is easy to replicate, troubleshoot, and adapt for other projects.</li>
</ul>
<p>Making effects-based concurrency easier to adopt means that more OCaml developers can potentially take advantage of its benefits. Speaking from experience, Simon Grondin summed up his experiments with Eio in our <a href="https://tarides.com/blog/2024-09-19-eio-from-a-user-s-perspective-an-interview-with-simon-grondin/">interview with him from 2024</a>:</p>
<blockquote>
<p>Eio helped me reason about my code, and I discovered bugs and problems because of how much Eio had cleaned up the code. I uncovered hidden bugs in every program I converted from Lwt to Eio. Every single one also ended up being faster, not because Eio itself was faster (it was as fast as Lwt), but because of the optimisations I could now afford to make, thanks to the reduced complexity.</p>
</blockquote>
<p>This project will enable more people to try Eio and see if their experience matches Simon’s, with the potential to significantly improve their workflow!</p>
<h2>Challenges and Methods</h2>
<p>One of the biggest challenges facing this work is the way that in an effect-based library there is an explicit fork feature to create a new thread, whereas forking is implicit with <code>Lwt</code> which makes it hard to detect. This fact alone is the reason why the team won’t be able to write a fully automated conversion tool.</p>
<p>Another challenge for the team is to make sure that they stay as neutral as possible in their approach to the effect library's design, in order to be able to make changes later or provide multiple alternatives.</p>
<p>Finally, they will strive to maintain backward compatibility to the greatest extent, by using Lwt-effect bridges to enable intercompatibility for existing applications without forcing them to switch immediately.</p>
<h2>Until Next Time</h2>
<p>Keep your eye on our blog and <a href="https://discuss.ocaml.org">OCaml Discuss</a> for more updates on this project and the tools that emerge from it.</p>
<p>Connect with Tarides online on <a href="https://bsky.app/profile/tarides.com">Bluesky</a>, <a href="https://mastodon.social/@tarides">Mastodon</a>, <a href="https://www.threads.net/@taridesltd">Threads</a>, and <a href="https://www.linkedin.com/company/tarides">LinkedIn</a> or sign up for our mailing list to stay updated on our latest projects.</p>


---
title: Cresting the OCaml AI humps
description:
url: https://anil.recoil.org/notes/cresting-the-ocaml-ai-hump
date: 2025-07-18T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
ignore:
---

<p>I've been hacking with <a href="https://toao.com" class="contact">Sadiq Jaffer</a> (<a href="https://toao.com/blog/ocaml-0725">^</a>),
<a href="https://github.com/jonludlam" class="contact">Jon Ludlam</a> (<a href="https://jon.recoil.org/blog/2025/07/week28.html">^</a>) and
<a href="https://ryan.freumh.org" class="contact">Ryan Gibb</a> (<a href="https://ryan.freumh.org/enki.html">^</a>) on various approaches to
improving the <a href="https://anil.recoil.org/notes/claude-copilot-sandbox">agentic coding experience</a> for OCaml.</p>
<p>We jotted down our notes in a <a href="https://www.cl.cam.ac.uk/~avsm2/2025-ocaml-ai-draft1.pdf">draft paper</a> to keep track of everything going on, including <a href="https://toao.com/blog/ocaml-local-code-models">summarising</a> previous experiments with Qwen3 for <a href="https://www.cl.cam.ac.uk/teaching/2425/FoundsCS/">FoCS</a>. Since then, there's been a flurry of extra activity from others which we need to integrate!</p>
<ul>
<li><a href="https://academic.mseri.me/" class="contact">Marcello Seri</a> started pushing to my vibe coded <a href="https://tangled.sh/@anil.recoil.org/ocaml-mcp">OCaml MCP library</a>, making him user number 2 of that!</li>
<li>Then <a href="https://github.com/tmattio" class="contact">Thibaut Mattio</a> announced a bunch of software, starting with <a href="https://discuss.ocaml.org/t/announcing-raven-scientific-computing-for-ocaml-alpha-release/16913">a collection of libraries and tools for numerical computing and machine learning</a> and also another <a href="https://discuss.ocaml.org/t/building-ocaml-mcp-what-features-would-you-want/16914">MCP server</a>. I haven't had a chance to try the MCP server yet, but I hope I can retire mine...</li>
<li><a href="https://github.com/samoht" class="contact">Thomas Gazagnaire</a> started hacking on an agent-friendly <a href="https://github.com/samoht/merlint">merlint</a> tool that spots common problems in style and choices and gives CLI feedback in a style easily consumed by claude. I've <a href="https://github.com/samoht/merlint/issues">started using it</a> despite its pre-alpha status.</li>
<li><a href="https://github.com/jonludlam" class="contact">Jon Ludlam</a>'s been <a href="https://jon.recoil.org/blog/2025/07/week28.html">getting</a> the <a href="https://toao.com/blog/opam-archive-dataset">opam embeddings</a> into shape to be suitable as an MCP server that can search the entire opam ecosystem. odoc v3 has also <a href="https://discuss.ocaml.org/t/new-odoc-3-generated-package-documentation-is-live-on-ocaml-org/16967">gone live</a> after lots of work, and <a href="https://github.com/https://github.com/davesnx" class="contact">David Sancho</a>'s support for <a href="https://github.com/ocaml/odoc/pull/1341">Markdown odoc output</a> on which makes this process easier.</li>
</ul>
<p>This is all fairly straightforward MCP work that improves the short-term experience. We'll get to the <a href="https://arxiv.org/abs/2505.24760">RL-VR</a> ideas later...
If anyone else is hacking on something agent related do <a href="https://discuss.ocaml.org">post on OCaml Discuss</a> and let us know! I'm hoping to update the paper later in August to roundup the efforts above.</p>


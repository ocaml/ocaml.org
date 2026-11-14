---
title: 'VSCode Walkthrough: Installing OCaml in 1 Click'
description: We have created a VSCode walkthrough that guides newcomers through installing
  OCaml with opam, making it easier to get started.
url: https://tarides.com/blog/2026-04-16-vscode-walkthrough-installing-ocaml-in-1-click
date: 2026-04-16T00:00:00-00:00
preview_image: https://tarides.com/blog/images/VSCode-window-1360w.webp
authors:
- Tarides
source:
ignore:
keywords:
- click
- dune
- installation
- ocamlformat
- odoc
- opam
- opens
- utop
- vscode
- walkthrough
---

<p>We are making it easier to get started with OCaml! We support the growth of the OCaml community, and feedback suggests that installation is a common pain point for newcomers. To improve their experience, we need to ensure that the pathways to installation and setting up projects are smooth. Recently, this effort has produced a walkthrough in VSCode for setting up OCaml, essentially a ‘one-click installation’ using <code>opam</code>.</p>
<p>This post will introduce the new feature and show you how it gets new users started.</p>
<h2>Why VSCode?</h2>
<p>VSCode is by far the most <a href="https://survey.stackoverflow.co/2024/technology#most-popular-technologies-new-collab-tools-learn">popular editor among beginners</a>, mainly thanks to its helpful UI, which gives users plenty of support: welcome/setup panels, interactive menus, selection tools, and so on. By targeting VSCode first we are making installation easier for newcomers, and the feedback we gather will also provide maintainers with insights they can use to improve other workflows.</p>
<p>Our goal with creating a walkthrough was to reduce friction by minimising reliance on external documentation and the terminal for setup. One of the first challenges when installing OCaml is understanding where to find and install what you need to start writing code. Even if you do know where to find everything, it can be challenging to get to it all in the right order. OCaml.org has an <a href="https://ocaml.org/docs/installing-ocaml">installation guide</a>, which is a great resource, but it’s a lot of information to take in and can be hard to parse for some users.</p>
<h2>The Walkthrough</h2>
<p>The new VSCode walkthrough opens a window when you install the OCaml plugin. The page guides you through five steps, providing clear instructions and a UI that indicates when each step is in progress and when it succeeds. When you click on a step, the walkthrough opens an integrated terminal and completes it for you.</p>
<p>The steps are:</p>
<ul>
<li>Install <code>opam</code>: First, VSCode opens a terminal and runs the <code>opam</code> install script.</li>
<li>Initialise <code>opam</code>: Second, VSCode opens a terminal and runs <code>opam init</code>. Initialising <code>opam</code> prepares your system to use <code>opam</code> to manage OCaml packages and compilers.</li>
<li>Activate the <code>opam</code> switch: This step prompts you to select and activate the <code>opam</code> switch. It explains that an <code>opam</code> switch is an isolated OCaml environment where you can install different versions of OCaml and packages.</li>
<li>Install Platform Tools: The next click installs some key OCaml tools: <code>dune</code> as a build system, OCaml LSP for editor support, <code>odoc</code> to generate documentation, <code>ocamlformat</code> to format code, and <code>utop</code> as an interactive REPL.</li>
<li>Check Installation: This step verifies the OCaml installation by running <code>utop</code>.</li>
<li>Congratulations: Success! OCaml is installed, and you are asked to fill in an optional feedback form.</li>
</ul>
<p>Here's what the start screen for the walkthrough looks like:
<img src="https://tarides.com/blog/images/VSCode-light-1360w~cGaZLYvkX4jLZiMvlFU5Qg.webp" sizes="(min-width: 1360px) 1360px, (min-width: 680px) 680px, 100vw" srcset="/blog/images/VSCode-light-170w~vU_8KGLrdsi8e8UiCENBTw.webp 170w, /blog/images/VSCode-light-340w~Y4Rms3bRIfU0-P9LOsBljg.webp 340w, /blog/images/VSCode-light-680w~wPQYuWE9KIu7-FmWmyg0nQ.webp 680w, /blog/images/VSCode-light-1360w~cGaZLYvkX4jLZiMvlFU5Qg.webp 1360w" alt="The first window for the VSCode walkthrough, which lists the steps described above"></p>
<p>Having both VSCode and the VSCode extension <code>OCaml Platform</code> installed will automatically open the walkthrough. Should you need to manually open the walkthrough after installing the OCaml Platform extension, start by clicking on the help menu in the top right corner, then select ‘open walkthrough’, and select the one titled ‘OCaml: Setup opam dev environment (manual)’.</p>
<h2>Until Next Time!</h2>
<p>There are still changes we are looking to make the coming months. Using the input from the feedback form, we want to improve the walkthrough as well as simplify the documentation on OCaml.org to reflect the new changes. Once Dune Package Management has its first full release, we also plan to create a similar walkthrough for that workflow to support its users.</p>
<p>You can connect with us on <a href="https://bsky.app/profile/tarides.com">Bluesky</a>, <a href="https://mastodon.social/@tarides">Mastodon</a>, <a href="https://www.threads.net/@taridesltd">Threads</a>, and <a href="https://www.linkedin.com/company/tarides">LinkedIn</a> or sign up for our mailing list to stay updated on our latest projects. We look forward to hearing from you!</p>
<hr>
<p><em>The featured image of this post contains the logos of <a href="https://github.com/ocaml/ocaml-logo?tab=Unlicense-1-ov-file">OCaml</a>, <a href="https://github.com/ocaml/dune?tab=License-1-ov-file">Dune</a>, and <a href="https://github.com/ocaml-opam/opam2web/tree/master?tab=License-1-ov-file">opam</a>. They are shared under a liberal license, MIT license, and the GNU lesser general public license respectively.</em></p>

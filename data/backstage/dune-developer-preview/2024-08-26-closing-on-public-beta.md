---
title: "Dune Developer Preview: Getting Ready for the Public Beta"
tags: [dune, platform, developer-preview]
---

As we prepare for the public beta, we're ramping up the DX interviews and ensuring the first few users will have a fun, productive experience with the Developer Preview.

> 📥 If you signed up for the Dev Preview back in May, check your inbox for a link and instructions to schedule your DX interview with us.

Here's a sample video on ([Mastodon](https://mas.to/deck/@leostera/112988841207690720) or [X](https://x.com/leostera/status/1825519465527673238)) where you can see us building the Riot project on a machine that does not have OCaml installed. It is pretty neat!

Seriously, big shoutout to the Dune team at Tarides[0] and Jane Street[1] who have been doing a phenomenal job 👏 ✨ 🐫 

So here's what getting started with OCaml looks like using the Dune Developer Preview as of today (August 19 2024):

1. get `dune` from our binary distribution – we'll soon make this public!
2. run `dune pkg lock` in your favorite project
3. run `dune build`

That's it. No need to install anything else! Dune will see that lock file, fetch, and build all necessary dependencies.

> 🗺️ These are some strong steps towards the [OCaml Platform vision for 2026](https://ocaml.org/tools/platform-roadmap) that we are actively working towards. If you have any thoughts or feedback please let us know!

There are more improvements coming that will help remove friction to get started and create a delightful experience. Both of these things we strongly believe will help onboard new users to the OCaml world.

Here's a few in the works:

* **Various DX improvements** – from new outputs to simplified workflows, we want to make using Dune just delightful.

* **Bundled support for dev tools** (OCamlFormat, `odoc`, LSP) – the default toolset will be available without any extra steps! Just call `dune fmt` and it works. No need to manually install anything else.

* **Automatic dependency locking** – when building, and even in watch mode, Dune will lock your dependencies by default and keep the lock up to date.

* **Cross-project caching** – by default we'll enable a local Dune cache across the system, so you never rebuild the same dependency, even across projects.

* **Signed binaries with certificates of origin** – we care deeply about security and want to make sure that any binary we ship can be easily verified and tracked back to its sources.

Stay tuned! 👋 

PS: here's a longer video on ([Mastodon](https://mas.to/deck/@leostera/112988880290815356) or [X](https://x.com/leostera/status/1825519469759812062)) showing you the setup for OCaml from zero, creating a new project, and adding a dependency, all within ~5 minutes

[0] @emillon @Leonidas @gridbugs @tmattio @maiste . Ambre Suhamy, Alpha Diallo
[1] @rgrinberg

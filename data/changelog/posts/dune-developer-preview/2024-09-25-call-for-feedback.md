---
title: "Dune Developer Preview: Call for Feedback"
tags: [dune, platform, developer-preview]
---

Hello folks! 👋 

We'd like to welcome everyone to try and play with the [Dune Developer Preview](https://preview.dune.build)! 🎉

This experimental nightly release of dune includes a lot of improvements, including the much expected package management features, and it can be installed from that website or by using the new installation script:

```bash
$ curl -fsSL https://get.dune.build/install | bash
```

In a few seconds you should be ready to OCaml by calling `dune`:

![Installing the Dune Developer Preview|690x442](upload://bAs05aK4zwlNnd5BsiWgaaXXAA2.gif)

You can also watch and share this demo on [X](https://x.com/leostera/status/1838969568795979922) and [Mastodon](https://mas.to/deck/@leostera/113198996085937679).


Please try it out and let us know what you think 🙏 

📅 You can book a feedback call with us [here](https://calendar.google.com/calendar/u/0/appointments/schedules/AcZssZ3HaJbskiCLHqLS6Oi1S3-rWYwv0hb_Iz8O9VlspuDdK5qbXYUZDpRRlWfEY1GP8KFy6XY8MFb9)

📝 You can submit feedback using [this form](https://docs.google.com/forms/u/2/d/e/1FAIpQLSda-mOTHIdATTt_e9dFmNgUCy-fD55Qzr3bGGsxpfY_Ecfyxw/viewform?usp=send_form)

🐛 You can submit issues to Github on [ocaml/dune](https://github.com/ocaml/dune/issues/new/choose)

### Changes since last update

The Dune shared cache has been enabled by default. We're starting off by caching all downloads and dependencies.

We have improved support for dev tools. We're working to streamline this but in the latest binary you can:

* Configure your LSP (in Neovim, Vim, Emacs, etc) to call `dune tools exec ocamllsp` to get LSP support for your projects out of the box – this may take a little bit the first time it builds the LSP for a compiler version, but it's pretty much instant afterwards.

* Call `dune fmt` to get your project formatted – remember to add an `.ocamlformat` file if you don't have one yet. An empty one is enough.

* Call `dune ocaml doc` to get documentation built 

### What's next?

We're looking forward to streamlining the DX, working on better dependency locks, and looking into supporting Windows.

In particular, we're considering work on a few things:

* `dune create <repo>` – to let the community create templates that can be easily used from within dune
* `dune pkg fetch` – to prefetch packages and prepare a repository for working in offline mode
* `dune build @deps` - to build all dependencies, useful for staged builds in Dockerfiles
* `dune pkg add <name>` - to make adding packages straightforward
* a short-hand syntax for pins on github
* and more!

If you've got any ideas, we'd love to hear them, so please open a feature request on Github 🙏 


## Other updates

#### FunOCaml Presentation
At **FunOCaml** we had a last-minute opportunity to present the work being done on Dune and we used it to introduce the Developer Preview to the community, and even tested Package Management live with suggestions from the audience (thanks @anmonteiro and Paul-Elliot for participating!) – you can [watch it on Twitch](https://www.twitch.tv/videos/2252408016?t=08h12m00s).

#### New design
We're working with @Claire_Vandenberghe on redesigning the Developer Preview website so that it'd feel like a seamless extension of OCaml.org – in this current iteration we've made it easier to get started and we're putting the FAQ front and center.

We'll be iterating on this design in the coming weeks until it fits perfectly within the OCaml.org design system 🎨 

You can check the new website here: https://preview.dune.build

#### Upcoming Blog posts
In the near future we'll be publishing blog posts about the Developer Preview and Package Management, which we're working on with @professor.rose 👏

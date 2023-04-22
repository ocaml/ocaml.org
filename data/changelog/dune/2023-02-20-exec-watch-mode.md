---
title: Watch mode for executables
date: "2023-02-20-02"
tags: [dune, platform, feature]
---

Dune 3.7 now supports watch mode for executables! 🎉

It works just as you'd expect, if you define an executable, you can run it with

```sh
dune exec -w my-executable
```

It will interrupt the process when a file change and re-start the application.

For a practical example of the workflows enabled by watch-mode, check
[this demo](https://github.com/tmattio/dune-watchmode-livereload-demo) of a live
reload for web development:

<video src="https://user-images.githubusercontent.com/6162008/231740987-b2def52a-5369-4288-b895-006795777782.mov" data-canonical-src="https://user-images.githubusercontent.com/6162008/231740987-b2def52a-5369-4288-b895-006795777782.mov" controls="controls" muted="muted" class="d-block rounded-bottom-2 border-top width-fit" style="max-height:640px; min-height: 200px">
</video>
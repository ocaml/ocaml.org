---
id: "platform-overview"
title: "Platform Overview"
description: |
  Tada tada test
category: "Overview"
---

# The OCaml Platform

The OCaml Platform represents the best way for developers, both new and
old, to write software in OCaml. It combines the core OCaml compiler with
a coherent set of tools, documentation, libraries, and testing resources.

Detailed instructions to install OCaml and the
Platform tools are available in [Installing OCaml](/docs/installing-ocaml).

../getting-started/1_00_install_OCaml.md#installing-ocaml

If you want to use the simpler, but experimental way to install the
Platform, you can use the [OCaml Platform Installer](https://github.com/tarides/ocaml-platform-installer). To download it, run:

```
bash < <(curl -sL https://ocaml.org" ^ Url.installer ^ ")
```

And run it to install the Platform tools in your opam switch:

```
ocaml-platform
```

<div
  class="mt-12 cursor-pointer z-0 relative rounded-2xl h-[413px] w-full overflow-hidden border-4 border-primary-100 video-shadow md:w-[640px]"
  x-data='{
          isPlaying: false,
          embed_url: "https://watch.ocaml.org/videos/embed/0e2070fd-798b-47f7-8e69-ef75e967e516",
          iframe_param: "?autoplay=1&mute=1",
          iframe_url() {
            return this.embed_url + this.iframe_param;
          },
        }'>
  <div class="bg-default dark:bg-dark-default text-center relative aspect-w-16 aspect-h-9 h-full" @click="
                  isPlaying = !isPlaying;
                  $nextTick(() => { $refs.iframeElement.setAttribute('src', iframe_url()) });">
    <div x-show.transition.in.opacity.duration.500ms="isPlaying">
      <iframe class="absolute top-0 rounded-lg h-full w-full" x-ref="iframeElement"
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
        allowfullscreen>
      </iframe>
    </div>
    <div class="flex h-full justify-center" x-show="!isPlaying">
      <div class="z-10 mb-10 lg:mb-0">
        <img width="160" class="m-auto mt-10 md:mt-20" src="/asset/logo-with-name.svg" alt="OCaml logo">
        <div class="text-lighter mt-2">OCaml Workshop 2020</div>
        <h3 class="font-bold mt-16">State of the OCaml Platform 2020</h3>
        <div class="mt-16 flex justify-center">
          Presented by&nbsp;
          <div class="font-semibold">Anil Madhavapeddy</div>
        </div>
        <div class="text-lighter mt-2">University of Cambridge</div>
      </div>
    </div>
  </div>
  <div
    class="rounded-full bg-primary-600 text-white w-16 h-16 right-0 left-0 m-auto bottom-5 md:left-auto md:right-10 md:bottom-10 absolute flex items-center z-10 justify-center"
    x-show="!isPlaying">
      <%s! Icons.play "h-9 w-9" %>
  </div>
</div>

### State of the OCaml Platform

Each platform element lives at a different point in the lifecycle of a Platform tool

#### Active

The work-horse tools that are used daily with strong backwards compatibility guarantees from the community.

<!-- use js here?? -->
<div class="grid grid-cols-1 md:grid-cols-2 gap-12 md:pr-20 mt-8 items-start">
<% tools |> List.filter (fun (item : Data.Tool.t) -> item.lifecycle = `Active) |> List.iter (fun (item :
Data.Tool.t) -> %>
<a href="<%s item.source %>" class="flex items-center">
<div class="flex flex-col pr-5 w-full">
<div class="text-primary-600 text-lg font-semibold">
<%s item.name %>
</div>
<div class="text-lighter h-full">
<%s item.synopsis %>
</div>
</div>
<%s! Icons.chevron_right "h-5 w-5" %>
</a>
<% ); %>
</div>

#### Incubate

New tools that fill a gap in the ecosystem but are not quite ready for wide-scale release and adoption.

      <% tools |> List.filter (fun (item : Data.Tool.t) -> item.lifecycle = `Incubate) |> List.iter (fun (item :
        Data.Tool.t) -> %>
        <a href="<%s item.source %>" class="flex items-center">
          <div class="flex flex-col pr-5 w-full">
            <div class="text-primary-600 text-lg font-semibold">
              <%s item.name %>
            </div>
            <div class="text-lighter h-full">
              <%s item.synopsis %>
            </div>
          </div>
          <%s! Icons.chevron_right "h-5 w-5" %>
        </a>
        <% ); %>

#### Sustain

Tools that will not likely see any major feature added but can be used reliably even if not being actively developed.

      <% tools |> List.filter (fun (item : Data.Tool.t) -> item.lifecycle = `Sustain) |> List.iter (fun (item :
        Data.Tool.t) -> %>
        <a href="<%s item.source %>" class="flex items-center">
          <div class="flex flex-col pr-5 w-full">
            <div class="text-primary-600 text-lg font-semibold">
              <%s item.name %>
            </div>
            <div class="text-lighter h-full">
              <%s item.synopsis %>
            </div>
          </div>
          <%s! Icons.chevron_right "h-5 w-5" %>
        </a>
        <% ); %>

#### Deprecate

Tools that are gradually being phased out, with clear paths to better workflows.

      <% tools |> List.filter (fun (item : Data.Tool.t) -> item.lifecycle = `Deprecate) |> List.iter (fun (item :
        Data.Tool.t) -> %>
        <a href="<%s item.source %>" class="flex items-center">
          <div class="flex flex-col pr-5 w-full">
            <div class="text-primary-600 text-lg font-semibold">
              <%s item.name %>
            </div>
            <div class="text-lighter h-full">
              <%s item.synopsis %>
            </div>
          </div>
          <%s! Icons.chevron_right "h-5 w-5" %>
        </a>
        <% ); %>

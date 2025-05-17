---
title: Are you still using OCaml 4.08 or earlier? If so, we need to know
description: 'OCaml users: share your needs regarding older versions to help determine
  support for OCaml 4.08 and earlier.'
url: https://anil.recoil.org/notes/deprecating-ocaml-408
date: 2025-03-05T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<p>I started pushing OCaml Docker images over to the <a href="https://hub.docker.com/r/ocaml/opam">Docker Hub</a> in around 2017, to support the burgeoning automated build infrastructure around the use of the language. Back then, OCaml 4.06 was the latest release, and so I wrote an <a href="https://github.com/ocurrent/ocaml-version/blob/master/CHANGES.md">ocaml-version</a> library to track the release metadata. It has been a bit of a success disaster, as that library now <a href="https://github.com/ocurrent/ocaml-version/blob/master/CHANGES.md">tracks</a> every release of OCaml in the modern era, and also backs the <a href="https://github.com/ocurrent/docker-base-images">automatic building</a> of a huge array of compiler versions and variants across <a href="https://images.ci.ocaml.org/?distro=debian-12&amp;">Linux</a> and <a href="https://images.ci.ocaml.org/?distro=windows-msvc&amp;">Windows</a>.</p>
<p>The problem is...we're now building the full set of images from OCaml 4.02 onwards through to the latest OCaml 5.3.0 release, which is unsustainable for obvious reasons; despite the hosting being kindly <a href="https://www.docker.com/community/open-source/application/">sponsored by Docker</a>, we must also consider the <a href="https://ocaml.org/policies/carbon-footprint">carbon footprint</a> of our infrastructure.
So the question for the OCaml community: <strong>are there are any remaining users who still need images earlier than OCaml 4.08 or can we can stop pushing those now?</strong></p>
<p><a href="https://github.com/hannesm" class="contact">Hannes Mehnert</a> lead an effort to deprecate compilers earlier than 4.08 <a href="https://discuss.ocaml.org/t/opam-repository-archival-phase-2-ocaml-4-08-is-the-lower-bound/15965">in the opam-repo</a>, and now <a href="https://tarides.com/blog/author/mark-elvers/" class="contact">Mark Elvers</a> is asking the same question <a href="https://discuss.ocaml.org/t/docker-base-images-and-ocaml-ci-support-for-ocaml-4-08/16229">on the OCaml discussion forum</a> about the Docker image infrastructure. The latter lags the opam repository since there still may be operational usecases of industrial users who depend on older compilers, even if they don't use the latest package repository.  So if you <em>are</em> using a really old OCaml and depend on our infrastructure, we'd appreciate you chiming in on the <a href="https://discuss.ocaml.org/t/docker-base-images-and-ocaml-ci-support-for-ocaml-4-08/16229">forum thread</a> or just contact <a href="https://tarides.com/blog/author/mark-elvers/" class="contact">Mark Elvers</a> or myself directly to let us know.</p>
<p>On another note, it's also quite difficult on the central <a href="https://hub.docker.com/">Docker Hub</a> to get statistics per-tag as to how many people are using each image. Does anyone have any recommendations on whether we should deploy our own "proxy registry" before pushing through to the central Docker Hub, or alternative open source registries to run our own?</p>


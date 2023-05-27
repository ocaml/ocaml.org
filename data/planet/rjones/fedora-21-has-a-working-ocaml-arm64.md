---
title: Fedora 21 has a working OCaml ARM64
description: "Update: Thanks to Peter Robinson, there is now a build of OCaml for
  aarch64 in the Fedora repository. I have backported the upstream ARM64 support into
  Fedora 21\u2019s OCaml, so you can now use i\u2026"
url: https://rwmj.wordpress.com/2013/12/31/fedora-21-has-a-working-ocaml-arm64/
date: 2013-12-31T13:24:42-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- rjones
---

<p><b>Update:</b> Thanks to Peter Robinson, there is now a <a href="http://arm.koji.fedoraproject.org/koji/buildinfo?buildID=183283">build of OCaml for aarch64 in the Fedora repository</a>.</p>
<p>I have <a href="https://git.fedorahosted.org/git/fedora-ocaml.git">backported the upstream ARM64 support</a> into <a href="http://pkgs.fedoraproject.org/cgit/ocaml.git/commit/?id=2b6c21aaa3d43c784fa5c10d9edc0e80093d3a2f">Fedora 21&rsquo;s OCaml</a>, so you can now use it to generate native ARM64/AArch64 binaries.  If you don&rsquo;t have hardware, <a href="https://rwmj.wordpress.com/2013/12/22/how-to-run-aarch64-binaries-on-an-x86-64-host-using-qemu-userspace-emulation/">use qemu to emulate it instead</a>.</p>


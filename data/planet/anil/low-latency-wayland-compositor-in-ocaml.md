---
title: Low-latency wayland compositor in OCaml
description:
url: https://anil.recoil.org/ideas/wayland
date: 2024-05-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<h1>Low-latency wayland compositor in OCaml</h1>
<p>This is an idea proposed in 2024 as a Cambridge Computer Science Part II project, and is currently <span class="idea-ongoing">being worked on</span> by <a href="mailto:tt492@cam.ac.uk" class="contact">Tom Thorogood</a>. It is co-supervised with <a href="https://ryan.freumh.org" class="contact">Ryan Gibb</a>.</p>
<p>When building situated displays and hybrid streaming
systems, we need fine-grained composition over what to show on the displays.
Wayland is a communications protocol for next-generation display servers used
in Unix-like systems.<sup><a href="https://anil.recoil.org/news.xml#fn-0" role="doc-noteref" class="fn-label">[1]</a></sup></p>
<p>It has been adopted as the default display server by Linux distributions
including Fedora with KDE, and Ubuntu and Debian with GNOME.  It aims to
replace the venerable X display server with a modern alternative.  X leaves
logic such as window management to application software, which has allowed the
proliferation of different approaches.  Wayland, however, centralizes all this
logic in the 'compositor', which assumes both display server and window manager
roles.<sup><a href="https://anil.recoil.org/news.xml#fn-1" role="doc-noteref" class="fn-label">[2]</a></sup></p>
<p>Libraries such as wlroots, libweston, and 'small Wayland compositor', exist to
provide a basis on which to build a Wayland compositor.  Much of the Wayland
ecosystem is written in C, but modern memory-safe, type-safe, composable
systems programming languages like OCaml offer tempting alternatives.  This
project proposes writing a Wayland compositor in OCaml, which opens up interesting
opportunities for writing custom window management logic similar to how xmonad
does for X<sup><a href="https://anil.recoil.org/news.xml#fn-3" role="doc-noteref" class="fn-label">[3]</a></sup> rather than relying on IPC mechanisms used in state-of-the-art
systems.<sup><a href="https://anil.recoil.org/news.xml#fn-4" role="doc-noteref" class="fn-label">[4]</a></sup></p>
<p>This project is suitable for an ambitious student with a keen interest in
graphics, communication protocols, and operating systems.  Starting points
include completing OCaml wlroots bindings<sup><a href="https://anil.recoil.org/news.xml#fn-3" role="doc-noteref" class="fn-label">[3]</a></sup> enough to implement an OCaml
version of the tinywl compositor<sup><a href="https://anil.recoil.org/news.xml#fn-5" role="doc-noteref" class="fn-label">[5]</a></sup> and the pure OCaml implementation of the
Wayland protocol.<sup><a href="https://anil.recoil.org/news.xml#fn-6" role="doc-noteref" class="fn-label">[6]</a></sup></p>
<p>If you want to read a really fun historical paper that inspires this work, then
the <a href="https://www.cl.cam.ac.uk/research/dtg/attarchive/pub/docs/att/tr.94.4.pdf">teleporting displays</a>
paper should give you some entertaining background.</p>
<section role="doc-endnotes"><ol>
<li>
<p><a href="https://wayland.freedesktop.org/">https://wayland.freedesktop.org/</a></p>
<span><a href="https://anil.recoil.org/news.xml#ref-1-fn-0" role="doc-backlink" class="fn-label">↩︎︎</a></span></li><li>
<p><a href="https://wayland.freedesktop.org/faq.html#heading_toc_j_11">https://wayland.freedesktop.org/faq.html#heading_toc_j_11</a></p>
<span><a href="https://anil.recoil.org/news.xml#ref-1-fn-1" role="doc-backlink" class="fn-label">↩︎︎</a></span></li><li>
<p><a href="https://github.com/swaywm/ocaml-wlroots">https://github.com/swaywm/ocaml-wlroots</a></p>
<span><a href="https://anil.recoil.org/news.xml#ref-1-fn-3" role="doc-backlink" class="fn-label">↩︎︎<sup>1</sup></a><a href="https://anil.recoil.org/news.xml#ref-2-fn-3" role="doc-backlink" class="fn-label">↩︎︎<sup>2</sup></a></span></li><li>
<p><a href="https://github.com/swaywm/sway/blob/master/sway/sway-ipc.7.scd">https://github.com/swaywm/sway/blob/master/sway/sway-ipc.7.scd</a></p>
<span><a href="https://anil.recoil.org/news.xml#ref-1-fn-4" role="doc-backlink" class="fn-label">↩︎︎</a></span></li><li>
<p><a href="https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/tinywl/tinywl.c">https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/tinywl/tinywl.c</a></p>
<span><a href="https://anil.recoil.org/news.xml#ref-1-fn-5" role="doc-backlink" class="fn-label">↩︎︎</a></span></li><li>
<p><a href="https://github.com/talex5/ocaml-wayland">https://github.com/talex5/ocaml-wayland</a></p>
<span><a href="https://anil.recoil.org/news.xml#ref-1-fn-6" role="doc-backlink" class="fn-label">↩︎︎</a></span></li></ol></section>


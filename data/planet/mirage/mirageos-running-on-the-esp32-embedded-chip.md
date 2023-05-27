---
title: MirageOS running on the ESP32 embedded chip
description:
url: https://mirage.io/blog/2018-esp32-booting
date: 2018-01-26T00:00:00-00:00
preview_image:
featured:
authors:
- Anil Madhavapeddy
---


        <p>Now that the winter holiday break is over, we are starting to see the results of winter hacking among our community.</p>
<p>The first great hack for 2018 is from <a href="http://toao.com">Sadiq Jaffer</a>, who got OCaml booting on a tiny and relatively new CPU architecture -- the <a href="http://esp32.net">Espressif ESP32</a>.  After proudly demonstrating a battery powered version to the folks at <a href="https://ocamllabs.io">OCaml Labs</a>, he then proceeded to clean it up enough tha it can be built with a <a href="https://github.com/sadiqj/ocaml-esp32-docker">Dockerfile</a>, so that others can start to do a native code port and get bindings to the networking interface working.</p>
<p><a href="http://toao.com/blog/getting-ocaml-running-on-the-esp32#getting-ocaml-running-on-the-esp32">Read all about it on Sadiq's blog</a>, and thanks for sharing this with us, Sadiq!</p>
<p>We also noticed that another OCaml generic virtual machine for even smaller microcontrollers has <a href="https://github.com/stevenvar/omicrob">shown up on GitHub</a>.  This, combined with some functional metaprogramming, may mean that 2018 is the year of OCaml in all the tiny embedded things...</p>

      

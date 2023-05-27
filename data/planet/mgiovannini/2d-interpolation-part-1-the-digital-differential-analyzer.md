---
title: '2D Interpolation, Part 1: The Digital Differential Analyzer'
description: To my Planet OCaml readers, I apologize for veering into Java. I've been
  playing with Processing of lately, because it's far easier to proto...
url: https://alaska-kamtchatka.blogspot.com/2012/06/2d-interpolation-part-1-digital.html
date: 2012-06-25T15:00:00-00:00
preview_image:
featured:
authors:
- "Mat\xEDas Giovannini"
---

To my Planet OCaml readers, I apologize for veering into Java. I've been playing with Processing of lately, because it's far easier to prototype silly, simple animations (fractals! Fractals everywhere!) in it than by using OCamlSDL, say. Last time I showed a basic 2D interpolator; now it's time to start massaging it into shape. Let's recall the original code:


void interp0() {
  final float dy =

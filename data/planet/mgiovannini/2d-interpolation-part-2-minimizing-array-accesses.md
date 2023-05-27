---
title: '2D Interpolation, Part 2: Minimizing Array Accesses'
description: Last time I massaged the interpolator  to avoid computing every time
  the linear transformation from destination space to source space, using...
url: https://alaska-kamtchatka.blogspot.com/2012/06/2d-interpolation-part-2-minimizing.html
date: 2012-06-26T13:00:00-00:00
preview_image:
featured:
authors:
- "Mat\xEDas Giovannini"
---

Last time I massaged the interpolator to avoid computing every time the linear transformation from destination space to source space, using only integer variables. With that rewriting, it is time to avoid referencing source values more than is needed. First thing we do, let's name all elements:


void interp0() {
  int offset = 0;
  int yn = 0;
  int yi = 1;
  for (int i = 0; i &lt; height; i++) {


---
title: '2D Interpolation, Part 4: ARGB Interpolation'
description: After linearizing all array accesses , interpolating ARGB values is easy
  from the algorithmic side of things; so easy things first. I'll han...
url: https://alaska-kamtchatka.blogspot.com/2012/06/2d-interpolation-part-4-argb.html
date: 2012-06-28T15:00:00-00:00
preview_image: //4.bp.blogspot.com/-y__nUozm2S4/T-XDJWhHuKI/AAAAAAAAAU8/AnMnevHLMC4/w1200-h630-p-k-no-nu/interp3.png
featured:
authors:
- "Mat\xEDas Giovannini"
---

After linearizing all array accesses, interpolating ARGB values is easy from the algorithmic side of things; so easy things first. I'll handle the pixel interpolation proper by abstracting them away in their own little functions. Processing an ARGB source array is just a matter of changing the variable declarations:


final int[] srcpix = {
0xff0051ff, 0xff00fffb, 0xff9cff00, 0xff0051ff,


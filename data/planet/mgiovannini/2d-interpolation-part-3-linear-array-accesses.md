---
title: '2D Interpolation, Part 3: Linear Array Accesses'
description: Last time I've hoisted all accesses  to the source array. This opens
  the door to being able to process linear arrays representing a matrix i...
url: https://alaska-kamtchatka.blogspot.com/2012/06/2d-interpolation-part-3-linear-array.html
date: 2012-06-27T15:00:00-00:00
preview_image:
featured:
authors:
- "Mat\xEDas Giovannini"
---

Last time I've hoisted all accesses to the source array. This opens the door to being able to process linear arrays representing a matrix in row-major order by stenciling. Not only that, but I was able to completely eliminate the need to have a bordered array on input by explicitly replicating elements as needed. The first step is to use a row buffer into which to copy the elements to be 

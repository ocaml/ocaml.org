---
title: '2D Interpolation, Part 5: Final Optimizations'
description: The code has now the proper shape  to carry out optimizations to their
  logical consequences, to the point that I question the wisdom in some...
url: https://alaska-kamtchatka.blogspot.com/2012/06/2d-interpolation-part-5-final.html
date: 2012-06-29T15:00:00-00:00
preview_image:
featured:
authors:
- "Mat\xEDas Giovannini"
---

The code has now the proper shape to carry out optimizations to their logical consequences, to the point that I question the wisdom in some of the previous transformations. It is true that in compiler construction some passes introduce constructs only for latter passes to eliminate them, in the hope of an overall simplification. In this case the starting point will be the elimination of the 

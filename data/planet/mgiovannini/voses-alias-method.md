---
title: Vose's Alias Method
description: This is a note regarding the implementation of Vose's Method  to construct
  the alias tables for non-uniform discrete probability sampling pr...
url: https://alaska-kamtchatka.blogspot.com/2011/12/voses-alias-method.html
date: 2011-12-29T17:12:00-00:00
preview_image:
featured:
authors:
- "Mat\xEDas Giovannini"
---

This is a note regarding the implementation of Vose's Method to construct the alias tables for non-uniform discrete probability sampling presented by Keith Schwartz (as of 2011-12-29). Mr. Schwartz otherwise very informative write-up contains an error in the presentation of the Method. Step 5 of the algorithm fails if the Small list is nonempty but the Large list is. This can happen either:
if 

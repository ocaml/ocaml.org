---
title: A Helping Phantom Hand
description: You don't have to be writing an interpreter or some other kind of abstract
  code to profit from some phantom types. Suppose you have two or m...
url: https://alaska-kamtchatka.blogspot.com/2012/08/a-helping-phantom-hand.html
date: 2012-08-02T13:59:00-00:00
preview_image:
featured:
authors:
- "Mat\xEDas Giovannini"
---

You don't have to be writing an interpreter or some other kind of abstract code to profit from some phantom types. Suppose you have two or more functions that work by &quot;cooking&quot; a simple value (a float, say) with a lengthy computation before proceeding:


let sun_geometric_longitude j =
  let je = to_jcen (to_jde j) in
  (* &hellip; computation with je &hellip; *)

let sun_apparent_longitude j =
  let je = 

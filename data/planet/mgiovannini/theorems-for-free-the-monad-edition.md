---
title: 'Theorems for Free: The Monad Edition'
description: 'This is for the record, since the derivations took me a while and I''d
  rather not lose them.   A functor  is the signature:    module type FU...'
url: https://alaska-kamtchatka.blogspot.com/2012/07/theorems-for-free-monad-edition.html
date: 2012-07-19T15:00:00-00:00
preview_image:
featured:
authors:
- "Mat\xEDas Giovannini"
---

This is for the record, since the derivations took me a while and I'd rather not lose them.

A functor is the signature:


module type FUNCTOR = sig
  type 'a t
  val fmap : ('a -&gt; 'b) -&gt; ('a t -&gt; 'b t)
end


satisfying the following laws:


Identity:    fmap id      &equiv; id
Composition: fmap (f &#8728; g) &equiv; fmap f &#8728; fmap g


An applicative structure or idiom is the signature:


module type APPLICATIVE = 

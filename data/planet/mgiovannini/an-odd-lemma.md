---
title: An Odd Lemma
description: "While proving that every monad is an applicative functor, I extracted
  the following derivation as a lemma:      fmap f \u2218 (\u03BBh. fmap h x) \u2261
  { ..."
url: https://alaska-kamtchatka.blogspot.com/2012/07/odd-lemma.html
date: 2012-07-17T17:36:00-00:00
preview_image:
featured:
authors:
- "Mat\xEDas Giovannini"
---

While proving that every monad is an applicative functor, I extracted the following derivation as a lemma:


  fmap f &#8728; (&lambda;h. fmap h x)
&equiv; { defn. &#8728;, &beta;-reduction }
  &lambda;g. fmap f (fmap g x)
&equiv; { defn. &#8728; }
  &lambda;g. (fmap f &#8728; fmap g) x
&equiv; { Functor }
  &lambda;g. fmap (f &#8728; g) x
&equiv; { abstract f &#8728; g }
  &lambda;g. (&lambda;h. fmap h x) (f &#8728; g)
&equiv; { defn. &#8728;, &eta;-contraction }
  (&lambda;h. fmap h x) &#8728; (f &#8728;)


for all f, x. This is the Yoneda

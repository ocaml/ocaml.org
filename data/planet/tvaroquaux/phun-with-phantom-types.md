---
title: Phun with phantom types!!
description: 'Phantom types are a nifty trick: types are used to store additional
  information during the type-checking pass. These types have no implement...'
url: https://till-varoquaux.blogspot.com/2007/06/phun-with-phantom-types.html
date: 2007-06-03T21:51:00-00:00
preview_image:
featured:
authors:
- Till
---

<p>Phantom types are a nifty trick: types are used to store additional
information during the type-checking pass. These types have no
implementations (there are no values actually having these types) but are
still used as type parameter to tag values. This additional info is then used
by the type system to statically ensure some conditions are met. As, I'm
guessing this is all getting rather intriguing (or confusing) I propose to
step through a very simple example.</p>

<h2>Without phantom types</h2>

<p>Let's start out with a very basic library to handle lists:</p>

<div style="background:#e6e6e6;border:1px solid #a0a0a0;">
  <tt><span style="font-style: italic"><span style="color: #9A1900">(*The&nbsp;empty&nbsp;list*)</span></span><br/>
  <span style="font-weight: bold"><span style="color: #0000FF">let</span></span>&nbsp;nil<span style="color: #990000">=[]</span><br/>
  <span style="font-style: italic"><span style="color: #9A1900">(*Appends&nbsp;an&nbsp;element&nbsp;in&nbsp;front&nbsp;of&nbsp;a&nbsp;list*)</span></span><br/>
  <span style="font-weight: bold"><span style="color: #0000FF">let</span></span>&nbsp;cons&nbsp;e&nbsp;l&nbsp;<span style="color: #990000">=</span>&nbsp;e<span style="color: #990000">::</span>l<br/>
  <span style="font-style: italic"><span style="color: #9A1900">(*Converts&nbsp;two&nbsp;list&nbsp;of&nbsp;same&nbsp;sizes&nbsp;to&nbsp;a&nbsp;list&nbsp;of&nbsp;couples&nbsp;*)</span></span><br/>
  <span style="font-weight: bold"><span style="color: #0000FF">let</span></span>&nbsp;combine&nbsp;<span style="color: #990000">=</span>&nbsp;<span style="font-weight: bold"><span style="color: #000080">List</span></span><span style="color: #990000">.</span>combine</tt>
</div>

<p>Combine needs both of its arguments to be of the same length. This is
typically a job for <a href="http://en.wikipedia.org/wiki/Dependent_type" class="externalLink">dependent types</a> (i.e. types
depending on a value) where list length would be encoded in their types.
Ocaml doesn't have dependant type but we'll see how to leverage the type
inference mechanism to encode lengths.</p>

<h2>Encoding the length</h2>

<p>Since our types cannot contain values we need to find a way to code
integers in our type system. We will using an encoding based on <a href="http://en.wikipedia.org/wiki/Peano_axioms#Peano.27s_axioms" class="externalLink">Peano's
axiom's</a>:</p>

<div style="background:#e6e6e6;border:1px solid #a0a0a0;">
  <tt><span style="font-weight: bold"><span style="color: #0000FF">type</span></span>&nbsp;zero<br/>
  <span style="font-weight: bold"><span style="color: #0000FF">type</span></span>&nbsp;'length&nbsp;succ</tt>
</div>

<p>0 is represented by the type <span style="background:#e6e6e6;border:1px solid #a0a0a0;"><tt>zero</tt></span>, 1 by
<span style="background:#e6e6e6;border:1px solid #a0a0a0;"><tt>succ&nbsp;zero</tt></span>,
2 by <span style="background:#e6e6e6;border:1px solid #a0a0a0;"><tt>succ&nbsp;succ&nbsp;zero</tt></span>
etc... There exist no values having these types: they are empty.</p>

<h2>Using the phantom type</h2>

<p>The previous type will be the &quot;phantom type&quot;: it will be used to encode
additional info but won't represent the type of any actual object.</p>

<p>The idea here is to make our lists depend on that type to store the length
info. Instead of being <span style="background:#e6e6e6;border:1px solid #a0a0a0;"><tt>'a&nbsp;<span style="color: #009900">list</span></tt></span> our list type is now:</p>

<div style="background:#e6e6e6;border:1px solid #a0a0a0;">
  <tt><span style="font-weight: bold"><span style="color: #0000FF">type</span></span>&nbsp;<span style="color: #990000">(</span>'a<span style="color: #990000">,</span>'length<span style="color: #990000">)</span>&nbsp;t</tt>
</div>

<p>where <span style="background:#e6e6e6;border:1px solid #a0a0a0;"><tt>'length</tt></span>
represents the length of the list. Giving types to our previous functions is
now straightforward:</p>

<div style="background:#e6e6e6;border:1px solid #a0a0a0;">
  <tt><span style="font-weight: bold"><span style="color: #0000FF">val</span></span>&nbsp;nil<span style="color: #990000">:(</span>'a<span style="color: #990000">,</span>zero<span style="color: #990000">)</span>&nbsp;t<br/>
  <span style="font-weight: bold"><span style="color: #0000FF">val</span></span>&nbsp;cons<span style="color: #990000">:</span>'a&nbsp;<span style="color: #990000">-&gt;</span>&nbsp;<span style="color: #990000">(</span>'a<span style="color: #990000">,</span>'length<span style="color: #990000">)</span>&nbsp;t&nbsp;<span style="color: #990000">-&gt;</span>&nbsp;<span style="color: #990000">(</span>'a<span style="color: #990000">,(</span>'length&nbsp;succ<span style="color: #990000">))</span>&nbsp;t<br/>
  <span style="font-weight: bold"><span style="color: #0000FF">val</span></span>&nbsp;combine<span style="color: #990000">:(</span>'a<span style="color: #990000">,</span>'length<span style="color: #990000">)</span>&nbsp;t&nbsp;<span style="color: #990000">-&gt;</span>&nbsp;<span style="color: #990000">(</span>'b<span style="color: #990000">,</span>'length<span style="color: #990000">)</span>&nbsp;t&nbsp;<span style="color: #990000">-&gt;</span>&nbsp;<span style="color: #990000">((</span>'a<span style="color: #990000">*</span>'b<span style="color: #990000">),</span>'length<span style="color: #990000">)</span>&nbsp;t</tt>
</div>

<p>and since under the hood we are using standard OCaml's list, converting
from our list to a normal list is a plain identity. We'll now wrap everything
in a nice module in order to hide the internals:</p>

<div style="background:#e6e6e6;border:1px solid #a0a0a0;">
  <tt><span style="font-weight: bold"><span style="color: #0000FF">module</span></span>&nbsp;<span style="color: #009900">DepList</span><span style="color: #990000">:</span><br/>
  <span style="font-weight: bold"><span style="color: #0000FF">sig</span></span><br/>
  &nbsp;<span style="font-weight: bold"><span style="color: #0000FF">type</span></span>&nbsp;zero<br/>
  &nbsp;<span style="font-weight: bold"><span style="color: #0000FF">type</span></span>&nbsp;'length&nbsp;succ<br/>
  &nbsp;<span style="font-weight: bold"><span style="color: #0000FF">type</span></span>&nbsp;<span style="color: #990000">(</span>'a<span style="color: #990000">,</span>'length<span style="color: #990000">)</span>&nbsp;t<br/>
  &nbsp;<span style="font-weight: bold"><span style="color: #0000FF">val</span></span>&nbsp;nil<span style="color: #990000">:(</span>'a<span style="color: #990000">,</span>zero<span style="color: #990000">)</span>&nbsp;t<br/>
  &nbsp;<span style="font-weight: bold"><span style="color: #0000FF">val</span></span>&nbsp;cons<span style="color: #990000">:</span>'a&nbsp;<span style="color: #990000">-&gt;</span>&nbsp;<span style="color: #990000">(</span>'a<span style="color: #990000">,</span>'length<span style="color: #990000">)</span>&nbsp;t&nbsp;<span style="color: #990000">-&gt;</span>&nbsp;<span style="color: #990000">(</span>'a<span style="color: #990000">,(</span>'length&nbsp;succ<span style="color: #990000">))</span>&nbsp;t<br/>
  &nbsp;<span style="font-weight: bold"><span style="color: #0000FF">val</span></span>&nbsp;toList<span style="color: #990000">:(</span>'a<span style="color: #990000">,</span>'length<span style="color: #990000">)</span>&nbsp;t&nbsp;<span style="color: #990000">-&gt;</span>&nbsp;'a&nbsp;<span style="color: #009900">list</span><br/>
  &nbsp;<span style="font-weight: bold"><span style="color: #0000FF">val</span></span>&nbsp;combine<span style="color: #990000">:(</span>'a<span style="color: #990000">,</span>'length<span style="color: #990000">)</span>&nbsp;t&nbsp;<span style="color: #990000">-&gt;</span>&nbsp;<span style="color: #990000">(</span>'b<span style="color: #990000">,</span>'length<span style="color: #990000">)</span>&nbsp;t&nbsp;<span style="color: #990000">-&gt;</span>&nbsp;<span style="color: #990000">((</span>'a<span style="color: #990000">*</span>'b<span style="color: #990000">),</span>'length<span style="color: #990000">)</span>&nbsp;t<br/>
  <span style="font-weight: bold"><span style="color: #0000FF">end</span></span><br/>
  &nbsp;<span style="color: #990000">=</span><br/>
  <span style="font-weight: bold"><span style="color: #0000FF">struct</span></span><br/>
  &nbsp;<span style="font-weight: bold"><span style="color: #0000FF">type</span></span>&nbsp;zero<br/>
  &nbsp;<span style="font-weight: bold"><span style="color: #0000FF">type</span></span>&nbsp;'b&nbsp;succ<br/>
  &nbsp;<span style="font-weight: bold"><span style="color: #0000FF">type</span></span>&nbsp;<span style="color: #990000">(</span>'a<span style="color: #990000">,</span>'length<span style="color: #990000">)</span>&nbsp;t<span style="color: #990000">=</span>'a&nbsp;<span style="color: #009900">list</span><br/>
  &nbsp;<span style="font-weight: bold"><span style="color: #0000FF">let</span></span>&nbsp;nil<span style="color: #990000">=[]</span><br/>
  &nbsp;<span style="font-weight: bold"><span style="color: #0000FF">let</span></span>&nbsp;cons&nbsp;e&nbsp;l&nbsp;<span style="color: #990000">=</span>&nbsp;e<span style="color: #990000">::</span>l<br/>
  &nbsp;<span style="font-weight: bold"><span style="color: #0000FF">let</span></span>&nbsp;combine&nbsp;<span style="color: #990000">=</span>&nbsp;<span style="font-weight: bold"><span style="color: #000080">List</span></span><span style="color: #990000">.</span>combine<br/>
  &nbsp;<span style="font-weight: bold"><span style="color: #0000FF">let</span></span>&nbsp;toList&nbsp;l&nbsp;<span style="color: #990000">=</span>&nbsp;l<br/>
  <span style="font-weight: bold"><span style="color: #0000FF">end</span></span></tt>
</div>

<h2>Testing it all</h2>

<p>And it's now time to play with our library...</p>

<div style="background:#e6e6e6;border:1px solid #a0a0a0;">
  <tt>#&nbsp;<span style="font-weight: bold"><span style="color: #000080">open</span></span>&nbsp;<span style="color: #009900">DepList</span><span style="color: #990000">;;</span><br/>
  #&nbsp;<span style="font-weight: bold"><span style="color: #0000FF">let</span></span>&nbsp;a<span style="color: #990000">=</span>cons&nbsp;<span style="color: #993399">5</span>&nbsp;<span style="color: #990000">(</span>cons&nbsp;<span style="color: #993399">6</span>&nbsp;nil<span style="color: #990000">);;</span><br/>
  <span style="font-weight: bold"><span style="color: #0000FF">val</span></span>&nbsp;a&nbsp;<span style="color: #990000">:</span>&nbsp;<span style="color: #990000">(</span><span style="color: #009900">int</span><span style="color: #990000">,</span>&nbsp;<span style="font-weight: bold"><span style="color: #000080">DepList</span></span><span style="color: #990000">.</span>zero&nbsp;<span style="font-weight: bold"><span style="color: #000080">DepList</span></span><span style="color: #990000">.</span>succ&nbsp;<span style="font-weight: bold"><span style="color: #000080">DepList</span></span><span style="color: #990000">.</span>succ<span style="color: #990000">)</span>&nbsp;<span style="font-weight: bold"><span style="color: #000080">DepList</span></span><span style="color: #990000">.</span>t&nbsp;<span style="color: #990000">=</span>&nbsp;<span style="color: #990000">&lt;</span>abstr<span style="color: #990000">&gt;</span><br/>
  #&nbsp;toList&nbsp;a<span style="color: #990000">;;</span><br/>
  <span style="color: #990000">-</span>&nbsp;<span style="color: #990000">:</span>&nbsp;<span style="color: #009900">int</span>&nbsp;<span style="color: #009900">list</span>&nbsp;<span style="color: #990000">=</span>&nbsp;<span style="color: #990000">[</span><span style="color: #993399">5</span><span style="color: #990000">;</span>&nbsp;<span style="color: #993399">6</span><span style="color: #990000">]</span><br/>
  #&nbsp;<span style="font-weight: bold"><span style="color: #0000FF">let</span></span>&nbsp;b<span style="color: #990000">=</span>cons&nbsp;<span style="color: #FF0000">&quot;a&quot;</span>&nbsp;nil<span style="color: #990000">;;</span><br/>
  <span style="font-weight: bold"><span style="color: #0000FF">val</span></span>&nbsp;b&nbsp;<span style="color: #990000">:</span>&nbsp;<span style="color: #990000">(</span><span style="color: #009900">string</span><span style="color: #990000">,</span>&nbsp;<span style="font-weight: bold"><span style="color: #000080">DepList</span></span><span style="color: #990000">.</span>zero&nbsp;<span style="font-weight: bold"><span style="color: #000080">DepList</span></span><span style="color: #990000">.</span>succ<span style="color: #990000">)</span>&nbsp;<span style="font-weight: bold"><span style="color: #000080">DepList</span></span><span style="color: #990000">.</span>t&nbsp;<span style="color: #990000">=</span>&nbsp;<span style="color: #990000">&lt;</span>abstr<span style="color: #990000">&gt;</span><br/>
  #&nbsp;combine&nbsp;a&nbsp;b<span style="color: #990000">;;</span><br/>
  <span style="color: #009900">Characters</span>&nbsp;<span style="color: #993399">10</span><span style="color: #990000">-</span><span style="color: #993399">11</span><span style="color: #990000">:</span><br/>
  &nbsp;&nbsp;combine&nbsp;a&nbsp;b<span style="color: #990000">;;</span><br/>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #990000">^</span><br/>
  <span style="color: #009900">This</span>&nbsp;expression&nbsp;has&nbsp;<span style="font-weight: bold"><span style="color: #0000FF">type</span></span>&nbsp;<span style="color: #990000">(</span><span style="color: #009900">string</span><span style="color: #990000">,</span>&nbsp;<span style="font-weight: bold"><span style="color: #000080">DepList</span></span><span style="color: #990000">.</span>zero&nbsp;<span style="font-weight: bold"><span style="color: #000080">DepList</span></span><span style="color: #990000">.</span>succ<span style="color: #990000">)</span>&nbsp;<span style="font-weight: bold"><span style="color: #000080">DepList</span></span><span style="color: #990000">.</span>t<br/>
  but&nbsp;is&nbsp;here&nbsp;used&nbsp;<span style="font-weight: bold"><span style="color: #0000FF">with</span></span>&nbsp;<span style="font-weight: bold"><span style="color: #0000FF">type</span></span><br/>
  &nbsp;&nbsp;<span style="color: #990000">(</span><span style="color: #009900">string</span><span style="color: #990000">,</span>&nbsp;<span style="font-weight: bold"><span style="color: #000080">DepList</span></span><span style="color: #990000">.</span>zero&nbsp;<span style="font-weight: bold"><span style="color: #000080">DepList</span></span><span style="color: #990000">.</span>succ&nbsp;<span style="font-weight: bold"><span style="color: #000080">DepList</span></span><span style="color: #990000">.</span>succ<span style="color: #990000">)</span>&nbsp;<span style="font-weight: bold"><span style="color: #000080">DepList</span></span><span style="color: #990000">.</span>t</tt>
</div>

<p>That's right we've just statically caught an error because <span style="background:#e6e6e6;border:1px solid #a0a0a0;"><tt>combine</tt></span> was
called with two lists of different lengths!</p>

<h2>Conclusion</h2>

<p>Phantom types are a fun hack to play with, alas they are very restrictive
and rarely useful. Their big brothers (<a href="http://www.haskell.org/ghc/docs/6.4/html/users_guide/gadt.html" class="externalLink">GADT's</a>
and dependant types) require specific type systems and are tricky to
groke.</p>

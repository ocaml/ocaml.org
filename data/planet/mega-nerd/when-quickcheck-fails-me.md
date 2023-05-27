---
title: When QuickCheck Fails Me
description:
url: http://www.mega-nerd.com/erikd/Blog/CodeHacking/Haskell/quickcheck_fail.html
date: 2014-01-08T10:03:00-00:00
preview_image:
featured:
authors:
- mega-nerd
---



<p>
This is an old trick I picked up from a colleague over a decade ago and have
re-invented or re-remembered a number of times since.
</p>

<p>
When implementing complicated performance critical algorithms and things
don't work immediately, the best idea is to drop back to the old formula of:
</p>

<ul>
<li>Make it compile.</li>
<li>Make it correct.</li>
<li>Make it fast.</li>
</ul>

<p>
Often than means implementing slow naive versions of parts of the algorithm
first and then one-by-one replacing the slow versions with fast versions.
For a given function of two inputs, this might give me two functions with the
identical type signatures:
</p>

<pre class="code">

   functionSlow :: A -&gt; B -&gt; C
   functionFast :: A -&gt; B -&gt; C

</pre>

<p>
that can be used interchangeably.
</p>

<p>
When it comes to implementing the fast versions, the slow versions can be used
to check the correct-ness of the fast version using a simple QuickCheck property
like:
</p>

<pre class="code">

   \ a b -&gt; functionFast a b == functionSlow a b

</pre>

<p>
This property basically just asks QuickCheck to generate a, b pairs, pass these
to both functions and compare their outputs.
</p>

<p>
With something like this, QuickCheck usually all finds the corner cases really
quickly.
Except for when it doesn't.
QuickCheck uses a random number generator to generate inputs to the function
under test.
If for instance you have a function that takes a floating point number and only
behaves incorrectly when that input is say exactly 10.3, the chances of QuickCheck
generating exactly 10.3 and hitting the bug are very small.
</p>

<p>
For exactly this reason, using the technique above sometimes doesn't work.
Sometimes the fast version has a bug that Quickcheck wasn't able to find.
</p>

<p>
When this happens the trick is to write a third function:
</p>

<pre class="code">

  functionChecked :: A -&gt; B -&gt; C
  functionChecked a b =
      let fast = functionFast a b
          slow = functionSlow a b
      in if fast == slow
           then fast
           else error $ &quot;functionFast &quot; ++ show a ++ &quot; &quot; ++ show b
                ++ &quot;\nreturns    &quot; ++ show fast
                ++ &quot;\n should be &quot; ++ show slow

</pre>

<p>
which calculates the function output using both the slow and the fast versions,
compares the outputs and fails with an error if the two function outputs are not
identical.
</p>


<p>
Using this in my algorithm I can then collect failing test cases that QuickCheck
couldn't find.
With a failing test case, its usually pretty easy to fix the broken fast
version of the function.
</p>



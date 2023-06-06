---
title: "Creating Stream Combinators in Haskell\u2019s Stream Fusion Library"
description: "So I took a look at the Haskell Stream Fusion library the other day,
  and got the idea to write a new append combinator that would merge the two streams
  in sort order. This seemed simple enough to c\u2026"
url: https://mcclurmc.wordpress.com/2010/03/21/creating-stream-combinators/
date: 2010-03-21T21:42:12-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- mcclurmc
---

<p>So I took a look at the Haskell <a href="http://www.cse.unsw.edu.au/~dons/papers/CLS07.html">Stream Fusion</a> <a href="http://hackage.haskell.org/packages/archive/stream-fusion/0.1.2.2/doc/html/Data-Stream.html">library</a> the other day, and got the idea to write a new <code>append</code> combinator that would merge the two streams in sort order. This seemed simple enough to code directly using Streams, but my first instinct is always to write the code using lists, and then translate it into the more complicated syntax. Here&rsquo;s what a sorting merge function looks like over lists:</p>
<p><code></code></p>
<pre>merge :: Ord a =&gt; [a] -&gt; [a] -&gt; [a]
merge []     bs                 = bs
merge as     []                 = as
merge (a:as) (b:bs) | a &lt; b     = a : merge as (b:bs)
                    | otherwise = b : merge (a:as) bs
</pre>
<p></p>
<p>We have two base cases where either one of the argument lists may be null, in which case we just return the other. For the recursive case, we just <code>cons</code> the lesser of the two list heads onto the rest of the list, and leave the other list head attached to its list in-place. Simple and elegant.</p>
<p>So the Stream version should be just as easy, right? Let&rsquo;s see.</p>
<p><code></code></p>
<pre>mergeS_wrong :: Ord a =&gt; Stream a -&gt; Stream a -&gt; Stream a
mergeS_wrong (Stream nexta sa0) (Stream nextb sb0) = Stream next (sa0, sb0)
    where
      next (sa0, sb0) =
          case (nexta sa0, nextb sb0) of
            (Done, sb) -&gt;
                case sb of
                  Done        -&gt; Done
                  Skip sb'    -&gt; Skip    (sa0, sb')
                  Yield b sb' -&gt; Yield b (sa0, sb')
            (sa, Done) -&gt;
                case sa of
                  Done        -&gt; Done
                  Skip sa'    -&gt; Skip    (sa', sb0)
                  Yield a sa' -&gt; Yield a (sa', sb0)
            (sa, sb) -&gt;
                case sa of 
                  Done        -&gt; Done -- shouldn't happen
                  Skip sa'    -&gt; Skip    (sa', sb0)
                  Yield a sa' -&gt;
                      case sb of
                        Done                    -&gt; Done -- shouldn't happen
                        Skip sb'                -&gt; Yield a (sa', sb')
                        Yield b sb' | a &lt; b     -&gt; Yield a (sa', sb0)
                                    | otherwise -&gt; Yield b (sa0, sb')
</pre>
<p></p>
<p>Looks like a wordier version of the first. We take the first element of each stream, and use a case expression to check each of our cases. The first two base cases are a little longer this time because we can&rsquo;t just return the other stream, but instead have to either <code>Skip</code> or <code>Yield</code> over the remainder of the Stream. In the third case, we must <code>Skip</code> over the first Stream until we <code>Yield</code> a value, and then do the same for the second stream. We compare the two values, <code>Yield</code> the lesser, and return the two remaining Streams.</p>
<p>The only problem is that this won&rsquo;t compile. <code>GHCi</code> gives us the following error message:</p>
<p><code></code></p>
<pre>*Main&gt; :load &quot;/home/mike/Projects/Haskell_SVN/NumWords.hs&quot;
[1 of 1] Compiling Main             ( /home/mike/Projects/Haskell_SVN/NumWords.hs, interpreted )

/home/mike/Projects/Haskell_SVN/NumWords.hs:59:53:
    Could not deduce (Data.Stream.Unlifted (s, s1))
      from the context (Data.Stream.Unlifted s1)
      arising from a use of `Stream'
</pre>
<p></p>
<p>What&rsquo;s this <code>Data.Stream.Unlifted</code> type? Turns out that our Stream data type is encapsulated by a universally quantified type <code>s</code> that is an instance of the hidden type class <code>Unlifted</code>. The standard Haskell pair type <code>(,)</code> isn&rsquo;t, unfortunately, an exposed instance of this class. Which means that we can&rsquo;t make a Stream out of a pair of Streams, as we did on the second line of code with <code>Stream next (sa0, sb0)</code>.</p>
<p>Or so I thought. That is, until I realized (after much hand wringing) that the library did expose a data type that would allow us to use our own types &mdash; or, indeed, all of the standard Haskell types, such as pair. The type we need is</p>
<p><code></code></p>
<pre>data L a = L a
instance Unlifted (L a) where
  expose (L _) s = s
</pre>
<p></p>
<p>Now we have a wrapper data type that acts as a dummy instance of class <code>Unlifted</code>! So (after about four hours of head scratching), we can make the following small changes to our code:</p>
<p><code></code></p>
<pre>mergeS :: Ord a =&gt; Stream a -&gt; Stream a -&gt; Stream a
mergeS (Stream nexta sa0) (Stream nextb sb0) = Stream next <strong>(L (sa0, sb0))</strong>
    where
      next <strong>(L (sa0, sb0))</strong> =
          case (nexta sa0, nextb sb0) of
            (Done, sb) -&gt;
                case sb of
                  Done        -&gt; Done
                  Skip sb'    -&gt; Skip    <strong>(L (sa0, sb'))</strong>
                  Yield b sb' -&gt; Yield b <strong>(L (sa0, sb'))</strong>
            (sa, Done) -&gt;
                case sa of
                  Done        -&gt; Done
                  Skip sa'    -&gt; Skip    <strong>(L (sa', sb0))</strong>
                  Yield a sa' -&gt; Yield a <strong>(L (sa', sb0))</strong>
            (sa, sb) -&gt;
                case sa of 
                  Done        -&gt; Done -- shouldn't happen
                  Skip sa'    -&gt; Skip    <strong>(L (sa', sb0))</strong>
                  Yield a sa' -&gt;
                      case sb of
                        Done                    -&gt; Done -- Shouldn't happen
                        Skip sb'                -&gt; Yield a <strong>(L (sa', sb'))</strong>
                        Yield b sb' | a &lt; b     -&gt; Yield a <strong>(L (sa', sb0))</strong>
                                    | otherwise -&gt; Yield b <strong>(L (sa0, sb'))</strong>
</pre>
<p></p>
<p>All we had to do was wrap our Stream pairs in the type constructor <code>L</code> to give our Stream pairs access to &ldquo;free&rdquo; instance deriving from the <code>Unlifted</code> class. Easy? Well, once you notice that unassuming <code>data L a = L a</code> in the documentation. But hey, it sure beats trying to do something like this in C!</p>


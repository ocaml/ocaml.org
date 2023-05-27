---
title: Pearl No.1 - The Min Missing Natural Number
description: This is the first pearl (min free natural) in the book
url: http://typeocaml.com/2015/02/02/functional-pearl-no-1-the-min-free-nature/
date: 2015-02-02T17:34:31-00:00
preview_image:
featured:
authors:
- typeocaml
---

<p><img src="http://typeocaml.com/content/images/2015/01/pearls2-1.jpg#hero" alt="pears"/></p>

<p><a href="http://www.cs.ox.ac.uk/richard.bird/">Prof. Richard Simpson Bird</a> is a Supernumerary Fellow of Computation at <a href="http://www.lincoln.ox.ac.uk/">Lincoln College, Oxford</a>, England, and former director of <a href="http://www.cs.ox.ac.uk/">the Oxford University Computing Laboratory</a>. His research interests include:</p>

<ul>
<li>The algebra of programming</li>
<li>The calculation of algorithms from their specification</li>
<li>Functional programming</li>
<li>Algorithm design</li>
</ul>

<p>In 2010, he wrote the book <a href="http://www.cambridge.org/gb/academic/subjects/computer-science/programming-languages-and-applied-logic/pearls-functional-algorithm-design">Pearls of Functional Algorithm Design</a>  </p>

<p><img src="http://typeocaml.com/content/images/2015/01/pearls_book.jpeg" alt="book"/></p>

<p>This book presents <strong>30 algorithm problems and their functional solutions</strong>. The reason that they are called as <em>pearls</em> is what I quote below:</p>

<blockquote>
  <p>Just as natural pearls grow from grains of sand that have irritated oysters, these programming pearls have grown from real problems that have irritated programmers. The programs are fun, and they teach important programming techniques and fundamental design principles. </p>
</blockquote>

<p>These pearls are all classic and togehter with the well presented functional approaches, they become very helpful for ones who really wish to sharpen their functional programming on algorithms. I have so far solved / fully understood 17 pearls and hmm...the rest are indeed difficult, at least for me. Nevertheless, I would like to share my journey of studying this book with you via a series of posts, each of which is a pearl in the book. All the posts will differ from the book in the following ways:</p>

<ol>
<li><strong>Only OCaml is used</strong> for the implementations (for the obvious reason: I am a fan of OCaml)  </li>
<li><strong>More general (functional) analysis techniques</strong> are adopted. The book heavily focuses on algebraic approach, namely, <em>design by calculation</em>, which honestly is too much for me. I mean I can understand the methodology, but cannot master it. So during my study, I did not replicate the algebraic thinking; instead, I tried to sniff around the functional sprit behind the curtain and consider the algebraic part as the source of hints.  </li>
<li><strong>Tail-recursive implementation</strong> will be provided if possible. The haskell implementations in the book do not consider much about tail-recursive because a) haskell is lazy; b) haskell's compiler is doing clever things to help recursion not blow. OCaml is different. It is not lazy and does not rely on the compiler to do optimisations on the potential <em>stackoverflow</em>. So as OCaml developers, we need to care about tail-recursive explicitly.</li>
</ol>

<p>Ok. Let's get started.</p>

<h1>The Min Missing Natural Number</h1>

<blockquote>
  <p>Given a unordered list of distinct natural numbers, find out the minimum natural number that is not in the list.</p>
  
  <p>For example, if the list is [8; 2; 3; 0; 12; 4; 1; 6], then 5 is the minimum natural number that is missing.</p>
  
  <p>O(n) solution is desired.</p>
</blockquote>

<p><img src="http://typeocaml.com/content/images/2015/02/problem_description-1.jpg" alt="eg"/></p>

<h1>Analysis of the problem description</h1>

<p>The description of an algorithm problem specifies the input, the output and the constraint. Yet, it is more than just telling us what to achieve. Most of the time, the literatures can provide us hints for possible solutions. Let's break down the description first:</p>

<ol>
<li>unordered list  </li>
<li>distinct  </li>
<li>natural numbers  </li>
<li>minimum and missing</li>
</ol>

<h3>unordered list</h3>

<p>The input list is not sorted. If this is specified explicitly, it implies that ordering is important here. In other words, if the list was sorted, then the problem would not be a problem any more or at least much easier to solve.</p>

<h3>distinct</h3>

<p>There are no duplicates inside.</p>

<h3>natural numbers</h3>

<p>All numbers are non-negative integers, i.e., 0, 1, 2, ... This puts a lower boundary on the possible numbers in the input list.</p>

<h3>minimum and missing</h3>

<p>There might be unlimited numbers not in the input list, but we just need to find the smallest one. When our goal is to locate something with certain characteristic, it would normally be a <em>selection problem</em>. Moreover, for problems related <em>min</em> or <em>max</em>, they normally can be solved by somehow bringing sorting; however, sorting will heavily involve moving all numbers around. As our target is only one number, sorting can be an overkill.</p>

<h1>An easy but not optimal solution</h1>

<p>From the analysis above, it is obvious that sorting can solve our problem quite easily. We can simply </p>

<ol>
<li>Sort the input list  </li>
<li>If the first number is not <code>0</code>, then the result is <code>0</code>  </li>
<li>Scan every consecutive pair (x, y)  </li>
<li>If <code>y - x &gt; 1</code> then the result is <code>x + 1</code>  </li>
<li>If point 4 never happens, then the result is <code>the last number plus 1</code>.</li>
</ol>

<p><img src="http://typeocaml.com/content/images/2015/02/easy_solution.jpg" alt="easy_solution"/></p>

<pre><code class="ocaml">let min_missing_trivial l =  
  let sl = List.sort compare l in
  let rec find = function
    | [] -&gt; None
    | x::[] -&gt; Some (x+1)
    | x::y::_ when y - x &gt; 1 -&gt; Some (x+1)
    | _::tl -&gt; find tl
  in
  (* adding -1 can cover point 2 and make find work for all *)
  find ((-1)::sl) 
</code></pre>

<p>Have we solved the problem? Let's have a look. The solution above can achieve the goal indeed. However, the time complexity of this solution is <code>O(nlogn)</code> since the sorting bit is dominating, which is worse than the required <code>O(n)</code>. </p>

<p>We have to try harder.</p>

<h1>Do we need complete order?</h1>

<p>So, if we do a sorting, we can obtain the answer but it is too slow. Let's have a look again at what we get after sorting.</p>

<p><img src="http://typeocaml.com/content/images/2015/02/completely_ordered.jpg" alt="completely sorted"/></p>

<p>If the list is sorted, then it provides us a chance where we check the consecutiveness of the numbers and the first gap is what we want. There are two questions though:</p>

<blockquote>
  <p>Q1. Shall we care about the consecutiveness after <code>6</code>?</p>
</blockquote>

<p>The answer is <em>no</em>. Since we are chasing for the <em>minimum</em>, i.e., the first missing one, the order of the numbers after the gap doesn't matter any more. </p>

<p>For example, even if <code>12</code> is before <code>8</code>, the result won't be affected.</p>

<p><img src="http://typeocaml.com/content/images/2015/02/after_gap.jpg" alt="after gap"/></p>

<blockquote>
  <p>Q2. Is the order of all the numbers before the gap important?</p>
</blockquote>

<p>Let's randomly mess up the order of <code>0</code>, <code>1</code>, <code>2</code>, and <code>3</code> a little:</p>

<p><img src="http://typeocaml.com/content/images/2015/02/before_gap-1.jpg" alt="before gap"/></p>

<p>It seems fine as the messed order of those 4 numbers does not affect the position of <code>4</code> and <code>6</code>. But hang on a minute, something is not right there.</p>

<p>We replied on the consecutiveness of <code>0</code>, <code>1</code>, <code>2</code>, and <code>3</code> to locate the first gap, and the consecutiveness can be checked via the numbers being sorted. Hence, if the order before the gap was not maintained, how could we scan for consecutiveness and find the gap in the first place? It sounds like a chicken and egg thing.</p>

<p>So can we check for the consecutiveness of the numbers without sorting them?</p>

<h1>Hints hidden in &quot;distinct natural numbers&quot;</h1>

<p>Yes, we can, and now it is the time to ask for help from <em>distinct natural numbers</em>. </p>

<p>As we described before, <em>natural numbers</em> are integers euqal to or larger than <code>0</code>. This lower bound <code>0</code> plus the constraint of <em>no duplicates</em> gives us the opportunity to check for consecutiveness without requiring all numbers being sorted. Let's first see a perfect consecutive sequnce (starting from 0) of natural numbers:</p>

<p><img src="http://typeocaml.com/content/images/2015/02/perfect_consecutive_1.jpg" alt="perfect1"/></p>

<p>They are sorted of course. Is there any other characteristic? Or say, for a number inside the sequence, how many other numbers are less than it (on its left side)?</p>

<p><img src="http://typeocaml.com/content/images/2015/02/perfect_consecutive_count.jpg" alt="count"/></p>

<p>For number <code>4</code>, there will exact <code>4</code> natural numbers less than itself. The same thing will apply on any numbers as long as all those belong to a perfect consecutive sequence starting from <code>0</code>. </p>

<p>This is also a two-way mapping, i.e., if we are told that there are <code>4</code> numbers less than <code>4</code> and all of them are before <code>4</code>, we can be sure that all five numbers can form a consecutive sequence. Most importantly, now whether all numbers are in order or not does not matter any more.</p>

<p><img src="http://typeocaml.com/content/images/2015/02/perfect_consecutive_not_ordered.jpg" alt="not ordered again"/></p>

<blockquote>
  <p>What does a perfect consecutiveness imply? </p>
</blockquote>

<p>It implies that among the sequence, no one is missing and if anyone is missing, it must be on the right side of the max of the sequence.</p>

<p><img src="http://typeocaml.com/content/images/2015/02/missing_in_right.jpg" alt="in the right"/></p>

<blockquote>
  <p>What if for a number, the number of smaller ones does not match its own value?</p>
</blockquote>

<p>It means the sequence up to the number won't be consecutive, which implies that there must be at least one a natural number missing, right?</p>

<p><img src="http://typeocaml.com/content/images/2015/02/in_the_left.jpg" alt="in the left"/></p>

<p>Now we have the weapon we want. In order to check consecutiveness, or say, to know the region where the min missing natural number is, we don't need complete sorting any more. Instead, we just to</p>

<ol>
<li>pick a number <code>x</code> from the sequence  </li>
<li>put all other smaller numbers to its left and count how many are those in <code>num_less</code>  </li>
<li>put all larger ones to its right  </li>
<li>If <code>num_less = x</code>, then it means <code>x</code>'s left branch is perfect and the missing one must be in its right branch. We repeat the whole process in the sequence of right hand side.  </li>
<li>Otherwise, we repeat in the left branch. Note that due to <em>distinct</em>, it is impossible <code>num_less &gt; x</code>. </li>
</ol>

<p>In this way, we cannot identify the min missing one in one go, but we can narrow down the range where it might be through each iteration and eventually we will find it when no range can be narrowed any more. </p>

<p>Sounds like a good plan? let's try to implement it.</p>

<h1>Partition and Implementation</h1>

<p>Do you feel familiar with the process we presented above? It is actually a classic <code>partition</code> step which is the key part of <em>quicksort</em> <a href="http://typeocaml.com/2015/01/02/immutable/">we talked about</a>.</p>

<p>Of course, in this problem, it won't be a standard <code>partition</code> as we need to record <code>num_less</code>. The code should be easy enough to write:</p>

<pre><code class="ocaml">let partition x l =  
  let f (num_less, left, right) y =
    if y &lt; x then num_less+1, y::left, right
    else num_less, left, y::right
  in
  List.fold_left f (0, [], []) l
</code></pre>

<p>Also our solver function should be straightword too:</p>

<pre><code class="ocaml">let min_missing l =  
  let rec find lo = function
    | [] -&gt; lo
    | x::tl -&gt;
      let num_less, left, right = partition x tl in
      if num_less + lo = x then find (x+1) right
      else find lo left
  in
  find 0 l

(* Why do we introduce `lo`?
   I will leave this question to the readers *)
</code></pre>

<h2>Time complexity of our new solution</h2>

<p>For the very 1st iteration, we need to scan all numbers, so costs <code>O(n)</code> for this step. But we can skip out ideally half of the numbers.</p>

<p>So for the 2nd iteration, it costs <code>O(n*(1/2))</code>. Again, further half will be ruled out.</p>

<p>...</p>

<p>So the total cost would be <code>O(n * (1 + 1/2 + 1/4 + 1/8 + ...)) = O(n * 2) = O(n)</code>.</p>

<p>We made it!</p>

<h1>Summary</h1>

<p>This is the first pearl and it is not that difficult, especially if you knew <em>quickselect</em> algorithm before. </p>

<p>Actually, many of the pearls involve certain fundamental algorithms and what one need to do is to peel the layers out one by one and eventually solve it via the essentials. If you are interested in pearls, please pay attentions to the tags attached with each pearl as they show what each pearl is really about.</p>

---
title: Pearl No.3 - Saddleback Search
description: This is the 3rd pearl (the saddleback search problem) in the book
url: http://typeocaml.com/2015/03/31/pearl-no-3-saddleback-search/
date: 2015-03-31T17:30:00-00:00
preview_image:
featured:
authors:
- typeocaml
---

<p><img src="http://typeocaml.com/content/images/2015/03/pearl_3_easter_1-2.jpg#hero" alt=""/></p>

<h1>Happy Easter</h1>

<p>Our easter egg happens to be Pearl 3.</p>

<blockquote>
  <p>A function $ f $ can have the following properties:</p>
  
  <ol>
  <li>$ f $ takes two arguments: $ x $ and $ y $</li>
  <li>Both $ x $ and $ y $ are natural numbers, i.e., non-negative integers  </li>
  <li>$ f $ also returns natural numbers  </li>
  <li>$ f $ is strictly increasing in each argument. This means if $ x $ increases or descreases, the according result of $ f $  will also increase or descrease. The same applies on $ y $.</li>
  </ol>
  
  <p>Now we are given such a function $ f $ and a natural number <code>z</code>, and we want to find out all pairs of $ x $ and $ y $ that makes $ f (x, y) = z $.</p>
  
  <p>In OCaml world, this problem requires us to write a function <code>let find_all f z = ...</code> which returns a list of <code>(x, y)</code> that satisfy <code>f x y = z</code>, assuming the supplied <code>f</code> meets the requirements above.</p>
</blockquote>

<h1>Basic Math Analysis</h1>

<p>This problem seems not that difficult. A trivial brute-force solution comes out immediately. We can simply try every possible value for $ x $ and $ y $ on $ f $, and accumulate all $ (x, y) $ satisfying $ f (x, y) = z $ to the list. There is just one silly question:</p>

<blockquote>
  <p>Can we try all infinite $ x $ and $ y $?</p>
</blockquote>

<p>Of course we cannot. We should try to set a range for both $ x $ and $ y $, otherwise, our solution would run forever. Then how? From some simple math analysis, we can conclude something about $ f $, even if we won't know what $ f $ will be exactly.</p>

<p>Here are what we know so far:</p>

<ol>
<li>$ x &gt;= 0 $  </li>
<li>$ y &gt;= 0 $  </li>
<li>$ z &gt;= 0 $  </li>
<li>$ x, y, z $ are all integers, which means the unit of increment or decrement is $ 1 $  </li>
<li>$ f $ goes up or down whenever $ x $ or $ y $ goes up or down.  </li>
<li>$ f (x, y) = z $</li>
</ol>

<p>From first 4 points, if we pick a value $ X $ for $ x $, we know we can descrease $ x $ from $ X $ at most $ X $ times. It is also true for $ y $ and $ z $.</p>

<p><img src="http://typeocaml.com/content/images/2015/03/x_descrease.jpg" alt="decrease_x"/></p>

<p>Then let's assume $ X $ and $ Y $ makes $ f $ equal to $ Z $ ($ X, Y, Z $ are assumed to be values), i.e., </p>

<p>$$ f (X, Y) = Z $$</p>

<p>Let's now fix $ Y $ and try descreasing $ x $ to $ X-1 $. From point 5, we know </p>

<p>$$ f (X-1, Y) = Z_{X-1} &lt; f (X, Y) = Z $$</p>

<p>We can continue to decrease $ x $ until $ 0 $:</p>

<p>$$ f (0, Y) = Z_0 &lt; f (1, Y) = Z_1 &lt; ... &lt; f (X-2, Y) = Z_{X-2} &lt; f (X-1, Y) = Z_{X-1} &lt; f (X, Y) = Z $$</p>

<p>Together with point 3 ($ z &gt;= 0 $), we can simplify the above inequalities like:</p>

<p>$$ 0 &lt;= Z_0 &lt; Z_1 &lt; ... &lt; Z_{X-2} &lt; Z_{X-1} &lt; Z $$</p>

<p>We can see that through this descreasing of $ x $, the number of results ($ Z_0, Z_1, ..., Z_{X-1} $) is $ X $. How many possible values between $ 0 $ (inclusive) and $ Z $ (exclusive)?  Of course the answer is $ Z $, right? So we can get $$ 0 &lt;= X &lt;= Z $$ and similarly, $$ 0 &lt;= Y &lt;= Z $$.</p>

<p>Thus, for any given $ x, y, z $, their relationship is</p>

<p>$$ 0 &lt;= x, y &lt;= Z $$</p>

<p>We obtained the range and now our brute-force solution will work.</p>

<h1>Brute-force solution</h1>

<p>It is simple enough.</p>

<pre><code class="ocaml">let find_all_bruteforce f z =  
  let rec aux acc x y =
    if y &gt; z then aux acc (x+1) 0
    else if x &gt; z then acc
    else 
      let r = f x y in
      if r = z then aux ((x, y)::acc) x (y+1)
      else aux acc x (y+1)
  in
  aux [] 0 0
</code></pre>

<p>The time complexity is $ O(log(z^2)) $. To be exact, we need $ (z + 1)^2 $ calculation of $ f $. It will be a bit slow and we should seek for a better solution</p>

<h1>A Matrix</h1>

<p>The fact that $ f $ is an increasing function on $ x $ and $ y $ has been used to retrieve the range of $ x $ and $ y $. We actually can extract more from it.</p>

<p>If we fix the somewhat value of $ y $, then increase $ x $ from $ 0 $, then the result of $ f $ will increase and naturally be sorted. If we fix $ x $, and increase $ y $ from $ 0 $, the same will happen that $ f $ will increase and be sorted. </p>

<p>We also know $ 0 &lt;= x, y &lt;= Z $; thus, we can create a matrix that has $ z + 1 $ rows and $ z + 1 $ columns. And each cell will be the result of $ f (x, y) $, where $ x $ is the row number and $ y $ is the column number.</p>

<p><img src="http://typeocaml.com/content/images/2015/03/matrix-1.jpg" alt="matrix"/></p>

<p>The best thing from this matrix is that <strong>all rows are sorted and so are all columns</strong>. The reason is that $ f $ is a strictly increasing function on $ x $ and $ y $.</p>

<p><img src="http://typeocaml.com/content/images/2015/03/sorted_matrix.jpg" alt="sorted_matrix"/></p>

<p>This matrix converts the original problem to the one that <strong>now we have a board of unrevealed cards and we need to seek for an efficient strategy to find all cards that we want</strong>. </p>

<p>The trivial solution in the previous section has a simplest strategy: simply reveal all cards one by one and collect all that are satisfying.</p>

<p><img src="http://typeocaml.com/content/images/2015/03/trivial.jpg" alt="trivial"/></p>

<h1>Zig-zag</h1>

<p>Let's take an example simple function $ f (x, y) = x * y $ and assume $ z = 6 $. </p>

<p>If we employ the trivial solution, then of course we will find all cards we want.</p>

<p><img src="http://typeocaml.com/content/images/2015/03/zig_zag_1.jpg" alt="zig_zag_1"/></p>

<p>However, we can see that we need to reveal $ 36 $ cards for $ 4 $ targets. <br/>
<img src="http://typeocaml.com/content/images/2015/03/zig_zag_2.jpg" alt="zig_zag_2"/></p>

<p>What a waste! But how can we improve it?</p>

<blockquote>
  <p>Maybe just start from somewhere, reveal one card, depend on its value and then decide which next card to reveal?</p>
</blockquote>

<p>Let's just try starting from the most natural place - the top-left corn, where $ x = 0, y = 0 $.</p>

<p><img src="http://typeocaml.com/content/images/2015/03/zig_zag_3-2.jpg" alt="zig_zag_3"/></p>

<ol>
<li>We get $ R $.  </li>
<li>If $ R &gt; z $, our problem is solved. This is because the 3 possible next cards must be bigger than $ R $ as the bigger $ x $ or $ y $ are the larger the results are. So we do not need to move any more.  </li>
<li>What if $ R &lt; z $? then we have to try to reveal all 3 cards, which makes not much sense since we may still anyway reveal all cards.</li>
</ol>

<p>We need a better way.</p>

<h2>Target sum of two sorted lists</h2>

<p>Before we continue to think, let's try another simpler problem first.</p>

<blockquote>
  <p>Given a value <code>k</code> and two sorted lists of integers (all being distinct), find all pairs of integers <code>(i, j)</code> where <code>i + j == k</code>.</p>
  
  <p>For example, <code>[1; 2; 8; 12; 20]</code> and <code>[3; 6; 9; 14; 19]</code> and <code>k = 21</code> is given, we should return <code>[(2, 19); (12, 9)]</code>.</p>
</blockquote>

<p>Of course, we can just scan all possible pairs to see. But it is not efficient and we waste the execellent hint: <em>sorted</em>. </p>

<p>Since sorted list is the fundamental condition for <em>merge</em>, how about we try to do something similar? Let's put two sorted lists in parallel and for the first two elements $ 1 $ and $ 3 $, we know $ 1 + 3 = 4 &lt; 21 $. </p>

<p><img src="http://typeocaml.com/content/images/2015/03/sorted_list_1-3.jpg" alt="1"/></p>

<p>It is too small at this moment, what should we do? We know we should move rightwards to increase, but do we move along <code>list 1</code> or <code>list 2</code> or both? </p>

<p><img src="http://typeocaml.com/content/images/2015/03/sorted_list_2-2.jpg" alt="2"/></p>

<p>We don't know actually, because each possible movement may give us chances to find good pairs. If we just take all possible movements, then it makes no sense as in the end as it will just try every possible pair. Hence, we just need to find a way to restrict our choices of movements.</p>

<p>How about we put one list in its natural order and put the other in its reversed order?</p>

<p><img src="http://typeocaml.com/content/images/2015/03/sorted_list_3-3.jpg" alt="3"/></p>

<p>Now, $ 1 + 19 = 20 &lt; 21 $. It is again too small. What shall we do? Can we move along <code>list 2</code>? We cannot, because the next element there is definitely smaller and if we move along, we will get even smaller sum. So moving along <code>list 1</code> is our only option.</p>

<p>If <code>i + j = k</code>, then good, we collect <code>(i, j)</code>. How about the next move? We cannot just move along any single list because the future sum will forever be either bigger than <code>k</code>  or smaller. Thus, we move along both because only through increasing <code>i</code> and decreasing <code>j</code> may give us changes to find the target sum again.</p>

<p>What if <code>i + j &gt; k</code>? It is easy to see that the only option for us is the next element in <code>list 2</code>.</p>

<p><img src="http://typeocaml.com/content/images/2015/03/sorted_list_4-1.jpg" alt="4"/></p>

<h2>One ascending and the other descending, always</h2>

<p>Let's come back to our <em>sorted</em> matrix problem. We do not have simple two sorted lists any more, but it is not difficult to see that we should <strong>start from bottom-left corner</strong> (rows are descending and columns are ascending). And depending on what we get from $ R = f (x, y) $, we just change direction (either up, right-up or right), and towards the top-right corner:</p>

<ol>
<li>We move <em>right</em> along $ y $ until we reach the <em>ceiling</em> (the smallest number that is bigger than $ z $), and then change to <em>up</em>  </li>
<li>We move <em>up</em> along $ x $ until we reach the <em>floor</em> (the bigger number that is smaller than $ z $), and then change to <em>right</em>  </li>
<li>Whenever we reach $ R = f (x, y) = z $, we change to <em>right-up</em>.</li>
</ol>

<p>We can use an example to explain why we want the <em>ceiling</em> (similarly explaining why the <em>floor</em>).</p>

<p><img src="http://typeocaml.com/content/images/2015/03/zigzag_binarysearch_y.jpg" alt="binary_search_1"/></p>

<p>When we reach the <em>ceiling</em>, we know all cells on its left can be dicarded because those are definitely smaller than $ z $.</p>

<p><img src="http://typeocaml.com/content/images/2015/03/zig_zag_4.jpg" alt="start_point"/></p>

<p>In this way, the card revealing process for $ f (x, y) = x * y $ looks like this:</p>

<p><img src="http://typeocaml.com/content/images/2015/03/matrix_example.jpg" alt="example"/></p>

<h2>Code</h2>

<pre><code class="ocaml">let find_all_zigzag f z =  
  let rec aux acc x y =
    if x &lt; 0 || y &gt; z then acc
    else
      let r = f x y in
      if r &lt; z then aux acc x (y+1) 
      else if r&gt; z then aux acc (x-1) y
      else aux (r::acc) (x-1) (y+1)
  in
  aux [] z 0
</code></pre>

<p>The time complexity is $ O(Z) $ and in the worst case, we need to calculate $ 2 * Z + 1 $ times of $ f $.</p>

<p>This solution is a linear one and there is still room for improvement.</p>

<h2>A same problem with slightly different appearance</h2>

<p>There is a quite popular interview question which is very similar to the pearl 3.</p>

<blockquote>
  <p>We have a matrix of numbers. All rows are sorted and so are all columns. Find the coordinates of a given number.</p>
</blockquote>

<p>Although it seems all numbers are already computed and put in the matrix, both this problem and pearl 3 are actually identical.</p>

<h1>Zig-zag + Binary Search</h1>

<p>Zig-zag solution is actually scan along $ x $ axis and $ y $ axis by turns. The scan on each turn is linear. But wait, each row and column are sorted, right? Does it ring a bell?</p>

<p>When a sequence of elements are sorted, and if we have a target to find, then we of course can try <em>binary search</em>.</p>

<p>Simply say, in order to improve the <em>zig-zag</em> solution, we just replace the <em>linear scan</em> part with <em>binary search</em>. </p>

<h2>Targets of binary search</h2>

<p>For each round of binary search, we cannot just search for the given value of $ z $ only. Instead, </p>

<ol>
<li>Our target is the <strong>ceiling</strong> when we binary search <strong>horizontally</strong>, i.e., along $ y $, from left to right.  </li>
<li>Our target is the <strong>floor</strong> when we binary search <strong>vertically</strong>, i.e., along $ x $, from down to up.  </li>
<li>During our search, if we find a target card, we can simply stop.</li>
</ol>

<h2>Eventually stops at ceiling or floor or equal</h2>

<p>The next question is <em>when a round of binary search stops?</em></p>

<p>When we reach an card equal to $ z $, of course we can stop immediately.</p>

<p>If we never reach an ideal card, then anyway the search will stop because there will eventually be no room on either left side or right side to continue. And that stop point will definitely be the <em>ceiling</em> or the <em>floor</em> of $ z $. </p>

<p>Again, because we need the <em>ceiling</em> for <em>horizon</em> and <em>floor</em> for <em>vertical</em>, we need to adjust it after we finish the binary search.</p>

<h2>Code</h2>

<pre><code class="ocaml">type direction = H | V

let rec binary_search z g p q =  
  if p + 1 &gt;= q then p
  else
    let m = (p + q) / 2 in
    let r = g m in
    if r = z then m
    else if r &gt; z then binary_search z g p (m-1)
    else binary_search z g (m+1) q

(* adjust ceiling or floor *)
let next_xy z f x y direction =  
  let r = f x y in
  match direction with
    | _ when r = z -&gt; x, y
    | H when r &gt; z -&gt; x-1, y
    | H -&gt; x-1, y+1
    | V when r &lt; z -&gt; x, y+1
    | V -&gt; x-1, y+1

let find_all_zigzag_bs f z =  
  let rec aux acc (x, y) =
    if x &lt; 0 || y &gt; z then acc
    else 
      let r = f x y in
      if r = z then aux (f x y::acc) (x-1, y+1)
      else if r &lt; z then 
        let k = binary_search z (fun m -&gt; f x m) y z in
        aux acc (next_xy z f x k H)
      else
        let k = binary_search z (fun m -&gt; f m y) 0 x in
        aux acc (next_xy z f k y V)
  in
  aux [] (z, 0)
</code></pre>

<h1>Why called Saddleback</h1>

<p>The reason why this pearl is called <em>Saddleback Search</em> is (quoted from the <a href="http://www.amazon.co.uk/Pearls-Functional-Algorithm-Design-Richard/dp/0521513383/ref=sr_1_1?ie=UTF8&amp;qid=1427413337&amp;sr=8-1&amp;keywords=pearls%20functional">book</a>), </p>

<blockquote>
  <p>(It is) an important search strategy, dubbed saddleback search by David Gries... </p>
  
  <p>I imagine Gries called it that because the shape of the three-dimensional plot of f , with the smallest element at the bottom left, the largest at the top right and two wings, is a bit like a saddle.</p>
</blockquote>

<p>For example, if we plot $ f (x, y) = x * y $ , we can see <a href="http://www.livephysics.com/tools/mathematical-tools/online-3-d-function-grapher/?xmin=-1&amp;xmax=1&amp;ymin=-1&amp;ymax=1&amp;zmin=Auto&amp;zmax=Auto&amp;f=x*y">this</a></p>

<p><img src="http://typeocaml.com/content/images/2015/03/plot.jpg" alt="plot"/></p>

<p>Does it look like a saddle?</p>

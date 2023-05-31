---
title: Pearl No.2 - The Max Number of Surpassers
description: This is the 2nd pearl (a surpassing problem) in the book
url: http://typeocaml.com/2015/02/20/pearl-no-2-the-max-number-of-surpassers/
date: 2015-02-21T01:24:38-00:00
preview_image:
featured:
authors:
- typeocaml
---

<p><img src="http://typeocaml.com/content/images/2015/02/pear-2.jpg#hero" alt="pear-2"/></p>

<blockquote>
  <p>In a list of unsorted numbers (not necessarily distinct), such as</p>
</blockquote>

<p><img src="http://typeocaml.com/content/images/2015/02/problem_description_1-1.jpg" alt="problem1"/></p>

<blockquote>
  <p>The surpassers of an element are all elements whose indices are bigger and values are larger. For example, the element <code>1</code>'s surpassers are <code>9</code>, <code>5</code>, <code>5</code>, and <code>6</code>, so its number of surpassers is 4. </p>
</blockquote>

<p><img src="http://typeocaml.com/content/images/2015/02/problem_description_2.jpg" alt="problem2"/></p>

<blockquote>
  <p>And also we can see that <code>9</code> doesn't have any surpassers so its number of surpassers is 0. </p>
  
  <p>So the problem of this pearl is:</p>
  
  <p><strong>Given an unsorted list of numbers, find the max number of surpassers, O(nlogn) is required.</strong></p>
  
  <p>In the answer for the above example is 5, for the element <code>-10</code>. </p>
</blockquote>

<h1>An easy but not optimal solution</h1>

<p>As usual, let's put a trivial solution on the table first (<em>[1]</em>). It is straightforward:</p>

<ol>
<li>For every element, we scan all elements behind it and maintain a <code>ns</code> as its number of surpassers.  </li>
<li>If one element is larger, then we increase the <code>ns</code>.  </li>
<li>After we finish on all elements, the <code>max</code> of all the <code>ns</code>es is what we are looking for.</li>
</ol>

<p>The diagram below demonstrates the process on <code>1</code>. <br/>
<img src="http://typeocaml.com/content/images/2015/02/trivial_solution-2.jpg" alt="trivial solution"/></p>

<pre><code class="ocaml">let num_surpasser p l = List.fold_left (fun c x -&gt; if x &gt; p then c+1 else c) 0 l

let max_num_surpasser l =  
  let rec aux ms l =
    match ms, l with
    | _, [] -&gt; ms
    | None, p::tl -&gt; aux (Some (p, num_surpasser p tl)) tl
    | Some (_, c), p::tl -&gt; 
      let ns = num_surpasser p tl in
      if ns &gt; c then aux (Some (p, ns)) tl
      else aux ms tl
  in
  aux None l

(* note think the answer as an `option` will make the code seem more complicated, but it is not a bad practice as for empty list we won't have max number of surpassers *)
</code></pre>

<p>The solution should be easy enough to obtain but its time complexity is <code>O(n^2)</code> which is worse than the required <code>O(nlogn)</code>. </p>

<h1>Introducing Divide and Conquer</h1>

<p><img src="http://typeocaml.com/content/images/2015/02/conquer-1.jpg" alt="hero"/></p>

<p>The algorithm design technique <em>divide and conquer</em> was mentioned in <a href="http://typeocaml.com/2014/12/04/recursion-reloaded/">Recursion Reloaded</a>. I believe it is a good time to properly introduce it now as it provides a elegant approach towards a better solution for pearl 2.</p>

<h2>What is it, literally</h2>

<p>Suppose we want to replace the dragon lady and become the king of the land below (<em>[2]</em>).</p>

<p><img src="http://typeocaml.com/content/images/2015/02/game_of_thrones_color-1.jpg" alt="game_of_thrones"/></p>

<p>We are very lucky that we have got a strong army and now the only question is how to overcome the realm.</p>

<p>One &quot;good&quot; plan is <em>no plan</em>. We believe in our troops so much that we can just let all of them enter the land and pwn everywhere.</p>

<p><img src="http://typeocaml.com/content/images/2015/02/game_of_thrones_strategy_1.jpg" alt="pwn"/></p>

<p>Maybe our army is very good in terms of both <em>quality</em> and <em>quantity</em> and eventually this plan will lead us to win. However, is it really a good plan? Some soldiers may march to places that have already been overcome; Some soldiers may leave too soon for more wins after one winning and have to come back due to local rebel... the whole process won't be efficient and it cost too much gold on food for men and horses.</p>

<p>Fortunately, we have a better plan.</p>

<p><img src="http://typeocaml.com/content/images/2015/02/game_of_thrones_dragon-2.jpg" alt="better"/></p>

<p>We divide the land into smaller regions and further smaller ones inside until unnecessary. And for each small region, we put ideal amount of soldiers there for battles. After soldiers finish their assigned region, they don't need to move and just make sure the region stay with us. This is more oganised and more efficient in terms of both gold and time. After all, if we conquer all the tiny regions, who would say we were not the king?</p>

<h2>What is it in algorithm design, with accumulation</h2>

<p><em>divide and conquer</em> in algorithm design is not a universal solution provider, but a problem attacking strategy or paradigm. Moreover, although this classic term has been lasting for quite a long time, personally I would like to add one more action - <strong>accumulate</strong> - to make it appear more complete. Let's check the 3 actions one by one to see how we can apply the techque.</p>

<h3>Divide</h3>

<p>Conceptually this action is simple and we know we need to divide a big problem into smaller ones. But <em>how to</em> is non-trivial and really context-sensitive. Generally we need to ask ourselves 2 questions first:</p>

<blockquote>
  <p>What are the sizes of the smaller sub-problems?</p>
</blockquote>

<p>Normally we intend to halve the problem because it can lead us to have a <code>O(logn)</code> in our final time complexity. </p>

<p>But it is not a must. For example <a href="http://www.sorting-algorithms.com/quick-sort-3-way">3-way quicksort</a> divides the problem set into 3 smallers ones. 3-way partition can let quicksort have O( $ \log_3{n} $ ). However, do not forget the number of comparison also increases as we need to check equality during partition.</p>

<p>Moreover, sometimes we may have to just split the problem into a sub-problem with size 1 and another sub-problem with the rest, like what we did for the <code>sum</code> function. This kind of <em>divide</em> won't give us any performance boost and it turns out to be a normal recursion design. </p>

<blockquote>
  <p>Do we directly split the problem, or we somehow reshape the problem and then do the splitting?</p>
</blockquote>

<p>In <em>mergesort</em>, we simply split the problem into 2; while in <em>quicksort</em>, we use <em>partition</em> to rearrange the list and then obtain the 2 sub-problems. </p>

<p>The point of this question is to bear in mind that we do not have shortcuts. We can have a very simple splitting, but later on we need to face probably more complicated <em>accumulate</em>. Like <em>mergesort</em> relies on <em>merge</em>. Or, we can do our important work during <em>divide</em> phase and have a straight <em>accumulate</em> (<em>quicksort</em> just needs to concatenate the solutions of the two sub-problems with the <em>pivot</em> in the middle).</p>

<h3>Conquer</h3>

<p>This action implies two things:</p>

<ol>
<li>Recursion. We divided the problem, then we need to conquer. How to conquer? We need to apply <em>divide and conquer and accumulate</em> again until we are not able to divide any more.  </li>
<li>Edge cases. This means if we cannot divide further, then it is time to really give a solution. For example, let's say our target is a list. If we reach an empty list or an one-element list, then what shall we do? Normally, if this happens, we do not need to <em>accumulate</em> and just return the answer based on the edge cases.</li>
</ol>

<p>I believe the <em>conquer</em> part in the original <em>divide and conquer</em> term also implies the <em>accumulate</em>. I seperate <em>accumulate</em> as explained next.</p>

<h3>Accumulate</h3>

<p>After we conquer every little area of the land, we should now somehow combine all our accomplishments and really build a kingdom out of them. This is the step of <em>accumulate</em>.</p>

<p>A key way to figure out <em>how to accumulate</em> is to <strong>start from small</strong>. In <em>mergesort</em>, if each of the 2 sub-problems just has one element, then the according answer is a list having that element and we have finished the <em>conquer</em> step. Now we have two lists each of which has one element, how can we accumulate them to have a single sorted list? Simple, smaller element goes first into our resulting list. What if we have two sorted list each of which has two elements? The same, smaller element goes first again.</p>

<p>If we decide to divide the problem in a fairly simple way, then <em>accumulate</em> is normally non-trivial and also dominates the time complexity. Figuring out a cost-efficient approach of <em>accumulate</em> is very important.</p>

<h3>Summary</h3>

<p>Again, <em>divide and conquer and accumulate</em> is just a framework for solving an algorithm problem. All the concrete solutions are problem context based and can spread into all 3 steps. </p>

<p>In addition, a fundamental hint to using this techqniue is that if we are given a problem, and we know the future solution is not anyhow related to the problem size, then we should try <em>divide and conquer and accumulate</em></p>

<h1>Solve pearl 2</h1>

<p>Although pearl 2 asks us to get the max number of surpassers, we can </p>

<ol>
<li>Get the number of surpassers for every element (we anyway need to)  </li>
<li>Then do a linear scan for the max one. </li>
</ol>

<p>The second step is <code>O(n)</code>. If we can achieve the first step in <code>O(nlogn)</code>, the overall time complexity stays as <code>O(nlogn)</code>. </p>

<p>So our current goal is to use <em>divide and conquer and accumulate</em> to get all numbers of surpassers.</p>

<h1>Divide the problem of pearl 2</h1>

<p><img src="http://typeocaml.com/content/images/2015/02/problem_description_1-1.jpg" alt="problem1"/></p>

<p>We have such as list and we want to get a new list that have the same elements and each element is associated with the number of its surpassers. Now we want to divide the original list (problem set).</p>

<p>Can we directly halve the list?</p>

<p><img src="http://typeocaml.com/content/images/2015/02/divide_1-3.jpg" alt="divide_1"/></p>

<p>As pearl 2 stated, an element only cares about all elements that are behind it. So if we split the list in the middle, we know the numbers of surpassers for all elements in <code>sub-problem 2</code> do not need any special operations and the answers can directly be part of the future resulting list. </p>

<p>For the elements inside <code>sub-problem 1</code>, the answers are not fully accomplished yet as they will be affected by the elemnts in <code>sub-problem 2</code>. But hey, how we obtain full answers for <code>sub-problem 1</code> with the help of the solutions of <code>sub-problem 2</code> should be the job of <em>accumulate</em>, right? For now, I believe halving the problem is a good choice for <em>divide</em> as at least we already solve half of the problem directly.</p>

<h1>Conquer</h1>

<p>We of course will use recursion. For sub-problems, we further halve them into smaller sub-problems until we are not able to, which means we reach the edge cases.</p>

<p>There are possibly two edge cases we need to conquer:</p>

<ol>
<li>Empty list  </li>
<li>A list with only one element.</li>
</ol>

<p><img src="http://typeocaml.com/content/images/2015/02/conquer-2.jpg" alt="conquer"/></p>

<p>For empty list, we just need to return an empty list as there is no element for us to count the number of surpassers. For an one-element list, we also return an one-element resulting list where the only element has <code>0</code> surpassers.</p>

<h1>Accumulate</h1>

<p>Now we finished dividing and conquering like below and it is time to accumulate (take <code>sub-problem 1</code> only for illustration).</p>

<p><img src="http://typeocaml.com/content/images/2015/02/accumulate_1.jpg" alt="accumulate 1"/></p>

<p>It is easy to combine solutions of <code>sp 111</code> and <code>sp 112</code>: just compare <code>8</code> from <code>sp 111</code> with <code>1</code> from <code>sp112</code>, update <code>8</code>'s number of surpassers if necessary and we can leave <code>sp 112</code> alone as we talked about during <em>divide</em>. The same way can be applied on <code>sp 121</code> and <code>sp 122</code>. Then we get:</p>

<p><img src="http://typeocaml.com/content/images/2015/02/accumulate_2.jpg" alt="accumulate 2"/></p>

<p>Now both <code>sp 11</code> and <code>sp 12</code> have more than one element. In order to get the solution for <code>sp 1</code>, <code>sp 12</code> can stay put. How about <code>sp 11</code>? An obvious approach is just let every element in <code>sp 11</code> to compare every element in <code>sp 12</code>, and update their numbers of surpassers accordingly. This can be a candidate for <em>accumulate</em> action, however, it is <code>O(n^2)</code>. We need to accumulate better.</p>

<p>We said in the very beginning of this post during our trivial solution that the original order of the list matters. However, is it still sensitive after we get the solution (for a sub-problem)? </p>

<p><img src="http://typeocaml.com/content/images/2015/02/accumulate_3-1.jpg" alt="accumulate 3"/></p>

<p>As we can see once the answer of <code>sp 11</code> is obtained, the order between <code>8</code> and <code>1</code> doesn't matter as they don't rely on each for their number of surpassers any more.</p>

<p>If we can obtain the solution in a sorted manner, it will help us a lot. For example, assume the resulting lists for <code>sp 11</code> and <code>sp 12</code> are sorted like this:</p>

<p><img src="http://typeocaml.com/content/images/2015/02/accumulate_4.jpg" alt="accumulate 4"/></p>

<p>Then we can avoid comparing every pair of elements by using <em>merge</em> like this:</p>

<p><img src="http://typeocaml.com/content/images/2015/02/accumulate_5-1.jpg" alt="accumulate 5"/></p>

<p>We can see that <code>8</code> in the left hand side list doesn't have to compare to <code>-10</code> any more. However, this example has not shown the full picture yet. <strong>If keep tracking the length of resulting list on the right hand side, we can save more comparisons</strong>. Let's assume both <code>sp 1</code> and <code>sp 2</code> have been solved as sorted list with lengths attached.</p>

<p><img src="http://typeocaml.com/content/images/2015/02/accumulate_6.jpg" alt="accumulate 6"/></p>

<p>We begin our <em>merge</em>.</p>

<p><img src="http://typeocaml.com/content/images/2015/02/accumulate_7-2.jpg" alt="accumulate 7"/></p>

<p>Have you noticed the fascinating part? Because <code>-10 &lt; -2</code>, without further going down along the resulting list on the right hand side, we can directly update the number of surpassers of <code>-10</code> and get it out. Why? Because <code>-2</code> is the smallest element on the right, and if it is bigger than <code>-10</code>, then the rest of the elements on the right must all be bigger than <code>-10</code>, right? Through only one comparison (instead of 4), we get the number of surpassers. </p>

<p>Thus, <strong>as long as the solutions of all sub-problems are sorted list with the length associated, we can accumulate like this</strong>:</p>

<ol>
<li>Compare the heads <code>hd1</code> and <code>hd2</code>, from two sorted resulting lists <code>l1</code> and <code>l2</code>, respectively  </li>
<li>If <code>hd1</code> &gt;= <code>hd2</code>, then <code>hd2</code> gets out; go to 1 with updated length for <code>l2</code>  </li>
<li>if <code>hd1</code> &lt; <code>hd2</code>, then <code>hd1</code> gets out, and its <code>ns</code> gets updated by adding the length of <code>l2</code> to the existing value; go to 1 with updated length for <code>l1</code></li>
</ol>

<p>The full process of accumulating <code>sp 1</code> and <code>sp 2</code> is illustrated as follows:</p>

<p><img src="http://typeocaml.com/content/images/2015/02/accumulate_8-1.jpg" alt="accumulate 8"/></p>

<p>Two things might need to be clarified:</p>

<ol>
<li>Although we assumed the resulting lists of sub-problems to be sorted, they will naturally become sorted anyway because we are doing the <em>smaller goes first</em> merging.  </li>
<li>We need to attach the lengths to each resulting list on the right and keep updating them because scanning the length of a list takes <code>O(n)</code>.</li>
</ol>

<p>Obviously this way of accumulation can give us <code>O(n)</code>. Because at most we can divide <code>O(logn)</code> times, our <em>divide and conquer and accumulate</em> solution will be <code>O(nlogn)</code>.</p>

<h1>Code</h1>

<p>At first, we <em>divide</em>. Note that this version of <em>divide</em> is actually a kind of <code>splitting from middle</code>, as the original order of the elements before we get any solution is important.</p>

<pre><code class="ocaml">(* we have a parameter n to indicate the length of l.
   it will be passed by the caller and 
   in this way, we do not need to scan l for its length every time.

   it will return left, right and the length of the right.
*)
let divide l n =  
  let m = n / 2 in
  let rec aux left i = function
    | [] -&gt; List.rev left, [], 0
    | right when i &gt;= m -&gt; List.rev left, right, n-i
    | hd::tl -&gt; aux (hd::left) (i+1) tl
  in
  aux [] 0 l
</code></pre>

<p>Now <em>accumulate</em>. We put it before writing <em>conquer</em> because <em>conquer</em> would call it thus it must be defined before <em>conquer</em>.</p>

<pre><code class="ocaml">let accumulate l1 l2 len2 =  
  let rec aux acc len2 = function
    | l, [] | [], l -&gt; List.rev_append acc l
    | (hd1,ns1)::tl1 as left, ((hd2,ns2)::tl2 as right) -&gt;
      if hd1 &gt;= hd2 then aux ((hd2,ns2)::acc) (len2-1) (left, tl2)
      else aux ((hd1,ns1+len2)::acc) len2 (tl1, right)
  in
  aux [] len2 (l1, l2)
</code></pre>

<p><em>conquer</em> is the controller.</p>

<pre><code class="ocaml">(* note the list parameter is a list of tuple, i.e., (x, ns) *)
let rec conquer n = function  
  | [] | _::[] as l -&gt; l
  | l -&gt;
    let left, right, right_len = divide l n in
    let solution_sp1 = conquer (n-right_len) left in
    let solution_sp2 = conquer right_len right in
    accumulate solution_sp1 solution_sp2 right_len
</code></pre>

<p>So if we are given a list of numbers, we can now get all numbers of surpassers:</p>

<pre><code class="ocaml">let numbers_of_surpassers l =  
  List.map (fun x -&gt; x, 0) l |&gt; conquer (List.length l)
</code></pre>

<p>Are we done? No! we should find the max number of surpassers out of them:</p>

<pre><code class="ocaml">(* we should always consider the situation where no possible answer could be given by using **option**, although it is a bit troublesome *)
let max_num_surpassers = function  
  | [] -&gt; None
  | l -&gt;
    let nss = numbers_of_surpassers l in
    Some (List.fold_left (fun max_ns (_, ns) -&gt; max max_ns ns) 0 nss)
</code></pre>

<hr/>

<p><strong>[1]</strong> Unless I can see an optimal solution instantly, I always intend to think of the most straightforward one even though it sometimes sounds stupid. I believe this is not a bad habit. Afterall, many good solutions come out from brute-force ones. As long as we anyway have a solution, we can work further based on it and see whether we can make it better. </p>

<p><strong>[2]</strong> Yes, I believe the dragon lady will <a href="http://www.imdb.com/title/tt0944947/">end the game and win the throne</a>. It is the circle and fate. </p>

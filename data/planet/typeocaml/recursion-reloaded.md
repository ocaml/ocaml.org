---
title: Recursion Reloaded
description: This post revises the recursion and describes the correct way for modelling
  recursive problems. Examples of sum, merge, and mergesort in OCaml are provided....
url: http://typeocaml.com/2014/12/04/recursion-reloaded/
date: 2014-12-04T15:44:18-00:00
preview_image:
featured:
authors:
- typeocaml
---

<p><img src="http://typeocaml.com/content/images/2014/12/infinity-cubes-room.jpg#hero" alt="recursion_reloaded"/></p>

<p>One essential of computer programming is <em>repeating some operations</em>. This repetition has two forms: <em>for / while loop</em> and <em>recursion</em>. </p>

<p><strong>Loop</strong></p>

<ul>
<li>We directly setup a boundary via <em>for</em> or <em>while</em>.</li>
<li>Certain conditions change inside the boundary.</li>
<li>And operations are executed based on the changing conditions.</li>
<li>It ends when hitting the boundary.</li>
</ul>

<p>if asked to write the <code>sum</code> method in Java, it might be more intuitive to have this code:</p>

<pre><code class="java">/* Java */
public int sum(int[] a) {  
  int s = 0;
  for (int i = 1; i &lt;= n; i++)
    s += a[i];
  return s
}
</code></pre>

<p><strong>Recursion</strong></p>

<ul>
<li>We write a function for the operations that need to be repeated.</li>
<li>The repetition is achieved by invoking the function inside itself. </li>
<li>We may not specify an explicit boundary, yet we still need to set a STOP sign inside the function to tell it when to stop invoking itself.</li>
<li>It ends when hitting the STOP sign.</li>
</ul>

<p>The recursive <code>sum</code> in OCaml can look like this:</p>

<pre><code class="ocaml">(* OCaml *)
let sum = function  
  | [] -&gt; 0 (*STOP sign*)
  | hd::tl -&gt; hd + sum tl
</code></pre>

<p><strong>loop or recursion?</strong></p>

<p>In imperative programming, developers may use <em>loop</em> more often than recursion as it seems to be more straightforward. </p>

<p>However, in functional programming, we almost (<em>[1]</em>) cannot do <em>loop</em>, and <em>recursion</em> is our only option. The major reason is that <em>loop</em> always needs to maintain mutable states inside the clause to change the conditions or pass intermediate results through iterations. Unfortunately, in functional programming, mutables are not allowed (<em>[2]</em>) and also intermediates must be passed via function calls not state changing. </p>

<p>So, if we really wish to get into the OCaml world, we have to get used to recursion. If you feel a bit hard, then this post is supposed to help you a little bit and show you the lovely side of recursion. </p>

<h1>Do you dislike recursion?</h1>

<p>Honestly, I hated recursion in the beginning. In order to <strong>write a recursive function</strong> or <strong>validate one's correctness</strong>, I thought I had to always somehow simulate the execution flow in my head and imagine divings into one level after another and every time when I did that, my brain felt a bit lost after some levels and sometimes I had to use pen &amp; paper. </p>

<p>This pain is natural. Human's brain feels much more comfortable on linear tasks than recursive ones. For example, if we are asked to finish the flow of first finish <em>task-1</em> -&gt; <em>task-2</em> -&gt; <em>task-3</em> -&gt; <em>task-4</em> -&gt; <em>done</em>, it seems concise and easy. On the other hand, if we are asked to finish <em>task-1</em>, inside which we need to finish <em>task-2</em> and <em>task-3</em>, and inside <em>task-2</em> we need to finish <em>task-4</em> and <em>task-5</em>, and inside <em>task-3</em> we need...(<em>[3]</em>), our brain may not that happy, does it? </p>

<p>What is the difference between these two cases? </p>

<p>In the first case, when we do <em>task-1</em>, we do not need to care about <em>task-2</em>; and after we finish <em>task-1</em>, we just move on and forget <em>task-2</em>. Thus, we just focus and remember one thing at one time. </p>

<p>In the second case, when do do <em>task-1</em>, we not only need to foresee a bit on <em>task-2</em> and <em>task-3</em>, but also can't forget <em>task-1</em>; and we need to still keep <em>task-2</em> in mind after we begin <em>task-4</em>...</p>

<p>So the difference is very obvious: we remember / track more things in case 2 than in case 1. </p>

<p>Let's investigate this difference further in the paradigm of the two different <code>sum</code> functions written early.</p>

<h2>Linear way</h2>

<p>Summing [9;14;12;6;], what will we do? </p>

<ol>
<li>We will do <code>9 + 14</code> first, we get <code>23</code> and we put the <code>23</code> somewhere, say, place <code>S</code>.  </li>
<li>Next number is <code>12</code>, then we check <code>S</code>, oh it is <code>23</code>, so we do <code>23 + 12</code> and get <code>35</code>.  </li>
<li>Now, we do not need the previous result <code>23</code> any more and update <code>S</code> with <code>35</code>.  </li>
<li>Next one is <code>6</code>, ...</li>
</ol>

<p><img src="http://typeocaml.com/content/images/2014/12/linear.jpg#small" alt="linear"/></p>

<p>If we look closer into the diagram above, we will find out that at any single step, we need to care only <code>S</code> and can forget anything happened before. For example, in step 1, we get 2 numbers from the list, calculate, store it to <code>S</code> and forget the 2 numbers; then go to step 2, we need to retrieve from <code>S</code>, get the 3rd number, then update <code>S</code> with new result and forget anything else...</p>

<p>Along the flow, we need to retrieve one number from the list at one time and forget it after done with it. We also need to remember / track <code>S</code>, but it is just a single place; even if its value changes, we do not care about its old value. In total, we just have to bear <strong>2 things</strong> in mind at all time, no matter the how big the list can be.</p>

<p>For a contrast, let's take a look at the recursive way.</p>

<h2>Recursive way</h2>

<p>If we try to analyse the recursive <code>sum</code>, we get</p>

<p><img src="http://typeocaml.com/content/images/2014/12/recursive.jpg#small" alt="recursive"/></p>

<p>After we retrieve the first number, 9, from the list, we cannot do anything yet and have to continue to retrieve 14 without forgetting 9, and so on so forth. It is easy to see that we need to remember <strong>4 things</strong> (marked as red square) if we use our brain to track the flow. It might be fine if there are only 4 numbers. Yet if the list has 100 random numbers, we need to remember <strong>100 things</strong> and our brains would be fried.</p>

<p>Basically, as long as we try to simulate the complete recursive / iteration flow, we cannot avoid remembering potentially big number of things. So what is the solution to escape this pain? The answer is simple: <strong>we do not simulate</strong>. </p>

<p>Actually, for many problems that need recursion, we do not need to look into the details of recursion and we do not need to iterate the function in our heads. <strong>The trick is the way of modeling the recursion</strong>.</p>

<h1>Recursion should be loved</h1>

<p>Let's revise the recursive <code>sum</code> function:</p>

<pre><code class="ocaml">let sum = function  
  | [] -&gt; 0 (*STOP sign*)
  | hd::tl -&gt; hd + sum tl
</code></pre>

<p>One <strong>bad way</strong> to interpret its repeatition process is </p>

<ol>
<li>We get an element out  </li>
<li>On the lefthand side of <code>+</code>, we hold it  </li>
<li>On the righthand side of <code>+</code>, we do point 1 again.  </li>
<li>After STOP, we do the plus on the previous numbers that were held, one by one</li>
</ol>

<p>This way is bad because it involves simulating the flow.</p>

<p>The <strong>good way</strong> to interpret is:</p>

<ol>
<li>Someone tells me <code>sum</code> can do the job of summing a list  </li>
<li>We don't care what exactly <code>sum</code> is doing  </li>
<li>If you give me a list and ask me to sum, then I just get the head (<code>hd</code>) out, and add it with <code>sum</code> of the rest  </li>
<li>Of course, what if the list is empty, then <code>sum</code> should return 0</li>
</ol>

<p>Unlike the bad way, this modelling has actually removed the iteration part from recursion, and been purely based on logic level: <strong>sum of list = hd + sum of rest</strong>. </p>

<p>To summary this process of modelling:</p>

<ul>
<li>I need to write a recursive function <code>f</code> to solve a problem</li>
<li>I won't think the exact steps or details inside <code>f</code></li>
<li>I just assume <code>f</code> is already there and correct</li>
<li>If the problem size is <em>N</em>, then I divide it into <em>X</em> and <em>Y</em> where <em>X + Y = N</em></li>
<li>If <code>f</code> is correct, then <code>f X</code> and <code>f Y</code> are both correct, right?</li>
<li>So to solve <code>N</code>, we just need to do <code>f X</code> and <code>f Y</code>, then think out <strong>some specific operations</strong> to wire the results together.</li>
<li>Of course, <code>f</code> should recognise STOP signs.</li>
</ul>

<p>So what we really need to do for recursion are:</p>

<ol>
<li>Think how to divid <code>N</code> to <code>X</code> and <code>Y</code>  </li>
<li>Think how to deal with the results from <code>f X</code> and <code>f Y</code> in order to get result of <code>f N</code>  </li>
<li>Set the STOP sign(s)</li>
</ol>

<p>Let's rewrite <code>sum</code> to fully demenstrate it</p>

<ol>
<li>We need to sum a list  </li>
<li>I don't know how to write <code>sum</code>, but I don't care and just assume <code>sum</code> is there  </li>
<li>a list <code>l</code> can be divid to <code>[hd]</code> + <code>tl</code>  </li>
<li>So <code>sum l = sum [hd] + sum tl</code> should make sense.  </li>
<li>Of course, STOP signs here can be two: <code>sum [] = 0</code> and <code>sum [x] = x</code>.</li>
</ol>

<pre><code class="ocaml">let sum = function  
  | [] -&gt; 0 (*STOP sign*) 
  | [x] -&gt; x (*STOP sign*)
  | hd::tl -&gt; sum [hd] + sum tl (* Logic *)
(* note sum [hd] can directly be hd, I rewrote in this way to be consistent to the modelling *)
</code></pre>

<p>I am not sure I express this high level logic based modelling clearly or not, but anyway we need more practices.</p>

<h2>Merge two sorted lists</h2>

<p>We need a <code>merge</code> function to merge two sorted lists so the output list is a combined sorted list.</p>

<h3>N = X + Y</h3>

<p>Because the head of the final combined list should be always min, so we care about the first elements from two lists as each is already the min inside its owner. <code>l1 = hd1 + tl1</code> and <code>l2 = hd2 + tl2</code>. </p>

<h3>f N = wire (f X)  (f Y)</h3>

<p>We will have two cases here.</p>

<p>If hd1 &lt; hd2, then X = tl1 and Y = l2, then the wiring operation is just to add hd1 as the head of <code>merge X Y</code></p>

<p>If hd1 &gt;= hd2, then X = l1 and Y = tl2, then the wiring operation is just to add hd2 as the head of <code>merge X Y</code></p>

<h3>STOP sign</h3>

<p>If one of the lists is empty, then just return the other (no matter it is empty or not).</p>

<h3>Code</h3>

<p>Then it should be easy to write the code from the above modelling.</p>

<pre><code class="ocaml">let merge = function  
  | [], l | l, [] -&gt; l (*STOP sign, always written as first*) 
  | hd1::tl1 as l1, hd2::tl2 as l2 -&gt; 
    if hd1 &lt; hd2 then hd1::merge (tl1, l2)
    else hd2::merge (l1, tl2)
</code></pre>

<p>The idea can be demonstrated by the diagram below:</p>

<p><img src="http://typeocaml.com/content/images/2014/12/merge.jpg" alt="merge"/></p>

<h2>Mergesort</h2>

<p>Mergesort is a way to sort a list.</p>

<h3>N = X + Y</h3>

<p>We can split N evenly so X = N / 2 and Y = N - N / 2.</p>

<h3>f N = wire (f X)  (f Y)</h3>

<p>What if we already mergesorted X and mergesorted Y? We simply <code>merge</code> the two results, right? </p>

<h3>STOP sign</h3>

<p>If the list has just 0 or 1 element, we simply don't do anything but return.</p>

<h3>Code</h3>

<pre><code class="ocaml">(* split_evenly is actually recursive too
   We here just ignore the details and use List.fold_left *)
let split_evenly l = List.fold_left ~f:(fun (l1, l2) x -&gt; (l2, x::l1)) ~init:([], []) l

let rec mergesort l =  
  match l with
    | [] | hd::[] as l -&gt; l
    | _ -&gt; 
      let l1, l2 = split_evenly l in
      merge (mergesort l1) (mergesort l2)
</code></pre>

<h1>More recursions will follow</h1>

<p>So far, all examples used in this post are quite trivial and easy. I chose these easy ones because I wish to present the idea in the simplest way. Many other recursion problems are more complicated, such as permutations, combinations, etc. I will write more posts for those.</p>

<p>One of the execellent use case of recursion is Binary Search Tree. In BST, we will see that the size of a problems is naturally split into 3. Depending on the goal, we deal with <strong>all or partial</strong> of the 3 sub-problems. I will demonstrate all these in the next post.</p>

<p>Again, remember, when dealing with recursion, don't try to follow the execution flow. Instead, focus on splitting the problem into smaller ones and try to combine the results. This is also called <em>divide and conquer</em> and actually it is the true nature of recursion. After all, no matter the size of the problem can be, it is anyway the same function that solve the cases of <code>size = 0</code>, <code>size = 1</code>, and <code>size = n &gt; 2</code>, right?</p>

<hr/>

<p><strong>[1]</strong> OCaml allows imperative style, but it is not encouraged. We should use imperative programming in OCaml only if we have to.</p>

<p><strong>[2]</strong> OCaml allows mutables and sometimes they are useful in some cases like in <a href="http://typeocaml.com/2014/11/13/magic-of-thunk-lazy/">lazy</a> or <em>memorise</em>. However, in most cases, we are not encouraged to use mutables.</p>

<p><strong>[3]</strong> I already got lost even when I am trying to design this case</p>

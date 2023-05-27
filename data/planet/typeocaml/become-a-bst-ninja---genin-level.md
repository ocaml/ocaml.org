---
title: Become a BST Ninja - Genin Level
description: This post presents the recursive modelling skills for binary search tree
  problems in OCaml, at entry level. Essential operations are described....
url: http://typeocaml.com/2014/12/19/how-to-become-a-bst-ninja-genin/
date: 2014-12-19T12:28:00-00:00
preview_image:
featured:
authors:
- typeocaml
---

<p><img src="http://typeocaml.com/content/images/2014/12/bst_ninja.jpg#hero" alt="bst_ninja"/></p>

<p>Binary Search Tree (<em>BST</em>) is one of the most classic data structures. The definition for its structure is shown as below:</p>

<ul>
<li>It consists of <em>Nodes</em> and <em>Leaves</em>.</li>
<li>A <em>Node</em> has a child bst on the <em>left</em> side, a <em>key</em> (, a <em>data</em>), and a child bst on the <em>right</em> side. Note here <strong>a node's left or right child is not a node, instead, is indeed another binary search tree</strong>. </li>
<li>A <em>Leaf</em> has nothing but act only as a STOP sign. </li>
</ul>

<pre><code class="ocaml">type 'a bst_t =  
  | Leaf
  | Node of 'a bst_t * 'a * 'a bst_t (* Node (left, key, right) *)
(* a node may also carry a data associated with the key. 
   It is omitted here for neater demonstration *)
</code></pre>

<p>The important feature that makes BST unique is </p>

<ul>
<li>for any node
<ul><li>all keys from its <strong>left child are smaller</strong> than its own key</li>
<li>all keys from its <strong>right child are bigger</strong> (assumming keys are distinct)</li></ul></li>
</ul>

<p>And here is an example of BST:</p>

<p><img src="http://typeocaml.com/content/images/2014/12/example_bst.jpg" alt="example_bst"/></p>

<p>Instead of continuing to present the basics of BST, this post will now focus on how to attack BST related problems with the most powerful weapon: <strong>Recursion</strong>. </p>

<h1>Recursion on BST</h1>

<p>From <a href="http://typeocaml.com/2014/12/04/recursion-reloaded/">Recursion Reloaded</a>, we know that one way to model recursion is:</p>

<ol>
<li>Assume we already got a problem solver: <code>solve</code>.  </li>
<li>Don't think about what would happen in each iteration.  </li>
<li><strong>Split</strong> the problem to smallers sizes (<em>N = N1 + N2 + ...</em>).  </li>
<li>Solve those smaller problems like <code>solve N1</code>, <code>solve N2</code>, ... Here is the tricky part: still, we do not know or care what are inside <code>solve</code> and how <code>f</code> would do the job, we just believe that it will return the correct results.  </li>
<li>Now we have those results for smaller problems, how to <strong>wire</strong> them up to return the result for <em>N</em>? This is the ultimate question we need to answer.  </li>
<li>Of course, we do not forget the <strong>STOP sign</strong> for some edge cases.  </li>
<li>Together with point 5 and 6, we get our <code>solve</code>.</li>
</ol>

<p>A good thing coming from BST is that the <em>split</em> step has been done already, i.e., a BST problem can be always divided into <em>left child</em>, <em>root</em>, and <em>right child</em>.</p>

<p>Thus if we assume we already got <code>solve</code>, we just need to solve <em>left</em> and / or solve <em>right</em>, then do something with <em>root</em>, and finally wire all outcomes to obtain the final result. Again, we should of course never forget the STOP sign and in BST, usually it is the <em>Leaf</em>, i.e., we need to ask ourselves what if the BST is a <em>Leaf</em>. </p>

<p>The thinking flow is illustrated as the diagram below.</p>

<p><img src="http://typeocaml.com/content/images/2014/12/left_root_right-4.jpg" alt="solve"/></p>

<p>Before we start to look at some problems, note that in the diagram above or <a href="http://typeocaml.com/2014/12/04/recursion-reloaded/">Recursion Reloaded</a>, we seem to always solve <em>both left and right</em>, or say, <em>all sub-problmes</em>. It is actually not necessary. For BST, sometimes <em>either left or right</em> is enough. Let's have a look at this case first. </p>

<h1>Either Left or Right</h1>

<p>Our starter for this section is the simplest yet very essential operation: <strong>insert</strong> a key to a BST.</p>

<h2>Insert</h2>

<p>From the definition of BST, we know the basic rule is that if the new key is smaller than a root, then it belongs to the root's left child; otherwise, to the root's right child. Let's follow the modelling in the previous diagram to achieve this.</p>

<ol>
<li>We assume we already got <code>insert key bst</code>  </li>
<li>We know the problem can be split into <em>left</em>, <em>root</em>, and <em>right</em>.  </li>
<li>Because a new key can go either left or right, so we need to <em>deal_with root</em> first, i.e., compare the new key and the key of the root.  </li>
<li>Directly taken from the rule of BST, if the new key is smaller, then we need to <em>solve left</em> thus <code>insert key left</code>; otherwise <code>insert key right</code>.  </li>
<li>What if we get to a <em>Leaf</em>? It means we can finally place our new key there as a new <em>Node</em> and of course, at this moment both children of the new <em>Node</em> are <em>Leaves</em>.</li>
</ol>

<p><img src="http://typeocaml.com/content/images/2014/12/insert-2.jpg" alt="insert"/></p>

<p>Note that the BST type in OCaml we defined early on is pure functional, which means every time we need to update something, we have to create new. That's why in the diagram, even if we just insert x to left or right, we need to construct a new <em>Node</em> because we are updating the left child or the right one. The code is shown as below.</p>

<pre><code class="ocaml">let rec insert x = function  
  | Leaf -&gt; Node (Leaf, x, Leaf) (* Leaf is a STOP *)
  | Node (left, k, right) -&gt;
    if x &lt; k then Node (insert x left, k, right) (* if x is smaller, go left *)
    else Node (left, k, insert x right) (* otherwise, go right *)
</code></pre>

<h2>Member</h2>

<p><code>member</code> is to check whether a given key exists in the BST or not. It is very similar to <code>insert</code>. There are three differences:</p>

<ol>
<li>When <em>dealing with root</em>, we need to see whether the given key equals to the root's key or not. If yes, then we hit it.  </li>
<li><code>member</code> is a readonly function, so we directly solve <em>left</em> or <em>right</em> without constructing new <em>Node</em>.  </li>
<li>If arriving at a <em>Leaf</em>, then we have nowhere to go any more and it means the given key is not in the BST.</li>
</ol>

<pre><code class="ocaml">let rec mem x = function  
  | Leaf -&gt; false
  | Node (left, k, right) -&gt;
    if x &lt; k then mem x left
    else if x = k then true
    else mem x right
</code></pre>

<h1>Both Left and Right</h1>

<p>Usually when we need to retrieve some properties of a BST or possibly go through all nodes to get an answer, we have to solve both children. However, the modelling technique does not change. </p>

<h2>Height</h2>

<p>Recall from <a href="http://typeocaml.com/2014/11/26/height-depth-and-level-of-a-tree/">Some properties of a tree</a>, the height of a tree is the number of edges that the longest path (from the root to a leaf) has. From this definition, it seems easy to get the height. We simply try to find all possible paths from root and for each path we record its number of edges. The answer will be the max of them. It sounds straightforward, but if you really try to write the code in this way, I bet the code would be a bit messy. Honestly, I never wrote in this way and I will never do that.</p>

<p>Another way is to think recursively. First let analyse a little bit about the longest path matter.</p>

<p><img src="http://typeocaml.com/content/images/2014/12/height.jpg#small" alt="height"/></p>

<p>As we can see from the above diagram, <em>Root</em> has two edges: one to <em>Left</em> and the other to <em>Right</em>. So whatever the longest path from <em>Root</em> might be, it must pass either <em>Left</em> or <em>Right</em>. If we somehow could obtain the longest path from the root of <em>Left</em> and the longest path from the root of <em>Right</em>, the longest path from <em>Root</em> should be the bigger one of the two paths, right?</p>

<p>Let's now assume we already got <code>height</code> and it will return the height of a BST. Then we can obtain <code>h_left</code> and <code>h_right</code>. The answer is what is the <code>h</code> (height of <em>Root</em>)? Note that the height implies the longest path already (that's the definition). So from the paragraph above, What we need to do is getting <code>max h_left h_right</code>. Since <em>Root</em> has an edge to either child, <code>h = 1 + max h_left h_right</code>.</p>

<p>Don't forget the <em>STOP</em> sign: the height of a Leaf is 0.</p>

<pre><code class="ocaml">let rec height = function  
  | Leaf -&gt; 0
  | Node (left, _, right) -&gt; 1 + max (height left) (height right)
</code></pre>

<p>Simple, isn't it?</p>

<h2>Keys at a certain depth</h2>

<p>So far, it seems our hypothetic <code>solve</code> function takes only the sub-probem as parameter. In many cases this is not enough. Sometimes we need to supply <strong>more arguments</strong> to help <code>solve</code>. For example, in the problem of retriving all keys at a certain depth definitely needs <em>current depth</em> information.</p>

<p><img src="http://typeocaml.com/content/images/2014/12/depth-1.jpg#small" alt="depth"/></p>

<p>Only with the help of <code>current_depth</code>, the <em>Root</em> can know whether it belongs to the final results. </p>

<ol>
<li>If <code>current_depth = target_depth</code>, then <em>Root</em> should be collected. Also we do not continue to solve <em>Left</em> or <em>Right</em> as we know their depths will never equal to <em>target_deapth</em>.  </li>
<li>Otherwise, we need to solve both <em>Left</em> and <em>Right</em> with argument of <code>1 + current_depth</code>.  </li>
<li>Assume our <code>solve</code> is working. Then <code>solve left (1+current_depth)</code> would return a list of target nodes and so does <code>solve right (1+current_depth)</code>. We simply then concatenate two target lists.  </li>
<li>STOP sign: <em>Leaf</em> is not even a <em>Node</em>, so the result will be empty list. </li>
</ol>

<p>The code is like this:</p>

<pre><code class="ocaml">let rec from_depth d cur_d = function  
  | Leaf -&gt; []
  | Node (left, k, right) -&gt;
    if cur_d = d then [k]
    else from_depth d (cur_d + 1) left @ from_depth d (cur_d + 1) right

let all_keys_at depth bst = from_depth depth 0 bst  
</code></pre>

<h1>Genin</h1>

<p>From <a href="http://en.wikipedia.org/wiki/Ninja">Ninja Wiki</a></p>

<blockquote>
  <p>A system of rank existed. A j&#333;nin (&quot;upper man&quot;) was the highest rank, representing the group and hiring out mercenaries. This is followed by the ch&#363;nin (&quot;middle man&quot;), assistants to the j&#333;nin. At the bottom was the genin (&quot;lower man&quot;), field agents drawn from the lower class and assigned to carry out actual missions.</p>
</blockquote>

<hr/>

<p><strong>Ps.</strong> </p>

<p>Some readers contacted me. They hope that maybe I can use more advanced knowledge or harder examples in my posts and the current ones might seem a little boring. I think I need to explain a bit here. </p>

<p>The general idea behind <em>Many things about OCaml</em> is not to write a cookbook for certain problems related to OCaml or be a place where quick solution is there and copy / paste sample code would do the trick. Instead, <em>Many things</em> means some important aspects in OCaml that might be overlooked, or some particular problems that can show the greatness of OCaml, or the elegant OCaml solutions for some typical data structures and algorithms, etc. As long as something are valuable and that value shows only in OCaml or Functional Programming, I would like to add them all in here one by one. </p>

<p>Fortunately or unfortunately, even though I have only limited experiences in OCaml, I found that the <em>many</em> is actually quite big. And due to this <em>many</em>, I had to make a plan to present them all in a progressive way. Topics can interleave with each other in terms of time order as we do not want to have the same food for a month. More importantly, however, all should go from simple / easy to advanced / hard. In order to present some advanced topic, we need to make sure we have a solid foundation. This is why, for example, I even produced a post for <a href="http://typeocaml.com/2014/11/26/height-depth-and-level-of-a-tree/">the properties of a tree</a> although they are so basic. This is also why I <a href="http://typeocaml.com/2014/12/04/recursion-reloaded/">reloaded recursion</a> since recursion is everywhere in OCaml. They are a kind of preparations. </p>

<p>Moreover, I believe in fundamentals. Fundamentals are normally concise and contain the true essence. But sometimes they can be easily overlooked or ignored and we may need to experience a certain number of difficult problems afterwards, then start to look back and appreciate the fundamentals.</p>

<p>The reason of using simple examples is that it makes my life easier for demonstrations. I love visualisations and one graph can be better than thousands of words. For complicated problems and solutions, it is a bit more difficult to draw a nice and clean diagram to show the true idea behind. I will try to do so later on, but even if I could achieve it in this early stage, some readers might easily get lost or confused because of the unavoidable complication of the graph. As a result, the point of grasping fundamentals might be missed. </p>

<p>Anyway, please don't worry too much. Attractive problems in OCaml are always there. For example, in my plan, I will later start to present a number (maybe 15 ~ 17) of my beloved <a href="http://www.cambridge.org/gb/academic/subjects/computer-science/programming-languages-and-applied-logic/pearls-functional-algorithm-design">Functional Pearls</a> in OCaml and if you are really chasing for some awesomeness, I hope they would satisfy you.</p>

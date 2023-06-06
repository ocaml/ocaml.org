---
title: Heap - Leftist Tree
description: This post presents a functional heap - leftist tree in OCaml. It walks
  through binary heap, list based heap towards leftist tree. OCaml code has been supplied....
url: http://typeocaml.com/2015/03/12/heap-leftist-tree/
date: 2015-03-13T02:04:57-00:00
preview_image:
featured:
authors:
- typeocaml
---

<p><img src="http://typeocaml.com/content/images/2015/03/leftist.jpg#hero" alt="leftist"/></p>

<p><a href="https://en.wikipedia.org/wiki/Heap_(data_structure)">Heap</a> is one of most important data structure, where the minimum of all elements can always be easily and efficiently retrieved. </p>

<h1>Binary Heap</h1>

<p>In imperative world, <a href="https://en.wikipedia.org/wiki/Binary_heap">binary heap</a> (implemented via <em>array</em>) is frequently used. Here is an example:</p>

<p><img src="http://typeocaml.com/content/images/2015/03/binary_heap-2.jpg" alt="binary_heap"/></p>

<p>The (min) heap on the right hand side is a full binary tree indeed. The root is always the min and recursively, a root (of any sub tree) is always smaller than its two children. Note that <strong>we just need to keep partial order for heap</strong>, not total order like binary search tree. For example, <code>1</code> needs to be smaller than its two children, but the relationship between the two children does not matter. Thus, the left child and right child can be either <code>10</code> and <code>3</code> or <code>3</code> and <code>10</code>. Moreover, the big node <code>17</code> can be in the right branch of <code>1</code> while its parent <code>3</code> is smaller than <code>10</code>. </p>

<p>The array based implementation is actually beautiful. Essentially, it uses two tricks to simulate the binary heap tree:</p>

<ol>
<li>If the index of a root is <code>i</code>, then its left child index is <code>2*i+1</code> and right child index is <code>2*i+2</code>.  </li>
<li>The relationship of left child and right child is not important, so the two child slots in the array for a root can be fully used. (<em>Can we use array to implement a binary search tree?</em>)</li>
</ol>

<p>The time complexities on operations are:</p>

<ol>
<li><em>get_min</em>: <code>O(1)</code>  </li>
<li><em>insert</em>: <code>O(logn)</code>  </li>
<li><em>delete_min</em>: <code>O(logn)</code>  </li>
<li><em>merge</em>: <code>O(n)</code></li>
</ol>

<p>Although its <code>merge</code> is not satisfying, this data structure is adorable and gives us the most compact space usage on array. </p>

<p>However, unfortunately we cannot have it in pure functional world where mutable array is not recommended. </p>

<h1>List based heap</h1>

<p>I would like to first explore two possible functional approaches for heap (the list based in this section and the direct binary tree based in next section) . They are trivial or even incomplete, but the ideas behind may lead to the invention of leftist tree. </p>

<p>List is basically the replacement of array in functional world and of course, we can use it for heap. The idea is simple:</p>

<ol>
<li>When <em>insert</em> <code>x</code>, linearly compare <code>x</code> with all existing elements one by one and insert it to the appropriate place where the element on its left hand side is smaller and the element on its right is equal or bigger.  </li>
<li>When <em>get_min</em>, it is as simple as returning the head.  </li>
<li>When <em>delete_min</em>, remove the head.  </li>
<li>When <em>merge</em>, do a standard <em>merge</em> like in <em>mergesort</em>.</li>
</ol>

<p>The time complexities are:</p>

<ol>
<li><em>get_min</em>: <code>O(1)</code>  </li>
<li><em>insert</em>: <code>O(n)</code>  </li>
<li><em>delete_min</em>: <code>O(1)</code>  </li>
<li><em>merge</em>: <code>O(n)</code></li>
</ol>

<p><img src="http://typeocaml.com/content/images/2015/03/list_based-2.jpg" alt="list_based"/></p>

<p>We can see that in this design, the list is fully sorted all the time. And also it is a tree, with just one branch always. </p>

<p>Of course, the performance of <em>insert</em> and <em>merge</em> is <code>O(n)</code> which is unacceptable. This is due to the adoption of just one leg which is crowded with elements and all elements have to be in their natural order to fit in (remember a parent must be smaller than its kid(s)?). Eventually the fact of <em>total order is not necessary</em> is not leveraged at all. </p>

<p>Hence, we need <strong>at least two branches</strong> so that we may be able to spread some elements into different branches and the comparisons of the children of a root may be avoided. </p>

<h1>Binary Heap not using array</h1>

<p>Since the array based binary heap is a binary tree, how about implementing it directly in a binary tree form?</p>

<p>We can define a binary tree heap like this:</p>

<pre><code class="ocaml">type 'a bt_heap_t =  
  | Leaf
  | Node of 'a * 'a bt_heap_t * 'a bt_heap_t
</code></pre>

<p>The creation of the type is easy, but it is hard to implement those operations. Let's take <em>insert</em> as an example.</p>

<p><img src="http://typeocaml.com/content/images/2015/03/binary_tree_heap.jpg" alt="insert"/></p>

<p>The <em>attempt 1</em> in the diagram above illustrates the idea behind the array based binary heap. When we insert an element, ideally we should put it in the last available place at the bottom level or the first place at a brand new level if already full, then we do a <em>pull up</em> by comparing and swapping with parents one by one. Obviously, we cannot do it in a pure tree structure since it is not efficient to find the initial place.</p>

<p>So let's try <em>attempt 2</em> by directly try to insert from top to bottom. So in the example, <code>2 &lt; 6</code> so <code>2</code> stays and <code>6</code> should continue going down. However, the question now is <strong>which branch it should take?</strong> <code>10</code> or <code>3</code>? This is not trivial to decide and we have to find a good rule.  </p>

<p>We will also have problem in <em>delete_min</em>.</p>

<p><img src="http://typeocaml.com/content/images/2015/03/binary_tree_heap_delete.jpg" alt="delete_min"/></p>

<p>If we delete the root (min), then we will have two binary trees. Then the question is how to merge them? Do we just take all elements of one of the trees, and insert every element into the other tree? Will this way be efficient even if we are able to design a good <em>insert</em>? </p>

<p>If we consider <em>insert</em> as <em>merge</em> with a single node tree, then the problem of <em>insert</em> becomes the problem of <em>merge</em>, just like <em>delete_min</em>. <strong>Should we design a good <em>merge</em> so that both <em>insert</em> and <em>delete_min</em> are naturally solved</strong>?</p>

<p>Bear all those questions in mind, and now we can start look at leftist tree.</p>

<h1>Leftist Tree</h1>

<p>The concerns in answering those questions in the previous section are majorly about the performance. We are dealing with a tree. How the tree getting structure or transformed along the time is very important and it affects the performance a lot.</p>

<p>For example, for the question of <em>which branch to take when inserting</em>, if we just always go left, then the left branch will be longer and longer if we insert lots of elements, and the time complexity becomes <code>O(n)</code>.</p>

<p>Also when merging, the two trees are already heaps, i.e., the elements and structure of either tree obeys the principle that a parent must be smaller than its children. Why do we need to destory one tree completely? Why not try to keep the structures of two trees untouched as much as possible? If we can somehow attach a root from one tree directly under a root of another tree, then all children under the first root can stay still and no operations are necessary for them. </p>

<p>Let's see how leftist tree is designed to make sure the good performance.</p>

<h2>Left always longer</h2>

<p>Leftist tree always keeps the left branches of all roots being the longer and in worst case, they are as long as the right branches. In other word, all right branches of all roots are shortest. This makes sense. When we decide which branch to go, if we know one branch is always shorter than the other, then we should take it. This is because shorter branch means potentially less nodes and the number of future possible operations intends to be smaller. </p>

<p>In order to maintain this property, each node has a <strong>rank</strong>, which indidates <strong>the length of the path between the node and the right most leaf</strong>. For example, </p>

<p><img src="http://typeocaml.com/content/images/2015/03/leftist_rank.jpg" alt="rank"/></p>

<p>The way of keep ranks up-to-date is like this:</p>

<ol>
<li>We always assume <code>the rank of the right child &lt;= the rank of the left child</code>.  </li>
<li>So we always go right.  </li>
<li>If we reach a leaf, then we replace the leaf with our <em>element</em> and update the ranks of all the parents back to the root. Note that the <em>element</em> in this context is not necessarily the original new element which is being inserted and we will explain it soon.  </li>
<li>When updating the rank of a parent, we first compare the rank of left <code>rank_left</code> and the rank of right <code>rank_right</code>. If <code>rank_left &lt; rank_right</code>, then we swap the left child and the right child and update the rank of the parent to be <code>rank_left + 1</code>; other wise <code>rank_right + 1</code> </li>
</ol>

<p>A diagram is better than hundreds of words. Let's build a leftist by inserting two elements.</p>

<h2>Insert</h2>

<p><img src="http://typeocaml.com/content/images/2015/03/leftist_insert-2.jpg" alt="insert"/></p>

<p>We can see that by always putting the higher rank to the left can make the right branch being shortest all the time. Actually, this strategy is how this design of tree based heap got the name <em>leftist</em>, i.e., more nodes intend to be on the left side. </p>

<p>But this is not the full story of leftist. Actually, although the diagram above describes <em>insert</em>, it is just for the purpose of demonstration of how ranks are updated. </p>

<p>In leftist tree, the most important operation is <em>merge</em> and an <em>insert</em> is just a <em>merge</em> with a singleton tree that has only the new element and two leaves.</p>

<h2>Merge</h2>

<p><em>Merge</em> is a recursive operation.</p>

<ol>
<li>We have two trees to merge: <code>merge t1 t2</code>.  </li>
<li>Compare two roots, if <code>k1 &gt; k2</code>, we simply switch two trees by <code>merge t2 t1</code>. This is to make sure the tree on the left always has smaller key, for conveniences.  </li>
<li>Since <code>t1</code> has smaller key, its root should stay as the new root.  </li>
<li>Because <code>t1</code>'s right branch <code>r</code> is always shortest, we then do <code>merge r t2</code>.  </li>
<li>If one of the two trees is leaf, we simply returns the other. And begin the rank updating process back to the root.  </li>
<li>The rank updating is the same as we described in the previous section.</li>
</ol>

<p>Again, let's see an example.</p>

<p><img src="http://typeocaml.com/content/images/2015/03/leftist_merge.jpg" alt="merge"/></p>

<h2>Code</h2>

<p><strong>type</strong></p>

<pre><code class="ocaml">type 'a leftist =  
  | Leaf 
  | Node of 'a leftist * 'a * 'a leftist * int
</code></pre>

<p><strong>essentials</strong></p>

<pre><code class="ocaml">let singleton k = Node (Leaf, k, Leaf, 1)

let rank = function Leaf -&gt; 0 | Node (_,_,_,r) -&gt; r  
</code></pre>

<p><strong>merge</strong></p>

<pre><code class="ocaml">let rec merge t1 t2 =  
  match t1,t2 with
    | Leaf, t | t, Leaf -&gt; t
    | Node (l, k1, r, _), Node (_, k2, _, _) -&gt;
      if k1 &gt; k2 then merge t2 t1 (* switch merge if necessary *)
      else 
        let merged = merge r t2 in (* always merge with right *)
        let rank_left = rank l and rank_right = rank merged in
        if rank_left &gt;= rank_right then Node (l, k1, merged, rank_right+1)
        else Node (merged, k1, l, rank_left+1) (* left becomes right due to being shorter *)
</code></pre>

<p><strong>insert, get_min, delete_min</strong></p>

<pre><code class="ocaml">let insert x t = merge (singleton x) t

let get_min = function  
  | Leaf -&gt; failwith &quot;empty&quot;
  | Node (_, k, _, _) -&gt; k

let delete_min = function  
  | Leaf -&gt; failwith &quot;empty&quot;
  | Node (l, _, r, _) -&gt; merge l r
</code></pre>

<h2>Time complexity</h2>

<ol>
<li><em>get_min</em>: <code>O(1)</code>  </li>
<li><em>insert</em>: <code>O(logn)</code>  </li>
<li><em>delete_min</em>: <code>O(logn)</code>  </li>
<li><em>merge</em>: <code>O(logn)</code></li>
</ol>

<p>Leftist tree's performance is quite good. Comparing to the array based binary heap, it has a much better <em>merge</em>. Moreover, its design and implementation are simple enough. Thus, leftist tree can an excellent choice for heap in the functional world.</p>

---
title: Binomial Heap
description: This post presents another functional heap - binomial heap in OCaml.
  It also describes binomial tree in great details. Diagrams and OCaml code has been
  supplied....
url: http://typeocaml.com/2015/03/17/binomial-heap/
date: 2015-03-18T00:07:39-00:00
preview_image:
featured:
authors:
- typeocaml
---

<p><img src="http://typeocaml.com/content/images/2015/03/binomial_heap.jpg#hero" alt=""/></p>

<p>As we described in the previous post, leftist tree is a binary tree based functional heap. It manipulates the tree structure so that the left branches are always the longest and operations follow the right branches only. It is a clever and simple data structure that fulfills the purpose of heap. </p>

<p>In this post, we present another functional heap called <a href="http://en.wikipedia.org/wiki/Binomial_heap">Binomial Heap</a> (<em>[1]</em>). Instead of being a single tree strucutre, it is a list of <em>binomial tree</em>s and it provides better performance than leftist tree on <em>insert</em>. </p>

<p>However, the reason I would like to talk about it here is not because of its efficiency. The fascination of binomial heap is that <strong>if there are N elements inside it, then it will have a determined shape, no matter how it ended up with the N elements</strong>. Personally I find this pretty cool. This is not common in tree related data structures. For example, we can not predict the shape of a leftist tree with N elements and the form of a binary search tree can be arbitrary even if it is somehow balanced. </p>

<p>Let's have a close look at it.</p>

<h1>Binomial Tree</h1>

<p>Binomial tree is the essential element of binomial heap. Its special structure is why binomial heap exists. Understanding binomial tree makes it easier to understand binomial heap.</p>

<p>Binomial tree's definition does not involve the values associated with the nodes, but just the structure:</p>

<ol>
<li>It has a rank <em>r</em> and <em>r</em> is a natural number.  </li>
<li>Its form is <em>a root node</em> with <em>a list of binomial trees</em>, whose ranks are strictly <em>r-1</em>, <em>r-2</em>, ..., <em>0</em>.  </li>
<li>A binomial tree with rank <em>0</em> has only one root, with an empty list.</li>
</ol>

<p>Let's try producing some examples.</p>

<p>From point 3, we know the base case:</p>

<p><img src="http://typeocaml.com/content/images/2015/03/rank_0.jpg" alt="rank_0"/></p>

<p>Now, how about <em>rank 1</em>? It should be a root node with a sub binomial tree with rank <code>1 - 1 = 0</code>:</p>

<p><img src="http://typeocaml.com/content/images/2015/03/rank_1-1.jpg" alt="rank_1"/></p>

<p>Let's continue for <em>rank 2</em>, which should have <em>rank 1</em> and <em>rank 0</em>:</p>

<p><img src="http://typeocaml.com/content/images/2015/03/rank_2.jpg" alt="rank_2"/></p>

<p>Finally <em>rank 3</em>, can you draw it?</p>

<p><img src="http://typeocaml.com/content/images/2015/03/rank_3.jpg" alt="rank_3"/></p>

<h2>$ 2^r $ nodes</h2>

<p>If we pull up the left most child of the root, we can see:</p>

<p><img src="http://typeocaml.com/content/images/2015/03/r_2_r-1-3.jpg" alt="r_2_r-1"/></p>

<p>This means a binomial tree with rank <em>r</em> can be seen as <em>two</em> binomial trees with the same rank <em>r-1</em>. Furthermore, because that <em>two</em>, and rank <em>0</em> has one node, then in term of the number of nodes, for a binomial tree with <strong>rank <em>r</em>, it must have $ 2^r $ nodes, no more, no less</strong>.</p>

<p>For example, rank <em>0</em> has 1 node. Rank <em>1</em> is 2 <em>rank 0</em>, so rank <em>1</em> has $ 2 * 1 = 2 $ nodes, right? Rank <em>2</em> then has $ 2 * 2 = 4 $ nodes, and so on so forth.</p>

<p>Note that $ 2^r = 1 + 2^r-1 + 2^r-2 + ... + 2^0 $ and we can see that a rank <em>r</em> tree's structure fits exactly to this equation (the <em>1</em> is the root and the rest is the children list). </p>

<h2>Two <em>r-1</em> is the way to be <em>r</em></h2>

<p>The definition tells us that a rank <em>r</em> tree is a root plus a list of trees of rank <em>r-1</em>, <em>r-2</em>, ..., and <em>0</em>. So if we have a binomial tree with an arbitrary rank, can we just insert it to another target tree to form a rank <em>r</em> tree?</p>

<p>For example, suppose we have a rank <em>1</em> tree, can we insert it to the target tree below for a rank <em>3</em> tree?</p>

<p><img src="http://typeocaml.com/content/images/2015/03/wrong_way.jpg" alt="wrong"/></p>

<p>Unfortunately we cannot, because the target tree won't be able to exist in the first place and it is not a valid binomial tree, is it?</p>

<p>Thus in order to have a rank <em>r</em> tree, we must have two <em>r-1</em> trees and link them together. When linking, we need to decide which tree is the new root, depending on the context. For the purpose of building a <em>min heap</em> later, we assume we always let the root with the <em>smaller</em> key be the root of the new tree.</p>

<h2>code</h2>

<p>Defining a binomial tree type is easy:</p>

<pre><code class="ocaml">(* Node of key * child_list * rank *)
type 'a binomial_t = Node of 'a * 'a binomial_t list * int  
</code></pre>

<p>Also we can have a function for a singleton tree with rank <em>0</em>:</p>

<pre><code class="ocaml">let singleton_tree k = Node (k, [], 0)  
</code></pre>

<p>Then we must have <code>link</code> function which promote two trees with same ranks to a higher rank tree.</p>

<pre><code class="ocaml">let link ((Node (k1, c1, r1)) as t1) ((Node (k2, c2, r2)) as t2) =  
  if r1 &lt;&gt; r2 then failwith &quot;Cannot link two binomial trees with different ranks&quot;
  else if k1 &lt; k2 then Node (k1, t2::c1, r1+1)
  else Node (k2, t1::c2, r2+1)
</code></pre>

<p>One possibly interesting problem can be:</p>

<blockquote>
  <p>Given a list of $ 2^r $ elements, how to construct a binomial tree with rank <em>r</em>?</p>
</blockquote>

<p>We can borrow the idea of <em>merging from bottom to top</em> for this problem.</p>

<p><img src="http://typeocaml.com/content/images/2015/03/from_list_2-1.jpg" alt="from_list"/></p>

<pre><code class="ocaml">let link_pair l =  
  let rec aux acc = function
    | [] -&gt; acc
    | _::[] -&gt; failwith &quot;the number of elements must be 2^r&quot;
    | t1::t2::tl -&gt; aux (link t1 t2 :: acc) tl
  in
  aux [] l

let to_binomial_tree l =  
  let singletons = List.map singleton_tree l in
  let rec aux = function
    | [] -&gt; failwith &quot;Empty list&quot;
    | t::[] -&gt; t
    | l -&gt; aux (link_pair l)
  in
  aux singletons
</code></pre>

<h2>Binomial coefficient</h2>

<p>If we split a binomial tree into levels and pay attention to the number of nodes on each level, we can see:</p>

<p><img src="http://typeocaml.com/content/images/2015/03/binomial_coefficiency.jpg" alt="binomial coefficient"/></p>

<p>So from top to bottom, the numbers of nodes on levels are <em>1</em>, <em>3</em>, <em>3</em> and <em>1</em>. It happens to be the coefficients of $ (x+y)^3 $ .</p>

<p>Let's try rank <em>4</em>:</p>

<p><img src="http://typeocaml.com/content/images/2015/03/binomial_coefficiency_2.jpg" alt="binomial_coefficient_2"/></p>

<p>They are <em>1</em>, <em>4</em>, <em>6</em>, <em>4</em> and <em>1</em>, which are the coefficients of $ (x+y)^4 $ .</p>

<p>The number of nodes on level <em>k</em> ( 0 &lt;= <em>k</em> &lt;= <em>r</em>) matches $ {r}\choose{k} $, which in turn matches <strong>the kth binomial coefficient of $ (x+y)^r $. This is how the name <em>binomial</em> tree came from</strong>.</p>

<h1>Binomial Heap</h1>

<p>A binomial heap is essentially a list of binomial trees with distinct ranks. It has two characteristics:</p>

<ol>
<li>If a binomial heap has <em>n</em> nodes, then its shape is determined, no matter what operations have been gone through it.  </li>
<li>If a binomial heap has <em>n</em> nodes, then the number of trees inside is <code>O(logn)</code>.</li>
</ol>

<p>The reason for the above points is explained as follows.</p>

<p>As we already knew, a binomial tree with rank <em>r</em> has $ 2^r $ nodes. If we move to the context of binary presentation of numbers, then a rank <em>r</em> tree stands for the case where there is a list of bits with only the <em>rth</em> slot turned on.</p>

<p><img src="http://typeocaml.com/content/images/2015/03/binary.jpg" alt="binary"/></p>

<p>Thus, for <em>n</em> number of nodes, it can be expressed as a list of binomial trees with distinct ranks, because the number <em>n</em> is actually a list of bits with various slots being <em>1</em>. For example, suppose we have 5 nodes (ignoring their values for now), mapping to a list of binomial trees, we will have:</p>

<p><img src="http://typeocaml.com/content/images/2015/03/binomial_heap_origin-2.jpg" alt="origin"/></p>

<p>This is where binomial heap comes from. </p>

<ol>
<li>Since a number <em>n</em> has determined binary presentation, a binomial heap also has fixed shape as long as it has <em>n</em> nodes.  </li>
<li>In addition, because <em>n</em> has <code>O(logn)</code> effective bits, a binomial heap has <code>O(logn)</code> binomial trees.  </li>
<li>If we keep each binomial tree having the min as the root, then for a binomial heap, the overall minimum elements is on of those roots.</li>
</ol>

<p>Let's now implement it.</p>

<h2>Type and singleton</h2>

<p>It is easy.</p>

<pre><code class="ocaml">type 'a binomial_heap_t = 'a binomial_t list
</code></pre>

<h2>insert</h2>

<p>When we <em>insert</em> a key <code>k</code>, we just create a singleton binomial tree and try to insert the tree to the heap list. The rule is like this:</p>

<ol>
<li>If the heap doesn't have a rank <em>0</em> tree, then directly insert the new singleton tree (with rank <em>0</em>) to the head of the list.  </li>
<li>If the heap has a rank <em>0</em> tree, then the two rank <em>0</em> tree need to be linked and promoted to a new rank <em>1</em> tree. And we have to continue to try to insert the rank <em>1</em> tree with the rest of the list that potentiall starts with a existing rank <em>1</em> tree.  </li>
<li>If there is already a rank <em>1</em> tree, then link and promot to rank <em>2</em>... so on so forth, until the newly promoted tree has a slot to fit in.</li>
</ol>

<p>Here are two examples:</p>

<p><img src="http://typeocaml.com/content/images/2015/03/insert.jpg" alt="insert_1"/></p>

<p><img src="http://typeocaml.com/content/images/2015/03/insert_2.jpg" alt="insert_2"/></p>

<p>The <em>insert</em> operation is actually the addition between <em>1</em> and <em>n</em> in binary presentation, in a revered order. </p>

<pre><code class="ocaml">let insert k h =  
  let rec aux acc (Node (_, _, r1) as bt1) = function
    | [] -&gt; List.rev (bt1::acc)
    | (Node (_, _, r2) as bt2)::tl -&gt;
      if r1 = r2 then aux acc (link bt1 bt2) tl
      else if r1 &lt; r2 then List.rev_append acc (bt1::bt2::tl)
      else aux (bt2::acc) bt1 tl
  in
  aux [] (singleton_tree k) h
</code></pre>

<p>If the heap is full as having a consecutive series of ranks of trees starting from rank <em>0</em>, we need <code>O(logn)</code> operations to finish the <em>insert</em>. However, once it is done, most of the lower rank slots are empty (like shown in the above figure). And for later new <em>insert</em>, it won't need <code>O(logn)</code> any more. Thus, The time complexity of <em>insert</em> seems to be <code>O(logn)</code>, but <strong>actually amortised <code>O(1)</code></strong>.</p>

<p>Note the above <em>insert</em> description is just for demonstration purpose. Like in <a href="http://typeocaml.com/2015/03/12/heap-leftist-tree/">Leftist tree</a>, <em>merge</em> is the most important operation for binomial heap and <em>insert</em> is just a simpler <em>merge</em>. </p>

<h2>merge</h2>

<p>The <em>merge</em> is like this:</p>

<ol>
<li>Get the two heads (<code>bt1</code> and <code>bt2</code>) out of two heaps (<code>h1</code> and <code>h2</code>).  </li>
<li>If <code>rank bt1 &lt; rank bt2</code>, then <code>bt1</code> leaves first and continue to merge <code>the rest of h1</code> and <code>h2</code>.  </li>
<li>If <code>rank bt1 &gt; rank bt2</code>, then <code>bt2</code> leaves first and continue to merge <code>h1</code> and <code>the rest of h2</code>.  </li>
<li>If <code>rank bt1 = rank bt2</code>, then <code>link bt1 bt2</code>, add the new tree to <code>the rest of h1</code> and merge the new <code>h1</code> and <code>the rest of h2</code>.</li>
</ol>

<p>I will skip the digram and directly present the code here:</p>

<pre><code class="ocaml">let rec merge h1 h2 =  
  match h1, h2 with
  | h, [] | [], h -&gt; h
  | (Node (_, _, r1) as bt1)::tl1, (Node (_, _, r2) as bt2)::tl2 -&gt;
    if r1 &lt; r2 then bt1::merge tl1 h2
    else if r1 &gt; r2 then bt2::merge h1 tl2
    else merge (link bt1 bt2::tl1) tl2

(* a better and simpler version of insert *)
let insert' k h = merge [singleton_tree k] h  
</code></pre>

<p>The time complexity is <code>O(logn)</code>.</p>

<h2>get_min</h2>

<p>We just need to scan all roots and get the min key.</p>

<pre><code class="ocaml">let get_min = function  
  | [] -&gt; failwith &quot;Empty heap&quot;
  | Node (k1, _, _)::tl -&gt;
    List.fold_left (fun acc (Node (k, _, _)) -&gt; min acc k) k1 tl
</code></pre>

<blockquote>
  <p>For achieve <code>O(1)</code>, we can attach a <code>minimum</code> property to the heap's type. It will always record the min and can be returned immediately if requested. However, we need to update this property when <em>insert</em>, <em>merge</em> and <em>delete_min</em>. Like every other book does, this modification is left to the readers as an exercise.</p>
</blockquote>

<h2>delete_min</h2>

<p><em>delete_min</em> appears as a little bit troublesome but actually very neat. </p>

<ol>
<li>We need to locate the binomial tree with <em>min</em>.  </li>
<li>Then we need to merge <code>the trees on its left</code> and <code>the trees on its right</code> to get a new list.  </li>
<li>It is not done yet as we need to deal with the <em>min</em> binomial tree.  </li>
<li>We are lucky that <strong>a binomial tree's child list is a heap indeed</strong>. So we just need to merge <code>the child list</code> with the new list from point 2.</li>
</ol>

<pre><code class="ocaml">let key (Node (k, _, _)) = k  
let child_list (Node (_, c, _)) = c

let split_by_min h =  
  let rec aux pre (a, m, b) = function
    | [] -&gt; List.rev a, m, b
    | x::tl -&gt;
      if key x &lt; key m then aux (x::pre) (pre, x, tl) tl
      else aux (x::pre) (a, m, b) tl
  in
  match h with 
    | [] -&gt; failwith &quot;Empty heap&quot;
    | bt::tl -&gt; aux [bt] ([], bt, []) tl

let delete_min h =  
  let a, m, b = split_by_min h in
  merge (merge a b) (child_list m |&gt; List.rev)
</code></pre>

<h1>Binomial Heap vs Leftist Tree</h1>

<pre>
|               | get_min                                 | insert         | merge   | delete_min |
|---------------|-----------------------------------------|----------------|---------|------------|
| Leftist tree  | O(1)                                    | O(logn)        | O(logn) | O(logn)    |
| Binomial heap | O(logn), but can be improved to be O(1) | Amortised O(1) | O(logn) | O(logn)    |

</pre>

<hr/>

<p><strong>[1]</strong> Binomial Heap is also introduced in <a href="http://www.amazon.co.uk/Purely-Functional-Structures-Chris-Okasaki/dp/0521663504/ref=sr_1_1?ie=UTF8&amp;qid=1426283477&amp;sr=8-1&amp;keywords=functional%20data%20structure">Purely Functional Data Structures</a>.</p>

---
title: Height, Depth and Level of a Tree
description: 'This is a post on the three important properties of trees: height, depth
  and level, together with edge and path, presented in a visual way....'
url: http://typeocaml.com/2014/11/26/height-depth-and-level-of-a-tree/
date: 2014-11-26T22:43:46-00:00
preview_image:
featured:
authors:
- typeocaml
---

<p><img src="http://typeocaml.com/content/images/2014/11/groot_tree2.jpg#hero" alt="tree"/></p>

<p>This is a post on the three important properties of trees: <em>height</em>, <em>depth</em> and <em>level</em>, together with <em>edge</em> and <em>path</em>. I bet that most people already know what they are and <a href="http://en.wikipedia.org/wiki/Tree_(data_structure)">tree (data structure) on wiki</a> also explains them briefly. </p>

<p>The reason why I still decided to produce such a trivial page is that I will later on write a series of articles focusing on <a href="http://en.wikipedia.org/wiki/Binary_search_tree">binary search tree</a> in OCaml. The starters among them will be quite basic and related to these three properties. </p>

<p>In order to be less boring, the properties are presented in a visual way and I try to fulfill details (some might be easily overlooked) as much as possible.</p>

<h1>Edge</h1>

<blockquote>
  <p>Edge &ndash; connection between one node to another. </p>
</blockquote>

<p><img src="http://typeocaml.com/content/images/2014/11/edge-1.jpg#small" alt="edge"/></p>

<p>An example of edge is shown above between <em>A</em> and <em>B</em>. Basically, an edge is a line between two nodes, <strong>or a node and a leaf</strong>. </p>

<h1>Path</h1>

<blockquote>
  <p>Path &ndash; a sequence of nodes and edges connecting a node with a descendant.</p>
</blockquote>

<p><img src="http://typeocaml.com/content/images/2014/11/path-1.jpg#small" alt="path"/></p>

<p>A path starts from a node and ends at another node or a leaf. Please don't look over the following points:</p>

<ol>
<li>When we talk about a path, it includes all nodes and all edges along the path, <em>not just edges</em>.  </li>
<li>The direction of a path is strictly from top to bottom and cannot be changed in middle. In the diagram, we can't really talk about a path from <em>B</em> to <em>F</em> although <em>B</em> is above <em>F</em>. Also there will be no path starting from a leaf or from a child node to a parent node. (<em>[1]</em>)</li>
</ol>

<h1>Height</h1>

<blockquote>
  <p>Height of node &ndash; The height of a node is the number of edges on the longest downward path between that node and a leaf.</p>
</blockquote>

<p>At first, we can see the above wiki definition has a redundant term - <em>downward</em> - inside. As we already know from previous section, path can only be downward. </p>

<p><img src="http://typeocaml.com/content/images/2014/11/height-3.jpg#small" alt="height"/></p>

<p>When looking at height:</p>

<ol>
<li>Every node has height. So <em>B</em> can have height, so does <em>A</em>, <em>C</em> and <em>D</em>.  </li>
<li>Leaf cannot have height as there will be no path starting from a leaf.  </li>
<li>It is the longest path from the node <strong>to a leaf</strong>. So <em>A</em>'s height is the number of edges of the path to <em>E</em>, NOT to <em>G</em>. And its height is 3.</li>
</ol>

<p><strong>The height of the root is 1.</strong></p>

<blockquote>
  <p>Height of tree &ndash;The height of a tree is the number of edges on the longest downward path between the root and a leaf.</p>
</blockquote>

<p>So <strong>the height of a tree is the height of its root</strong>. </p>

<p>Frequently, we may be asked the question: <em>what is the max number of nodes a tree can have if the height of the tree is h?</em>. Of course the answer is $ 2^h-1 $ . When $ h = 1 $ , the number of node inside is 1, which is just the root; also when a tree has just root, the height of the root is 1. Hence, the two inductions match.</p>

<p>How about giving a height of 0? Then it means we don't have any <em>node</em> in the tree; but still we may have <em>leaf</em> inside (note that in this case we may not call it <em>root</em> of the tree as it makes not much sense). This is why in most languages, the type of a tree can be a leaf alone. </p>

<pre><code class="OCaml">type 'a bst =  
  | Leaf 
  | Node of 'a bst * 'a * 'a bst
</code></pre>

<p>Moreover, when we use $2^h-1$ to calculate the max number of nodes, leaves are not taken into account. <em>Leaf</em> is not <em>Node</em>. It carries no key or data,  and acts only like a STOP sign. We need to remember this when we deal with properties of trees.</p>

<h1>Depth</h1>

<blockquote>
  <p>Depth &ndash;The depth of a node is the number of edges from the node to the tree's root node.</p>
</blockquote>

<p><img src="http://typeocaml.com/content/images/2014/11/depth-1.jpg#small" alt="depth"/></p>

<p>We don't care about path any more when depth pops in. We just count how many edges between the targeting node and the root, ignoring directions. For example, <em>D</em>'s depth is 2.</p>

<p>Recall that when talking about height, we actually imply a baseline located at bottom. For depath, the baseline is at top which is root level. That's why we call it depth. </p>

<p>Note that <strong>the depth of the root is 0</strong>.</p>

<h1>Level</h1>

<blockquote>
  <p>Level &ndash; The level of a node is defined by 1 + the number of connections between the node and the root.</p>
</blockquote>

<p><img src="http://typeocaml.com/content/images/2014/11/level.jpg#small" alt="level"/></p>

<p>Simply, <strong>level is depth plus 1.</strong></p>

<p>The important thing to remember is when talking about level, it <strong>starts from 1</strong> and <strong>the level of the root is 1</strong>. We need to be careful about this when solving problems related to level. </p>

<hr/>

<p><strong>[1]</strong> Although point 2 stands, sometimes some problems may talk about paths in an arbitrary way, like <em>the path between B and F</em>. We have to live with that while deep in our hearts remembering the precise definition.</p>

<p><strong>ps.</strong> <a href="http://www.yworks.com/en/products/yfiles/yed/">yEd - Graph Editor</a> has been used to create all diagrams here.</p>

---
title: Balanced binary search trees
description: "The type of \"association tables\" (binary search trees).  type (\u03B1,
  \u03B2) t = | Empty | Node of (\u03B1 , \u03B2) t * \u03B1 * \u03B2 * (\u03B1, \u03B2)
  t * int  There are tw..."
url: http://blog.shaynefletcher.org/2016/08/perfectly-balanced-binary-search-trees.html
date: 2016-08-27T13:18:00-00:00
preview_image:
featured:
authors:
- Shayne Fletcher
---

<p>
The type of &quot;association tables&quot; (binary search trees).
</p><pre class="prettyprint ml">
type (&alpha;, &beta;) t =
| Empty
| Node of (&alpha; , &beta;) t * &alpha; * &beta; * (&alpha;, &beta;) t * int
</pre>
There are two cases : a tree that is empty or, a node consisting of a left sub-tree, a key, the value associated with that key, a right sub-tree and, an integer representing the &quot;height&quot; of the tree (the number of nodes to traverse before reaching the most distant leaf).

<p>The binary search tree invariant will be made to apply in that for any non empty tree $n$, every node in the left sub-tree is ordered less than $n$ and every node in the right sub-tree of $n$ is ordered greater than $n$ (in this program, ordering of keys is performed using the <code>Pervasives.compare</code> function).
</p>
<p>This function, <code>height</code>, given a tree, extracts its height.
</p><pre class="prettyprint ml">
let height : (&alpha;, &beta;) t -&gt; int = function
  | Empty -&gt; 0
  | Node (_, _, _, _, h) -&gt; h
</pre>

<p>The value <code>empty</code>, is a constant, the empty tree.
</p><pre class="prettyprint ml">
let empty : (&alpha;, &beta;) t = Empty
</pre>

<p>
<code>create l x d r</code> creates a new non-empty tree with left sub-tree <code>l</code>, right sub-tree <code>r</code> and the binding of key <code>x</code> to the data <code>d</code>. The height of the tree created is computed from the heights of the two sub-trees.
</p><pre class="prettyprint ml">
let create (l : (&alpha;, &beta;) t) (x : &alpha;) (d : &beta;) (r : (&alpha;, &beta;) t) : (&alpha;, &beta;) t =
  let hl = height l and hr = height r in
  Node (l, x, d, r, (max hl hr) + 1)
</pre>

<p>This next function, <code>balance</code> is where all the action is at. Like the preceding function <code>create</code>, it is a factory function for interior nodes and so takes the same argument list as <code>create</code>. It has an additional duty though in that the tree that it produces takes balancing into consideration.
</p><pre class="prettyprint ml">
let balance (l : (&alpha;, &beta;) t) (x : &alpha;) (d : &beta;) (r : (&alpha;, &beta;) t) : (&alpha;, &beta;) t =
  let hl = height l and hr = height r in
  if hl &gt; hr + 1 then
    match l with
</pre>
In this branch of the program, it has determined that production of a node with the given left and right sub-trees (denoted $l$ and $r$ respectively) would be unbalanced because $h(l) &gt; hr(1) + 1$ (where $h$ denotes the height function).

<p>There are two possible reasons to account for this. They are considered in turn.
</p><pre class="prettyprint ml">
    (*Case 1*)
    | Node (ll, lv, ld, lr, _) when height ll &gt;= height lr -&gt;
      create ll lv ld (create lr x d r)
</pre>
So here, we find that $h(l) &gt; h(r) + 1$, because of the height of the left sub-tree of $l$.
<pre class="prettyprint ml">
    (*Case 2*)
    | Node (ll, lv, ld, Node (lrl, lrv, lrd, lrr, _), _) -&gt;
      create (create ll lv ld lrl) lrv lrd (create lrr x d r)
</pre>
In this case, $h(l) &gt; h(r) + 1$ because of the height of the right sub-tree of $l$.
<pre class="prettyprint ml">
    | _ -&gt; assert false
</pre>
We <code>assert false</code> for all other patterns as we aim to admit by construction no further possibilities.

<p>We now consider the case $h(r) &gt; h(l) + 1$, that is the right sub-tree being &quot;too long&quot;.
</p><pre class="prettyprint ml">
  else if hr &gt; hl + 1 then
    match r with
</pre>

<p>There are two possible reasons.
</p><pre class="prettyprint ml">
    (*Case 3*)
    | Node (rl, rv, rd, rr, _) when height rr &gt;= height rl -&gt;
      create (create l x d rl) rv rd rr
</pre>
Here $h(r) &gt; h(l) + 1$ because of the right sub-tree of $r$.
<pre class="prettyprint ml">
    (*Case 4*)
    | Node (Node (rll, rlv, rld, rlr, _), rv, rd, rr, _) -&gt;
      create (create l x d rll) rlv rld (create rlr rv rd rr)
</pre>
Lastly, $h(r) &gt; h(l) + 1$ because of the left sub-tree of $r$.
<pre class="prettyprint ml">
    | _ -&gt; assert false
</pre>
Again, all other patterns are (if we write this program correctly according to our intentions,) impossible and so, <code>assert false</code> as there are no further possibilities.

<p>In the last case, neither $h(l) &gt; h(r) + 1$ or $h(r) &gt; h(l) + 1$ so no rotation is required.
</p><pre class="prettyprint ml">
  else
    create l x d r
</pre>

<p>
<code>add x data t</code> computes a new tree from <code>t</code> containing a binding of <code>x</code> to <code>data</code>. It resembles standard insertion into a binary search tree except that it propagates rotations through the tree to maintain balance after the insertion.
</p><pre class="prettyprint ml">
let rec add (x : &alpha;) (data : &beta;) : (&alpha;, &beta;) t -&gt; (&alpha;, &beta;) t = function
    | Empty -&gt; Node (Empty, x, data, Empty, 1)
    | Node (l, v, d, r, h) -&gt;
      let c = compare x v in
      if c = 0 then
        Node (l, x, data, r, h)
      else if c &lt; 0 then
        balance (add x data l) v d r
      else 
        balance l v d (add x data r)
</pre>

<p>To implement removal of nodes from a tree, we'll find ourselves needing a function to &quot;merge&quot; two binary searchtrees $l$ and $r$ say where we can assume that all the elements of $l$ are ordered before the elements of $r$.
</p><pre class="prettyprint ml">
let rec merge (l : (&alpha;, &beta;) t) (r : (&alpha;, &beta;) t) : (&alpha;, &beta;) t = 
  match (l, r) with
  | Empty, t -&gt; t
  | t, Empty -&gt; t
  | Node (l1, v1, d1, r1, h1), Node (l2, v2, d2, r2, h2) -&gt;
    balance l1 v1 d1 (balance (merge r1 l2) v2 d2 r2)
</pre>
Again, rotations are propagated through the tree to ensure the result of the merge results in a balanced tree.

<p>With <code>merge</code> available, implementing <code>remove</code> becomes tractable.
</p><pre class="prettyprint ml">
let remove (id : &alpha;) (t : (&alpha;, &beta;) t) : (&alpha;, &beta;) t = 
  let rec remove_rec = function
    | Empty -&gt; Empty
    | Node (l, k, d, r, _) -&gt;
      let c = compare id k in
      if c = 0 then merge l r else
        if c &lt; 0 then balance (remove_rec l) k d r
        else balance l k d (remove_rec r) in
  remove_rec t
</pre>

<p>The remaining algorithms below are &quot;stock&quot; algorithms for binary search trees with no particular consideration of balancing necessary and so we won't dwell on them here.
</p><pre class="prettyprint ml">
let rec find (x : &alpha;) : (&alpha;, &beta;) t -&gt; &beta; = function
  | Empty -&gt;  raise Not_found
  | Node (l, v, d, r, _) -&gt;
    let c = compare x v in
    if c = 0 then d
    else find x (if c &lt; 0 then l else r)

let rec mem (x : &alpha;) : (&alpha;, &beta;) t -&gt; bool = function
  | Empty -&gt; false
  | Node (l, v, d, r, _) -&gt;
    let c = compare x v in
    c = 0 || mem x (if c &lt; 0 then l else r)
    
let rec iter (f : &alpha; -&gt; &beta; -&gt; unit) : (&alpha;, &beta;) t -&gt; unit = function
  | Empty -&gt; ()
  | Node (l, v, d, r, _) -&gt;
    iter f l; f v d; iter f r

let rec map (f : &alpha; -&gt; &beta; -&gt; &gamma;) : (&alpha;, &beta;) t -&gt; (&alpha;, &gamma;) t = function
  | Empty -&gt; Empty
  | Node (l, k, d, r, h) -&gt; 
    Node (map f l, k, f k d, map f r, h)

let rec fold (f : &alpha; -&gt; &beta; -&gt; &gamma; -&gt; &gamma;) (m : (&alpha;, &beta;) t) (acc : &gamma;) : &gamma; =
  match m with
  | Empty -&gt; acc
  | Node (l, k, d, r, _) -&gt; fold f r (f k d (fold f l acc))

open Format

let print 
    (print_key : formatter -&gt; &alpha; -&gt; unit)
    (print_data : formatter -&gt; &beta; -&gt; unit)
    (ppf : formatter)
    (tbl : (&alpha;, &beta;) t) : unit =
  let print_tbl ppf tbl =
    iter (fun k d -&gt; 
           fprintf ppf &quot;@[&lt;2&gt;%a -&gt;@ %a;@]@ &quot; print_key k print_data d)
      tbl in
  fprintf ppf &quot;@[<hv>[[%a]]@]&quot; print_tbl tbl
</hv></pre>
<p>The source code for this post can be found in the file 'ocaml/misc/tbl.ml' in the OCaml source distribution. More information on balanced binary search trees including similar but different implementation techniques and complexity analyses can be found in <a href="https://www.cs.cornell.edu/courses/cs3110/2009sp/lectures/lec11.html">this Cornell lecture</a> and <a href="http://www.cs.cornell.edu/courses/cs3110/2008fa/lectures/lec20.html">this one</a>.
</p>


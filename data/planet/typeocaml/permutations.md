---
title: Permutations
description: This post describes the ways of generating permutations, with 2 common
  approaches , the Johnson Trotter algorithm and streaming. Code is in OCaml....
url: http://typeocaml.com/2015/05/05/permutation/
date: 2015-05-05T19:15:23-00:00
preview_image:
featured:
authors:
- typeocaml
---

<p><img src="http://typeocaml.com/content/images/2015/05/permutation3.jpg#hero" alt="hero"/></p>

<p>In this post, we will talk about producing permuations using OCaml. Generating permutations was actually one of my first self-homeworks when I started to learn OCaml years ago. It can be a good exercise to train our skills on <em>list</em>, <em>recursion</em>, foundamental <em>fold</em>, <em>map</em>, etc, in OCaml. Also it shows the conciseness of the OCaml as a language.</p>

<p>We will first present <strong>2 common approaches</strong> for generating all permutations of a list of elements. </p>

<p>Then we introduce the <a href="http://en.wikipedia.org/wiki/Steinhaus%E2%80%93Johnson%E2%80%93Trotter_algorithm">Johnson Trotter algorithm</a> which enable us to generate one permutation at a time. </p>

<p>Although Johnson Trotter algorithm uses imperative array, it provides us the opportunity to implement a stream (using <a href="http://typeocaml.com/2014/11/09/magic-of-thunk-stream-list/">stream list</a> or built-in <code>Stream</code> module) of permutations, i.e., we generate a permutation only when we need. We will describe that as last.</p>

<h1>The insert-into-all-positions solution</h1>

<p>We can generate permutations using <em>recursion</em> technique. As we descriped in <a href="http://typeocaml.com/2014/12/04/recursion-reloaded/">Recursion Reloaded</a>, let's first assume we already get a function that can produce all permuations. </p>

<p><img src="http://typeocaml.com/content/images/2015/05/permutations_function0.jpg" alt="permutation_function0"/></p>

<p>What exactly <code>f</code> will generate is not our concern for now, but we are sure that given a list (say 3 distinct elements), <code>f</code> will produce a list of permutations (totally 6 in this example). </p>

<p>So now what if our original list has one more new element?</p>

<p><img src="http://typeocaml.com/content/images/2015/05/permutations_function1.jpg" alt="permutation_function1"/></p>

<p>What should we do to combine the new element together with the old list of permutations, in order to generate a new list of permuatations?</p>

<p>Let's first take a look at how to combine the new element with one permutation.</p>

<p><img src="http://typeocaml.com/content/images/2015/05/permutations_function2-1.jpg" alt="permutation_function2"/></p>

<p>A good way, like shown above, is to insert the new element into all possible positions. Easy, right?</p>

<p>So for the new list of permutations, we just insert the new element into all possible positions of all old permutations.</p>

<p><img src="http://typeocaml.com/content/images/2015/05/permutations_function3.jpg" alt="permutation_function3"/></p>

<h2>code</h2>

<p>First let's implement the function that combines an element with a permutation (which is actually a normal list).</p>

<pre><code class="ocaml">(* note that in order to preserve certain order and also show the conciseness of the implementation, no tail-recursive is used *)
let ins_all_positions x l =  
  let rec aux prev acc = function
    | [] -&gt; (prev @ [x]) :: acc |&gt; List.rev
    | hd::tl as l -&gt; aux (prev @ [hd]) ((prev @ [x] @ l) :: acc) tl
  in
  aux [] [] l
</code></pre>

<p>Now the main permutations generator.</p>

<pre><code class="ocaml">let rec permutations = function  
  | [] -&gt; []
  | x::[] -&gt; [[x]] (* we must specify this edge case *)
  | x::xs -&gt; List.fold_left (fun acc p -&gt; acc @ ins_all_positions x p ) [] (permutations xs)
</code></pre>

<p>Here is the <a href="https://gist.github.com/MassD/fa79de3a5ee88c9c5a8e">Gist</a>.</p>

<h1>The fixed-head solution</h1>

<p>There is another way to look at the permutations.</p>

<p><img src="http://typeocaml.com/content/images/2015/05/permutations_function4.jpg" alt="permutation_function4"/></p>

<p>For a list of 3 elements, each element can be the head of all permutations of the rest elements. For example, <em>blue</em> is the head of the permutations of <em>green</em> and <em>yellow</em>.</p>

<p>So what we can do is</p>

<ol>
<li>Get an element out  </li>
<li>Generate all permutations on all other elements  </li>
<li>Stick the element as the head of every permutation  </li>
<li>We repeat all above until we all elements have got their chances to be heads</li>
</ol>

<p><img src="http://typeocaml.com/content/images/2015/05/permutations_function5-1.jpg" alt="permutation_function5"/></p>

<h2>Code</h2>

<p>First we need a function to remove an element from a list.</p>

<pre><code class="ocaml">let rm x l = List.filter ((&lt;&gt;) x) l  
</code></pre>

<p>The <code>rm</code> above is not a must, but it will make the meaning of our following <code>permutations</code> clearer. </p>

<pre><code class="ocaml">let rec permutations = function  
  | [] -&gt; []
  | x::[] -&gt; [[x]]
  | l -&gt; 
    List.fold_left (fun acc x -&gt; acc @ List.map (fun p -&gt; x::p) (permutations (rm x l))) [] l

(* The List.fold_left makes every element have their oppotunities to be a head *)
</code></pre>

<p>Here is the <a href="https://gist.github.com/MassD/22950955c5efa8f8af88">Gist</a></p>

<h1>No tail-recusive?</h1>

<p>So far in all our previous posts, the tail-recusive has always been considered in the codes. However, when we talk about permutations, tail-recusive has been ignored. There are two reasons:</p>

<p>At first, it is not possible to make recusion tail-recusive everywhere for the two solutions. The best we can do is just make certain parts tail-recusive.</p>

<p>Secondly, permutation generation is a <em>P</em> problem and it is slow. If one tries to generate all permutations at once for a huge list, it would not be that feasible. Thus, when talking about permutations here, it is assumed that no long list would be given as an argument; hence, we assume no stackoverflow would ever occur.</p>

<p>In addition, ignoring tail-recusive makes the code cleaner.</p>

<h1>What if the list is huge?</h1>

<p>If a list is huge indeed and we have to somehow use possibly all its permutations, then we can think of making the permutations as a <em>stream</em>. </p>

<p>Each time we just generate one permutation, and then we apply our somewhat <code>use_permuatation</code> function. If we need to continue, then we ask the stream to give us one more permutation. If we get what we want in the middle, then we don't need to generate more permutations and time is saved.</p>

<p>If we still have to go through all the permutations, time-wise the process will still cost us much. However, we are able to avoid putting all permutations in the memory or potentiall stackoverflow.</p>

<p>In order to achieve <em>a stream of permutations</em>, we need <a href="http://en.wikipedia.org/wiki/Steinhaus%E2%80%93Johnson%E2%80%93Trotter_algorithm">Johnson Trotter algorithm</a> and a stream.</p>

<h1>Johnson Trotter algorithm</h1>

<p>The advantage of this algorithm is its ability to generate a new permutation based on the previous one, via simple <code>O(n)</code> operations (the very first permutation is the list itself). This is ideal for our adoption of stream.</p>

<p>The disadvantage, epecially for OCaml, is that it needs an mutable array. Fortunately, we can encapsulate the array in a module or inside a function, without exposing it to the outside world. Thus, certain level of safety will be maintained. </p>

<p>Personally I think this algorithm is very clever. Johnson must have spent quit much time on observing the changes through all permutations and set a group of well defined laws to make the changes happen naturally. </p>

<h2>An assumption - sorted</h2>

<p>The first assumption of this algorithm is that the array of elements are initially sorted in ascending order (<em>[1]</em>). </p>

<p>If in some context we cannot sort the original array, then we can attach additional keys, such as simple integers starting from <code>1</code>, to every element. And carry on the algorithm based on that key.</p>

<p>For example, if we have <code>[|e1; e2; e3; e4|]</code> and we do not want to sort it, then we just put an integer in front of each element like <code>[|(1, e1); (2, e2); (3, e3); (4, e4)|]</code>. All the following process can target on the key, and only when return a permutation, we output the <code>e</code> in the tuple.</p>

<p>For simplicity, we will have an example array <code>[|1; 2; 3; 4|]</code>, which is already sorted.</p>

<p><img src="http://typeocaml.com/content/images/2015/05/johnson1.jpg" alt="1"/></p>

<h2>Direction: L or R</h2>

<p>The key idea behind the algorithm is to move an element (or say, switch two elements) at a time and after the switching, we get our new permutation.</p>

<p>For any element, it might be able to move either <em>Left</em> or <em>Right</em>, i.e., switch position with either <em>Left</em> neighbour or <em>Right</em> one. </p>

<blockquote>
  <p>So we will attach a <em>direction</em> - <em>L</em> (initially) or <em>R</em> - to every element.</p>
</blockquote>

<p><img src="http://typeocaml.com/content/images/2015/05/johnson2.jpg" alt="johnson2"/></p>

<h2>Movable</h2>

<p>Even if an element has a direction, it might be able to move towards that direction. Only if the element has a <strong>smaller</strong> neighbour on that direction, it can move.</p>

<p>For example,</p>

<p><img src="http://typeocaml.com/content/images/2015/05/johnson3_0-1.jpg" alt="jonhson3_0"/></p>

<p><code>4</code> and <code>2</code> are movable, because the neighbours on their <em>left</em> are smaller.</p>

<p><code>3</code> is not movable, because <code>4</code> is not smaller.</p>

<p><code>1</code> is not movable, because it doesn't have any neighbour on its <em>left</em>.</p>

<h2>Scan for largest movable element</h2>

<p>As we described before, the algorithm makes a new permutation by moving an element, i.e., switch an element with the neighbour on its <em>direction</em>.</p>

<p>What if there are more than one elmeent is movable? We will choose the largest one.</p>

<blockquote>
  <p>Each time, when we are about to generate a new permutation, we simply scan the array, find the largest movable element, and move it.</p>
  
  <p>If we cannot find such an element, it means we have generated all possible permutations and we can end now.</p>
</blockquote>

<p>For example, </p>

<p><img src="http://typeocaml.com/content/images/2015/05/johnson4-2.jpg" alt="johnson4"/></p>

<p>Although in the above case, <code>2</code>, <code>3</code> and <code>4</code> are all movable, we will move only <code>4</code> since it is largest.</p>

<p>The whole process will end if no element is movable.</p>

<p><img src="http://typeocaml.com/content/images/2015/05/johnson4_0.jpg" alt="johnson4_0"/></p>

<p>Note that <strong>this scan is before the movement</strong>.</p>

<h2>Scan to flip directions of larger element</h2>

<p><strong>After we make a movement</strong>, immediately we need to scan the whole array and flip the directions of elements that are larger than the element which is just moved.</p>

<p><img src="http://typeocaml.com/content/images/2015/05/johnson5.jpg" alt="johnson5"/></p>

<h2>A complete example</h2>

<p><img src="http://typeocaml.com/content/images/2015/05/johnson6.jpg" alt="johnson6"/></p>

<h2>Code</h2>

<p><strong>Direction</strong></p>

<pre><code class="ocaml">type direction = L | R

let attach_direction a = Array.map (fun x -&gt; (x, L)) a
</code></pre>

<p><strong>Move</strong></p>

<pre><code class="ocaml">let swap a i j = let tmp = a.(j) in a.(j) &lt;- a.(i); a.(i) &lt;- tmp

let is_movable a i =  
  let x,d = a.(i) in
  match d with
    | L -&gt; if i &gt; 0 &amp;&amp; x &gt; (fst a.(i-1)) then true else false
    | R -&gt; if i &lt; Array.length a - 1 &amp;&amp; x &gt; (fst a.(i+1)) then true else false

let move a i =  
  let x,d = a.(i) in
  if is_movable a i then 
    match d with
      | L -&gt; swap a i (i-1)
      | R -&gt; swap a i (i+1)
  else
    failwith &quot;not movable&quot;
</code></pre>

<p><strong>Scan for the larget movable element</strong></p>

<pre><code class="ocaml">let scan_movable_largest a =  
  let rec aux acc i =
    if i &gt;= Array.length a then acc
    else if not (is_movable a i) then aux acc (i+1)
    else
      let x,_ = a.(i) in
      match acc with
        | None -&gt; aux (Some i) (i+1)
        | Some j -&gt; aux (if x &lt; fst(a.(j)) then acc else Some i) (i+1)
  in
  aux None 0
</code></pre>

<p><strong>Scan to flip larger</strong></p>

<pre><code class="ocaml">let flip = function | L -&gt; R | R -&gt; L

let scan_flip_larger x a =  
  Array.iteri (fun i (y, d) -&gt; if y &gt; x then a.(i) &lt;- y,flip d) a
</code></pre>

<p><strong>Permutations generator</strong></p>

<pre><code class="ocaml">let permutations_generator l =  
  let a = Array.of_list l |&gt; attach_direction in
  let r = ref (Some l) in
  let next () = 
    let p = !r in
    (match scan_movable_largest a with (* find largest movable *)
      | None -&gt; r := None (* no more permutations *)
      | Some i -&gt; 
        let x, _ = a.(i) in (
        move a i; (* move *)
        scan_flip_larger x a; (* after move, scan to flip *)
        r := Some (Array.map fst a |&gt; Array.to_list)));
    p
  in
  next

(* an example of permutation generator of [1;2;3].
   Every time called, generator() will give either next permutation or None*)
let generator = permutations_generator [1;2;3]

&gt; generator();;
&gt; Some [1; 2; 3]

&gt; generator();;
&gt; Some [1; 3; 2]

&gt; generator();;
&gt; Some [3; 1; 2]

&gt; generator();;
&gt; Some [3; 2; 1]

&gt; generator();;
&gt; Some [2; 3; 1]

&gt; generator();;
&gt; Some [2; 1; 3]

&gt; generator();;
&gt; None
</code></pre>

<p>Here is the <a href="https://gist.github.com/MassD/be3f6571967662b9d3c6">Gist</a>.</p>

<h2>The imperative part inside</h2>

<p>Like said before, although we use array and <code>ref</code> for the impelmentation, we can hide them from the interface <code>permutations_generator</code>. This makes our code less fragile, which is good. However, for OCaml code having imperative parts, we should not forget to put <code>Mutex</code> locks for thread safety. </p>

<h1>A stream of permutations</h1>

<p>Now it is fairly easy to produce a stream of permutations via built-in <a href="http://caml.inria.fr/pub/docs/manual-ocaml/libref/Stream.html">Stream</a>.</p>

<pre><code class="ocaml">let stream_of_permutations l =  
  let generator = permutations_generator l in
  Stream.from (fun _ -&gt; generator())
</code></pre>

<hr/>

<p><strong>[1]</strong>. The array can be descending order, which means later on we need to put all initial directions as <em>R</em>.</p>

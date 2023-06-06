---
title: Towers of Hanoi
description: Towers of Hanoi          The "towers of Hanoi" problem is stated like
  this. There are three pegs labelled a , b  and c . On pe...
url: http://blog.shaynefletcher.org/2017/11/towers-of-hanoi.html
date: 2017-11-11T14:32:00-00:00
preview_image: https://4.bp.blogspot.com/-uIdWt5l_kzY/WgcJ2KR3ScI/AAAAAAAABxw/ZOp900ZzLNQd2Zs5wxAZQHStnjWVK1hQgCLcBGAs/w1200-h630-p-k-no-nu/tower_of_hanoi_fig1_600.jpg
featured:
authors:
- Shayne Fletcher
---


<html>
  <head>
    
    <title>Towers of Hanoi</title>
  </head>
  <body>
<div class="separator" style="clear: both; text-align: center;"><a href="https://4.bp.blogspot.com/-uIdWt5l_kzY/WgcJ2KR3ScI/AAAAAAAABxw/ZOp900ZzLNQd2Zs5wxAZQHStnjWVK1hQgCLcBGAs/s1600/tower_of_hanoi_fig1_600.jpg" imageanchor="1" style="margin-left: 1em; margin-right: 1em;"><img src="https://4.bp.blogspot.com/-uIdWt5l_kzY/WgcJ2KR3ScI/AAAAAAAABxw/ZOp900ZzLNQd2Zs5wxAZQHStnjWVK1hQgCLcBGAs/s320/tower_of_hanoi_fig1_600.jpg" border="0" width="320" height="159" data-original-width="600" data-original-height="298"/></a></div>
<p>
The &quot;towers of Hanoi&quot; problem is stated like this. There are three
pegs labelled <i>a</i>, <i>b</i> and <i>c</i>. On peg <i>a</i> there
is a stack of <i>n</i> disks of increasing size, the largest at the
bottom, each with a hole in the middle to accomodate the peg. The
problem is to transfer the stack of disks to peg <i>c</i>, one disk at
a time, in such a way as to ensure that no disk is ever placed on top
of a smaller disk.
</p>
<p>The problem is amenable to a divide and conquer strategy : &quot;Move
the top <i>n - 1</i> disks from peg <i>a</i> to peg <i>b</i>, move the
remaining largest disk from peg <i>a</i> to peg <i>c</i> then, move
the <i>n - 1</i> disks on peg <i>b</i> to peg <i>c</i>.&quot;
</p>
<p>
</p><pre><code class="code"><span class="keyword">let</span> <span class="keyword">rec</span> towers n from to_ spare =
  <span class="keyword">if</span> n &gt; 0 <span class="keyword">then</span>
    <span class="keyword">begin</span>
      towers (n - 1) from spare to_;
      <span class="constructor">Printf</span>.printf  <span class="string">
               &quot;Move the top disk from peg %c to peg %c\n&quot;</span> from to_;
      towers (n - 1) spare to_ from
    <span class="keyword">end</span>
<span class="keyword">else</span>
  ()
;;
</code></pre>
For example, the
invocation <code class="code"><span class="keyword">let</span> () =
towers
3 <span class="string">'a'</span> <span class="string">'c'</span> <span class="string">'b'</span></code>
will generate the recipie
<pre>Move the top disk from peg a to peg c
Move the top disk from peg a to peg b
Move the top disk from peg c to peg b
Move the top disk from peg a to peg c
Move the top disk from peg b to peg a
Move the top disk from peg b to peg c
Move the top disk from peg a to peg c
</pre>

<p>Let <i>T(n)</i> be the time complexity of <code>towers (x, y,
z)</code>, when the characteristic operation is the moving of a disk
from one peg to another. The time complexity of <code>towers(n - 1, x,
y z)</code> is <i>T(n - 1)</i> by definition and no further
investigation is needed. <i>T(0) = 0</i> because the test <code>n &gt;
0</code> fails and no disks are moved. For larger <code>n</code>, the
expression <code>towers (n - 1, from, spare, to_)</code> is evaluated
with cost <i>T(n - 1)</i> followed by <code><span class="constructor">Printf</span>.printf  <span class="string">&quot;Move the top disk from peg %c to peg %c\n&quot;</span> from to_
</code> with cost <i>1</i> and finally, <code>towers(n - 1, spare,
to_, from)</code> again with cost <i>T(n - 1)</i>.
</p>
<p>
Summing these contributions gives the recurrence relation <i>T(n) =
2T(n - 1) + 1</i> where <i>T(0) = 0</i>.
</p>

<p>Repeated substituition can be used to arrive at a closed form
for <i>T(n)</i>, since, <i>T(n) = 2T(n - 1) + 1 = 2[2T(n - 2) + 1] + 1
= 2[2[2T(n - 3) +1] + 1] + 1 = 2<sup>3</sup>T(n - 3) + 2<sup>2</sup> +
2<sup>1</sup> + 2<sup>0</sup></i> (provided <i>n &ge;</i> 3),
expanding the brackets in a way that elucidates the emerging
pattern. If this substitution is repeated <i>i</i> times then clearly
the result is <i>T(n) = 2<sup>i</sup>T(n - i) + 2<sup>i - 1</sup> +
2<sup>i - 2</sup> + &middot;&middot;&middot; + 2<sup>0</sup></i> (<i>n
&ge; i</i>). The largest possible value <i>i</i> can take is <i>n</i>
and if <i>i = n</i> then <i>T(n - i) = T(0) = 0</i> and so we arrive
at <i>T(n) = 2<sup>n</sup>0 + 2<sup>n - 1</sup> +
&middot;&middot;&middot; + 2<sup>0</sup></i>. This is the sum of a
geometric series with the well known solution <i>2<sup>n</sup> - 1</i>
(use induction to establish that last result or more directly, just
compute <i>2T(n) - T(n)</i>). And so, the time complexity (the number
of disk moves needed) for <i>n</i> disks is <i>T(n) = 2<sup>n</sup> -
1</i>.
</p>
    <hr/>
   <p>
     References:<br/>
     <cite>Algorithms and Data Structures Design, Correctness, Analysis</cite> by Jeffrey Kingston, 2nd ed. 1998
   </p>
  </body>
</html>


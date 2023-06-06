---
title: Transpose
description: Transpose               If we are to represent a row of a matrix as a
  list of numbers,     then a matrix can naturally be re...
url: http://blog.shaynefletcher.org/2017/08/transpose.html
date: 2017-08-12T19:38:00-00:00
preview_image:
featured:
authors:
- Shayne Fletcher
---


<html>
  <head>
  
  <meta content="text/html; charset=iso-8859-1" http-equiv="Content-Type"/>
  
  <title>Transpose</title>
  </head>
  <body>
  <p>
    If we are to represent a row of a matrix as a list of numbers,
    then a matrix can naturally be represented as a list of lists of
    numbers.
  </p>
  <p>The transpose of a matrix $\mathbf{A}$ is a new matrix denoted
    $\mathbf{A^{T}}$. The traditional mathematical definition of
    $\mathbf{A^{T}}$ is expressed as saying the $i$ th row, $j$ th
    column element of $\mathbf{A^{T}}$ is the $j$ th row, $i$ th
    column element of $\mathbf{A}$:
    </p><div align="center">
    $\left[\mathbf{A}\right]_{ij} = \left[\mathbf{A^{T}}\right]_{ji}$.
    </div>
  
  <p>
    As definitions go, this isn't terribly helpful in
    explaining <em>how</em> to compute a transpose. A better
    equivalent definition for the functional programmer is : the
    matrix obtained by writing the columns of $\mathbf{A}$ as the
    rows of $\mathbf{A^{T}}$.
  </p>
  <p>
    An elegant program for computing a transpose follows from a
    direct translation of that last definition.
</p><pre><code class="code"><span class="keyword">let</span> <span class="keyword">rec</span> transpose (ls : <span class="keywordsign">'</span>a list list) : <span class="keywordsign">'</span>a list list =
  <span class="keyword">match</span> ls <span class="keyword">with</span>
  <span class="keywordsign">|</span> [] <span class="keywordsign">|</span> [] :: _ <span class="keywordsign">-&gt;</span> []
  <span class="keywordsign">|</span> ls <span class="keywordsign">-&gt;</span> <span class="constructor">List</span>.map (<span class="constructor">List</span>.hd) ls :: transpose (<span class="constructor">List</span>.map (<span class="constructor">List</span>.tl) ls)
</code></pre>
  
  <p>
  It is not at all hard to understand how the program works when
  you've seen an example:
  </p><pre><code class="code">transpose [[1; 2]; [3; 4;]; [5; 6]]
  = [1; 3; 5] :: transpose [[2]; [4;]; [6]]
  = [1; 3; 5] :: [2; 4; 6] :: transpose [[]; []; []]
  = [1; 3; 5] :: [2; 4; 6] :: []
  = [[1; 3; 5]; [2; 4; 6]]</code></pre>
  
  <p>
    Being as pretty as it is, one is inclined to leave things be but,
    as a practical matter it should be rephrased to be tail-recursive.
</p><pre><code class="code"><span class="keyword">let</span> <span class="keyword">rec</span> transpose (ls : <span class="keywordsign">'</span>a list list) : <span class="keywordsign">'</span>a list list  =
  <span class="keyword">let</span> <span class="keyword">rec</span> transpose_rec acc = <span class="keyword">function</span>
  <span class="keywordsign">|</span> [] <span class="keywordsign">|</span> [] :: _ <span class="keywordsign">-&gt;</span> <span class="constructor">List</span>.rev acc
  <span class="keywordsign">|</span> ls <span class="keywordsign">-&gt;</span> transpose_rec (<span class="constructor">List</span>.map (<span class="constructor">List</span>.hd) ls :: acc) (<span class="constructor">List</span>.map (<span class="constructor">List</span>.tl) ls)
  <span class="keyword">in</span> transpose_rec [] ls
</code></pre>   
  
  <hr/>
  <p>
    References:<br/>
    &quot;An Introduction to Functional Programming Systems Using Haskell&quot; -- Davie A J T., 1992
  </p>
  </body>
</html>


---
title: How to render trees like the Unix tree command
description: How to render trees like Unix 'tree'            The Unix tree  utility
  produces a pretty rendering of a filesystem. Implementi...
url: http://blog.shaynefletcher.org/2017/10/how-to-render-trees-like-unix-tree.html
date: 2017-10-14T19:20:00-00:00
preview_image:
featured:
authors:
- Shayne Fletcher
---


<html>
  <head>
    
    <title>How to render trees like Unix 'tree'</title>
  </head>
  <body>
    <p>The Unix <a href="https://en.wikipedia.org/wiki/Tree_(Unix)"><code>tree</code></a> utility produces a pretty rendering of a filesystem. Implementing an algorithm to produce output like <code>tree</code> is a little harder than one might expect! This short example program illustrates one way of doing it.
</p><pre><code class="code"><span class="comment">(* A type of non-empty trees of strings. *)</span>
<span class="keyword">type</span> tree = [
  <span class="keywordsign">|</span><span class="keywordsign">`</span><span class="constructor">Node</span> <span class="keyword">of</span> string * tree list
]
;;

<span class="comment">(* [print_tree tree] prints a rendering of [tree]. *)</span>
<span class="keyword">let</span> <span class="keyword">rec</span> print_tree
          ?(pad : (string * string)= (<span class="string">&quot;&quot;</span>, <span class="string">&quot;&quot;</span>))
          (tree : tree) : unit =
  <span class="keyword">let</span> pd, pc = pad <span class="keyword">in</span>
  <span class="keyword">match</span> tree <span class="keyword">with</span>
  <span class="keywordsign">|</span> <span class="keywordsign">`</span><span class="constructor">Node</span> (tag, cs) <span class="keywordsign">-&gt;</span>
     <span class="constructor">Printf</span>.printf <span class="string">&quot;%s%s\n&quot;</span> pd tag;
     <span class="keyword">let</span> n = <span class="constructor">List</span>.length cs - 1 <span class="keyword">in</span>
     <span class="constructor">List</span>.iteri (
         <span class="keyword">fun</span> i c <span class="keywordsign">-&gt;</span>
         <span class="keyword">let</span> pad =
           (pc ^ (<span class="keyword">if</span> i = n <span class="keyword">then</span> <span class="string">&quot;`-- &quot;</span> <span class="keyword">else</span> <span class="string">&quot;|-- &quot;</span>),
            pc ^ (<span class="keyword">if</span> i = n <span class="keyword">then</span> <span class="string">&quot;    &quot;</span> <span class="keyword">else</span> <span class="string">&quot;|   &quot;</span>)) <span class="keyword">in</span>
         print_tree ~pad c
       ) cs
;;

<span class="comment">(* An example tree. *)</span>
<span class="keyword">let</span> tree =
  <span class="keywordsign">`</span><span class="constructor">Node</span> (<span class="string">&quot;.&quot;</span>
        , [
            <span class="keywordsign">`</span><span class="constructor">Node</span> (<span class="string">&quot;S&quot;</span>, [
                      <span class="keywordsign">`</span><span class="constructor">Node</span> (<span class="string">&quot;T&quot;</span>, [
                                <span class="keywordsign">`</span><span class="constructor">Node</span> (<span class="string">&quot;U&quot;</span>, [])]);
                      <span class="keywordsign">`</span><span class="constructor">Node</span> (<span class="string">&quot;V&quot;</span>, [])])
          ;  <span class="keywordsign">`</span><span class="constructor">Node</span> (<span class="string">&quot;W&quot;</span>, [])
          ])
;;

<span class="comment">(* Print the example tree. *)</span>
<span class="keyword">let</span> () =  print_tree tree
;;
</code></pre>    
    
    <p>The output of the above looks like this:
      </p><pre>.
|-- S
|   |-- T
|   |   `-- U
|   `-- V
`-- W</pre>
    
    <hr/>
  </body>
</html>


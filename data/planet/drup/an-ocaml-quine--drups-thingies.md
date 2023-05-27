---
title: An OCaml quine | Drup's thingies
description: (fun x -> Printf.printf "%s %S" x x) "(fun x -> Printf.printf \"%s %S\"
  x x)"
url: https://drup.github.io/2018/05/30/quine/
date: 2018-05-30T00:00:00-00:00
preview_image:
featured:
authors:
- drup
---


        
        
        
        <div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="p">(</span><span class="k">fun</span> <span class="n">x</span> <span class="o">-&gt;</span> <span class="nn">Printf</span><span class="p">.</span><span class="n">printf</span> <span class="s2">&quot;%s %S&quot;</span> <span class="n">x</span> <span class="n">x</span><span class="p">)</span> <span class="s2">&quot;(fun x -&gt; Printf.printf </span><span class="se">\&quot;</span><span class="s2">%s %S</span><span class="se">\&quot;</span><span class="s2"> x x)&quot;</span>
</code></pre></div></div>


        
        

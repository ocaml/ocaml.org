---
title: Neovim, OCaml Interfaces, Tree-Sitter and LSP
description: Can we all agree that witnessing syntax highlighting being absolutely
  off is probably the most annoying thing that can happen to anybody?
url: https://soap.coffee/~lthms/posts/NeovimOCamlTreeSitterAndLSP.html
date: 2023-05-01T00:00:00-00:00
preview_image: https://soap.coffee/~lthms/img/thinking.png
authors:
- "Thomas Letan\u2019s Blog"
source:
---


        
        <h1>Neovim, OCaml Interfaces, Tree-Sitter and LSP</h1><div><span class="icon"><svg><use href="/~lthms/img/icons.svg#tag"></use></svg></span>&nbsp;<a href="https://soap.coffee/~lthms/tags/ocaml.html" marked="" class="tag">ocaml</a> <span class="icon"><svg><use href="/~lthms/img/icons.svg#tag"></use></svg></span>&nbsp;<a href="https://soap.coffee/~lthms/tags/neovim.html" marked="" class="tag">neovim</a> </div>
<p>Can we all agree that witnessing syntax highlighting being absolutely off is
probably the most annoying thing that can happen to anybody?</p>
<p>I mean, just look at this horror.</p>
<p></p><figure><img src="https://soap.coffee/~lthms/img/wrong-highlighting.png"><figcaption><p>Syntax highlighting being absolutely wrong.</p></figcaption></figure><p></p>
<p>What you are looking at is the result of trying to enable <code class="hljs">tree-sitter</code> for
OCaml hacking and calling it a day. In a nutshell, OCaml <code class="hljs">mli</code> files are
quickly turning into a random mess of nonsensical colors, and I didn’t know
why. I tried to blame
<a href="https://github.com/tree-sitter/tree-sitter-ocaml/issues/72" marked=""><code class="hljs">tree-sitter-ocaml</code>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a>,
but, of course I was wrong.</p>
<p>The issue is subtle, and to be honest, I don’t know if I totally grasp it. But
from my rough understanding, it breaks down as follows.</p>
<ul>
<li><code class="hljs">tree-sitter-ocaml</code> defines two grammars: <code class="hljs">ocaml</code> for the <code class="hljs">ml</code> files, and
<code class="hljs">ocaml_interface</code> (but <code class="hljs">ocamlinterface</code> also works) for the <code class="hljs">mli</code> files</li>
<li>By default, neovim uses the filetype <code class="hljs">ocaml</code> for <code class="hljs">mli</code> files, so the incorrect
parser is being used for syntax highlighting. This explains the root issue</li>
<li>Bonus: <code class="hljs">ocamllsp</code> does not recognize the <code class="hljs">ocamlinterface</code> filetype by
default (but somehow use the <code class="hljs">ocaml.interface</code> id for <code class="hljs">mli</code> files…<label for="fn1" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-right sidenote note"><span class="footnote-p">There is probably something to be done here. </span>
</span>).</li>
</ul>
<p>So, in order to have both <code class="hljs">tree-sitter</code> and <code class="hljs">ocamllsp</code> working at the same
time, I had to tweak my configuration a little bit.</p>
<pre><code class="hljs language-lua">lspconfig.ocamllsp.setup({
  filetypes = vim.list_extend(
    <span class="hljs-built_in">require</span>(<span class="hljs-string">'lspconfig.server_configurations.ocamllsp'</span>)
      .default_config
      .filetypes,
    { <span class="hljs-string">'ocamlinterface'</span> }
  ),
})

vim.cmd(<span class="hljs-string">[[au! BufNewFile,BufRead *.mli setfiletype ocamlinterface]]</span>)
</code></pre>
<p>And now, I am blessed with a consistent syntax highlighting for my <code class="hljs">mli</code> files.</p>
<p></p><figure><img src="https://soap.coffee/~lthms/img/good-highlighting.png"><figcaption><p>Syntax highlighting being absolutely right.</p></figcaption></figure><p></p>
        
      

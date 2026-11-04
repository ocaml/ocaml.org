---
title: Tree-sitting Emacs
description: Getting [`tree-sitter`](https://www.emacswiki.org/emacs/Tree-sitter)
  going before turning on [`eglot`](https://www.gnu.org/software/emacs/manual/html_node/eglot/Quick-Start.html)
url: https://mort.io/blog/treesitting-emacs/
date: 2025-10-20T00:00:00-00:00
preview_image:
authors:
- Richard Mortier
source:
ignore:
keywords:
- config
- domain
- eglot
- emacs
- grammars
- nixos
- parser
- tree-sitter
- treesit-auto
- use-package
---

<p>First, some background that it took me longer than I would’ve hoped to piece
together.</p>
<p><a href="https://tree-sitter.github.io/tree-sitter/" rel="external">Tree-sitter</a> is “a parser generator
tool and an incremental parsing library”. What does that mean in pratice? It is
a thing which, when paired with a grammar, parses your source code and enables
syntax highlighting, code folding, and so on. Syntactic manipulations. It comes
with a domain specific language (DSL) for writing grammars and so, happily, many
languages are already supported. It is also, as of Emacs 29, included out of the
box.</p>
<p>On the other hand, <a href="https://www.gnu.org/software/emacs/manual/html_node/eglot/Quick-Start.html" rel="external">Eglot</a>, also included out of the box since Emacs 29,
provides the <a href="https://microsoft.github.io/language-server-protocol/" rel="external">Language Server Protocol (LSP)</a> interaction. This supports
semantic rather than syntactic markup: inline hints, invocation of code
formatters, and so on. More on that next.</p>
<h2><a href="https://mort.io/rss.xml#nixos-packages" class="zola-anchor" aria-label="Anchor link for: nixos-packages">NixOS packages</a></h2>
<p>I am of course also using NixOS, with flakes and Home Manager, so it took a bit
of faffing about to get this all working but I think I got there in the end.
First, the NixOS runes needed to install relevant Emacs packages:</p>
<pre class="giallo z-code"><code data-lang="nix"><span class="giallo-l"><span>programs</span><span class="z-5">.</span><span>emacs</span><span class="z-10"> =</span><span> {</span></span>
<span class="giallo-l"><span class="z-6">  enable</span><span class="z-5"> =</span><span class="z-7"> true</span><span>;</span></span>
<span class="giallo-l"><span class="z-6">  package</span><span class="z-5"> =</span><span> pkgs</span><span class="z-5">.</span><span>emacs-gtk;</span></span>
<span class="giallo-l"><span class="z-6">  extraPackages</span><span class="z-5"> =</span></span>
<span class="giallo-l"><span>    epkgs:</span><span class="z-5"> with</span><span> epkgs; ([</span></span>
<span class="giallo-l"><span class="z-3 z-i">      # ...</span></span>
<span class="giallo-l"><span>      tree-sitter-langs</span></span>
<span class="giallo-l"><span>      (treesit-grammars</span><span class="z-5">.</span><span>with-grammars (p: [</span></span>
<span class="giallo-l"><span>        p</span><span class="z-5">.</span><span>tree-sitter-bash</span></span>
<span class="giallo-l"><span>        p</span><span class="z-5">.</span><span>tree-sitter-dockerfile</span></span>
<span class="giallo-l"><span>        p</span><span class="z-5">.</span><span>tree-sitter-elisp</span></span>
<span class="giallo-l"><span>        p</span><span class="z-5">.</span><span>tree-sitter-markdown</span></span>
<span class="giallo-l"><span>        p</span><span class="z-5">.</span><span>tree-sitter-markdown-inline</span></span>
<span class="giallo-l"><span>        p</span><span class="z-5">.</span><span>tree-sitter-nix</span></span>
<span class="giallo-l"><span>        p</span><span class="z-5">.</span><span>tree-sitter-ocaml</span></span>
<span class="giallo-l"><span>        p</span><span class="z-5">.</span><span>tree-sitter-python</span></span>
<span class="giallo-l"><span>        p</span><span class="z-5">.</span><span>tree-sitter-rust</span></span>
<span class="giallo-l"><span>        p</span><span class="z-5">.</span><span>tree-sitter-toml</span></span>
<span class="giallo-l"><span>        p</span><span class="z-5">.</span><span>tree-sitter-typst</span></span>
<span class="giallo-l"><span>        p</span><span class="z-5">.</span><span>tree-sitter-yaml</span></span>
<span class="giallo-l"><span>      ]))</span></span>
<span class="giallo-l"><span>    ]);</span></span>
<span class="giallo-l"><span>}</span><span class="z-10">;</span></span></code></pre>
<p>You could use the <code>treesit-grammars.with-all-grammars</code> package instead of the
final expression that selects specific grammars, but I found that package did
not include all the grammars I actually wanted, hence doing it by hand. It is
also in principle possible to allow the Emacs <code>treesit-auto</code> package to download
and install grammars on demand. Grammars are first sought in
<code>treesit-extra-load-path</code> – in my case a gnarly and ever evolving Nix path,
currently
<code>/nix/store/4p4rfax61q9z6c5wj7ahnb8hjq8pa11g-emacs-packages-deps/lib/</code>. If they
are not found there, they are next looked for in
<code>${user-emacs-directory}/tree-sitter/</code> with <code>${user-emacs-directory}</code> resolving
in my case to <code>~/.emacs.d</code>. <code>treesit-auto</code> places them in the latter location.</p>
<p>Additionally, the <code>emacs-lsp-booster</code> package claims to speed things up, so why
not:</p>
<pre class="giallo z-code"><code data-lang="nix"><span class="giallo-l"><span>home</span><span class="z-5">.</span><span>packages</span><span class="z-10"> = with</span><span> pkgs</span><span class="z-10">;</span><span> [ emacs-lsp-booster ]</span><span class="z-10">;</span></span></code></pre><h2><a href="https://mort.io/rss.xml#emacs-configuration" class="zola-anchor" aria-label="Anchor link for: emacs-configuration">Emacs configuration</a></h2>
<p>This was a bit fiddly but not too bad in the end. First install packages
comprising the tree-sitter grammars, an auto-installer for missing grammars, and
enabling code folding via tree-sitter:</p>
<pre class="giallo z-code"><code data-lang="emacs-lisp"><span class="giallo-l"><span>(</span><span class="z-1">use-package</span><span> tree-sitter-langs </span><span class="z-3 z-i">;; grammar bundle</span></span>
<span class="giallo-l"><span>  :after tree-sitter</span></span>
<span class="giallo-l"><span>  :custom (global-tree-sitter-mode t))</span></span>
<span class="giallo-l"></span>
<span class="giallo-l"><span>(</span><span class="z-1">use-package</span><span> treesit-auto </span><span class="z-3 z-i">;; auto-install missing grammars</span></span>
<span class="giallo-l"><span>  :after tree-sitter</span></span>
<span class="giallo-l"><span>  :config (global-treesit-auto-mode))</span></span>
<span class="giallo-l"></span>
<span class="giallo-l"><span>(</span><span class="z-1">use-package</span><span> treesit-fold </span><span class="z-3 z-i">;; enable code folding based on tree-sitter</span></span>
<span class="giallo-l"><span>  :vc (:url</span><span class="z-2"> "https://github.com/emacs-tree-sitter/treesit-fold"</span><span>)</span></span>
<span class="giallo-l"><span>  :config (treesit-fold-mode)</span></span>
<span class="giallo-l"><span>  :bind</span></span>
<span class="giallo-l"><span>  ((</span><span class="z-2">"C-`"</span><span class="z-5"> .</span><span> treesit-fold-toggle)</span></span>
<span class="giallo-l"><span>   (</span><span class="z-2">"C-€"</span><span class="z-5"> .</span><span> treesit-fold-close-all)</span><span class="z-3 z-i"> ;; I remap S-` to € using `keyd` so can't use C-S-`</span></span>
<span class="giallo-l"><span>   (</span><span class="z-2">"M-C-€"</span><span class="z-5"> .</span><span> treesit-fold-open-all)))</span></span></code></pre>
<p>Then, configure the <code>-ts-</code> version for each relevant major <code>-mode</code>, e.g., for
Dockerfile and Nix:</p>
<pre class="giallo z-code"><code data-lang="emacs-lisp"><span class="giallo-l"><span>(</span><span class="z-1">use-package</span><span> dockerfile-ts-mode</span></span>
<span class="giallo-l"><span>  :mode</span><span class="z-2"> "\\Dockerfile\\'"</span></span>
<span class="giallo-l"><span>  :config (</span><span class="z-1">add-to-list</span><span class="z-8"> 'major-mode-remap-alist</span><span> '((docker-mode </span><span class="z-5">.</span><span> docker-ts-mode))))</span></span>
<span class="giallo-l"></span>
<span class="giallo-l"><span>(</span><span class="z-1">use-package</span><span> nix-ts-mode</span></span>
<span class="giallo-l"><span>  :mode</span><span class="z-2"> "\\.nix\\'"</span></span>
<span class="giallo-l"><span>  :config (</span><span class="z-1">add-to-list</span><span class="z-8"> 'major-mode-remap-alist</span><span> '((nix-mode </span><span class="z-5">.</span><span> nix-ts-mode))))</span></span></code></pre>
<p>…and so on. The examples above do two things: set the file glob pattern to
which the major mode will apply, and remap the “default” major mode
<code>LANGUAGE-mode</code> to the new tree-sitter major mode, <code>LANGUAGE-ts-mode</code>.</p>
<p><a href="https://microsoft.github.io/language-server-protocol/" rel="external">LSP</a> support via <a href="https://www.gnu.org/software/emacs/manual/html_node/eglot/Quick-Start.html" rel="external">Eglot</a> then requires installing any necessary language servers
and configuring them. More on that next.</p>

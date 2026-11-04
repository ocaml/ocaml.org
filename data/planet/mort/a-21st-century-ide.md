---
title: A 21st Century IDE
description: Merlin, Tuareg and <code>ocp-indent</code>
url: https://mort.io/blog/21st-century-ide/
date: 2013-10-13T00:00:00-00:00
preview_image:
authors:
- Richard Mortier
source:
ignore:
keywords:
- concat
- merlin
- merlin-mode
- ocp-indent
- opam
- setq
- shell-command-to-string
- substring
- tuareg-mode
- var
---

<p>I finally decided to sit down and get the shiny new <a href="http://kiwi.iuwt.fr/~asmanur/blog/merlin/" rel="external">merlin</a> mode for OCaml
working with my emacs configuration. Basically, really rather simple in the end
although (in the usual fashion!) I did end up spending considerable time
tweaking various other customisations…</p>
<p>Most of the information below is based on the following sources:</p>
<ul>
<li><a href="http://github.com/def-lkb/merlin#emacs-interface" rel="external">http://github.com/def-lkb/merlin#emacs-interface</a></li>
<li><a href="http://zheng.li/buzzlogs-ocaml/2013/08/23/irc.html" rel="external">http://zheng.li/buzzlogs-ocaml/2013/08/23/irc.html</a></li>
<li><a href="http://www.ocamlpro.com/blog/2013/03/18/monthly-03.html" rel="external">http://www.ocamlpro.com/blog/2013/03/18/monthly-03.html</a></li>
</ul>
<p>Before we begin, install <code>merlin</code>:</p>
<pre class="giallo z-code"><code data-lang="plain"><span class="giallo-l"><span>$ opam install merlin</span></span></code></pre>
<p>The complete <a href="https://github.com/mor1/rc-files/commit/4a2b0be59081d6df0640af39b48c75c20443c8dc" rel="external">commit</a> change is in my <a href="http://github.com/mor1" rel="external">github</a> account (combined with a
large cleanup of various other aborted OCaml configurations). Breaking it down a
bit, first setup some paths: where to find <code>ocp-indent</code>, <code>merlin.el</code> for
<code>merlin-mode</code>, and the <code>ocamlmerlin</code> command itself. Note that this relies on
the current state of <code>opam</code>, so when you start <code>emacs</code> be sure to have selected
the <code>opam</code> compiler-switch that you installed the <code>merlin</code> package into, above.</p>
<pre class="giallo z-code"><code data-lang="emacs-lisp"><span class="giallo-l"><span class="z-3 z-i">;; ocp-indent</span></span>
<span class="giallo-l"><span>(</span><span class="z-1">load-file</span><span> (</span><span class="z-1">concat</span></span>
<span class="giallo-l"><span>            (</span><span class="z-1">substring</span><span> (</span><span class="z-1">shell-command-to-string</span><span class="z-2"> "opam config var prefix"</span><span>)</span><span class="z-9"> 0 -1</span><span>)</span></span>
<span class="giallo-l"><span class="z-2">            "/share/typerex/ocp-indent/ocp-indent.el"</span></span>
<span class="giallo-l"><span>            ))</span></span>
<span class="giallo-l"></span>
<span class="giallo-l"><span class="z-3 z-i">;; merlin-mode</span></span>
<span class="giallo-l"><span>(</span><span class="z-5">push</span><span> (</span><span class="z-1">concat</span></span>
<span class="giallo-l"><span>       (</span><span class="z-1">substring</span><span> (</span><span class="z-1">shell-command-to-string</span><span class="z-2"> "opam config var share"</span><span>)</span><span class="z-9"> 0 -1</span><span>)</span></span>
<span class="giallo-l"><span class="z-2">       "/emacs/site-lisp"</span></span>
<span class="giallo-l"><span>       )</span></span>
<span class="giallo-l"><span>      load-path)</span></span>
<span class="giallo-l"></span>
<span class="giallo-l"><span>(</span><span class="z-6 z-b">setq</span><span> merlin-command</span></span>
<span class="giallo-l"><span>      (</span><span class="z-1">concat</span></span>
<span class="giallo-l"><span>       (</span><span class="z-1">substring</span><span> (</span><span class="z-1">shell-command-to-string</span><span class="z-2"> "opam config var bin"</span><span>)</span><span class="z-9"> 0 -1</span><span>)</span></span>
<span class="giallo-l"><span class="z-2">       "/ocamlmerlin"</span></span>
<span class="giallo-l"><span>       ))</span></span>
<span class="giallo-l"><span>(</span><span class="z-1">autoload</span><span class="z-8"> 'merlin-mode</span><span class="z-2"> "merlin" "Merlin mode"</span><span> t)</span></span></code></pre>
<p>Now the meat: when we select <code>tuareg-mode</code>, use <code>ocp-indent</code> to indent lines,
turn on <code>merlin</code> auto-complete, and finally set a couple of local key bindings
so that I can fix up <code>merlin</code> to not conflict with my
now-neurologically-hardwired navigation keys.</p>
<pre class="giallo z-code"><code data-lang="emacs-lisp"><span class="giallo-l"><span>(</span><span class="z-1">add-hook</span><span class="z-8"> 'tuareg-mode-hook</span></span>
<span class="giallo-l"><span>          '(</span><span class="z-1">lambda</span><span> ()</span></span>
<span class="giallo-l"><span>             (merlin-mode)</span></span>
<span class="giallo-l"><span>             (</span><span class="z-6 z-b">setq</span><span> indent-line-function </span><span class="z-8">'ocp-indent-line</span><span>)</span></span>
<span class="giallo-l"><span>             (</span><span class="z-6 z-b">setq</span><span> merlin-use-auto-complete-mode t)</span></span>
<span class="giallo-l"><span>             (</span><span class="z-1">local-set-key</span><span> (</span><span class="z-1">kbd</span><span class="z-2"> "C-S-&lt;up&gt;"</span><span>)</span><span class="z-8"> 'merlin-type-enclosing-go-up</span><span>)</span></span>
<span class="giallo-l"><span>             (</span><span class="z-1">local-set-key</span><span> (</span><span class="z-1">kbd</span><span class="z-2"> "C-S-&lt;down&gt;"</span><span>)</span><span class="z-8"> 'merlin-type-enclosing-go-down</span><span>)</span></span>
<span class="giallo-l"><span>             ))</span></span></code></pre>
<p>Finally, do the usual to use <code>tuareg-mode</code> for OCaml/F# editing.</p>
<pre class="giallo z-code"><code data-lang="emacs-lisp"><span class="giallo-l"><span>(push'(</span><span class="z-2">"\\.ml[iylp]?"</span><span class="z-5"> .</span><span> tuareg-mode) auto-mode-alist)</span></span>
<span class="giallo-l"><span>(</span><span class="z-5">push</span><span> '(</span><span class="z-2">"\\.fs[ix]?"</span><span class="z-5"> .</span><span> tuareg-mode) auto-mode-alist)</span></span></code></pre>
<p>And that’s it!</p>

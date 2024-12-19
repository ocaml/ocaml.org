---
title: What happened in August 2022?
description: "In an attempt to start a regular blogging habbits, I am giving a try
  to the monthly \u201Cstatus updates\u201D format. This month: some Emacs config
  hacking, and some changes on how this website is generated."
url: https://soap.coffee/~lthms/posts/August2022.html
date: 2022-08-15T00:00:00-00:00
preview_image: https://soap.coffee/~lthms/img/thinking.png
authors:
- "Thomas Letan\u2019s Blog"
source:
---


        
        <h1>What happened in August 2022?</h1><div><span class="icon"><svg><use href="/~lthms/img/icons.svg#tag"></use></svg></span>&nbsp;<a href="https://soap.coffee/~lthms/tags/emacs.html" marked="" class="tag">emacs</a> <span class="icon"><svg><use href="/~lthms/img/icons.svg#tag"></use></svg></span>&nbsp;<a href="https://soap.coffee/~lthms/tags/meta.html" marked="" class="tag">meta</a> </div>
<p>Without further ado, let’s take a look at what was achieved
for the last thirty days or so.</p>
<h2>Emacs</h2>
<p>I have started tweaking and improving my Emacs
<a href="https://src.soap.coffee/dotfiles/emacs.d.git" marked="">configuration&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>
again<label for="fn1" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-right sidenote note"><span class="footnote-p">After having used Emacs for seven years now, I am nowhere close
to consider my configuration as a done project. I really envy developers
who are using their editor with little to no customization. </span>
</span>.</p>
<h3>Theme Selection Menu</h3>
<p>The change I am the most excited about is that I have <em>finally</em> reduced the
boilerplate in need to write to use a new theme. I am very indecisive when
it comes to theming. I like to have my choices, and I get tired of any
color scheme pretty quickly. As a consequence, I introduced a customizable
variable to let me select a theme dynamically, and have this choice persist
across Emacs session.</p>
<p>I have a Hydra menu that allows me to select which theme I want to
use for the time being. It looks like this.</p>
<p></p><figure><img src="https://soap.coffee/~lthms/img/select-theme.png"><figcaption><p>A Hydra menu for selecting a theme.</p></figcaption></figure><p></p>
<p>But adding new entries to this menu was very cumbersome, and mostly
boilerplate that I know a good macro could abstract away. And I can
finally report that I was right all along. I have my macros now,
and they allow me to have the Hydra menu above generated with these
simple lines of code.</p>
<pre><code class="hljs language-lisp">(<span class="hljs-name">use-theme</span> ancientless <span class="hljs-string">"a"</span> <span class="hljs-symbol">:straight</span> <span class="hljs-literal">nil</span> <span class="hljs-symbol">:load-path</span> <span class="hljs-string">"~/.emacs.d/lisp"</span>)
(<span class="hljs-name">use-theme</span> darkless <span class="hljs-string">"d"</span> <span class="hljs-symbol">:straight</span> <span class="hljs-literal">nil</span> <span class="hljs-symbol">:load-path</span> <span class="hljs-string">"~/.emacs.d/lisp"</span>)
(<span class="hljs-name">use-theme</span> brightless <span class="hljs-string">"b"</span> <span class="hljs-symbol">:straight</span> <span class="hljs-literal">nil</span> <span class="hljs-symbol">:load-path</span> <span class="hljs-string">"~/.emacs.d/lisp"</span>)
(<span class="hljs-name">use-theme</span> monotropic <span class="hljs-string">"m"</span>)
(<span class="hljs-name">use-theme</span> monokai <span class="hljs-string">"M"</span>)
(<span class="hljs-name">use-theme</span> nothing <span class="hljs-string">"n"</span>)
(<span class="hljs-name">use-theme</span> eink <span class="hljs-string">"e"</span>)
(<span class="hljs-name">use-theme</span> dracula <span class="hljs-string">"D"</span>)
(<span class="hljs-name">use-theme</span> chocolate <span class="hljs-string">"c"</span>)
(<span class="hljs-name">use-themes-from</span> tao-theme
                 '((<span class="hljs-string">"tl"</span> . tao-yang)
                   (<span class="hljs-string">"td"</span> . tao-yin)))
</code></pre>
<h3>Eldoc and Flycheck Popups</h3>
<p>I have been experimenting with several combinations of packages to
have Eldoc and Flycheck using pop-up-like mechanisms to report
things to me, instead of the echo area.</p>
<p>The winning setup for now is the one that uses the <a href="https://github.com/cpitclaudel/quick-peek" marked=""><code class="hljs">quick-peek</code>
package&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a>. That is,
<a href="https://github.com/flycheck/flycheck-inline" marked=""><code class="hljs">flycheck-inline</code>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a> (customized to
use <code class="hljs">quick-peek</code>, as suggested in their README), and
<a href="https://melpa.org/#/eldoc-overlay" marked=""><code class="hljs">eldoc-overlay</code>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>. This works well enough,
so the pop-ups of eldoc are maybe a bit too distracting.</p>
<p>#<a href="https://soap.coffee/~lthms/img/flycheck-inline.png" marked=""><code class="hljs">flycheck-inline</code> in action with an OCaml compilation error.</a></p>
<p>In my quest for pop-ups, I ran into several issues with the packages I tried
out. For instance, <a href="https://github.com/casouri/eldoc-box" marked=""><code class="hljs">eldoc-box</code>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a> was very
nice, but also very slow for some reason. It turns out there was an issue
about that slowness, wherein the culprit was identified. This allowed me to
<a href="https://github.com/casouri/eldoc-box/pull/48" marked="">submit a pull request that got merged rather
quickly&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a>.</p>
<p>Similarly, after a packages update, I discovered
<a href="https://github.com/flycheck/flycheck-ocaml" marked=""><code class="hljs">flycheck-ocaml</code>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a> was no longer
working, and <a href="https://github.com/flycheck/flycheck-ocaml/pull/14" marked="">submit a patch to fix the
issue&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a>.</p>
<h2>This Website</h2>
<p>I have not been investing a lot of time in this website for the past
six years or so. This month, things change a bit on that side too.</p>
<h3>New Contents</h3>
<p>First, I have published a (short) article on <a href="https://soap.coffee/~lthms/posts/RankNTypesInOCaml.html" marked="">higher-order
polymorphism in OCaml</a>. The goal was for me to
log somewhere the solution for an odd problem I was confronted to at
<code class="hljs language-bash"><span class="hljs-variable">$WORK</span></code>, but the resulting article was not doing a great job as
conveying this. In particular, two comments on Reddit motivated me to rework
it, and I am glad I did. I hope you enjoy the retake.</p>
<p>Once this was out of the way, I decided that generating this website was taking
way too much time for no good enough reason. The culprit was <strong><code class="hljs">cleopatra</code></strong>, a
toolchain I had developed in 2020 to integrate the build process of this
website as additional contents that I thought might interest people. The sad
things were: <strong><code class="hljs">cleopatra</code></strong> was adding a significant overhead, and I never take
the time to actually document them properly.</p>
<h3>Under the Hood</h3>
<p>Overall, the cost of using <strong><code class="hljs">cleopatra</code></strong> was not worth the burden, and so I
got rid of it. Fortunately, it was not very difficult, since the job of
<strong><code class="hljs">cleopatra</code></strong> was to extracting the generation processes from org files; I
just add to implement a small <code class="hljs">makefile</code> to make use of these files, without
having to rely on <strong><code class="hljs">cleopatra</code></strong> anymore.</p>
<p>This was something I was pondering to do for a long time, and as
often in these circumstances, this gave me the extra motivation I
needed to tackle other ideas I had in mind for this website. This
is why now, rather than starting one Emacs process per Org file I
have to process, my build toolchain starts one Emacs server, and
later uses <code class="hljs">emacsclient</code>.</p>
<p>Now, most of the build time is spent by <a href="https://soupault.app" marked="">soupault&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>. I guess
I will have to spend some time on the Lua plugins I have developed for it at
some point.</p>
<h2>A New Mailing List</h2>
<p>Finally, I have created <a href="https://lists.sr.ht/~lthms/public-inbox" marked="">a public
mailing&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a> list that is available if you
want to start a discussion on one of my articles. Don’t hesitate to use it, or
to register to it!</p>
        
      

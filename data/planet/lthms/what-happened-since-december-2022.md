---
title: What happened since December 2022?
description: "\u201CRegularity is key.\u201D But sometimes, it is a bit hard to get
  right. Anyway, let\u2019s catch up."
url: https://soap.coffee/~lthms/posts/May2023.html
date: 2023-05-18T00:00:00-00:00
preview_image: https://soap.coffee/~lthms/img/thinking.png
authors:
- "Thomas Letan\u2019s Blog"
source:
---


        
        <h1>What happened since December 2022?</h1><div><span class="icon"><svg><use href="/~lthms/img/icons.svg#tag"></use></svg></span>&nbsp;<a href="https://soap.coffee/~lthms/tags/emacs.html" marked="" class="tag">emacs</a> <span class="icon"><svg><use href="/~lthms/img/icons.svg#tag"></use></svg></span>&nbsp;<a href="https://soap.coffee/~lthms/tags/meta.html" marked="" class="tag">meta</a> <span class="icon"><svg><use href="/~lthms/img/icons.svg#tag"></use></svg></span>&nbsp;<a href="https://soap.coffee/~lthms/tags/neovim.html" marked="" class="tag">neovim</a> <span class="icon"><svg><use href="/~lthms/img/icons.svg#tag"></use></svg></span>&nbsp;<a href="https://soap.coffee/~lthms/tags/releases.html" marked="" class="tag">releases</a> <span class="icon"><svg><use href="/~lthms/img/icons.svg#tag"></use></svg></span>&nbsp;<a href="https://soap.coffee/~lthms/tags/spatial-shell.html" marked="" class="tag">spatial-shell</a> </div>
<p>Initially, I started this “What happened” series as an exercise to publish
more regularly on this website. Suffice to say, I haven’t done a particularly
impressive job in that regard, which only means I have a lot of room for
improvement.</p>
<p>Anyway, if the first few months of 2023 has been mostly <code class="hljs language-bash"><span class="hljs-variable">$WORK</span></code> focus,
the same cannot be said for April and May. For one, I have started
<a href="https://soap.coffee/~lthms/running.html" marked="">running</a> again. But this is only the tip of the iceberg.</p>
<h2>Spatial Shell got its first releases</h2>
<p><a href="https://github.com/lthms/spatial-shell" marked="">Spatial Shell&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a> is probably my hobby
project I am most excited about. The <a href="https://soap.coffee/~lthms/posts/CFTSpatialShell.html" marked="">“call for testers”
article</a> I have published recently managed to
catch the attention of a few folks<label for="fn1" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-right sidenote note"><span class="footnote-p">You want to hear a lesson I learned the hard way just after publishing
it? Before calling for testers, it is better to <a href="https://github.com/lthms/spatial-shell/issues/2#issuecomment-1527193430" marked="">be sure your project can
actually be compiled easily by the potential
volunteers&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a>. </span>
</span>. The perspective to publish such a
write-up was a very strong source of motivation for me to clean up a project I
was using daily for several months now, and I am very satisfied with the
result.</p>
<p>Mass adoption is still a distant horizon, but still, the project is now
mainstream enough that it has already been mentioned in <a href="https://discuss.ocaml.org/t/window-manager-xmonad-in-ocaml/12048/4" marked="">a random topic on the
OCaml discourse by someone who isn’t
me&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>. 🎉</p>
<p>This led me to formally release a first version of Spatial Shell in the end of
April, and a second today. For the first time, I have also published <a href="https://aur.archlinux.org/packages/spatial-shell" marked="">an
Archlinux package&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>, to make
the life of potential early adopters even easier. Do not hesitate to upvote it
so that it can find its way to the <code class="hljs">extra</code> repository some day.</p>
<h2>Goodbye Emacs! Remember me, Neovim?</h2>
<p>In 2015, I started using Coq for my PhD thesis and at the time, there was no
real support for (Neo)vim<label for="fn2" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-left sidenote note"><span class="footnote-p">The situation later improved. Nowadays, you can implement your theories
using <a href="https://github.com/whonore/Coqtail" marked="">Coqtail&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a>, and <a href="https://github.com/ejgallego/coq-lsp" marked="">Coq
LSP&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a> will probably become a viable
and interesting setup in a near future. </span>
</span>. Everyone was using <a href="https://proofgeneral.github.io/" marked="">Proof
General&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a> and Emacs, so I was left with little
choice but to follow through. With only my courage and the <a href="https://juanjoalvarez.net/posts/2014/vim-emacsevil-chaotic-migration-guide/" marked="">good advice of a
fellow “vimer” who had also made a similar
journey&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>,
I started using Emacs.</p>
<p>Fast forward 8 years later, and my <a href="https://src.soap.coffee/dotfiles/emacs.d" marked="">Emacs
configuration&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a> has become a project
of its own. Overall, I was pretty happy with my setup, but in the same time, I
always remained a bit nostalgic of my Neovim days. This is probably why I
decided to give this old friend a try when my company bought me a new laptop. I
also used this as an opportunity to try out this LSP-thing everyone was talking
about.</p>
<p>It has been a month now, and I do not plan to come back to my previous habits.
There are still some few edges here and there, I still need to get my head
around lua, but LSP is nice, and plugins like
<a href="https://github.com/nvim-telescope/telescope.nvim" marked="">telescope&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a> are simply too
beautiful.</p>
<p>That being said, there was one aspect of moving from Emacs to Neovim I had not
anticipated: Org mode. Which constitutes a perfect transition to the next
session.</p>
<h2>Website redesign, again</h2>
<p>Did you notice this website has been revamping recently? The changes are
actually deeper than “just” a redesign, to a point where I had to port <em>all</em> my
write-ups to a different markup language<label for="fn3" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-right sidenote note"><span class="footnote-p">Are you starting to understand why “Org mode” was the perfect
transition to move on to this section? </span>
</span>.</p>
<p>Why, you ask? Well, it’s actually pretty simple: as time goes, I’ve grown
lazier.</p>
<p>Let me give you some context. Until very recently, my website was built around
the idea to have literate programming as a first-class citizen of my author
tools. For instance, you can have a look at <a href="https://soap.coffee/~lthms/posts/CleopatraV1.html" marked="">what used to be the literate
program which was responsible for generating the
website</a>. Similarly, most of <a href="https://soap.coffee/~lthms/tags/coq.html" marked="">my write-ups about
Coq</a> were actually Coq documents. Literate programming is
actually a very nice paradigm for authoring technical contents, because it
gives you the tools to keep said contents accurate and up-to-date. In a
nutshell, you cannot have a typo in one of your code snippets which would
prevent it from compiling, because you actually
compile the snippet and catch the typo when you try to generate your website.
Or at least, it is what I used to do.</p>
<p>I decided to stop because, for all its benefits, this approach has one major
drawback: it is hard to maintain. I had invested quite some time and efforts to
keep my website sources under control, but it really was an everyday fight.
There are some strange things which start happening when you fully commit to
this, as I think I did. For instance, software dependencies tie your article
together. Suddenly, you cannot talk about this new fancy feature of the latest
Coq release without upgrading <em>all</em> your write-ups implemented as Coq
documents<label for="fn4" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-left sidenote note"><span class="footnote-p">Well, in theory you can. Just have each Coq document specifies the
Coq version it requires, and support this level of customization in your
build toolchain. But then, your blog takes forever to build from a cold
repository. </span>
</span>.</p>
<p>That being said, most of the work had already been done. This website <em>was</em> a
collection of literate programs, and I was pretty proud of the state of things.
I could deal with the annoyances<label for="fn5" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-right sidenote note"><span class="footnote-p">Like using Coqdoc syntax to write my articles, for instance. I could
write about how the Coqdoc syntax irks me for ages. </span>
</span>. But then, as I explained in the
previous section, I decided to move away from Emacs. The first time I tried to
start a new write-up, it hit me.</p>
<p>I used to write most of my contents using Org mode. Org mode, also known as
<em>the</em> Emacs markup language.</p>
<p>I know of at least <a href="https://github.com/nvim-orgmode/orgmode" marked="">one “Org plugin” for
Neovim&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a>, but instead of giving it a
try, I decided to use this opportunity to tackle my “maintenance problem” once
and for all. <em>I gave up on literate programming for this website.</em> As a result,
this website is now generated from Markdown files only (using
<a href="https://github.com/markdown-it/markdown-it" marked="">markdown-it&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a> with many plugins).
As a consequence, the generated HTML is way more “predictable.” This was enough
to motivate me at giving a try at <a href="https://soupault.app/reference-manual/#metadata-extraction-and-rendering" marked="">Soupault’s
indexes&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>,
which are way more powerful than I anticipated. Now, this website has</p>
<ul>
<li>Tags. Each write-up can be labeled with as many tags as I want, there is <a href="https://soap.coffee/~lthms/tags" marked="">a
page which lists all the tags used in the website</a>, and each tag has
its own page (for instance, the <a href="https://soap.coffee/~lthms/tags/coq.html" marked=""><code class="hljs">coq</code> tag</a>.</li>
<li>A <a href="https://soap.coffee/~lthms/posts/index.xml" marked="">RSS feed</a>. It was actually one of the main features I
really wanted to get with this revamp.</li>
<li>Automatically generated list of articles in the <a href="https://soap.coffee/~lthms/" marked="">home page</a>, for each
series (see the <a href="https://soap.coffee/~lthms/series/Ltac.html" marked="">Ltac series</a> for instance). Before, I was
publishing “curated indexes,” or put in other words: I was writing these
indexes myself, by hand. And again, I’ve grown lazier.</li>
</ul>
<p>It took me a week to go through this rework. Translating manually every write-up
was tedious, to say the least, as was implementing the Lua plugins for Soupault
since I have neither proficiency nor tooling to help me write Lua code. But I
am very glad for the final result.</p>
<p>Also, I have invested in an Antidote license, so hopefully, this website will
have fewer typos and English butchering as of now. A clean text, delivered with
a nice and simple design, from a sane and maintainable <a href="https://src.soap.coffee/soap.coffee/lthms.git/" marked="">Git
repository&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>.</p>
        
      

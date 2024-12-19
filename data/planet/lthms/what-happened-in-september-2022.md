---
title: What happened in September 2022?
description: In a nutshell, my latest hobby project (Spatial Sway) works well enough
  so that I can use it daily, and I have done some unsuccessful experiments for this
  website.
url: https://soap.coffee/~lthms/posts/September2022.html
date: 2022-09-18T00:00:00-00:00
preview_image: https://soap.coffee/~lthms/img/thinking.png
authors:
- "Thomas Letan\u2019s Blog"
source:
---


        
        <h1>What happened in September 2022?</h1><div><span class="icon"><svg><use href="/~lthms/img/icons.svg#tag"></use></svg></span>&nbsp;<a href="https://soap.coffee/~lthms/tags/spatial-shell.html" marked="" class="tag">spatial-shell</a> <span class="icon"><svg><use href="/~lthms/img/icons.svg#tag"></use></svg></span>&nbsp;<a href="https://soap.coffee/~lthms/tags/meta.html" marked="" class="tag">meta</a> </div>
<p>It is September 18 today, and it has already been a month since I
decided to start these retrospectives. This means it is time to take a
step back and reflect of what happened these past few thirty days or
so<label for="fn1" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-right sidenote note"><span class="footnote-p">There is the shocking news that I have started to use syntax
highlighting again. But let’s not linger too much into it just yet. </span>
</span>.</p>
<h2>Spatial Sway</h2>
<p>A few days after publishing my August Retrospective, I have learned
the existence of <a href="https://material-shell.com" marked="">Material Shell&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>, an extension for
GNOME 3 that provides a very interesting user experience.</p>
<p>I tried it for a few hours, but the thing kept crashing (it’s
probably on me, I did not even remember I had Gnome installed on my
machine, and I would not be surprised the culprit was my dusty setup
rather than Material Shell itself). The experience remained very
promising, though. Their “spatial model” especially felt like a very
good fit for me. Basically, the main idea is that you have a grid of
windows, with your workspaces acting as the rows. You can navigate
horizontally (from one workspace to another), or horizontally, and
you choose how many windows you want to see at once on your screen.</p>
<p>And so for a few hours, I was a bit frustrated by the situation…
until I learned about how one can actually manage and extend Sway
(the Wayland compositor I use for several years now) thanks to its IPC
protocol.  I spend like three days experimenting, first in Rust, then in
OCaml<label for="fn2" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-left sidenote note"><span class="footnote-p">This was actually an interesting thought process. I am using OCaml at
<code class="hljs language-bash"><span class="hljs-variable">$WORK</span></code> for about more than a year now.</span>
<span class="footnote-p">I have curated a setup that works pretty well, and I am familiar with the
development tools. On the contrary, I had not written a line of Rust for at
least a year, my Emacs configuration for this language was broken, and I
had lost all my fluency in this language. Still, I was not expecting to
pick OCaml when I started this project. </span>
</span>, and by the end of the week, I had a first working prototype I
called <a href="https://github.com/lthms/spatial-shell" marked="">Spatial Sway&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a>. It works pretty
well; well enough that I am using it daily for several weeks now. It feels
clunky at times, but it works well, and I have been able to write a
<a href="https://github.com/Alexays/Waybar" marked="">Waybar&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a> configuration heavily inspired on
Material Shell UI.</p>
<p>Overall, I am pretty satisfied with this turnout. Writing a hobbyist
software project is always nice, but the ones you can integrate in
your daily workflow are the best one. The last time I did that was
<a href="https://sr.ht/~lthms/keyrd" marked=""><strong>keyrd</strong>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>, my little keystrokes counting
daemon<label for="fn3" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-right sidenote note"><span class="footnote-p">19,970,965 since I started using it at the time of writing this
article </span>
</span>.</p>
<p>Anyway, lots remains to be said about Spatial Sway, but I might save
it for a bit later. I still have some key features to implement
(notably, moving a window to another workspace), then I will
probably try to advertise it a bit. I am under the impression this
project could be of interest for others, and I would love to see it
used by folks willing to give a Material Shell-like experience a
try, without having to deal with Gnome Shell. By the way,
considering Sway is a drop-in replacement for i3, and that it
implements the exact same IPC protocol, there is no reason why
Spatial Sway is actually Sway specific, and I will rename it Spatial
Shell at some point.</p>
<p></p><figure><img src="https://soap.coffee/~lthms/img/spatial-sway-preview.png"><figcaption><p>Mandatory screenshot of Spatial Sway.</p></figcaption></figure><p></p>
<h2>This Website</h2>
<p>On a side note, I have started to refine the layout of this website
a bit. Similarly, I have written a new, curated home page where I
want to highlight the most recent things I have published on the
Internet.</p>
<p>I have been experimenting with
<a href="https://github.com/cpitclaudel/alectryon/" marked="">Alectryon&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a> as a way to replace
<code class="hljs">coqdoc</code>, to improve the readability of my Coq-related articles. Unfortunately,
it looks like this tool is missing <a href="https://github.com/cpitclaudel/alectryon/issues/86" marked="">a key feature I
need&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a>. I might try to get
my hand dirty and implement it myself if I find the time and the motivation
in the following weeks.</p>
<p>Finally, reading about how <a href="https://xeiaso.net/talks/how-my-website-works" marked="">Xe Iaso’s talk about how she generates her
blog&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a> was very inspiring to me.
I can only suggest that you have a look.</p>
<p>Though not to the same extent, I also think I have spent way too much effort in
my website. Most of my Coq-related articles are actual Coq program, expect the
articles about <code class="hljs">coqffi</code> which are Org mode literate programs. Hell, this website
itself used to be a literate program of the sort, until I stopped using my
homegrown literate programming toolchain <strong><code class="hljs">cleopatra</code></strong> last month. At some
point, I have even spent a bit of time to ensure most of the pages of this
website were granted a 100/100 on websites like PageSpeed Insight<label for="fn4" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-left sidenote note"><span class="footnote-p">Good news, I’ve just checked, and it still is! </span>
</span>. I
had almost forgotten.</p>
<p>A lot remains to be done, but watching this talk made me reflect on
the job done. And opened my eyes to a new perspective, too. We will
see what translates into reality.</p>
        
      

---
title: From Gedit to Geany.
description:
url: http://www.mega-nerd.com/erikd/Blog/CodeHacking/Geany/gedit_geany.html
date: 2010-08-04T11:17:00-00:00
preview_image:
featured:
authors:
- mega-nerd
---



<p>
After effectively
	<a href="http://www.mega-nerd.com/erikd/Blog/CodeHacking/rip_nedit.html">
	giving up on Nedit</a>,
my text editor of choice for the last fifteen years, I gave Gedit a serious try.
</p>

<p>
For a full two weeks, I stuck with Gedit, including the intense 2&frac12; day
hacking session of
	<a href="http://random.axman6.com/blog/?p=219">
	AusHac2010</a>.
Unfortunately, switching from a very full featured editor like Nedit to Gedit
was painful.
There were a bunch of features that I had grown used to that were just absent or
inconvienient in Gedit.
The problem is that Gedit aims to be a relatively full featured programmer's
editor while still being the default easy-to-use editor in GNOME.
As far as I am concerned, these two aims are in conflict, making Gedit an
adequate simple text editor and a poor editor for advanced coders.
</p>

<p>
After butting my head against basic usability issues with Gedit I was even
considered either modifying it extensively using plugins or maybe even forking
it and maintaining a forked version.
Yes, that would be a huge pain in the neck, but fortunately that will not now
be necessary.
</p>

<p>
In response to my blog post titled
	<a href="http://www.mega-nerd.com/erikd/Blog/CodeHacking/rip_nedit.html">
	<i>&quot;R.I.P. Nedit&quot;</i></a>
fellow Haskell hacker and Debian Haskell Group member
	<a href="https://www.joachim-breitner.de/blog/">
	Joachim Breitner</a>
suggested I have a look at the
	<a href="http://www.geany.org/">
	Geany text editor and IDE</a>.
</p>

<p>
Geany is obviously a tool aimed squarely as an editor for full time, committed
programmers.
Its also much more than just an editor, in that it has many features of an IDE
(Integrated Development Environment).
In fact, when I first fired it up it looked like this (click for a larger view):
</p>

<br/>
<center>
	<a href="http://www.mega-nerd.com/erikd/Img/geany-default.png">
	<img src="http://www.mega-nerd.com/erikd/Img/geany-default-small.png" border="0" alt="Geany default window"/>
	</a>
</center>
<br/>

<p>
On seeing this I initially thought Geany was not for me.
Fortunately I found that the extra IDE-like features can easily be hidden,
providing me with a simple-to-use, highly configurable, advanced text editor.
The features I really like are:
</p>

<ul>
	<li>High degree of configurability, including key bindings.
		</li>
	<li>Syntax highlighting (configurable) for a huge number of languages.
		</li>
	<li>Custom syntax highlighting (ie user definable highlighting for languages
		not currently supported by Geany).
		</li>
	<li>Regex search and search/replace.
		</li>
	<li>Search and replace within a selected area only.
		</li>
	<li>Highlighting of matching braces and brackets.
		</li>
	<li>Language specific editing modes and auto indentation.
		</li>
	<li>Go to specified line number.
		</li>
	<li>Plugins.
		</li>
</ul>

<p>
There are still a few little niggles, but nothing like the pain I experienced
trying to use Gedit.
For instance, when run from the command line, Geany will open new files in a
tab of an existing Geany instance.
With multiple desktop workspaces, this is sub optimal.
It would be much nicer if Geany would start a new instance if there was not
already an instance running on the current workspace.
After a brief inspection of the Gedit sources (Gedit has the desired feature),
I came up with a fix for this issue which I will be submitting to the Geany
development mailing list after a couple of days of testing.
</p>

<p>
Another minor issue (shared with Gedit) is that of fonts.
Nedit uses bitmap fonts while Geany (and Gedit) use TrueType fonts.
When I choose light coloured fonts on a black background I find the fonts in
Geany (and Gedit) a lot fuzzier than the same size fonts in Nedit.
I've tried a number of different fonts including
	<a href="http://www.levien.com/type/myfonts/inconsolata.html">
	Inconsolata</a>
but I've currently settled on
	<a href="http://dejavu-fonts.org/wiki/Main_Page">
	DejaVu Sans Mono</a>
although I'm not entirely satisfied.
</p>

<p>
Currently my Geany setup (editing some Haskell code) looks like this:
</p>

<br/>
<center>
	<img src="http://www.mega-nerd.com/erikd/Img/geany-modded.png" border="0" alt="Geany modified config"/>
</center>
<br/>

<p>
Light text on a black background with highlighting using a small number of
colours; red for types, green for literals, yellow for keywords etc.
</p>

<p>
Geany is a great text editor.
For any committed coders currently using either Nedit or Gedit and not entirely
happy, I strongly recommend that you give Geany a try.
</p>




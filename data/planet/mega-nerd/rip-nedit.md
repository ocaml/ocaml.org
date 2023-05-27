---
title: R.I.P. Nedit
description:
url: http://www.mega-nerd.com/erikd/Blog/CodeHacking/rip_nedit.html
date: 2010-07-27T12:18:00-00:00
preview_image:
featured:
authors:
- mega-nerd
---



<p>
For serious programmers, the text editor they user is an intensely personal
thing.
Try suggesting to an Emacs user that they should switch to Vim or vice-versa.
Most would shudder at the thought.
</p>

<p>
My choice of editor for the last 15 years has been Nedit, the
	<a href="http://www.nedit.org/">
	Nirvana Editor</a>.
Nedit has been an outstanding editor; feature full yet easy to use.
When I first started using it, Nedit was a closed source binary-only download
but sometime in the late 1990s, it was released under the GNU GPL.
</p>

<p>
Unfortunately Nedit has been suffering from bit rot and neglect for a number
of years.
The main problem is that it uses the
	<a href="http://en.wikipedia.org/wiki/Motif_(widget_toolkit)">
	Motif widget toolkit</a>.
For open source, there are basically two options for Motif;
	<a href="http://lesstif.sourceforge.net/">
	Lesstif</a>,
an LGPL reimplementation of Motif which has been basically unmaintained for
a number of years, or
	<a href="http://www.opengroup.org/openmotif/">
	OpenMotif</a>
released under a license which is in no way
	<a href="http://www.opensource.org/">
	OSI approved</a>.
On top of that, Nedit still doesn't support UTF-8, mainly because Lesstif
doesn't support it.
</p>

<p>
I have, in the past, tried to fix bugs in Nedit, but the bugs are not really
in Nedit itself, but in an interaction between Nedit whichever Motif library
it is linked against and the underlying X libraries.
Depending on whether Nedit is linked against Lesstif and OpenMotif, Nedit will
display different sets of bugs.
I have tried fixing bugs in Nedit linked against Lesstif, but got absolutely
nowhere.
Lesstif is one of the few code bases I have ever worked on that I was
completely unable to make progress on.
</p>

<p>
With Nedit getting flakier with each passing year I finally decided to switch
to a new editor.
I had already discounted Emacs and Vim; switching from Nedit to either of those
two archaic beasts was going to be way too painful.
Of all the FOSS editors available,
	<a href="http://projects.gnome.org/gedit/">
	Gedit</a>
seemed to be the closest in features to Nedit.
</p>

<p>
Unfortunately, Gedit does not compare well with Nedit feature wise.
To me it seems to try to be simultaneously as simple as possible and to have as
many features as possible and the features don't seem to fit together all that
well from a usability point of view.
On top of that, it lacks the following:
</p>

<ul>
	<li>Regex search and regex search/replace.
		Apparently there is a regex search/replace plugin, but that uses a
		different hot key combination that literal search/repalce.
		Nedit on the other hand uses the same dialog box for literal and
		regex search/replaces; with a toggle button to switch between literal
		and regex searches. 
		</li>
	<li>Search and replace within the selected area only.
		</li>
	<li>Highlighting of matching braces and brackets.
		</li>
	<li>Language specific editing modes and auto indentation.
		</li>
	<li>A macro language allowing further customisation.
		</li>
	<li>A simple, quick way to go to a particular line number (for Gedit,
		Control-L is supposed to work, but doesn't).
		</li>
</ul>

<p>
On top of that Gedit could also do with some improved key bindings and some
improvements to its syntax highlighting patterns.
The Ocaml syntax highlighting is particularly poor.
</p>

<p>
I'm now going to try to use Gedit, by customising its setup and and using the
plugin system to see if I can regain the features that made Nedit such a
pleasure to use.
</p>







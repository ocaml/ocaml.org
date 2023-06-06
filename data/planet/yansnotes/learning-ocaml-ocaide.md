---
title: 'Learning OCAML: OcaIDE'
description: A little bit about everything, but mostly about fixing annoying tech
  problems, interesting posts I stumbled on.
url: http://yansnotes.blogspot.com/2014/10/learning-ocaml-idealy-one-function-at.html
date: 2014-10-02T11:01:00-00:00
preview_image:
featured:
authors:
- Unknown
---

<div dir="ltr" style="text-align: left;" trbidi="on">
<div dir="ltr" style="text-align: left;" trbidi="on">
OCAML has a growing and loyal community behind it, OCAML.org is a great place to get in touch and contribute.<br/>
Nevertheless, in my journey I found in difficult to find much material that is tailored for a total noobie.&nbsp; This is why I decided to document my journey towards functional-language enlightenment, namely by learning and using OCAML language for&nbsp; developing the <a href="https://github.com/yansh/MoanaML/" target="_blank">MoanaML</a>&nbsp; project. Your feedback, guidance and contributions are most welcomed. <br/>
<br/>
So here were are, let's start exploring...our glory awaits! :) By the way, I am running Ubuntu 14.04, so most of my tips will be related to it.<br/>
<br/>
I tend to learn most by doing and to do something useful you need the right tools. <br/>
<br/>
Therefore I think the first post about my journey should be on finding and using the right IDE <a href="https://www.blogger.com/blogger.g?blogID=954580896613987338#1" name="top1"><sup>1</sup></a>. There are not many options around, but there are a few. Your main trade off is on how much time you spend fiddling with them.<br/>
<br/>
I tried a few in all the cases I had to tweak the settings and configuration to get reasonable performance. In the end, I started using <a href="http://www.algo-prog.info/ocaide/index.php" target="_blank">OcaIDE</a>, which is a plugin for Eclipse. It is far from perfect, but gives you the initial support a noobie might need to get started.<br/>
<br/>
<blockquote class="tr_bq">
<ul>
<li> Source editor for modules (ml files), interfaces (mli files), parsers (mly files) and lexers (mll files)
        </li>
<li> Syntax coloring (colors and styles are configurable)
        </li>
<li> Automatic indentation while typing in the editor (configurable in the preferences)
        </li>
<li> A customizable integrated code formatter, and an interface to the camlp4 formatter (through an AST printer)
        </li>
<li> Completion
        </li>
<li> Library browser, both for the standard library and user libraries
        <br/><br/>. . . and much more. </li>
</ul>
</blockquote>
<br/>
Out of all the Eclipse plugins <a href="http://www.algo-prog.info/ocaide/index.php" target="_blank">OcaIDE</a> works pretty much out of the box. However you need to make sure you specify your build command in the Project preferences. This is also the right place to specify all the libraries and/or external packages the you are planning to use in your project.<br/>
<br/>
In any case, the <a href="http://www.algo-prog.info/ocaide/index.php" target="_blank">OcaIDE </a>project offers Flash-based tutorials on how to set-up and best utilised your developing environment.<br/>
<br/>
You can find step-by-step instructions for it <a href="http://www.seas.upenn.edu/~cis120e/ocaml_setup.shtml" target="_blank">here </a>from guys in UPenn, which include info on how to install OCAML, Eclipse and finally <a href="http://www.algo-prog.info/ocaide/index.php" target="_blank">OcaIDE</a>.<br/>
A nice summary of how to install OCAML on different enviroment is also presented by the OCAML.org <a href="https://ocaml.org/docs/install.html" target="_blank">here</a>.<br/>
<br/>
There is plenty of discussion online about a suitable IDE, here are the links to some of it:<br/>
<br/>
<ul style="text-align: left;">
<li><a href="http://stackoverflow.com/a/14767665" target="_blank">Nice overview on StackOverflow </a></li>
<li><a href="http://caml.inria.fr/cgi-bin/hump.en.cgi?sort=0&amp;browse=56" target="_blank">A nice collection from the OCAML birth place - INRIA </a></li>
</ul>
<br/>
<br/>
<br/>
<br/></div>
<hr width="80%"/>
<span class="Apple-style-span" style="font-size: x-small;"><br/>
<a href="https://www.blogger.com/null" name="1"><b>1 </b></a>I am not a big fan of Vim and Emacs, so I wanted to find and IDE 
that gives me slightly more than just syntax highlight and indentation -
 just kidding :)&nbsp; This&nbsp; is a very gross underestimation
 of the true power behind Vim and Emacs editors, they are truly powerful
 tools once you master them. I guess in my case, I preferred to minimize
 my effort on fiddling with the developing environment and remembering 
key combinations and rather focus on the OCAML language itself. 
Nevertheless, as it turned out, choosing an IDE introduced plenty of 
fiddling with configuration as well. You can find numerous Stack Overflow discussions about it online. </span></div>


---
title: Installing OCaml for MacOS Noobie!
description: A little bit about everything, but mostly about fixing annoying tech
  problems, interesting posts I stumbled on.
url: http://yansnotes.blogspot.com/2015/01/ocaml-for-macos-noobie.html
date: 2015-01-23T20:04:00-00:00
preview_image:
featured:
authors:
- Unknown
---

<div dir="ltr" style="text-align: left;" trbidi="on">
After successfully installing OCaml and Ocaide plugin for Eclipse on a &nbsp;Mac, I now think it's straightforward, however, before I completely forget the pain involved in figuring out what goes where. I wanted to put down some pointers for noobies like me, in hope that it will save people some valuable time.<br/>
<br/>
In general, <a href="http://ocaml.org/">ocaml.org</a> is a great spot for finding any information related to OCaml. Installing OCaml is no different, you can read all about it <a href="https://ocaml.org/docs/install.html#MacOSX" target="_blank">here</a>. There is tons of very useful and detailed information that I highly recommend anyone who is interested in OCaml to check out. In this post I just summarize the steps it took me to get from zero to OCaml installed (hero!).<br/>
<br/>
Feel free to correct me or share your own personal successes and experiences.<br/>
<br/>
<h4 style="text-align: left;">
The following steps worked for me:</h4>
<ul style="text-align: left;">
<li>Install <a href="http://brew.sh/" target="_blank">Homebrew</a></li>
</ul>
<div>
<ul style="text-align: left;">
<li>Install Xcode (<a href="http://osxdaily.com/2014/02/12/install-command-line-tools-mac-os-x/" target="_blank">check this guide</a>)</li>
</ul>
<blockquote class="tr_bq">
xcode-select --install</blockquote>
<ul style="text-align: left;">
<li>brew install ocaml&nbsp;</li>
</ul>
</div>
<div>
<ul style="text-align: left;">
<li>brew install opam - I encountered a problem and apparently I am not the only one - see details and solutions <a href="https://github.com/ocaml/opam/issues/1853" target="_blank">here</a>.</li>
<ul>
<li>Basically if after installing opam and trying to run it, you get &quot;Illegal instruction: 4&quot; &nbsp;Try running:</li>
</ul>
</ul>
<blockquote class="tr_bq">
<span style="background-color: white; color: #333333; font-family: 'Helvetica Neue', Helvetica, 'Segoe UI', Arial, freesans, sans-serif; font-size: 14px; line-height: 22px;">&nbsp;</span><span style="background-color: white; color: #333333; font-family: 'Helvetica Neue', Helvetica, 'Segoe UI', Arial, freesans, sans-serif; font-size: 14px; line-height: 22px;">brew reinstall --build-from-source opam</span></blockquote>
<ul style="text-align: left;"><ul>you can thank&nbsp;<a href="https://github.com/avsm" target="_blank">@avsm</a>&nbsp;for the workaround.</ul>
</ul>
<ul style="text-align: left;"><ul>
</ul>
</ul>
</div>
<div>
Now that you have OCaml installed, let's discuss IDEs.</div>
<h2 style="text-align: left;">
IDEs</h2>
<h3 style="text-align: left;">
Eclipse&nbsp;</h3>
<div>
<br/></div>
<div>
My IDE of choice is Eclipse<a href="https://www.blogger.com/blogger.g?blogID=954580896613987338#1"><sup>1</sup></a> <a href="http://www.algo-prog.info/ocaide/" target="_blank">ocaide plugin very useful</a>. I used it on Ubuntu and thought that installing it on Mac might be a good way to go.</div>
<div>
<br/></div>
<div>
There are multiple guides (from <a href="http://www.seas.upenn.edu/~cis120/current/ocaml_setup.shtml" target="_blank">Upenn</a>, <a href="http://www.cs.jhu.edu/~scott/pl/caml/ocaide.shtml" target="_blank">JSU</a>) on the web on how to do just that, just make sure that you get all the prerequesite components such as Java 7 installed and ready to go.</div>
<div>
<br/></div>
<div>
<a href="http://www.seas.upenn.edu/~cis120/current/ocaml_setup.shtml" target="_blank">Upenn CS120</a> provides a nice list for you to follow, make sure that you do! - thanks guys!</div>
<div>
<br/></div>
<blockquote class="tr_bq">
<ol>
<li style="color: #163243; font-family: Verdana; font-size: 16px; margin: 0px;"><b></b><b>Mac Users Only</b> Install X11 libraries (needed for the OCaml graphics libraries to work):</li>
<ul style="list-style-type: square;">
<li style="color: #163243; font-family: Verdana; font-size: 16px; margin: 0px;">Install Apple's XQuartz version, which is available here: <a href="http://xquartz.macosforge.org/landing/"><span style="color: #39a890; font-kerning: none;">http://xquartz.macosforge.org/landing/</span></a></li>
<li style="color: #163243; font-family: Verdana; font-size: 16px; margin: 0px;">Before moving on to the next step, make sure you LOG OUT of your user account so that the X11 install can complete.</li>
<li style="color: #163243; font-family: Verdana; font-size: 16px; margin: 0px;">Check to see that the directory /usr/X11/lib exists and that it contains the file libX11.6.dylib (this should have been created when you installed XQuartz). If this isn't the case, try reinstalling XQuartz and then contact the course staff for help.</li>
<li style="color: #163243; font-family: Verdana; font-size: 16px; margin: 0px;">[MM] Removed these instructions, because ~/lib isn't on the default PATH for Macs, and because with most recent SW updates this step isn't necessary.
</li>
<li><span style="font-family: Verdana, sans-serif;"> From the terminal, in your home directory (e.g. /Users/stevez) create a directory called lib (if one does not already exist): </span><pre> &gt; cd &gt; mkdir lib </pre>
</li>
<li><span style="font-family: Verdana, sans-serif;"> Create a symbolic link in that lib directory to the libX11.6.dylib file: </span><pre> &gt; cd ~/lib &gt; ln -s /opt/X11/lib/libX11.6.dylib libX11.6.dylib </pre>
</li>
<li style="color: #163243; font-family: Verdana; font-size: 16px; margin: 0px;">Next, install the Java Development Kit (JDK) 7. You can download it from this <a href="http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html"><span style="color: #39a890; font-kerning: none;">this site</span></a> (after accepting the terms &amp; conditions). Make sure you do this step before installing Eclipse or OCaIDE.</li>
</ul>
</ol>
</blockquote>
<div>
<br/></div>
<div>
<br/>
[Update] As was pointed out by numerous stackoverflow posts like <a href="http://stackoverflow.com/questions/829749/launch-mac-eclipse-with-environment-variables-set" target="_blank">this one</a> , Eclipse IDE tend not to recognise environment variables. The <a href="http://stackoverflow.com/a/1182744" target="_blank">solution </a>is to wrap the execution into a bash script. It works, however, I couldn't manage to make it work with the MacOS launch database. Even after the update of the Info.plist, Eclipse still won't recognise environment variables. At this stage, I run the script manually and it works.<br/>
<br/>
<h3>
Vim&nbsp;</h3>
[Update] VIM grows on me. If you are interest to configure VIM to use OCaml, please follow <a href="http://anil.recoil.org/2013/10/03/merlin-and-vim.html" target="_blank">these instructions </a>by<a href="https://twitter.com/avsm" target="_blank"> @avsm</a>.<br/>
<br/>
Here is how my ~/.vimrc looks like:<br/>
<blockquote class="tr_bq">
<div style="background-color: black; color: #34bbc7; font-family: Courier; font-size: 14px;">
<span style="color: #ce7924;">execute</span><span style="color: whitesmoke;">&nbsp;</span>pathogen#infect<span style="color: #d53bd3;">()</span></div>
<div style="background-color: black; color: #c33720; font-family: Courier; font-size: 14px;">
<span style="color: #ce7924;">let</span><span style="color: whitesmoke;">&nbsp;</span><span style="color: #34bbc7;">s:ocamlmerlin</span><span style="color: #ce7924;">=</span><span style="color: #34bbc7;">substitute</span><span style="color: #d53bd3;">(</span><span style="color: #34bbc7;">system</span><span style="color: #d53bd3;">(</span>'opam config var share'<span style="color: #d53bd3;">)</span><span style="color: whitesmoke;">,</span>'\n$'<span style="color: whitesmoke;">,</span>''<span style="color: whitesmoke;">,</span>''''<span style="color: #d53bd3;">)</span><span style="color: whitesmoke;">&nbsp;</span><span style="color: #ce7924;">.</span><span style="color: whitesmoke;">&nbsp;&nbsp;</span>&quot;/ocamlmerlin&quot;</div>
<div style="background-color: black; color: #34bbc7; font-family: Courier; font-size: 14px;">
<span style="color: #ce7924;">let</span><span style="color: whitesmoke;">&nbsp;</span>g:syntastic_ocaml_checkers<span style="color: whitesmoke;">&nbsp;</span><span style="color: #ce7924;">=</span><span style="color: whitesmoke;">&nbsp;[</span><span style="color: #c33720;">'merlin'</span><span style="color: whitesmoke;">]</span></div>
<div style="background-color: black; color: whitesmoke; font-family: Courier; font-size: 14px;">
<span style="color: #ce7924;">au</span>&nbsp;<span style="color: #34bd26;">BufRead</span>,<span style="color: #34bd26;">BufNewFile</span>&nbsp;*.ml,*.mli&nbsp;<span style="color: #ce7924;">compiler</span>&nbsp;ocaml</div>
<div style="background-color: black; color: #c33720; font-family: Courier; font-size: 14px;">
<span style="color: #ce7924;">execute</span><span style="color: whitesmoke;">&nbsp;</span>&quot;set rtp+=&quot;<span style="color: #ce7924;">.</span><span style="color: #34bbc7;">s:ocamlmerlin</span><span style="color: #ce7924;">.</span>&quot;/vim&quot;</div>
<div style="background-color: black; color: #c33720; font-family: Courier; font-size: 14px;">
<span style="color: #ce7924;">execute</span><span style="color: whitesmoke;">&nbsp;</span>&quot;set rtp+=&quot;<span style="color: #ce7924;">.</span><span style="color: #34bbc7;">s:ocamlmerlin</span><span style="color: #ce7924;">.</span>&quot;/vimbufsync&quot;</div>
<div style="background-color: black; color: #c33720; font-family: Courier; font-size: 14px;">
<span style="color: #ce7924;">execute</span><span style="color: whitesmoke;">&nbsp;</span>&quot;:source &quot;<span style="color: whitesmoke;">&nbsp;</span><span style="color: #ce7924;">.</span><span style="color: whitesmoke;">&nbsp;</span>&quot;/Users/Yan/.opam/system/share/vim/syntax/ocp-indent.vim&quot;</div>
<div>
<br/></div>
</blockquote>
You can then do some cool stuff as kindly shared <a href="http://stackoverflow.com/a/17234163" target="_blank">here</a> by <a href="http://stackoverflow.com/users/50926/thomas-leonard" target="_blank">Thomas Leonard</a>:<br/>
<br/>
<blockquote class="tr_bq">
<div style="border: 0px; clear: both; color: #222222; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; font-size: 15px; line-height: 19px; margin-bottom: 1em; padding: 0px;">
Then you get some nice shortcuts:</div>
<ul style="border: 0px; color: #222222; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; font-size: 15px; line-height: 19px; list-style-image: initial; list-style-position: initial; margin: 0px 0px 1em 30px; padding: 0px;">
<li style="border: 0px; margin: 0px 0px 0.5em; padding: 0px; word-wrap: break-word;"><code style="background-color: #eeeeee; border: 0px; font-family: Consolas, Menlo, Monaco, 'Lucida Console', 'Liberation Mono', 'DejaVu Sans Mono', 'Bitstream Vera Sans Mono', 'Courier New', monospace, sans-serif; font-size: 13px; margin: 0px; padding: 1px 5px; white-space: pre-wrap;">\s</code>&nbsp;switches between the .ml and .mli file</li>
<li style="border: 0px; margin: 0px 0px 0.5em; padding: 0px; word-wrap: break-word;"><code style="background-color: #eeeeee; border: 0px; font-family: Consolas, Menlo, Monaco, 'Lucida Console', 'Liberation Mono', 'DejaVu Sans Mono', 'Bitstream Vera Sans Mono', 'Courier New', monospace, sans-serif; font-size: 13px; margin: 0px; padding: 1px 5px; white-space: pre-wrap;">\c</code>&nbsp;comments the current line / selection (<code style="background-color: #eeeeee; border: 0px; font-family: Consolas, Menlo, Monaco, 'Lucida Console', 'Liberation Mono', 'DejaVu Sans Mono', 'Bitstream Vera Sans Mono', 'Courier New', monospace, sans-serif; font-size: 13px; margin: 0px; padding: 1px 5px; white-space: pre-wrap;">\C</code>&nbsp;to uncomment)</li>
<li style="border: 0px; margin: 0px 0px 0.5em; padding: 0px; word-wrap: break-word;"><code style="background-color: #eeeeee; border: 0px; font-family: Consolas, Menlo, Monaco, 'Lucida Console', 'Liberation Mono', 'DejaVu Sans Mono', 'Bitstream Vera Sans Mono', 'Courier New', monospace, sans-serif; font-size: 13px; margin: 0px; padding: 1px 5px; white-space: pre-wrap;">%</code>&nbsp;jumps to matching let/in, if/then, etc (see&nbsp;<code style="background-color: #eeeeee; border: 0px; font-family: Consolas, Menlo, Monaco, 'Lucida Console', 'Liberation Mono', 'DejaVu Sans Mono', 'Bitstream Vera Sans Mono', 'Courier New', monospace, sans-serif; font-size: 13px; margin: 0px; padding: 1px 5px; white-space: pre-wrap;">:h matchit-install</code>)</li>
<li style="border: 0px; margin: 0px 0px 0.5em; padding: 0px; word-wrap: break-word;"><code style="background-color: #eeeeee; border: 0px; font-family: Consolas, Menlo, Monaco, 'Lucida Console', 'Liberation Mono', 'DejaVu Sans Mono', 'Bitstream Vera Sans Mono', 'Courier New', monospace, sans-serif; font-size: 13px; margin: 0px; padding: 1px 5px; white-space: pre-wrap;">\t</code>&nbsp;tells you the type of the thing under the cursor (if you compiled with&nbsp;<code style="background-color: #eeeeee; border: 0px; font-family: Consolas, Menlo, Monaco, 'Lucida Console', 'Liberation Mono', 'DejaVu Sans Mono', 'Bitstream Vera Sans Mono', 'Courier New', monospace, sans-serif; font-size: 13px; margin: 0px; padding: 1px 5px; white-space: pre-wrap;">-annot</code>)</li>
</ul>
<div style="border: 0px; clear: both; color: #222222; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; font-size: 15px; line-height: 19px; margin-bottom: 1em; padding: 0px;">
</div>
</blockquote>
Thomas also adds<br/>
<blockquote class="tr_bq">
<blockquote class="tr_bq">
&quot;Also, Vim can then parse the output of the compiler and jump to the correct location.&quot;</blockquote>
</blockquote>
However, he doesn't say how to do that. I searched the web and eventually figured it out. So here is what you need:<br/>
<br/>
<ol style="text-align: left;">
<li>Makefile to compile you code</li>
<li>Vim 7.4+ (earlier versions don't seem to support it.</li>
<li>and the knowledge how to use vim's quickfix</li>
</ol>
<div>
Let's tackle these one by one:</div>
<div>
<br/></div>
<div>
1. Here is a sample of a Makefile:</div>
<div>
<br/></div>
<br/>
<div style="background-color: black; color: whitesmoke; font-family: Courier; font-size: 14px;">
<span style="color: #34bbc7; font-variant-ligatures: no-common-ligatures;">NAME </span>= <name_of_your_project></name_of_your_project></div>
<div>
<div style="background-color: black; color: whitesmoke; font-family: Courier; font-size: 14px;">
<span style="color: #34bbc7; font-variant-ligatures: no-common-ligatures;">OCAMLBUILD </span>= ocamlbuild -use-ocamlfind &nbsp;-classic-display</div>
<div style="background-color: black; color: whitesmoke; font-family: Courier; font-size: 14px;">
<span style="color: #34bbc7; font-variant-ligatures: no-common-ligatures;">PACKAGES </span>= -package <required packages=""> -tag thread</required></div>
<div style="background-color: black; color: whitesmoke; font-family: Courier; font-size: 14px; min-height: 17px;">
<br/></div>
<div style="background-color: black; color: #34bbc7; font-family: Courier; font-size: 14px;">
all:</div>
<div style="background-color: black; color: #c33720; font-family: Courier; font-size: 14px;">
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <span style="color: #34bbc7; font-variant-ligatures: no-common-ligatures;">$(OCAMLBUILD)</span> <span style="color: #34bbc7; font-variant-ligatures: no-common-ligatures;">$(PACKAGES)</span> filename.byte&nbsp;</div>
<div style="background-color: black; color: whitesmoke; font-family: Courier; font-size: 14px; min-height: 17px;">
<br/></div>
<div style="background-color: black; color: #34bbc7; font-family: Courier; font-size: 14px;">
clean:</div>
<div style="background-color: black; color: #c33720; font-family: Courier; font-size: 14px;">
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; rm *.byte</div>
<div style="background-color: black; color: whitesmoke; font-family: Courier; font-size: 14px; min-height: 17px;">
<br/></div>
<div style="background-color: black; color: #34bbc7; font-family: Courier; font-size: 14px;">
test:&nbsp; &nbsp;</div>
<div style="background-color: black; color: #c33720; font-family: Courier; font-size: 14px;">
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <span style="color: #34bbc7; font-variant-ligatures: no-common-ligatures;">$(OCAMLBUILD)</span> <span style="color: #34bbc7; font-variant-ligatures: no-common-ligatures;">$(PACKAGES)</span> filename.byte&nbsp;</div>
<div style="background-color: black; color: whitesmoke; font-family: Courier; font-size: 14px; min-height: 17px;">
<br/></div>
<div style="background-color: black; color: #34bbc7; font-family: Courier; font-size: 14px;">
<br/></div>
</div>
<br/>
<br/>
2. Make sure you have an updated version of Vim.<br/>
<br/>
3. &nbsp;You can read the full documentation on it <a href="http://vimdoc.sourceforge.net/htmldoc/quickfix.html" target="_blank">here</a>, or check this quick and what I thought I useful, summary provided by this <a href="http://stackoverflow.com/a/1747286" target="_blank">stack overflow answer</a>&nbsp;- run: <b>make </b>and then:<br/>
<br/>
<pre style="background-color: #eeeeee; border: 0px; color: #222222; font-family: Consolas, Menlo, Monaco, 'Lucida Console', 'Liberation Mono', 'DejaVu Sans Mono', 'Bitstream Vera Sans Mono', 'Courier New', monospace, sans-serif; font-size: 13px; margin-bottom: 1em; max-height: 600px; overflow: auto; padding: 5px; width: auto; word-wrap: normal;"><code style="border: 0px; font-family: Consolas, Menlo, Monaco, 'Lucida Console', 'Liberation Mono', 'DejaVu Sans Mono', 'Bitstream Vera Sans Mono', 'Courier New', monospace, sans-serif; margin: 0px; padding: 0px; white-space: inherit;">:copen &quot; Open the quickfix window
:ccl   &quot; Close it
:cw    &quot; Open it if there are &quot;errors&quot;, close it otherwise (some people prefer this)
:cn    &quot; Go to the next error in the window
:cnf   &quot; Go to the first error in the next file</code></pre>
<br/>
That's all folks! Enjoy.</div>
<div>
<br/></div>
<div>
Please let me know if above helped you or you whether you encountered other issues so I can update the post accordingly.<br/>
<br/>
<a href="https://www.blogger.com/blogger.g?blogID=954580896613987338#r1"><sup>1&nbsp;</sup></a><span style="font-size: x-small;">After some issues with PATH variables in Eclipse, I am seriously considering converting to Vim.</span><br/>
<div>
<br/></div>
</div>
</div>


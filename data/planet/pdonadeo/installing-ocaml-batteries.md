---
title: Installing OCaml Batteries
description:
url: https://www.donadeo.net/post/2010/installing-batteries
date: 2010-12-13T22:55:00-00:00
preview_image:
featured:
authors:
- pdonadeo
---

<div>
<p class="noindent">In this post I want to help OCaml newcomers to install Batteries. The task is trivial under Linux, while it's a bit tricky under Windows, because OCaml still lacks a self-contained Windows installer.</p>

<p>My assumption is that the reader is a coder, so I will not explain <em>everything</em>&hellip; Let's start with the easy part: Linux.</p>

<h4>Linux</h4>
<p class="noindent">The installation of OCaml + Batteries under a Debian/Ubuntu system couldn't be easier, thanks the the hard work of the <a href="https://wiki.debian.org/Teams/OCamlTaskForce">Debian OCaml Task Force</a>. So open a terminal and type:</p>

<pre class="brush: bash">
$ sudo aptitude install ocaml-batteries-included
</pre>

<p>That's all for Debian/Ubuntu. I don't know how Fedora works, but I think it's easy to install Batteries using YUM, something like:</p>

<pre class="brush: bash">
$ yum install ocaml-batteries-included
</pre>

<p>If a RPM package for Batteries wasn't available, you could still install OCaml, Camomile (the Unicode library), and compile Batteries from sources, as described below for the Windows OS.</p>

<h4>Windows</h4>

<p class="noindent">As said, this OS still lacks a self contained installer which is in progress, at least for installing OCaml. Since <a href="https://caml.inria.fr/ocaml/release.en.html#id2268363">many OCaml versions</a> are available for Windows, with different <a href="https://caml.inria.fr/ocaml/portability.en.html#windows">pros and cons</a>, I had to decide which one to use, and I decided to follow the simplest path to reach the goal of installing all the stuff we need. The Cygwin port is by far the simplest way.</p>

<ol>

<li>Download <a href="https://www.cygwin.com/setup.exe">Cygwin setup</a> and double click the executable. In Windows Vista/7 (I made my test on a Windows 7 64bit box) you will be required to allow the program to be run a couple of times, as usual ;-) &hellip;</li>

<li>when the list of available packages appears, select: each and every package containing &quot;caml&quot; (see the screenshot below), and also <kbd>make</kbd>, <kbd>m4</kbd>, <kbd>libncurses-devel</kbd>, <kbd>git</kbd>, <kbd>wget</kbd> and <kbd>rlwrap</kbd>;

<br/>

<a href="https://www.donadeo.net/static/2010/12/install_cygwin.png" title="Necessary Cygwin packages" class="zoom-box-image"><img src="https://www.donadeo.net/static/2010/12/install_cygwin_small.png" class="little left" alt="Necessary Cygwin packages"/></a>
<br style="clear:both;"/>
</li>

<li>open the Cygwin shell;</li>

<li>download the Findlib library, version 1.2.6:
<pre class="brush: bash">
$ wget https://download.camlcity.org/download/findlib-1.2.6.tar.gz
</pre>
</li>

<li>unpack, compile and install Findlib:
<pre class="brush: bash">
$ tar -xpzf findlib-1.2.6.tar.gz
$ cd findlib-1.2.6/
$ ./configure
$ make
$ make install
</pre>
</li>

<li>download, unpack, compile and install Camomile 0.8.1:
<pre class="brush: bash">
$ wget https://prdownloads.sourceforge.net/camomile/camomile-0.8.1.tar.bz2
$ tar -xpjf camomile-0.8.1.tar.bz2
$ cd camomile-0.8.1/
$ ./configure
$ make
$ make install
</pre>
</li>

<li>the last step is to download compile and install Batteries itself. I wasn't able to compile the latest stable release (1.2.2), for an obscure preprocessor error, but using the latest GIT branch everything went smoothly. So here are the steps:
<pre class="brush: bash">
$ git clone git://github.com/ocaml-batteries-team/batteries-included.git
$ cd batteries-included/
$ make camomile82
$ make all doc
$ make install install-doc
</pre>
</li>
</ol>

<h4>Testing the installation</h4>

<p class="noindent">Before starting to play with the library and the <em>toplevel</em> (the OCaml <a href="https://en.wikipedia.org/wiki/Read-eval-print_loop">REPL</a> is called toplevel) let's put into action a couple of helpers.</p>

<ol>

<li>The OCaml toplevel doesn't support readline. To get this feature back we add an alias to <kbd>.bashrc</kbd>. This works in both Linux and Windows:

<pre class="brush: bash">
alias ocaml='rlwrap -H /home/paolo/.ocaml_history -D 2 -i -s 10000 ocaml'
</pre>

restart the terminal or load another bash;
</li>

<li>we need to load Batteries in the toplevel. This is not strictly necessary, but it helps a lot and the Batteries ASCII logo is wonderful <kbd>:-)</kbd>. All we need is to create a file named <kbd>.ocamlinit</kbd> in the home directory. Open your favorite editor and put this <em>phrases</em> in <kbd>~/.ocamlinit</kbd>:

<pre class="brush: ocaml">
let interactive = !Sys.interactive;;
Sys.interactive := false;; (*Pretend to be in non-interactive mode*)
#use &quot;topfind&quot;;;
Sys.interactive := interactive;; (*Return to regular interactive mode*)

Toploop.use_silently 
             Format.err_formatter (Filename.concat (Findlib.package_directory 
             &quot;batteries&quot;) &quot;battop.ml&quot;);;
</pre>
</li>
</ol>

<p>If everything went well you can now type <kbd>ocaml</kbd> and something like this should appear:</p>

<pre style="background-color: #fffdbf; font-weight: bold;">
$ ocaml
        Objective Caml version 3.11.2

      _________________________
    [| +   | |   Batteries   - |
     |_____|_|_________________|
      _________________________
     | -  Type '#help;;' | | + |]
     |___________________|_|___|


Loading syntax extensions...
	Camlp4 Parsing version 3.11.2
</pre>

<h4>Conclusions</h4>

<p class="noindent">This (rather boring) post has been devoted to the installation details of Batteries under Windows, where it presents some difficulties for newbies. Next time we will start on exploring the library with simple examples to exploit its strength.</p>
</div>

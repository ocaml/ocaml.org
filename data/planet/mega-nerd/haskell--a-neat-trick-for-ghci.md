---
title: 'Haskell : A neat trick for GHCi'
description:
url: http://www.mega-nerd.com/erikd/Blog/CodeHacking/Haskell/ghci-trick.html
date: 2014-10-17T22:16:00-00:00
preview_image:
featured:
authors:
- mega-nerd
---



<p>
Just found a really nice little hack that makes working in the GHC interactive
	<a href="https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop">REPL</a>
a little easier and more convenient.
First of all, I added the following line to my <b><tt>~/.ghci</tt></b> file.
</p>

<pre class="code">

  :set -DGHC_INTERACTIVE

</pre>

<p>
All that line does is define a <b><tt>GHC_INTERACTIVE</tt></b> pre-processor
symbol.
</p>

<p>
Then in a file that I want to load into the REPL, I need to add this to the top
of the file:
</p>

<pre class="code">

  {-# LANGUAGE CPP #-}

</pre>

<p>
and then in the file I can do things like:
</p>

<pre class="code">

  #ifdef GHC_INTERACTIVE
  import Data.Aeson.Encode.Pretty

  prettyPrint :: Value -&gt; IO ()
  prettyPrint = LBS.putStrLn . encodePretty
  #endif

</pre>

<p>
In this particular case, I'm working with some relatively large chunks of JSON
and its useful to be able to pretty print them when I'm the REPL, but I have
no need for that function when I compile that module into my project.
</p>



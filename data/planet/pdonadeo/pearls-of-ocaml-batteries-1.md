---
title: Pearls of OCaml Batteries (1)
description:
url: https://www.donadeo.net/post/2010/batteries-1
date: 2010-12-05T15:15:00-00:00
preview_image:
featured:
authors:
- pdonadeo
---

<div>
<img src="https://www.donadeo.net/static/2010/11/batteries_logo.png" class="little left" alt="OCaml Batteries logo"/>

<p class="noindent"><a href="https://caml.inria.fr/ocaml/index.en.html">OCaml</a> is known to be a powerful functional programming language, but one of its presumed weakness is a relatively poor standard library.</p>

<p class="noindent">By accident, I'm one of the few people on the planet considering this very clean and virtually bug free library a feature and not a bug, but this is only an opinion.</p>

<p><a href="https://caml.inria.fr/pub/docs/manual-ocaml/manual034.html">The standard library</a> contains everything you need to build applications and other libraries, but it's <em>essential</em>, forget something like the Python standard library and things like &ldquo;sending an email in one line of code&rdquo;. Instead, think of the C standard library (plus some important data structures missing in the libc).</p>

<p>More than two years ago the OCaml community decided to start the development of a library containing all the conveniences that are missing in the standard library. The project is <a href="https://batteries.forge.ocamlcore.org/">OCaml Batteries Included</a> and I'd like to introduce the reader with a series of posts, aimed to cast a light on various aspects of the library, without pretending to be an exhaustive tutorial.</p>

<p>The posts will be targeted at novice OCaml programmers because I think that an experienced OCaml hacker already uses &quot;Batteries&quot; or, in any case, he understand the library API and doesn't need help from this blog.</p>

<p>Before starting with the (boring) installation details, I want to give you a taste of Batteries, to show how a simple task could be written in a more natural way using Batteries modules, in comparison with a <em>vanilla</em> implementation. Let's take this simple task: we want to read a file by lines and print on the terminal only those lines containing a particular substring.</p>

<p>A simple and actually working solution is proposed by the <a href="https://pleac.sourceforge.net/pleac_ocaml/">PLEAC-Objective CAML</a> project, it's the very first example of the <a href="https://pleac.sourceforge.net/pleac_ocaml/fileaccess.html">file access</a> section. Here is the proposed code:</p>

<pre class="brush: ocaml;">
let () =
  let in_channel = open_in &quot;/usr/local/widgets/data&quot; in
  try
    while true do
      let line = input_line in_channel in
      try
        ignore (Str.search_forward (Str.regexp_string &quot;blue&quot;) line 0);
        print_endline line
      with Not_found -&gt; ()
    done
  with End_of_file -&gt;
    close_in in_channel
</pre>

<p class="noindent">Now let's rephrase using Batteries:</p>

<pre class="brush: ocaml;">
Enum.iter
  (fun l -&gt;
    if BatString.exists l &quot;blue&quot;
    then print_endline l)
  (open_in &quot;/usr/local/widgets/data&quot; |&gt; BatIO.lines_of)
</pre>

<p class="noindent">The result is the same, but the code is much cleaner and far more idiomatic for a functional language.</p>

<p>Next time we will see how to install OCaml and Batteries, under Linux of course, but hopefully even under Windows.</p></div>

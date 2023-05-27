---
title: Why is virt-builder written in OCaml?
description: "Docker is written in Go. virt-builder is written in OCaml. Why? (Or
  as someone at work asked me \u2014 apparently seriously \u2014 why did you write
  it in a language which only you can use?) Virt\u2026"
url: https://rwmj.wordpress.com/2013/11/11/why-is-virt-builder-written-in-ocaml/
date: 2013-11-11T15:00:42-00:00
preview_image: http://libguestfs.org/virt-builder.svg
featured:
authors:
- rjones
---

<p><img src="https://i0.wp.com/libguestfs.org/virt-builder.svg" width="250" style="float:right;"/></p>
<p><a href="https://news.ycombinator.com/item?id=6709517">Docker is written in Go.</a>  <a href="http://libguestfs.org/virt-builder.1.html">virt-builder</a> is written in OCaml.  Why?  (Or as someone at work asked me &mdash; apparently seriously &mdash; why did you write it in a language which only you can use?)</p>
<p>Virt-builder is a fairly thin wrapper around <a href="http://libguestfs.org">libguestfs</a> and libguestfs has bindings for a dozen languages, and I&rsquo;m pretty handy in most programming languages, so it could have been done in Python or C or even Go.  In this case there are reasons why OCaml is a much better choice:</p>
<ul>
<li> It&rsquo;s a language I&rsquo;m familiar with and happy programming in.  Never underestimate how much that matters.
</li><li> OCaml is strongly typed, helping to eliminate many errors.  If it had been written in Python we&rsquo;d be running into bugs at customer sites that could have been eliminated by the compiler before anything shipped.  That doesn&rsquo;t mean virt-builder is bug free, but if the compiler can help to remove a bug, why not have the compiler do that?
</li><li> Virt-builder has to be fast, and OCaml is fast.  Python is fucking slow.
</li><li> I had some C code for doing <a href="http://git.annexia.org/?p=pxzcat.git%3Ba=summary">parallel xzcat</a> and with OCaml I can just link the C code and the OCaml code together directly into a single native binary.  Literally you just mix C object files and OCaml object files together on the linker command line.  Doing this in, say, Perl/Python/Ruby would be far more hassle.  We would have ended up with either a slow interpreted implementation, or having to ship a separate .so file and have the virt-builder program find it and dynamically load it.  Ugh.
</li><li> There was a little bit of common code used by another utility called <a href="http://libguestfs.org/virt-sysprep.1.html">virt-sysprep</a> which started out as a shell script but is now also written in OCaml.  Virt-sysprep regularly gets outside contributions, despite being written in OCaml.  I could have written the small amount of common code in C to get around this, but every little helps.
</li></ul>
<p>Is OCaml a language that only I can understand?  Judge for yourself by <a href="https://github.com/libguestfs/libguestfs/blob/master/builder/builder.ml">looking at the source code</a>.  I think if you cannot understand that enough to at least make small changes, you should hand in your programmer&rsquo;s card at the door.</p>
<p>Edit: <a href="https://news.ycombinator.com/item?id=6711893">Hacker News discussion of this article</a>.</p>


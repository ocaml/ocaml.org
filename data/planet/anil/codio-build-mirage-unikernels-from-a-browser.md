---
title: 'Codio: build Mirage unikernels from a browser'
description: Build Mirage unikernels from a browser with Codio's OPAM support and
  interactive Ubuntu shell.
url: https://anil.recoil.org/notes/codio-now-has-opam-support
date: 2014-03-26T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<p>I noticed an offhand tweet from Phil Tomson about <a href="http://codio.com/">Codio</a> adding OPAM support, and naturally had to take a quick look. I was <em>really</em> impressed by the whole process, and ended up building the <a href="https://web.archive.org/web/20170914182531/http://www.openmirage.org/wiki/mirage-www">Mirage Xen website</a> unikernel directly from my web browser in less than a minute, including registration!</p>
<ul>
<li>I signed up to Codio for free (since it’s <a href="https://web.archive.org/web/20170914182531/https://codio.com/avsm/Mirage-WWW/">a public project</a>) using GitHub oAuth (only public identity access required at first, no repository access).</li>
<li>Selected a <code>git</code> project and pointed it at the <a href="https://web.archive.org/web/20170914182531/https://github.com/mirage/mirage-www">mirage-www</a> repository.</li>
<li>At this point, you get the usual file explorer and code editor view in your browser. The magic begins when you go to “Tools/Terminal”, and an interactive Ubuntu shell pops up. Since Codio added <a href="https://web.archive.org/web/20170914182531/https://codio.com/s/blog/2014/03/new-parts/">opam support</a>, setting up the Mirage environment is a breeze:</li>
</ul>
<blockquote>
<p>I notice Codio supports OCaml and opam on the server side now.
— phil tomson (@philtor)
<a href="https://web.archive.org/web/20170914182531/https://twitter.com/philtor/statuses/448884571950444545">March 26, 2014</a></p>
</blockquote>
<pre><code class="language-bash">$ parts install opam
$ opam init -a
$ eval `opam config env`
$ opam install mirage-www -y
$ make MODE=xen
</code></pre>
<p>Then have a cup of coffee while the box builds, and you have a <code>mir-www.xen</code>, all from your web browser! Codio has a number of deployment options available too, so you should be able to hook up a <a href="https://web.archive.org/web/20170914182531/http://amirchaudhry.com/from-jekyll-to-unikernel-in-fifty-lines/">Git-based workflow</a> using some combination of Travis or other CI service.</p>
<p>This is the first time I’ve ever been impressed by an online editor, and might consider moving away from my beloved vi...</p>


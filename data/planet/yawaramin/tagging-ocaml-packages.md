---
title: Tagging OCaml packages
description: How to tag your opam packages for better searchability
url: https://dev.to/yawaramin/tagging-ocaml-packages-11dg
date: 2023-12-31T22:38:45-00:00
preview_image: https://media2.dev.to/dynamic/image/width=1000,height=500,fit=cover,gravity=auto,format=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Frlm1xr347xxtt7q8e04d.png
authors:
- Yawar Amin
source:
ignore:
---

<h2>
  
  
  TL;DR
</h2>

<p>Add <code>(tags (org:your-github-username))</code> to your <code>dune-project</code> file's <code>package</code> stanza.</p>

<h2>
  
  
  About
</h2>

<p>OCAML's opam package manager has an unfortunately little-known feature calling 'tagging'. This allows you to give 'tags' or 'labels' to your packages and search using those tags. This works a lot like popular blogging platforms, like dev.to in fact! And even better, the OCaml.org website package search can already search for tags: <a href="https://ocaml.org/packages/search?q=tag:%22org:erratique%22">https://ocaml.org/packages/search?q=tag:%22org:erratique%22</a></p>

<p>That's an example of searching for the <code>org:erratique</code> tag, which will find all packages by <a href="https://erratique.ch/contact.en">Daniel Bünzli</a>, who meticulously tags his OCaml packages. In fact the <code>org:</code> prefix for tags is specifically reserved for the 'organization' (or person) who publishes the package: <a href="https://opam.ocaml.org/doc/Manual.html#opamfield-tags">https://opam.ocaml.org/doc/Manual.html#opamfield-tags</a></p>

<h2>
  
  
  How to tag
</h2>

<p>If you are using the <a href="https://dune.build/">dune</a> build system, add the tag(s) to your <code>dune-project</code> file's <code>package</code> stanza. E.g.:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight plaintext"><code>
(package
 (name dream-html)
 (synopsis "HTML generator eDSL for Dream")
 (description
  "Write HTML directly in your OCaml source files with editor support.")
 (documentation "https://yawaramin.github.io/dream-html/")
 (tags (org:yawaramin))
 (depends
  (dream
   (&gt;= 1.0.0~alpha3))))
</code></pre>

</div>



<p>Of course, you can add multiple tags, e.g. <code>(tags (tag1 tag2 tag3))</code>. Refer to <a href="https://dune.readthedocs.io/en/stable/dune-files.html#field-package-tags">https://dune.readthedocs.io/en/stable/dune-files.html#field-package-tags</a> for the documentation.</p>

<p>Make sure you run <code>dune build</code> so that dune regenerates the package's <code>opam</code> file. Now, commit these changes and the next time you <a href="https://ocaml.org/docs/publishing-packages-w-dune">publish your package</a> on opam, these tags will appear and be searchable, e.g. <a href="https://ocaml.org/packages/search?q=tag:%22org:your-github-username%22">https://ocaml.org/packages/search?q=tag:%22org:your-github-username%22</a></p>

<h2>
  
  
  Namespacing
</h2>

<p>You might have realized that I am specifically recommending adding the <code>org:</code> tag with high priority, because it enables an ad-hoc form of namespacing. The opam registry doesn't auto-enforce namespacing, of course, but you can always appeal to the registry maintainers if you think someone is squatting on your namespace.</p>

<h2>
  
  
  Searchability
</h2>

<p>Of course, namespacing is not the only benefit–you also improve the searchability of the opam registry by adding this metadata to your projects. For example, if people are looking for web-related projects, they might search for <code>tag:"web"</code> etc. This will benefit the entire OCaml ecosystem. And even better, it's really easy to do.</p>



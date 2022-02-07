---
title: Dune 1.9.0
description: "Tarides is pleased to have contributed to the dune 1.9.0 release which\nintroduces
  the concept of library variants. Thanks to this update\u2026"
url: https://tarides.com/blog/2019-04-10-dune-1-9-0
date: 2019-04-10T00:00:00-00:00
preview_image: https://tarides.com/static/a7294df7159db3785da6121fc6ecadf8/10057/sand_dune2.jpg
featured:
---

<p>Tarides is pleased to have contributed to the dune 1.9.0 release which
introduces the concept of library variants. Thanks to this update,
unikernels builds are becoming easier and faster in the MirageOS
universe! This also opens the door for a better cross-compilation
story, which will ease the addition of new MirageOS backends
(trustzone, ESP32, RISC-V, etc.)</p>
<p><em>This post has also been posted to the
<a href="https://dune.build/blog/dune-1-9-0/">Dune blog</a>.  See also the <a href="https://discuss.ocaml.org/t/ann-dune-1-9-0/3646">the discuss
forum</a> for more
details.</em></p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#dune-190" aria-label="dune 190 permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Dune 1.9.0</h1>
<p>Changes include:</p>
<ul>
<li>Coloring in the watch mode (<a href="https://github.com/ocaml/dune/pull/1956">#1956</a>)</li>
<li><code>$ dune init</code> command to create or update project boilerplate (<a href="https://github.com/ocaml/dune/pull/1448">#1448</a>)</li>
<li>Allow &quot;.&quot; in c_names and cxx_names (<a href="https://github.com/ocaml/dune/pull/2036">#2036</a>)</li>
<li>Experimental Coq support</li>
<li>Support for library variants and default implementations (<a href="https://github.com/ocaml/dune/pull/1900">#1900</a>)</li>
</ul>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#variants" aria-label="variants permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Variants</h1>
<p>In dune 1.7.0, the concept of virtual library was introduced:
<a href="https://dune.build/blog/virtual-libraries/">https://dune.build/blog/virtual-libraries/</a>. This feature allows to
mark some abstract library as virtual, and then have several
implementations for it. These implementations could be for multiple
targets (<code>unix</code>, <code>xen</code>, <code>js</code>), using different algorithms, using C
code or not. However each implementation in a project dependency tree
had to be manually selected. Dune 1.9.0 introduces features for
automatic selection of implementations.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#library-variants" aria-label="library variants permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Library variants</h2>
<p>Variants is a tagging mechanism to select implementations on the final
linking step. There's not much to add to make your implementation use
variants. For example, you could decide to design a <code>bar_js</code> library
which is the javascript implementation of <code>bar</code>, a virtual
library. All you need to do is specificy a <code>js</code> tag using the
<code>variant</code> option.</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">(library
 (name bar_js)
 (implements bar)
 (variant js)); &lt;-- variant specification</code></pre></div>
<p>Now any executable that depend on <code>bar</code> can automatically select the
<code>bar_js</code> library variant using the <code>variants</code> option in the dune file.</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">(executable
 (name foo)
 (libraries bar baz)
 (variants js)); &lt;-- variants selection</code></pre></div>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#common-variants" aria-label="common variants permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Common variants</h2>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#language-selection" aria-label="language selection permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Language selection</h3>
<p>In your projects you might want to trade off speed for portability:</p>
<ul>
<li><code>ocaml</code>: pure OCaml</li>
<li><code>c</code>: OCaml accelerated by C</li>
</ul>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#javascript-backend" aria-label="javascript backend permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>JavaScript backend</h3>
<ul>
<li><code>js</code>: code aiming for a Node backend, using <code>Js_of_ocaml</code></li>
</ul>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#mirage-backends" aria-label="mirage backends permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Mirage backends</h2>
<p>The Mirage project (<a href="https://mirage.io/">mirage.io</a>) will make
extensive use of this feature in order to select the appropriate
dependencies according to the selected backend.</p>
<ul>
<li><code>unix</code>: Unikernels as Unix applications, running on top of <code>mirage-unix</code></li>
<li><code>xen</code>: Xen backend, on top of <code>mirage-xen</code></li>
<li><code>freestanding</code>: Freestanding backend, on top of <code>mirage-solo5</code></li>
</ul>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#default-implementation" aria-label="default implementation permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Default implementation</h2>
<p>To facilitate the transition from normal libraries into virtuals ones,
it's possible to specify an implementation that is selected by
default. This default implementation is selected if no implementation
is chosen after variant resolution.</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">(library
 (name bar)
 (virtual_modules hello)
 (default_implementation bar_unix)); &lt;-- default implementation selection</code></pre></div>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#selection-mechanism" aria-label="selection mechanism permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Selection mechanism</h2>
<p>Implementation is done with respect to some priority rules:</p>
<ul>
<li>manual selection of an implementation overrides everything</li>
<li>after that comes selection by variants</li>
<li>finally unimplemented virtual libraries can select their default implementation</li>
</ul>
<p>Libraries may depend on specific implementations but this is not
recommended. In this case, several things can happen:</p>
<ul>
<li>the implementation conflicts with a manually selected implementation: resolution fails.</li>
<li>the implementation overrides variants and default implementations: a cycle check is done and this either resolves or fails.</li>
</ul>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#conclusion" aria-label="conclusion permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Conclusion</h2>
<p>Variant libraries and default implementations are fully <a href="https://dune.readthedocs.io/en/latest/variants.html">documented
here</a>. This
feature improves the usability of virtual libraries.</p>
<p>This
<a href="https://github.com/dune-universe/mirage-entropy/commit/576d25d79e3117bba64355ae73597651cfd27631">commit</a>
shows the amount of changes needed to make a virtual library use
variants.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#coq-support" aria-label="coq support permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Coq support</h1>
<p>Dune now supports building Coq projects. To enable the experimental Coq
extension, add <code>(using coq 0.1)</code> to your <code>dune-project</code> file. Then,
you can use the <code>(coqlib ...)</code> stanza to declare Coq libraries.</p>
<p>A typical <code>dune</code> file for a Coq project will look like:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">(include_subdirs qualified) ; Use if your development is based on sub directories

(coqlib
  (name Equations)                  ; Name of wrapper module
  (public_name equations.Equations) ; Generate an .install file
  (synopsis &quot;Equations Plugin&quot;)     ; Synopsis
  (libraries equations.plugin)      ; ML dependencies (for plugins)
  (modules :standard \ IdDec)       ; modules to build
  (flags -w -notation-override))    ; coqc flags</code></pre></div>
<p>See the <a href="https://github.com/ocaml/dune/blob/1.9/doc/coq.rst">documentation of the
extension</a> for more
details.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#credits" aria-label="credits permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Credits</h1>
<p>This release also contains many other changes and bug fixes that can
be found on the <a href="https://discuss.ocaml.org/t/ann-dune-1-9-0/3646">discuss
announce</a>.</p>
<p>Special thanks to dune maintainers and contributors for this release:
<a href="https://github.com/rgrinberg">@rgrinberg</a>,
<a href="https://github.com/emillon">@emillon</a>,
<a href="https://github.com/shonfeder">@shonfeder</a>
and <a href="https://github.com/ejgallego">@ejgallego</a>!</p>

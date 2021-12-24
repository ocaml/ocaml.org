---
title: Dune 1.2.0
description: "After a tiny but important patch release as 1.1.1, the dune team is
  thrilled to\nannounce the release of dune 1.2.0! Here are some highlights\u2026"
url: https://tarides.com/blog/2018-09-06-dune-1-2-0
date: 2018-09-06T00:00:00-00:00
preview_image: https://tarides.com[object Object]
---

<p>After a tiny but important patch release as 1.1.1, the dune team is thrilled to
announce the release of dune 1.2.0! Here are some highlights of the new
features in that version. The full list of changes can be found <a href="https://github.com/ocaml/dune/blob/e3af33b43a87d7fa2d15f7b41d8bd942302742ec/CHANGES.md#120-14092018">in the dune
repository</a>.</p>
<h1 id="watch-mode" style="position:relative;"><a href="#watch-mode" aria-label="watch mode permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Watch mode</h1>
<p>When developing, it is common to edit a file, run a build, read the error
message, and fix the error. Since this is a very tight loop and developers are
doing this hundreds or thousands times a day, it is crucial to have the
quickest feedback possible.</p>
<p><code>dune build</code> and <code>dune runtest</code> now accept <a href="https://dune.readthedocs.io/en/latest/usage.html#watch-mode">a <code>-w</code>
flag</a> that will
watch the filesystem for changes, and trigger a new build.</p>
<h1 id="better-error-messages" style="position:relative;"><a href="#better-error-messages" aria-label="better error messages permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Better error messages</h1>
<p>Inspired by the great work done in
<a href="http://elm-lang.org/blog/compiler-errors-for-humans">Elm</a> and
<a href="https://reasonml.github.io/blog/2017/08/25/way-nicer-error-messages.html">bucklescript</a>,
dune now displays the relevant file in error messages.</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text"> % cat dune
(executable
 (name my_program)
 (librarys cmdliner)
)
 % dune build
File "dune", line 3, characters 2-10:
3 |  (librarys cmdliner)
      ^^^^^^^^
Error: Unknown field librarys
Hint: did you mean libraries?</code></pre></div>
<p>Many messages have also been improved, in particular to help users <a href="https://dune.readthedocs.io/en/latest/migration.html#check-list">switching
from the <code>jbuild</code> format to the <code>dune</code>
format</a>.</p>
<h1 id="dune-unstable-fmt" style="position:relative;"><a href="#dune-unstable-fmt" aria-label="dune unstable fmt permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>dune unstable-fmt</h1>
<p>Are you confused about how to format S-expressions? You are not alone.
That is why we are gradually introducing a formatter for <code>dune</code> files. It can
transform a valid but ugly <code>dune</code> into one that is consistently formatted.</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text"> % cat dune
(executable( name ls) (libraries cmdliner)
(preprocess (pps ppx_deriving.std)))
 % dune unstable-fmt dune
(executable
 (name ls)
 (libraries cmdliner)
 (preprocess
  (pps ppx_deriving.std)
 )
)</code></pre></div>
<p>This feature is not ready yet for the end user (hence the <code>unstable</code> part),
and in particular the concrete syntax is not stable yet.
But having it already in the code base will make it possible to build useful
integrations with <code>dune</code> itself (to automatically reformat all dune files in a
project, for example) and common editors, so that they format <code>dune</code> files on
save.</p>
<h1 id="first-class-support-of-findlib-plugins" style="position:relative;"><a href="#first-class-support-of-findlib-plugins" aria-label="first class support of findlib plugins permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>First class support of findlib plugins</h1>
<p>It is now easy to support findlib plugins by just adding the <code>findlib.dynload</code>
library dependency. Then you can use <code>Fl_dynload</code> module in your code which
will automatically do the right thing. <a href="https://dune.readthedocs.io/en/latest/advanced-topics.html#dynamic-loading-of-packages">A complete example can be found in the
dune manual</a>.</p>
<h1 id="promote-only-certain-files" style="position:relative;"><a href="#promote-only-certain-files" aria-label="promote only certain files permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Promote only certain files</h1>
<p>The <code>dune promote</code> command now accept a list of files. This is useful to
promote just the file that is opened in a text editor for example. Some emacs
bindings are provided to do this, which works particularly well with
<a href="https://dune.readthedocs.io/en/latest/tests.html#inline-expectation-tests">inline expectation tests</a>.</p>
<h1 id="deprecation-message-for-wrapped-modes" style="position:relative;"><a href="#deprecation-message-for-wrapped-modes" aria-label="deprecation message for wrapped modes permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Deprecation message for (wrapped) modes</h1>
<p>By default, libraries are <code>(wrapped true)</code>, which means that they expose a
single OCaml module (source files are exposed as submodules of this main
module). This is usually desired as it makes link-time name collisions less
likely. However, a lot of libraries are using <code>(wrapped false)</code> (expose all
source files as modules) to keep compatibility.</p>
<p>It can be challenging to transition from <code>(wrapped false)</code> to <code>(wrapped true)</code>
because it breaks compatibility. That is why we have added <code>(wrapped (transition "message"))</code> which will generate wrapped modules but keep unwrapped
modules with a deprecation message to help coordinate the change.</p>
<h1 id="credits" style="position:relative;"><a href="#credits" aria-label="credits permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Credits</h1>
<p>Special thanks to our contributors for this release: @aantron, @anuragsoni,
@bobot, @ddickstein, @dra27, @drjdn, @hongchangwu, @khady, @kodek16,
@prometheansacrifice and @ryyppy.</p>

---
title: OCamlFormat 0.8
description: "We are proud to announce the release of OCamlFormat 0.8 (available on
  opam). To ease the transition from the previous 0.7 release here are\u2026"
url: https://tarides.com/blog/2018-10-17-ocamlformat-0-8
date: 2018-10-17T00:00:00-00:00
preview_image: https://tarides.com/static/9b70dfbba6abba837b47f644a75b33dc/0132d/code_black1.jpg
featured:
---

<p>We are proud to announce the release of OCamlFormat 0.8 (available on opam). To ease the transition from the previous 0.7 release here are some highlights of the new features of this release. The <a href="https://github.com/ocaml-ppx/ocamlformat/blob/v0.8/CHANGES.md#08-2018-10-09">full changelog</a> is available on the project repository.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#precedence-of-options" aria-label="precedence of options permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Precedence of options</h1>
<p>In the previous version you could override command line options with <code>.ocamlformat</code> files configuration. 0.8 fixed this so that the OCamlFormat configuration is first established by reading <code>.ocamlformat</code> and <code>.ocp-indent</code> files:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">margin = 77
wrap-comments = true</code></pre></div>
<p>By default, these files in current and all ancestor directories for each input file are used, as well as the global configuration defined in <code>$XDG_CONFIG_HOME/ocamlformat</code>. The global <code>$XDG_CONFIG_HOME/ocamlformat</code> configuration has the lowest priority, then the closer the directory is to the processed file, the higher the priority. In each directory, both <code>.ocamlformat</code> and <code>.ocp-indent</code> files are read, with <code>.ocamlformat</code> files having the higher priority.</p>
<p>For now <code>ocp-indent</code> options support is very partial and is expected to be extended in the future.</p>
<p>Then the parameters can be overriden with the <code>OCAMLFORMAT</code> environment variable:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">OCAMLFORMAT=field-space=tight,type-decl=compact</code></pre></div>
<p>and finally the parameters can be overriden again with the command lines parameters.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#reading-input-from-stdin" aria-label="reading input from stdin permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Reading input from stdin</h1>
<p>It is now possible to read the input from stdin instead of OCaml files. The following command invokes OCamlFormat that reads its input from the pipe:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">echo &quot;let f x = x + 1&quot; | ocamlformat --name a.ml -</code></pre></div>
<p>The <code>-</code> on the command line indicates that <code>ocamlformat</code> should read from stdin instead of expecting input files. It is then necessary to use the <code>--name</code> option to designate the input (<code>a.ml</code> here).</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#preset-profiles" aria-label="preset profiles permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Preset profiles</h1>
<p>Preset profiles allow you to have a consistent configuration without needing to tune every option.</p>
<p>Preset profiles set all options, overriding lower priority configuration. A preset profile can be set using the <code>--profile</code> (or <code>-p</code>) option. You can pass the option <code>--profile=&lt;name&gt;</code> on the command line or add <code>profile = &lt;name&gt;</code> in an <code>.ocamlformat</code> configuration file.</p>
<p>The available profiles are:</p>
<ul>
<li><code>default</code> sets each option to its default value</li>
<li><code>compact</code> sets options for a generally compact code style</li>
<li><code>sparse</code> sets options for a generally sparse code style</li>
<li><code>janestreet</code> is the profile used at JaneStreet</li>
</ul>
<p>To get a better feel of it, here is the formatting of the <a href="https://github.com/ocaml/ocaml/blob/trunk/typing/env.ml#L227-L234"><code>mk_callback</code></a> function from the OCaml compiler with the <code>compact</code> profile:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">let mk_callback rest name desc = function
  | None -&gt; nothing
  | Some f -&gt; (
      fun () -&gt;
        match rest with
        | [] -&gt; f name None
        | (hidden, _) :: _ -&gt; f name (Some (desc, hidden)) )</code></pre></div>
<p>then the same function formatted with the <code>sparse</code> profile:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">let mk_callback rest name desc = function
  | None -&gt;
      nothing
  | Some f -&gt;
      fun () -&gt;
        ( match rest with
        | [] -&gt;
            f name None
        | (hidden, _) :: _ -&gt;
            f name (Some (desc, hidden)) )</code></pre></div>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#project-root" aria-label="project root permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Project root</h1>
<p>The project root of an input file is taken to be the nearest ancestor directory that contains a <code>.git</code> or <code>.hg</code> or <code>dune-project</code> file.
If the new option <code>--disable-outside-detected-project</code> is set, <code>.ocamlformat</code> configuration files are not read outside of the current project. If no configuration file is found, formatting is disabled.</p>
<p>A new option, <code>--root</code> allows to specify the root directory for a project. If specified, OCamlFormat only takes into account <code>.ocamlformat</code> configuration files inside the root directory and its subdirectories.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#credits" aria-label="credits permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Credits</h1>
<p>This release also contains many other changes and bug fixes that we cannot detail here. Check out the <a href="https://github.com/ocaml-ppx/ocamlformat/blob/v0.8/CHANGES.md#08-2018-10-09">full changelog</a>.</p>
<p>Special thanks to our maintainers and contributors for this release: David Allsopp, Josh Berdine, Hugo Heuzard, Brandon Kase, Anil Madhavapeddy and Guillaume Petiot.</p>

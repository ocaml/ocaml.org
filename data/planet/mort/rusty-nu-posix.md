---
title: Rusty Nu POSIX
description: The GNU is Dead! Long Live the GNU!
url: https://mort.io/blog/nu-posix/
date: 2025-05-07T00:00:00-00:00
preview_image:
authors:
- Richard Mortier
source:
ignore:
keywords:
- better
- dua
- grep
- irritated
- man
- modern
- parser
- replacement
- replacements
- rust
---

<p>A slight delay to this post, but happily I now have no more lecturing to do
until 2027<sup class="footnote-reference"><a href="https://mort.io/blog/nu-posix/#fn-1">[1]</a></sup> :)</p>
<p>I switched a year or two ago to using NixOS as my daily driver following about
15 years as an increasingly irritated MacOS user. Shortly before I had become
interested in Rust as a systems programming language that seemed to marry
several things I like about OCaml with several other desirable things from C and
Python.</p>
<p>I then more recently observed something that I thought was interesting: there
seem to be a <strong>lot</strong> of recent replacements of what were once completely
standard and changeless POSIX utilities. I’m thinking things like <code>grep</code>,
<code>find</code>, <code>ls</code> and the like that I’ve been using uninterrupted, other than the
occasional quibble over whether it was the original version or the GNU version,
for about 30 years. Indeed, I have already raved (slightly) about
<a href="https://just.systems/" rel="external"><code>just</code></a> as a
<a href="https://www.gnu.org/software/make/manual/make.html" rel="external"><code>make</code></a> replacement and its
use with <a href="https://mort.io/blog/just-ocaml/">OCaml</a> and <a href="https://mort.io/blog/just-latex/">LaTeX</a>.</p>
<p>NixOS’ declarative configuration meant that I could actually see the list
growing, all in one place – I suspect on other systems I wouldn’t have noticed
in quite the same way because it would’ve been a much more incremental and
diffuse process of change without a clear record of the choices made.</p>
<p>I thus find in my
<a href="https://github.com/mor1/rc-files/blob/main/nixos/modules/home-manager/cli.nix#L44-L65" rel="external"><code>cli.nix</code></a>
config that describes the CLI tools I expect, to have the following collection:</p>
<pre class="giallo z-code"><code data-lang="nix"><span class="giallo-l"><span>      nu_posix</span><span class="z-10"> =</span><span> [</span></span>
<span class="giallo-l"><span>        bat</span><span class="z-3 z-i"> # better cat</span></span>
<span class="giallo-l"><span>        bottom</span><span class="z-3 z-i"> # btm ~ better top, htop, etc</span></span>
<span class="giallo-l"><span>        broot</span><span class="z-3 z-i"> # interactive directory navigation</span></span>
<span class="giallo-l"><span>        chafa</span><span class="z-3 z-i"> # terminal graphics viewer</span></span>
<span class="giallo-l"><span>        ctpv</span><span class="z-3 z-i"> # terminal file previewer</span></span>
<span class="giallo-l"><span>        cyme</span><span class="z-3 z-i"> # better `lsusb`</span></span>
<span class="giallo-l"><span>        delta</span><span class="z-3 z-i"> # better syntax highlighting diff</span></span>
<span class="giallo-l"><span>        dua</span><span class="z-3 z-i"> # disk usage, interactively</span></span>
<span class="giallo-l"><span>        eza</span><span class="z-3 z-i"> # improved `ls`</span></span>
<span class="giallo-l"><span>        fd</span><span class="z-3 z-i"> # `find` replacement</span></span>
<span class="giallo-l"><span>        fend</span><span class="z-3 z-i"> # better CLI calculator</span></span>
<span class="giallo-l"><span>        hexyl</span><span class="z-3 z-i"> # hex pretty printer</span></span>
<span class="giallo-l"><span>        htop</span><span class="z-3 z-i"> # graphical top</span></span>
<span class="giallo-l"><span>        iotop</span><span class="z-3 z-i"> # io top</span></span>
<span class="giallo-l"><span>        jujutsu</span><span class="z-3 z-i"> # better git</span></span>
<span class="giallo-l"><span>        just</span><span class="z-3 z-i"> # updated gnumake replacement</span></span>
<span class="giallo-l"><span>        procs</span><span class="z-3 z-i"> # better ps</span></span>
<span class="giallo-l"><span>        ripgrep</span><span class="z-3 z-i"> # rg ~ `grep` replacement</span></span>
<span class="giallo-l"><span>        sudo-rs</span><span class="z-3 z-i"> # memory-safe `sudo`</span></span>
<span class="giallo-l"><span>        uutils-coreutils-noprefix</span><span class="z-3 z-i"> # replaces GNU `coreutils`</span></span>
<span class="giallo-l"><span>        viddy</span><span class="z-3 z-i"> # better watch</span></span>
<span class="giallo-l"><span>      ]</span><span class="z-10">;</span></span></code></pre>
<p>I think that most, if not all, of these are written in Rust: that particular
language community seems to have a real enthusiasm for re-implementing
long-standing tools but better, and I have to say I really appreciate it! When I
say “better” I’m not particularly thinking of esoteric language features or
development ideologies either. I mean better in two very particular senses:</p>
<ol>
<li>
<p><strong>Usability</strong>. Many of the older tools simply did not have great user
interfaces and, when they were ok, they were not built using modern tooling.
As a result getting documentation was somewhere between good and great if
there was a decent <code>man</code>-page, with a range of potential switches for more
short form help or for cases where the <code>man</code>-page was not installed –
whether <code>-h</code>, <code>--help</code>, <code>-help</code>, <code>-?</code>, <code>help</code>, or something else. The
short-form help would, of course, be formatted in arbitrary ways.</p>
<p>The modern Rust-y replacements tend to use
<a href="https://docs.rs/clap/latest/clap/" rel="external"><code>clap</code></a> as a reasonably standard
command-line parser. As a result, they are remarkably consistent in usage and
format, typically producing something that looks a lot like <code>man</code>-page output
in response to their <code>-h|--help</code> switch. In a world where <code>man</code>-pages are
often an afterthought or, even worse, replaced by <code>info</code> documentation, I
find this invaluable. They are also generally inclined to make greater use of
modern terminal environments – <a href="https://github.com/eza-community/eza" rel="external"><code>eza</code></a>
as a replacement for
<a href="https://www.gnu.org/software/coreutils/manual/html_node/ls-invocation.html" rel="external"><code>ls</code></a>
is a good example of this.</p>
</li>
<li>
<p><strong>Performance</strong>. Old tools were originally built for old computers in old
languages (largely C) and, whether this is language ideology or just the
practicalities of engineering long-standing widely-used codebases, tended not
to be radically updated.</p>
<p>Rust re-implementations, on the other hand, are from scratch – and Rust’s
memory model appears to make it relatively easy for them to be made
multi-threaded. On modern hardware this seems to make them startlingly higher
performance than the alternatives. Tools I particularly appreciate for this
include <a href="https://github.com/sharkdp/fd" rel="external"><code>fd</code></a> replacing
<a href="https://www.gnu.org/software/findutils/" rel="external"><code>find</code></a> and <a href="https://github.com/BurntSushi/ripgrep" rel="external">ripgrep,
<code>rg</code>,</a> replacing
<a href="https://www.gnu.org/software/grep/" rel="external"><code>grep</code></a>.</p>
</li>
</ol>
<p>Perhaps the most immediate example of the benefits of this that I’ve experienced
is <a href="https://github.com/Byron/dua-cli" rel="external"><code>dua</code></a> via <code>dua i</code>. Traditionally, when
trying to clean up an uncomfortably full hard disk I would’ve ended up using
some manual iterative application of either <code>du -hS *</code> or possibly something
like <code>find ... | xargs du</code>. Or possibly written a Python script to do it for me.
And it would’ve taken <em>O</em>(hours) for me to find where the space was being used
and to do something about it. And I would’ve found it tedious and deeply
irritating.<sup class="footnote-reference"><a href="https://mort.io/blog/nu-posix/#fn-2">[2]</a></sup></p>
<p>In contrast, <code>dua i</code> gives me a TUI interface to navigate the filesystem from
wherever I run it, the ability to cumulatively mark files and directories for
trashing or immediate deletion, with subdirectory space summaries – and does so
across ~850GB / 3 million files in about 10-15 seconds without using any form of
caching, database, or other such thing. As far as I can tell, simply by being
efficient and multi-threaded.</p>
<p>If this is the future, sign me up. (At least for the bits like this that are
good.)</p>
<section class="footnotes">
<ol class="footnotes-list">
<li>
<p>…assuming I get back the same courses after my sabbatical that is. <a href="https://mort.io/blog/nu-posix/#fr-1-1">↩</a></p>
</li>
<li>
<p>I’m easily irritated. What can I say. <a href="https://mort.io/blog/nu-posix/#fr-2-1">↩</a></p>
</li>
</ol>
</section>

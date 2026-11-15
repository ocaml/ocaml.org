---
title: 'curry: a modern Emacs mode for Haskell'
description: Back in April I wrote about a month of Elisp and finished by mentioning
  that, having experienced neocaml (a modern Emacs mode for OCaml), I'd started writing
  a tree-sitter powered Emacs package for Haskell. That package is curry-mode, and
  I'm releasing version 0.1.0. curry-mode is a major mode for Haskell built on Emacs's
  built-in tree-sitter support.
url: https://lambdafoo.com/posts/2026-11-15-curry-mode.html
date: 2026-11-15T00:00:00-00:00
preview_image:
authors:
- Tim McGilchrist
source:
ignore:
keywords:
- curry-mode
- emacs
- ghc
- grammar
- haskell
- haskell-mode
- hls
- indentation
- mode
- tree-sitter
---

<div class="post">
  <h1 class="post-title">curry: a modern Emacs mode for Haskell</h1>
  <span class="post-date">November 15, 2026</span><p>Back in April I wrote about <a href="https://lambdafoo.com/posts/2026-04-23-a-month-of-elisp.html">a month of Elisp</a> and finished by mentioning that, having experienced <a href="https://github.com/bbatsov/neocaml">neocaml</a> (a modern Emacs mode for OCaml), I'd started writing a tree-sitter powered Emacs package for Haskell. That package is <a href="https://github.com/tmcgilchrist/curry-mode">curry-mode</a>, and I'm releasing <a href="https://github.com/tmcgilchrist/curry-mode/releases/tag/v0.1.0">version 0.1.0</a>.</p>
<p>curry-mode is a major mode for Haskell built on Emacs's built-in tree-sitter support. It provides font-locking (Emacs-speak for syntax highlighting), indentation, navigation, imenu (the buffer index you navigate with), a REPL (read-eval-print loop) using GHCi, the interactive environment of the Glasgow Haskell Compiler (GHC), and Cabal integration, and hands everything semantic (completion, go-to-definition, types on hover, code actions) to the <a href="https://github.com/haskell/haskell-language-server">Haskell Language Server</a> (HLS) via Eglot, the client for the Language Server Protocol (LSP) built into Emacs.</p>
<h2><a href="https://lambdafoo.com/rss.xml#why-another-haskell-mode" class="anchor" aria-hidden="true"></a>Why another Haskell mode?</h2>
<p>I started out using Emacs at University on SunOS SPARC machines. At the time I learnt both of the viable editors, vi and Emacs, but leant towards Emacs because of how far you could customise it. Over the years I've mostly used other people's packages and configuration, with detours into IDEs when Java or Scala demanded it. I'd never built a large mode from scratch, and the best way I know to learn something is by doing it.</p>
<p>There is already an official <a href="https://github.com/haskell/haskell-mode">haskell-mode</a> with many users and many features, so why build a new one? haskell-mode has grown complex over the years, bundling everything from indentation to a REPL to HLS interaction in one monolith. It has to, since it predates both tree-sitter in Emacs and language servers. With tree-sitter built into Emacs 29+ and HLS providing the semantic features over LSP, a modern Haskell mode can be dramatically simpler.</p>
<p>I'm not the first person to think this. haskell-mode issue <a href="https://github.com/haskell/haskell-mode/issues/1804">#1804</a> collects the attempts at a tree-sitter powered major mode for Haskell, including two separate <code>haskell-ts-mode</code> packages. There is <a href="https://github.com/erikbackman/haskell-ts-mode">erikbackman/haskell-ts-mode</a>, which is now archived, and <a href="https://codeberg.org/pranshu/haskell-ts-mode/">pranshu/haskell-ts-mode</a>. Neither attempt became popular enough to sustain the effort, and I thought I could do a better job by following the architecture of bbatsov's neocaml.</p>
<p>That architecture is a mode built in layers. At the bottom, curry-mode provides the syntax layer with highlighting, indentation, navigation and imenu, all from the tree-sitter AST, and works with nothing else installed. On top of that, HLS via Eglot adds the semantic layer with completion, types, diagnostics, code actions and formatting. All the good things you expect from an LSP.</p>
<p>Each layer should be useful on its own and each one above improves on, or replaces, what the layer below provides. You shouldn't need a running language server before Emacs can indent your code. If things go well, perhaps some of this can be folded back into haskell-mode once it no longer needs to support Emacs versions before 29.</p>
<h3><a href="https://lambdafoo.com/rss.xml#whats-in-a-name" class="anchor" aria-hidden="true"></a>What's in a name</h3>
<p>Naming is hard, and realistically this mode should be <code>haskell-ts-mode</code> the third, but that is a really terrible choice. Instead I named it after <a href="https://en.wikipedia.org/wiki/Haskell_Curry">Haskell Curry</a>, after whom both the language and the concept of currying are named. A delightfully intertwined name, I think.</p>
<h2><a href="https://lambdafoo.com/rss.xml#standing-on-neocamls-shoulders" class="anchor" aria-hidden="true"></a>Standing on neocaml's shoulders</h2>
<p>I closely modelled curry-mode on neocaml (and its sibling <a href="https://github.com/bbatsov/fsharp-ts-mode">fsharp-ts-mode</a>), so the packages share plenty of structural and stylistic similarities. Perhaps that's not surprising, since both are statically typed languages with an ML heritage. Borrowing his good ideas let me quickly tick off the basics, like a base mode with language-specific derived modes, the REPL integration pattern, and the build tool interaction pattern. Even imenu, code folding and navigation from tree-sitter started as fairly direct translations of the neocaml code. Hopefully bbatsov is fine with that.</p>
<p>bbatsov has also written up <a href="https://batsov.com/articles/2026/02/27/building-emacs-major-modes-with-treesitter-lessons-learned/">Building Emacs major modes with tree-sitter: lessons learned</a>, which covers many of the same lessons I learnt the hard way. If you're thinking of writing a tree-sitter mode, read that first. If only I'd checked his blog sooner it would have saved me some time.</p>
<p>So let's skip the similarities and talk about what's different about Haskell.</p>
<h2><a href="https://lambdafoo.com/rss.xml#what-you-get" class="anchor" aria-hidden="true"></a>What you get</h2>
<p>The 0.1.0 release covers the most common things you'd need in day to day Haskell work:</p>
<ul>
<li>Font-locking with 4 levels of detail for <code>.hs</code>, <code>.hsc</code> and <code>.hs-boot</code> files.</li>
<li>Indentation from tree-sitter rules, with region shifting (<code>C-c &gt;</code> / <code>C-c &lt;</code>) and the indentation offset guessed from the existing code.</li>
<li>Navigation by definition (<code>C-M-a</code> / <code>C-M-e</code>), by expression (<code>C-M-f</code> / <code>C-M-b</code>), by top-level declaration (<code>M-a</code> / <code>M-e</code> on Emacs 30+), and a jump to the import block and back (<code>M-g i</code>).</li>
<li>Imenu grouped into functions, types, classes, instances and imports.</li>
<li>A GHCi REPL (<code>curry-repl</code>) with tree-sitter highlighting of what you type, and commands to send definitions, regions or the whole buffer, reload, and ask for <code>:type</code> and <code>:info</code> at point.</li>
<li>Cabal integration with <code>curry-cabal-mode</code> for <code>.cabal</code> files, formatting with the cabal-fmt or cabal-gild formatters, and commands to run cabal build, test, run, repl and haddock (Haskell's documentation generator) from any Haskell buffer.</li>
<li>GHC errors in <code>M-x compile</code> output, so <code>M-g n</code> / <code>M-g p</code> jump to the source location.</li>
<li>Eglot registration for haskell-language-server.</li>
<li>Debugging with <a href="https://github.com/svaante/dape">dape</a>, an Emacs debugger client, and Well-Typed's <a href="https://github.com/well-typed/haskell-debugger">haskell-debugger</a> (experimental, needs GHC 9.14+).</li>
</ul>
<p>curry-mode doesn't provide completion, type lookup, Hoogle search (the Haskell API search engine), documentation browsing or code actions. HLS does those better than any Elisp I could write.</p>
<h2><a href="https://lambdafoo.com/rss.xml#how-much-simpler" class="anchor" aria-hidden="true"></a>How much simpler?</h2>
<p>I was curious whether "dramatically simpler" was true, so I counted lines. curry-mode is about 2,100 lines of Elisp against just over 20,000 for haskell-mode, roughly 10 times smaller. That number is a bit misleading, since haskell-mode includes plenty that curry-mode hands to HLS. Comparing the features both modes actually implement is a fairer comparison:</p>
<div role="region"><table>
<tbody><tr>
<th>Concern</th>
<th class="right">haskell-mode</th>
<th class="right">curry-mode</th>
<th class="right">Ratio</th>
</tr>
<tr>
<td>Font-locking</td>
<td class="right">1,219</td>
<td class="right">122</td>
<td class="right">~10x</td>
</tr>
<tr>
<td>Indentation</td>
<td class="right">2,870</td>
<td class="right">190</td>
<td class="right">~15x</td>
</tr>
<tr>
<td>REPL</td>
<td class="right">2,019</td>
<td class="right">357</td>
<td class="right">~6x</td>
</tr>
<tr>
<td>Cabal</td>
<td class="right">1,228</td>
<td class="right">611</td>
<td class="right">~2x</td>
</tr>
<tr>
<td>Mode, navigation, imenu</td>
<td class="right">1,874</td>
<td class="right">837</td>
<td class="right">~2x</td>
</tr>
</tbody></table></div><p>Tree-sitter shows up clearly in the first two rows. haskell-mode includes a hand-written lexer (<code>haskell-lexeme.el</code>) that copes with the layout rule, string gaps, character literals and pragmas, and adds font-lock keywords on top of it. curry-mode asks the tree-sitter syntax tree instead, and around 120 lines of <code>treesit-font-lock-rules</code> cover all four levels. For indentation, haskell-mode ships <em>two</em> indenters (<code>haskell-indent</code> and <code>haskell-indentation</code>), because Haskell layout is hard enough that neither one alone was enough. curry-mode has about 190 lines of <code>treesit-simple-indent-rules</code>. Again there is a gap in functionality in the indentation but really I think most developers would be better served by an external tool.</p>
<p>The REPL and Cabal savings come from leaning on what Emacs already provides (<code>comint</code>, <code>compile</code>) and on external tools like cabal-fmt, rather than from tree-sitter.</p>
<h2><a href="https://lambdafoo.com/rss.xml#working-with-tree-sitter" class="anchor" aria-hidden="true"></a>Working with tree-sitter</h2>
<p>Most of the size difference comes from tree-sitter. Once you have a syntax tree, font-locking is a set of queries (patterns matched against nodes in the tree) rather than a pile of regular expressions, and the same tree gives you navigation, imenu, folding and <a href="https://www.masteringemacs.org/article/combobulate-intuitive-structured-navigation-treesitter">Combobulate</a> support with little extra code. Combobulate is a package for structured navigation and editing that works across any language with a tree-sitter grammar. It also makes new features easier to add. Want to find all the tests in a file using the Tasty test framework? That's a query over the tree, not a parser you write yourself.</p>
<p>The Haskell grammar story is a little fragmented, though. The official <a href="https://github.com/tree-sitter/tree-sitter-haskell">tree-sitter/tree-sitter-haskell</a> is missing many bug fixes and newer GHC features. <a href="https://github.com/tek/tree-sitter-haskell">tek/tree-sitter-haskell</a> applies most of those fixes and is active, but doesn't commit the generated C parser that Emacs needs to build the grammar. So curry-mode uses <a href="https://github.com/tmcgilchrist/tree-sitter-haskell">my fork</a> of tek's, which adds the generated parser files, and installs it for you. I chose tek's grammar because it has the best language coverage, but I'd love for the fork to become unnecessary.</p>
<p>That leads to my bigger point, which is that a tree-sitter grammar is no longer optional for a language. GitHub code navigation, Emacs, Neovim, Helix, Zed and plenty of other tools are built on tree-sitter, so a good grammar matters as much as a good standard library or build tool. Ideally the grammar would track each GHC release, or even be mechanically derived from GHC's own parser. GHC Haskell keeps growing new syntax, and keeping editors working across versions raises the same problems that <a href="https://arxiv.org/abs/1610.04799">Trees that Grow</a>, the extensible AST design used inside GHC, tackles for the compiler.</p>
<p>I hit a few rough edges along the way. Tree-sitter ABI (application binary interface) versions are confusing. Emacs often supports ABI 14 as the lowest version, but you can build grammars with ABI 15, and since ABI 15 isn't backwards compatible with 14, loading the wrong one will SEGV your Emacs. curry-mode now checks the version of libtree-sitter (the tree-sitter C library Emacs is linked against) and gives a clear error instead. Grammar releases also tend to follow the tree-sitter tooling version rather than semver, so a minor version bump can bring major headaches. Finally, with tree-sitter the AST is your API, and an AST is never going to be particularly stable, so curry-mode warns you when the installed grammar is older than the one it expects.</p>
<h2><a href="https://lambdafoo.com/rss.xml#indentation" class="anchor" aria-hidden="true"></a>Indentation</h2>
<p>Haskell is whitespace sensitive, which makes indentation the hardest part of any Haskell mode. Unlike most languages, there is often more than one valid indentation for a line, and they mean different things. The first rule for curry-mode is to do no harm, so indenting a line should never break a program that was already correct. Beyond that, the tree-sitter rules aim to cover the common layouts like <code>do</code>, <code>where</code>, <code>let</code>, <code>case</code>, guards, records and the rest of the everyday code I write. Where the rules get it wrong there is an escape hatch. <code>curry-cycle-indent</code> switches to <code>indent-relative</code>, which lines up with the previous line, and region shifting moves a block by one level.</p>
<p>Some cases are still hard (<code>NondecreasingIndentation</code>, CPP blocks, and edits that change the parse tree as you type), and the <a href="https://github.com/tmcgilchrist/curry-mode/blob/main/ROADMAP.md">roadmap</a> lists them as known issues. Getting a whole file into the right shape is a job for a formatter like <a href="https://github.com/tweag/ormolu">ormolu</a> or <a href="https://github.com/fourmolu/fourmolu">fourmolu</a>, which you can already run through HLS with <code>eglot-format-buffer</code>. This is another place where curry-mode provides a usable base and leaves the heavy lifting to the tool that's best at it.</p>
<h2><a href="https://lambdafoo.com/rss.xml#trying-it-out" class="anchor" aria-hidden="true"></a>Trying it out</h2>
<p>curry-mode needs Emacs 29.1 or newer, built against libtree-sitter 0.25 or newer. On Emacs 30 you can install it from GitHub with <code>use-package</code>:</p>
<pre><code><span class="emacs-lisp-source">(</span><span class="emacs-lisp-keyword-control">use-package</span><span class="emacs-lisp-source"> curry-mode
</span><span class="emacs-lisp-source">  </span><span class="emacs-lisp-constant-other-keyword">:vc</span><span class="emacs-lisp-source"> (</span><span class="emacs-lisp-constant-other-keyword">:url</span><span class="emacs-lisp-source"> </span><span class="emacs-lisp-string-quoted-double">"</span><span class="emacs-lisp-string-quoted-double">https://github.com/tmcgilchrist/curry-mode</span><span class="emacs-lisp-string-quoted-double">"</span><span class="emacs-lisp-source"> </span><span class="emacs-lisp-constant-other-keyword">:rev</span><span class="emacs-lisp-source"> </span><span class="emacs-lisp-constant-other-keyword">:newest</span><span class="emacs-lisp-source">))
</span></code></pre>
<p>On Emacs 29, use <code>M-x package-vc-install RET https://github.com/tmcgilchrist/curry-mode</code>.</p>
<p>The Haskell tree-sitter grammar is installed automatically the first time you open a Haskell file, or you can run <code>M-x curry-install-grammars</code> yourself. For the semantic features, install HLS (for example with <code>ghcup install hls</code>) and run <code>M-x eglot</code> in a Haskell buffer.</p>
<p>The <a href="https://github.com/tmcgilchrist/curry-mode">README</a> has the details on key bindings, font-lock levels and configuration options.</p>
<h2><a href="https://lambdafoo.com/rss.xml#whats-next" class="anchor" aria-hidden="true"></a>What's next?</h2>
<p>How mature is curry-mode? It covers what I need for my Haskell work, and I've been using it daily. The grammar could use polish to keep up with the ever-growing syntax of GHC Haskell, the font-locking needs tuning to look just right, and I'm sure there are corners of Haskell I haven't touched. The <a href="https://github.com/tmcgilchrist/curry-mode/blob/main/ROADMAP.md">roadmap</a> collects ideas for where it could go next, from formatter integration to running the right test from point. I also want to build out the higher layers. I have a branch adding Combobulate support for Haskell (<a href="https://github.com/tmcgilchrist/combobulate/pull/12">PR #12</a>), which adds structured editing on top of the same syntax tree, and debugging with dape needs more use before it moves past experimental.</p>
<p>Most of the hacking for this release is done, and I'm going to spend time on other projects for a while. Perhaps people will find curry-mode useful and borrow the code for haskell-mode, or enough people will use it that it lives on as a modern Haskell mode for Emacs. Please try it out and <a href="https://github.com/tmcgilchrist/curry-mode/issues">report issues</a> for anything that breaks.</p>
<p>Contributions, bug reports, suggestions and feedback are most welcome. Remember, Emacs can be whatever you make of it.</p>

  <p class="post-tags">Tags: <a href="https://lambdafoo.com/tags/haskell/index.html" title="All pages tagged 'haskell'." rel="tag">haskell</a>, <a href="https://lambdafoo.com/tags/emacs/index.html" title="All pages tagged 'emacs'." rel="tag">emacs</a>, <a href="https://lambdafoo.com/tags/tree-sitter/index.html" title="All pages tagged 'tree-sitter'." rel="tag">tree-sitter</a></p>
</div>

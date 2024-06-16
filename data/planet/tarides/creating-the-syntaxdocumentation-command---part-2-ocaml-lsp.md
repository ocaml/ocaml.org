---
title: 'Creating the SyntaxDocumentation Command - Part 2: OCaml LSP'
description: "In the first part of this series, Creating the SyntaxDocumentation Command
  - Part 1: Merlin, we explored how to create a new command in\u2026"
url: https://tarides.com/blog/2024-07-12-creating-the-syntaxdocumentation-command-part-2-ocaml-lsp
date: 2024-07-12T00:00:00-00:00
preview_image: https://tarides.com/static/01f0fe82b9020a8cb67f092f27c60876/0132d/ufo_hover.jpg
authors:
- Tarides
source:
---

<p>In the first part of this series, <a href="https://tarides.com/blog/2024-04-17-creating-the-syntaxdocumentation-command-part-1-merlin/">Creating the <code>SyntaxDocumentation</code> Command - Part 1: Merlin</a>, we explored how to create a new command in Merlin, particularly the <code>SyntaxDocumentation</code> command. In this continuation, we will be looking at the amazing OCaml LSP project and how we have integrated our <code>SyntaxDocumentation</code> command into it. OCaml LSP is a broad and complex project, so we will be limiting the scope of this article just to what's relevant for the <code>SyntaxDocumentation</code> command.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#language-server-protocol" aria-label="language server protocol permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Language Server Protocol</h2>
<p>The <a href="https://microsoft.github.io/language-server-protocol/">Language Server Protocol (LSP)</a> defines the protocol used between an editor or IDE and a language server that provides language features like auto complete, go to definition, find all references, etc. In turn, the protocol defines the format of the messages sent using <a href="https://www.jsonrpc.org/">JSON-RPC</a> between the development tool and the language server. With LSP, a single language server can be used with multiple development tools, such as:</p>
<ul>
<li>Integrated Development Environments (IDEs): Visual Studio Code, Atom, or IntelliJ IDEA</li>
<li>Code editors: Sublime Text, Vim, or Emacs</li>
<li>Text editors with code-related features</li>
<li>Command-line tools for code management, building, or testing</li>
</ul>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#how-lsp-works" aria-label="how lsp works permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>How LSP Works</h3>
<p>Here's a typical interaction between a development tool and a language server:</p>
<ol>
<li><strong>Document Opened:</strong> When the user opens a document, this notifies the language server that a document is open <code>(textDocument/didOpen)</code>.</li>
<li><strong>Editing:</strong> When the user edits the document, this notifies the server about the changes <code>(textDocument/didChange)</code>. The server analyses the changes and notifies the tool of any detected errors and warnings <code>(textDocument/publishDiagnostics)</code>.</li>
<li><strong>Go to Definition:</strong> The user executes &quot;Go to Definition&quot; on a symbol. The tool sends a <code>textDocument/definition</code> request to the server, which responds with the location of the symbol's definition.</li>
<li><strong>Document Closed:</strong> The user closes the document. A <code>textDocument/didClose</code> notification is sent to the server.</li>
</ol>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#ocaml-lsp" aria-label="ocaml lsp permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>OCaml LSP</h2>
<p><a href="https://github.com/ocaml/ocaml-lsp">ocaml-lsp</a> is an implementation of the Language Server Protocol for OCaml in OCaml. It provides language features like code completion, go to definition, find references, type information on hover, and more, to editors and IDEs that support the Language Server Protocol. OCaml LSP is built on top of Merlin, which provides the actual analysis and type information.</p>
<p>Currently, OCaml LSP supports several LSP requests such as <code>textDocument/completion</code>, <code>textDocument/hover</code>, <code>textDocument/codelens</code>, etc. For the purposes of this article, we will limit the scope to <code>textDocument\hover</code> requests because this is where our command is implemented. You can find out more about supported OCaml LSP requests at <a href="https://github.com/ocaml/ocaml-lsp/tree/master?tab=readme-ov-file#features">Features | OCaml LSP</a>.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#hover-requests" aria-label="hover requests permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Hover Requests</h2>
<p>When a user hovers over a symbol or some syntax, their development tool sends a <code>textDocument/hover</code> request to the language server. To better understand this process, let us consider some sample code:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> get_children <span class="token punctuation">(</span>position<span class="token punctuation">:</span>Lexing<span class="token punctuation">.</span>position<span class="token punctuation">)</span> <span class="token punctuation">(</span>root<span class="token punctuation">:</span>node<span class="token punctuation">)</span> <span class="token operator">=</span>
  <span class="token operator">..</span><span class="token punctuation">.</span>some code<span class="token operator">..</span><span class="token punctuation">.</span></code></pre></div>
<p>When the user hovers over the function name, <code>get_children</code>, the hover request (taken from the server logs) is as follows:</p>
<div class="gatsby-highlight" data-language="json"><pre class="language-json"><code class="language-json"><span class="token punctuation">[</span>Trace - <span class="token number">4</span><span class="token operator">:</span><span class="token number">07</span><span class="token operator">:</span><span class="token number">21</span> AM<span class="token punctuation">]</span> Sending request 'textDocument/hover - (<span class="token number">13</span>)'.
Params<span class="token operator">:</span> <span class="token punctuation">{</span>
    <span class="token property">&quot;textDocument&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span>
        <span class="token property">&quot;uri&quot;</span><span class="token operator">:</span> <span class="token string">&quot;file:///home/../../merlin/src/kernel/mbrowse.ml&quot;</span>
    <span class="token punctuation">}</span><span class="token punctuation">,</span>
    <span class="token property">&quot;position&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span>
        <span class="token property">&quot;line&quot;</span><span class="token operator">:</span> <span class="token number">279</span><span class="token punctuation">,</span>
        <span class="token property">&quot;character&quot;</span><span class="token operator">:</span> <span class="token number">10</span>
    <span class="token punctuation">}</span>
<span class="token punctuation">}</span></code></pre></div>
<p>This request includes the following information:</p>
<ul>
<li>The URI of the document where the user is hovering</li>
<li>The position (line and character) within the document where the hover event occurred</li>
</ul>
<p>The language server then responds with information corresponding to what its hover query should do. This could be type information, documentation information, etc.</p>
<div class="gatsby-highlight" data-language="json"><pre class="language-json"><code class="language-json"><span class="token punctuation">[</span>Trace - <span class="token number">4</span><span class="token operator">:</span><span class="token number">07</span><span class="token operator">:</span><span class="token number">21</span> AM<span class="token punctuation">]</span> Received response 'textDocument/hover - (<span class="token number">13</span>)' in 2ms.
Result<span class="token operator">:</span> <span class="token punctuation">{</span>
    <span class="token property">&quot;contents&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span>
        <span class="token property">&quot;kind&quot;</span><span class="token operator">:</span> <span class="token string">&quot;markdown&quot;</span><span class="token punctuation">,</span>
        <span class="token property">&quot;value&quot;</span><span class="token operator">:</span> <span class="token string">&quot;```ocaml\nLexing.position -&gt; ('a * node) list -&gt; node\n```&quot;</span>
    <span class="token punctuation">}</span><span class="token punctuation">,</span>
    <span class="token property">&quot;range&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span>
        <span class="token property">&quot;end&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span>
            <span class="token property">&quot;character&quot;</span><span class="token operator">:</span> <span class="token number">16</span><span class="token punctuation">,</span>
            <span class="token property">&quot;line&quot;</span><span class="token operator">:</span> <span class="token number">279</span>
        <span class="token punctuation">}</span><span class="token punctuation">,</span>
        <span class="token property">&quot;start&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span>
            <span class="token property">&quot;character&quot;</span><span class="token operator">:</span> <span class="token number">4</span><span class="token punctuation">,</span>
            <span class="token property">&quot;line&quot;</span><span class="token operator">:</span> <span class="token number">279</span>
        <span class="token punctuation">}</span>
    <span class="token punctuation">}</span>
<span class="token punctuation">}</span></code></pre></div>
<p>The response received indicates that at this position the type signature is <code>Lexing.position -&gt; ('a * node) list -&gt; node</code>, and it's formatted with Markdown, since it was done in VSCode. For development tools that don't support Markdown, this response will simply be plaintext. The <code>range</code> is used by the editor to highlight the relevant line(s) for the user.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#syntaxdocumentation-implementation" aria-label="syntaxdocumentation implementation permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a><code>SyntaxDocumentation</code> Implementation</h2>
<p>With OCaml LSP, type information displayed from a hover request is taken from Merlin using the <code>type_enclosing</code> command, and the information returned is passed onto the hover functionality to be displayed as a response. With this, we can attach the result from querying Merlin about the <code>SyntaxDocumentation</code> command and add the results to the <code>type_enclosing</code> response.</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> type_enclosing <span class="token operator">=</span>
<span class="token punctuation">{</span>
    loc <span class="token punctuation">:</span> Loc<span class="token punctuation">.</span>t<span class="token punctuation">;</span>
    typ <span class="token punctuation">:</span> string<span class="token punctuation">;</span>
    doc <span class="token punctuation">:</span> string option<span class="token punctuation">;</span>
    syntax_doc <span class="token punctuation">:</span> Query_protocol<span class="token punctuation">.</span>syntax_doc_result option
<span class="token punctuation">}</span></code></pre></div>
<p>To query Merlin for something, we use <code>Query_protocol</code> and <code>Query_command</code>. You can read more about what these do from <a href="https://tarides.com/blog/2024-04-17-creating-the-syntaxdocumentation-command-part-1-merlin/">Part 1</a> of this article series.</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"> <span class="token keyword">let</span> syntax_doc pipeline pos <span class="token operator">=</span>
    <span class="token keyword">let</span> res <span class="token operator">=</span>
      <span class="token keyword">let</span> command <span class="token operator">=</span> Query_protocol<span class="token punctuation">.</span>Syntax_document pos <span class="token keyword">in</span>
      Query_commands<span class="token punctuation">.</span>dispatch pipeline command
    <span class="token keyword">in</span>
    <span class="token keyword">match</span> res <span class="token keyword">with</span>
    <span class="token operator">|</span> <span class="token variant symbol">`Found</span> s <span class="token operator">-&gt;</span> Some s
    <span class="token operator">|</span> <span class="token variant symbol">`No_documentation</span> <span class="token operator">-&gt;</span> None</code></pre></div>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#making-syntaxdocumentation-configurable" aria-label="making syntaxdocumentation configurable permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Making <code>SyntaxDocumentation</code> Configurable</h3>
<p>Sometimes, too much information can be problematic, which is the case with the hover functionality. Most times, users just want a specific kind of information, and presenting a lot of unrelated information can have a negative effect on their productivity. For this reason, <code>SyntaxDocumentation</code> is made to be configurable, so users can toggle it on or off. This is made possible by passing configuration settings to the server.</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml">syntaxDocumentation<span class="token punctuation">:</span> <span class="token punctuation">{</span> enable <span class="token punctuation">:</span> boolean <span class="token punctuation">}</span></code></pre></div>
<p>For a piece of code such as:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> color <span class="token operator">=</span> Red <span class="token operator">|</span> Blue</code></pre></div>
<p>When SyntaxDoc is turned off, we receive the following response:</p>
<div class="gatsby-highlight" data-language="json"><pre class="language-json"><code class="language-json"><span class="token punctuation">{</span>
      <span class="token property">&quot;contents&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span> <span class="token property">&quot;kind&quot;</span><span class="token operator">:</span> <span class="token string">&quot;plaintext&quot;</span><span class="token punctuation">,</span> <span class="token property">&quot;value&quot;</span><span class="token operator">:</span> <span class="token string">&quot;type color = Red | Blue&quot;</span> <span class="token punctuation">}</span><span class="token punctuation">,</span>
      <span class="token property">&quot;range&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span>
        <span class="token property">&quot;end&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span> <span class="token property">&quot;character&quot;</span><span class="token operator">:</span> <span class="token number">21</span><span class="token punctuation">,</span> <span class="token property">&quot;line&quot;</span><span class="token operator">:</span> <span class="token number">1</span> <span class="token punctuation">}</span><span class="token punctuation">,</span>
        <span class="token property">&quot;start&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span> <span class="token property">&quot;character&quot;</span><span class="token operator">:</span> <span class="token number">0</span><span class="token punctuation">,</span> <span class="token property">&quot;line&quot;</span><span class="token operator">:</span> <span class="token number">1</span> <span class="token punctuation">}</span>
      <span class="token punctuation">}</span>
    <span class="token punctuation">}</span></code></pre></div>
<p>When SyntaxDoc is turned on, we receive the following response:</p>
<div class="gatsby-highlight" data-language="json"><pre class="language-json"><code class="language-json"><span class="token punctuation">{</span>
      <span class="token property">&quot;contents&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span>
        <span class="token property">&quot;kind&quot;</span><span class="token operator">:</span> <span class="token string">&quot;plaintext&quot;</span><span class="token punctuation">,</span>
        <span class="token property">&quot;value&quot;</span><span class="token operator">:</span> <span class="token string">&quot;type color = Red | Blue. `syntax` Variant Type: Represent's data that may take on multiple different forms..See [Manual](https://v2.ocaml.org/releases/4.14/htmlman/typedecl.html#ss:typedefs)&quot;</span>
      <span class="token punctuation">}</span><span class="token punctuation">,</span>
      <span class="token property">&quot;range&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span>
        <span class="token property">&quot;end&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span> <span class="token property">&quot;character&quot;</span><span class="token operator">:</span> <span class="token number">21</span><span class="token punctuation">,</span> <span class="token property">&quot;line&quot;</span><span class="token operator">:</span> <span class="token number">1</span> <span class="token punctuation">}</span><span class="token punctuation">,</span>
        <span class="token property">&quot;start&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span> <span class="token property">&quot;character&quot;</span><span class="token operator">:</span> <span class="token number">0</span><span class="token punctuation">,</span> <span class="token property">&quot;line&quot;</span><span class="token operator">:</span> <span class="token number">1</span> <span class="token punctuation">}</span>
      <span class="token punctuation">}</span>
    <span class="token punctuation">}</span></code></pre></div>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#conclusion" aria-label="conclusion permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Conclusion</h2>
<p>In this article, we looked at the LSP protocol and a few examples of how it is implemented in OCaml. With OCaml LSP, the <code>SyntaxDocumentation</code> command becomes a very handy tool, empowering developers to get documentation information by just hovering over the syntax. If you wish to support the OCaml LSP project, you are welcome to submit issues and code constibutions to the repository at <a href="https://github.com/ocaml/ocaml-lsp/issues">Issues | OCaml LSP</a>. In the next and final part of this series, we will look at the VSCode Platform Extension for OCaml and how we can add a visual checkbox to the UI for toggling on/off <code>SyntaxDocumentation</code>.</p>

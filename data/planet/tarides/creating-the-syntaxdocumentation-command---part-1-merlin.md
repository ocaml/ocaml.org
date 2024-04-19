---
title: 'Creating the SyntaxDocumentation Command - Part 1: Merlin'
description: "OCaml development has never been more enchanting, thanks to Merlin \u2013
  the wizard of the editor realm. The magic of Merlin is something that\u2026"
url: https://tarides.com/blog/2024-04-17-creating-the-syntaxdocumentation-command-part-1-merlin
date: 2024-04-17T00:00:00-00:00
preview_image: https://tarides.com/static/51d265b4859973fb259a8f7ec6093ff5/0132d/merlin_syntax.jpg
featured:
authors:
- Tarides
source:
---

<p>OCaml development has never been more enchanting, thanks to Merlin &ndash; the wizard of the editor realm. The <a href="https://tarides.com/blog/2022-07-05-the-magic-of-merlin/">magic of Merlin</a> is something that makes programming in OCaml a very nice experience. By Merlin, I don't mean the old gray-haired, staff-bearing magic guy. I'm talking about the editor service that provides modern IDE features for OCaml.</p>
<p>Merlin currently has an arsenal of tools that enable code navigation, completion, and a myriad of others. To use Merlin, we give it commands, kinda like reading spells from a magic book. In Merlin's magical world, each spell (command) works in a particular way (the logic), requires a specific set of items to work (the inputs), and produces a specific set of results (the output).</p>
<p>This article is the first of a three-part series. Here, we'll be looking at how to implement a new command in Merlin, taking the <code>SyntaxDocumentation</code> functionality as a case study. The second will explore how we integrate this command with <code>ocaml-lsp-server</code>, and in the final article, we'll learn how to include this command as a configurable option on the VSCode OCaml Extension.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#the-syntaxdocumentation-command" aria-label="the syntaxdocumentation command permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The SyntaxDocumentation Command</h2>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#the-problem" aria-label="the problem permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The Problem</h3>
<p>Before going into the implementation details, let's take some time to understand what this command is all about and why it's even needed in the first place.</p>
<p>A common challenge faced by OCaml developers is the need for quick and accurate documentation about their code's syntax. While OCaml is a powerful language, its syntax can sometimes be complex, especially for newcomers or developers working on unfamiliar codebases.</p>
<p>Without proper documentation, understanding the syntax can be like navigating a maze blindfolded. You may spend valuable time sifting through hundreds of pages of documentation to find what you are looking for. Googling &quot;syntax symbols&quot; doesn't really help much unless someone faced the same problem and specifically used the exact syntax. This inefficiency not only slows down development, but it also increases the likelihood of errors and bugs creeping into the codebase. Programming should be about the solution you're implementing, not just about the language's syntax, so having a quicker way to understand syntax will go a long way to make programming in OCaml a much nicer experience.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#the-solution" aria-label="the solution permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The Solution</h3>
<p>Most programmers write code using a text editor, such as Vim, Emacs, VSCode, etc. An editor typically has a basic interface for writing and navigating code by using a cursor. Whenever the user's cursor is over some code, the editor tells us what that code is and provides further information about the syntax.
The <code>SyntaxDocumentation</code> command basically grabs the code under the cursor and uses Merlin's analysis engine to extract relevant information about its syntax. This information is then presented back to the user.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#the-implementation" aria-label="the implementation permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The Implementation</h3>
<p>To implement the <code>SyntaxDocumentation</code> command, we'll use a simple three-step approach:</p>
<ol>
<li><strong>The Trigger</strong>: What the user should do to trigger this command.</li>
<li><strong>The Action</strong>: What actions should be executed when the user has triggered this command.</li>
<li><strong>The Consequence</strong>: How the results should be presented when the action(s) are completed.</li>
</ol>
<p>The trigger here will be a simple hover, such as placing your cursor above some code. We won't go into detail how this works. (See Part 2).</p>
<p>In this article, our focus will be on step 2 and 3. This covers which actions to run after the trigger and what the result should be.</p>
<h4 style="position:relative;"><a href="https://tarides.com/feed.xml#1-new-commands" aria-label="1 new commands permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>1. New Commands</h4>
<p>For our <code>SyntaxDocumentation</code> command to be possible, we have to let Merlin know of the new command by defining it. This involves telling Merlin the name of the command, what the command needs as input, and what Merlin should do if this command is called.</p>
<p>To create a new command, we need to add its definition to some files:</p>
<ul>
<li><a href="https://github.com/ocaml/merlin/commit/0f64255167b63d8eab606419693ac2ca83d132f0#diff-cbfaeb02002660c15c9f7a82955822acd5ec25cc7362c06bf025f5efedc0957eR202-R215">new_commands.ml</a>: In this file, we define our new command and indicate the inputs it requires. By giving it a helpful description, the user can learn about it from the help menu.</li>
</ul>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml">command <span class="token string">&quot;syntax-document&quot;</span>
    <span class="token label property">~doc</span><span class="token punctuation">:</span> <span class="token string">&quot;Returns documentation for OCaml syntax for the entity under the cursor&quot;</span>
    <span class="token label property">~spec</span><span class="token punctuation">:</span> <span class="token punctuation">[</span>
        arg <span class="token string">&quot;-position&quot;</span> <span class="token string">&quot;&lt;position&gt; Position to complete&quot;</span>
        <span class="token punctuation">(</span>marg_position <span class="token punctuation">(</span><span class="token keyword">fun</span> pos _pos <span class="token operator">-&gt;</span> pos<span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">;</span>
    <span class="token punctuation">]</span>
    <span class="token label property">~default</span><span class="token punctuation">:</span> <span class="token variant symbol">`None</span>
    <span class="token keyword">begin</span> <span class="token keyword">fun</span> buffer pos <span class="token operator">-&gt;</span>
        <span class="token keyword">match</span> pos <span class="token keyword">with</span>
        <span class="token operator">|</span> <span class="token variant symbol">`None</span> <span class="token operator">-&gt;</span> failwith <span class="token string">&quot;-position &lt;pos&gt; is mandatory&quot;</span>
        <span class="token operator">|</span> <span class="token directive property">#Msource</span><span class="token punctuation">.</span>position <span class="token keyword">as</span> pos <span class="token operator">-&gt;</span>
            run buffer <span class="token punctuation">(</span>Query_protocol<span class="token punctuation">.</span>Syntax_document pos<span class="token punctuation">)</span>
    <span class="token keyword">end</span>
<span class="token punctuation">;</span></code></pre></div>
<p>Basically, this tells Merlin to create a new command called <code>syntax-document</code> that requires a position. <code>Msource</code> is a helpful module containing useful utilities to deal with positions.</p>
<ul>
<li><a href="https://github.com/ocaml/merlin/commit/0f64255167b63d8eab606419693ac2ca83d132f0#diff-4dee2c70efab5997f53cb009604f12caa24a233f38889b3e0b622982c2cfa281R143-R147">query_protocol.ml</a>: In this file, we specifically define our command's input and output types. Here we tell Merlin that our command needs an input of type <code>position</code> from the <code>Msource</code> module, and our output can either be <code>No_documentation</code> or that documentation with the type <code>syntax_doc_result</code> has been found.</li>
</ul>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token operator">|</span> Syntax_document
    <span class="token punctuation">:</span> Msource<span class="token punctuation">.</span>position
    <span class="token operator">-&gt;</span>  <span class="token punctuation">[</span> <span class="token variant symbol">`Found</span> <span class="token keyword">of</span> syntax_doc_result
        <span class="token operator">|</span> <span class="token variant symbol">`No_documentation</span>
        <span class="token punctuation">]</span> t</code></pre></div>
<p><code>syntax_doc_result</code> is defined as a record that contains a name, a description, and a link to the documentation:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> syntax_doc_result <span class="token operator">=</span> 
<span class="token punctuation">{</span> 
    name <span class="token punctuation">:</span> string<span class="token punctuation">;</span> 
    description <span class="token punctuation">:</span> string<span class="token punctuation">;</span> 
    documentation <span class="token punctuation">:</span> string 
<span class="token punctuation">}</span></code></pre></div>
<p>So basically our command will receive a cursor position as input and either return some information (name, description, and a documentation link) or say no documentation has been found.</p>
<ul>
<li><a href="https://github.com/ocaml/merlin/commit/0f64255167b63d8eab606419693ac2ca83d132f0#diff-b8705d092b3c3b7c1194dc783a4e75b0041b663b890c31defe9af4d23277c62eR115-R116">query_json.ml</a>: In this file, we write the code for how Merlin should format the response it sends to other editor plugins, such as Vim and Emacs.</li>
</ul>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token operator">|</span> Syntax_document pos <span class="token operator">-&gt;</span>
    mk <span class="token string">&quot;syntax-document&quot;</span> <span class="token punctuation">[</span> <span class="token punctuation">(</span><span class="token string">&quot;position&quot;</span><span class="token punctuation">,</span> mk_position pos<span class="token punctuation">)</span> <span class="token punctuation">]</span></code></pre></div>
<p>Here, <code>mk_position</code> is a function that takes our cursor position and serialises it for debugging purposes.</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token operator">|</span> Syntax_document <span class="token punctuation">_</span><span class="token punctuation">,</span> response <span class="token operator">-&gt;</span> <span class="token punctuation">(</span>
    <span class="token keyword">match</span> response <span class="token keyword">with</span>
    <span class="token operator">|</span> <span class="token variant symbol">`Found</span> info <span class="token operator">-&gt;</span>
            <span class="token variant symbol">`Assoc</span>
            <span class="token punctuation">[</span>
                <span class="token punctuation">(</span><span class="token string">&quot;name&quot;</span><span class="token punctuation">,</span> <span class="token variant symbol">`String</span> info<span class="token punctuation">.</span>name<span class="token punctuation">)</span><span class="token punctuation">;</span>
                <span class="token punctuation">(</span><span class="token string">&quot;description&quot;</span><span class="token punctuation">,</span> <span class="token variant symbol">`String</span> info<span class="token punctuation">.</span>description<span class="token punctuation">)</span><span class="token punctuation">;</span>
                <span class="token punctuation">(</span><span class="token string">&quot;url&quot;</span><span class="token punctuation">,</span> <span class="token variant symbol">`String</span> info<span class="token punctuation">.</span>documentation<span class="token punctuation">)</span><span class="token punctuation">;</span>
            <span class="token punctuation">]</span>
    <span class="token operator">|</span> <span class="token variant symbol">`No_documentation</span> <span class="token operator">-&gt;</span> <span class="token variant symbol">`String</span> <span class="token string">&quot;No documentation found&quot;</span><span class="token punctuation">)</span></code></pre></div>
<p>This code serialises the output into JSON format. It is also used by the different editor plugins.</p>
<p>Great! Now that we have seen how Merlin handles our inputs and outputs, it's time to understand how we convert this input into the output.</p>
<h4 style="position:relative;"><a href="https://tarides.com/feed.xml#2-command-logic" aria-label="2 command logic permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>2. Command Logic</h4>
<p>The implementation of our logic is found in the file <a href="https://github.com/ocaml/merlin/commit/0f64255167b63d8eab606419693ac2ca83d132f0#diff-8009410bbeda8c44724e5b305d6d128561d75292378904d5d82f448cbee7f801R506-R514s">query_commands.ml</a>.</p>
<p>Before diving deep, let's understand a few concepts that we'll use in our implementation.</p>
<ul>
<li>
<p><strong>Source Code</strong>: refers to the OCaml code written in a text editor</p>
</li>
<li>
<p><strong>Parsetree</strong>: a more detailed internal representation of the source code</p>
</li>
<li>
<p><strong>Typedtree</strong>: an enhanced version of the Parsetree where type information is attached to each node</p>
</li>
</ul>
<p>Basically, the source code is the starting point. The parser then takes this source code and builds a Parsetree representing its syntactic structure. The type checker analyses this Parsetree and assigns types to its elements, generating a Typedtree.</p>
<p>The Merlin engine already provides a lot of utilities that we can use to achieve all of this, such as:</p>
<ul>
<li><code>Mpipeline</code>: This is the core pipeline of Merlin's analysis engine. It handles the various stages of processing OCaml code, such as lexing and parsing.</li>
<li><code>Mtyper</code>: This module provides us with utilities for interacting with the Typedtree.</li>
<li><code>Mbrowse</code>: This module provides us with utilities for navigating and manipulating the nodes of the Typedtree.</li>
</ul>
<p>Our implementation code is:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token operator">|</span> Syntax_document pos <span class="token operator">-&gt;</span>
    <span class="token keyword">let</span> typer <span class="token operator">=</span> Mpipeline<span class="token punctuation">.</span>typer_result pipeline <span class="token keyword">in</span>
    <span class="token keyword">let</span> pos <span class="token operator">=</span> Mpipeline<span class="token punctuation">.</span>get_lexing_pos pipeline pos <span class="token keyword">in</span>
    <span class="token keyword">let</span> node <span class="token operator">=</span> Mtyper<span class="token punctuation">.</span>node_at typer pos <span class="token keyword">in</span>
    <span class="token keyword">let</span> res <span class="token operator">=</span> Syntax_doc<span class="token punctuation">.</span>get_syntax_doc pos node <span class="token keyword">in</span> 
    <span class="token punctuation">(</span><span class="token keyword">match</span> res <span class="token keyword">with</span>
    <span class="token operator">|</span> Some res <span class="token operator">-&gt;</span> <span class="token variant symbol">`Found</span> res 
    <span class="token operator">|</span> None <span class="token operator">-&gt;</span> <span class="token variant symbol">`No_documentation</span><span class="token punctuation">)</span></code></pre></div>
<p>We are using the <code>Mpipeline</code> module to get the Typedtree and the lexing position (our cursor's position in the source code). Once this position is found, we use the <code>Mtyper</code> module to grab the specific node found at this cursor position in the Typedtree. <code>Mtyper</code> uses the <code>Mbrowse</code> module to navigate through the Typedtree until it arrives at the node that has the same position as our lexing position (cursor position).</p>
<p>Example: Let's consider a simple variant type:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> color <span class="token operator">=</span> Red <span class="token operator">|</span> Green</code></pre></div>
<p>The node tree will be:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">[ type_kind; type_declaration; structure_item; structure ]</code></pre></div>
<p>Once we have received this node tree, we pass it to our custom module <a href="https://github.com/ocaml/merlin/commit/0f64255167b63d8eab606419693ac2ca83d132f0#diff-2067d79c6bb02a49ccb063ad859e08560060013395b911988a2cf856af1a526b">Syntax_doc.ml</a> and call the function <code>get_syntax_doc</code> within it. This pattern-matches the node tree and extracts the relevant information or returns no information. An excerpt from our custom module is presented below:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token operator">..</span><span class="token punctuation">.</span>

<span class="token keyword">let</span> get_syntax_doc cursor_loc node <span class="token operator">=</span>
    <span class="token keyword">match</span> node <span class="token keyword">with</span>
    <span class="token operator">|</span> <span class="token punctuation">(</span><span class="token punctuation">_</span><span class="token punctuation">,</span> Type_kind Ttype_variant <span class="token punctuation">_</span><span class="token punctuation">)</span> <span class="token punctuation">::</span> <span class="token punctuation">(</span><span class="token punctuation">_</span><span class="token punctuation">,</span> Type_declaration <span class="token punctuation">_</span><span class="token punctuation">)</span> <span class="token punctuation">::</span> <span class="token punctuation">_</span>
        <span class="token operator">-&gt;</span>
        Some <span class="token punctuation">{</span> 
                name <span class="token operator">=</span> <span class="token string">&quot;Type Variant&quot;</span><span class="token punctuation">;</span> 
                description <span class="token operator">=</span> <span class="token string">&quot;Represent's data that may take on multiple different forms.&quot;</span><span class="token punctuation">;</span>
                documentation <span class="token operator">=</span> <span class="token string">&quot;https://v2.ocaml.../typev.html&quot;</span><span class="token punctuation">;</span>
            <span class="token punctuation">}</span>
<span class="token operator">..</span><span class="token punctuation">.</span>
    <span class="token operator">|</span> <span class="token punctuation">_</span> <span class="token operator">-&gt;</span> None</code></pre></div>
<p>The output returned conforms to <code>type syntax_info = Query_protocol.syntax_doc_result</code>, which is defined in <a href="https://github.com/ocaml/merlin/commit/0f64255167b63d8eab606419693ac2ca83d132f0#diff-4dee2c70efab5997f53cb009604f12caa24a233f38889b3e0b622982c2cfa281R99-R105">query_protocol.ml</a>.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#results-and-tests" aria-label="results and tests permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Results and Tests</h3>
<p>After Merlin runs the logic, it has to return some results for us. To test that our code works well, we use the Cram testing framework to check it's functionality.
Example: Say we write the following source code in a file called <code>main.ml</code>:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> rectangle <span class="token operator">=</span> <span class="token punctuation">{</span> length<span class="token punctuation">:</span> int<span class="token punctuation">;</span> width<span class="token punctuation">:</span> int<span class="token punctuation">}</span></code></pre></div>
<p>We can use Cram to call Merlin and ask it to get us some information:</p>
<div class="gatsby-highlight" data-language="sh"><pre class="language-sh"><code class="language-sh"><span class="token variable">$MERLIN</span> single syntax-document <span class="token parameter variable">-position</span> <span class="token number">1</span>:12 <span class="token parameter variable">-filename</span> ./main.ml <span class="token operator">&lt;</span> ./main.ml</code></pre></div>
<p>Here we are telling Merlin to give us information for the cursor position <code>1:12</code>, which means the first line on the 12th column (begin from the first character of line 1 and count 12 characters). This will place our cursor over the word <code>rectangle</code>.</p>
<p>When we run this test, the result returned will be:</p>
<div class="gatsby-highlight" data-language="json"><pre class="language-json"><code class="language-json"><span class="token punctuation">{</span>
   <span class="token property">&quot;name&quot;</span><span class="token operator">:</span> <span class="token string">&quot;Record types&quot;</span><span class="token punctuation">,</span>
   <span class="token property">&quot;description&quot;</span><span class="token operator">:</span> <span class="token string">&quot;Allows you to define variants with a fixed...&quot;</span><span class="token punctuation">,</span>
   <span class="token property">&quot;url&quot;</span><span class="token operator">:</span> <span class="token string">&quot;https://v2.ocaml....riants.html&quot;</span>
<span class="token punctuation">}</span></code></pre></div>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#conclusion" aria-label="conclusion permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Conclusion</h3>
<p>We have finally come to the end of the first part of this article series. In this part, we explored the problem we are trying to solve, hypothesised about a possible solution, and then implemented the solution. This implementation is like the engine/backend of our solution.</p>
<p>It was a very fun and exciting experience working on this command. I got to learn a lot about OCaml, especially how Merlin works internally. In Part 2 of this series, we'll look at how this new functionality has been integrated to work with various editors such as Vim, Emacs, and VSCode.</p>
<p>Here are some lessons I learned on this journey:</p>
<ul>
<li>An idiomatic approach is better. Coming from a non-functional background, I am used to writing code a certain non-functional way and wasn't yet baptised in the functional programming waters. I would frequently write these long <code>if-else</code> statements instead of just using pattern matching, the OCaml way. Once I understood it, it became like magic dust for me. I used it very much.</li>
<li>Read the documentation. When working with a new project, the best thing you can do is spend some time reading through the documentation and looking at how the code is written. Most times, something you may be struggling to write may have already been implemented, so you just have to use it. Stop reinventing the wheel.</li>
<li>Ask questions. I can't count how many times I got stuck and had to scream for help, like a kid in a candy shop who lost his toy. I have amazing mentors who are always willing to point me in the right direction. This support literally feels like wielding Thanos' gaunlet!</li>
</ul>

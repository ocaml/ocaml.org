---
title: 'Creating the SyntaxDocumentation Command - Part 3: VSCode Platform Extension'
description: "In the final installment of our series on the SyntaxDocumentation command,
  we delve into its integration within the OCaml VSCode Platform\u2026"
url: https://tarides.com/blog/2024-07-24-creating-the-syntaxdocumentation-command-part-3-vscode-platform-extension
date: 2024-07-24T00:00:00-00:00
preview_image: https://tarides.com/static/aa5bd16e724bfc18f6e436399a4dda66/e49a8/vscode_toggle.jpg
authors:
- Tarides
source:
---

<p>In the final installment of our series on the <code>SyntaxDocumentation</code> command, we delve into its integration within the OCaml VSCode Platform extension. Building on our previous discussions about Merlin and OCaml LSP, this article explores how to make <code>SyntaxDocumentation</code> an opt-in feature in the popular VSCode editor.</p>
<p>In the first part of this series, <a href="https://tarides.com/blog/2024-04-17-creating-the-syntaxdocumentation-command-part-1-merlin/">Creating the SyntaxDocumentation Command - Part 1: Merlin</a>, we explored how to create a new command in Merlin, particularly the <code>SyntaxDocumentation</code> command. In the second part, <a href="https://tarides.com/blog/2024-06-12-creating-the-syntaxdocumentation-command-part-2-ocaml-lsp/">Creating the SyntaxDocumentation Command - Part 2: OCaml LSP</a>, we looked at how to implement this feature in OCaml LSP in order to enable visual editors to trigger the command with actions such as hovering. In this third and final installment, you will learn how <code>SyntaxDocumentation</code> integrates into the OCaml VSCode Platform extension as an opt-in feature, enabling users to toggle it on/off depending on their preference.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#vscode-editor" aria-label="vscode editor permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>VSCode Editor</h2>
<p><a href="https://code.visualstudio.com/">Visual Studio Code</a> is a free open-source, cross-platform code editor from Microsoft that is very popular among developers.
Some of its features include:</p>
<ul>
<li>Built-in Git support</li>
<li>Easy debugging of code right from the editor with an interactive console</li>
<li>Built-in extension manager with lots of available extensions to download</li>
<li>Supports a huge number of programming languages, including syntax highlighting</li>
<li>Integrated terminal and many more features</li>
</ul>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#ocaml-platform-extension-for-vscode" aria-label="ocaml platform extension for vscode permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>OCaml Platform Extension for VSCode</h2>
<p>The VSCode OCaml Platform extension enhances the development experience for OCaml programmers. It is itself written in the OCaml programming language using bindings to the VSCode API and then compiled into Javascript with <a href="https://github.com/ocsigen/js_of_ocaml"><code>js_of_ocaml</code></a>. It provides language support features such as <code>syntax-highlighting</code>, <code>go-to-definition</code>, <code>auto-completion</code>, and <code>type-on-hover</code>. These key functionalities are powered by the OCaml Language Server (<code>ocamllsp</code>), which can be installed using popular package managers like <a href="https://opam.ocaml.org/">opam</a> and <a href="https://esy.sh/">esy</a>. Users can easily configure the extension to work with different sandbox environments, ensuring a tailored setup for various project needs. Additionally, the extension includes comprehensive settings and command options, making it very versatile for both beginner and advanced OCaml developers.</p>
<p>The OCaml Platform Extension for VSCode gives us a nice UI for interacting with OCaml-LSP. We can configure settings for the server as well as interact with switches, browse the AST, and many more features. Our main focus is on adding a <code>checkbox</code> that allows users to activate or deactivate <code>SyntaxDocumentation</code> in OCaml LSP's <code>hover</code> response. I limited this article's scope to just the files relevant in implementing this, while giving a brief tour of how the extension is built.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#the-implementation" aria-label="the implementation permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The Implementation</h2>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#extension-manifest" aria-label="extension manifest permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Extension Manifest</h3>
<p>Every VSCode extension has a manifest file, <a href="https://github.com/ocamllabs/vscode-ocaml-platform/blob/master/package.json">package.json</a>, at the root of the extension directory. The <code>package.json</code> contains a mix of Node.js fields, such as scripts and <code>devDependencies</code>, and VS Code specific fields, like <code>publisher</code>, <code>activationEvents</code>, and <code>contributes</code>.
Our manifest file contains general information such as:</p>
<ul>
<li><strong>Name</strong>: OCaml Platform</li>
<li><strong>Description</strong>: Official OCaml language extension for VSCode</li>
<li><strong>Version</strong>: 1.14.2</li>
<li><strong>Publisher</strong>: OCaml Labs</li>
<li><strong>Categories</strong>: Programming Languages, Debuggers</li>
</ul>
<p>We also have commands that act as action events for our extension. These commands are used to perform a wide range of things, like navigating the AST, upgrading packages, deleting a switch, etc.
An example of a command to open the AST explorer is written as:</p>
<div class="gatsby-highlight" data-language="json"><pre class="language-json"><code class="language-json"><span class="token punctuation">{</span>
    <span class="token property">&quot;command&quot;</span><span class="token operator">:</span> <span class="token string">&quot;ocaml.open-ast-explorer-to-the-side&quot;</span><span class="token punctuation">,</span>
    <span class="token property">&quot;category&quot;</span><span class="token operator">:</span> <span class="token string">&quot;OCaml&quot;</span><span class="token punctuation">,</span>
    <span class="token property">&quot;title&quot;</span><span class="token operator">:</span> <span class="token string">&quot;Open AST explorer&quot;</span>
<span class="token punctuation">}</span></code></pre></div>
<p>For our case, enabling/disabling <code>SyntaxDocumentation</code> is a configuration setting for our language server, so we indicate this in the configurations section:</p>
<div class="gatsby-highlight" data-language="json"><pre class="language-json"><code class="language-json"><span class="token property">&quot;ocaml.server.syntaxDocumentation&quot;</span><span class="token operator">:</span> <span class="token punctuation">{</span>
    <span class="token property">&quot;type&quot;</span><span class="token operator">:</span> <span class="token string">&quot;boolean&quot;</span><span class="token punctuation">,</span>
    <span class="token property">&quot;default&quot;</span><span class="token operator">:</span> <span class="token boolean">false</span><span class="token punctuation">,</span>
    <span class="token property">&quot;markdownDescription&quot;</span><span class="token operator">:</span> <span class="token string">&quot;Enable/Disable syntax documentation&quot;</span>
<span class="token punctuation">}</span></code></pre></div>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#extension-instance" aria-label="extension instance permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Extension Instance</h3>
<p>The file <a href="https://github.com/ocamllabs/vscode-ocaml-platform/blob/master/src/extension_instance.ml"><code>extension_instance.ml</code></a> handles the setup and configuration of various components of the OCaml VSCode extension and ensures that features like the language server and documentation are properly initialised. Its key functionalities are:</p>
<ul>
<li><strong>Managing the Extension State</strong>: It uses a record type that encapsulates the state of the extension, holding information about the sandbox, REPL, OCaml version, LSP client, documentation server, and various other settings.</li>
</ul>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> t <span class="token operator">=</span> <span class="token punctuation">{</span>
  <span class="token keyword">mutable</span> sandbox <span class="token punctuation">:</span> Sandbox<span class="token punctuation">.</span>t<span class="token punctuation">;</span>
  <span class="token keyword">mutable</span> repl <span class="token punctuation">:</span> Terminal_sandbox<span class="token punctuation">.</span>t option<span class="token punctuation">;</span>
  <span class="token keyword">mutable</span> ocaml_version <span class="token punctuation">:</span> Ocaml_version<span class="token punctuation">.</span>t option<span class="token punctuation">;</span>
  <span class="token keyword">mutable</span> lsp_client <span class="token punctuation">:</span> <span class="token punctuation">(</span>LanguageClient<span class="token punctuation">.</span>t <span class="token operator">*</span> Ocaml_lsp<span class="token punctuation">.</span>t<span class="token punctuation">)</span> option<span class="token punctuation">;</span>
  <span class="token keyword">mutable</span> documentation_server <span class="token punctuation">:</span> Documentation_server<span class="token punctuation">.</span>t option<span class="token punctuation">;</span>
  documentation_server_info <span class="token punctuation">:</span> StatusBarItem<span class="token punctuation">.</span>t<span class="token punctuation">;</span>
  sandbox_info <span class="token punctuation">:</span> StatusBarItem<span class="token punctuation">.</span>t<span class="token punctuation">;</span>
  ast_editor_state <span class="token punctuation">:</span> Ast_editor_state<span class="token punctuation">.</span>t<span class="token punctuation">;</span>
  <span class="token keyword">mutable</span> codelens <span class="token punctuation">:</span> bool option<span class="token punctuation">;</span>
  <span class="token keyword">mutable</span> extended_hover <span class="token punctuation">:</span> bool option<span class="token punctuation">;</span>
  <span class="token keyword">mutable</span> dune_diagnostics <span class="token punctuation">:</span> bool option<span class="token punctuation">;</span>
  <span class="token keyword">mutable</span> syntax_documentation <span class="token punctuation">:</span> bool option<span class="token punctuation">;</span>
<span class="token punctuation">}</span></code></pre></div>
<ul>
<li>
<p><strong>Interacting With the Language Server</strong>: This extension needs to interact with the OCaml language server (<code>ocamllsp</code>) to provide features like code completion, diagnostics, and other language-specific functionalities.</p>
</li>
<li>
<p><strong>Documentation Server Management</strong>: The file includes functionality to start, stop, and manage the documentation server, which provides documentation lookup for installed OCaml packages.</p>
</li>
<li>
<p><strong>Handling Configuration</strong>: This extension allows users to configure settings such as code lens, extended hover, diagnostics, and syntax documentation. These settings are sent to the language server to adjust its behaviour accordingly. For <code>SyntaxDocumentation</code>, whenever the user toggles the checkbox, the server should set the correct configuration parameters. This is done mainly using two functions <code>set_configuration</code> and <code>send_configuration</code>.</p>
</li>
</ul>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token operator">..</span><span class="token punctuation">.</span>

<span class="token comment">(* Set configuration *)</span>
<span class="token keyword">let</span> set_configuration t <span class="token label property">~syntax_documentation</span> <span class="token operator">=</span>
  t<span class="token punctuation">.</span>syntax_documentation <span class="token operator">&lt;-</span> syntax_documentation<span class="token punctuation">;</span>
  <span class="token keyword">match</span> t<span class="token punctuation">.</span>lsp_client <span class="token keyword">with</span>
  <span class="token operator">|</span> None <span class="token operator">-&gt;</span> <span class="token punctuation">(</span><span class="token punctuation">)</span>
  <span class="token operator">|</span> Some <span class="token punctuation">(</span>client<span class="token punctuation">,</span> <span class="token punctuation">(</span><span class="token punctuation">_</span> <span class="token punctuation">:</span> Ocaml_lsp<span class="token punctuation">.</span>t<span class="token punctuation">)</span><span class="token punctuation">)</span> <span class="token operator">-&gt;</span>
      send_configuration <span class="token label property">~syntax_documentation</span> client
<span class="token operator">..</span><span class="token punctuation">.</span></code></pre></div>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token operator">..</span><span class="token punctuation">.</span>

<span class="token comment">(* Send configuration *)</span>
<span class="token keyword">let</span> send_configuration <span class="token label property">~syntax_documentation</span> client <span class="token operator">=</span>
  <span class="token keyword">let</span> syntaxDocumentation <span class="token operator">=</span>
    Option<span class="token punctuation">.</span>map syntax_documentation <span class="token label property">~f</span><span class="token punctuation">:</span><span class="token punctuation">(</span><span class="token keyword">fun</span> enable <span class="token operator">-&gt;</span>
        Ocaml_lsp<span class="token punctuation">.</span>OcamllspSettingEnable<span class="token punctuation">.</span>create <span class="token label property">~enable</span><span class="token punctuation">)</span>
  <span class="token keyword">in</span>
  <span class="token keyword">let</span> settings <span class="token operator">=</span>
    Ocaml_lsp<span class="token punctuation">.</span>OcamllspSettings<span class="token punctuation">.</span>create
      <span class="token label property">~syntaxDocumentation</span>
  <span class="token keyword">in</span>
  <span class="token keyword">let</span> payload <span class="token operator">=</span>
    <span class="token keyword">let</span> settings <span class="token operator">=</span>
      LanguageClient<span class="token punctuation">.</span>DidChangeConfiguration<span class="token punctuation">.</span>create
        <span class="token label property">~settings</span><span class="token punctuation">:</span><span class="token punctuation">(</span>Ocaml_lsp<span class="token punctuation">.</span>OcamllspSettings<span class="token punctuation">.</span>t_to_js settings<span class="token punctuation">)</span>
        <span class="token punctuation">(</span><span class="token punctuation">)</span>
    <span class="token keyword">in</span>
    LanguageClient<span class="token punctuation">.</span>DidChangeConfiguration<span class="token punctuation">.</span>t_to_js settings
  <span class="token keyword">in</span>
  LanguageClient<span class="token punctuation">.</span>sendNotification
    client
    <span class="token string">&quot;workspace/didChangeConfiguration&quot;</span>
    payload

<span class="token operator">..</span><span class="token punctuation">.</span></code></pre></div>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#interacting-with-ocaml-lsp" aria-label="interacting with ocaml lsp permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Interacting With OCaml LSP:</h3>
<p>The <a href="https://github.com/ocamllabs/vscode-ocaml-platform/blob/master/src/ocaml_lsp.ml"><code>ocaml_lsp.ml</code></a> file ensures that <code>ocamllsp</code> is set up correctly and up to date. For <code>SyntaxDocumentation</code>, two important modules used from this file are: <code>OcamllspSettingEnable</code> and <code>OcamllspSettings</code>.</p>
<p><code>OcamllspSettingEnable</code> defines an interface for enabling/disabling specific settings in <code>ocamllsp</code>.</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token operator">..</span><span class="token punctuation">.</span>

<span class="token keyword">module</span> OcamllspSettingEnable <span class="token operator">=</span> <span class="token keyword">struct</span>
  <span class="token keyword">include</span> Interface<span class="token punctuation">.</span>Make <span class="token punctuation">(</span><span class="token punctuation">)</span>
  <span class="token keyword">include</span>
    <span class="token punctuation">[</span><span class="token operator">%</span>js<span class="token punctuation">:</span>
    <span class="token keyword">val</span> enable <span class="token punctuation">:</span> t <span class="token operator">-&gt;</span> bool or_undefined <span class="token punctuation">[</span><span class="token operator">@@</span>js<span class="token punctuation">.</span>get<span class="token punctuation">]</span>
    <span class="token keyword">val</span> create <span class="token punctuation">:</span> enable<span class="token punctuation">:</span>bool <span class="token operator">-&gt;</span> t <span class="token punctuation">[</span><span class="token operator">@@</span>js<span class="token punctuation">.</span>builder<span class="token punctuation">]</span><span class="token punctuation">]</span>
<span class="token keyword">end</span>

<span class="token operator">..</span><span class="token punctuation">.</span></code></pre></div>
<p>The annotation <code>[@@js.get]</code> is a PPX used to bind OCaml functions to JavaScript property accessors. This allows OCaml code to interact seamlessly with JavaScript objects, accessing properties directly as if they were native OCaml fields, while <code>[@@js.builder]</code> facilitates the creation of JavaScript objects from OCaml functions. They both come from the <a href="https://github.com/LexiFi/gen_js_api/tree/master"><code>LexFi/gen_js_api</code></a> library.</p>
<p><code>OcamllspSettings</code> aggregrates multiple <code>OcamllspSettingEnable</code> settings into a comprehensive settings interface for <code>ocamllsp</code>.</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token operator">..</span><span class="token punctuation">.</span>
<span class="token keyword">module</span> OcamllspSettings <span class="token operator">=</span> <span class="token keyword">struct</span>
  <span class="token keyword">include</span> Interface<span class="token punctuation">.</span>Make <span class="token punctuation">(</span><span class="token punctuation">)</span>
  <span class="token keyword">include</span>
    <span class="token punctuation">[</span><span class="token operator">%</span>js<span class="token punctuation">:</span>
    <span class="token keyword">val</span> syntaxDocumentation <span class="token punctuation">:</span> t <span class="token operator">-&gt;</span>
      OcamllspSettingEnable<span class="token punctuation">.</span>t or_undefined <span class="token punctuation">[</span><span class="token operator">@@</span>js<span class="token punctuation">.</span>get<span class="token punctuation">]</span>

    <span class="token keyword">val</span> create <span class="token punctuation">:</span> <span class="token operator">?</span>syntaxDocumentation<span class="token punctuation">:</span>OcamllspSettingEnable<span class="token punctuation">.</span>t <span class="token operator">-&gt;</span>
      unit <span class="token operator">-&gt;</span> t <span class="token punctuation">[</span><span class="token operator">@@</span>js<span class="token punctuation">.</span>builder<span class="token punctuation">]</span><span class="token punctuation">]</span>

  <span class="token keyword">let</span> create <span class="token label property">~syntaxDocumentation</span> <span class="token operator">=</span> create <span class="token operator">?</span>syntaxDocumentation <span class="token punctuation">(</span><span class="token punctuation">)</span>
<span class="token keyword">end</span>
<span class="token operator">..</span><span class="token punctuation">.</span></code></pre></div>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#workspace-configuration" aria-label="workspace configuration permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Workspace Configuration</h3>
<p>The file <a href="https://github.com/ocamllabs/vscode-ocaml-platform/blob/master/src/settings.ml"><code>settings.ml</code></a> provides a flexible way to manage workspace-specific settings, including:</p>
<ul>
<li>Creating settings with JSON serialisation and deserialisation</li>
<li>Retrieving and updating settings from the workspace configuration</li>
<li>Resolving and substituting workspace variables within settings</li>
<li>Defining specific settings for the OCaml language server, such as extra environment variables, server arguments, and features like <code>codelens</code> and <code>SyntaxDocumentation</code></li>
</ul>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token operator">..</span><span class="token punctuation">.</span>
<span class="token keyword">let</span> create_setting <span class="token label property">~scope</span> <span class="token label property">~key</span> <span class="token label property">~of_json</span> <span class="token label property">~to_json</span> <span class="token operator">=</span>
  <span class="token punctuation">{</span> scope<span class="token punctuation">;</span> key<span class="token punctuation">;</span> to_json<span class="token punctuation">;</span> of_json <span class="token punctuation">}</span>

<span class="token keyword">let</span> server_syntaxDocumentation_setting <span class="token operator">=</span>
  create_setting
    <span class="token label property">~scope</span><span class="token punctuation">:</span>ConfigurationTarget<span class="token punctuation">.</span>Workspace
    <span class="token label property">~key</span><span class="token punctuation">:</span><span class="token string">&quot;ocaml.server.syntaxDocumentation&quot;</span>
    <span class="token label property">~of_json</span><span class="token punctuation">:</span>Jsonoo<span class="token punctuation">.</span>Decode<span class="token punctuation">.</span>bool
    <span class="token label property">~to_json</span><span class="token punctuation">:</span>Jsonoo<span class="token punctuation">.</span>Encode<span class="token punctuation">.</span>bool
<span class="token operator">..</span><span class="token punctuation">.</span></code></pre></div>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#activating-the-extension" aria-label="activating the extension permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Activating the Extension</h3>
<p>The <a href="https://github.com/ocamllabs/vscode-ocaml-platform/blob/master/src/vscode_ocaml_platform.ml"><code>vscode_ocaml_platform.ml</code></a> file initialises and activates the OCaml Platform extension for VSCode. The key tasks include:</p>
<ul>
<li>Suggesting users select a sandbox environment</li>
<li>Notifying the extension instance of configuration changes</li>
<li>Registering various components and features of the extension</li>
<li>Setting up the sandbox environment and starting the OCaml language server</li>
</ul>
<p>In the context of <code>SyntaxDocumentation</code>, this code ensures that the extension is correctly configured to handle <code>SyntaxDocumentation</code> settings. The <code>notify_configuration_changes</code> function listens for changes to the <code>server_syntaxDocumentation_setting</code> and updates the extension instance accordingly. This means that any changes the user makes to the <code>SyntaxDocumentation</code> settings in the VSCode workspace configuration will be reflected in the extension's behaviour, ensuring that <code>SyntaxDocumentation</code> is enabled or disabled as per the user's preference.</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> notify_configuration_changes instance <span class="token operator">=</span>
  Workspace<span class="token punctuation">.</span>onDidChangeConfiguration
    <span class="token label property">~listener</span><span class="token punctuation">:</span><span class="token punctuation">(</span><span class="token keyword">fun</span> _event <span class="token operator">-&gt;</span>
      <span class="token keyword">let</span> syntax_documentation <span class="token operator">=</span>
        Settings<span class="token punctuation">.</span><span class="token punctuation">(</span>get server_syntaxDocumentation_setting<span class="token punctuation">)</span>
      <span class="token keyword">in</span>
      Extension_instance<span class="token punctuation">.</span>set_configuration instance <span class="token label property">~syntax_documentation</span><span class="token punctuation">)</span>
    <span class="token punctuation">(</span><span class="token punctuation">)</span></code></pre></div>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#conclusion" aria-label="conclusion permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Conclusion</h2>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/35fdebf46d5296c80a6b1339b9237095/66cde/syndoc_vscode.jpg" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 62.35294117647059%; position: relative; bottom: 0; left: 0; background-image: url('data:image/jpeg;base64,/9j/2wBDABALDA4MChAODQ4SERATGCgaGBYWGDEjJR0oOjM9PDkzODdASFxOQERXRTc4UG1RV19iZ2hnPk1xeXBkeFxlZ2P/2wBDARESEhgVGC8aGi9jQjhCY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2P/wgARCAAMABQDASIAAhEBAxEB/8QAFwABAQEBAAAAAAAAAAAAAAAAAAIBBf/EABQBAQAAAAAAAAAAAAAAAAAAAAD/2gAMAwEAAhADEAAAAeTNSGD/xAAUEAEAAAAAAAAAAAAAAAAAAAAg/9oACAEBAAEFAl//xAAUEQEAAAAAAAAAAAAAAAAAAAAQ/9oACAEDAQE/AT//xAAUEQEAAAAAAAAAAAAAAAAAAAAQ/9oACAECAQE/AT//xAAUEAEAAAAAAAAAAAAAAAAAAAAg/9oACAEBAAY/Al//xAAXEAADAQAAAAAAAAAAAAAAAAAAEEEB/9oACAEBAAE/IY4av//aAAwDAQACAAMAAAAQ8M//xAAUEQEAAAAAAAAAAAAAAAAAAAAQ/9oACAEDAQE/ED//xAAUEQEAAAAAAAAAAAAAAAAAAAAQ/9oACAECAQE/ED//xAAcEAACAgIDAAAAAAAAAAAAAAAAAREhEDFhwdH/2gAIAQEAAT8Q3F9jV7RHKJp6UeP/2Q=='); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/35fdebf46d5296c80a6b1339b9237095/7bf67/syndoc_vscode.jpg" class="gatsby-resp-image-image" alt="SyntaxDocument toggle" title="" srcset="/static/35fdebf46d5296c80a6b1339b9237095/651be/syndoc_vscode.jpg 170w,
/static/35fdebf46d5296c80a6b1339b9237095/d30a3/syndoc_vscode.jpg 340w,
/static/35fdebf46d5296c80a6b1339b9237095/7bf67/syndoc_vscode.jpg 680w,
/static/35fdebf46d5296c80a6b1339b9237095/990cb/syndoc_vscode.jpg 1020w,
/static/35fdebf46d5296c80a6b1339b9237095/66cde/syndoc_vscode.jpg 1045w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<p>In this final article, we explored how to integrate <code>SyntaxDocumentation</code> into OCaml VSCode Platform extension as a configurable option for OCaml LSP's <code>hover</code> command. We covered key components such as configuring the extension manifest, managing the extension state, interacting with the OCaml language server, and handling workspace configurations. By enabling users to toggle the <code>SyntaxDocumentation</code> feature on or off, we can ensure a flexible and customisable development experience for all users.</p>
<p>Feel free to contribute to this extension on the GitHub repository: <a href="https://github.com/ocamllabs/vscode-ocaml-platform"><code>vscode-ocaml-platform</code></a>. Thank you for following along in this series, and happy coding with OCaml and VSCode!</p>
<blockquote>
<p>Tarides is an open-source company first. Our top priorities are to establish and tend to the OCaml community. Similarly, we&rsquo;re dedicated to the <a href="https://github.com/sponsors/tarides">development of the OCaml language</a> and enjoy collaborating with industry partners and individual engineers to continue improving the performance and features of OCaml.</p>
<p>We want you to join the OCaml community, test the languages and tools, and actively be part of the language&rsquo;s evolution.</p>
<p><a href="https://tarides.com/company">Contact Tarides</a> to see how OCaml can benefit your business and/or for support while learning OCaml. Follow us on <a href="https://twitter.com/tarides_">Twitter</a> and <a href="https://www.linkedin.com/company/tarides/">LinkedIn</a> to ensure you never miss a post, and join the OCaml discussion on <a href="https://discuss.ocaml.org/">Discuss</a>!</p>
</blockquote>

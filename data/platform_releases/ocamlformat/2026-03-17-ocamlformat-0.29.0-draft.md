---
title: OCamlFormat 0.29.0
tags:
- ocamlformat
- platform
contributors:
changelog:
versions:
authors: []
experimental: false
ignore: false
released_on_github_by: Julow
github_release_tags:
- 0.29.0
---

<p>CHANGES:</p>
<h3>Highlight</h3>
<ul>
<li>
<p>* Support OCaml 5.5 syntax<br>
(<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2772" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="4017434605" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2772" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2772/hovercard">#2772</a>, <a href="https://github.com/ocaml-ppx/ocamlformat/pull/2774" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="4021690050" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2774" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2774/hovercard">#2774</a>, <a href="https://github.com/ocaml-ppx/ocamlformat/pull/2775" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="4022750917" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2775" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2775/hovercard">#2775</a>, <a href="https://github.com/ocaml-ppx/ocamlformat/pull/2777" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="4046551995" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2777" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2777/hovercard">#2777</a>, <a href="https://github.com/ocaml-ppx/ocamlformat/pull/2780" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="4072210803" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2780" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2780/hovercard">#2780</a>, <a href="https://github.com/ocaml-ppx/ocamlformat/pull/2781" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="4072808830" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2781" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2781/hovercard">#2781</a>, <a href="https://github.com/ocaml-ppx/ocamlformat/pull/2782" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="4083594581" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2782" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2782/hovercard">#2782</a>, <a href="https://github.com/ocaml-ppx/ocamlformat/pull/2783" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="4083696723" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2783" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2783/hovercard">#2783</a>, <a href="https://github.com/Julow" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/Julow/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@Julow</a>)<br>
The update brings several tiny changes, they are listed below.</p>
</li>
<li>
<p>* Update Odoc's parser to 3.0 (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2757" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="3671814954" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2757" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2757/hovercard">#2757</a>, <a href="https://github.com/Julow" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/Julow/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@Julow</a>)<br>
The indentation of code-blocks containing OCaml code is reduced by 2 to avoid<br>
changing the generated documentation. The indentation within code-blocks is<br>
now significative in Odoc and shows up in generated documentation.</p>
</li>
</ul>
<h3>Added</h3>
<ul>
<li>
<p>Added option <code>letop-punning</code> (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2746" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="3567679949" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2746" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2746/hovercard">#2746</a>, <a href="https://github.com/WardBrian" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/WardBrian/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@WardBrian</a>) to control whether<br>
punning is used in extended binding operators.<br>
For example, the code <code>let+ x = x in ...</code> can be formatted as<br>
<code>let+ x in ...</code> when <code>letop-punning=always</code>. With <code>letop-punning=never</code>, it<br>
becomes <code>let+ x = x in ...</code>. The default is <code>preserve</code>, which will<br>
only use punning when it exists in the source.<br>
This also applies to <code>let%ext</code> bindings (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2747" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="3571443500" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2747" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2747/hovercard">#2747</a>, <a href="https://github.com/WardBrian" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/WardBrian/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@WardBrian</a>).</p>
</li>
<li>
<p>Support the unnamed functor parameters syntax in module types<br>
(<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2755" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="3652137963" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2755" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2755/hovercard">#2755</a>, <a href="https://github.com/ocaml-ppx/ocamlformat/pull/2759" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="3680557537" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2759" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2759/hovercard">#2759</a>, <a href="https://github.com/Julow" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/Julow/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@Julow</a>)</p>
<div class="highlight highlight-source-ocaml notranslate position-relative overflow-auto" data-snippet-clipboard-copy-content="module type F = ARG -> S"><pre><span class="pl-k">module type </span><span class="pl-en">F</span> <span class="pl-k">=</span> <span class="pl-en">ARG</span> -&gt; <span class="pl-en">S</span></pre></div>
<p>The following lines are now formatted as they are in the source file:</p>
<div class="highlight highlight-source-ocaml notranslate position-relative overflow-auto" data-snippet-clipboard-copy-content="module M : (_ : S) -> (_ : S) -> S = N
module M : S -> S -> S = N
(* The preceding two lines are no longer turned into this: *)
module M : (_ : S) (_ : S) -> S = N"><pre><span class="pl-k">module</span> <span class="pl-en">M</span> : (_ :<span class="pl-k"> S</span>) -&gt; (_ :<span class="pl-k"> S</span>) -&gt; <span class="pl-en">S</span> <span class="pl-k">=</span> <span class="pl-en">N</span>
<span class="pl-k">module</span> <span class="pl-en">M</span> : <span class="pl-en">S</span> -&gt; <span class="pl-en">S</span> -&gt; <span class="pl-en">S</span> <span class="pl-k">=</span> <span class="pl-en">N</span>
<span class="pl-c"><span class="pl-c">(*</span> The preceding two lines are no longer turned into this: <span class="pl-c">*)</span></span>
<span class="pl-k">module</span> <span class="pl-en">M</span> : (_ :<span class="pl-k"> S</span>) (_ :<span class="pl-k"> S</span>) -&gt; <span class="pl-en">S</span> <span class="pl-k">=</span> <span class="pl-en">N</span></pre></div>
</li>
</ul>
<h3>Fixed</h3>
<ul>
<li>
<p>Fix dropped comment in <code>(function _ -&gt; x (* cmt *))</code> (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2739" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="3556370479" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2739" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2739/hovercard">#2739</a>, <a href="https://github.com/Julow" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/Julow/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@Julow</a>)</p>
</li>
<li>
<p>* <code>cases-matching-exp-indent=compact</code> does not impact <code>begin end</code> nodes that<br>
don't have a match inside. (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2742" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="3566187270" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2742" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2742/hovercard">#2742</a>, <a href="https://github.com/EmileTrotignon" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/EmileTrotignon/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@EmileTrotignon</a>)</p>
<div class="highlight highlight-source-ocaml notranslate position-relative overflow-auto" data-snippet-clipboard-copy-content="(* before *)
begin match () with
| () -> begin
  f x
end
end
(* after *)
begin match () with
| () -> begin
    f x
  end
end"><pre><span class="pl-c"><span class="pl-c">(*</span> before <span class="pl-c">*)</span></span>
<span class="pl-k">begin</span> <span class="pl-k">match</span> <span class="pl-c1">()</span> <span class="pl-k">with</span><span class="pl-k"></span>
| <span class="pl-c1">()</span> -&gt; <span class="pl-k">begin</span>
  f x
<span class="pl-k">end</span>
<span class="pl-k">end</span>
<span class="pl-c"><span class="pl-c">(*</span> after <span class="pl-c">*)</span></span>
<span class="pl-k">begin</span> <span class="pl-k">match</span> <span class="pl-c1">()</span> <span class="pl-k">with</span><span class="pl-k"></span>
| <span class="pl-c1">()</span> -&gt; <span class="pl-k">begin</span>
    f x
  <span class="pl-k">end</span>
<span class="pl-k">end</span></pre></div>
</li>
<li>
<p><code>Ast_mapper</code> now iterates on <em>all</em> locations inside of Longident.t,<br>
instead of only some.<br>
(<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2737" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="3551324654" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2737" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2737/hovercard">#2737</a>, <a href="https://github.com/v-gb" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/v-gb/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@v-gb</a>)</p>
</li>
<li>
<p>Remove line break in <code>M with module N = N (* cmt *)</code> (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2779" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="4059567995" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2779" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2779/hovercard">#2779</a>, <a href="https://github.com/Julow" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/Julow/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@Julow</a>)</p>
</li>
</ul>
<h3>Internal</h3>
<ul>
<li>Added information on writing tests to <code>CONTRIBUTING.md</code> (#2838, <a href="https://github.com/WardBrian" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/WardBrian/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@WardBrian</a>)</li>
</ul>
<h3>Changed</h3>
<ul>
<li>
<p>indentation of the <code>end</code> keyword in a match-case is now always at least 2. (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2742" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="3566187270" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2742" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2742/hovercard">#2742</a>, <a href="https://github.com/EmileTrotignon" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/EmileTrotignon/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@EmileTrotignon</a>)</p>
<div class="highlight highlight-source-ocaml notranslate position-relative overflow-auto" data-snippet-clipboard-copy-content="(* before *)
begin match () with
| () -> begin
  match () with
  | () -> ()
end
end
(* after *)
begin match () with
| () -> begin
  match () with
  | () -> ()
"><pre><span class="pl-c"><span class="pl-c">(*</span> before <span class="pl-c">*)</span></span>
<span class="pl-k">begin</span> <span class="pl-k">match</span> <span class="pl-c1">()</span> <span class="pl-k">with</span><span class="pl-k"></span>
| <span class="pl-c1">()</span> -&gt; <span class="pl-k">begin</span>
  <span class="pl-k">match</span> <span class="pl-c1">()</span> <span class="pl-k">with</span><span class="pl-k"></span>
  <span class="pl-k">|</span> <span class="pl-c1">()</span> -&gt; <span class="pl-c1">()</span>
<span class="pl-k">end</span>
<span class="pl-k">end</span>
<span class="pl-c"><span class="pl-c">(*</span> after <span class="pl-c">*)</span></span>
<span class="pl-k">begin</span> <span class="pl-k">match</span> <span class="pl-c1">()</span> <span class="pl-k">with</span><span class="pl-k"></span>
| <span class="pl-c1">()</span> -&gt; <span class="pl-k">begin</span>
  <span class="pl-k">match</span> <span class="pl-c1">()</span> <span class="pl-k">with</span><span class="pl-k"></span>
  <span class="pl-k">|</span> <span class="pl-c1">()</span> -&gt; <span class="pl-c1">()</span>
</pre></div>
</li>
<li>
<p>* use shortcut <code>begin end</code> in <code>match</code> cases and <code>if then else</code> body. (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2744" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="3566683668" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2744" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2744/hovercard">#2744</a>, <a href="https://github.com/EmileTrotignon" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/EmileTrotignon/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@EmileTrotignon</a>)</p>
<div class="highlight highlight-source-ocaml notranslate position-relative overflow-auto" data-snippet-clipboard-copy-content="(* before *)
match () with
| () -> begin
    match () with
    | () ->
  end
end
(* after *)
match () with
| () ->
  begin match () with
    | () ->
  end
end"><pre><span class="pl-c"><span class="pl-c">(*</span> before <span class="pl-c">*)</span></span>
<span class="pl-k">match</span> <span class="pl-c1">()</span> <span class="pl-k">with</span><span class="pl-k"></span>
| <span class="pl-c1">()</span> -&gt; <span class="pl-k">begin</span>
    <span class="pl-k">match</span> <span class="pl-c1">()</span> <span class="pl-k">with</span><span class="pl-k"></span>
    <span class="pl-k">|</span> <span class="pl-c1">()</span> -&gt;
  <span class="pl-k">end</span>
end
<span class="pl-c"><span class="pl-c">(*</span> after <span class="pl-c">*)</span></span>
<span class="pl-k">match</span> <span class="pl-c1">()</span> <span class="pl-k">with</span><span class="pl-k"></span>
| <span class="pl-c1">()</span> -&gt;
  <span class="pl-k">begin</span> <span class="pl-k">match</span> <span class="pl-c1">()</span> <span class="pl-k">with</span><span class="pl-k"></span>
    <span class="pl-k">|</span> <span class="pl-c1">()</span> -&gt;
  <span class="pl-k">end</span>
end</pre></div>
</li>
<li>
<p>* Set the <code>ocaml-version</code> to <code>5.4</code> by default (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2750" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="3629291619" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2750" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2750/hovercard">#2750</a>, <a href="https://github.com/EmileTrotignon" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/EmileTrotignon/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@EmileTrotignon</a>)<br>
The main difference is that the <code>effect</code> keyword is recognized without having<br>
to add <code>ocaml-version=5.3</code> to the configuration.<br>
In exchange, code that use <code>effect</code> as an identifier must use<br>
<code>ocaml-version=5.2</code>.</p>
</li>
<li>
<p>The work to support OCaml 5.5 come with several improvements:</p>
<ul>
<li>Improve the indentation of <code>let structure-item</code> with the<br>
<code>[@ocamlformat "disable"]</code> attribute.<br>
<code>let structure-item</code> means <code>let module</code>, <code>let open</code>, <code>let include</code> and<br>
<code>let exception</code>.</li>
<li><code>(let open M in e)[@a]</code> is turned into <code>let[@a] open M in e</code>.</li>
<li>Long <code>let open ... in</code> no longer exceed the margin.</li>
<li>Improve indentation of <code>let structure-item</code> within parentheses:
<div class="highlight highlight-source-ocaml notranslate position-relative overflow-auto" data-snippet-clipboard-copy-content="(* before *)
(let module M = M in
M.foo)
(* after *)
(let module M = M in
 M.foo)"><pre><span class="pl-c"><span class="pl-c">(*</span> before <span class="pl-c">*)</span></span>
(<span class="pl-k">let</span> <span class="pl-k">module</span> <span class="pl-c1">M</span> = <span class="pl-en">M</span> <span class="pl-k">in</span>
<span class="pl-c1">M.</span>foo)
<span class="pl-c"><span class="pl-c">(*</span> after <span class="pl-c">*)</span></span>
(<span class="pl-k">let</span> <span class="pl-k">module</span> <span class="pl-c1">M</span> = <span class="pl-en">M</span> <span class="pl-k">in</span>
 <span class="pl-c1">M.</span>foo)</pre></div>
</li>
</ul>
</li>
</ul>

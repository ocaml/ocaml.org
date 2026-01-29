---
title: Release 0.28.0
tags:
- ocamlformat
- platform
authors: []
contributors:
changelog:
versions:
experimental: false
ignore: false
released_on_github_by: Julow
github_release_tags:
- 0.28.0
---

<p>CHANGES:</p>
<ul>
<li>
<p>* Support for OCaml 5.4 (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2717" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="3136979211" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2717" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2717/hovercard">#2717</a>, <a href="https://github.com/ocaml-ppx/ocamlformat/pull/2720" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="3304403060" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2720" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2720/hovercard">#2720</a>, <a href="https://github.com/Julow" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/Julow/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@Julow</a>, <a href="https://github.com/Octachron" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/Octachron/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@Octachron</a>)<br>
OCamlformat now supports OCaml 5.4 syntax.<br>
Module packing of the form <code>((module M) : (module S))</code> are no longer<br>
rewritten to <code>(module M : S)</code> because these are now two different syntaxes.</p>
</li>
<li>
<p>* Reduce indentation after <code>|&gt; map (fun</code> (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2694" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="3002815048" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2694" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2694/hovercard">#2694</a>, <a href="https://github.com/EmileTrotignon" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/EmileTrotignon/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@EmileTrotignon</a>)<br>
Notably, the indentation no longer depends on the length of the infix<br>
operator, for example:</p>
<div class="highlight highlight-source-ocaml notranslate position-relative overflow-auto" data-snippet-clipboard-copy-content="(* before *)
v
|>>>>>> map (fun x ->
            x )
(* after *)
v
|>>>>>> map (fun x ->
    x )"><pre><span class="pl-c"><span class="pl-c">(*</span> before <span class="pl-c">*)</span></span>
v
<span class="pl-k">|&gt;&gt;&gt;&gt;&gt;&gt;</span> map (<span class="pl-k">fun</span> <span class="pl-v">x</span> -&gt;
            x )
<span class="pl-c"><span class="pl-c">(*</span> after <span class="pl-c">*)</span></span>
v
<span class="pl-k">|&gt;&gt;&gt;&gt;&gt;&gt;</span> map (<span class="pl-k">fun</span> <span class="pl-v">x</span> -&gt;
    x )</pre></div>
<p><code>@@ match</code> can now also be on one line.</p>
</li>
<li>
<p>Added option <code>module-indent</code> option (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2711" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="3040732612" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2711" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2711/hovercard">#2711</a>, <a href="https://github.com/HPRIOR" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/HPRIOR/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@HPRIOR</a>) to control the indentation<br>
of items within modules. This affects modules and signatures. For example,<br>
module-indent=4:</p>
<div class="highlight highlight-source-ocaml notranslate position-relative overflow-auto" data-snippet-clipboard-copy-content="module type M = sig
    type t

    val f : (string * int) list -> int
end"><pre><span class="pl-k">module type </span><span class="pl-en">M</span> <span class="pl-k">=</span> <span class="pl-k">sig</span>
    <span class="pl-k">type</span> <span class="pl-k">t</span>

    <span class="pl-k">val</span> <span class="pl-en">f</span> : (<span class="pl-k">string</span> <span class="pl-k">*</span> <span class="pl-k">int</span>) <span class="pl-k">list</span> -&gt; <span class="pl-k">int</span>
<span class="pl-k">end</span></pre></div>
</li>
<li>
<p><code>exp-grouping=preserve</code> is now the default in <code>default</code> and <code>ocamlformat</code><br>
profiles. This means that its now possible to use <code>begin ... end</code> without<br>
tweaking ocamlformat. (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2716" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="3125346906" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2716" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2716/hovercard">#2716</a>, <a href="https://github.com/EmileTrotignon" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/EmileTrotignon/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@EmileTrotignon</a>)</p>
</li>
<li>
<p>Starting in this release, ocamlformat can use cmdliner &gt;= 2.0.0. When that is<br>
the case, the tool no longer accepts unambiguous option names prefixes. For<br>
example, <code>--max-iter</code> is not accepted anymore, you have to pass the full<br>
option <code>--max-iters</code>. This does not apply to the keys in the <code>.ocamlformat</code><br>
configuration files, which have always required the full name.<br>
See <a href="https://github.com/dbuenzli/cmdliner/issues/200" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="2889398469" data-permission-text="Title is private" data-url="https://github.com/dbuenzli/cmdliner/issues/200" data-hovercard-type="issue" data-hovercard-url="/dbuenzli/cmdliner/issues/200/hovercard">dbuenzli/cmdliner#200</a>.<br>
(<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2680" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="2982858551" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2680" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2680/hovercard">#2680</a>, <a href="https://github.com/emillon" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/emillon/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@emillon</a>)</p>
</li>
<li>
<p>* The formatting of infix extensions is now consistent with regular<br>
formatting by construction. This reduces indentation in <code>f @@ match%e</code><br>
expressions to the level of indentation in <code>f @@ match</code>. Other unknown<br>
inconsistencies might also be fixed. (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2676" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="2971700847" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2676" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2676/hovercard">#2676</a>, <a href="https://github.com/EmileTrotignon" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/EmileTrotignon/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@EmileTrotignon</a>)</p>
</li>
<li>
<p>* The spacing of infix attributes is now consistent across keywords. Every<br>
keyword but <code>begin</code> <code>function</code>, and <code>fun</code> had attributes stuck to the keyword:<br>
<code>match[@a]</code>, but <code>fun [@a]</code>. Now its also <code>fun[@a]</code>. (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2676" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="2971700847" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2676" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2676/hovercard">#2676</a>, <a href="https://github.com/EmileTrotignon" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/EmileTrotignon/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@EmileTrotignon</a>)</p>
</li>
<li>
<p>* The formatting of<code>let a = b in fun ...</code> is now consistent with other<br>
contexts like <code>a ; fun ...</code>. A check for the syntax <code>let a = fun ... in ...</code><br>
was made more precise. (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2705" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="3020888198" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2705" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2705/hovercard">#2705</a>, <a href="https://github.com/EmileTrotignon" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/EmileTrotignon/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@EmileTrotignon</a>)</p>
</li>
<li>
<p>* <code>|&gt; begin</code>, <code>~arg:begin</code>, <code>begin if</code>, <code>lazy begin</code>, <code>begin match</code>,<br>
<code>begin fun</code> and <code>map li begin fun</code>  can now be printed on the same line, with<br>
one less indentation level for the body of the inner expression.<br>
(<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2664" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="2914783356" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2664" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2664/hovercard">#2664</a>, <a href="https://github.com/ocaml-ppx/ocamlformat/pull/2666" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="2917958037" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2666" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2666/hovercard">#2666</a>, <a href="https://github.com/ocaml-ppx/ocamlformat/pull/2671" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="2949190763" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2671" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2671/hovercard">#2671</a>, <a href="https://github.com/ocaml-ppx/ocamlformat/pull/2672" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="2949301785" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2672" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2672/hovercard">#2672</a>, <a href="https://github.com/ocaml-ppx/ocamlformat/pull/2681" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="2983048773" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2681" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2681/hovercard">#2681</a>, <a href="https://github.com/ocaml-ppx/ocamlformat/pull/2685" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="2988947283" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2685" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2685/hovercard">#2685</a>, <a href="https://github.com/ocaml-ppx/ocamlformat/pull/2693" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="3002152210" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2693" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2693/hovercard">#2693</a>, <a href="https://github.com/EmileTrotignon" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/EmileTrotignon/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@EmileTrotignon</a>)<br>
For example :</p>
<div class="highlight highlight-source-ocaml notranslate position-relative overflow-auto" data-snippet-clipboard-copy-content="(* before *)
begin
  fun x ->
    some code
end
(* after *)
begin fun x ->
  some code
end"><pre><span class="pl-c"><span class="pl-c">(*</span> before <span class="pl-c">*)</span></span>
<span class="pl-k">begin</span>
  <span class="pl-k">fun</span> <span class="pl-v">x</span> -&gt;
    some code
end
<span class="pl-c"><span class="pl-c">(*</span> after <span class="pl-c">*)</span></span>
<span class="pl-k">begin</span> <span class="pl-k">fun</span> <span class="pl-v">x</span> -&gt;
  some code
end</pre></div>
</li>
<li>
<p>* <code>break-struct=natural</code> now also applies to <code>sig ... end</code>. (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2682" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="2985059809" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2682" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2682/hovercard">#2682</a>, <a href="https://github.com/EmileTrotignon" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/EmileTrotignon/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@EmileTrotignon</a>)</p>
</li>
<li>
<p>Fixed <code>wrap-comments=true</code> not working with the janestreet profile (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2645" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="2773114414" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2645" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2645/hovercard">#2645</a>, <a href="https://github.com/Julow" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/Julow/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@Julow</a>)<br>
Asterisk-prefixed comments are also now formatted the same way as with the<br>
default profile.</p>
</li>
<li>
<p>Fixed <code>nested-match=align</code> not working with <code>match%ext</code> (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2648" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="2826610101" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2648" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2648/hovercard">#2648</a>, <a href="https://github.com/EmileTrotignon" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/EmileTrotignon/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@EmileTrotignon</a>)</p>
</li>
<li>
<p>Fixed the AST generated for bindings of the form <code>let pattern : type = function ...</code><br>
(<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2651" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="2845416376" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2651" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2651/hovercard">#2651</a>, <a href="https://github.com/v-gb" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/v-gb/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@v-gb</a>)</p>
</li>
<li>
<p>Print valid syntax for the corner case (1).a (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2653" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="2854808820" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2653" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2653/hovercard">#2653</a>, <a href="https://github.com/v-gb" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/v-gb/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@v-gb</a>)</p>
</li>
<li>
<p><code>Ast_mapper.default_mapper</code> now iterates on the location of <code>in</code> in <code>let+ .. in ..</code><br>
(<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2658" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="2884155019" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2658" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2658/hovercard">#2658</a>, <a href="https://github.com/v-gb" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/v-gb/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@v-gb</a>)</p>
</li>
<li>
<p>Fix missing parentheses in <code>let+ (Cstr _) : _ = _</code> (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2661" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="2891725356" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2661" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2661/hovercard">#2661</a>, <a href="https://github.com/Julow" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/Julow/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@Julow</a>)<br>
This caused a crash as the generated code wasn't valid syntax.</p>
</li>
<li>
<p>Fix bad indentation of <code>let%ext { ...</code> (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2663" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="2902715840" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2663" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2663/hovercard">#2663</a>, <a href="https://github.com/EmileTrotignon" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/EmileTrotignon/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@EmileTrotignon</a>)<br>
with <code>dock-collection-brackets</code> enabled.</p>
</li>
<li>
<p>ocamlformat is now more robust when used as a library to print modified ASTs<br>
(<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2659" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="2884687233" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2659" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2659/hovercard">#2659</a>, <a href="https://github.com/v-gb" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/v-gb/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@v-gb</a>)</p>
</li>
<li>
<p>Fix crash due to edge case with asterisk-prefixed comments (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2674" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="2960875619" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2674" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2674/hovercard">#2674</a>, <a href="https://github.com/Julow" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/Julow/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@Julow</a>)</p>
</li>
<li>
<p>Fix crash when formatting <code>mld</code> files that cannot be lexed as ocaml (e.g.<br>
containing LaTeX or C code) (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2684" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="2988046797" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2684" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2684/hovercard">#2684</a>, <a href="https://github.com/emillon" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/emillon/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@emillon</a>)</p>
</li>
<li>
<p>* Fix double parens around module constraint in functor application :<br>
<code>module M = F ((A : T))</code> becomes <code>module M = F (A : T)</code>. (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2678" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="2977431644" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2678" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2678/hovercard">#2678</a>, <a href="https://github.com/EmileTrotignon" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/EmileTrotignon/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@EmileTrotignon</a>)</p>
</li>
<li>
<p>Fix misplaced <code>;;</code> due to interaction with floating doc comments.<br>
(<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2691" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="3000900514" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2691" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2691/hovercard">#2691</a>, <a href="https://github.com/EmileTrotignon" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/EmileTrotignon/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@EmileTrotignon</a>)</p>
</li>
<li>
<p>The formatting of attributes of expression is now aware of the attributes<br>
infix or postix positions: <code>((fun [@a] x -&gt; y) [@b])</code> is formatted without<br>
moving attributes. (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2676" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="2971700847" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2676" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2676/hovercard">#2676</a>, <a href="https://github.com/EmileTrotignon" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/EmileTrotignon/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@EmileTrotignon</a>)</p>
</li>
<li>
<p><code>begin%e ... end</code> and <code>begin [@a] ... end</code> nodes are always preserved.<br>
(<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2676" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="2971700847" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2676" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2676/hovercard">#2676</a>, <a href="https://github.com/EmileTrotignon" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/EmileTrotignon/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@EmileTrotignon</a>)</p>
</li>
<li>
<p><code>begin end</code> syntax for <code>()</code> is now preserved. (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2676" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="2971700847" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2676" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2676/hovercard">#2676</a>, <a href="https://github.com/EmileTrotignon" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/EmileTrotignon/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@EmileTrotignon</a>)</p>
</li>
<li>
<p>Fix a crash on <code>type 'a t = A : 'a. {a: 'a} -&gt; 'a t</code>. (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2710" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="3039164426" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2710" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2710/hovercard">#2710</a>, <a href="https://github.com/EmileTrotignon" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/EmileTrotignon/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@EmileTrotignon</a>)</p>
</li>
<li>
<p>Fix a crash where <code>type%e nonrec t = t</code> was formatted as <code>type nonrec%e t = t</code>,<br>
which is invalid syntax. (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2712" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="3063468335" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2712" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2712/hovercard">#2712</a>, <a href="https://github.com/EmileTrotignon" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/EmileTrotignon/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@EmileTrotignon</a>)</p>
</li>
<li>
<p>Fix commandline parsing being quadratic in the number of arguments<br>
(<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2724" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="3438931349" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2724" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2724/hovercard">#2724</a>, <a href="https://github.com/let-def" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/let-def/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@let-def</a>)</p>
</li>
<li>
<p>* Fix <code>;;</code> being added after a documentation comment (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2683" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="2986074491" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2683" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2683/hovercard">#2683</a>, <a href="https://github.com/EmileTrotignon" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/EmileTrotignon/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@EmileTrotignon</a>)<br>
This results in more <code>;;</code> being inserted, for example:</p>
<div class="highlight highlight-source-ocaml notranslate position-relative overflow-auto" data-snippet-clipboard-copy-content="(* before *)
print_endline &quot;foo&quot;
let a = 3

(* after *)
print_endline &quot;foo&quot; ;;
let a = 3"><pre><span class="pl-c"><span class="pl-c">(*</span> before <span class="pl-c">*)</span></span>
print_endline <span class="pl-s"><span class="pl-pds">"</span>foo<span class="pl-pds">"</span></span>
<span class="pl-k">let</span> a <span class="pl-k">=</span> <span class="pl-c1">3</span>

<span class="pl-c"><span class="pl-c">(*</span> after <span class="pl-c">*)</span></span>
print_endline <span class="pl-s"><span class="pl-pds">"</span>foo<span class="pl-pds">"</span></span> ;;
<span class="pl-k">let</span> a <span class="pl-k">=</span> <span class="pl-c1">3</span></pre></div>
</li>
</ul>

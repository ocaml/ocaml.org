---
title: OCamlFormat 0.30.0
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
- 0.30.0
---

<p>CHANGES:</p>
<h3>Highlight</h3>
<ul>
<li>Support for OCaml 5.6 (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2833" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="6080439668" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2833" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2833/hovercard">#2833</a>, <a href="https://github.com/ocaml-ppx/ocamlformat/pull/2834" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="6081937643" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2834" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2834/hovercard">#2834</a>, <a href="https://github.com/ocaml-ppx/ocamlformat/pull/2836" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="6207661430" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2836" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2836/hovercard">#2836</a>, <a href="https://github.com/ocaml-ppx/ocamlformat/pull/2837" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="6306377033" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2837" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2837/hovercard">#2837</a>, <a href="https://github.com/ocaml-ppx/ocamlformat/pull/2840" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="6348428926" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2840" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2840/hovercard">#2840</a>, <a href="https://github.com/Julow" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/Julow/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@Julow</a>)</li>
</ul>
<h3>Added</h3>
<ul>
<li>Add the <code>ocsigen</code> profile (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2852" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="6516915411" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2852" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2852/hovercard">#2852</a>, <a href="https://github.com/Julow" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/Julow/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@Julow</a>)</li>
</ul>
<h3>Changed</h3>
<ul>
<li>Empty bodies of while loops will be formatted on one line: <code>do () done</code>.<br>
(<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2812" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="4768409623" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2812" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2812/hovercard">#2812</a>, <a href="https://github.com/v-gb" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/v-gb/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@v-gb</a>)</li>
</ul>
<h3>Fixed</h3>
<ul>
<li>
<p>Fix dropped comment with <code>if-then-else = keyword-first</code> (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2853" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="6517334464" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2853" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2853/hovercard">#2853</a>, <a href="https://github.com/Julow" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/Julow/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@Julow</a>)</p>
</li>
<li>
<p>Fix closing parenthesis indentation in some expressions and pattern with<br>
<code>indicate-multiline-delimiters = closing-on-separate-line</code><br>
(<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2850" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="6510297866" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2850" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2850/hovercard">#2850</a>, <a href="https://github.com/ocaml-ppx/ocamlformat/pull/2851" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="6513682982" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2851" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2851/hovercard">#2851</a>, <a href="https://github.com/Julow" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/Julow/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@Julow</a>)</p>
</li>
<li>
<p>Fix dropped parentheses in <code>1 :: (2 :: [] [@a])</code> (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2849" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="6465212940" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2849" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2849/hovercard">#2849</a>, <a href="https://github.com/Julow" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/Julow/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@Julow</a>)</p>
</li>
<li>
<p>Fix dropped comment in <code>let[@ocamlformat "disable"] x = 42 (* a *)</code><br>
(<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2848" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="6419688793" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2848" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2848/hovercard">#2848</a>, <a href="https://github.com/Julow" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/Julow/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@Julow</a>)</p>
</li>
<li>
<p>Fix comment changed on some bad <code>{% ... %}</code> syntax (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2845" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="6371906669" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2845" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2845/hovercard">#2845</a>, <a href="https://github.com/Julow" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/Julow/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@Julow</a>)</p>
</li>
<li>
<p>Fix comment changed containing <code>[\\[\\]]</code> (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2844" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="6371501929" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2844" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2844/hovercard">#2844</a>, <a href="https://github.com/Julow" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/Julow/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@Julow</a>)</p>
</li>
<li>
<p>Fix missing parentheses in <code>effect A, (Some k)</code> (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2843" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="6351014206" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2843" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2843/hovercard">#2843</a>, <a href="https://github.com/Julow" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/Julow/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@Julow</a>)</p>
</li>
<li>
<p>Fix missing parentheses around attributed <code>let open</code> and <code>let module</code><br>
expressions on the left of a sequence (<a href="https://github.com/ocaml-ppx/ocamlformat/issues/2826" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="5886811323" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2826" data-hovercard-type="issue" data-hovercard-url="/ocaml-ppx/ocamlformat/issues/2826/hovercard">#2826</a>, <a href="https://github.com/ocaml-ppx/ocamlformat/pull/2827" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="6046297500" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2827" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2827/hovercard">#2827</a>, <a href="https://github.com/kxc-wraikny" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/kxc-wraikny/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@kxc-wraikny</a>, <a href="https://github.com/Don-Yin" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/Don-Yin/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@Don-Yin</a>).</p>
</li>
<li>
<p>Fix the indentation of the <code>in</code> keyword after a local exception: it is no<br>
longer indented one level deeper than the enclosing <code>let</code>, matching the<br>
behaviour of local types and modules.<br>
(<a href="https://github.com/ocaml-ppx/ocamlformat/issues/2822" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="5301993837" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2822" data-hovercard-type="issue" data-hovercard-url="/ocaml-ppx/ocamlformat/issues/2822/hovercard">#2822</a>, <a href="https://github.com/ocaml-ppx/ocamlformat/pull/2823" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="5350665134" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2823" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2823/hovercard">#2823</a>, <a href="https://github.com/MisterDA" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/MisterDA/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@MisterDA</a>)</p>
</li>
<li>
<p>Fix <code>begin match … end</code> (and <code>begin if … end</code>) branches: with<br>
<code>if-then-else=fit-or-vertical</code> the <code>match … with</code> header no longer splits<br>
over several lines and <code>end</code> is aligned with <code>begin</code>; and a leading comment<br>
on the body no longer reindents it — <code>begin</code> keeps the body one indent in<br>
instead of gluing the keyword to the comment.<br>
(<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2810" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="4733212293" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2810" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2810/hovercard">#2810</a>, <a href="https://github.com/ocaml-ppx/ocamlformat/pull/2815" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="4826809731" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2815" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2815/hovercard">#2815</a>, <a href="https://github.com/MisterDA" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/MisterDA/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@MisterDA</a>, <a href="https://github.com/yakobowski" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/yakobowski/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@yakobowski</a>)</p>
</li>
<li>
<p>Fix indentation of a bare <code>match</code>/<code>function</code>/<code>try</code> branch preceded by a<br>
comment with <code>if-then-else=fit-or-vertical</code>: the branch is no longer<br>
indented relative to the comment's end column.<br>
(<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2810" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="4733212293" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2810" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2810/hovercard">#2810</a>, <a href="https://github.com/MisterDA" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/MisterDA/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@MisterDA</a>)</p>
</li>
<li>
<p>Fix formatting oscillation with <code>if-then-else=fit-or-vertical</code> and<br>
<code>begin...end</code>.<br>
(<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2800" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="4324373389" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2800" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2800/hovercard">#2800</a>, <a href="https://github.com/MisterDA" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/MisterDA/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@MisterDA</a>)</p>
</li>
<li>
<p>Fix instability on long <code>if-then-else</code> with <code>if-then-else=fit-or-vertical</code><br>
(<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2797" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="4298221649" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2797" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2797/hovercard">#2797</a>, <a href="https://github.com/MisterDA" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/MisterDA/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@MisterDA</a>)</p>
</li>
<li>
<p>Fix <code>match</code> in <code>if-then-else</code> branches expanding to vertical with<br>
<code>fit-or-vertical</code> (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2798" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="4314251239" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2798" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2798/hovercard">#2798</a>, <a href="https://github.com/MisterDA" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/MisterDA/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@MisterDA</a>)</p>
</li>
<li>
<p>Fix lexer error on Windows when an Odoc code block contains CRLF line<br>
endings (<a href="https://github.com/hhugo" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/hhugo/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@hhugo</a>)</p>
</li>
<li>
<p>Fix missing parentheses in <code>(a, ~b:(if .. then .. else ..))</code> (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2811" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="4736275320" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2811" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2811/hovercard">#2811</a>, <a href="https://github.com/Julow" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/Julow/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@Julow</a>)</p>
</li>
<li>
<p>Fix configuration in <code>$XDG_CONFIG_HOME</code> was not used when<br>
<code>--enable-outside-detected-project</code> was passed (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2816" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="4839941090" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2816" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2816/hovercard">#2816</a>, <a href="https://github.com/torimus" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/torimus/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@torimus</a>)</p>
</li>
<li>
<p>* Fix a comment before <code>in</code> in a <code>let … in</code> binding forcing an unnecessary<br>
vertical break: <code>let x = v (* comment *) in …</code> is no longer split across<br>
several lines when it otherwise fits. This also fixes a related<br>
non-idempotency. (<a href="https://github.com/ocaml-ppx/ocamlformat/pull/2813" class="issue-link js-issue-link" data-error-text="Failed to load title" data-id="4808846884" data-permission-text="Title is private" data-url="https://github.com/ocaml-ppx/ocamlformat/issues/2813" data-hovercard-type="pull_request" data-hovercard-url="/ocaml-ppx/ocamlformat/pull/2813/hovercard">#2813</a>, <a href="https://github.com/yakobowski" class="user-mention notranslate" data-hovercard-type="user" data-hovercard-url="/users/yakobowski/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self">@yakobowski</a>)</p>
</li>
</ul>

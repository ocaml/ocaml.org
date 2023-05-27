---
title: 'Opa 0.9.0: New syntax'
description: 'When we released Opa 0.9.0  (codenamed S4 ) we promised to follow-up
  with posts presenting its two main new features: new syntax and MongoD...'
url: http://blog.opalang.org/2012/02/opa-090-new-syntax.html
date: 2012-02-27T20:37:00-00:00
preview_image:
featured:
authors:
- Adam Koprowski
---

<div class="sectionbody">
<div class="paragraph"><p>When we <a href="http://blog.opalang.org/2012/02/new-release-opa-090-s4.html">released Opa 0.9.0</a> (codenamed <tt>S4</tt>) we promised to follow-up with posts presenting its two main new features: new syntax and MongoDB support. In this post we'll shortly introduce the former.</p></div>
<div class="paragraph"><p>The main motivation behind introducing the new syntax was to make it more accessible and familiar to users of other programming languages. It is largely inspired by JavaScript and hence current web developers trying Opa should feel more at home with it. However, we still believe that our original syntax has a lot to offer (for one thing: it's very concise) and will continue supporting it. The choice between the two variants is done via a commend line option:</p></div>
<div class="listingblock">
<div class="content">
<pre><tt>opa --parser js-like <span style="color: #990000">...</span>
opa --parser classic <span style="color: #990000">...</span></tt></pre></div></div>
<div class="paragraph"><p>choosing new/old syntax respectively. Starting with Opa 0.9.0 new syntax becomes the default (so to use it one does not need to include any of the above arguments). It will also be used exclusively in the <a href="http://doc.opalang.org/!/manual">manual</a> and the <a href="http://doc.opalang.org/!/api">API</a>.</p></div>
<div class="paragraph"><p>Instead of introducing the new syntax here, I'd like to refer you to a newly introduced section in our manual: <a href="http://doc.opalang.org/#!/refcard">Reference card</a>, which succintly summarizes Opa's syntax, important libraries and everything to get you started with the language. It's a new material, so don't hesitate to give us your feedback on it.</p></div>
<div class="paragraph"><p>I'll wrap up this post with our immortal <a href="https://github.com/MLstate/hello_chat">Chat example</a>; both in old &amp; new syntax, stripped from comments for brevity (consult the original repo for a fully commented version).</p></div>
<div class="ftabs">
<div class="ulist"><ul>
<li>
<p>
<a href="http://www.blogger.com/feeds/2073503406800427577/posts/default#new_syntax">chat-new-syntax.opa</a>
</p>
</li>
<li>
<p>
<a href="http://www.blogger.com/feeds/2073503406800427577/posts/default#old_syntax">chat-old-syntax.opa</a>
</p>
</li>
</ul></div>
<div>
<div class="listingblock">
<div class="content">
<pre><tt><span style="font-weight: bold"><span style="color: #0000FF">import</span></span> stdlib<span style="color: #990000">.</span>themes<span style="color: #990000">.</span>bootstrap

<span style="font-weight: bold"><span style="color: #0000FF">type</span></span> <span style="color: #008080">message</span> <span style="color: #990000">=</span> <span style="color: #FF0000">{</span> <span style="color: #009900">string</span> author
               <span style="color: #990000">,</span> <span style="color: #009900">string</span> <span style="color: #009900">text</span>
               <span style="color: #FF0000">}</span>

exposed <span style="font-weight: bold"><span style="color: #000080"></span></span> <span style="color: #008080">room</span> <span style="color: #990000">=</span> <span style="color: #990000">Network.</span><span style="font-weight: bold"><span style="color: #000000">network</span></span><span style="color: #990000">(</span>message<span style="color: #990000">)</span> <span style="color: #990000">(Network.</span><span style="font-weight: bold"><span style="color: #000000">cloud</span></span><span style="color: #990000">(</span><span style="color: #FF0000">&quot;room&quot;</span><span style="color: #990000">))</span>

function <span style="font-weight: bold"><span style="color: #000000">user_update</span></span><span style="color: #990000">(</span>message x<span style="color: #990000">)</span> <span style="color: #FF0000">{</span>
    <span style="color: #008080">line</span> <span style="color: #990000">=</span> <span style="color: #990000">&lt;</span>div <span style="color: #008080">class</span><span style="color: #990000">=</span><span style="color: #FF0000">&quot;row line&quot;</span><span style="color: #990000">&gt;</span>
              <span style="color: #990000">&lt;</span>div <span style="color: #008080">class</span><span style="color: #990000">=</span><span style="color: #FF0000">&quot;span1 columns userpic&quot;</span> <span style="color: #990000">/&gt;</span>
              <span style="color: #990000">&lt;</span>div <span style="color: #008080">class</span><span style="color: #990000">=</span><span style="color: #FF0000">&quot;span2 columns user&quot;</span><span style="color: #990000">&gt;</span><span style="color: #FF0000">{</span>x<span style="color: #990000">.</span>author<span style="color: #FF0000">}</span><span style="color: #990000">:&lt;/</span>div<span style="color: #990000">&gt;</span>
              <span style="color: #990000">&lt;</span>div <span style="color: #008080">class</span><span style="color: #990000">=</span><span style="color: #FF0000">&quot;span13 columns message&quot;</span><span style="color: #990000">&gt;</span><span style="color: #FF0000">{</span>x<span style="color: #990000">.</span><span style="color: #009900">text</span><span style="color: #FF0000">}</span><span style="color: #990000">&lt;/</span>div<span style="color: #990000">&gt;</span>
            <span style="color: #990000">&lt;/</span>div<span style="color: #990000">&gt;;</span>
    <span style="color: #FF6600">#conversation</span> <span style="color: #990000">=+</span> line<span style="color: #990000">;</span>
    <span style="color: #990000">Dom.</span><span style="font-weight: bold"><span style="color: #000000">scroll_to_bottom</span></span><span style="color: #990000">(</span><span style="color: #FF6600">#conversation</span><span style="color: #990000">);</span>
<span style="color: #FF0000">}</span>

function <span style="font-weight: bold"><span style="color: #000000">broadcast</span></span><span style="color: #990000">(</span>author<span style="color: #990000">)</span> <span style="color: #FF0000">{</span>
    <span style="color: #008080">text</span> <span style="color: #990000">=</span> <span style="color: #990000">Dom.</span><span style="font-weight: bold"><span style="color: #000000">get_value</span></span><span style="color: #990000">(</span><span style="color: #FF6600">#entry</span><span style="color: #990000">);</span>
    <span style="color: #008080">message</span> <span style="color: #990000">=</span> <span style="color: #990000">~</span><span style="color: #FF0000">{</span>author<span style="color: #990000">,</span> <span style="color: #009900">text</span><span style="color: #FF0000">}</span><span style="color: #990000">;</span>
    <span style="color: #990000">Network.</span><span style="font-weight: bold"><span style="color: #000000">broadcast</span></span><span style="color: #990000">(</span>message<span style="color: #990000">,</span> room<span style="color: #990000">);</span>
    <span style="color: #990000">Dom.</span><span style="font-weight: bold"><span style="color: #000000">clear_value</span></span><span style="color: #990000">(</span><span style="color: #FF6600">#entry</span><span style="color: #990000">);</span>
<span style="color: #FF0000">}</span>

function <span style="font-weight: bold"><span style="color: #000000">start</span></span><span style="color: #990000">()</span> <span style="color: #FF0000">{</span>
    <span style="color: #008080">author</span> <span style="color: #990000">=</span> <span style="color: #990000">Random.</span><span style="font-weight: bold"><span style="color: #000000">string</span></span><span style="color: #990000">(</span><span style="color: #993399">8</span><span style="color: #990000">);</span>
    <span style="color: #990000">&lt;</span>div <span style="color: #008080">class</span><span style="color: #990000">=</span><span style="color: #FF0000">&quot;topbar&quot;</span><span style="color: #990000">&gt;</span>
      <span style="color: #990000">&lt;</span>div <span style="color: #008080">class</span><span style="color: #990000">=</span><span style="color: #FF0000">&quot;fill&quot;</span><span style="color: #990000">&gt;</span>
        <span style="color: #990000">&lt;</span>div <span style="color: #008080">class</span><span style="color: #990000">=</span><span style="color: #FF0000">&quot;container&quot;</span><span style="color: #990000">&gt;</span>
          <span style="color: #990000">&lt;</span>div <span style="color: #008080">id</span><span style="color: #990000">=</span><span style="color: #FF6600">#logo</span> <span style="color: #990000">/&gt;</span>
        <span style="color: #990000">&lt;/&gt;</span>
      <span style="color: #990000">&lt;/&gt;</span>
    <span style="color: #990000">&lt;/&gt;</span>
    <span style="color: #990000">&lt;</span>div <span style="color: #008080">id</span><span style="color: #990000">=</span><span style="color: #FF6600">#conversation</span> <span style="color: #008080">class</span><span style="color: #990000">=</span><span style="color: #FF0000">&quot;container&quot;</span>
      <span style="color: #008080">onready</span><span style="color: #990000">=</span><span style="color: #FF0000">{</span><span style="font-weight: bold"><span style="color: #000000">function</span></span><span style="color: #990000">(</span>_<span style="color: #990000">)</span> <span style="color: #FF0000">{</span> <span style="color: #990000">Network.</span><span style="font-weight: bold"><span style="color: #000000">add_callback</span></span><span style="color: #990000">(</span>user_update<span style="color: #990000">,</span> room<span style="color: #990000">)</span> <span style="color: #FF0000">}}</span><span style="color: #990000">&gt;&lt;/&gt;</span>
    <span style="color: #990000">&lt;</span>div <span style="color: #008080">id</span><span style="color: #990000">=</span><span style="color: #FF6600">#footer</span><span style="color: #990000">&gt;</span>
      <span style="color: #990000">&lt;</span>div <span style="color: #008080">class</span><span style="color: #990000">=</span><span style="color: #FF0000">&quot;container&quot;</span><span style="color: #990000">&gt;</span>
        <span style="color: #990000">&lt;</span>input <span style="color: #008080">id</span><span style="color: #990000">=</span><span style="color: #FF6600">#entry</span> <span style="color: #008080">class</span><span style="color: #990000">=</span><span style="color: #FF0000">&quot;xlarge&quot;</span> <span style="color: #008080">onnewline</span><span style="color: #990000">=</span><span style="color: #FF0000">{</span><span style="font-weight: bold"><span style="color: #000000">function</span></span><span style="color: #990000">(</span>_<span style="color: #990000">)</span> <span style="color: #FF0000">{</span> <span style="font-weight: bold"><span style="color: #000000">broadcast</span></span><span style="color: #990000">(</span>author<span style="color: #990000">)</span> <span style="color: #FF0000">}}</span> <span style="color: #990000">/&gt;</span>
        <span style="color: #990000">&lt;</span>div <span style="color: #008080">class</span><span style="color: #990000">=</span><span style="color: #FF0000">&quot;btn primary&quot;</span> <span style="color: #008080">onclick</span><span style="color: #990000">=</span><span style="color: #FF0000">{</span><span style="font-weight: bold"><span style="color: #000000">function</span></span><span style="color: #990000">(</span>_<span style="color: #990000">)</span> <span style="color: #FF0000">{</span> <span style="font-weight: bold"><span style="color: #000000">broadcast</span></span><span style="color: #990000">(</span>author<span style="color: #990000">)</span> <span style="color: #FF0000">}}</span><span style="color: #990000">&gt;</span>Post<span style="color: #990000">&lt;/&gt;</span>
      <span style="color: #990000">&lt;/&gt;</span>
    <span style="color: #990000">&lt;/&gt;</span>
<span style="color: #FF0000">}</span>

<span style="color: #990000">Server.</span><span style="font-weight: bold"><span style="color: #000000">start</span></span><span style="color: #990000">(</span>
    <span style="color: #990000">Server.</span>http<span style="color: #990000">,</span>
    <span style="color: #990000">[</span> <span style="color: #FF0000">{</span>resources<span style="color: #990000">:</span> <span style="font-weight: bold"><span style="color: #000080">@static_resource_directory</span></span><span style="color: #990000">(</span><span style="color: #FF0000">&quot;resources&quot;</span><span style="color: #990000">)</span><span style="color: #FF0000">}</span>
      <span style="color: #990000">,</span> <span style="color: #FF0000">{</span>register<span style="color: #990000">:</span> <span style="color: #990000">[</span><span style="color: #FF0000">&quot;resources/css.css&quot;</span><span style="color: #990000">]</span><span style="color: #FF0000">}</span>
      <span style="color: #990000">,</span> <span style="color: #FF0000">{</span>title<span style="color: #990000">:</span> <span style="color: #FF0000">&quot;Chat&quot;</span><span style="color: #990000">,</span> page<span style="color: #990000">:</span>start <span style="color: #FF0000">}</span>
    <span style="color: #990000">]</span>
<span style="color: #990000">);</span></tt></pre></div></div>
</div>
<div>
<div class="listingblock">
<div class="content">
<pre><tt><span style="font-weight: bold"><span style="color: #0000FF">import</span></span> stdlib<span style="color: #990000">.</span>themes<span style="color: #990000">.</span>bootstrap

<span style="font-weight: bold"><span style="color: #0000FF">type</span></span> <span style="color: #008080">message</span> <span style="color: #990000">=</span> <span style="color: #FF0000">{</span> author<span style="color: #990000">:</span> <span style="color: #009900">string</span>
               <span style="color: #990000">;</span> <span style="color: #009900">text</span><span style="color: #990000">:</span> <span style="color: #009900">string</span>
               <span style="color: #FF0000">}</span>

<span style="font-weight: bold"><span style="color: #000080">@publish</span></span> <span style="color: #008080">room</span> <span style="color: #990000">=</span> <span style="color: #990000">Network.</span><span style="font-weight: bold"><span style="color: #000000">cloud</span></span><span style="color: #990000">(</span><span style="color: #FF0000">&quot;room&quot;</span><span style="color: #990000">):</span> <span style="color: #990000">Network.</span><span style="font-weight: bold"><span style="color: #000000">network</span></span><span style="color: #990000">(</span>message<span style="color: #990000">)</span>

<span style="font-weight: bold"><span style="color: #000000">user_update</span></span><span style="color: #990000">(</span>x<span style="color: #990000">:</span> message<span style="color: #990000">)</span> <span style="color: #990000">=</span>
  <span style="color: #008080">line</span> <span style="color: #990000">=</span> <span style="color: #990000">&lt;</span>div <span style="color: #008080">class</span><span style="color: #990000">=</span><span style="color: #FF0000">&quot;row line&quot;</span><span style="color: #990000">&gt;</span>
            <span style="color: #990000">&lt;</span>div <span style="color: #008080">class</span><span style="color: #990000">=</span><span style="color: #FF0000">&quot;span1 columns userpic&quot;</span> <span style="color: #990000">/&gt;</span>
            <span style="color: #990000">&lt;</span>div <span style="color: #008080">class</span><span style="color: #990000">=</span><span style="color: #FF0000">&quot;span2 columns user&quot;</span><span style="color: #990000">&gt;</span><span style="color: #FF0000">{</span>x<span style="color: #990000">.</span>author<span style="color: #FF0000">}</span><span style="color: #990000">:&lt;/</span>div<span style="color: #990000">&gt;</span>
            <span style="color: #990000">&lt;</span>div <span style="color: #008080">class</span><span style="color: #990000">=</span><span style="color: #FF0000">&quot;span13 columns message&quot;</span><span style="color: #990000">&gt;</span><span style="color: #FF0000">{</span>x<span style="color: #990000">.</span><span style="color: #009900">text</span><span style="color: #FF0000">}</span>
            <span style="color: #990000">&lt;/</span>div<span style="color: #990000">&gt;</span>
         <span style="color: #990000">&lt;/</span>div<span style="color: #990000">&gt;</span>
  <span style="font-weight: bold"><span style="color: #0000FF">do</span></span> <span style="color: #990000">Dom.</span><span style="font-weight: bold"><span style="color: #000000">transform</span></span><span style="color: #990000">([</span><span style="color: #FF6600">#conversation</span> <span style="color: #990000">+&lt;-</span> line <span style="color: #990000">])</span>
  <span style="color: #990000">Dom.</span><span style="font-weight: bold"><span style="color: #000000">scroll_to_bottom</span></span><span style="color: #990000">(</span><span style="color: #FF6600">#conversation</span><span style="color: #990000">)</span>

<span style="font-weight: bold"><span style="color: #000000">broadcast</span></span><span style="color: #990000">(</span>author<span style="color: #990000">)</span> <span style="color: #990000">=</span>
  <span style="color: #008080">text</span> <span style="color: #990000">=</span> <span style="color: #990000">Dom.</span><span style="font-weight: bold"><span style="color: #000000">get_value</span></span><span style="color: #990000">(</span><span style="color: #FF6600">#entry</span><span style="color: #990000">)</span>
  <span style="color: #008080">message</span> <span style="color: #990000">=</span> <span style="color: #FF0000">{</span><span style="color: #008080">~author</span> <span style="color: #008080">~text</span><span style="color: #FF0000">}</span>
  <span style="font-weight: bold"><span style="color: #0000FF">do</span></span> <span style="color: #990000">Network.</span><span style="font-weight: bold"><span style="color: #000000">broadcast</span></span><span style="color: #990000">(</span>message<span style="color: #990000">,</span> room<span style="color: #990000">)</span>
  <span style="color: #990000">Dom.</span><span style="font-weight: bold"><span style="color: #000000">clear_value</span></span><span style="color: #990000">(</span><span style="color: #FF6600">#entry</span><span style="color: #990000">)</span>

<span style="font-weight: bold"><span style="color: #000000">start</span></span><span style="color: #990000">()</span> <span style="color: #990000">=</span>
  <span style="color: #008080">author</span> <span style="color: #990000">=</span> <span style="color: #990000">Random.</span><span style="font-weight: bold"><span style="color: #000000">string</span></span><span style="color: #990000">(</span><span style="color: #993399">8</span><span style="color: #990000">)</span>
  <span style="color: #990000">&lt;</span>div <span style="color: #008080">class</span><span style="color: #990000">=</span><span style="color: #FF0000">&quot;topbar&quot;</span><span style="color: #990000">&gt;&lt;</span>div <span style="color: #008080">class</span><span style="color: #990000">=</span><span style="color: #FF0000">&quot;fill&quot;</span><span style="color: #990000">&gt;&lt;</span>div <span style="color: #008080">class</span><span style="color: #990000">=</span><span style="color: #FF0000">&quot;container&quot;</span><span style="color: #990000">&gt;&lt;</span>div <span style="color: #008080">id</span><span style="color: #990000">=</span><span style="color: #FF6600">#logo</span> <span style="color: #990000">/&gt;&lt;/</span>div<span style="color: #990000">&gt;&lt;/</span>div<span style="color: #990000">&gt;&lt;/</span>div<span style="color: #990000">&gt;</span>
  <span style="color: #990000">&lt;</span>div <span style="color: #008080">id</span><span style="color: #990000">=</span><span style="color: #FF6600">#conversation</span> <span style="color: #008080">class</span><span style="color: #990000">=</span><span style="color: #FF0000">&quot;container&quot;</span> <span style="color: #008080">onready</span><span style="color: #990000">=</span><span style="color: #FF0000">{</span>_ <span style="color: #990000">-&gt;</span> <span style="color: #990000">Network.</span><span style="font-weight: bold"><span style="color: #000000">add_callback</span></span><span style="color: #990000">(</span>user_update<span style="color: #990000">,</span> room<span style="color: #990000">)</span><span style="color: #FF0000">}</span><span style="color: #990000">&gt;&lt;/</span>div<span style="color: #990000">&gt;</span>
  <span style="color: #990000">&lt;</span>div <span style="color: #008080">id</span><span style="color: #990000">=</span><span style="color: #FF6600">#footer</span><span style="color: #990000">&gt;&lt;</span>div <span style="color: #008080">class</span><span style="color: #990000">=</span><span style="color: #FF0000">&quot;container&quot;</span><span style="color: #990000">&gt;</span>
    <span style="color: #990000">&lt;</span>input <span style="color: #008080">id</span><span style="color: #990000">=</span><span style="color: #FF6600">#entry</span> <span style="color: #008080">class</span><span style="color: #990000">=</span><span style="color: #FF0000">&quot;xlarge&quot;</span> <span style="color: #008080">onnewline</span><span style="color: #990000">=</span><span style="color: #FF0000">{</span>_ <span style="color: #990000">-&gt;</span> <span style="font-weight: bold"><span style="color: #000000">broadcast</span></span><span style="color: #990000">(</span>author<span style="color: #990000">)</span><span style="color: #FF0000">}</span><span style="color: #990000">/&gt;</span>
    <span style="color: #990000">&lt;</span>div <span style="color: #008080">class</span><span style="color: #990000">=</span><span style="color: #FF0000">&quot;btn primary&quot;</span> <span style="color: #008080">onclick</span><span style="color: #990000">=</span><span style="color: #FF0000">{</span>_ <span style="color: #990000">-&gt;</span> <span style="font-weight: bold"><span style="color: #000000">broadcast</span></span><span style="color: #990000">(</span>author<span style="color: #990000">)</span><span style="color: #FF0000">}</span><span style="color: #990000">&gt;</span>Post<span style="color: #990000">&lt;/</span>div<span style="color: #990000">&gt;</span>
  <span style="color: #990000">&lt;/</span>div<span style="color: #990000">&gt;&lt;/</span>div<span style="color: #990000">&gt;</span>

<span style="font-weight: bold"><span style="color: #0000FF">server</span></span> <span style="color: #990000">=</span> <span style="color: #990000">Server.</span><span style="font-weight: bold"><span style="color: #000000">one_page_bundle</span></span><span style="color: #990000">(</span><span style="color: #FF0000">&quot;Chat&quot;</span><span style="color: #990000">,</span>
        <span style="color: #990000">[</span><span style="font-weight: bold"><span style="color: #000080">@static_resource_directory</span></span><span style="color: #990000">(</span><span style="color: #FF0000">&quot;resources&quot;</span><span style="color: #990000">)],</span>
        <span style="color: #990000">[</span><span style="color: #FF0000">&quot;resources/css.css&quot;</span><span style="color: #990000">],</span> start<span style="color: #990000">)</span></tt></pre></div></div>
</div>
</div>
<span class="run"><a href="http://hello_chat.tutorials.opalang.org" target="_blank">Run</a></span>
</div>

---
title: 'Programming tools UX: Better Type Error Messages'
description: "I am an intern at the Opa team having a summer break from my PhD at
  UCSD.\_The goal of my internship is to make strong static typing easier f..."
url: http://blog.opalang.org/2012/07/programming-tools-ux-better-type-error.html
date: 2012-07-20T14:33:00-00:00
preview_image:
featured:
authors:
- Unknown
---

<div dir="ltr" style="text-align: left;" trbidi="on"><div class="content"><div class="sect1"><div class="sectionbody"><div class="paragraph">I am an intern at the Opa team having a summer break from my PhD at UCSD.&nbsp;The goal of my internship is to make strong static typing easier for web developers!<br/>
<br/>
This goal is highly motivated from interesting discussions in the Silicon Valley, in particular with Julien Verlaguet at Facebook, on how to make type error messages (much) more user-friendly.<br/>
<br/>
Developers want to write code faster. We all agree.&nbsp;Opponents of static typing often state that:<br/>
<div style="text-align: left;"></div><ul style="text-align: left;"><li>Compilation can be<span style="color: red;"> </span>too long and breaks the workflow.</li>
<li>Figuring out type error messages can make you out of the zone.</li>
</ul>They are right. However, taking into account the time spent in testing and debugging plus a formal guarantee on non tested cases in production and more accurate documentation, the benefits of static typing cannot be ignored.<br/>
<div style="text-align: left;"><br/>
We aim at providing a more user-friendly static typing. This blog post describes an enhancement about the second point: better type errors messages which indicate what you need to change in the code.</div><div style="text-align: left;"></div><div style="text-align: left;"><br/>
</div>To begin with, let&rsquo;s briefly explain why a <em>type error message</em> is raised.&nbsp;Language elements, such as keywords, constants, functions, records, etc., provide&nbsp;type information about expressions.&nbsp;Opa compiler uses this information to associate a type to each expression.&nbsp;Whenever two conflicting types are detected for one expression, a type error&nbsp;message is delivered. For example, the following code contains a type error, as <i>incr</i>&nbsp;expects an integer argument, but it is called with a float&nbsp;(color is used to relate locations in code with their references in the error messages):</div><div class="listingblock"><div class="content"><br/>
<pre><tt><span style="color: #993399;">1</span><span style="color: #990000;">.</span>  <span style="font-weight: bold;"><span style="color: blue;">function</span></span> <span style="font-weight: bold;"><span style="color: black;">incr</span></span><span style="color: #990000;">(</span>x<span style="color: #990000;">)</span><span style="color: red;">{</span>x<span style="color: #990000;">+</span><span style="color: #993399;">1</span><span style="color: red;">}</span>
       <span style="color: #990000;">...</span>
<span style="color: #993399;">42</span><span style="color: #990000;">.</span> <span style="font-weight: bold;"><span style="color: blue;">function</span></span> <span style="font-weight: bold;"><span style="color: black;">foo</span></span><span style="color: #990000;">()</span> <span class="Apple-style-span" style="background-color: yellow;"><span style="color: red;">{</span><span style="font-weight: bold;"><span style="color: black;">incr</span></span><span style="color: #990000;">(</span><span style="color: #993399;">6.0</span><span style="color: #990000;">)</span><span style="color: red;">}</span></span></tt></pre></div></div><div class="paragraph">The expression <em>incr</em>&nbsp;at line 42 is associated with&nbsp;two conflicting information about its type:</div><div class="ulist"><ul><li>line 1 indicates that <em>incr</em>&nbsp;is a function that&nbsp;expects an integer argument and returns an integer.<br/>
</li>
<li>line 42 indicates that&nbsp;<em>incr</em>&nbsp;is a function that takes a float.<br/>
</li>
</ul></div><div class="paragraph">These two types conflict, as&nbsp;the argument can not simultaneously be&nbsp;a float and an integer. Thus, current Opa compiler&nbsp;will deliver the following error message:<br/>
<br/>
</div><div class="listingblock"><div class="content"><pre>Error
File &quot;foo.opa&quot;,  <span style="background-color: yellow;">line 42, characters 15-25, (42:15-42:25 | 77-87)</span>
<tt>Function was found of type <span class="Apple-style-span" style="color: red;">int -&gt; int</span> but application expects it to be
of type <span class="Apple-style-span" style="color: red;">float -&gt; 'a</span>.
Types <span class="Apple-style-span" style="color: red;">int</span> and <span class="Apple-style-span" style="color: red;">float</span> are not compatible</tt></pre></div></div><div class="paragraph"><br/>
In the above message, one can spot two flaws.&nbsp;Firstly, it only draw programmer&rsquo;s attention to line 42,&nbsp;where <em>incr&nbsp;</em>is actually used.&nbsp;But, the mistake could as well be made in <em>incr</em>'s definition.&nbsp;The programmer might have wanted to change the&nbsp;<i>incr</i>&nbsp;to actually increment float numbers&nbsp;and after 41 lines of code totally forgot about it.&nbsp;Secondly, the message can be hard to understand.&nbsp;Its comprehension requires basic knowledge of type theory,&nbsp;while it could clearly state that there should be an integer instead of 6.0.</div><div class="paragraph"><br/>
These two flaws can be addressed as follows:&nbsp;Firstly, as mentioned earlier, the type error is created by the conflicting&nbsp;information gathered from two program points,&nbsp;hence, citing both conflicting points could help the programmer.&nbsp;Secondly, to make messages more comprehensible, we traverse the original types, until we spot the conflicting sub-types and we describe in simple language the position of the conflicting types.&nbsp;With the above two enhancements, the type error message is:<br/>
<br/>
</div><div class="listingblock"><div class="content"><pre><span style="color: #993399;">1</span><span style="color: #990000;">.</span>  <span style="font-weight: bold;"><span style="color: blue;">function</span></span> <span style="font-weight: bold;"><span style="color: black;">incr</span></span><span style="color: #990000;">(</span>x<span style="color: #990000;">)</span><span style="color: red;">{</span>x<span style="background-color: white; color: #990000;">+</span><span style="background-color: #d5a6bd; color: #993399;">1</span><span style="color: red;">}</span>
       <span style="color: #990000;">...</span>
<span style="color: #993399;">42</span><span style="color: #990000;">.</span> <span style="font-weight: bold;"><span style="color: blue;">function</span></span><span class="Apple-style-span" style="background-color: white;"> <span style="font-weight: bold;"><span style="color: black;">foo</span></span></span><span style="color: #990000;">()</span> <span style="background-color: yellow; color: red;">{</span><span style="background-color: yellow; font-weight: bold;"><span style="color: black;">incr</span></span><span style="background-color: yellow; color: #990000;">(</span><span style="background-color: lime; color: #993399;">6.0</span><span style="background-color: yellow; color: #990000;">)</span><span style="background-color: yellow; color: red;">}
</span></pre></div></div><br/>
<br/>
<div class="listingblock"><div class="content"><pre>Error: <tt>File &quot;foo.opa&quot;,  <span style="background-color: yellow;">line 42, characters 15-25, (42:15-42:25 | 77-87)</span>
Type conflict
  <span class="Apple-style-span" style="background-color: #d5a6bd;">(1:20-1:20)  </span>         int
  <span style="background-color: lime;">(42:21-42:23)</span>         float
<div></div>The argument of function incr should be <span class="Apple-style-span" style="color: red;">int</span> instead of <span class="Apple-style-span" style="color: red;">float</span>
 </tt></pre></div></div><br/>
<div class="paragraph">The first part of this message actually says that&nbsp;the integer type was found at line 1 and the float type at line 42.&nbsp;But these two types conflict, so the programmer should check these locations&nbsp;to correct the error.&nbsp;The second part of the message describes the original types&nbsp;that produced the error; i.e. how <tt>incr</tt>&nbsp;was defined and how&nbsp;the programmer tried to use it.<br/>
<br/>
</div><div class="paragraph">We applied the above enhancements to Opa&rsquo;s type error messages:&nbsp;in every message we cite the position of the conflicting information and&nbsp;whenever possible, the error is explained in simple language. These changes will be available in the next Opa&rsquo;s version.</div></div></div></div></div>

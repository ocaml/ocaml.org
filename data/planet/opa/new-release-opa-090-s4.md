---
title: 'New release: Opa 0.9.0 (S4)'
description: We are happy to announce the new release of Opa, version 0.9.0, codenamed
  Opa S4  (with this realease we are switching to sequential-based ...
url: http://blog.opalang.org/2012/02/new-release-opa-090-s4.html
date: 2012-02-14T17:07:00-00:00
preview_image:
featured:
authors:
- Adam Koprowski
---

<div class="sectionbody">
<div class="paragraph"><p>We are happy to announce the new release of Opa, version 0.9.0, codenamed <em>Opa S4</em> (with this realease we are switching to <a href="http://en.wikipedia.org/wiki/Software_versioning#Sequence-based_identifiers">sequential-based version identifiers</a>). You can get it <a href="http://opalang.org/get.xmlt">here</a>, see the CHANGELOG <a href="https://github.com/MLstate/opalang/blob/v1309/CHANGELOG">here</a> and the press release <a href="http://www.marketwire.com/press-release/Opa-S4-the-New-Version-of-Opa-Is-Now-Available-1619622.htm">here</a>.</p></div>
<div class="paragraph"><p>In this article I'll first sketch to the new users, why Opa could be interesting for them and then I will highlight the main changes introduced in this release. Also in the coming weeks expect some technical posts elaborating on those newly introduced features.</p></div>
<div class="sect3">
<h4>New users: why should you choose Opa?</h4>
</div>
<div class="sect2">
<h3>(1) Correctness</h3>
<div class="paragraph"><p>Are you a fan of debugging? Well, neither are we. Ever dreamt of web programming where things will &ldquo;just work&rdquo;? Stop dreaming&nbsp;&mdash;&nbsp;use Opa.</p></div>
<div class="paragraph"><p><strong>How is that possible?</strong> In Opa, a large spectrum of programming errors will be detected by the compiler, which may even suggest a hint on how to solve them. This is possible thanks to strong static typing of the language; with Opa you benefit from its power without having to explicitly write any type annotations. Sounds too good to be true? It is time you had this chat with your fellow Haskell programmer.</p></div>
<div class="paragraph"><p>&nbsp;&nbsp;&nbsp;<em>`&lsquo;Static typing [of Opa] helps catch most bugs at compile time rather than a stack trace at run time&rsquo;'</em><br/>
&nbsp;&nbsp;&nbsp;&nbsp;&mdash;&nbsp;Vimalkumar Jeyakumar, PhD in Computer Science at Stanford University</p></div>
<div class="paragraph"><p>&nbsp;&nbsp;&nbsp;<em>`&lsquo;Opa's type checking is simply amazing. [&hellip;] I think Opa will greatly change the future of web development&rsquo;'</em><br/>
&nbsp;&nbsp;&nbsp;&nbsp;&mdash;&nbsp;Tristan Sloughter, Co-Owner of Erlware, Erlang consulting organization</p></div>
<div class="paragraph"><p>&nbsp;&nbsp;&nbsp;<em>`&lsquo;Oh, just another web programming&nbsp;&mdash;&nbsp;WAIT, STATIC TYPING? I&rsquo;m in love!&rsquo;'</em><br/>
&nbsp;&nbsp;&nbsp;&nbsp;&mdash;&nbsp;Tweet by @1x</p></div>
</div>
<div class="sect2">
<h3>(2) Productivity</h3>
<div class="paragraph"><p>What if you could achieve twice as much, while writing only half of the code? Opa is well known for its conciseness. Have you ever seen a <a href="https://github.com/MLstate/hello_chat/blob/master/hello_chat.opa">distributed web chat</a> in &lt;50 LOC?</p></div>
<div class="paragraph"><p><strong>How is that possible?</strong> Opa&rsquo;s functional and high-level nature make for a very expressive language. Also its focus on web applications means that typical things needed in such development you will have at your fingertips.</p></div>
<div class="paragraph"><p>&nbsp;&nbsp;&nbsp;<em>`&lsquo;I'm coding in Opa at the moment. This thing rocks! It can't be repeated enough!&rsquo;'</em><br/>
&nbsp;&nbsp;&nbsp;&nbsp;&mdash;&nbsp;Julien Verlaguet, Software Engineer at Facebook</p></div>
<div class="paragraph"><p>&nbsp;&nbsp;&nbsp;<em>`&lsquo;[Opa] has great abstractions to make an impressive start!&rsquo;'</em><br/>
&nbsp;&nbsp;&nbsp;&nbsp;&mdash;&nbsp;Vimalkumar Jeyakumar, PhD in Computer Science at Stanford University</p></div>
</div>
<div class="sect2">
<h3>(3) Security</h3>
<div class="paragraph"><p>Concerned about security? Opa&rsquo;s unique design protects your applications against most common web attacks, including XSS attacks and all forms of code injection, with no additional effort from the programmers.</p></div>
<div class="paragraph"><p><strong>How is that possible?</strong> Opa is a statically, strongly typed language with built-in constructions for web programming. In Opa, web objects such as URL, HTML, CSS are not manipulated as raw characters by the servers but represented by structured data with a specific semantics and secured output methods. Opa&rsquo;s runtime also benefits from a dedicated web stack that complements the compile-time security protections.</p></div>
<div class="paragraph"><p>&nbsp;&nbsp;&nbsp;<em>`&lsquo;Opa is [&hellip;] extremely secure, much more so than just about any other programming language.&rsquo;'</em><br/>
&nbsp;&nbsp;&nbsp;&nbsp;&mdash;&nbsp;WebAppers, a popular blog dedicated to share top quality open source resources for web developers</p></div>
<div class="paragraph"><p>&nbsp;&nbsp;&nbsp;<em>`&lsquo;We chose the Opa technology because the features built in the language make it very easy to code secure and scalable systems.&rsquo;'</em><br/>
&nbsp;&nbsp;&nbsp;&nbsp;&mdash;&nbsp;Ludovic Wacheux, IT manager at Plug-up.</p></div>
<div class="sect3">
<h4>Existing users: what has changed in Opa S4?</h4>
</div>
</div>
<div class="sect2">
<h3>(1) New syntax available</h3>
<div class="paragraph"><p>For better readability and familiarity of the source code, we have designed a brand new syntax close to JavaScript and other C-like languages.</p></div>
<div class="paragraph"><p>With this new S4 release we let <strong>you decide</strong>: you can continue using the previous syntax&nbsp;&mdash;&nbsp;quite concise is it not?&nbsp;&mdash;&nbsp;or you can try the new one, which should be easier on the eye for C/JS/&hellip; programmers.</p></div>
</div>
<div class="sect2">
<h3>(2) High-quality support for MongoDB</h3>
<div class="paragraph"><p>Opa&rsquo;s database had one big advantage: good integration with the language and absolute ease of use. However, our power users were asking us for things like distribution, data replication and powerful querying capabilities. Admittedly those are aspects where we cannot compete with state-of-the-art DBMSs. Therefore starting with this S4 release we will be improving support for external DBMSs. In S4 you will find extensive support for MongoDB.</p></div>
</div>
<div class="sect2">
<h3>(3) More to come&hellip;</h3>
<div class="paragraph"><p>We had one more awesome news but unfortunately it didn't make it to this release (by a hair) and we'll need to postpone it. So: expect some exciting announcements in the weeks to come!</p></div>
</div>
</div>

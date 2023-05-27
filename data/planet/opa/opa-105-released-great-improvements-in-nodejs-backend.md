---
title: 'Opa 1.0.5 released: great improvements in Node.js backend'
description: "Last month we introduced the Node.js backend for Opa. We received lots
  of feedback, thank you all!\_We worked hard to take everything into co..."
url: http://blog.opalang.org/2012/08/opa-105-released-improvements-on-nodejs.html
date: 2012-08-02T10:43:00-00:00
preview_image:
featured:
authors:
- "C\xE9dric Soulas"
---

Last month we introduced the Node.js backend for Opa. We received lots of feedback, thank you all!&nbsp;We worked hard to take everything into consideration: the new Opa 1.0.5 release is a big one which comes with a lot of bug fixes, improvements and new features.<br/>
<br/>
Here is a quick summary of the changelog:<br/>
<ul>
<li>the generated JavaScript for&nbsp;Node.js&nbsp;is even smaller, once again, and really faster to compute (x3.75 to compute Fibonacci, &nbsp;x1.7 to serve hello pages under siege, compared to Opa 1.0.4).<br/>
</li>
<li>we introduced two new modules, <a href="http://doc.opalang.org/module/stdlib.core/Binary">Binary</a> and <a href="http://doc.opalang.org/module/stdlib.core/Pack">Pack</a>, for a better and easier support of binary data and buffers, exposed by various&nbsp;Node.js&nbsp;modules. For an example, have a look at&nbsp;<a href="https://github.com/MLstate/opalang/blob/master/lib/stdlib/core/web/server/client_code.opa">client_code.opa</a><br/>
</li>
<li>we improved the compiler error messages by polishing messages formatting and adding more hints, especially for parsing errors and typing errors&nbsp;(and we even further enhanced since this <a href="http://blog.opalang.org/2012/07/programming-tools-ux-better-type-error.html">blog post</a>). We hope Opa will be even easier for web developers that are not familiar with typed and compiled languages. If you think some error messages you get from Opa 1.0.5 could be improved, please let us know in the <a href="http://forum.opalang.org/">forum</a>.<br/>
</li>
<li>your application now checks&nbsp;Node.js&nbsp;version and modules dependencies at startup, to avoid nasty errors at runtime, and is more stable thanks to numerous little bug fixes and improvements.</li>
</ul>
Have a look at the complete changelog&nbsp;<a href="http://opalang.org/resources/changelog.xmlt">here</a>.<br/>
<br/>
We also reorganized the project <a href="https://github.com/MLstate/opalang">source code</a>: it should help any contributors who start digging into the code. And as we promised, we changed the license: the&nbsp;Node.js&nbsp;backend and the standard library are now MIT. If you want to contribute, tell us and we will be pleased to help.&nbsp;For example we are looking for contributors to add support of SQL databases and local storage.<br/>
<br/>
And don't forget the Opa developer challenge this summer! Find more details <a href="http://opalang.org/challenge/home.xmlt">here</a>.<br/>
<br/>
<a href="http://opalang.org/get.xmlt">Download Opa 1.0.5</a><br/>
<br/>

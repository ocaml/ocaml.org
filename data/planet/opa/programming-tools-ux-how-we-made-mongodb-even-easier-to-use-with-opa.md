---
title: 'Programming tools UX: How we made MongoDB even easier to use with Opa'
description: "Most developers nowadays rave about \u201CUser Experience\u201D or UX,
  i.e. designing software that pleases the users. Most of the time, UX involves ..."
url: http://blog.opalang.org/2012/03/programming-tools-ux-experience-how-we.html
date: 2012-03-29T12:42:00-00:00
preview_image:
featured:
authors:
- Adam Koprowski
---

<div class="sectionbody">
<div class="paragraph"><p>Most developers nowadays rave about &ldquo;User Experience&rdquo; or UX, i.e. designing software that pleases the users. Most of the time, UX involves GUI concepts and design, but not always. When we added support for the MongoDB database to the Opa programming language, we tried to make things as easy as possible for the developers. But a second look at the actual programming workflow showed room for improvement&nbsp;&mdash;&nbsp;and improvement we did.</p></div>
<div class="paragraph"><p>Little background first. Opa is a web programming platform. It unifies the approach to web development by providing a single, uniform programming language for both front- and back-end coding. Under the hood the program gets automatically divided into the server and the client part, with the former compiled to native code and the latter to JavaScript and all the communication between the two taken care of by the compiler. Opa also nicely integrates database functionality, including extensive support for MongoDB, parts of which I&rsquo;ll talk more about in this article. If interested in the language <a href="http://opalang.org">Opa's website</a> is a great place to start.</p></div>
<div class="paragraph"><p>A typical support for a database in any programming language consists of a driver for that particular database that provides connectivity with the DB and an API that allows the program to communicate with it. Opa goes few steps further. From the start the database was very tightly integrated into the language allowing one to very easily persist and query arbitrary data in one&rsquo;s program. Opa was using its own DBMS to accomplish that.</p></div>
<div class="paragraph"><p>That worked perfectly but our users wanted to have more freedom and to be able to use existing DBMSs. We quickly provided a driver&nbsp;&mdash;&nbsp;in the usual sense of this word&nbsp;&mdash;&nbsp;for MongoDB. But then we realized that a traditional driver comes with traditional problems: communication between the program and the database, going mostly via uninterpreted strings, is essentially untyped and unsafe. This flew in the face Opa&rsquo;s principles, as it aims to provide a single, uniform language that is safe and secure to use and where type-safety is a given.</p></div>
<div class="paragraph"><p>Our response to that was to provide an intelligent interface layer between Opa and MongoDB that ensures type-safety for all DB operations. On top of that we made the interface consistent with Opa&rsquo;s internal database so that now one can very easily switch back and forth between those two different backends. The usage scenario for Mongo was to first start its instance (after installing it on the given machine) and then, once it was running, the Opa application using it, so it went something like this (output slightly simplified for brevity):</p></div>
<div class="listingblock">
<div class="content">
<pre><tt>koper@thistle:~/test$ mkdir -p ~/mongodata/opa
koper@thistle:~/test$ ${INSTALL_DIR}/mongod --noprealloc --dbpath ~/mongodata/opa &gt; ~/mongodata/opa/log.txt 2&gt;&amp;1
koper@thistle:~/test$ ./test.exe --db-local ~/mongodata/opa
Opening database at ~/mongodata/opa
Test (OPA/1488) serving on http://thistle:8080</tt></pre></div></div>
<div class="paragraph"><p>this first creates directory <tt>~/mongodata/opa</tt> for database data, then runs MongoDB server storing logs at <tt>\~/mongodata/opa/log.txt</tt> and finally launches the Opa application which will use that database server instance.</p></div>
<div class="paragraph"><p>At the same time we also improved the query language in Opa. Just to give you an idea of how it works think how would you retrieve <em>all American or French movies with rating between 7 and 10, released after year 2000, sorted by the number of ratings they received and limited to the first 50 results?</em>. In Opa the query is actually shorter than this sentence:</p></div>
<div class="listingblock">
<div class="content">
<pre><tt><span style="color: #008080">movies</span> <span style="color: #990000">=</span> <span style="color: #990000">/</span>movies<span style="color: #990000">/</span>all<span style="color: #990000">[</span>rating <span style="color: #990000">&gt;=</span> <span style="color: #993399">7</span> <span style="font-weight: bold"><span style="color: #0000FF">and</span></span> rating <span style="color: #990000">&lt;=</span> <span style="color: #993399">10</span><span style="color: #990000">,</span> <span style="color: #008080">country</span> <span style="color: #990000">==</span> <span style="color: #FF0000">&quot;France&quot;</span> or <span style="color: #008080">country</span> <span style="color: #990000">==</span> <span style="color: #FF0000">&quot;USA&quot;</span><span style="color: #990000">,</span> release_year <span style="color: #990000">&gt;=</span> <span style="color: #993399">2000</span><span style="color: #990000">;</span> order <span style="color: #990000">+</span>ratings_no<span style="color: #990000">;</span> limit <span style="color: #993399">50</span><span style="color: #990000">]</span></tt></pre></div></div>
<div class="paragraph"><p>If you want to learn more about this cool, concise syntax check the <a href="http://doc.opalang.org/manual/Hello%E2%80%94database">relevant chapter</a> in Opa manual.</p></div>
<div class="paragraph"><p>That was cool. And we were quite pleased. Until one day we realized one fact: Opa&rsquo;s approach tightly integrating persistence in the language, essentially meant that our users didn&rsquo;t have to know first thing about MongoDB to be able to take advantage of this great, state-of-the-art database! They could just take a previous Opa program and now switch the database backend to Mongo. Except, for one thing. They of course had to be able to install and run it separately from the application itself, as illustrated above.</p></div>
<div class="paragraph"><p>We could improve this by providing some installation hints&hellip; But why not going one step further and actually performing the installation and run an instance of MongoDB for the user? With this improvement in place the above scenario became this (again output slightly simplified):</p></div>
<div class="listingblock">
<div class="content">
<pre><tt>koper@thistle:~/test$ ./test.exe
Opening database at ~/.opa/test.exe/db
MongoDB does not seem to be installed in &lsquo;~/.opa/test.exe/db&rsquo;; sit back, relax (or grab a cup of coffee) and I'll install it for you
Launching MongoDB...
Test (OPA/1488) serving on http://thistle:8080</tt></pre></div></div>
<div class="paragraph"><p>The change just meant one day of work of one of the Opa developers (thanks Quentin) but the results is lots of love from our users. Thank you for your support, we love to make you happy!</p></div>
</div>

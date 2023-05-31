---
title: 'Programming tools UX: How we simplified the creation of Opa projects'
description: "Introduction   In a previous post  we demonstrated how just a little
  work can drastically improve the UX of Opa.\_Here is another example..."
url: http://blog.opalang.org/2012/06/programming-tools-ux-how-we-simplified.html
date: 2012-06-13T14:58:00-00:00
preview_image:
featured:
authors:
- "C\xE9dric Soulas"
---

<div class="sectionbody">
<h3>

 Introduction</h3>
<div class="paragraph">
In a <a href="http://blog.opalang.org/2012/03/programming-tools-ux-experience-how-we.html">previous post</a> we demonstrated how just a little work can drastically improve the UX of Opa.&nbsp;Here is another example: automatic project creation. Again, it just took us just a few hours to add this feature and we think it greatly improved the UX of the compiler. Let's take an example.<br/>
<br/>
To compile and run a single file all you just need to type is:</div>
<div class="listingblock">
<div class="content">
<pre><tt>$ opa hello_world.opa --</tt></pre>
</div>
</div>
<div class="paragraph">
But when your application becomes bigger you will probably additionally  need to:</div>
<div class="ulist">
<ul>
<li> add a <tt>resources</tt> directory with images and css files,<br/>
</li>
<li> split your project into several files,<br/>
</li>
<li> group those files into different packages,<br/>
</li>
<li> and create a Makefile.<br/>
</li>
</ul>
</div>
<h3>

 Generate a full Opa project</h3>
<div style="clear: left;">
</div>
<div class="paragraph">
Now Opa is able to generate all the required architecture from a single command line:</div>
<div class="listingblock">
<div class="content">
<pre><tt>$ opa create myapp</tt></pre>
</div>
</div>
<div class="paragraph">
It will create a new <tt>myapp</tt> directory and generate all those files:</div>
<div class="listingblock">
<div class="content">
<pre><tt>Makefile
Makefile.common
opa.conf
resources/css/style.css
src/controller.opa
src/model.opa
src/view.opa</tt></pre>
</div>
</div>
<div class="paragraph">
The source code comes charged with everything you need to get started, in particular:</div>
<div class="ulist">
<ul>
<li> a database declaration,<br/>
</li>
<li> a static include of the <tt>resources</tt> directory,<br/>
</li>
<li> the appropriate URL parsers,<br/>
</li>
<li> two bootstraped pages as an example: a wiki and a statistics panel.<br/>
</li>
</ul>
</div>
<strong><br/>
Configuration file</strong><br/>
<div style="clear: left;">
</div>
<div class="paragraph">
Let&rsquo;s take the opportunity to have a closer look at the generated configuration file&nbsp;<span style="font-family: monospace;">opa.conf</span>:</div>
<div class="listingblock">
<div class="content">
<pre><tt>myapp.controller:
        import myapp.view
        src/controller.opa

myapp.view:
        import myapp.model
        import stdlib.themes.bootstrap
        src/view.opa

myapp.model:
        src/model.opa</tt></pre>
</div>
</div>
<div class="paragraph">
When you use such a configuration file, you don&rsquo;t need to write package declarations (such as <tt>package myapp.controller</tt> and <tt>import myapp.view</tt>) at the beginning of your <tt>.opa</tt> files.<br/>
Everything is centralized into a single configure file; just add the <tt>--conf</tt> option when invoking <tt>opa</tt> compiler to use it.</div>
<h3>

 Compile and run</h3>
<div style="clear: left;">
</div>
<div class="paragraph">
If you generated the application with <tt>opa create</tt>, it can be compiled and executed very easily:</div>
<div class="listingblock">
<div class="content">
<pre><tt>$ cd myapp
$ make run</tt></pre>
</div>
</div>
<div class="paragraph">
It will automatically download and start mongoDB on first startup. If you already have mongoDB installed and running, edit the Makefile and use <tt>--db-remote host:port</tt> option.</div>
<h3>

 Try and contribute!</h3>
<div style="clear: left;">
</div>
<div class="paragraph">
You can find the sources of the tool in the <a href="https://github.com/MLstate/opalang">opalang repository</a> on github, more specifically in the <a href="https://github.com/MLstate/opalang/tree/master/tools/opa-create"><tt>tools/opa-create</tt></a> folder.<br/>
You can already try it with the <a href="http://opalang.org/get.xmlt">latest stable package</a>.</div>
<div class="paragraph">
In the future we can imagine adding new templates and new options like <tt>--author myname</tt>, <tt>--no-mvc</tt>, <tt>--example chat</tt>, etc.<br/>
All suggestions and contributions are welcome! The tool itself is written in Opa, so you can even brush up your Opa skills while contributing!</div>
</div>

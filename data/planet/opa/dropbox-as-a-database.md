---
title: Dropbox-as-a-Database
description: We live in the as-a era. IaaS, SaaS, PaaS. Even Database-as-a-Service
  where companies offer SQL and NoSQL database management systems hosted...
url: http://blog.opalang.org/2012/10/dropbox-as-database.html
date: 2012-10-31T14:51:00-00:00
preview_image: http://4.bp.blogspot.com/-aCPIKt9z5Iw/UJFAkrSya5I/AAAAAAAAAA8/jAkb09uRzSc/w1200-h630-p-k-no-nu/dropbox-storage.png
featured:
authors:
- "C\xE9dric Soulas"
---

We live in the as-a era. IaaS, SaaS, PaaS. Even Database-as-a-Service where companies offer SQL and NoSQL database management systems hosted online.<br/>
<br/>
We played with the concept a bit, and, in an era which is also the one of cloud storage with Dropbox, Box, Google Drive, Skydrive and the like, we wondered why applications and services shouldn't just use <i>our</i> cloud storage account to store <i>our</i> data. Why everything should be centralized? Why all applications and services behave like Mega and not like BitTorrent?<br/>
<br/>
That's why we introduced in <a href="http://opalang.org/">Opa 1.0.7</a> a new database back-end working on top of Dropbox. If you're new to <a href="http://opalang.org/">Opa</a>, you can read this <a href="https://github.com/MLstate/opalang/wiki/A-tour-of-Opa">introduction</a>, but as the syntax should look familiar, you should still understand the code without any prior knowledge of Opa.<br/>
<br/>
Try a <a href="http://servermonitor-cedric.dotcloud.com/">demo application</a> (1) to get an idea of the concept (<a href="https://github.com/cedricss/server-monitor">source code</a> on github). The data of this sample application is not stored on <strike>Heroku</strike> dotCloud, neither on any centralized server. Instead, every user data is directly stored on every user Dropbox account.<br/>
<br/>
(1) <b>update</b>: Heroku is <a href="https://status.heroku.com/incidents/463">down</a>, we are moving the demo to another cloud provider.<br/>
&nbsp; &nbsp;&nbsp; <b>update</b>: the demo is now on dotCloud.<br/>
&nbsp; &nbsp;&nbsp; <b>update</b>: <a href="http://blog.opalang.org/2012/11/dropbox-as-database-tutorial.html">Dropbox-as-a-Database, the tutorial</a> is available!<br/>
<br/>
Let's dig into details about this new (and experimental) back-end.<br/>
<img src="http://4.bp.blogspot.com/-aCPIKt9z5Iw/UJFAkrSya5I/AAAAAAAAAA8/jAkb09uRzSc/s1600/dropbox-storage.png"/><br/>
<br/>
<a name="more"></a><br/>
<br/>
<h2>Introduction: Databases in Opa</h2>Let's explain our <a href="http://server-monitor.herokuapp.com/">demo app</a>. The central notion of the app is the <code>job</code>, defined with an url to monitor and an execution frequency:<br/>
<pre><code>type job = { string url, int freq }</code></pre>A database storing those jobs is defined this way in Opa:<br/>
<pre><code>database monitor {
  stringmap(job) /jobs
}</code></pre><ul><li><code>monitor</code> is the name of the database</li>
<li><code>/jobs</code> is the name of the collection</li>
<li><code>stringmap(job)</code> is the type of the collection: a map where keys are strings and values are of type <code>job</code>.</li>
</ul>A function to add a job in the database looks like:<br/>
<pre><code>function add(name, url, freq) {
    /monitor/jobs[name] &lt;- { url:url, freq:freq }
}</code></pre>And to get all of them, we write:<br/>
<pre><code>function get_all(){
    /monitor/jobs
}</code></pre>The code above is the standard way to access and update data in Opa. Follow this <a href="https://github.com/MLstate/opalang/wiki/Hello,-database">tutorial</a> to learn more about it or read the <a href="https://github.com/MLstate/opalang/wiki/The-database">database chapter</a>. The default database back-end in Opa is <a href="http://www.mongodb.org/">MongoDB</a>.<br/>
<h2><a href="http://www.blogger.com/blogger.g?blogID=2073503406800427577" name="use-case"></a> Storing Application Data in Dropbox</h2>To store the <code>job</code> above in a Dropbox folder, we could use a classic Node.js Dropbox library:<br/>
<pre><code>client.put(&quot;path/to/directory/filename.json&quot;, serialize(job), callback)
client.get(
    &quot;path/to/directory/filename.json&quot;,
    function(status, data, metadata) { job = unserialize(data); ... }
)</code></pre>And rely on standard API calls each time we want to access data. It's probably how most Dropbox-enabled apps work today.<br/>
<h2>Switching from MongoDB to Dropbox</h2>Using a classic Node.js Dropbox library is quite easy for little data. But what if your application gets bigger? The nice database automation concept of Opa is lost, and we are back to tedious programming tasks. A typo in an API call? A possibly-hard-to-iron-out bug.<br/>
We would love to reuse the same Opa syntax as above, especially as it would allow the same application code to either run on MongoDB centrally, or using Dropbox.<br/>
<pre><code>/path/to/directory[filename] &lt;- &quot;content&quot;  // write 
content = /path/to/directory[filename]     // read</code></pre>This is exactly what the new Opa Dropbox back-end offers. The only change required to switch from MongoDB to Dropbox is to add a <code>@dropbox</code> annotation:<br/>
<pre><code>database monitor @dropbox {
    stringmap(job) /jobs
}</code></pre>That's all. All the other functions seen in the introduction remain unchanged! Quite easy, isn't it?<br/>
<h2>Behind the Scene</h2><h3>Path Notation and Automatic Json Serialization</h3><img src="http://4.bp.blogspot.com/-aCPIKt9z5Iw/UJFAkrSya5I/AAAAAAAAAA8/jAkb09uRzSc/s1600/dropbox-storage.png"/><br/>
<br/>
<br/>
<br/>
How does it work behind the scene? When we write:<br/>
<pre><code>/monitor/jobs[name] &lt;- { url:url, freq:freq }</code></pre>It serializes the Opa record to json, for example:<br/>
<pre><code>{&quot;url&quot;:&quot;http://opalang.org&quot;,&quot;freq&quot;:30}</code></pre><blockquote><b>Note</b>: the serialization works on more complex Opa structures like <code>list</code> or <code>option</code>&nbsp;and supports embedded records</blockquote>After the serialization, content is sent to the Dropbox account, regarding the current user session, at this location:<br/>
<pre><code>Apps/monitor/jobs/opalang.json</code></pre><h3>Non-blocking by Default</h3>To retrieve and display all jobs, we simply write:<br/>
<pre><code>all_jobs = /monitor/jobs   // retrieve all the jobs
display(all_jobs)          // do something</code></pre>This will retrieve the list of json file stored in the <code>Apps/monitor/jobs/</code> folder, and request the content for all of them.<br/>
All those requests are sent in parallel to the Dropbox API. The final <code>all_jobs</code> value is constructed progressively, as the responses arrive from Dropbox (they may arrive out of order).<br/>
What is really important here is that Opa is non-blocking by default:<br/>
<blockquote>Modern applications use a lot of asynchronous calls. Dealing with callbacks manually can be painful, and failing to do so properly blocks the application runtime. To make asynchronous programming easy without blocking the application, Opa-generated JavaScript code uses smart continuations. (http://opalang.org)</blockquote>It means two things:<br/>
<ul><li>in the previous example, we don't have to pass the <code>display</code> function as a callback, Opa compiles it to the appropriate asynchronous and non-blocking JS code. In fact, we can even just write <code>display(/monitor/jobs)</code> as if it were synchronous!</li>
<li>our application server doesn't block during the treatment: all other computations and client requests are fairly handled, thanks to the <a href="http://en.wikipedia.org/wiki/Continuation-passing_style">CPS</a> generated code and the Opa scheduler. This is automatic and transparent in Opa.</li>
</ul><h2>Going Further</h2>We are not limited to maps. Simple value storage is possible:<br/>
<pre><code>database monitor @dropbox {
  int /counter
}</code></pre>I didn't detail here the user authentication process with Dropbox, it's just two functions you can read in the <a href="https://github.com/cedricss/server-monitor/blob/master/main.opa#L158">source code</a> of the <a href="http://server-monitor.herokuapp.com/">server-monitor demo</a>.<br/>
By the way, here is how to specify your <a href="https://www.dropbox.com/developers/apps">Dropbox App keys</a> in the command line:<br/>
<pre><code>./app.js --db-remote:monitor appkey:appsecret</code></pre>Welcome to the Dropbox-as-a-Service era!<br/>
<h4>Notes</h4><ul><li>This release is experimental. You can <a href="https://github.com/MLstate/opalang/issues">submit issues on github</a>.</li>
<li>This back-end is still limited compared to powerful MongoDB queries, but it can be very useful in many cases.</li>
</ul>

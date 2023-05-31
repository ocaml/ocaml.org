---
title: The Opa Framework Hits a Major Milestone
description: When we released Opa 1.0 in June this year, we made a major move by supporting
  Node.js as the main backend for Opa.  Since then, as we told ...
url: http://blog.opalang.org/2012/09/the-opa-framework-hits-major-milestone.html
date: 2012-09-10T14:31:00-00:00
preview_image: https://lh3.googleusercontent.com/blogger_img_proxy/AByxGDTIZDcBUbrZqgXEk1FtUkvcFeN0kuHfi_uJq7lAqMP5Fn15EUOEDZZhJ3YENSVgGKlguA7JoszYwSQWe26SWE2yVUuvRA58xAHwUGheOl-VfUAhpJY-98Qh=w1200-h630-p-k-no-nu
featured:
authors:
- HB
---

When we released Opa 1.0 in June this year, we made a major move by supporting Node.js as the main backend for Opa.<br/>
Since then, as <a href="http://blog.opalang.org/2012/06/announcing-opa-10.html">we told our on blog</a> at the time, we are focused optimizing the code generation and runtime of Node.js. We already did great improvements in the 5 minor releases up to the current 1.0.5.<br/>
And today, we are happy to inform you that 1.0.6 ships. But don't trust the minor revision number: 1.0.6 is a major release and improvement to Opa. The only reason we're keeping away from using the 1.1 tag is the forthcoming support of <a href="http://npmjs.org/">npm packages</a>.<br/>
This post tells where we are headed, what are the remaining goals and try to answer the questions that are frequently asked either online or in person for instance at <a href="http://www.meetup.com/The-Opa-Hackathons-in-the-Bay-Area/events/73780032/">our last hackathon</a>.<br/>
<h2>
Documentation</h2>
As of today, our major focus becomes documentation. Opa already has a very rich set of features, but many parts lack proper documentation. Even our manual needs to be improved.<br/>
Therefore we moved our manual from our proprietary system to GitHub:<br/>
<pre><code>https://github.com/MLstate/opalang/wiki/A-tour-of-Opa</code></pre>
and made it globally editable. <em>Please help us and contribute to improving it!</em><br/>
Our next goals are:<br/>
<br/>
<ul>
<li>To simplify the presentation of the <a href="http://doc.opalang.org/api">API documentation</a> and add new features, such as browse and query by type.&nbsp;</li>
<li>To create a cookbook with small Opa recipes to take inspiration from in your applications. We will automatically ensure that recipes compile with the latest versions of Opa.</li>
<li>Optimize the API browser to make it faster, and make it social by accepting user contributions. - And more generally create easily accessible documentation about Opa.</li>
</ul>
<br/>
Not to mention the forthcoming book on Opa which Adam and I have almost finished, to be published by O'Reilly. Stay tuned for the release!<br/>
<h2>
Optimization</h2>
Our two perpetual goals are:<br/>
<ul>
<li>To reduce size of the JavaScript code;</li>
<li>To make JavaScript runtime faster.</li>
</ul>
But for the last 40 days, this was our main, if not unique, preoccupation.<br/>
And we're glad that we did not made improvements... We made huge ones!<br/>
<ul><img src="https://pbs.twimg.com/media/A2b14OiCcAAWS--.jpg:large" width="50%"/>
<li>Between Opa 1.0.5 and 1.0.6, the size of the Opa-generated JavaScript shrunk an unbelievable 62%.</li>
<li>Opa apps now use 29% less memory and start 38% faster!</li>
<img src="https://pbs.twimg.com/media/A2byK_ECAAAA0rY.jpg:large" width="50%"/>
<li>Not to mention they run 46% faster (on a Fibonacci benchmark) and handle 49% more request/second on the same hardware.</li>
</ul>
Give it a try now, just in time for the <a href="http://opalang.org/challenge/home.xmlt">Opa Developer Challenge</a>!<br/>
<h2>
JavaScript Support</h2>
We are working hard to make the JavaScript code that Opa outputs as simple and as readable as possible. And the shorter JS code in 1.0.6 is clearly a step in that direction.<br/>
For 1.1, we plan to integrate with Node packages (npm), so that Opa-built packages are standard node packages, which means:<br/>
<br/>
<ol>
<li>Opa packages can hosted in the npmjs repository;</li>
<li>Opa packages can be used by any Node.js application;</li>
<li>Opa can use existing npmjs packages easily.</li>
</ol>
<br/>
We will blog about this and the coming changes soon.<br/>
<h2>
Other changes</h2>
As usual, please look at the <a href="http://opalang.org/resources/changelog.xmlt">changelog</a>. In particular, please note the <em>new opa-bundle</em> application. <em>opa-bundle</em> is a CLI that bundles the JS, depends and stdlib of an app for an easy deployment on a clean server.<br/>
<pre><code>opa bundle TARGET</code></pre>
will create a self contained TARGET.opa-bundle and tar-gzip it.<br/>
Note also that there is a new AMI for Opa on Amazon EC2. Read further on our <a href="https://github.com/MLstate/opalang/wiki/Amazon-Image-for-Opa">GitHub wiki</a>.<br/>
<h2>
Frequent requests</h2>
<h3>
Dynamic programming</h3>
We are often asked for a &quot;dynamic&quot;-like programming workflow where Opa compiler is called automatically on code changes and the resulting app relaunched. The new <a href="https://github.com/OpaOnWindowsNow/opa-dynamic">opa-dynamic</a> project on GitHub does just this. It is itself implemented in Opa and released under the MIT license. Please test it (and contribute by sending pull requests if you feel like it).<br/>
<h3>
Reactive front-end programming</h3>
Another popular demand is support for automatic synchronization of values, generalizing the prototype discussed in our <a href="http://forum.opalang.org/#213%26qid=-56681%26q=reactive">forum</a>. We are investigating to use an existing JavaScript framework for this, such as AngularJS. Please share your thoughts with us, for instance by filing <a href="https://github.com/MLstate/opalang/issues?direction=desc&amp;sort=created&amp;state=open">issues</a>.<br/>
<h3>
SQL support</h3>
Our main backend is now Node.js and MongoDB but we keep getting legitimate feedback asking for support of other backends and databases. We can tell you that:<br/>
<br/>
<ul>
<li>Support of SQL databases, starting with MySQL is high on that list.</li>
<li>Support of Java and the JVM is a possible long-term goal.</li>
</ul>
<br/>
For all these projects, community contributions are more than welcome. Opa is a highly innovative framework -- we need <em>your help</em> to make it happen.

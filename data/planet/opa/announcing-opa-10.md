---
title: Announcing Opa 1.0
description: Today, just 365 days since the first open source release of Opa, we announce
  the release of Opa 1.0.   Opa 1.0 introduces the last major fea...
url: http://blog.opalang.org/2012/06/announcing-opa-10.html
date: 2012-06-21T14:04:00-00:00
preview_image:
featured:
authors:
- HB
---

Today, just 365 days since the first open source release of Opa, we announce the release of Opa 1.0.<br/>
<br/>
Opa 1.0 introduces the last major feature we wanted for Opa: The complete support for the JavaScript stack, including Node.js and MongoDB.<br/>
<br/>
We originally released Opa supporting only its own, native backend. While we still love this platform, much of the feedback we received asked us to support existing runtime technologies. We chose the JavaScript stack as our target, since we already had support for JavaScript on the client, we already had support for MongoDB, and we already had JavaScript-inspired syntax. Not to mention the support for Node.js was the platform the most asked for (together with the JVM, which represents a greater work).<br/>
<br/>
So starting today, Opa generates standard JavaScript applications and becomes the most advanced framework ever built for JavaScript. The workflow is super easy. Developers just write applications in Opa, which checks automatically the quality of the application and then generates a standard JavaScript application. In a matter of seconds.<br/>
<br/>
Let me detail the Top 3 features we have built in:<br/>
<ul><li>Automatic client/server/database distribution,</li>
<li>Automatic code rewriting to ensure that the Node.js application code does not hang, by automating the use of fibers,</li>
<li>Strong static typing from the client to the database, bringing you the equivalent of bazillions of automated tests. We worked hard to make typing easy thanks to type inference -- which means most types are never written in your Opa code.</li>
</ul><br/>
No other framework has built so many advanced algorithms to make developing high-quality Node.js and MongoDB applications faster and easier. And let me insist: The unique strong static typing of Opa is a key differentiator in a world of fragile frameworks.<br/>
<br/>
Opa 1.0 is not the end of road, of course. It's just the beginning. We will try to keep our road-map public from now on. Let's do it right now! Our next three next goals for 1.1, due at the end of this summer, are to:<br/>
<ul><li>Improve the standard library and APIs,</li>
<li>Improve error messages that the compiler outputs,</li>
<li>Improve the performance of the Node.js backend.</li>
</ul><br/>
Nothing extraordinary but the polish we all love from a mature technology.<br/>
<br/>
Just a last word: We would be nothing without our community. Contributions, discussions on the mailing list have had a strong impact on Opa. Thank you all, and let's make Opa the de-facto framework for JavaScript applications.<br/>

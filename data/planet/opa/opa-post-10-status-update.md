---
title: 'Opa: Post 1.0 Status Update'
description: Last week, we launched 1.0. That's a milestone for a project. In our
  case, it meant that all the features that we wanted for 1.0 were in... ...
url: http://blog.opalang.org/2012/06/opa-post-10-status-update.html
date: 2012-06-27T17:36:00-00:00
preview_image:
featured:
authors:
- HB
---

Last week, we launched 1.0. That's a milestone for a project. In our case, it meant that all the features that we wanted for 1.0 were in... and that of course meant the support of Node.js. Thank you for all nice messages telling it was a perfect move. When we read things like &quot;Now, I want to use Opa&quot;, that goes straight to the heart. And of course, turns out there was another major reason for releasing 1.0: team was thirsty!<br/>
<br/>
Launching 1.0 provided us with a great amount of feedback. And bug reports. As a result, we are hard at work solving all reported issues, hence the Opa version number is growing quickly:<br/>
<ul><li>1.0.1 reinstated scaffolding, SSL support along with MongoDB bugfixes, just one day after launch;</li>
<li>1.0.2 fixed the debian and Ubuntu packages and introduced new packages that were left over with Node.js support;</li>
<li> 1.0.3 reduces greatly the size of the package download (and that matters, since Opa is much downloaded). Downloads are now 66% lighter!</li>
</ul><br/>
The updated source code should also be available soon -- we are cleaning the tree and updating the license on all source files. As <a href="http://blog.opalang.org/2012/05/opa-license-change-not-just-agpl.html">promised earlier</a>, Opa 1.0 is released under a much more permissive license that allows anyone to release applications written with Opa under any license.<br/>
<br/>
As promised, the whole team is now high-boiling making Opa leaner, better, nicer. <br/>
<br/>
Let's dig into what we are building right now:<br/>
<ul><li>First, the size of the generated JavaScript is today way too big. It's not cleaned, nor minimized as we wanted to be sure not to introduce bugs. But we are now focused on reducing the line count by 99%. That should impact favorably compilation time, launch time, and of course the size of Opa programs. Best news: We are expecting to release this <strong>this week</strong>!</li>
<li>Second, better error messages. Many new developers look at Opa, and some get a hard time understanding the error messages. Over the next months, we will release major innovations in displaying type errors.</li>
<li>Third, easy deployment on clouds. We are now working on basic tools and collaborating with major cloud providers to bring you very easy deployments soon.</li>
</ul><br/>
Oh, and when we're not doing all this, we keep doing little improvements, bugfixes to about everything to make sure Opa rocks!<br/>
If you have any suggestion, please tell on <a href="http://forum.opalang.org">the forum</a> or on <a href="https://github.com/mlstate/opalang/issues?direction=desc&amp;sort=created&amp;state=open">github</a>.<br/>
If you want to join the fame of <a href="http://opalang.org/contributors.xmlt">contributors</a>, it's also a perfect time to do so: Come on in and say &quot;Hi&quot;!

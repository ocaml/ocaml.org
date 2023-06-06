---
title: 'Opa License Change: Not just AGPL anymore'
description: The problem  Since we launched Opa almost a year ago, we received countless
  feedback. To date, the main criticism about Opa is not about the...
url: http://blog.opalang.org/2012/05/opa-license-change-not-just-agpl.html
date: 2012-05-29T14:51:00-00:00
preview_image:
featured:
authors:
- HB
---

<h2>The problem</h2><br/>
Since we launched Opa almost a year ago, we received countless feedback. To date, the main criticism about Opa is not about the technology itself, but its licensing.<br/>
<br/>
We chose initially to release Opa under the Affero GPL (AGPL) license. We made this choice to ensure that all improvements to Opa benefit the whole community -- and also provide more programs written in Opa.<br/>
<br/>
There are two components in Opa, both released under the AGPL:<br/>
<ul><li>The compiler,</li>
<li>The runtime environment.</li>
</ul><br/>
And because of the latter, every program written in Opa, that links to the runtime, must itself be released under the AGPL or the GPL.<br/>
<br/>
On paper,<br/>
<ul><li>The license convinces (as in enforces) developers to release the source code of the applications written in Opa. Which means more code to look at, great for a new language.</li>
<li>The license entices business users to buy a license from us and fund us to continue the development of Opa. That&rsquo;s a cool business model for a company with only engineers.</li>
</ul><br/>
But in reality, it turns out the license is barred from being used at many companies, so we end up repelling developers. Even worse, we don't get the main expected benefit as most developers won&rsquo;t release the source anyway while they develop for many possible reasons: It&rsquo;s not working yet, they are not proud of their code yet, they don&rsquo;t know what to do with it yet, etc.<br/>
<br/>
And customers struggle to find the value in the &ldquo;same thing&rdquo; that others get for free. It was better to sell support as such.<br/>
<br/>
<h2>The solution</h2><br/>
As promised earlier and now mentioned in our FAQ, we are changing the license of Opa. The new licensing scheme will take effect <strong>June 20th</strong>.<br/>
<br/>
Let me share with you in advance the details of the licensing and the reasoning behind it.<br/>
<br/>
<ol><li>The Opa compiler will remain an AGPL project.</li>
<li>The standard library and the native backend will be licensed under the GPL license with the so-called ClassPath exception, like Java. The exception means you can link the GPL code with any code, opening the door to license your application under any license.</li>
<li>The forthcoming Node.js backend will be licensed under the MIT license.</li>
</ol><br/>
<h2>The rationale</h2><br/>
For Opa developers, the license change will allow the community to write applications in Opa and license them at will -- and we are happy to address this much requested issue.<br/>
<br/>
But we are just a start-up. We worked hard to build Opa and we believe our approach to type-safe, easy web app development is unmatched. We don't want (major) corporations and/or cloud platforms to be able to take parts or fork the Opa <emph>compiler</emph> without either release the changes and related projects or work with us.

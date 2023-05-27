---
title: Opa 1.0.4 Released
description: 'Short news: Opa 1.0.4 has just been released. Tokyo:opa henri$ wc -l
  hack1.opa        22 hack1.opa  Tokyo:opa henri$ time opa hack1.opa     ...'
url: http://blog.opalang.org/2012/07/opa-104-released.html
date: 2012-07-04T17:48:00-00:00
preview_image:
featured:
authors:
- HB
---

<p>Short news: Opa 1.0.4 has just been released.</p><pre>Tokyo:opa henri$ wc -l hack1.opa 
      22 hack1.opa

Tokyo:opa henri$ time opa hack1.opa     
real 0m1.491s
user 0m1.278s
sys 0m0.177s

Tokyo:opa henri$ wc -l hack1.js 
     112 hack1.js
</pre><br/>
<p>In case of type errors, it's much faster not to break your workflow:</p><pre>Tokyo:opa henri$ time opa hack1.opa 
Error
File &quot;hack1.opa&quot;, line 6, characters 10-15, (6:10-6:15 | 85-90)
Expression has type string but is coerced into int.


real 0m0.248s
user 0m0.186s
sys 0m0.050s
</pre><br/>
<p>And speaking about workflow, stay tuned for a next blog post.</p>

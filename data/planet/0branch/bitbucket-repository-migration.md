---
title: Bitbucket repository migration
description:
url: http://blog.0branch.com/posts/2020-02-03-bitbucket-migration.html
date: 2020-02-03T19:55:00-00:00
preview_image:
featured:
authors:
- 0branch
---

<div>
  <div class="span-22">
    <div class="span-12"><h1>Bitbucket repository migration</h1></div>
    <div style="text-align: right" class="span-10 last">
      <a href="https://blog.0branch.com/index.html">#</a> February  3, 2020
    </div>
  </div>
  <hr/>
  <div>
    <p>Since Bitbucket are discontinuing Mercurial support in a few months&rsquo; time (see <a href="https://bitbucket.org/blog/sunsetting-mercurial-support-in-bitbucket">here</a>), I&rsquo;ve started migrating a few old repositories:</p>
<ul>
<li><a href="https://github.com/0branch/hugo-unix">hugo-unix</a> is now hosted on GitHub
<ul>
<li>&hellip; and Nikos released <a href="https://github.com/0branch/hugo-unix/releases/tag/v3.1.05">v3.1.05</a> today.</li>
<li>Conversion was done with <a href="https://foss.heptapod.net/mercurial/hg-git">hg-git</a>.</li>
</ul></li>
<li>Extensions <a href="http://hg.0branch.com/hg-prettypaths">hg-prettypaths</a> and <a href="http://hg.0branch.com/hg-persona/">hg-persona</a> are now archived on this server.
<ul>
<li>Note that <a href="http://hg.0branch.com/hg-prettypaths">hg-prettypaths</a> is deprecated (broken in newer versions of Mercurial).</li>
<li><a href="http://hg.0branch.com/hg-persona/">hg-persona</a> has been updated to work with hg &ge;4.3.</li>
</ul></li>
</ul>
  </div>
</div>

<hr/>

<div></div>

<noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
<a href="http://disqus.com" class="dsq-brlink">comments powered by <span class="logo-disqus">Disqus</span></a>


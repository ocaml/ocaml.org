---
title: 'Mercurial: prettyconfig extension'
description:
url: http://blog.0branch.com/posts/2020-02-15-prettyconfig-extension.html
date: 2020-02-16T02:12:00-00:00
preview_image:
featured:
authors:
- 0branch
---

<div>
  <div class="span-22">
    <div class="span-12"><h1>Mercurial: prettyconfig extension</h1></div>
    <div style="text-align: right" class="span-10 last">
      <a href="https://blog.0branch.com/index.html">#</a> February 16, 2020
    </div>
  </div>
  <hr/>
  <div>
    <p>Since the <a href="https://blog.0branch.com/posts/2020-02-03-bitbucket-migration.html">Bitbucket migration</a>, I&rsquo;ve found myself tinkering<a href="https://blog.0branch.com/rss.xml#fn1" class="footnote-ref"><sup>1</sup></a> with Mercurial and its extensions system again (after a long hiatus).</p>
<p>One byproduct of this was a simple, single function <a href="http://hg.0branch.com/hg-aliases">extension</a> for listing aliases in a user-friendly way. I subsequently realised that the same behaviour would be useful for arbitrary config sections (aliases, paths, schemes)&hellip; and so, the <a href="http://hg.0branch.com/hg-prettyconfig">prettyconfig</a> fork.</p>
<p>The <a href="http://hg.0branch.com/hg-prettyconfig">prettyconfig</a> extension defines a single command, <code>prettyconfig</code>, for colourising and neatly displaying config values. Without arguments, all config name/value pairs are output, where names are qualified with section prefixes (akin to <code>hg showconfig</code>). Single sections are displayed with the <code>-s</code> (or <code>--section</code>) switch, e.g.:</p>
<pre><code>$ hg prettyconfig  -s       alias   # display aliases
$ hg prettyconfig --section alias   # same thing</code></pre>
<p>Colouring can be applied to the output by setting the following two labels in an <code>.hgrc</code> file (either globally or locally):</p>
<div class="sourceCode"><pre class="sourceCode ini"><code class="sourceCode ini"><a class="sourceLine" data-line-number="1"><span class="kw">[color]</span></a>
<a class="sourceLine" data-line-number="2"><span class="dt">prettyconfig.name </span><span class="ot">=</span><span class="st"> yellow</span></a>
<a class="sourceLine" data-line-number="3"><span class="dt">prettyconfig.value </span><span class="ot">=</span><span class="st"> green</span></a></code></pre></div>
<p>So far, I&rsquo;ve found the following aliases<a href="https://blog.0branch.com/rss.xml#fn2" class="footnote-ref"><sup>2</sup></a> useful enough to store globally in <code>~/.hgrc</code>:</p>
<div class="sourceCode"><pre class="sourceCode ini"><code class="sourceCode ini"><a class="sourceLine" data-line-number="1"><span class="kw">[alias]</span></a>
<a class="sourceLine" data-line-number="2"><span class="dt">aliases </span><span class="ot">=</span><span class="st"> prettyconfig -s alias</span></a>
<a class="sourceLine" data-line-number="3"><span class="dt">schemes </span><span class="ot">=</span><span class="st"> prettyconfig -s schemes</span></a></code></pre></div>
<p>Hopefully others will find <a href="http://hg.0branch.com/hg-prettyconfig">prettyconfig</a> useful too. Feedback is welcome.</p>
<section class="footnotes">
<hr/>
<ol>
<li><p>Perusing APIs, making old extensions Python 3 compatible, tweaking web templates, etc.<a href="https://blog.0branch.com/rss.xml#fnref1" class="footnote-back">&#8617;</a></p></li>
<li><p>Note that the <code>aliases</code> alias effectively does the same thing as enabling <a href="http://hg.0branch.com/hg-aliases">hg-aliases</a> (from which this extension was derived).<a href="https://blog.0branch.com/rss.xml#fnref2" class="footnote-back">&#8617;</a></p></li>
</ol>
</section>
  </div>
</div>

<hr/>

<div></div>

<noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
<a href="http://disqus.com" class="dsq-brlink">comments powered by <span class="logo-disqus">Disqus</span></a>


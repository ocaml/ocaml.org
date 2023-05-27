---
title: Quick histograms
description: "Having come back to actively working on OCI*ML recently, it\u2019s time
  I cracked on with some more features (I have been promising LOBs for a long time,
  sorry to anyone who\u2019s still waiting)\u2026"
url: https://gaius.tech/2012/06/15/quick-histograms/
date: 2012-06-15T20:35:48-00:00
preview_image: https://gaiustech.files.wordpress.com/2012/06/qh.png
featured:
authors:
- gaius
---

<p>Having come back to actively working on <a href="http://gaiustech.github.com/ociml/">OCI*ML</a> recently, it&rsquo;s time I cracked on with some more features (I have been promising <a href="http://docs.oracle.com/cd/B28359_01/appdev.111/b28393/adlob_intro.htm#ADLOB001">LOBs</a> for a long time, sorry to anyone who&rsquo;s still waiting). Just to get warmed up, inspired by <a href="http://github.com/holman/spark">spark</a> I have added a quick histogram function, similar to <a href="https://gaiustech.wordpress.com/2011/05/14/ocaml-as-a-sqlplus-replacement/">quick query</a> for interactive use. This requires a query of the form of a label and a number, for example a simple view:</p>
<pre class="brush: sql; title: ; wrap-lines: false; notranslate">
SQL&gt; create view v1 as
select object_type, count(1) as howmany from user_objects group by object_type;
</pre>
<p><a href="https://gaiustech.files.wordpress.com/2012/06/qh.png"><img src="https://gaiustech.files.wordpress.com/2012/06/qh.png?w=640&amp;h=206" loading="lazy" data-attachment-id="2124" data-permalink="https://gaius.tech/2012/06/15/quick-histograms/qh/" data-orig-file="https://gaiustech.files.wordpress.com/2012/06/qh.png" data-orig-size="1065,344" data-comments-opened="1" data-image-meta="{&quot;aperture&quot;:&quot;0&quot;,&quot;credit&quot;:&quot;&quot;,&quot;camera&quot;:&quot;&quot;,&quot;caption&quot;:&quot;&quot;,&quot;created_timestamp&quot;:&quot;0&quot;,&quot;copyright&quot;:&quot;&quot;,&quot;focal_length&quot;:&quot;0&quot;,&quot;iso&quot;:&quot;0&quot;,&quot;shutter_speed&quot;:&quot;0&quot;,&quot;title&quot;:&quot;&quot;}" data-image-title="qh" data-image-description="" data-image-caption="" data-medium-file="https://gaiustech.files.wordpress.com/2012/06/qh.png?w=300" data-large-file="https://gaiustech.files.wordpress.com/2012/06/qh.png?w=640" class="aligncenter size-full wp-image-2124" title="qh" alt="" width="640" height="206" srcset="https://gaiustech.files.wordpress.com/2012/06/qh.png?w=638&amp;h=206 638w, https://gaiustech.files.wordpress.com/2012/06/qh.png?w=150&amp;h=48 150w, https://gaiustech.files.wordpress.com/2012/06/qh.png?w=300&amp;h=97 300w, https://gaiustech.files.wordpress.com/2012/06/qh.png?w=768&amp;h=248 768w, https://gaiustech.files.wordpress.com/2012/06/qh.png?w=1024&amp;h=331 1024w, https://gaiustech.files.wordpress.com/2012/06/qh.png 1065w" sizes="(max-width: 640px) 100vw, 640px"/></a><br/>
The histogram automatically <a href="http://pleac.sourceforge.net/pleac_ocaml/userinterfaces.html">scales</a> to the width of the current window.</p>
<p>Also, I have been reading Jordan Mechner&rsquo;s book <em><a href="http://www.amazon.co.uk/The-Making-Prince-Persia-ebook/dp/B005WUE6Q2/ref=sr_1_1?s=digital-text&amp;ie=UTF8&amp;qid=1333205986&amp;sr=1-1">The Making Of Prince Of Persia</a></em>&dagger;. It&rsquo;s both fascinating and inspiring. Just before that, I read <em><a href="http://www.amazon.co.uk/Future-Here-Platform-Studies-ebook/dp/B007V5BVJG/ref=sr_1_1?s=digital-text&amp;ie=UTF8&amp;qid=1339795151&amp;sr=1-1">The Future Was Here</a></em>, the story of the Commodore Amiga&Dagger;. The book is made even more poignant by my Mac inexplicably showing the beach ball as I scroll through a simple web page, or the mighty RHEL servers at work being unable to keep up with my typing. The future is <em>still</em> back in the 80s.</p>
<p>&dagger; The <a href="http://github.com/jmechner/Prince-of-Persia-Apple-II">original code</a> is also on Github.</p>
<p>&Dagger; I have an <a href="http://en.wikipedia.org/wiki/Amiga_500_Plus">A500+</a> on my desk right now, the best of them IMHO. I might write a post comparing it with the <a href="http://en.wikipedia.org/wiki/Atari_STE#STE_models">Atari STE</a>, and the <a href="https://gaiustech.wordpress.com/2012/01/04/happy-new-year-2/">BBC</a> with the C64, in the cold light of day as an experienced adult. I have a fine collection of classic machines now, often acquired broken with the intention of repairing them myself. Another time-sink from OCaml work&hellip;</p>


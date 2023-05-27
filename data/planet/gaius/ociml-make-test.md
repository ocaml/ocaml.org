---
title: 'OCI*ML: Make Test'
description: "Before resuming feature implementation in OCI*ML I thought I ought to
  tighten up the test suite a bit, so I have started on a make test target, including
  some utilities for generating large test da\u2026"
url: https://gaius.tech/2013/08/15/ociml-make-test/
date: 2013-08-15T16:01:03-00:00
preview_image: https://gaiustech.files.wordpress.com/2013/08/maketest.png
featured:
authors:
- gaius
---

<p>Before resuming feature implementation in <a href="http://gaiustech.github.io/ociml/">OCI*ML</a> I thought I ought to tighten up the test suite a bit, so I have started on a <code>make test</code> target, including some utilities for generating large test datasets, which should be useful elsewhere. In the process I uncovered a couple of bugs, which I also fixed. Once I&rsquo;m happy with the level of coverage, I might even get around to doing LOBs&hellip;</p>
<p><a href="https://gaiustech.files.wordpress.com/2013/08/maketest.png"><img src="https://gaiustech.files.wordpress.com/2013/08/maketest.png?w=640&amp;h=292" loading="lazy" data-attachment-id="2274" data-permalink="https://gaius.tech/2013/08/15/ociml-make-test/maketest/" data-orig-file="https://gaiustech.files.wordpress.com/2013/08/maketest.png" data-orig-size="917,419" data-comments-opened="1" data-image-meta="{&quot;aperture&quot;:&quot;0&quot;,&quot;credit&quot;:&quot;&quot;,&quot;camera&quot;:&quot;&quot;,&quot;caption&quot;:&quot;&quot;,&quot;created_timestamp&quot;:&quot;0&quot;,&quot;copyright&quot;:&quot;&quot;,&quot;focal_length&quot;:&quot;0&quot;,&quot;iso&quot;:&quot;0&quot;,&quot;shutter_speed&quot;:&quot;0&quot;,&quot;title&quot;:&quot;&quot;}" data-image-title="maketest" data-image-description="" data-image-caption="" data-medium-file="https://gaiustech.files.wordpress.com/2013/08/maketest.png?w=300" data-large-file="https://gaiustech.files.wordpress.com/2013/08/maketest.png?w=640" alt="maketest" width="640" height="292" class="aligncenter size-full wp-image-2274" srcset="https://gaiustech.files.wordpress.com/2013/08/maketest.png?w=640&amp;h=292 640w, https://gaiustech.files.wordpress.com/2013/08/maketest.png?w=150&amp;h=69 150w, https://gaiustech.files.wordpress.com/2013/08/maketest.png?w=300&amp;h=137 300w, https://gaiustech.files.wordpress.com/2013/08/maketest.png?w=768&amp;h=351 768w, https://gaiustech.files.wordpress.com/2013/08/maketest.png 917w" sizes="(max-width: 640px) 100vw, 640px"/></a></p>
<p>It feels pretty good to be stretching the old OCaml muscles again <img src="https://s0.wp.com/wp-content/mu-plugins/wpcom-smileys/twemoji/2/72x72/1f642.png" alt="&#128578;" class="wp-smiley" style="height: 1em; max-height: 1em;"/></p>


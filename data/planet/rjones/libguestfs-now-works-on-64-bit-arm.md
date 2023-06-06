---
title: libguestfs now works on 64 bit ARM
description: "Pictured above is my 64 bit ARM server. It\u2019s under NDA so I cannot
  tell you who supplied it or even show you a proper photo. However it runs Fedora
  21 & Rawhide: Linux arm64.home.annexia.\u2026"
url: https://rwmj.wordpress.com/2014/07/23/libguestfs-now-works-on-64-bit-arm/
date: 2014-07-23T20:49:26-00:00
preview_image: https://rwmj.files.wordpress.com/2014/07/arm.jpg
featured:
authors:
- rjones
---

<p><a href="https://rwmj.files.wordpress.com/2014/07/arm.jpg"><img src="https://rwmj.files.wordpress.com/2014/07/arm.jpg?w=500" data-attachment-id="5374" data-permalink="https://rwmj.wordpress.com/2014/07/23/libguestfs-now-works-on-64-bit-arm/arm/" data-orig-file="https://rwmj.files.wordpress.com/2014/07/arm.jpg" data-orig-size="320,240" data-comments-opened="1" data-image-meta="{&quot;aperture&quot;:&quot;0&quot;,&quot;credit&quot;:&quot;&quot;,&quot;camera&quot;:&quot;&quot;,&quot;caption&quot;:&quot;&quot;,&quot;created_timestamp&quot;:&quot;0&quot;,&quot;copyright&quot;:&quot;&quot;,&quot;focal_length&quot;:&quot;0&quot;,&quot;iso&quot;:&quot;0&quot;,&quot;shutter_speed&quot;:&quot;0&quot;,&quot;title&quot;:&quot;&quot;}" data-image-title="arm" data-image-description="" data-image-caption="" data-medium-file="https://rwmj.files.wordpress.com/2014/07/arm.jpg?w=320" data-large-file="https://rwmj.files.wordpress.com/2014/07/arm.jpg?w=320" alt="arm" class="aligncenter size-full wp-image-5374" srcset="https://rwmj.files.wordpress.com/2014/07/arm.jpg 320w, https://rwmj.files.wordpress.com/2014/07/arm.jpg?w=150 150w" sizes="(max-width: 320px) 100vw, 320px"/></a></p>
<p>Pictured above is my 64 bit ARM server.  It&rsquo;s under NDA so I cannot tell you who supplied it or even show you a proper photo.</p>
<p>However it runs Fedora 21 &amp; Rawhide:</p>
<pre>
Linux arm64.home.annexia.org 3.16.0-0.rc6.git1.1.efirtcfix1.fc22.aarch64 #1 SMP Wed Jul 23 12:15:58 BST 2014 aarch64 aarch64 aarch64 GNU/Linux
</pre>
<p>libvirt and libguestfs run fine, with full KVM acceleration, although right now you have to use qemu from git as the Rawhide version of qemu is not new enough.</p>
<p>Also OCaml 4.02.0 beta works (after we found and fixed a few bugs in the arm64 native code generator last week).</p>


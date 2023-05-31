---
title: Segmentation Faults, TAP and Eclipse
description: "This is quite a neat trick. Consider: Referencing that NULL pointer
  obviously crashes straight away with a terse segmentation fault: By simply linking
  it with libSegFault, which seems to be documen\u2026"
url: https://gaius.tech/2011/09/09/segmentation-faults-tap-and-eclipse/
date: 2011-09-09T11:14:41-00:00
preview_image: https://gaiustech.files.wordpress.com/2011/09/segfault1.png
featured:
authors:
- gaius
---

<p>This is quite a neat trick. Consider:</p>
<pre class="brush: cpp; title: ; notranslate">
#include &lt;cstdlib&gt;

int main(int argc, char** argv) {
  int* ptr = NULL;
  *ptr = 1;

  exit(EXIT_SUCCESS);
}
</pre>
<p>Referencing that <code>NULL</code> pointer obviously crashes straight away with a terse <a href="http://en.wikipedia.org/wiki/Segmentation_fault">segmentation fault</a>:</p>
<p><a href="https://gaiustech.files.wordpress.com/2011/09/segfault1.png"><img src="https://gaiustech.files.wordpress.com/2011/09/segfault1.png?w=640" data-attachment-id="1719" data-permalink="https://gaius.tech/2011/09/09/segmentation-faults-tap-and-eclipse/segfault1/" data-orig-file="https://gaiustech.files.wordpress.com/2011/09/segfault1.png" data-orig-size="665,463" data-comments-opened="1" data-image-meta="{&quot;aperture&quot;:&quot;0&quot;,&quot;credit&quot;:&quot;&quot;,&quot;camera&quot;:&quot;&quot;,&quot;caption&quot;:&quot;&quot;,&quot;created_timestamp&quot;:&quot;0&quot;,&quot;copyright&quot;:&quot;&quot;,&quot;focal_length&quot;:&quot;0&quot;,&quot;iso&quot;:&quot;0&quot;,&quot;shutter_speed&quot;:&quot;0&quot;,&quot;title&quot;:&quot;&quot;}" data-image-title="segfault1" data-image-description="" data-image-caption="" data-medium-file="https://gaiustech.files.wordpress.com/2011/09/segfault1.png?w=300" data-large-file="https://gaiustech.files.wordpress.com/2011/09/segfault1.png?w=640" alt="" title="segfault1" class="aligncenter size-full wp-image-1719" srcset="https://gaiustech.files.wordpress.com/2011/09/segfault1.png?w=640 640w, https://gaiustech.files.wordpress.com/2011/09/segfault1.png?w=150 150w, https://gaiustech.files.wordpress.com/2011/09/segfault1.png?w=300 300w, https://gaiustech.files.wordpress.com/2011/09/segfault1.png 665w" sizes="(max-width: 640px) 100vw, 640px"/></a><br/>
By simply linking it with <code>libSegFault</code>, which seems to be documented only <a href="http://www.cygwin.com/ml/gdb/2007-06/msg00345.html">very informally</a>, but comes with <a href="http://www.gnu.org/s/libc/">glibc</a>:</p>
<p><a href="https://gaiustech.files.wordpress.com/2011/09/segfault2.png"><img src="https://gaiustech.files.wordpress.com/2011/09/segfault2.png?w=640" data-attachment-id="1720" data-permalink="https://gaius.tech/2011/09/09/segmentation-faults-tap-and-eclipse/segfault2/" data-orig-file="https://gaiustech.files.wordpress.com/2011/09/segfault2.png" data-orig-size="665,463" data-comments-opened="1" data-image-meta="{&quot;aperture&quot;:&quot;0&quot;,&quot;credit&quot;:&quot;&quot;,&quot;camera&quot;:&quot;&quot;,&quot;caption&quot;:&quot;&quot;,&quot;created_timestamp&quot;:&quot;0&quot;,&quot;copyright&quot;:&quot;&quot;,&quot;focal_length&quot;:&quot;0&quot;,&quot;iso&quot;:&quot;0&quot;,&quot;shutter_speed&quot;:&quot;0&quot;,&quot;title&quot;:&quot;&quot;}" data-image-title="segfault2" data-image-description="" data-image-caption="" data-medium-file="https://gaiustech.files.wordpress.com/2011/09/segfault2.png?w=300" data-large-file="https://gaiustech.files.wordpress.com/2011/09/segfault2.png?w=640" alt="" title="segfault2" class="aligncenter size-full wp-image-1720" srcset="https://gaiustech.files.wordpress.com/2011/09/segfault2.png?w=640 640w, https://gaiustech.files.wordpress.com/2011/09/segfault2.png?w=150 150w, https://gaiustech.files.wordpress.com/2011/09/segfault2.png?w=300 300w, https://gaiustech.files.wordpress.com/2011/09/segfault2.png 665w" sizes="(max-width: 640px) 100vw, 640px"/></a><br/>
Of course you could get all this by starting the program with <a href="http://ftp.gnu.org/old-gnu/Manuals/gdb-5.1.1/html_node/gdb_42.html">gdb</a> but this looks like a great technique for diagnosing crashes &ldquo;in the wild&rdquo;. Not that my code segfaults all the time, mind! After writing this, I found some more details on <a href="http://stackoverflow.com/q/77005/447514">Stack Overflow</a>, including a good tip about <code>c++filt</code>. Another useful utility is <code><a href="http://linux.die.net/man/1/addr2line">addr2line</a></code>.</p>
<p>Also I am starting to incorporate <code><a href="http://testanything.org/wiki/index.php/Testing_with_C++#Testing_using_libtap.2B.2B">libtap++</a></code>, an implementation of the <a href="http://testanything.org/wiki/index.php/TAP_at_IETF:_Draft_Standard#Introduction">Test Anything Protocol</a>, into my projects. C++ has <a href="http://c2.com/cgi/wiki?StronglyTyped">strong typing</a>, at least stronger than plain C, which helps <a href="https://gaiustech.wordpress.com/2011/04/25/and-while-im-on-the-subject/">trap errors at compile time</a> like in OCaml. But since I always write a test harness anyway, it makes sense to fall into line with the way everyone else does it, especially as I have ambitions for wider adoption of my bindings&dagger;. <s>Presently there is <a href="http://testanything.org/wiki/index.php/TAP_Producers">no TAP producer for OCaml</a></s>&Dagger;, so at some point I will work on that too (or just bind to <a href="https://github.com/zorgnax/libtap">the C libtap</a>).</p>
<p>On the recommendation of a friend of mine who is a very experienced C++ programmer, I have been playing with <a href="http://www.eclipse.org/cdt/">Eclipse CDT</a>, which is pretty nice for C/C++ but doesn&rsquo;t deal well at all with mixed C++/OCaml projects, and <a href="http://eclipsefp.github.com">EclipseFP</a> seems to have dropped support for OCaml at some point. I think I&rsquo;ll try using it for just the <code>.so</code> portion of my projects and stick with Emacs/<code>make</code> for final integration with OCaml bindings, at least until I see if it really is more productive to do C++ in a full-blown <a href="http://en.wikipedia.org/wiki/Integrated_development_environment">IDE</a> versus good old <a href="http://www.gnu.org/software/emacs/tour/">Emacs</a>. Also I&rsquo;ve bought a copy of <i><a href="http://www.amazon.co.uk/Boost-C-Libraries-Boris-Schaling/dp/0982219199/ref=sr_1_5?s=books&amp;ie=UTF8&amp;qid=1315564879&amp;sr=1-5">The Boost C++ Libraries</a></i>, again on the recommendation of my friend, that whatever I want, it&rsquo;s probably already in <a href="http://www.boost.org/">Boost</a>. </p>
<p><font size="1">&dagger; OPERATION FOOTHOLD<br/>
&Dagger; See comments</font></p>


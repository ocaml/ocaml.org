---
title: OCaml on iOS 7, Progress Report
description:
url: http://psellos.com/2014/05/2014.05.arm-as-to-ios-5.html
date: 2014-05-31T19:00:00-00:00
preview_image:
featured:
authors:
- Psellos
---

<div class="date">May 31, 2014</div>

<p>Sorry I&rsquo;ve been away, reader, but I was offered a chance to build software for a research project at a great Computer Science Department and I just couldn&rsquo;t pass up the opportunity. I&rsquo;ve learned a lot about <a href="http://nodejs.org">node.js</a> (no type system, but otherwise very enjoyable). I&rsquo;ve talked to serious researchers in machine learning and synthetic biology. I share an elevator with the occasional robot, and work in a secret sub-basement DNA lab. In short, it&rsquo;s an enthralling yet humbling environment for a guy like me.</p>

<div class="flowaroundimg" style="margin-top: 1.0em;">
<a href="http://psellos.com/ios/arm-as-to-ios.html"><img src="http://psellos.com/images/vorobeacon-s35.png" alt="Vaguely robotic looking Voronoi diagram"/></a>
</div>

<p>In the meantime I&rsquo;ve heard from people interested in running OCaml on iOS, and I myself am still extremely interested. So I&rsquo;ve started to work on updating the project to the latest versions of everything, which right now are: OCaml 4.01.0, iOS 7.1, Xcode 5.1. There are new versions of all of these coming out, but there are always new versions of everything.</p>

<p>The first order of business in porting OCaml to iOS is to make contact with the C and assembly toolchain, which have been changing and moving around like everything else. The latest iOS uses <a href="http://clang.llvm.org">clang</a> in place of gcc. </p>

<p>As has been the case for a while, developer tools are in a hideout deep inside the Xcode app, under a directory named <code>Xcode.app/Contents/Developer</code>. For the latest tools you want to look in <code>Toolchains/XcodeDefault.xctoolchain</code>:</p>

<table>
<col/>
<col/>
<thead>
<tr>
	<th>Tool</th>
	<th>Location</th>
</tr>
</thead>
<tbody>
<tr>
	<td>C compiler</td>
	<td><code>usr/bin/clang</code></td>
</tr>
<tr>
	<td>Assembler</td>
	<td><code>usr/bin/as</code></td>
</tr>
</tbody>
</table>

<p>The good news here is that the trickiest things seem to work much as they did before. Surprisingly, my <code>arm-as-to-ios</code> script works <em>without change</em> to convert the <code>arm.S</code> code of OCaml 4.01.0 from Linux to iOS format. I thought writing a script was a good idea, but I didn&rsquo;t expect it to work quite <em>this</em> well!</p>

<p>Here&rsquo;s what it looks like:</p>

<pre><code>$ HIDEOUT=/Applications/Xcode.app/Contents/Developer
$ TOOLCHAIN=$HIDEOUT/Toolchains/XcodeDefault.xctoolchain
$ CLANG=$TOOLCHAIN/usr/bin/clang
$ arm-as-to-ios arm.S &gt; armios.S
$ $CLANG -no-integrated-as -arch armv7 -DSYS_macosx -c armios.S
$ otool -tv armios.o | head
armios.o:
(__TEXT,__text) section
_caml_call_gc:
00000000        f8dfc1e0        ldr.w   r12, [pc, #0x1e0]
00000004        f8cce000        str.w   lr, [r12]
00000008        f8dfc1dc        ldr.w   r12, [pc, #0x1dc]
0000000c        f8ccd000        str.w   sp, [r12]
00000010        ed2d0b10        vpush   {d0, d1, d2, d3, d4, d5, d6, d7}
00000014        e92d50ff        push.w  {r0, r1, r2, r3, r4, r5, r6, r7, r12, lr}
00000018        f8dfc1d0        ldr.w   r12, [pc, #0x1d0]</code></pre>

<p>The only real trick here is to tell clang not to use its integrated assembler. The external assembler apparently behaves a little bit more like the previous version.</p>

<p>I am currently applying the patches to the new OCaml compiler sources. I&rsquo;ll have more results to report soon.</p>

<p>The <code>arm-as-to-ios</code> script is described on the page <a href="http://psellos.com/ios/arm-as-to-ios.html">Convert Linux ARM Assembly Code for iOS</a>. I&rsquo;ll revise the page for Xcode 5.1, but (as I say) the script itself  seems to work as it is.</p>

<p>If you have any comments or encouragement, leave them below or email me at <a href="mailto:jeffsco@psellos.com">jeffsco@psellos.com</a>.</p>

<p>Posted by: <a href="http://psellos.com/aboutus.html#jeffreya.scofieldphd">Jeffrey</a></p>

<p></p>


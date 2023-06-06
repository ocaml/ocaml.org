---
title: OCaml on iOS 7, Second Progress Report
description:
url: http://psellos.com/2014/08/2014.08.ocamlxarm-progress.html
date: 2014-08-12T19:00:00-00:00
preview_image:
featured:
authors:
- Psellos
---

<div class="date">August 12, 2014</div>

<p>Some estimable savants and polymaths have continued to ask me gently about the status of the OCaml-on-iOS project. I&rsquo;m happy to say I&rsquo;ve made some progress in recent weeks, and a few days ago I built my first iOS app with OCaml 4.01.0, and ran it successfully on my iPhone (iOS 7.1.1).</p>

<p>Since the last report here I adapted and applied the  OCaml 4.00.0 OCaml-on-iOS patches to the OCaml 4.01.0 compiler. Then I updated the <code>xarm-build</code> script that builds ocamlopt as an ARM cross-compiler. <code>xarm-build</code> is described in <a href="http://psellos.com/ocaml/compile-to-iphone.html">Compile OCaml for iOS</a> (soon to be updated).</p>

<p>I got the compiler to build OK but there were two problems with it.</p>

<div class="flowaroundimg" style="margin-top: 1.0em;">
<a href="http://psellos.com/ocaml/example-app-portland.html"><img src="http://psellos.com/images/portland-upside-p3.png" alt="Portland app Portrait Upside Down screen"/></a>
</div>

<p>First, the iOS ABI sometimes needs to move a double precision value to a pair of integer registers. I&rsquo;ve been representing this in the internal machine code as a standard move (<code>Imove</code>) operation into a double-precision register, and another move into the integer registers. However, the 4.01.0 compiler sees the first move as redundant, and when it tries to optimize it away it fails because it apparently doesn&rsquo;t expect to see mixed-type move operations.</p>

<p>For now my fix for this is to disable the optimization when the registers have different types. Later it might be more elegant all around to use a different machine code representation for the mixed-type move. In the meantime I think it&rsquo;s best to continue with the code that has been working, even if it&rsquo;s clumsy.</p>

<p>Second, the clang runtime defines functions <code>__divsi3</code> and <code>__modsi3</code> for doing 32-bit div and mod operations. With the gcc runtime OCaml used <code>__aeabi_idiv</code> and <code>__aeabi_idivmod</code>. This is easy to fix just by changing the names of the functions.</p>

<p>Once the compiler was working I built the <a href="http://psellos.com/ocaml/example-app-portland.html">Portland</a> app, which does just enough to test whether OCaml is working on the iPhone. Here is the CLI session where I built the app:</p>

<pre><code>$ ocamlopt -version
4.01.0
$ make
/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc -arch armv7 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.1.sdk -isystem ../lib/ocaml -DCAML_NAME_SPACE   -c -o wrap.o wrap.m
/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc -arch armv7 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.1.sdk -isystem ../lib/ocaml -DCAML_NAME_SPACE   -c -o main.o main.m
ocamlc  -c wrapper.mli
ocamlopt  -c wrapper.ml
ocamlc  -c wrappee.mli
ocamlopt  -c wrappee.ml
ocamlc  -c cgAffineTransform.mli
ocamlopt  -c cgAffineTransform.ml
ocamlc  -c nsTimer.mli
ocamlopt  -c nsTimer.ml
ocamlc  -c uiDevice.mli
ocamlopt  -c uiDevice.ml
ocamlc  -c uiLabel.mli
ocamlopt  -c uiLabel.ml
ocamlc  -c uiApplication.mli
ocamlopt  -c uiApplication.ml
ocamlopt  -c portlandappdeleg.ml
ocamlopt  -o Portland \
            wrap.o main.o wrapper.cmx wrappee.cmx cgAffineTransform.cmx nsTimer.cmx uiDevice.cmx uiLabel.cmx uiApplication.cmx portlandappdeleg.cmx -cclib '-framework UIKit -framework Foundation' \
            -cclib -Wl,-no_pie
$ file Portland
Portland: Mach-O executable arm</code></pre>

<p>It doesn&rsquo;t look like much, but it&rsquo;s a good feeling to see a new OCaml-on-iOS compiler working after such a long wait. Even better, when I run the app on my iPhone it works perfectly.</p>

<p>I want to try a few more things before releasing this version to the estimable savants and polymaths. (Likely you, reader, are one of these.) If I don&rsquo;t find any serious problems, a new release will be coming soon.</p>

<p>If you have any comments or encouragement, leave them below or email me at <a href="mailto:jeffsco@psellos.com">jeffsco@psellos.com</a>.</p>

<p>Posted by: <a href="http://psellos.com/aboutus.html#jeffreya.scofieldphd">Jeffrey</a></p>

<p></p>


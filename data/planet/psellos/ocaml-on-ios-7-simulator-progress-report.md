---
title: OCaml on iOS 7 Simulator, Progress Report
description:
url: http://psellos.com/2014/08/2014.08.ocamlxsim-progress.html
date: 2014-08-30T19:00:00-00:00
preview_image:
featured:
authors:
- Psellos
---

<div class="date">August 30, 2014</div>

<p>Some indie gypsy polka-punk developers across the globe have now been asking me about the status of the OCaml-on-iOS-<em>Simulator</em> project. I&rsquo;ve made some progress here, too, and yesterday I built the first iOS app with OCaml 4.01.0, and ran it successfully in the iPhone Simulator (iOS 7.1).</p>

<div class="flowaroundimg" style="margin-top: 1.0em;">
<a href="http://psellos.com/ocaml/example-app-gamut.html"><img src="http://psellos.com/images/gamut-burnt-orange-p3.png" alt="Gamut app burnt orange screen"/></a>
</div>

<p>To get it working I applied the OCaml 4.00.0 OCaml-on-iOS-Simulator patches to the OCaml 4.01.0 compiler. The patches are quite simple, probably because the ABI of the 32-bit Intel architecture is well standardized. So there&rsquo;s nothing to change in the code generator.</p>

<p>Then I updated the <code>xsim-build</code> script that builds ocamlopt as a cross-compiler to the Simulator environment. <code>xsim-build</code> is described in <a href="http://psellos.com/ocaml/compile-to-iossim.html">Compile OCaml for iOS Simulator</a> (soon to be updated).</p>

<p>There were two small problems with the generated compiler.</p>

<p>First, the clang toolchain tracks the difference between OS X and the Simulator environment. (I wrote about the differences in <a href="http://psellos.com/2012/04/2012.04.iossim-vs-osx.html">iOS Simulator Vs. OS X</a>.) You need to tell the compiler you&rsquo;re compiling for iOS, or you&rsquo;ll see an error like this at link time:</p>

<blockquote>
  <p><code>ld: building for MacOSX, but linking against dylib built for iOS Simulator file</code></p>
</blockquote>

<p>The fix for this is to define a desired minimum version of iOS. What I&rsquo;m using for now is this command-line flag for clang:</p>

<blockquote>
  <p><code>-miphoneos-version-min=6.0</code></p>
</blockquote>

<p>Note that this will change the set of defined preprocessor symbols, and so may require some adaptation in your conditional compilation directives.</p>

<p>Second, there were many warnings like this at link time:</p>

<blockquote>
  <p><code>ld: warning: could not create compact unwind for _caml_curry4_2_app</code></p>
</blockquote>

<p>I believe this happens because the OCaml code generator doesn&rsquo;t generate metadata to support &ldquo;compact unwind.&rdquo; This is something I know nothing about. I could learn, but if you, reader, know something about it I&rsquo;d be very happy to get some help.</p>

<p>For now, things seem to work if you turn off compact unwind with the following undocumented linker flag:</p>

<blockquote>
  <p><code>-no_compact_unwind</code></p>
</blockquote>

<p>One cool thing about compiling for the simulator is that you can run the generated code, if it&rsquo;s simple enough, from the OS X command line. Here&rsquo;s a session showing how to do it:</p>

<pre><code>$ BIN=/usr/local/ocamlxsim/bin
$ cat howitends.ml
let main () = Printf.printf &quot;You already know how this will end.\n&quot;

let () = main ()
$ $BIN/ocamlopt -o howitends howitends.ml
$ HIDEOUT=/Applications/Xcode.app/Contents/Developer
$ PLAT=$HIDEOUT/Platforms/iPhoneSimulator.platform
$ SDK=/Developer/SDKs/iPhoneSimulator7.1.sdk
$ DYLD_ROOT_PATH=$PLAT$SDK howitends
You already know how this will end.</code></pre>

<p>If you&rsquo;re interested, there are more details in <a href="http://psellos.com/2012/04/2012.04.iossim-vs-osx.html">iOS Simulator Vs. OS X</a>.</p>

<p>Once the compiler was working I built the <a href="http://psellos.com/ocaml/example-app-gamut.html">Gamut</a> app, which does just enough to test whether OCaml is working in the Simulator. As far as I can tell, it&rsquo;s working perfectly.</p>

<p>I want to try a few more things before releasing this version to the savants and lovers of wisdom. If I don&rsquo;t find any serious problems, a new release will be coming soon. In the meantime, the elder savants have released a new version of OCaml, 4.02.0, for which we can only thank them. Support for this new release will come in due time.</p>

<p>If you have any comments or encouragement, leave them below or email me at <a href="mailto:jeffsco@psellos.com">jeffsco@psellos.com</a>.</p>

<p>Posted by: <a href="http://psellos.com/aboutus.html#jeffreya.scofieldphd">Jeffrey</a></p>

<p></p>


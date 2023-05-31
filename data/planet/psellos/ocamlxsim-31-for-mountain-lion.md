---
title: OCamlXSim 3.1 for Mountain Lion
description:
url: http://psellos.com/2012/10/2012.10.ocamlxsim-mountain-lion.html
date: 2012-10-23T19:00:00-00:00
preview_image:
featured:
authors:
- Psellos
---

<div class="date">October 23, 2012</div>

<p>For those interested in building iOS Simulator apps in OCaml 4, I&rsquo;ve
just revamped <a href="http://psellos.com/ocaml/compile-to-iossim.html">OCamlXSim 3.1</a> for the
latest OS X release, OS X 10.8 (Mountain Lion).  The only difference is
in the default iOS SDK, which I changed from iOS 5.1 to iOS 6.0.
Otherwise, this was just a recompile.</p>

<div class="flowaroundimg" style="margin-top: 1.0em;">
<a href="http://psellos.com/ocaml/compile-to-iossim.html"><img src="http://psellos.com/images/vorolambda-b3-p2.png"/></a>
</div>

<p>You can get binary releases of OCamlXSim here:</p>

<ul class="rightoffloat">
<li><a href="http://psellos.com/pub/ocamlxsim/ocaml-4.00.0+xsim-3.1.6.dmg">OCamlXSim 3.1.6 for Lion</a></li>
<li><a href="http://psellos.com/pub/ocamlxsim/ocaml-4.00.0+xsim-3.1.7.dmg">OCamlXSim 3.1.7 for Mountain Lion</a></li>
</ul>

<p>For information on how to build from sources and how to test an
installation, see the updated version of <a href="http://psellos.com/ocaml/compile-to-iossim.html">Compile OCaml for iOS
Simulator</a>.</p>

<p>If you&rsquo;re new to this site, you might also be interested in OCamlXARM, a
modified version of OCaml 4.00.0 that builds iOS apps.  I also revamped
it recently to work under Mountain Lion.  You can read about it on
<a href="http://psellos.com/ocaml/compile-to-iphone.html">Compile OCaml for iOS</a></p>

<div style="clear: both"></div>

<h3>OCaml Cross Compilation Build Howto</h3>

<p>OCamlXSim and OCamlXARM are both cross compilers, and they&rsquo;re built
using exactly the same approach.  I think the strategy could be useful
for building other OCaml cross compilers, so I thought I&rsquo;d explain how
the build process works in some detail.  I&rsquo;m not claiming that the
method is original; however, I did develop it independently and it works
for my host and targets.</p>

<p>Since the stock version of OCaml doesn&rsquo;t want to be a cross compiler,
the overall goal is to beguile it into being one without disrupting the
build process too much.  To keep things simple for now, I build a
bytecode cross compiler that generates native code for the target; i.e.,
a cross-compiling version of <code>ocamlopt</code>.  The approach requires that
OCaml already supports the host system with at least a bytecode
implementation, and the target system with a native code implementation.</p>

<p>Building the equivalent &ldquo;optimized&rdquo; cross compiler (<code>ocamlopt.opt</code>)
doesn&rsquo;t seem <em>too</em> much harder, given a native OCaml compiler for the
host system.  I&rsquo;d like to get this working at some point.</p>

<h4>Compiler Source Changes</h4>

<p>This note just describes the commands I use to build the cross
compilers.  It doesn&rsquo;t describe the changes to the compiler source
itself.  These will vary a lot depending on the target and the
differences between the host and the target.</p>

<p>There are no source changes for OCamlXSIM when building a 32-bit OS X
host executable, because the host and target have virtually identical
properties.  Even for a 64-bit OS X executable, the changes are minimal,
because the host and target are quite similar.  There is one change in
<code>asmrun/signals_osdep.h</code>, which must be modified to include the proper
signal handling code in a cross-compiling environment (when the host and
the target architectures are different).  Another change in the code
generator makes sure that emitted native int values don&rsquo;t exceed 32
bits.</p>

<p>The compiler source changes for OCamlXARM are much more extensive,
because the iOS target isn&rsquo;t directly supported in the stock OCaml
release.  The same signal-handling change was required, and many
(reasonably straightforward) changes were required in the emission of
assembly code to allow for the particular syntax of the iOS assembler.</p>

<p>In cases where the host and target machines are very different, it may
be necessary to make significant changes to the architecture-dependent
code that emits instructions and data.</p>

<p>If you&rsquo;re interested in the exact compiler changes for OCamlXSim or
OCamlXARM, see their associated pages (linked above) for a description
of how to retrieve the patches.</p>

<h4>Ordinary OCaml Build</h4>

<p>As a starting point for the build process, consider the ordinary OCaml
build process:</p>

<blockquote>
  <p><strong><code>$ ./configure</code></strong> <br/>
  <strong><code>$ make world</code></strong> <br/>
  <strong><code>$ make opt</code></strong>  </p>
</blockquote>

<p>The <code>configure</code> step does many things:</p>

<ul>
<li><p>Guess the CPU type and operating system of the host.</p></li>
<li><p>Find a C compiler and associated assembler and linker.</p></li>
<li><p>Determine properties of the machine (integer sizes, endianness).</p></li>
<li><p>Determine properties of the system (available system calls and
libraries).</p></li>
</ul>

<p>Since OCaml sees itself as a native compiler, all these configuration
properties are assumed to apply both to the compiler itself and to the
programs it generates.  This isn&rsquo;t the case for a cross compiler, and
the key undertaking is to separate the two.</p>

<p>The <code>make world</code> step builds the bytecode compiler (<code>ocamlc</code>) and
bytecode runtime.  The bytecode runtime consists of a native-code
program named <code>ocamlrun</code> and a set of dynamically loadable executables
for extra libraries.  <code>ocamlrun</code>, in turn, consists of a bytecode
interpreter and native-code primitives.  Each dynamic library contains
bytecode plus extra native-code primitives.</p>

<p>The <code>make opt</code> step builds the native code compiler (<code>ocamlopt</code>) and a
native runtime.  The native runtime consists of a set of native
libraries, very similar to the bytecode runtime minus the interpreter.</p>

<p>When you do an ordinary compile of an OCaml program with <code>ocamlopt</code>,
<code>ocamlopt</code> itself uses the bytecode runtime created in the <code>make world</code>
step.  The compiled program links against the native runtime created in
the <code>make opt</code> step.</p>

<h4>Cross Compiling Requirements</h4>

<p>To get a cross compiler using the same build system requires a
reconsideration of the configuration properties:</p>

<ul>
<li><p>The CPU type is used to select the correct native code generator.  So
the CPU type of the host isn&rsquo;t so interesting.  We want to specify the
CPU type of the target.</p></li>
<li><p>The C compiler and linker are needed for building the bytecode runtime
for the host.  However, we also want a <em>target</em> toolchain C compiler,
assembler, and linker to be used for generated programs.</p></li>
<li><p>Similarly, the machine and system properties are correct for building
the bytecode runtime on the host.  But we want the <em>target</em> machine
and system properties for building the runtime to be used by generated
programs.</p></li>
</ul>

<p>This suggests a two-phase build process:</p>

<ul>
<li><p>Phase 1: run <code>configure</code> as usual to determine the properties of the
host system.  Post-modify the configuration properties just enough to
create a native-code cross compiler for the target.  Then build the
native-code compiler as usual.  This native-code compiler runs on the
bytecode interpreter (<code>ocamlrun</code>) of the host, and generates native
code for the target.</p></li>
<li><p>Phase 2: run <code>configure</code> on the target system to determine the
properties of the target system.  Then rebuild just the runtime on the
host using the target toolchain and these properties of the target
system.  The resulting runtime works for the compiled programs.</p></li>
</ul>

<p>If the target system is insufficiently Unix-like to run the <code>configure</code>
script, it will be necessary to determine the configuration parameters
by some other method.</p>

<p>This is how both OCamlXARM and OCamlXSim are built.  For people really
interested in the details, the following sections show the build process
for OCamlXSim 3.1.7.  You&rsquo;ll find the code in an OS X shell script named
<code>xsim-build</code>.</p>

<h4>Phase 1</h4>

<p>The configuration step of Phase 1 looks essentially like this:</p>

<pre><code>export&nbsp;PLT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform
export SDK=/Developer/SDKs/iPhoneSimulator6.0.sdk

config1 () {
    # Configure for building bytecode interpreter to run on Intel OS X.
    # But specify iOSSim parameters for assembly and partial link.
    ./configure \
            -cc &quot;gcc&quot; \
            -as &quot;$PLT/Developer/usr/bin/gcc -arch i386 -c&quot; \
            -aspp &quot;$PLT/Developer/usr/bin/gcc -arch i386 -c&quot;
    # Post-modify config/Makefile to select i386 back end for ocamlopt
    # (i386 assembly code).
    sed \
        -e 's/^ARCH[    ]*=.*/ARCH=i386/' \
        -e 's/^MODEL[    ]*=.*/MODEL=default/' \
        -e &quot;s#^PARTIALLD[    ]*=.*#PARTIALLD=$PLT/Developer/usr/bin/ld -r#&quot; \
        config/Makefile
    # Post-modify utils/config.ml.
    make utils/config.ml
    sed \
        -e 's#let[      ][      ]*mkexe[        ]*=.*#let mkexe =&quot;'&quot;$PLT/Developer/usr/bin/gcc -arch i386 -Wl,-objc_abi_version,2 -Wl,-no_pie -gdwarf-2 -isysroot $PLT$SDK&quot;'&quot;#' \
        -e 's#let[      ][      ]*bytecomp_c_compiler[  ]*=.*#let bytecomp_c_compiler =&quot;'&quot;$PLT/Developer/usr/bin/gcc -arch i386 -gdwarf-2 -isysroot $PLT$SDK&quot;'&quot;#' \
        -e 's#let[      ][      ]*native_c_compiler[    ]*=.*#let native_c_compiler =&quot;'&quot;$PLT/Developer/usr/bin/gcc -arch i386 -gdwarf-2 -isysroot $PLT$SDK&quot;'&quot;#' \
        utils/config.ml
}</code></pre>

<p>The <code>configure</code> step itself specifies the C compiler of the host
(<code>gcc</code>), which is needed to build the bytecode runtime.  The assembler,
however, isn&rsquo;t needed in this phase.  So the <code>configure</code> step can
specify the <em>target</em> tools for the two types of assembly&mdash;in both cases,
it specifies the <code>gcc</code> of the target toolchain.  This means that the
generated cross compiler will run the proper tools when it assembles its
generated native code.</p>

<p>After generating configuration information for the host, the script then
post-modifies it to become a cross compiler.  Most importantly, it
modifies <code>config/Makefile</code> to set its <code>ARCH</code> variable to the target
architecture.  As mentioned above, this is the key step that attaches
the target code generator to the host compiler.  The other changes
specify a more particular model of CPU (not really used for OCamlXSim)
and the target tool chain command for doing partial linking.</p>

<p>Note that for OCamlXSim, the target architecture is <code>i386</code>.  The iOS
Simulator is a 32-bit Intel hardware environment with libraries that
recreate the software environment of iOS devices.  In the build script
for OCamlXARM, the target architecture is <code>armv7</code>.</p>

<p>This leaves the question of how the cross compiler should compile any C
programs that are given on its command line, and how it should link the
results into an OCaml executable.  These commands are inserted at an
even deeper level, to avoid interfering with the compilation and linking
of the cross compiler runtime.  The second set of modifications works by
generating <code>utils/config.ml</code> and modifying its commands to be those of
the target toolchain.</p>

<p>The build step of Phase 1 looks like this:</p>

<pre><code>build1 () {
    # Don't assemble asmrun/i386.S for Phase 1 build.  Modify
    # asmrun/Makefile temporarily to disable.  Be really sure to put
    # back for Phase 2.
    trap 'mv -f asmrun/Makefile.aside asmrun/Makefile' EXIT
    grep -q '^[         ]*ASMOBJS[      ]*=' asmrun/Makefile &amp;&amp; \
        mv -f asmrun/Makefile asmrun/Makefile.aside
    sed -e '/^[        ]*ASMOBJS[      ]*=/s/^/#/' \
        asmrun/Makefile.aside &gt; asmrun/Makefile
    make world &amp;&amp; make opt
    mv -f asmrun/Makefile.aside asmrun/Makefile
    trap - EXIT
    # Save the Phase 1 shared (dynamically loadable) libraries and
    # restore them after Phase 2.  They're required by some OCaml
    # utilities, such as camlp4.
    #
    find . -name '*.so' -exec mv {} {}phase1 \;
}</code></pre>

<p>This step basically just runs <code>make world</code> and <code>make opt</code> as usual.
However, it turns out to be necessary to make some tricky changes before
and after.</p>

<p>First, the assembled output of <code>asmrun/i386.S</code> won&rsquo;t be compatible with
the rest of the bytecode runtime.  So we remove it from the build rule
of <code>asmrun/Makefile</code>, and restore it later.  This works because this
file is needed only for native executables, and we&rsquo;re producing only
bytecode executables at this point.</p>

<p>Second, the dynamically loadable libraries of the bytecode runtime will
be overwritten during Phase 2.  These libraries <em>are</em> needed by the
bytecode executables.  So we move them aside temporarily, and restore
them at the end of Phase 2.</p>

<h4>Phase 2</h4>

<p>For Phase 2, we&rsquo;d like to run <code>configure</code> on our target system.  This
can be tricky in general, but for OCamlXSim it&rsquo;s relatively easy.  The
iOS Simulator actually runs as a separate software environment on OS X,
our host system.  It&rsquo;s possible to generate and run code in this
environment by specifying the proper command-line options.</p>

<p>If you aren&rsquo;t so lucky, the requirement is to generate three files:
<code>config/s.h</code>, <code>config/m.h</code>, and <code>config/Makefile</code>.  A possible plan is
to generate these by running <code>configure</code> on a Unix-like system that&rsquo;s as
similar as possible to your target, then make any other modifications by
hand.</p>

<p>The configuration step of Phase 2 looks essentially like this:</p>

<pre><code>config2 () {
    # Clean out OS X runtime
    cd asmrun; make clean; cd ..
    cd stdlib; make clean; cd ..
    cd otherlibs/bigarray; make clean; cd ../..
    cd otherlibs/dynlink; make clean; cd ../..
    cd otherlibs/num; make clean; cd ../..
    cd otherlibs/str; make clean; cd ../..
    cd otherlibs/systhreads; make clean; cd ../..
    cd otherlibs/threads; make clean; cd ../..
    cd otherlibs/unix; make clean; cd ../..
    # Reconfigure for iOSSim environment
    ./configure \
            -host i386-apple-darwin10.0.0d3 \
            -cc &quot;$PLT/Developer/usr/bin/gcc -arch i386 -gdwarf-2 -isysroot $PLT$SDK&quot; \
            -as &quot;$PLT/Developer/usr/bin/gcc -arch i386 -c&quot; \
            -aspp &quot;$PLT/Developer/usr/bin/gcc -arch i386 -c&quot;
    # Rebuild ocamlmklib, so libraries work with iOSSim.
    rm myocamlbuild_config.ml
    cd tools
    make ocamlmklib
    cd ..
}</code></pre>

<p>The purpose of Phase 2 is to build a runtime for the target.  So we
start by clearing out the old runtime for the host.  Now that we&rsquo;ve
built the cross compiler, it won&rsquo;t be needed.</p>

<p>Next, we rerun <code>configure</code>, specifying the C compiler and assembler of
the target toolchain (in our case, the iOS Simulator).  We also specify
a specific <code>-host</code>, so that <code>configure</code> doesn&rsquo;t attempt to guess the CPU
and operating system.</p>

<p>Then we rebuild ocamlmklib so it works with the target toolchain rather
than the host toolchain.</p>

<p>The build step of Phase 2 looks like this:</p>

<pre><code>build2 () {
    # Make iOSSim runtime
    cd asmrun; make all; cd ..
    cd stdlib; make all allopt; cd ..
    cd otherlibs/unix; make all allopt; cd ../..
    cd otherlibs/str; make all allopt; cd ../..
    cd otherlibs/num; make all allopt; cd ../..
    cd otherlibs/dynlink; make all allopt; cd ../..
    cd otherlibs/bigarray; make all allopt; cd ../..
    cd otherlibs/systhreads; make all allopt; cd ../..
    cd otherlibs/threads; make all allopt; cd ../..
    # Restore the saved Phase 1 .so files (see above).
    find . -name '*.sophase1' -print | \
        while read f; do \
            fso=&quot;$(expr &quot;$f&quot; : '\(.*\)sophase1$')so&quot;; mv -f $f $fso; \
        done
}</code></pre>

<p>These commands rebuild the runtime using the new toolchain, then restore
the dynamically loaded libraries of the host runtime that were saved at
the end of Phase 1.  These libraries are used by some of the compiling
tools&mdash;notably, the <code>camlp4</code> family uses the Unix library.</p>

<p>Serendipitously, the resulting executables and objects look just like
those of a traditional OCaml release.  So they can be installed using
the unmodified <code>install</code> rule of the top-level Makefile.  It works out
this way because there are two distinct parts: the bytecode subsystem
(which works on the host), and the native-code subsystem (which works on
the target).  Things don&rsquo;t have to be separated this way, but it&rsquo;s
convenient for now.</p>

<p>If you have comments or questions, please leave them below, or email me
at <a href="mailto:jeffsco@psellos.com">jeffsco@psellos.com</a>.</p>

<p>Posted by: <a href="http://psellos.com/aboutus.html#jeffreya.scofieldphd">Jeffrey</a></p>

<p></p>


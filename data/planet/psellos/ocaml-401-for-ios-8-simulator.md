---
title: OCaml 4.01 for iOS 8 Simulator
description:
url: http://psellos.com/2014/12/2014.12.ocaml-iossim8.html
date: 2014-12-19T19:00:00-00:00
preview_image:
featured:
authors:
- Psellos
---

<div class="date">December 19, 2014</div>

<p><a href="http://psellos.com/ocaml/compile-to-iphone.html">OCamlXARM</a> compiles for an iOS device, but <a href="http://psellos.com/ocaml/compile-to-iossim.html">OCamlXSim</a> compiles
for an iOS Simulator. The same <code>ocamloptrev</code> script that compiles OCaml
for iOS 8 can also get OCamlXSim to compile OCaml for the iOS 8
Simulator. The only thing that changes is the location of the compiler.</p>

<p>If you want to try out OCaml on the iOS 8 Simulator, here is an update
to the script that compiles for either an iOS device or an iOS Simulator
(<code>ocamloptrev</code>):</p>

<pre><code>#!/bin/bash
#
# ocamloptrev     ocamlopt for specified iOS revision
#
USAGE='ocamloptrev  -rev M.N  [ -sim ]  other-ocamlopt-options ...'

OCAMLDIR=/usr/local/ocamlxarm/v7
OCAMLSIMDIR=/usr/local/ocamlxsim

REV=''
SIM=n
declare -a ARGS
while [ $# -gt 0 ] ; do
    case $1 in
    -rev)
        if [ $# -gt 1 ]; then
            REV=$2
            shift 2
        else
            echo &quot;$USAGE&quot; &gt;&amp;2
            exit 1
        fi
        ;;
    -sim)
        SIM=y
        shift
        ;;
    *)  ARGS[${#ARGS[*]}]=&quot;$1&quot;
        shift 1
        ;;
    esac
done
if [ &quot;$REV&quot; = &quot;&quot; ]; then
    echo &quot;$USAGE&quot; &gt;&amp;2
    exit 1
fi

HIDEOUT=/Applications/Xcode.app/Contents/Developer 

case $SIM in
y)  PLT=$HIDEOUT/Platforms/iPhoneSimulator.platform 
    SDK=/Developer/SDKs/iPhoneSimulator${REV}.sdk 
    OCAMLC=$OCAMLSIMDIR/bin/ocamlopt
    ;;
n)  PLT=$HIDEOUT/Platforms/iPhoneOS.platform 
    SDK=/Developer/SDKs/iPhoneOS${REV}.sdk 
    OCAMLC=$OCAMLDIR/bin/ocamlopt
    ;;
esac

$OCAMLC -ccopt -isysroot -ccopt &quot;$PLT$SDK&quot; &quot;${ARGS[@]}&quot;</code></pre>

<p>To compile for the iOS Simulator, specify <code>-sim</code> along with <code>-rev M.N</code>.</p>

<p>Let&rsquo;s make a tiny OCaml program for testing:</p>

<pre><code>$ Q=&quot;Do you know what it's like on the outside?\\n&quot;
$ echo &quot;Printf.printf \&quot;$Q\&quot;&quot; &gt; ny1941.ml</code></pre>

<p>Here&rsquo;s what happens if you compile with the current OCamlXSim on a
system with the iOS 8.1 SDK:</p>

<pre><code>$ /usr/local/ocamlxsim/bin/ocamlopt -o ny1941 ny1941.ml
clang: warning: no such sysroot directory: '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator7.1.sdk'
ld: library not found for -lSystem
clang: error: linker command failed with exit code 1 (use -v to see invocation)
File &quot;caml_startup&quot;, line 1:
Error: Error during linking</code></pre>

<p>As you can see, it&rsquo;s trying and failing to use the default iOS Simulator
7.1 SDK. Here&rsquo;s how to use <code>ocamloptrev</code> (the above script):</p>

<pre><code>$ ocamloptrev -sim -rev 8.1 -o ny1941 ny1941.ml
$ ls -l ny1941
-rwxr-xr-x  1 jeffsco  staff  303364 Dec 19 23:02 ny1941
$ file ny1941
ny1941: Mach-O executable i386
$</code></pre>

<p>You can actually run an iOS simulator app from the OS X command line,
though there are many things that don&rsquo;t work properly.</p>

<pre><code>$ ny1941
Do you know what it's like on the outside?
$</code></pre>

<p>See <a href="http://psellos.com/2012/04/2012.04.iossim-vs-osx.html">iOS Simulator Vs. OS X</a> for a
description of some differences between the OS X and the iOS Simulator
environments.</p>

<p>If you don&rsquo;t specify <code>-sim</code>, the script compiles for an iOS device as
before:</p>

<pre><code>$ ocamloptrev -rev 8.1 -o ny1941 ny1941.ml -cclib -Wl,-no_pie
$ file ny1941
ny1941: Mach-O executable arm
$ </code></pre>

<p>When not working in the subbasement of my alma mater, I&rsquo;m working in my
cluttered underground workroom on several OCaml-on-iOS projects. Along
with holiday joys and the delights of coding in node.js during the day,
I&rsquo;ll keep working through them as fast as I can.</p>

<p>I hope this script will be useful for folks who want to try OCaml on the
iOS Simulator while I&rsquo;m updating my humble patches to the latest
versions of everything and keeping all the irons in the fire.</p>

<p>If you have any trouble (or success) with the script, or have any other
comments, leave them below or email me at <a href="mailto:jeffsco@psellos.com">jeffsco@psellos.com</a>.</p>

<p>Posted by: <a href="http://psellos.com/aboutus.html#jeffreya.scofieldphd">Jeffrey</a></p>

<p></p>


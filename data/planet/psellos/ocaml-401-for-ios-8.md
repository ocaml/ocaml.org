---
title: OCaml 4.01 for iOS 8
description:
url: http://psellos.com/2014/12/2014.12.ocaml-ios8.html
date: 2014-12-09T19:00:00-00:00
preview_image:
featured:
authors:
- Psellos
---

<div class="date">December 9, 2014</div>

<p>The current OCamlXARM compiles by default for iOS 7.1, but using it for
iOS 8 is not too difficult. The only thing that changes is the name of
the SDK, which can be specified with the <code>-ccopt</code> option of ocamlopt.</p>

<p>I&rsquo;ve been testing OCaml apps on iOS 8.1 recently, and I wrote a script
that runs the OCamlXARM version of ocamlopt with the correct options. In
fact it lets you specify the revision of iOS that you want to compile
for.</p>

<p>If you want to try out OCaml on iOS 8, this script should work for you
(<code>ocamloptrev</code>):</p>

<pre><code>#!/bin/bash
#
# ocamloptrev     ocamlopt for specified iOS revision
#
USAGE='ocamloptrev  -rev M.N  other-ocamlopt-options ...'
REV=''
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
PLT=$HIDEOUT/Platforms/iPhoneOS.platform 
SDK=/Developer/SDKs/iPhoneOS${REV}.sdk 
OCOPTS=&quot;-ccopt -isysroot -ccopt $PLT$SDK&quot; 
/usr/local/ocamlxarm/v7/bin/ocamlopt $OCOPTS &quot;${ARGS[@]}&quot;</code></pre>

<p>Let&rsquo;s make a tiny OCaml program for testing:</p>

<pre><code>$ echo &quot;Printf.printf \&quot;There's a light up above\n\&quot;&quot; &gt; bbjohn.ml</code></pre>

<p>Here&rsquo;s what happens if you compile with the current OCamlXARM on a
system with the iOS 8.1 SDK:</p>

<pre><code>$ /usr/local/ocamlxarm/v7/bin/ocamlopt -o bbjohn bbjohn.ml
clang: warning: no such sysroot directory: '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.1.sdk'
ld: library not found for -lSystem
clang: error: linker command failed with exit code 1 (use -v to see invocation)
File &quot;caml_startup&quot;, line 1:
Error: Error during linking</code></pre>

<p>As you can see, it&rsquo;s trying and failing to use the iOS 7.1 SDK. Here&rsquo;s
how to use <code>ocamloptrev</code> (the above script):</p>

<pre><code>$ ocamloptrev -rev 8.1 -o bbjohn -cclib -Wl,-no_pie bbjohn.ml
$ ls -l bbjohn
-rwxr-xr-x+ 1 jeffsco  staff  238272 Dec  9 20:55 bbjohn
$ file bbjohn
bbjohn: Mach-O executable arm</code></pre>

<p>I have run the generated executables under iOS 8.1, and they work for
me.</p>

<p>I&rsquo;m continuing to work with passion, in the evenings, in my
metaphorically lonely atelier in the subbasement, on several
OCaml-on-iOS projects. In fact one is potentially quite exciting. Thanks
for all the support from correspondents as I work through them as fast
as I can.</p>

<p>I hope this script will be useful for folks who want to try OCaml on iOS
while I&rsquo;m updating the release to the latest versions of everything and
keeping all the irons in the fire.</p>

<p>If you have any trouble (or success) with the script, or have any other
comments, leave them below or email me at <a href="mailto:jeffsco@psellos.com">jeffsco@psellos.com</a>.</p>

<p>Posted by: <a href="http://psellos.com/aboutus.html#jeffreya.scofieldphd">Jeffrey</a></p>

<p></p>


---
title: Building the LLVM Fuzzer on Debian.
description:
url: http://www.mega-nerd.com/erikd/Blog/CodeHacking/building-llvm-fuzzer.html
date: 2015-07-21T10:08:00-00:00
preview_image:
featured:
authors:
- mega-nerd
---



<p>
I've been using the awesome
	<a href="http://lcamtuf.coredump.cx/afl/">American Fuzzy Lop</a>
fuzzer since late last year but had also heard good things about the
	<a href="http://llvm.org/docs/LibFuzzer.html">LLVM Fuzzer</a>.
Getting the code for the LLVM Fuzzer is trivial, but when I tried to use it, I
ran into all sorts of road blocks.
</p>

<p>
Firstly, the LLVM Fuzzer needs to be compiled with and used with Clang (GNU GCC
won't work) and it needs to be Clang &gt;= 3.7.
Now Debian does ship a clang-3.7 in the Testing and Unstable releases, but that
package has a bug
	<a href="https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=779785">(#779785)</a>
which means the Debian package is missing the static libraries required by the
	<a href="http://clang.llvm.org/docs/AddressSanitizer.html">Address Sanitizer</a>
options.
Use of the Address Sanitizers (and other sanitizers) increases the effectiveness
of fuzzing tremendously.
</p>

<p>
This bug meant I had to build Clang from source, which nnfortunately, is rather
poorly documented (I intend to submit a patch to improve this) and I only
managed it with help from the #llvm IRC channel.
</p>

<p>
Building Clang from the git mirror can be done as follows:
</p>

<pre class="code">

  mkdir LLVM
  cd LLVM/
  git clone http://llvm.org/git/llvm.git
  (cd llvm/tools/ &amp;&amp; git clone http://llvm.org/git/clang.git)
  (cd llvm/projects/ &amp;&amp; git clone http://llvm.org/git/compiler-rt.git)
  (cd llvm/projects/ &amp;&amp; git clone http://llvm.org/git/libcxx.git)
  (cd llvm/projects/ &amp;&amp; git clone http://llvm.org/git/libcxxabi)

  mkdir -p llvm-build
  (cd llvm-build/ &amp;&amp; cmake -G &quot;Unix Makefiles&quot; -DCMAKE_INSTALL_PREFIX=$(HOME)/Clang/3.8 ../llvm)
  (cd llvm-build/ &amp;&amp; make install)

</pre>

<p>
If all the above works, you will now have working <b><tt>clang</tt></b> and
<b><tt>clang++</tt></b> compilers installed in <b><tt>$HOME/Clang/3.8/bin</tt></b>
and you can then follow the examples in the
	<a href="http://llvm.org/docs/LibFuzzer.html">LLVM Fuzzer documentation</a>.
</p>



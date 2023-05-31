---
title: Compiling ARM binaries for use with BAP
description: The Binary Analysis Platform Blog
url: http://binaryanalysisplatform.github.io/arm_with_bap
date: 2015-03-04T00:00:00-00:00
preview_image:
featured:
authors:
- bap
---

<p>This post serves to give some guidance on obtaining the disassembly and CFG for
your own binaries with BAP. For sample coreutils ARM binaries that can be used
with BAP, see
<a href="https://github.com/BinaryAnalysisPlatform/arm-binaries/tree/master/coreutils">here</a>.</p>

<ol>
  <li>
    <p>You&rsquo;ll need to install an ARM compiler toolchain. Depending on your needs,
you can choose to use either the default toolchains included with the Ubuntu
package repository, or a third-party toolchain based off of mainline gcc
(e.g.  CodeSourcery, Linode, etc).</p>

    <p>For our purposes, we&rsquo;ll stick with Ubuntu 14.04, which provides five
different varieties: <code class="language-plaintext highlighter-rouge">gcc-arm-linux-gnueabi</code>, <code class="language-plaintext highlighter-rouge">gcc-arm-linux-gnueabihf</code>,
<code class="language-plaintext highlighter-rouge">gcc-aarch64-linux-gnu</code>, <code class="language-plaintext highlighter-rouge">gcc-arm-linux-androideabi</code>, and <code class="language-plaintext highlighter-rouge">gcc-none-eabi</code>.
Of these, you probably won&rsquo;t be using the latter three, since they are for
64-bit ARM, Android on ARM, and raw ARM binaries (e.g. without Linux). Of
the remaining two, the former is soft-float, meaning it doesn&rsquo;t use Thumb
instructions or a hardware floating-point unit, whereas the latter uses
both, so we want to pick <code class="language-plaintext highlighter-rouge">gcc-arm-linux-gnueabi</code>. This should
automatically add in associated dependencies such as
<code class="language-plaintext highlighter-rouge">libc6-dev-armel-cross</code> and <code class="language-plaintext highlighter-rouge">binutils-arm-linux-gnueabi</code>, but not gdb, so
you will need to specify it manually as follows:</p>

    <div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>sudo apt-get install gcc-arm-linux-gnueabi gdb-multiarch
</code></pre></div>    </div>
  </li>
  <li>
    <p>A simple &ldquo;Hello World&rdquo; program can be compiled in the familiar gcc fashion:</p>

    <div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>arm-linux-gnueabi-gcc hello.c -O0 -o hello_gccarm_O0
</code></pre></div>    </div>
  </li>
  <li>
    <p>To run this (should you be interested), you&rsquo;ll need <code class="language-plaintext highlighter-rouge">qemu-arm</code> from <code class="language-plaintext highlighter-rouge">qemu-user</code>:</p>

    <div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>sudo apt-get install qemu-user
</code></pre></div>    </div>
  </li>
  <li>
    <p>Attempting to run our binary with</p>

    <div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>qemu-user hello_gccarm_O0 # wrong!
</code></pre></div>    </div>

    <p>results in: <code class="language-plaintext highlighter-rouge">&quot;/lib/ld-linux.so.3: No such file or directory&quot;</code>.</p>

    <p>We will need these shared libraries built for arm. These are available after
installing the arm compiler toolchain. To successfully run
our binary, the command is:</p>

    <div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>qemu-arm -L /usr/arm-linux-gnueabi/ hello_gccarm_O0
</code></pre></div>    </div>
  </li>
  <li>
    <p>You may view <code class="language-plaintext highlighter-rouge">bap-objdump</code> disassembly of your binary by running:</p>

    <div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>bap-objdump --dump=asm strcpy_arm_g
</code></pre></div>    </div>
  </li>
</ol>

<h2>Extras</h2>

<p>You might like to debug your ARM binary with gdb. To do so, use qemu-arm to set
up a gdb server which you&rsquo;ll be able to connect:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>qemu-arm -L /usr/arm-linux-gnueabi/ -g 1111 hello_gccarm_O0
</code></pre></div></div>

<p>Then connect to it as follows:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>gdb-multiarch -q -nx
(gdb) file hello_gccarm_O0
(gdb) set architecture arm
(gdb) target remote 127.0.0.1:1111
</code></pre></div></div>

<p>You should now have a debugging session with gdb.</p>

<p>Take note that there are other useful utilities under <code class="language-plaintext highlighter-rouge">arm-linux-gnueabi-*</code>.
For example, you might be interested in stripping your binary before analysis,
using:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>arm-linux-gnueabi-strip hello_gcc_arm_O0
</code></pre></div></div>


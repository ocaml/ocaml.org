---
title: Building an ARMy of Xen unikernels
description:
url: https://mirage.io/blog/introducing-xen-minios-arm
date: 2014-07-22T00:00:00-00:00
preview_image:
featured:
authors:
- Thomas Leonard
---


        <p>Mirage has just gained the ability to compile unikernels for the Xen/arm32
platform, allowing Mirage guests to run under the Xen hypervisor on ARM
devices such as the <a href="http://cubietruck.com/collections/frontpage/products/cubieboard2-allwinner-a20-arm-cortex-a7-dual-core-development-board">Cubieboard 2</a> and <a href="http://cubietruck.com/collections/frontpage/products/cubietruck-cubieboard3-cortex-a7-dual-core-2gb-ram-8gb-flash-with-wifi-bt">CubieTruck</a>.</p>
<h3>Introduction</h3>
<p>The ARMv7 architecture introduced the (optional) Virtualization Extensions,
providing hardware support for running virtual machines on ARM devices, and
Xen's <a href="http://www.xenproject.org/developers/teams/arm-hypervisor.html">ARM Hypervisor</a> uses this to support hardware accelerated
ARM guests.</p>
<p><a href="http://wiki.xen.org/wiki/Mini-OS">Mini-OS</a> is a tiny OS kernel designed specifically for running under Xen.
It provides code to initialise the CPU, display messages on the console,
allocate memory (malloc), and not much else. It is used as the low-level
core of Mirage's Xen implementation.</p>
<p>Mirage v1 was built on an old version of Mini-OS which didn't support ARM.
For Mirage v2, we have added ARM support to the current Mini-OS (completing
Karim Allah Ahmed's <a href="http://lists.xen.org/archives/html/xen-devel/2014-01/msg00249.html">initial ARM port</a>) and made Mirage depend
on it as an external library.
This means that Mirage will automatically gain support for other
architectures that get added later.
We are currently working with the Xen developers to get
<a href="https://github.com/talex5/xen">our Mini-OS fork</a> upstreamed.</p>
<p>In a similar way, we have replaced Mirage v1's bundled maths library with a
dependency on the external
<a href="https://github.com/JuliaLang/openlibm">OpenLibm</a>, which we also extended
with ARM support (this was just a case of fixing the build system; the code
is from FreeBSD's libm, which already supported ARM).</p>
<p>Mirage v1 also bundled <a href="http://www.fefe.de/dietlibc/">dietlibc</a> to provide its standard C library.
A nice side-effect of this work came when we were trying to separate out the
dietlibc headers from the old Mini-OS headers in Mirage.
These had rather grown together over time and the work was proving
difficult, until we discovered that we no longer needed a libc at all, as
almost everything that used it had been replaced with pure OCaml versions!
The only exception was the <code>printf</code> code for formatting floating point
numbers, which OCaml uses in its <code>printf</code> implementation.
We replaced that by taking the small <code>fmt_fp</code> function from
<a href="http://www.musl-libc.org/">musl libc</a>.</p>
<p>Here's the final diffstat of the changes to <a href="https://github.com/mirage/mirage-platform">mirage-platform</a>
adding ARM support:</p>
<pre><code>778 files changed, 1949 insertions(+), 59689 deletions(-)
</code></pre>
<h3>Trying it out</h3>
<p>You'll need an ARM device with the Virtualization Extensions.
I've been testing using the Cubieboard 2 (and CubieTruck):</p>
<p><img src="https://mirage.io/graphics/cubieboard2.jpg" alt="Cubieboard2"/></p>
<p>The first step is to install Xen.
<a href="https://mirage.io/docs/xen-on-cubieboard2">Running Xen on the Cubieboard2</a>
documents the manual installation process, but you can now also use
<a href="https://github.com/mirage/xen-arm-builder">mirage/xen-arm-builder</a> to build
an SDcard image automatically.
Copy the image to the SDcard, connect the network cable and power, and the
board will boot Xen.</p>
<p>Once booted you can ssh to Dom0, the privileged Linux domain used to manage
the system, <a href="https://mirage.io/docs/install">install Mirage</a>, and build your unikernel just
as on x86.
Currently, you need to select the Git versions of some components.
The following commands will install the necessary versions if you're using
the xen-arm-builder image:</p>
<pre><code class="language-bash">$ opam init
$ opam install mirage-xen-minios
$ opam remote add mirage-dev https://github.com/mirage/mirage-dev
$ opam install mirage
</code></pre>
<h3>Technical details</h3>
<p>One of the pleasures of unikernels is that you can comprehend the whole
system with relatively little effort, and
those wishing to understand, debug or contribute to the ARM support may find
the following technical sections interesting.
However, you don't need to know the details of the ARM port to use it,
as Mirage abstracts away the details of the underlying platform.</p>
<h4>The boot process</h4>
<p>An ARM Mirage unikernel uses the <a href="http://www.simtec.co.uk/products/SWLINUX/files/booting_article.html">Linux zImage format</a>, though it is
not actually compressed. Xen will allocate some RAM for the image and load
the kernel at the offset 0x8000 (32 KB).</p>
<p>Execution begins in <a href="https://github.com/talex5/xen/blob/cde4b7e14b0aeedcdc006b0622905b7af2665c77/extras/mini-os/arch/arm/arm32.S#L8">arm32.S</a>, with the <code>r2</code> register pointing to a
<a href="http://www.devicetree.org">Flattened Device Tree (FDT)</a> describing details of the virtual system.
This assembler code performs a few basic boot tasks:</p>
<ol>
<li>Configuring the MMU, which maps virtual addresses to physical addresses (see next section).
</li>
<li>Turning on caching and branch prediction.
</li>
<li>Setting up the exception vector table (this says how to handle interrupts and deal with various faults, such as reading from an invalid address).
</li>
<li>Setting up the stack pointer and calling the C function <code>arch_init</code>.
</li>
</ol>
<p><a href="https://github.com/talex5/xen/blob/cde4b7e14b0aeedcdc006b0622905b7af2665c77/extras/mini-os/arch/arm/setup.c#L74">arch_init</a> makes some calls to the hypervisor to set up support for the console and interrupt controller, and then calls <code>start_kernel</code>.</p>
<p><a href="https://github.com/mirage/mirage-platform/blob/b0a027d4486230ce6e1e8fd0e7354b17e9c388f5/xen/runtime/xencaml/main.c#L57">start_kernel</a> (in libxencaml) sets up a few more features (events, malloc, time-keeping and <a href="http://wiki.xen.org/wiki/Grant_Table">grant tables</a>), then calls <code>caml_startup</code>.</p>
<p><a href="https://github.com/mirage/mirage-platform/blob/b0a027d4486230ce6e1e8fd0e7354b17e9c388f5/xen/runtime/ocaml/startup.c#L202">caml_startup</a> (in libocaml) initialises the garbage collector and calls <code>caml_program</code>, which is your application's <code>main.ml</code>.</p>
<h4>The address space</h4>
<p>With the Virtualization Extensions, there are two stages to converting a
virtual memory address (used by application code) to a physical address in
RAM.
The first stage is under the control of the guest VM, mapping the virtual
address to what the guest believes is the physical address (this address is
referred to as the <em>Intermediate Physical Address</em> or <em>IPA</em>).
The second stage, under the control of Xen, maps the IPA to the real
physical address.
The tables holding these mappings are called <em>translation tables</em>.</p>
<p>Mirage's memory needs are simple: most of the RAM should be used for the
garbage-collected OCaml heap, with a few pages used for interacting with Xen
(these don't go on the OCaml heap because they must be page aligned and must
not move around).</p>
<p>Xen does not commit to using a fixed address as the IPA of the RAM, but the
C code needs to run from a known location. To solve this problem the
assembler code in <code>arm32.S</code> detects where it is running from and sets up a
virtual-to-physical mapping that will make it appear at the expected
location, by adding a fixed offset to each virtual address.
For example, on Xen/unstable, we configure the beginning of the virtual
address space to look like this (on Xen 4.4, the physical addresses would
start at 80000000 instead):</p>
<table>
  <tr><th>Virtual address</th><th>Physical address (IPA)</th><th>Purpose</th></tr>
  <tr><td>400000</td><td>40000000</td><td>Stack (16 KB)</td></tr>
  <tr><td>404000</td><td>40004000</td><td>Translation tables (16 KB)</td></tr>
  <tr><td>408000</td><td>40008000</td><td>Kernel image</td></tr>
</table>
<p>The physical address is always at a fixed offset from the virtual address and
the addresses wrap around, so virtual address c0400000 maps back to physical
address 0 (in this example).</p>
<p>The stack, which grows downwards, is placed at the start of RAM so that a
stack overflow will trigger a fault rather than overwriting other data.</p>
<p>The 16 KB translation table is an array of 4-byte entries each mapping 1 MB
of the virtual address space, so the 16 KB table is able to map the entire
32-bit address space (4 GB). Each entry can either give the physical section
address directly (which is what we do) or point to a second-level table
mapping individual 4 KB pages. By using only the top-level table we reduce
possible delays due to <a href="http://en.wikipedia.org/wiki/Translation_lookaside_buffer">TLB misses</a>.</p>
<p>After the kernel code comes the data (constants and global variables), then
the <a href="http://en.wikipedia.org/wiki/.bss">bss</a> section (data that is initially
zero, and therefore doesn't need to be stored in the kernel image),
and finally the rest of the RAM, which is handed over to the malloc system.</p>
<h3>Contact</h3>
<p>The current version seems to be working well on Xen 4.4 (stable) and the 4.5
development version, but has only been lightly tested.
If you have any problems or questions, or get it working on other devices,
please <a href="https://mirage.io/community/">let us know</a>!</p>

      

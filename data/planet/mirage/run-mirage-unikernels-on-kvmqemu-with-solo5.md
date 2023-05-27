---
title: Run Mirage Unikernels on KVM/QEMU with Solo5
description:
url: https://mirage.io/blog/introducing-solo5
date: 2016-01-07T00:00:00-00:00
preview_image:
featured:
authors:
- Dan Williams
---


        <p>I'm excited to announce the release of
<a href="https://github.com/solo5/solo5">Solo5</a>!
Solo5 is essentially a kernel library that bootstraps the hardware and
forms a base (similar to Mini-OS) from which unikernels can be built.
It runs on fully virtualized x86 hardware (e.g., KVM/QEMU), using
<code>virtio</code> device interfaces.</p>
<p>Importantly, Solo5 is integrated (to some extent) with the MirageOS
toolstack, so the Solo5 version of the Mirage toolstack can build
Mirage unikernels that run directly on KVM/QEMU instead of Xen.  As
such, Solo5 can be considered an alternative to Mini-OS in the Mirage
stack.  <a href="https://github.com/solo5/solo5">Try it out
today!</a></p>
<p>In the rest of this post, I'll give a bit of motivation about why I
think the lowest layer of the unikernel is interesting and important,
as well as a rough overview of the steps I took to create Solo5.</p>
<h3>Why focus so far down the software stack?</h3>
<p>When people think about Mirage unikernels, one of the first things
that comes to mind is the use of a high-level language (OCaml).
Indeed, the Mirage community has invested lots of time and effort
producing implementations of traditional system components (e.g., an
entire <a href="https://github.com/mirage/mirage-tcpip">TCP stack</a>) in OCaml.  The pervasive use of OCaml contributes to
security arguments for Mirage unikernels (strong type systems are
good) and is an interesting design choice well worth exploring.</p>
<p>But underneath all of that OCaml goodness is a little kernel layer
written in C.  This layer has a direct impact on:</p>
<ul>
<li>
<p><strong>What environments the unikernel can run on.</strong> Mini-OS, for
example, assumes a paravirtualized (Xen) machine, whereas Solo5
targets full x86 hardware virtualization with <code>virtio</code> devices.</p>
</li>
<li>
<p><strong>Boot time.</strong> &quot;Hardware&quot; initialization (or lack of it in a
paravirtualized case) is a major factor in achieving the 20 ms
unikernel boot times that are changing the way people think about
elasticity in the cloud.</p>
</li>
<li>
<p><strong>Memory layout and protection.</strong> Hardware &quot;features&quot; like
page-level write protection must be exposed by the lowest layer for
techniques like memory tracing to be performed.  Also,
software-level strategies like address space layout randomization
require cooperation of this lowest layer.</p>
</li>
<li>
<p><strong>Low-level device interfacing.</strong> As individual devices (e.g., NICs)
gain virtualization capabilities, the lowest software layer is an
obvious place to interface directly with hardware.</p>
</li>
<li>
<p><strong>Threads/events.</strong> The low-level code must ensure that device I/O
is asynchronous and/or fits with the higher-level synchronization
primitives.</p>
</li>
</ul>
<p>The most popular existing code providing this low-level kernel layer
is called Mini-OS.  Mini-OS was (I believe) originally written as
a vehicle to demonstrate the paravirtualized interface offered by Xen
for people to have a reference to port their kernels to and as a base
for new kernel builders to build specialized Xen domains.  Mini-OS is
a popular base for <a href="https://mirage.io">MirageOS</a>,
<a href="http://cnp.neclab.eu/projects/clickos/">ClickOS</a>,
and <a href="http://unikernel.org/projects/">other unikernels</a>.  Other
software that implements a unikernel base include
<a href="http://rumpkernel.org/">Rumprun</a> and <a href="http://osv.io/">OSv</a>.</p>
<p>I built Solo5 from scratch (rather than adapting Mini-OS, for example)
primarily as an educational (and fun!) exercise to explore and really
understand the role of the low-level kernel layer in a unikernel.  To
provide applications, Solo5 supports the Mirage stack.  It is my hope
that Solo5 can be a useful base for others; even if only at this point
to run some Mirage applications on KVM/QEMU!</p>
<h3>Solo5: Building a Unikernel Base from Scratch</h3>
<p>At a high level, there are roughly 3 parts to building a unikernel
base that runs on KVM/QEMU and supports Mirage:</p>
<ul>
<li>
<p><strong>Typical kernel hardware initialization.</strong> The kernel must know how
to load things into memory at the desired locations and prepare
the processor to operate in the correct mode (e.g., 64-bit).  Unlike
typical kernels, most setup is one-time and simplified.  The kernel
must set up a memory map, stack, interrupt vectors, and provide
primitives for basic memory allocation.  At its simplest, a
unikernel base kernel does not need to worry about user address
spaces, threads, or many other things typical kernels need.</p>
</li>
<li>
<p><strong>Interact with <code>virtio</code> devices.</strong> <code>virtio</code> is a paravirtualized
device standard supported by some hypervisors, including KVM/QEMU
and Virtualbox.  As far as devices go, <code>virtio</code> devices are simple:
I was able to write (very simple/unoptimized) <code>virtio</code> drivers for
Solo5 drivers from scratch in C.  At some point it may be
interesting to write them in OCaml like the Xen device drivers in
Mirage, but for someone who doesn't know OCaml (like me) a simple C
implementation seemed like a good first step.  I should note that
even though the drivers themselves are written in C, Solo5 does
include some OCaml code to call out to the drivers so it can connect with
Mirage.</p>
</li>
<li>
<p><strong>Appropriately link Mirage binaries/build system.</strong> A piece of
software called <a href="https://github.com/mirage/mirage-platform">mirage-platform</a>
performs the binding between Mini-OS
and the rest of the Mirage stack.  Building a new unikernel base
means that this &quot;cut point&quot; will have lots of undefined dependencies
which can either be implemented in the new unikernel base, stubbed
out, or reused.  Other &quot;cut points&quot; involve device drivers: the
console, network and block devices.  Finally, the <code>mirage</code> tool
needs to output appropriate Makefiles for the new target and an
overall Makefile needs to put everything together.</p>
</li>
</ul>
<p>Each one of these steps carries complexity and gotchas and I have
certainly made many mistakes when performing all of them.  The
hardware initialization process is needlessly complex, and the overall
Makefile reflects my ignorance of OCaml and its building and packaging
systems.  It's a work in progress!</p>
<h3>Next Steps and Getting Involved</h3>
<p>In addition to the aforementioned clean up, I'm currently exploring
the boot time in this environment.  So far I've found that generating
a bootable iso with GRUB as a bootloader and relying on QEMU to
emulate BIOS calls to load the kernel is, by the nature of emulation,
inefficient and something that should be avoided.</p>
<p>If you find the lowest layer of the unikernel interesting, please
don't hesitate to contact me or get involved.  I've packaged the build
and test environment for Solo5 into a Docker container to reduce the
dependency burden in playing around with it.  Check out <a href="https://github.com/solo5/solo5">the
repo</a> for the full
instructions!</p>
<p>I'll be talking about Solo5 at the upcoming <a href="http://wiki.xenproject.org/wiki/2016_Unikernels_and_More:_Cloud_Innovators_Forum_Schedule">2016 Unikernels and More:
Cloud Innovators
Forum</a>
event to be held on January 22, 2016 at <a href="https://www.socallinuxexpo.org/scale/14x">SCALE
14X</a> in Pasadena, CA USA.  I
look forward to meeting some of you there!</p>
<p><em>Discuss this post on <a href="https://devel.unikernel.org/t/run-mirage-unikernels-on-kvm-qemu-with-solo5/59">devel.unikernel.org</a></em></p>
<p><em>Thanks to <a href="https://twitter.com/amirmc">Amir</a>,
<a href="http://mort.io">Mort</a>,
and <a href="https://github.com/yallop">Jeremy</a>,
for taking the time to read and comment on earlier drafts.</em></p>

      

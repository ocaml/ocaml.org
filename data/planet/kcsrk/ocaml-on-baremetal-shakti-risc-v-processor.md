---
title: OCaml on Baremetal Shakti RISC-V processor
description:
url: https://kcsrk.info/ocaml/riscv/shakti/2019/03/29/1400-ocaml-baremetal-shakti/
date: 2019-03-29T14:00:00-00:00
preview_image:
featured:
authors:
- KC Sivaramakrishnan
---

<p>It has been 3 months since I joined <a href="https://www.iitm.ac.in/">IIT Madras</a> and it
has been good fun so far. Along with the members of the <a href="http://rise.cse.iitm.ac.in/">RISE
group</a>, we&rsquo;ve initiated a project to build secure
applications on top of secure extensions of the open-source
<a href="http://shakti.org.in/">Shakti</a> RISC-V processor ecosystem. Unsurprisingly, my
language of choice to build the applications is <a href="http://www.ocaml.org/">OCaml</a>.
Given the availability of rich ecosystem of libraries under the
<a href="https://mirage.io/">MirageOS</a> library operating system for building unikernels,
we hope to minimise the amount of unsafe C code that the hardware has to contend
with and protect exploits against. As a first step, we have managed to get OCaml
programs to run on directly on top of the Shakti processor running in simulation
under QEMU and Spike ISA simulators <em>without an intervening operating system</em>.</p>



<p>A custom bootloader performs the necessary hardware initialisation and
transfers control directly to the OCaml program. We have
<a href="https://gitlab.com/shaktiproject/tools/shakti-tee/ocaml-baremetal-riscv">open-sourced</a>
all of the tools necessary to build your own kernel. This handy
<a href="https://gitlab.com/shaktiproject/tools/shakti-tee/ocaml-baremetal-riscv/tree/master/docker">dockerfile</a>
documents the entire process. For the impatient, an image is available in the
dockerhub:</p>

<div class="language-bash highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nv">$ </span>docker run <span class="nt">-it</span> iitmshakti/riscv-ocaml-baremetal:0.1.0

<span class="c"># Write your program</span>
<span class="nv">$ </span><span class="nb">echo</span> <span class="s1">'let _ = print_endline &quot;A camel treads on hardware!&quot;'</span> <span class="o">&gt;</span> hello.ml
<span class="c"># Compile for Shakti</span>
<span class="nv">$ </span>ocamlopt <span class="nt">-output-obj</span> <span class="nt">-o</span> payload.o hello.ml
<span class="nv">$ </span>file payload.o
payload.o: ELF 64-bit LSB relocatable, UCB RISC-V, version 1 <span class="o">(</span>SYSV<span class="o">)</span>, not stripped

<span class="c"># Link with bootcode and build the kernel</span>
<span class="nv">$ </span>make <span class="nt">-C</span> ../build
make: Entering directory <span class="s1">'/root/ocaml-baremetal-riscv/build'</span>
make[1]: Entering directory <span class="s1">'/root/ocaml-baremetal-riscv/build'</span>
make[2]: Entering directory <span class="s1">'/root/ocaml-baremetal-riscv/build'</span>
make[2]: Leaving directory <span class="s1">'/root/ocaml-baremetal-riscv/build'</span>
<span class="o">[</span> 64%] Built target boot
make[2]: Entering directory <span class="s1">'/root/ocaml-baremetal-riscv/build'</span>
make[2]: Leaving directory <span class="s1">'/root/ocaml-baremetal-riscv/build'</span>
<span class="o">[</span> 78%] Built target freestanding-compat
make[2]: Entering directory <span class="s1">'/root/ocaml-baremetal-riscv/build'</span>
make[2]: Leaving directory <span class="s1">'/root/ocaml-baremetal-riscv/build'</span>
<span class="o">[</span> 85%] Built target asmrun_t
make[2]: Entering directory <span class="s1">'/root/ocaml-baremetal-riscv/build'</span>
make[2]: Leaving directory <span class="s1">'/root/ocaml-baremetal-riscv/build'</span>
<span class="o">[</span> 92%] Built target nolibc_t
make[2]: Entering directory <span class="s1">'/root/ocaml-baremetal-riscv/build'</span>
make[2]: Leaving directory <span class="s1">'/root/ocaml-baremetal-riscv/build'</span>
<span class="o">[</span>100%] Built target kernel
make[1]: Leaving directory <span class="s1">'/root/ocaml-baremetal-riscv/build'</span>
make: Leaving directory <span class="s1">'/root/ocaml-baremetal-riscv/build'</span>
<span class="nv">$ </span>file kernel 
kernel: ELF 64-bit LSB executable, UCB RISC-V, version 1 <span class="o">(</span>SYSV<span class="o">)</span>, statically linked, with debug_info, not stripped

<span class="c"># Run under spike RISC-V ISA simulator</span>
<span class="nv">$ </span>spike kernel
ocaml-boot: heap@0x80042be8 stack@0x8002fbc0
A camel treads on hardware!
ocaml-boot: caml runtime returned. shutting down!

<span class="c"># Run under QEMU</span>
<span class="nv">$ </span>qemu-system-riscv64 <span class="nt">-machine</span> spike_v1.10 <span class="nt">-smp</span> 1 <span class="nt">-m</span> 1G <span class="nt">-serial</span> stdio <span class="nt">-kernel</span> kernel
VNC server running on 127.0.0.1:5900
ocaml-boot: heap@0x80042be8 stack@0x8002fbc0
A camel treads on hardware!
ocaml-boot: caml runtime returned. shutting down!
</code></pre></div></div>

<p>The immediate next step will be getting the code to run on a Shakti softcore on
an FPGA. In addition to targeting high-end FPGAs, we will also be targeting the
$100 <a href="https://store.digilentinc.com/arty-a7-artix-7-fpga-development-board-for-makers-and-hobbyists/">Arty
A7</a>
hobbyist board and release all of the software under liberal open-source
licenses.</p>

<p>Further along, we will port mirage libraries to Shakti following similar to the
setup in <a href="https://github.com/well-typed-lightbulbs/">Well-typed lightbulbs</a> and
implementing hardware security enhancements in Shakti for preventing spatial and
temporal attacks while running unsafe C code (with the ability to dynamically
turn it off when running OCaml!), hardware-assisted compartments, etc. Lots of
exciting possibilities on the horizon!</p>

<h2>Acknowledgements</h2>

<p>Much of this work was done by the incredible <a href="https://github.com/sl33k">Malte</a>,
who is a visiting student at IIT Madras on a semester away from Leibniz
University Hannover,
<a href="https://www.linkedin.com/in/arjun-menon/?originalSubdomain=in">Arjun</a>, Lavanya,
Ambika, <a href="http://www.cse.iitm.ac.in/~chester/">Chester</a>, and the rest of the
Shakti team. The RISC-V port of OCaml is developed and maintained by <a href="https://nojb.github.io/">Nicol&aacute;s
Ojeda B&auml;r</a>.</p>


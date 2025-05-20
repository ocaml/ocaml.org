---
title: Webassembly on exotic architectures (a 2025 roundup)
description:
url: https://anil.recoil.org/notes/wasm-on-exotic-targets
date: 2025-04-16T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
ignore: true
---

<p>It's about the time of the academic year to come up with project <a href="https://anil.recoil.org/ideas">ideas</a>! <a href="https://kcsrk.info" class="contact">KC Sivaramakrishnan</a>, <a href="https://github.com/andrewray" class="contact">Andy Ray</a> and I have been looking into <a href="https://anil.recoil.org/notes/fpgas-hardcaml">FPGA/OCaml matters</a> recently so I thought I'd review the latest in the land of <a href="https://webassembly.org">Webassembly</a> for non-traditional hardware targets.  It turns out that there are very fun systems projects going on to turn wasm into a "real" target architecture on several fronts: a native port of Linux to run in wasm, a port of wasm to run in kernel space, a POSIX mapping of wasm, and fledgling wasm-CPUs-on-FPGAs.</p>
<h2>Native port of Linux to wasm</h2>
<p>The first one is a <a href="https://github.com/tombl/linux"><em>native</em> port</a> of the Linux kernel to run in webassembly (<a href="https://linux.tombl.dev">try it in your browser</a>). This isn't an emulation; instead, the various kernel subsystems have been ported to have wasm interfaces, so the C kernel code runs directly as webassembly, with virtual device layers.</p>
<p>The inspiration for this seems to have come from a famous comment eight years ago on the LKML:</p>
<blockquote>
<p>One more general comment: I think this may well be the last new CPU architecture we ever add to the kernel. Both nds32 and c-sky are made by companies that also work on risc-v, and generally speaking risc-v seems to be killing off any of the minor licensable instruction set projects, just like ARM has mostly killed off the custom vendor-specific instruction sets already. If we add another architecture in the future, it may instead be something like the LLVM bitcode or WebAssembly, who knows?
<cite>-- <a href="https://lore.kernel.org/all/CAK8P3a2-wyXxctVtJxniUoeShASMhF-6Z1vyvfBnr6wKJuioAQ@mail.gmail.com/">Arnd Bergmann, LKML, 2018</a></cite></p>
</blockquote>
<p>And this port brings us much closer to that!  I need to spelunk more into the diffs to the mainline kernel to see how it all works, but some quick notes:</p>
<ul>
<li>the <a href="https://github.com/tombl/linux/blob/777d95246a8b1dc184e991a76946ccafef392206/tools/wasm/src/worker.ts">tools/wasm</a> directory shows how some of the glue code works, such as the <a href="https://github.com/tombl/linux/blob/777d95246a8b1dc184e991a76946ccafef392206/tools/wasm/src/worker.ts">worker.ts</a> which uses <a href="https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers">WebWorkers</a> to implement multicore, and the venerable <a href="https://wiki.libvirt.org/Virtio.html">virtio</a> to implement <a href="https://github.com/tombl/linux/blob/wasm/tools/wasm/src/virtio.ts#L204">virtual block devices</a>.</li>
<li>the <a href="https://github.com/tombl/linux/tree/777d95246a8b1dc184e991a76946ccafef392206/arch/wasm">arch/wasm</a> contains the glue code, and <a href="https://github.com/tombl/linux/blob/777d95246a8b1dc184e991a76946ccafef392206/arch/wasm/kernel/irq.c#L17">mm.c</a> shows how atomic builtins in wasm are sufficient to implement low-level memory management. The <a href="https://github.com/tombl/linux/blob/777d95246a8b1dc184e991a76946ccafef392206/arch/wasm/kernel/fork.c#L12C2-L12C24">clone</a> implementation leads us to <a href="https://github.com/tombl/linux/blob/777d95246a8b1dc184e991a76946ccafef392206/arch/wasm/include/asm/wasm_imports.h">wasm_imports.h</a> which shows all the FFI stubs needed from the runtime in <a href="https://github.com/tombl/linux/blob/777d95246a8b1dc184e991a76946ccafef392206/tools/wasm/src/wasm.ts#L21">worker.ts</a>.  Notably, it looks like the <a href="https://github.com/tombl/linux/blob/777d95246a8b1dc184e991a76946ccafef392206/tools/wasm/src/worker.ts#L103">process switcher</a> doesn't use the <a href="https://github.com/WebAssembly/stack-switching">wasm stack switching</a> extension (possibly for compatibility?).</li>
<li>the <a href="https://github.com/tombl/linux/blob/777d95246a8b1dc184e991a76946ccafef392206/arch/wasm/kernel/syscall.c#L19">arch/wasm/kernel/syscall.c</a> (and that whole directory) could form the basis for a nice OS teaching course. Implementing the core of an OS on a virtual hypervisor is always <a href="https://anil.recoil.org/projects/unikernels">an educational experience</a>, and this port is based on "real" Linux!</li>
</ul>
<h2>Running wasm in Linux kernel mode</h2>
<p>On the opposite end of the architecture spectrum, we have a <a href="https://github.com/wasmerio/kernel-wasm">Linux in-kernel WASM runtime</a>. This one allows running userspace code within the kernel space, as motivated by:</p>
<blockquote>
<p>Since WASM is a virtual ISA protected by a virtual machine, we don't need to rely on external hardware and software checks to ensure safety. Running WASM in the kernel avoids most of the overhead introduced by those checks, e.g. system call (context switching) and <code>copy_{from,to}_user</code>, therefore improving performance.
Also, having low-level control means that we can implement a lot of features that were heavy or impossible in userspace, like virtual memory tricks and handling of intensive kernel events (like network packet filtering).
<cite>-- <a href="https://github.com/wasmerio/kernel-wasm?tab=readme-ov-file#why-run-webassembly-in-the-kernel">Why run Wasm in the kernel</a></cite></p>
</blockquote>
<p>There are some interesting <a href="https://github.com/wasmerio/wasmer/tree/main/examples#examples">example applications</a> available that they accelerate. They report on the speedup for an echo and http server that can run in kernel space:</p>
<blockquote>
<p>When compiled with the singlepass backend (unoptimized direct x86-64 code generation) and benchmarked using tcpkali/wrk, echo-server is ~10% faster (25210 Mbps / 22820 Mbps) than its native equivalent, and http-server is ~6% faster (53293 Rps / 50083 Rps). Even higher performance is expected when the other two Wasmer backends with optimizations (Cranelift/LLVM) are updated to support generating code for the kernel.
<cite>-- <a href="https://github.com/wasmerio/kernel-wasm?tab=readme-ov-file#examples-and-benchmark">kernel wasm benchmarks</a></cite></p>
</blockquote>
<h2>Running POSIX applications in the browser</h2>
<p>The kernel-wasm port lead me to look more closely at the wasmer runtime, which in turn also extends the <a href="https://wasi.dev">wasi</a> server-side interface of WASM to support full POSIX compatibility. You can also view this in the <a href="https://wasmer.sh">browser as a shell</a>, where a variety of applications can be compiled to wasm and run as if you had a shell in the browser!</p>
<p>There is impressive support for POSIX here, as well as an <a href="https://wasmer.io/posts/introducing-the-wasmer-js-sdk">wasmer/wasix SDK</a> to port existing applications like ffmpeg to run in the browser or <a href="https://wasmer.io/posts/wasmer-js-sdk-now-supports-node-and-bun">on in a server JS runtime</a>.</p>
<p>So what's stopping OCaml --via the <a href="https://tarides.com/blog/2023-11-01-webassembly-support-for-ocaml-introducing-wasm-of-ocaml/">new wasm-of-ocaml compiler</a> -- from running in the browser? Just the fact that our target runtime depends on the <a href="https://github.com/WebAssembly/stack-switching">wasm stack switching</a> extension, and <a href="https://github.com/ocaml-wasm/wasm_of_ocaml/issues/101#issuecomment-2464706078">wasmer doesnt yet support that extension</a>. Since there, wasmer 2.3 has <a href="https://wasmer.io/posts/wasmer-2_3">improved stack switching</a> performance but the extension isn't quite there yet. So if anyone's looking for some experience with language runtime hacking, this might be a good project. I couldn't find any information on whether wasmer is planning on adding support for this extension yet though.</p>
<h2>Running wasm on an FPGA</h2>
<p>And last but not least, given all of the above, what would it take to run wasm on an FPGA directly? The existence of the Linux native wasm port is encouraging, since it implies that if you were to get wasm instructions to run directly on an FPGA (just like you might wiht a <a href="https://discuss.ocaml.org/t/hardcaml-mips-cpu-learning-project-and-blog/8088">MIPS FPGA CPU</a> or a <a href="https://github.com/ujamjar/hardcaml-riscv">RISC-V one</a>), then you could hook up the rest of the OS ecosystem to this as custom drivers.</p>
<p>I found a few projects around this space that I need to look into more:</p>
<ul>
<li>wasmachine is an implementation of the WebAssembly specification in a FPGA. It follows a sequential 6-steps design. <a href="https://github.com/piranna/wasmachine">https://github.com/piranna/wasmachine</a> (see <a href="https://github.com/WebAssembly/design/issues/1050">wasm design discussion</a>)</li>
<li>a <a href="https://github.com/denisvasilik/wasm-fpga-engine">wasm-fpga-engine</a> that executes a subset of instructions</li>
<li>an <a href="https://www.mdpi.com/2079-9292/13/20/3979">FPGA accelerator for WASM instructions</a>. This one came before the stack switching extension though, which might make the implementation in hardware significantly easier.</li>
</ul>
<h2>And more...</h2>
<p>After first posting this, here are incoming updates. <a href="https://bsky.app/profile/jonaskruckenberg.de/post/3lmygmvbidc2i">Jonas Kruckenberg</a> tells me that he's got an experimental OS called <a href="https://github.com/JonasKruckenberg/k23">k23</a>. This is a microkernel that is built around the idea of using Wasm as the primary execution environment:</p>
<blockquote>
<p>This allows for a number of benefits:</p>
<ul>
<li>Security: WebAssembly is designed to run in a sandboxed environment, making it much harder to exploit.</li>
<li>Modularity: WebAssembly modules can depend on each other, importing and exporting functionality and data, forming a modular system where dependency management is a first class citizen.</li>
<li>Portability: WebAssembly is designed to be very portable. Forget questions like "is this binary compiled for amd64 or arm?". k23 programs just run wherever.</li>
<li>Static Analysis: WebAssembly is famous for being very easy to analyze. This means we can check for bad programs without even running them.
<cite>-- <a href="https://jonaskruckenberg.github.io/k23/">The k23 manual</a></cite></li>
</ul>
</blockquote>


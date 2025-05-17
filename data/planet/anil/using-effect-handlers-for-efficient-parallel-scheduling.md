---
title: Using effect handlers for efficient parallel scheduling
description:
url: https://anil.recoil.org/ideas/parallel-scheduling-with-effects
date: 2022-01-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<h1>Using effect handlers for efficient parallel scheduling</h1>
<p>This is an idea proposed in 2022 as a Cambridge Computer Science Part III or MPhil project, and has been <span class="idea-completed">completed</span> by <a href="https://github.com/bartoszmodelski" class="contact">Bartosz Modelski</a>.</p>
<p>Modern hardware is so parallel and workloads are so concurrent, that there is
no single, perfect scheduling strategy across a complex application software
stack. Therefore, there are significant performance advantages to be gained
from customizing and composing schedulers.</p>
<p>Multicore parallelism is here to stay, and in contrast with clock frequency
increases, schedulers have to be carefully crafted in order to take full
advantage of horizontal scaling of the underlying architecture. That’s because
designs need to evolve as synchronization primitives such as locks or atomics
do not scale endlessly to many cores, and a naive work stealing scheduler that
may have been good enough on 16-thread Intel Xeon in 2012 will fail to utilize
all 128 threads of a contemporary AMD ThreadRipper in 2022.  Modern high-core
architectures also feature non-uniform memory and so memory latency patterns
vary with the topology. Scheduling decisions will benefit from taking mem- ory
hierarchy into account. Moreover, the non-uniformity also appears also in
consumer products such as Apple M1 or Intel Core i7-1280P. These highlight two
sets of cores in modern architectures: one optimized for performance and
another one for efficiency.</p>
<p>This project uses the experimental multicore OCaml extension to explore
concurrent scheduling on multicore hardware, using library schedulers. Common
programming languages either include threading support, which is tightly
coupled with the language itself, or offer no support and, thus,
library-schedulers cannot offer much beyond simply running scheduled functions
in some order. OCaml, on the other hand, features fibers and effects. Together,
they allow writing a direct style, stack-switching scheduler as a library.
Further, OCaml allows composing schedulers -- a much-needed mechanism for
executing diverse workloads with portions having different optimization
criteria.</p>
<h2>Results</h2>
<p>The project was successfully concluded. To validate the hypothesis, it
developed several practical userspace schedulers and extended them with a
number of work distribution methods. The code was written in OCaml with
multicore support, which features a novel effects-based approach to
multithreading. Most importantly, it decoupled lightweight threading from the
runtime and lets user compose schedulers.
The evaluation involved several real-world benchmarks executed on up to 120
threads of a dual-socket machine with two AMD EPYC 7702 processors.</p>
<p>The results showed that scaling applications to high core counts is
non-trivial, and some classic methods such as work stealing do not provide
optimal performance. Secondly, different scheduling policies have a profound
impact on the throughput and latency of specific benchmarks, which justifies
the need to compose schedulers for heterogeneous workloads. Further, a
composition of schedulers in a staged architecture was shown to provide better
tail latency than its components. Moreover, the performance of the scheduler
developed in this project was shown to improve over the existing default
Multicore OCaml scheduler - Domainslib. Finally, the results put in question a
common design of overflow queue present in e.g., Go and Tokio (Rust).</p>
<p>Read the full <a href="https://github.com/bartoszmodelski/ebsl/blob/main/report/report.pdf">report
PDF</a>
online, and see the <a href="https://github.com/bartoszmodelski/ebsl">notebooks</a>
associated with the experiments here.</p>


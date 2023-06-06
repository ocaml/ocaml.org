---
title: 'OS as a Development Environment: A Journey of Discovery'
description:
url: https://mirage.io/blog/2022-04-04.QuebesFirewall
date: 2022-04-04T00:00:00-00:00
preview_image:
featured:
authors:
- Pierre Alain
---


        <p>My first experience with the Mirage ecosystem was using <code>qubes-mirage-firewall</code> as a way to decrease resource usage for an internal system task. Just before the release of MirageOS 3.9, I participated in testing PVH-mode unikernels with Solo5. I found it interesting with very constructive exchanges and high-quality speakers (@mato, @talex5, @hannesm) to correct some minor bugs.</p>
<h3>Observations and an Issue Rises</h3>
<p>After the release of Mirage 3.9 and the ability to launch unikernels in PVH-mode with Solo5, my real adventure with Mirage started when I noticed a drop in the bandwidth performance compared to the Linux firewall in <a href="https://github.com/mirage/qubes-mirage-firewall/issues/120">Qubes</a>.</p>
<p>The explanation was quickly found: each time a network packet was received, the firewall performed a memory statistic call to decide whether it needed to trigger the garbage collector. The idea behind this was simply to perform the collection steps before running out of memory.</p>
<p>With the previous system (Mini-OS), the amount of free memory was directly accessible; however, with Solo5, the <code>nolibc</code> implementation used the <code>dlmalloc</code> library to manage allocations in the heap. The interface that showed the fraction of occupied memory (<code>mallinfo()</code>) had to loop over the whole heap to count the used and unused areas. This scan is time-linear with the heap size; therefore it took time to make the operation visible when it was performed (in <code>qubes-mirage-firewall</code>) for each packet.</p>
<p>The first proposed solution was to use a less accurate <code>dlmalloc</code> call <a href="https://github.com/mirage/qubes-mirage-firewall/pull/116#issuecomment-704827905">footprint()</a> which could overestimate the memory usage. This solution had the advantage to be low-cost and increase the bandwitdh performance. However, this overestimation is currently strictly increasing. Without going into details, <code>footprint()</code> gives the amount of memory obtained from the system, which corresponds approximately to the top of the heap. It is possible to give back the top of the heap to Solo5 by calling <code>trim()</code>, which is, sadly, currently not available in the OCaml environment, thus the top of the heap increases. After a while, the amount of free memory falls below a threshold, and our firewall spends its time writing log messages warning about the lack of memory, but it never can solve the problem. The first clue suggested that this was due to a memory leak.</p>
<h3>Several Avenues to Explore</h3>
<p>As a computer science degree teacher, I can sometimes propose internship topics to students, so I challenged one student to think about this memory leak problem. We tried:</p>
<ul>
<li>to understand how to trigger the memory leak problem in a consistent way. Unfortunately it was an erratic behavior which made the analysis of the situation complex.
</li>
<li>to replace <code>dlmalloc</code> by a simpler allocator written from scratch from binary buddy in Knut's TAOCP. The problem with this attempt was the large allocator overhead, as it takes almost 10MB of data structure to manage 32MB of memory.
</li>
<li>to keep <code>dlmalloc</code> and count the allocations, releases, reallocations, etc., the hard way with requests to keep the total amount of memory allocated for the unikernel in a simple C variable, like what existed in Mini-OS.
</li>
</ul>
<p>This latest solution looks promising at the beginning of this year, and we're now able to have an estimate of the occupied memory, which goes up and down with the allocations and the garbage collector calls (<a href="https://github.com/mirage/qubes-mirage-firewall/issues/120#issuecomment-1006642747">link</a>). Bravo Julien! It still remains to test and produce the PR to finally close this Issue.</p>
<h3>Sharing Files as a Side Project</h3>
<p>In parallel to this first experience with MirageOS, and for which I had not practiced OCaml at all, I began developing with MirageOS by writing a tool for my personal usage!</p>
<p>Before telling you about it, I have to add some context: it's easy to have one or more encrypted partitions mountable on the fly with <code>autofs</code>, but I haven't managed to have an encrypted folder that can behave as such an encrypted partition.</p>
<p>In January 2021, the Mirage ecosystem got a library that permits unikernels to communicate using the SSH protocol : Aw&aacute;-ssh. The server part hadn't been updated since the first version, so I was able to start soaking up by updating this part.</p>
<p>As a developer, I use SSHFS very regularly to mount a remote folder from a server to access and drop&mdash;in short, to manipulate files. The good thing is that with my need to have an encrypted folder and the ability to respond in a unikernel to an incoming SSH connection, I was able to capitalize on this work on Aw&aacute;-ssh server to add the management of an SSHFS mount.</p>
<p>The first work was to follow the SSHFS RFC to handle the SSHFS protocol. Thanks again @hannesm for the help on adapting the aw&aacute;-unix code to have an aw&aacute;-mirage module!</p>
<p>Quickly I needed a real file system for my tests. With luck, Mirage offers a file system! Certainly basic, but sufficient for my tests, the venerable FAT16!</p>
<p>With this file system onboard, I was able to complete writing the unikernel, and now I'm able to easily share files (small files, as the FAT16 system doesn't help here) on my local network, thanks to the UNIX version of the unikernel. The great thing about MirageOS is that I'm also able to do it by running the unikernel as a virtual machine without changing the code, just by changing the target at compile time!</p>
<p>However, I still have a lots of work to do to reach my initial goal of being able to build an encrypted folder on Linux (a side project will probably always take long to complete), I need to:
- add an encryption library for a disk block
- add a real file system with the features of a modern system like btrfs</p>
<p>To answer the first point, and as the abstraction is a strong feature of MirageOS, it is very feasible to change the physical access to the file system in a transparent way. Concerning the second point there are already potential candidates to look at!</p>
<h3>MirageOS 4</h3>
<p>With the recent release of MirageOS 4, I truly appreciate the new build system that allows fast code iterations through all used dependencies. It considerably helped me fix a runtime issue on Xen and post a PR! Thanks to the whole team for their hard work, and it was a really nice hacking experience! The friendliness and helpfulness of the community is really a plus for this project, so I can't encourage people enough to try writing unikernels for their own needs. You'll get full help and advice from this vibrant community!</p>

      

---
title: Xen Hypervisor
description:
url: https://anil.recoil.org/projects/xen
date: 2002-01-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<div>
  <h1>Xen Hypervisor</h1>
  <p></p><p>I was on the original team at Cambridge that built the Xen hypervisor in 2002
-- the first open-source "type-1" hypervisor that ushered in the age of cloud
computing and virtual machines.  Xen emerged from the Xenoservers project at
the CL SRG, where I started my PhD and hacked on the emerging codebase and
subsequently worked on the development of the commercial distribution of
XenServer.</p>
<p>Back at the turn of the century, the Computer Lab SRG faculty at the time
(led by my first PhD supervisor <a href="https://anil.recoil.org/news.xml" class="contact">Ian Pratt</a>) decided to start the
<a href="https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-552.pdf">XenoServers</a> project,
which would build a public infrastructure for wide-area distributed computing.
An <a href="https://gow.epsrc.ukri.org/NGBOViewGrant.aspx?GrantRef=GR/S01894/01">EPSRC grant</a> lead
to a number of graduate students all surging into the SRG in around 2002 to
work on the project, including me.</p>
<p>The later history of Xen is chronicled <a href="http://www-archive.xenproject.org/community/xenhistory.html">on the original Xen
website</a>, but the
early days were a heady mixture of furious hacking to put the various
prototypes together. I did a very early port of NetBSD to the PV interface,
before the introduction of linear page table checking into the hypervisor
defeated my port and Christian Limpach took it over.  That early work was
recorded in the <a href="https://anil.recoil.org/papers/xen02">Xen 2002</a> technical report. My involvement for a while after was
limited, as I also interned with Sandy Fraser in Princeton and set up the <a href="https://anil.recoil.org/projects/ubiqinteraction">Ubiquitous Interaction Devices</a>
project with Intel Research.</p>
<p>It was after the open source release of Xen 1.0 and the submission of my PhD
thesis that I joined XenSource as an early engineer and began release managing
the first commercial distribution of Xen, known as XenServer.  This involved
building an entire embedded "appliance" that hid the underlying complexities of
managing virtual machines. To add to the fun, we also built an entire
management toolstack in OCaml, making it one of the largest commercial uses
of functional programming back then.  Our experiences with building
this are published in <a href="https://anil.recoil.org/papers/2010-icfp-xen">Using functional programming within an industrial product group: perspectives and perceptions</a>, and the XenServer management stack is still
going strong as an <a href="https://github.com/xapi-project/xen-api">open source project</a>.</p>
<p>The nitty-gritty of XenServer engineering has never been captured in an academic
paper, but I wrote a few blog posts (on the now-defunct Citrix blog) that are
mirrored here:</p>
<ul>
<li><a href="https://anil.recoil.org/notes/installing-ubuntu-on-xenserver">Installing Ubuntu on XenServer</a> covers how the then-nascent Linux distribution could be virtualised.</li>
<li><a href="https://anil.recoil.org/notes/shedding-some-light-on-xenapp-on-xenserver-performance-tuning">Shedding light on XenApp on XenServer performance tuning</a> discusses some performance profiling issues with XenServer after the Citrix acquisition of XenSource.</li>
<li><a href="https://anil.recoil.org/notes/peeking-under-the-hood-of-high-availability">Peeking under the hood of High Availability</a> illustrates the extremely cool high-availability feature we built into XenServer 5.0, using some fairly complex OCaml hacking under the hood of the management stack.</li>
</ul>
<p>Once I returned to academia full-time in 2010, much of my later work also improved
the Xen toolstack.  I laid out the early vision for multiscale computing in <a href="https://anil.recoil.org/papers/2010-bcs-visions">Multiscale not multicore: efficient heterogeneous cloud computing</a>
and subsequently a prototype from the <a href="https://anil.recoil.org/projects/unikernels">Unikernels</a> project in <a href="https://anil.recoil.org/papers/2010-hotcloud-lamp">Turning Down the LAMP: Software Specialisation for the Cloud</a>.
As Xen got itself an ARM port a few years
later, my work on <a href="https://anil.recoil.org/papers/2015-nsdi-jitsu">Jitsu: Just-In-Time Summoning of Unikernels</a> also fed back to Xen development by highlighting potential efficiencies in the toolstack.
I also investigated whether FPGAs would make sense in cloud environments in <a href="https://anil.recoil.org/papers/2011-fccm-cloudfpga">Reconfigurable Data Processing for Clouds</a>.</p>
<p>In 2021, I largely use Solo5 and KVM as my main hacking and production
hypervisor, but I plan to revisit Xen at some point as I begin looking
at RISC-V architectures and embedded systems again as part of <a href="https://anil.recoil.org/projects/osmose">Interspatial OS</a>.</p>
<p></p>
</div>


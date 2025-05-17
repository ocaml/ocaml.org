---
title: Personal Containers
description:
url: https://anil.recoil.org/projects/perscon
date: 2009-01-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<div>
  <h1>Personal Containers</h1>
  <p></p><p>As cloud computing empowered the creation of vast data silos, I investigated how decentralised technologies might be deployed to allow individuals more vertical control over their own data. Personal containers was the prototype we built to learn how to stem the flow of our information out to the ad-driven social tarpits. We also deployed personal containers in an experimental data locker system at the University of Cambridge in order to incentivise lower-carbon travel schemes.</p>
<p>I've had a passion for self-hosted, decentralised computing for many years
since <a href="https://nick.recoil.org" class="contact">Nick Ludlam</a> and I set up the recoil.org collective in the late 90s. In
late 2008, I'd been working on early cloud computing as part of the <a href="https://anil.recoil.org/projects/xen">Xen Hypervisor</a>
project and already seeing the rapid rise of centralised data gathering in
the early cloud providers.  When I left Citrix in 2009, I joined <a href="https://drdrmc.github.io/about/" class="contact">Derek McAuley</a> and
<a href="mailto:jon.crowcroft@cl.cam.ac.uk" class="contact">Jon Crowcroft</a> in their new <a href="https://www.horizon.ac.uk">Horizon Digital Economy</a>
centre to lead a charge into building more privacy-centred digital infrastructure.
I had the huge privilege of receiving a strings-free 5-year postdoctoral fellowship in
Cambridge. It's rare to see such long term postdoc opportunities these days, but
something I am hugely supportive of for new projects.</p>
<p>My hacking first began with <a href="https://nick.recoil.org" class="contact">Nick Ludlam</a> in 2008 on a prototype of a
<a href="https://github.com/avsm/lifedb-server">lifedb</a> server and app, which we
envisioned as a place to aggregate all the messages from disparate sources (for
example, to mirror the then-new Twitter service into my IMAP email).  I worked
on <a href="https://anil.recoil.org/papers/2010-smarte-privacybutler">Privacy Butler: A Personal Privacy Rights Manager for Online Presence</a> to add a policy engine to this prototype.
While the prototype worked well enough for me, it was largely a negative result
since it was just too risky to put all that private data in one location
(especially aggregated).</p>
<p>Now back at Cambridge in 2010, I began working with <a href="https://github.com/samoht" class="contact">Thomas Gazagnaire</a> on a more robust
implementation of data aggregation that would have stronger end-to-end security
and privacy. We started coding up an implementation in OCaml to followup
my <a href="https://anil.recoil.org/projects/melange">Functional Internet Services</a> work, and built out infrastructure like an OCaml ORM in
<a href="https://anil.recoil.org/papers/2010-dyntype-wgt">Dynamics for ML using Meta-Programming</a> to make it easier to work with databases.  It became
obvious pretty quickly that having this much data in one place required
end users to become sysadmins, and so I started to lay out a new architecture
for this sort of end-user managed data in <a href="https://anil.recoil.org/papers/2010-bcs-visions">Multiscale not multicore: efficient heterogeneous cloud computing</a>.</p>
<p>Our first prototype of a personal container running as a unikernel was published
in <a href="https://anil.recoil.org/papers/2010-hotcloud-lamp">Turning Down the LAMP: Software Specialisation for the Cloud</a>, and would form the basis of the MirageOS project. To this day, the MirageOS community remains passionate about decentralised systems from these origins! We explored a number of directions in the early days:</p>
<ul>
<li><a href="https://anil.recoil.org/papers/2010-iswp-dustclouds">Using Dust Clouds to Enhance Anonymous Communication</a> looked into spawning tiny unikernels on public cloud infrastructure to form a "fast flux" for onion routing. This remains a pretty good idea and something I'd like to see implemented on modern public clouds!</li>
<li><a href="https://anil.recoil.org/papers/de10-perscon">The personal container, or your life in bits</a> was the evolution of the lifedb into the "personal container". Although its domain name is now offline, you can still find the <a href="https://github.com/avsm/perscon.net">original perscon.net blog</a> repository.  I worked pretty hard on a <a href="https://github.com/avsm/perscon">perscon prototype</a> that you can read about in <a href="https://anil.recoil.org/notes/uiprototype">Pulling together a user interface</a> and <a href="https://anil.recoil.org/notes/yurts-for-digital-nomads">Yurts for Digital Nomads</a>.</li>
<li><a href="https://anil.recoil.org/papers/2011-nsdi-ciel">CIEL: A universal execution engine for distributed data-flow computing</a> investigated what a distributed dataflow engine might look like to help with processing the vast amounts of personal data we were working with.  The primary author of CIEL <a href="https://github.com/mrry" class="contact">Derek Murray</a> went on to develop Naiad and other influential systems in this space, but I still like CIEL's very simple model. I built a simple continuation based implementation in <a href="https://anil.recoil.org/notes/datacaml-with-ciel">DataCaml: distributed dataflow programming in OCaml</a>, and as of 2021 am continuing this work again with OCaml's multicore effects in <a href="https://anil.recoil.org/projects/ocamllabs">OCaml Labs</a>.</li>
<li>From an Internet architecture perspective, another fascinating line of thought we came up with was the notion of giving every user their own domain name server that would give them fine-grained control over network connectivity.  The <a href="https://anil.recoil.org/papers/2012-sigcomm-signposts">Signposts: end-to-end networking in a world of middleboxes</a> and <a href="https://anil.recoil.org/papers/2013-foci-signposts">Lost in the Edge: Finding Your Way with DNSSEC Signposts</a> papers both lay out an architecture for a DNSSEC-based dynamic DNS server that users can control.  We explored how a "polyversal TCP" might look for making p2p connections from this in <a href="https://anil.recoil.org/papers/2012-conext-pvtcp">Evolving TCP: how hard can it be?</a>, as well as a software Openflow switch to route data from cloud to edge devices in <a href="https://anil.recoil.org/papers/2012-iccsdn-mirageflow">Cost, Performance &amp; Flexibility in OpenFlow: Pick three</a>.</li>
<li><a href="https://anil.recoil.org/papers/2012-ahans-soapp">Exploring Compartmentalisation Hypotheses with SOAAP</a> was the result of my collaboration with the just-established CHERI project at the Computer Lab on compartmentalisation interfaces, another area of programming that continues to need improvement.</li>
</ul>
<p>One of the main drivers for personal containers was to drive applications that would otherwise be too invasive from a privacy perspective. <a href="https://anil.recoil.org/news.xml" class="contact">Ian Leslie</a> and I worked on the "c-aware" project in <a href="https://anil.recoil.org/papers/2012-mpm-caware">Confidential carbon commuting: exploring a privacy-sensitive architecture for incentivising 'greener' commuting</a> to figure out if personal containers could help influence user behaviour to reduce carbon usage.  Overall, this project taught us just how much effort it would be to deploy real-world infrastructure in corporate environments like the University of Cambridge.  We also struggled to get any users to deploy our prototype servers, something explored more in user studies with colleagues in Horizon Nottingham in <a href="https://anil.recoil.org/papers/de13-dataware">Perceived risks of personal data sharing</a>.</p>
<p>My work on personal data processing petered out from a research perspective in around 2013 since the underlying infrastructure I had built really started gathering steam with <a href="https://anil.recoil.org/projects/unikernels">Unikernels</a> and <a href="https://anil.recoil.org/projects/ocamllabs">OCaml Labs</a>.  We hadn't quite cracked the problem of how to break the cloud hegemony, but (as with XenoServers and Xen), the pieces that succeeded emerged from the research questions we asked.
However, I don't consider this project permanently closed by any means -- after all, I've been self hosting my email since 1997! We've been working steadily over the past decade of MirageOS (as of 2021) to build out a really solid, self-hosted protocol stack that will work as a unikernel. I am revisiting the question of decentralisation in the form of physical infrastructure in the <a href="https://anil.recoil.org/projects/osmose">Interspatial OS</a> project, and you can read my early thoughts in <a href="https://anil.recoil.org/papers/2018-hotpost-osmose">An architecture for interspatial communication</a>.</p>
<p></p>
</div>


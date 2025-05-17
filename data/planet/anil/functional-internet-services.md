---
title: Functional Internet Services
description:
url: https://anil.recoil.org/projects/melange
date: 2003-01-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<div>
  <h1>Functional Internet Services</h1>
  <p></p><p>My PhD dissertation work proposed an architecture for constructing new implementations of standard Internet protocols with integrated formal methods such as model checking and functional programming that were then not used in deployed servers. A more informal summary is "rewrite all the things in OCaml from C!", which lead to a merry adventure into implementing many networks protocols from scratch in a functional style, and learning lots about how to enforce specifications without using a full blown proof assistant.</p>
<p>In the late 90s while working at MVACS on the Mars Polar Lander, I found myself
using the secure OpenBSD operating system to deploy the self-hosted service
that @nickludlam and I have run together ever since.  I became an OpenBSD
developer with commit rights and went to several hackathons, a sample of which you can read in <a href="https://anil.recoil.org/notes/c2k5-thoughts">OpenBSD C2K5 thoughts</a>. Back then, my primary open source experience was working on C code in the OpenBSD base system and in PHP code while hacking on the  popular <a href="https://horde.org">Horde/IMP</a> groupware system for my own email.</p>
<p>I rapidly tired of hacking in C code and looked for safer alternatives. While
procrastinating over PhD coffee with <a href="https://github.com/djs55" class="contact">Dave Scott</a> he suggested I look into writing
a system daemon in <a href="https://ocaml.org">OCaml</a>. Why not have a go at a SSH server written entirely
in a type-safe functional language?  Being a PhD student sorely in need of a
challenge, I took up the project.</p>
<p>There were a couple of different challenges involved:</p>
<ul>
<li>There was no good way of expressing packet parsing policies for the complex
dynamics of real Internet protocols.  I developed a domain-specific language
for this in OCaml known as <a href="https://github.com/avsm/melange">MPL</a> (the "meta packet language") and used it to
successfully parse DNS, BGP, Ethernet, IP, SSH and a host of other binary
protocols. The work won the best student paper award at EuroSys 2007 in
<a href="https://anil.recoil.org/papers/2007-eurosys-melange">Melange: creating a "functional" internet</a>, and helped to lay the foundation for a growing belief
in industrial circles that C was not the only way to do low-level parsing.</li>
<li>Once parsing was fixed, I also had to express complex state machines using
OCaml. Using a functional language was not a silver bullet to solve this problem
since the state machines still had to be verified against a spec.  I had a first
go at this in <a href="https://anil.recoil.org/papers/sam03-secpol">The Case for Abstracting Security Policies</a> using system call tracing, but decided that was
a dead end due to the poor granularity.  I then designed another domain-specific
language called SPL in <a href="https://anil.recoil.org/papers/2005-hotdep-spl">On the challenge of delivering high-performance, dependable, model-checked internet servers</a> and <a href="https://anil.recoil.org/papers/2005-spin-splat">SPLAT: A Tool for Model-Checking and Dynamically-Enforcing Abstractions</a> and a detailed
writeup in <a href="https://anil.recoil.org/papers/2009-icfem-spl">Combining Static Model Checking with Dynamic Enforcement Using the Statecall Policy Language</a>.  This turned out to be a pretty pragmatic solution
by using model checking and even included an early visual debugger for protocol
state machines.  The work holds up surprisingly well in 2021: while theorem provers
and refinement types based languages like Fstar produce amazing results, they
still require a lot more effort than my simpler model-checking-based solution.</li>
</ul>
<p>All this work resulted in the <a href="https://github.com/avsm/melange">Melange</a> framework
that I put together in OCaml and evaluated, and published in my <a href="https://anil.recoil.org/papers/anil-phd-thesis">Creating high-performance, statically type-safe network applications</a> PhD thesis with the following abstract:</p>
<blockquote>
<p>A typical Internet server finds itself in the middle of a virtual battleground,
under constant threat from worms, viruses and other malware seeking to subvert
the original intentions of the programmer. In particular, critical Internet
servers such as OpenSSH, BIND and Sendmail have had numerous security issues
ranging from low-level buffer overflows to subtle protocol logic errors. These
problems have cost billions of dollars as the growth of the Internet exposes
increasing numbers of computers to electronic malware. Despite the decades of
research on techniques such as model-checking, type-safety and other forms of
formal analysis, the vast majority of server implementations continue to be
written unsafely and informally in C/C++.</p>
<p>In this dissertation we propose an architecture for constructing new
implementations of standard Internet protocols which integrates mature
formal methods not currently used in deployed servers: (i) static type
systems from the ML family of functional languages; (ii) model checking to
verify safety properties exhaustively about aspects of the servers; and (iii)
generative meta-programming to express high-level constraints for the
domain-specific tasks of packet parsing and constructing non-deterministic
state ma- chines. Our architecture -— dubbed MELANGE -— is based on Objective Caml
and contributes two domain-specific languages: (i) the Meta Packet Language
(MPL), a data description language used to describe the wire format of a
protocol and output statically type-safe code to handle network traffic using
high-level functional data structures; and (ii) the Statecall Policy Language
(SPL) for constructing non-deterministic finite state automata which are
embedded into applications and dynamically enforced, or translated into
PROMELA and statically model-checked.  Our research emphasises the importance
of delivering efficient, portable code which is feasible to deploy across the
Internet. We implemented two complex protocols -— SSH and DNS -— to verify our
claims, and our evaluation shows that they perform faster than their standard
counterparts OpenSSH and BIND, in addition to providing static guarantees
against some classes of errors that are currently a major source of security
problems.</p>
</blockquote>
<p>I didn't do much on this immediately after submitting my thesis since I was busy
working on <a href="https://anil.recoil.org/projects/xen">Xen Hypervisor</a> from 2006-2009 or so.  However, the first thing I did when
I quit Citrix was to start the <a href="https://mirageos.org">MirageOS</a> project (the successor to Melange) with
<a href="https://github.com/samoht" class="contact">Thomas Gazagnaire</a> and <a href="https://github.com/djs55" class="contact">Dave Scott</a> in order to develop better personal data infrastructure with
<a href="https://anil.recoil.org/projects/perscon">Personal Containers</a>. This formed the foundation for my subsequent research into library
operating systems and the concept of <a href="https://anil.recoil.org/projects/unikernels">Unikernels</a>.
Read more about the subsequent work
there, or sample <a href="https://anil.recoil.org/papers/2010-hotcloud-lamp">Turning Down the LAMP: Software Specialisation for the Cloud</a> to get a taster of the direction
Melange evolved in.</p>
<p>Reflecting on my PhD research in 2021, I think that it
was a pretty good piece of systems research. It didn't make any deep contributions
to formal verification or programming language research, but it did posit a clear
systems thesis and implement and evaluate it without a huge team being involved.
That's more difficult to do these days in the era of large industrial research
teams dominating the major conferences, but certainly not impossible.</p>
<p>Choosing a good topic for systems research is crucial, since the context you do
the research in is as important as the results you come up with. Much of my subsequent
career has been influenced by the "crazy challenge" that <a href="https://github.com/djs55" class="contact">Dave Scott</a> set me back in 2003
to do systems programming in a functional language, with all the intellectual and
engineering challenges that came along with that extreme (back in 2003) position.</p>
<p></p>
</div>


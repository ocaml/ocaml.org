---
title: Visiting the camels - MirageOS spring hack retreat 2018
description:
url: https://mirage.io/blog/2018-visiting-the-camels
date: 2018-04-20T00:00:00-00:00
preview_image:
featured:
authors:
- Stefanie Schirmer
---


        <p>Original posted on <a href="https://linse.me/2018/04/20/Visiting-the-camels.html">linse's blog</a>.</p>
<p><img src="https://upload.wikimedia.org/wikipedia/commons/7/7f/Maroc_Marrakech_Jemaa-el-Fna_Luc_Viatour.JPG" alt="Jemaa El Fnaa"/>
Image by Luc Viatour / https://Lucnix.be</p>
<p>In March 2018, I attended my first <a href="http://retreat.mirage.io/">MirageOS hack retreat</a> in Morrocco.
<a href="https://mirage.io/">MirageOS</a> is a library operating system which allows everyone to build very small, specialized operating system kernels that are intended to run directly on the virtualization layer.
The application code itself is the guest operating system kernel, and can be deployed at scale without the need for an extra containerization step in between.
It is written in <a href="https://ocaml.org/learn/description.html">OCaml</a> and each kernel is built only with exactly the code that is necessary for the particular application.
A pretty different approach from traditional operating systems. Linux feels <a href="https://www.linuxcounter.net/statistics/kernel">huge</a> all of a sudden.</p>
<p>I flew in from New York via Casablanca to Marrakesh, and then took a cab to the city center, to the main square, <a href="https://en.wikipedia.org/wiki/Jemaa_el-Fnaa">Jemaa El Fnaa</a>.
At Cafe de France, Hannes was picking me up and we walked back through the labyrinth of the Medina to the hostel Riad &quot;Priscilla&quot; where we lived with about 20 MirageOS folks, two <a href="https://www.instagram.com/p/BgPaVbuD3Y3/?taken-by=l1ns3">turtles</a> and a dog.
We ate some food, and there were talks about Mirage's quickcheck-style fuzzing library <a href="https://github.com/stedolan/crowbar">Crowbar</a>, and an API realized on top of a message queue written in OCaml.</p>
<p>Coming from compiler construction in Haskell and building &quot;stateless&quot; services for information retrieval in Scala, I have a good grasp of functional programming. The funny problem is I don't know much about OCaml yet.</p>
<p>At Etsy, I was part of the Core Platform team where we first <a href="https://www.youtube.com/watch?v=75j1RRxxARI">used hhvm</a> (Facebook's hip-hop virtual machine) on the API cluster, and then advocated to use their gradually typed <a href="http://hacklang.org/">&quot;hack&quot; language</a> to introduce typing to the gigantic PHP codebase at Etsy. Dan Miller and I added types to the codebase with Facebook's <a href="https://docs.hhvm.com/hack/tools/hackificator"><code>hackificator</code></a>, but then
PHP 7 added the possibility of type annotations and great speedups, and PHP's own static analyzer <a href="https://github.com/phan/phan"><code>phan</code></a> was developed by Rasmus Lerdorf and Andrew Morrison to work with PHP's types.
We abandoned the hackification approach.
Why is this interesting? These were my first encounters with OCaml! The <a href="https://docs.hhvm.com/hack/typechecker/introduction">hack typechecker</a> is written in OCaml, and Dan and I have read it to understand the gradual typing approach.
Also, we played with <a href="https://github.com/facebook/pfff/wiki/Main"><code>pfff</code></a>, a tool written in OCaml that allows structural edits on PHP programs, based on the abstact syntax tree.
I made a list to translate between Haskell and OCaml syntax, and later Maggie Zhou and I used <code>pfff</code> to <a href="https://codeascraft.com/author/sschirmer/">unify</a> the syntax of several hundred endpoints in Etsy's internal API.</p>
<p>At the MirageOS retreat, I started my week reading <a href="https://dev.realworldocaml.org/">&quot;Real World OCaml&quot;</a>, but got stuck because the examples did not work with the buildsystem used in the book. Stephen helped me to find a workaround, I made a PR to the book but it was closed since it is a temporary problem. Also, I started reading about OCaml's <a href="https://mirage.io/docs/tutorial-lwt">&quot;lwt&quot; library</a> for concurrent programming. The abbreviation stands for lightweight threads and the library provides a monadic way to do multithreading, really similar to <a href="https://twitter.github.io/util/docs/com/twitter/util/Future.html">twitter futures</a> in Scala. Asynchronous calls can be made in a thread, which then returns at some point when the call was successful or failed. We can  do operations &quot;inside&quot; lwt with bind (<code>&gt;&gt;=</code>) in the same way we can flatMap over Futures in scala. The library also provides ways to run multiple threads in sequence or in parallel, and to block and wait.
In the evening, there was a talk about a <a href="https://github.com/cfcs/mirage-ocra-demo">high-end smart card</a> that based on a private start value can provide a succession of keys. The hardware is interesting, being the size of a credit card it has a small keypad and a screen. Some banks use these cards already (for their TAN system?), and we all got a sample card to play with.</p>
<p>One day I went swimming with Lix and Reynir, which was quite the adventure since the swimming pool was closed and we were not sure what to do. We still made it to the part that was still open, swam a lot and then got a cake for Hannes birthday which lead to a cake overflow since there were multiple cakes and an awesome party with candles, food and live music already. :D Thanks everyone for organizing!! Happy birthday Hannes!</p>
<p>I started reading another book, <a href="http://ocaml-book.com/">&quot;OCaml from the very beginning&quot;</a>, and working through it with Kugg. This book was more focused on algorithms and the language itself than on tooling and libraries, and the exercises were really fun to solve. Fire up OCaml's REPL <a href="https://github.com/diml/utop"><code>utop</code></a> and go! :D</p>
<p>At the same time I started reading the code for <a href="https://github.com/solo5/solo5">solo5</a> to get an understanding of the underlying hypervisor abstraction layer and the backends we compile to. This code is really a pleasure to read.
It is called solo5 because of MirageOS's system calls, initially a set of 5 calls to the hypervisor, called hypercalls which sounds really futuristic. :D</p>
<p>So that's the other fun problem: I don't know too much about kernel programming yet. I did the <a href="http://eudyptula-challenge.org/">Eudyptula (Linux kernel) challenge</a>, an email-based challenge that sends you programming quests to learn about kernel programming.
Over the course of the challenge, I've made my own Linux kernel module that says &quot;Hello world!&quot; but I have not built anything serious yet.</p>
<p>The next things I learned were <a href="https://mirage.io/docs/hello-world">configuring and compiling</a> a MirageOS unikernel. Hannes showed me how this works.
The config system is powerful and can be tailored to the unikernel we are about to build, via a config file.
After configuring the build, we can build the kernel for a target backend of our choice. I started out with compiling to Unix, which means all network calls go through unix pipes and the unikernel runs as a simple unix binary in my host system, which is really useful for testing.</p>
<p>The next way to run MirageOS that I tried was running it in ukvm. For this setup you have to change the networking approach so that you can talk from the host system to you unikernel inside ukvm. In Linux you can use the Tun/Tap loopback interface for networking to wire up this connection.</p>
<p>We had a session with <a href="https://hackingwithcare.in/about-2/">Jeremie</a> about our vision for MirageOS which was super fun, and very interesting because people have all kinds of different backgrounds but the goals are still very aligned.</p>
<p>Another thing I learned was how to look at network traffic with <a href="https://www.wireshark.org/">wireshark</a>. <a href="https://s4y.us/">Sidney</a> and I had previously recorded a TLS handshake with tcpdump and looked at the binary data in the pcap file with &quot;hexfiend&quot; next to Wikipedia to decode what we saw.
Derpeter gave me a nice introduction about how to do this with wireshark, which knows about most protocols already and will do the decoding of the fields for us. We talked about all layers of the usual stack, other kinds of internet protocols, the iptables flow, and bgp / <a href="https://www.peeringdb.com/net/12276">peeringDB</a>. Quite interesting and I feel I have a pretty good foundational understanding about how the internet actually works now.</p>
<p>During the last days I wanted to write a unikernel that does something new, and I thought about monitoring, as there is no monitoring for MirageOS yet. I set up a <a href="https://grafana.com/">grafana</a> on my computer and sent some simple data packets to grafana from a unikernel, producing little peaks in a test graph. Reynir and I played with this a bit and restructured the program.</p>
<p>After this, the week was over, I walked back to Jemaa el Fnaa with Jeremie, I feel I learned a ton and yet am still at the very beginning, excited what to build next. On the way back I got stuck in a weird hotel in Casablanca due to the flight being cancelled, where I bumped into a Moroccan wedding and met some awesome travelling women from Brazil and the US who also got stuck. All in all a fun adventure!</p>
<p><img src="https://scontent-frt3-2.cdninstagram.com/vp/b7383ad87744d99eae8940b38789fc94/5B58DFFC/t51.2885-15/e35/28764104_231320117439563_2956918922680467456_n.jpg" alt=""/></p>

      

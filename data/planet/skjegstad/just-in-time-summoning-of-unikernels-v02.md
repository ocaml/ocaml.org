---
title: Just-in-Time Summoning of Unikernels (v0.2)
description:
url: http://www.skjegstad.com/blog/2015/08/17/jitsu-v02/
date: 2015-08-16T23:00:00-00:00
preview_image:
featured:
authors:
- Magnus Skjegstad
---

<p><a href="https://github.com/mirage/jitsu.git">Jitsu</a> - or Just-in-Time Summoning of Unikernels - is a prototype DNS server that can boot virtual machines on demand. When Jitsu receives a DNS query, a virtual machine is booted automatically before the query response is sent back to the client. If the virtual machine is a <a href="http://queue.acm.org/detail.cfm?id=2566628">unikernel</a>, it can boot in milliseconds and be available as soon as the client receives the response. To the client it will look like it was on the whole time. </p>
<p>Jitsu can be used to run microservices that only exist after they have been resolved in DNS - and perhaps in the future can facilitate <a href="http://amirchaudhry.com/heroku-for-unikernels-pt2/">demand-driven clouds</a> or extreme scaling with <a href="http://www.skjegstad.com/blog/2015/03/25/mirageos-vm-per-url-experiment/">a unikernel per URL</a>. Jitsu has also been used to boot unikernels in milliseconds on <a href="https://www.usenix.org/system/files/conference/nsdi15/nsdi15-paper-madhavapeddy.pdf">ARM devices</a>.</p>
<p>A new version of Jitsu was just released and I'll summarize some of the old and new features here. This is the first version that supports both <a href="https://mirage.io">MirageOS</a> and <a href="https://github.com/rumpkernel/rumprun">Rumprun</a> unikernels and uses the distributed <a href="https://github.com/mirage/irmin">Irmin</a> database to store state. A full list of changes is available <a href="https://github.com/mirage/jitsu/blob/master/CHANGES.md">here</a>.</p>


<p>A Jitsu demo hosting a MirageOS unikernel runs <a href="http://www.jitsu.v0.no">here</a> and nginx on Rumprun <a href="http://www.rump.jitsu.v0.no">here</a>. These demos should be up most of the time, but may occasionally be unstable or unavailable as they are also used to test new features. </p>
<p>For more technical details and up to date example configurations with MirageOS and Rumprun, see the Jitsu <a href="https://github.com/mirage/jitsu/blob/master/README.md">README</a>.</p>
<h3>Overview</h3>
<ul>
<li><a href="http://www.skjegstad.com/feeds/ocaml.tag.atom.xml#how-it-works">How it works</a></li>
<li><a href="http://www.skjegstad.com/feeds/ocaml.tag.atom.xml#masking-boot-delays">Masking boot delays</a><ul>
<li><a href="http://www.skjegstad.com/feeds/ocaml.tag.atom.xml#synjitsu">Synjitsu</a></li>
</ul>
</li>
<li><a href="http://www.skjegstad.com/feeds/ocaml.tag.atom.xml#irmin-and-jitsu">Irmin and Jitsu</a></li>
<li><a href="http://www.skjegstad.com/feeds/ocaml.tag.atom.xml#new-backends">New backends</a></li>
<li><a href="http://www.skjegstad.com/feeds/ocaml.tag.atom.xml#tell-me-more-about-unikernels">Tell me more!</a></li>
</ul>
<h2>How it works</h2>
<p>The following figure shows what happens when Jitsu receives a DNS query for a unikernel that is not currently running.</p>
<p><img src="http://www.skjegstad.com/images/blog/jitsu/jitsu_mirage.jpg" alt="Jitsu"/></p>
<p>First, the client sends a DNS request to Jitsu. The request is received and checked against a list of domains mapped to unikernels. If there is a match, Jitsu boots the corresponding unikernel VM. When the unikernel has started booting, Jitsu sends a DNS reply to the client containing the future IP address of the unikernel. When the DNS response is received by the client it initiates a TCP connection to the IP address in the DNS response.</p>
<p>Each DNS reply from Jitsu contains a time-to-live (TTL) value that tells the client for how long the reply is valid. This is a feature built into DNS that allows query results to be cached by the client or by other name servers. When the TTL expires, the client will have to send a new DNS query to Jitsu to verify that a cached response still correct. By using low TTL values (typically less than an hour), Jitsu can keep track of how often a unikernel is used and may automatically stop unikernels that have not been requested within a certain time period. By default, unikernels are stopped after 2 x TTL timeout.</p>
<h2>Masking boot delays</h2>
<p>When Jitsu boots a unikernel and returns the DNS response there is a race between the client and the unikernel. The unikernel has to be able to respond to a TCP request within the time it takes to send the DNS reponse back to the client and for the client to attempt to connect. What happens if the unikernel is unable to complete its boot process in time?</p>
<p>The problem is illustrated in this figure:</p>
<p><img src="http://www.skjegstad.com/images/blog/jitsu/jitsu_nosynjitsu.jpg" alt="Jitsu without Synjitsu"/></p>
<p>After being booted by Jitsu, the unikernel has about 1 round-trip-time (RTT) to finish booting. This is the time it takes for the DNS query to go back to the client and for the TCP handshake to be initiated with a SYN packet. For example, the typical boot time of a MirageOS unikernel on ARM is about 3-400 ms. It is then likely that the unikernel will not be ready in time and that the first SYN packet is lost. TCP is able to recover by retransmitting the SYN packet, but it requires a timeout and a retransmit. With <a href="https://tools.ietf.org/html/rfc6298">recommended timeout values</a> it will take a second or longer for the client to finally connect.</p>
<p>To mask this delay and avoid the SYN retransmission, Jitsu now supports three alternative mechanisms:</p>
<ul>
<li>Delay the DNS response by a fixed timeout (e.g. 150-200 ms) to let the unikernel complete the boot process</li>
<li>Wait for the unikernel to signal Jitsu before sending the DNS response</li>
<li>Cache the incoming SYN packet on behalf of the unikernel with <a href="https://github.com/mirage/synjitsu">Synjitsu</a></li>
</ul>
<p>The simplest solution to set up is the fixed delay. Depending on the application, a delay of a few hundred milliseconds may be acceptable to the client. For a web application for example, this may not be noticeable. This mechanism does not require modifications to the unikernel itself. The downside is that the delay is fixed, so even if the unikernel starts faster than expected there will still be a delay for the client.</p>
<p>A more dynamic approach is to let the unikernel notify Jitsu when it is ready. This is currently done by waiting for a key to appear in <a href="http://wiki.xen.org/wiki/XenStore">Xenstore</a>, Xen's shared information store. To write the key the unikernel only needs a working Xenstore client implementation. Jitsu will watch Xenstore and immediately send the DNS response when the key appears. While more dynamic, this mechanism doesn't allow Jitsu to send the DNS reply while the unikernel is booting - making the delay longer than necessary.</p>
<p>To be able to use both a dynamic delay and send the response back while the unikernel is booting, Jitsu has support for running a separate unikernel service that caches incoming SYNs until the unikernel is ready. We call this Synjitsu.</p>
<h3>Synjitsu</h3>
<p><a href="https://github.com/samoht/synjitsu">Synjitsu</a> is a unikernel service that handles TCP connections on behalf of unikernels that are completing their boot process. Synjitsu is always running and captures TCP SYN packets that appear on the network bridge that don't have a matching unikernel yet. The SYNs are then stored in the Xenstore database. When a new unikernel has booted it will check for cached SYNs that matches its MAC- and IP-address in Xenstore. Every SYN it finds will then be processed as if it was received over the network and trigger a SYN/ACK to complete the TCP <a href="http://en.wikipedia.org/wiki/Transmission_Control_Protocol#Connection_establishment">three way handshake</a>. 
When the unikernel has finished booting all incoming SYNs are ignored by Synjitsu and go directly to the unikernel as regular network traffic.</p>
<p><img src="http://www.skjegstad.com/images/blog/jitsu/synjitsu_mirage.jpg" alt=""/></p>
<p>The process is shown above. A DNS query has already been sent to Jitsu DNS, a unikernel has been booted and a reply sent back to the client. The client now attempts to send a TCP SYN packet to initiate the TCP connection. Unfortunately, the unikernel is not ready yet and would be unable to reply. Synjitsu then silently stores the SYN for the remaining milliseconds while the unikernel completes its boot process. When the unikernel is ready it will retrieve the SYN and send a SYN/ACK back to the client. </p>
<p>For Synjitsu to work properly we also have to handle <a href="http://en.wikipedia.org/wiki/Address_Resolution_Protocol">ARP</a> traffic. ARP is used to find the MAC address that matches an IP address on the local network. Before the incoming TCP SYN can reach its destination, the router (usually the local gateway) has to know the MAC address it should be sent to. As the unikernel is still booting it is unable to announce its address and IP - in fact the IP is not really in use yet. To compensate for this, Jitsu will tell Synjitsu the MAC- and IP-address of every unikernel that is currently booting. Synjitsu then sends <a href="http://en.wikipedia.org/wiki/Address_Resolution_Protocol#ARP_announcements">gratuitous ARP</a> packets to announce to the network that it is handling the specified MAC and IP for now. As soon as the real unikernel finishes booting it sends its own gratuitous ARP packet to notify the network that it is ready. </p>
<p><em>Synjitsu is currently a highly experimental feature and requires a modified MirageOS TCP/IP stack. For more information about running Synjitsu, see <a href="https://www.usenix.org/system/files/conference/nsdi15/nsdi15-paper-madhavapeddy.pdf">our paper</a> or ask on the <a href="http://lists.xenproject.org/cgi-bin/mailman/listinfo/mirageos-devel">mailing list</a>. The source code is available <a href="https://github.com/mirage/synjitsu">here</a>.</em></p>
<h2>Irmin and Jitsu</h2>
<p><a href="https://github.com/mirage/irmin">Irmin</a> is a distributed database with git-like features, such as a full history of changes and support for branching and merging. Jitsu's internal state is now stored in an Irmin database which can be inspected using the Irmin tool. The database used to store the state of the demonstration is shown below.</p>
<div class="highlight"><pre><span class="nv">$ </span>irmin tree
/jitsu/vm/1ca...b60/config/disk/0.........................<span class="s2">&quot;/dev/loop5@xvda&quot;</span>
/jitsu/vm/1ca...b60/config/disk/1.........................<span class="s2">&quot;/dev/loop6@xvdb&quot;</span>
/jitsu/vm/1ca...b60/config/dns/0.....................<span class="s2">&quot;www.rump.jitsu.v0.no&quot;</span>
/jitsu/vm/1ca...b60/config/ip/0.............................<span class="s2">&quot;89.16.190.215&quot;</span>
/jitsu/vm/1ca...b60/config/kernel/0.............................<span class="s2">&quot;nginx.bin&quot;</span>
/jitsu/vm/1ca...b60/config/memory/0.................................<span class="s2">&quot;64000&quot;</span>
/jitsu/vm/1ca...b60/config/name/0.................................<span class="s2">&quot;rump-xl&quot;</span>
/jitsu/vm/1ca...b60/config/nic/0......................................<span class="s2">&quot;br0&quot;</span>
/jitsu/vm/1ca...b60/config/response_delay/0...........................<span class="s2">&quot;0.9&quot;</span>
/jitsu/vm/1ca...b60/config/rumprun_config/0......................<span class="s2">&quot;json.cfg&quot;</span>
/jitsu/vm/1ca...b60/dns/www.rump.jitsu.v0.no/ttl.......................<span class="s2">&quot;60&quot;</span>
/jitsu/vm/1ca...b60/ip......................................<span class="s2">&quot;89.16.190.215&quot;</span>
/jitsu/vm/1ca...b60/response_delay....................................<span class="s2">&quot;0.1&quot;</span>
/jitsu/vm/1ca...b60/stop_mode.....................................<span class="s2">&quot;destroy&quot;</span>
/jitsu/vm/1ca...b60/use_synjitsu....................................<span class="s2">&quot;false&quot;</span>
/jitsu/vm/de4...ad3/config/dns/0..........................<span class="s2">&quot;www.jitsu.v0.no&quot;</span>
/jitsu/vm/de4...ad3/config/ip/0.............................<span class="s2">&quot;89.16.190.214&quot;</span>
/jitsu/vm/de4...ad3/config/kernel/0...........................<span class="s2">&quot;mir-www.xen&quot;</span>
/jitsu/vm/de4...ad3/config/memory/0.................................<span class="s2">&quot;64000&quot;</span>
/jitsu/vm/de4...ad3/config/name/0..................................<span class="s2">&quot;www-xl&quot;</span>
/jitsu/vm/de4...ad3/config/nic/0......................................<span class="s2">&quot;br0&quot;</span>
/jitsu/vm/de4...ad3/config/response_delay/0...........................<span class="s2">&quot;0.1&quot;</span>
/jitsu/vm/de4...ad3/config/wait_for_key/0.....................<span class="s2">&quot;data/status&quot;</span>
/jitsu/vm/de4...ad3/dns/www.jitsu.v0.no/ttl............................<span class="s2">&quot;60&quot;</span>
/jitsu/vm/de4...ad3/ip......................................<span class="s2">&quot;89.16.190.214&quot;</span>
/jitsu/vm/de4...ad3/response_delay....................................<span class="s2">&quot;0.1&quot;</span>
/jitsu/vm/de4...ad3/stop_mode.....................................<span class="s2">&quot;destroy&quot;</span>
/jitsu/vm/de4...ad3/use_synjitsu....................................<span class="s2">&quot;false&quot;</span>
/jitsu/vm/de4...ad3/wait_for_key..............................<span class="s2">&quot;data/status&quot;</span>
</pre></div>


<p>The Jitsu database is currently read only, but in the future the plan is to allow clients to create their own branch of the database, perform changes and then merge with Jitsu's master branch. This can then be used to control Jitsu while it is running and may, for example, allow unikernels to modify their own boot- and DNS configuration. The Irmin database will also make it easier to split Jitsu into smaller components that cooperate and allow some features to run within separate unikernels (e.g. DNS).</p>
<h2>New backends</h2>
<p>Jitsu v0.2 includes support for several backends that can be used to manage the unikernel VMs. The original libvirt backend is still used by default, but libxl and XAPI are also supported (but not as well tested). If you encounter problems with the new backends, please report them <a href="https://github.com/mirage/jitsu/issues">here</a>.</p>
<h2>Tell me more!</h2>
<p>This post has mainly focused on Jitsu, but if you are interested in unikernels and want more information about writing your own or hosting your web site with one, these links may be useful:</p>
<ul>
<li><a href="http://openmirage.org/wiki/hello-world">Hello Mirage World</a> describes how to create and compile a simple &quot;Hello world&quot; unikernel.</li>
<li>In <a href="http://roscidus.com/blog/blog/2014/07/28/my-first-unikernel/">My first unikernel</a>, Thomas Leonard describes how he set up a MirageOS REST service with a storage backend.</li>
<li>Mindy Preston has documented how she runs her blog as a unikernel with Amazon EC2 in <a href="http://www.somerandomidiot.com/blog/2014/08/19/i-am-unikernel/">I Am Unikernel! (and So Can You!)</a>. </li>
<li><a href="http://amirchaudhry.com/from-jekyll-to-unikernel-in-fifty-lines/">From Jekyll site to Unikernel in fifty lines of code</a></li>
<li><a href="https://github.com/rumpkernel/wiki/wiki/Tutorial:-Serve-a-static-website-as-a-Unikernel">Tutorial: Serve a static website as a Unikernel</a> explains how to run an nginx server in a Rumprun unikernel.</li>
</ul>
<p>There are also many MirageOS application examples available <a href="https://github.com/mirage/mirage-skeleton">here</a>. The examples are kept up to date with the latest libraries.</p>
<p>If you experiment with Jitsu, please let us know how it went on the <a href="http://lists.xenproject.org/cgi-bin/mailman/listinfo/mirageos-devel">mailing list</a>!</p>
<p>(Thanks to Daniel B&uuml;nzli and Amir Chaudhry for comments on previous versions of this post)</p>

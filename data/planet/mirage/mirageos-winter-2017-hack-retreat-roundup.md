---
title: MirageOS Winter 2017 hack retreat roundup
description:
url: https://mirage.io/blog/2017-winter-hackathon-roundup
date: 2017-12-23T00:00:00-00:00
preview_image:
featured:
authors:
- Hannes Mehnert
---


        <p>This winter, 33 people from around the world gathered in Marrakesh for a Mirage hack retreat. This is fast becoming a <a href="https://mirage.io/blog/2016-spring-hackathon">MirageOS</a> <a href="https://mirage.io/blog/2017-march-hackathon-roundup">tradition</a>, and we're a little sad that it's over already! We've collected some trip reports from those who attended the 2017 winter hack retreat, and we'd like to thank our amazing hosts, organisers and everyone who took the time to write up their experiences.
<img src="https://mirage.io/graphics/winter2017.jpg" style="float:right; padding: 15px"/></p>
<p>We, the MirageOS community, strongly believe in using our own software: this website has been a unikernel since day one^W^W it was possible to run MirageOS unikernels.  In Marrakesh we used our own DHCP and DNS server without trouble.  There are many more services under heavy development (including git, ssh, ...), which we're looking forward to using soon ourselves.</p>
<p>Several atteendees joined for the second or third time in Marrakesh, and brought their own projects, spanning over <a href="https://github.com/andreas/ocaml-graphql-server">graphql</a>, <a href="https://reproducible-builds.org/">reproducible builds</a> (with application to <a href="https://github.com/talex5/qubes-mirage-firewall">qubes-mirage-firewall</a>, see <a href="http://layer-acht.org/thinking/blog/20171204-qubes-mirage-firewall/">holger's report</a> and <a href="https://github.com/ocaml/ocaml/pull/1515">Gabriel's OCaml fixes for build path variation</a>).  A stream of improving error messages in the OCaml compiler (based on <a href="https://github.com/ocaml/ocaml/pull/102">Arthur Chargu&eacute;raud PR</a>) was prepared and merged (<a href="https://github.com/ocaml/ocaml/pull/1496">PR 1496</a>, <a href="https://github.com/ocaml/ocaml/pull/1501">PR 1501</a>, <a href="https://github.com/ocaml/ocaml/pull/1505">PR 1505</a>, <a href="https://github.com/ocaml/ocaml/pull/1510">PR 1510</a>, and <a href="https://github.com/ocaml/ocaml/pull/1534">PR 1534</a>).  Our OCaml <a href="https://github.com/mirage/ocaml-git/">git implementation</a> was rewritten to support git push properly, and this PR was <a href="https://github.com/mirage/ocaml-git/pull/227">merged</a>.  Other projects of interest are <a href="https://github.com/haesbaert/awa-ssh">awa-ssh</a>, <a href="https://github.com/mirage/charrua-core/pull/76">anonymity profiles in DHCP</a>, and fixes to the deployment troubles of <a href="https://github.com/mirage/mirage-www">our website</a>.  There is now a <a href="https://github.com/cfcs/eye-of-mirage">mirage PNG viewer integrated into Qubes</a> and a <a href="https://github.com/cfcs/passmenage">password manager</a>.  Some <a href="https://github.com/juga0/mirage_mar2017">getting started notes</a> were written down as well as the new <a href="https://mirage.io/docs/learning">learning about MirageOS</a> website.</p>
<p>A huge fraction of the <a href="https://github.com/solo5/solo5">Solo5 contributors</a> gathered in Marrakesh as well and discussed the future, including terminology, the project scope, and outlined a roadmap for merging branches in various states.  Adrian from the <a href="https://muen.sk">Muen</a> project joined the discussion, and in the aftermath they are now running their website using MirageOS on top of the Muen separation kernel.</p>
<p>A complete list of fixes and discussions is not available, please bear with us if we forgot anything above.  A sneak preview: there will be <a href="http://retreat.mirage.io">another retreat in March 2018</a> in Marrakesh.  Following are texts written by individual participants about their experience.</p>
<h2>Mindy Preston</h2>
<p>I came to Marrakesh for the hack retreat with one goal in mind: documentation.  I was very pleased to discover that <a href="https://github.com/mk270">Martin Keegan</a> had come with the same goal in mind and fresher eyes, and so I had some time to relax, enjoy Priscilla and the sun, photograph some cats, and chat about projects both past and future.  In particular, I was really pleased that there's continued interest in building on some of the projects I've worked on at previous hack retreats.</p>
<p>On the way to the first hack retreat, I did some work applying <a href="https://github.com/stedolan">Stephen Dolan's</a> then-experimental <a href="http://lcamtuf.coredump.cx">American Fuzzy Lop</a> instrumentation to testing the <a href="https://github.com/mirage/mirage-tcpip">mirage-tcpip</a> library via <a href="https://github.com/yomimono/mirage-net-pcap">mirage-net-pcap</a>. (A post on this was <a href="http://canopy.mirage.io/Projects/Fuzzing">one of the first Canopy entries!</a>  At this hack retreat, I did a short presentation on the current state of this work:</p>
<ul>
<li>AFL instrumentation was released in OCaml 4.05; switches with it enabled by default are available in opam (<code>opam sw 4.05.0+afl</code>)
</li>
<li><a href="https://github.com/stedolan/crowbar">crowbar</a> for writing generative tests powered by AFL, with an <a href="https://github.com/stedolan/crowbar/tree/staging">experimental staging branch</a> that shows OCaml code for regenerating failing test cases
</li>
<li>a <a href="https://github.com/yomimono/ppx_deriving_crowbar">companion ppx_deriving</a> plugin for automatic generator discovery based on type definitions
</li>
<li><a href="https://github.com/yomimono/ocaml-bun">bun</a>, for integrating afl tests into CI runs
</li>
</ul>
<p>I was lucky to have a lot of discussions about fuzzing in OCaml, some of which inspired further work and suggestions on <a href="https://github.com/stedolan/crowbar/issues/7">some current problems in Crowbar</a>.  (Special thanks to <a href="https://github.com/gasche">gasche</a> and <a href="https://github.com/armael">armael</a> for their help there!)  I'm also grateful to <a href="https://github.com/aantron">aantron</a> for some discussions on ppx_bisect motivated by an attempt to estimate coverage for this testing workflow.  I was prodded into trying to get Crowbar ready to release by these conversations, and wrote a lot of docstrings and an actual README for the project.</p>
<p><a href="https://github.com/juga0">juga0</a> added some extensions to the <a href="https://github.com/mirage/charrua-core">charrua-core DHCP library</a> started by <a href="https://github.com/haesbaert">Christiano Haesbaert</a> a few hack retreats ago.  juga0 wanted to add some features to support <a href="https://tools.ietf.org/html/rfc7844.html">more anonymity for DHCP clients</a>, so we did some associated work on the <a href="https://github.com/haesbaert/rawlink">rawlink</a> library, and added an experimental Linux DHCP client for charrua-core itself.  I got to write a lot of docstrings for this library!</p>
<p>I was also very excited to see the work that <a href="https://github.com/cfcs">cfcs</a> has been doing on building more interesting MirageOS unikernels for use in QubesOS.  I had seen static screenshots of <a href="https://github.com/cfcs/mirage-framebuffer">mirage-framebuffer</a> in action which didn't do it justice at all; seeing it in person (including self-hosted slides!) was really cool, and inspired me to think about how to fix <a href="https://discuss.ocaml.org/t/mirageos-parametric-compilation-depending-on-target/1005/12">some ugliness in writing unikernels using the framebuffer</a>. The <a href="https://github.com/cfcs/passmenage">experimental password manager</a> is something I hope to be using by the next hack retreat.  Maybe 2017 really is <a href="https://mirage.io/blog/qubes-target">the year of unikernels on the desktop</a>!</p>
<p>tg, hannes, halfdan, samoht, and several others (sorry if I missed you!) worked hard to get some unikernel infrastructure up and running at Priscilla, including homegrown DHCP and DNS services, self-hosted pastebin and etherpad, an FTP server for blazing-fast local filesharing, and (maybe most importantly!) a local <code>opam</code> mirror.  I hope that in future hack retreats, we can set up a local <code>git</code> server using the <a href="https://github.com/mirage/ocaml-git">OCaml git implementation</a>, which got some major improvements during the hack retreat thanks to dinosaure (from the other side of the world!) and samoht.</p>
<p>Finally, the <a href="https://github.com/talex5/qubes-mirage-firewall">qubes-mirage-firewall</a> got a lot of attention this hack retreat.  (The firewall itself incorporates some past hack retreat work by me and talex5.)  h01ger worked on the <a href="http://layer-acht.org/thinking/blog/20171204-qubes-mirage-firewall/">reproducibility of the build</a>, and cfcs did some work on passing ruleset changes to the firewall -- currently, users of qubes-mirage-firewall need to rebuild the unikernel with ruleset changes.</p>
<p>We also uncovered some strangeness and bugs in the <a href="https://github.com/mirage/mirage/pull/874">handling of Xen block-storage devices</a>, which I was happy to fix in advance of the more intense use of block storage I expect with <a href="https://github.com/g2p/wodan">wodan</a> and <a href="https://github.com/mirage/irmin">irmin</a> in the near future.</p>
<h2>Oh yes, and somewhere in there, I did find time to see some cats, eat tajine, wander around the medina, and enjoy all of the wonder that <a href="http://queenofthemedina.com">Priscilla, the Queen of the Medina</a> and her lovely hosts have to offer.  Thanks to everyone who did the hard work of organizing, feeding, and laundering this group of itinerant hackers!</h2>
<h2>Ximin Luo</h2>
<p>This was my third MirageOS hack retreat, I continued right where I left off last time.</p>
<p>I've had a pet project for a while to develop a end-to-end secure protocol for group messaging. One of its themes is to completely separate the transport and application layers, by sticking an end-to-end secure session layer in between them, with the aim of unifying all the <em>secure messaging</em> protocols that exist today. Like many pet projects, I haven't had much time to work on it recently, and took the chance to this week.</p>
<p>I worked on implementing a consistency checker for the protocol. This allows chat members to verify everyone is seeing and has seen the same messages, and to distinguish between other members being silent (not sending anything) vs the transport layer dropping packets (either accidentally or maliciously). This is built on top of my as-yet-unreleased pure library for setting timeouts, monitors (scheduled tasks) and expectations (promises that can timeout), which I worked on in the previous hackathons.</p>
<p>I also wrote small libraries for doing 3-valued and 4-valued logic, useful for implementing complex control flows where one has to represent different control states like <code>success</code>, <code>unknown/pending</code>, <code>temporary failure</code>, <code>permanent failure</code>, and be able to compose these states in a logically coherent way.</p>
<p>For my day-to-day work I work on the <a href="https://reproducible-builds.org/">Reproducible Builds</a>, and as part of this we write patches and/or give advice to compilers on how to generate output deterministically. I showed Gabriel Scherer our testing framework with our results for various ocaml libraries, and we saw that the main remaining issue is that the build process embeds absolute paths into the output. I explained our <code>BUILD_PATH_PREFIX_MAP</code> mechanism for stripping this information without negatively impacting the build result, and he implemented this for the ocaml compiler. It works for findlib! Then, I need to run some wider tests to see the overall effect on all ocaml packages. Some of the non-reproducibility is due to GCC and/or GAS, and more analysis is needed to distinguish these cases.</p>
<p>I had very enjoyable chats with Anton Bachin about continuation-passing style, call-cc, coroutines, and lwt; and with Gabriel Scherer about formal methods, proof systems, and type systems.</p>
<p>For fun times I carried on the previous event's tradition of playing Cambio, teaching it to at least half of other people here who all seemed to enjoy it very much! I also organised a few mini walks to places a bit further out of the way, like Gueliz and the Henna Art Cafe.</p>
<p>On the almost-last day, I decided to submerge myself in the souks at 9am or so and explored it well enough to hopefully never get lost in there ever again! The existing data on OpenStreetMap for the souks is actually er, <em>topologically accurate</em> shall we say, except missing some side streets. :)</p>
<h2>All-in-all this was another enjoyable event and it was good to be back in a place with nice weather and tasty food!</h2>
<h2>Martin Keegan</h2>
<p>My focus at the retreat was on working out how to improve the documentation.
This decomposed into</p>
<ul>
<li>encouraging people to fix the build for the docs system
</li>
<li>talking to people to find out what the current state of Mirage is
</li>
<li>actually writing some material and getting it merged
</li>
</ul>
<p>What I learnt was</p>
<ul>
<li>which backends are in practice actually usable today
</li>
<li>the current best example unikernels
</li>
<li>who can actually get stuff done
</li>
<li>how the central configuration machinery of <code>mirage configure</code> works today
</li>
<li>what protocols and libraries are currently at the coal-face
</li>
<li>that some important documentation exists in the form of blog posts
</li>
</ul>
<p>I am particularly grateful to Mindy Preston and Thomas Gazagnaire for
their assistance on documentation. I am continuing the work now that I
am back in Cambridge.</p>
<p>The tone and pace of the retreat was just right, for which Hannes is
due many thanks.</p>
<p>On the final day, I gave a brief presentation about the use of OCaml
for making part of a vote counting system, focusing on the practicalities
and cost of explaining to laymen the guarantees provided by <code>.mli</code>
interface files, with an implicit comparison to the higher cost in more
conventional programming languages.</p>
<h2>The slides for the talk as delivered <a href="http://mk.ucant.org/media/talks/2017-12-05_OCaml-Marrakesh-STV/">are here</a>, but it deserves its own
blog post.</h2>
<h2>Michele Orr&ugrave;</h2>
<p>This year's Marrakech experience has been been a bit less productive than
past years'. I indulged a bit more chatting to people, and pair programming with
them.</p>
<p>I spent some of my individual time time getting my hands dirty with the Jsonm
library, hoping that I would have been able to improve the state of my
ocaml-letsencrypt library; I also learned how to integrate ocaml API in C,
improving and updating the ocaml-scrypt library, used by another fellow mirage
user in order to develop its own password manager.
Ultimately, I'm not sure either direction I took was good: a streaming Json library is
perhaps not the best choice for an application that shares few jsons (samoht
should have been selling more his <a href="https://github.com/mirage/ezjsonm">easyjson</a> library!), and the ocaml-scrypt
library has been superseeded by the pure implementation <a href="https://github.com/abeaumont/ocaml-scrypt-kdf">ocaml-scrypt-kdf</a>, which
supposedly will make the integration in mirage easier.</p>
<h2>The overall warm atmosphere and the overall positive attitude of the
group make me still think of this experience as a positive learning experience,
and how they say: failure the best teacher is.</h2>
<h2>Reynir Bj&ouml;rnsson</h2>
<p>For the second time this year (and ever) I went to Marrakech to participate in the MirageOS hack retreat / unconference.
I wrote about my <a href="http://reynir.dk/posts/2017-03-20-11-27-Marrakech%202017.html">previous trip</a>.</p>
<h3>The walk from the airport</h3>
<p>Unlike the previous trip I didn't manage to meet any fellow hackers at the RAK airport.
Considering the annoying haggling taking a taxi usually involves and that the bus didn't show up last time I decided to walk the 5.3 km from the airport to Priscilla (the venue).
The walk to <a href="https://en.wikipedia.org/wiki/Jemaa_el-Fnaa">Jemaa el-Fnaa</a> (AKA 'Big Square') was pretty straight forward.
Immediately after leaving the airport area I discovered every taxi driver would stop and tell me I needed a ride.
I therefore decided to walk on the opposite side of the road.
This made things more difficult because I then had more difficulties reading the road signs.
Anyway, I found my way to the square without any issues, although crossing the streets on foot requires cold blood and nerves of steel.</p>
<p>Once at the square I noticed a big caf&eacute; with lots of lights that I recognized immediately.
I went past it thinking it was Caf&eacute; de France.
It was not.
I spent about 30-40 minutes practicing my backtracking skills untill I finally gave up.
I went back to the square in order to call Hannes and arrange a pickup.
The two meeting points at the square was some juice stand whose number I couldn't remember and Caf&eacute; de France, so I went looking for the latter.
I quickly realized my mistake, and once I found the correct caf&eacute; the way to Priscilla was easy to remember.</p>
<p>All in all I don't recommend walking unless you <em>definitely</em> know the way and is not carrying 12-15 kg of luggage.</p>
<h3>People</h3>
<p>Once there I met new and old friends.
Some of the old friends I had seen at <a href="https://bornhack.dk">Bornhack</a> while others I hadn't seen since March.
In either case it was really nice to meet them again!
As for the new people it's amazing how close you can get with strangers in just a week.
I had some surprisingly personal conversations with people I had only met a few days prior.
Lovely people!</p>
<h3>My goals</h3>
<p>Two months prior to the hack retreat I had started work on implementing the ssh-agent protocol.
I started the project because I couldn't keep up with Christiano's <a href="https://github.com/haesbaert/awa-ssh">awa-ssh</a> efforts in my limited spare time, and wanted to work on something related that might help that project.
My goals were to work on my <a href="https://github.com/reynir/ocaml-ssh-agent">ocaml-ssh-agent</a> implementation as well as on awa-ssh.</p>
<p>Before going to Marrakech I had had a stressful week at work.
I had some things to wrap up before going to a place without a good internet connection.
I therefore tried to avoid doing anything on the computer the first two days.
On the plane to Marrakech I had taken up knitting again - something I hadn't done in at least two years.
The morning of the first day I started knitting.
Eventually I had to stop knitting because I had drunk too much coffee for me to have steady enough hands to continue, so I started the laptop despite my efforts not to.
I then looked at awa-ssh, and after talking with Christiano I made the first (and sadly only) contribution to awa-ssh of that trip:
The upstream <a href="https://github.com/mirleft/ocaml-nocrypto">nocrypto</a> library had been changed in a way that required changes to awa-ssh.
I rewrote the digest code to reflect the upstream changes, and refactored the code on suggestion by Christiano.</p>
<p>In ocaml-ssh-agent I was already using <a href="https://github.com/inhabitedtype/angstrom">angstrom</a> for parsing ssh-agent messages.
I rewrote the serialization from my own brittle cstruct manipulations to using <a href="https://github.com/inhabitedtype/faraday">faraday</a>.
This worked great, except I never quite understood how to use the <code>Faraday_lwt_unix</code> module.
Instead I'm serializing to a string and then writing that string to the <code>SSH_AUTH_SOCK</code>.</p>
<h3>GADT !!!FUN!!!</h3>
<p>The ssh-agent is a request-response protocol.
Only a certain subset of the responses are valid for each request.
I wanted to encode that relationship into the types so that the user of the library wouldn't have to deal with invalid responses.
In order to do that I got help by <a href="https://github.com/aantron">@aantron</a> to implement this with GADTs.
The basic idea is a phantom type is added to the request and response types.
The phantom type, called request_type, is a polymorphic variant that reflects the kind of requests that are possible.
Each response is parameterized with a subset of this polymorphic variant.
For example, every request can fail, so <code>Ssh_agent_failure</code> is parameterized with the whole set,
while <code>Ssh_agent_identities_answer</code> is parameterized with <code> `Ssh_agent_request_identities</code>,
and <code>Ssh_agent_success</code> is parameterized with <code> `Ssh_agent_successable</code> - a collapse of all the request types that can either return success or failure.</p>
<p>This worked great except it broke the typing of my parser -
The compiler can't guess what the type parameter should be for the resulting <code>ssh_agent_response</code>.
To work around that <a href="https://github.com/gasche">@gasche</a> helped me solve that problem by introducing an existential type:</p>
<pre><code class="language-OCaml">    type any_ssh_agent_response = Any_response : 'a ssh_agent_response -&gt; any_ssh_agent_response
</code></pre>
<p>Using this I could now write a function <code>unpack_any_response</code> which 'discards' every response that doesn't make sense for a particular request.
Its type is the following:</p>
<pre><code class="language-OCaml">    val unpack_any_response : 'a ssh_agent_request -&gt; any_ssh_agent_response -&gt;
                              ('a ssh_agent_response, string) result
</code></pre>
<p>Now I want to write a <code>listen</code> function that takes a handler of type <code>'a ssh_agent_request -&gt; 'a ssh_agent_response</code>, in other words a handler that can only create valid response types.
This unfortunately doesn't type check.
The parser returns an existential
<code>type any_ssh_agent_request = Any_request : 'req_type ssh_agent_request -&gt; any_ssh_agent_request</code>.
This is causing me a problem: the <code>'req_type</code> existential would escape.
I do not know how to solve this problem, or if it's possible to solve it at all.
I discussed this issue with <a href="http://github.com/infinity0">@infinity0</a> after the retreat, and we're not very optimistic.
Perhaps someone in <code>#ocaml</code> on Freenode might know a trick.</p>
<pre><code class="language-OCaml">    let listen ((ic, oc) : in_channel * out_channel)
        (handler : 'a Ssh_agent.ssh_agent_request -&gt; 'a Ssh_agent.ssh_agent_response) =
      match Angstrom_unix.parse Ssh_agent.Parse.ssh_agentc_message ic with
      | { len = 0; _ }, Ok (Ssh_agent.Any_request request) -&gt;
        Ok (Ssh_agent.Any_response (handler response))
      | { len; _ }, Ok _ -&gt;
        Error &quot;Additional data in reply&quot;
      | _, Error e -&gt;
        Error e
</code></pre>
<h3>Ideas for uses of ocaml-ssh-agent</h3>
<p>Besides the obvious use in a ssh-agent client in a ssh client, the library could be used to write an ssh-agent unikernel.
This unikernel could then be used in <a href="https://www.qubes-os.org/">Qubes OS</a> in the same way as <a href="https://github.com/henn/qubes-app-split-ssh">Qubes Split SSH</a> where the ssh-agent is running in a separate VM not connected to the internet.
Furthermore, <a href="https://github.com/cfcs">@cfcs</a> suggested an extension could be implemented such that only identities relevant for a specific host or host key are offered by the ssh-agent.
When one connects to e.g. github.com using ssh keys all the available public keys are sent to the server.
This allows the server to do finger printing of the client since the set of keys is likely unique for that machine, and may leak information about keys irrelevant for the service (Github).
This requires a custom ssh client which may become a thing with awa-ssh soon-ish.</p>
<h3>Saying goodbye</h3>
<p>Leaving such lovely people is always difficult.
The trip to the airport was emotional.
It was a chance to spend some last few moments with some of the people from the retreat knowing it was also the last chance this time around.
I will see a lot of the participants at 34c3 in 3 weeks already, while others I might not see again in the near future.
I do hope to stay in contact with most of them online!</p>
<h2>Thank you for yet another great retreat!</h2>
<p>Many thanks to everyone involved!  The hostel is already booked for <a href="http://retreat.mirage.io">another retreat in March 2018</a>...</p>

      

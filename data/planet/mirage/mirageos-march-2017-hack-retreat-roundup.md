---
title: MirageOS March 2017 hack retreat roundup
description:
url: https://mirage.io/blog/2017-march-hackathon-roundup
date: 2017-04-15T00:00:00-00:00
preview_image:
featured:
authors:
- Hannes Mehnert
---


        <p>This March, 34 people from around the world gathered in Marrakech for a spring Mirage hack retreat. This is fast becoming a <a href="https://mirage.io/blog/2016-spring-hackathon">MirageOS tradition</a>, and we're a little sad that it's over already! We've collected some trip reports from those who attended the 2017 Hack Retreat, and we'd like to thank our amazing hosts, organisers and everyone who took the time to write up their experiences. Props go especially to Hannes Mehnert who initiated the event and took care of many of the logistics, and to Gemma Gordon for designing and printing <a href="http://reynard.io/2017/03/10/OCamlCollection.html">limited edition t-shirts</a> especially for the occasion!
<img src="https://mirage.io/graphics/medina-2017.jpg" style="float:right; padding: 15px"/></p>
<p>In addition to the reports below, you can find other information online:</p>
<ul>
<li>the daily <a href="http://ocamllabs.io/events/2017/03/06/MirageHackUpdates.html">tweets about the event</a>, including sophisticated &quot;paper slides&quot;
</li>
<li><a href="http://ollehost.dk/blog/2017/03/17/travel-report-mirageos-hack-retreat-in-marrakesh-2017/">Olle Jonsson</a> and <a href="https://reynir.dk/posts/2017-03-20-11-27-Marrakech%202017.html">Reynir Bj&ouml;rnsson</a> wrote up their experiences on their personal sites.
</li>
</ul>
<h2>Hannes Mehnert</h2>
<p>At the retreat, 34 people from all around the world (mainly Western
Europe) interested in MirageOS gathered for a week in Marrakech.</p>
<p>Numerous social contacts, political discussions, technical challenges
were discussed in smaller and bigger groups. Lots of pull requests were
opened and merged - we kept the DSL line busy with git pushes and pulls
:) - sometimes overly busy.</p>
<p>In contrast to <a href="https://mirage.io/blog/2016-spring-hackathon">last year</a>, we organised several events:</p>
<ul>
<li>Body self-awareness workshop (by the resident dancers)
</li>
<li>Hiking to waterfalls on Sunday
</li>
<li>Hamam visit on Monday
</li>
<li>Herbalist visit on Tuesday
</li>
<li>Talk by the resident dancers on Tuesday
</li>
<li>A <a href="https://www.dropbox.com/s/w5wnlbxujf7pk5w/Marrakech.pdf?dl=0">public talk</a> led by Amir on Saturday (highly appreciated, it
was announced rather late, only ~10 external people showed up)
<img src="https://mirage.io/graphics/spiros-camel.jpg" style="float:right; padding: 15px"/>
</li>
</ul>
<p>Several voluntary presentations on topics of interest to several people:</p>
<ul>
<li>&quot;Reverse engineering MirageOS with radare2 (and IDA pro)&quot; by Alfredo
(Alfredo and Chris tried afterwards the link-time optimization branch of
OCaml, which does not seem to have any effect at all (there may be
something missing from the 4.04.0+trunk+forced_lto switch))
</li>
<li>&quot;Introduction to base&quot; by Spiros
</li>
<li>&quot;Solo5&quot; (or rather: what is below the OCaml runtime, xen vs solo5) by
Mato https://pbs.twimg.com/media/C6VQffoWMAAtbot.jpg
</li>
<li>&quot;Angstrom intro&quot; by Spiros
</li>
</ul>
<p>After the week in Marrakech, I was sad to leave the place and all the nice people. Fortunately we can interact via the Internet (on IRC,
GitHub, Mail, ...) on projects which we started or continued to work on at the retreat.</p>
<p>It was a very nice week, I met lots of new faces. These were real people with interesting stories, and I could finally match email addresses to faces. I was delighted to share knowledge about software I know to other people, and learned about other pieces of software.</p>
<p>My personal goal is to grow a nice and diverse community around MirageOS, and so far I have the feeling that this is coming along smoothly.</p>
<h2>Thanks again to everybody for participating (on-site and remote) and special thanks to <a href="http://ocamllabs.io">OCaml Labs</a> for support, and Gemma Gordon for the limited edition <a href="http://reynard.io/2017/03/10/OCamlCollection.html">t-shirts</a> (design and logistics)!</h2>
<h2>Ximin Luo</h2>
<p>Good people, good food, good weather, what more could you ask for? This year's MirageOS hackathon was a blast, like last year.</p>
<p>I started off the week by giving a monad tutorial to a few people - introducing the terminology around it, the motivation behind it, giving a few concrete examples and exercises, and relating it to some basic category theory.</p>
<p>Since last year, I've been working on-and-off on a group messaging protocol. One of its aims is to completely separate the transport and application layers, by sticking an end-to-end secure session layer in between them. This could help to unify <a href="https://xkcd.com/1810/">all the messaging protocols that exist today</a> or it could <a href="https://xkcd.com/927/">make the problem worse</a>, time will tell how this works out in the end. :)</p>
<p>Another of my interests is to write more code that is obviously-more-secure, using strong type systems that provide compile-time guarantees about what your code can or can't do. As part of bringing these two concepts together, I've been working on writing a pure library for doing scheduled (timed) computations - i.e., to express &quot;do this in X time in the future&quot; then actually do it. This is very important in real world security systems, where you can't wait for too long for certain events to happen, otherwise you'll be susceptible to attacks.</p>
<p>To give the game away, the utility is just a state monad transformer where the state is a schedule data structure that records the tasks to be performed in the future, together with a pure monadic runner that executes these tasks but is triggered by impure code that knows the &quot;real&quot; time. However, implementing the specifics so that user code is composable and still looks (relatively) nice, has taken quite some effort to figure out. There are various other nice properties I added, such as being able to serialise the schedule to disk, so the behaviour is preserved across program shutdowns.</p>
<p>Using this pure lower-level control-flow utility, we can build slightly higher-level utilities, such as a &quot;monitor&quot; (something that runs a task repeatedly, e.g. useful for resending algorithms) or an &quot;expectation&quot; (a promise/future that can time out, and also runs a monitor to repeatedly &quot;try&quot; to succeed, while it is not yet succeeded or failed, which is useful for <em>deferring</em> high-level security properties but not forgetting about them, a very common pattern). I spent much of the week building these things and testing them, and using this practical experience to refine the APIs for the low-level scheduled computations.</p>
<p>I also did some more short-term work to spread type-safe languages to more audiences, packaging OCaml 4.04 for Debian, and also reporting and working around some test failures for rustc 1.15.1 on Debian, earning me the label of &quot;traitor&quot; for a while. :p</p>
<p>I wrote more documentation for my in-progress contribution to the ocaml-lens library, to bring traverse-once &quot;van Laarhoven&quot; lens to OCaml, similar to the ones in Haskell. I had some very interesting discussions with Jens and Rudi on Rust, Haskell, OCaml and various other &quot;cutting-edge&quot; FP research topics. Rudi also gave some useful feedback on my ocaml-lens code as well as some other pure functional utilities that I've been developing for the messaging protocol mentioned above, thanks Rudi!</p>
<p>Viktor and Luk taught us how to play <a href="https://web.archive.org/web/20161026135837/http://joshaguirre.com/cambio-card-game-rules-and-cheatsheet/">Cambio</a> and we in turn taught that to probably 10 more people around the hostel, including some non-mirage guests of the hostel! It was very enjoyable playing this into the early hours of the morning.</p>
<h2>On one of the evenings Jurre and I got drunk and did some very diverse and uncensored karaoke and eventually embarassed^H^H^H^H^H^H^H persuaded a lot of the others to join us in the fun and celebrations. We'll be back next year with more, don't worry!</h2>
<h2>Michele Orr&ugrave;</h2>
<p>Last summer I started, while being an intern in Paris, a <a href="https://letsencrypt.org/">let's encrypt</a> (or rather
<a href="https://www.ietf.org/id/draft-ietf-acme-acme-06.txt">ACME</a>.</p>
<p>Let's encrypt is a certificate authority which issues signed certificates via an automated service (using the ACME protocol). Even though it is still in the process of being standardized, the first eCA already launched in April 2016, as a low-cost alternative to commercial CAs (where you usually need to provide identity information (passport) for verification).</p>
<p>If you want to run a secure service on your domain, such as HTTPS, STARTTLS in SMTP, IMAPS, ..., you have to generate a private key and a certificate signing request (CSR).  You then upload this CSR via HTTP to the let's encrypt server and solve a some &quot;challenge&quot; proposed by the server in order to certify you <em>own</em> the requested domain.</p>
<p>At the time of the hack retreat, the following challenges were supported:</p>
<ul>
<li>TLS (using the SNI extension),
</li>
<li>DNS (setting a TXT record), or
</li>
<li>HTTP (replying to a particular request at some &quot;.well_known&quot; url),
</li>
</ul>
<p>In order to reach a working implementation, I had to implement myself a JSON web signature, and a JSON web key <a href="https://github.com/mmaker/ocaml-letsencrypt/">library in OCaml</a>.</p>
<p>My goal for the hack retreat was to polish this library, get it up to date with the new internet standards, and present this library to the Mirage community, as I do believe it could be the cornerstone for bootstrapping a unikernel on the internet having encryption by default. I was impressed by the overwhelming interest of the participants and their interest in helping out polishing this library. I spent a lot of time reviewing pull requests and coding with people I had just met. For instance, <a href="https://github.com/reynir">Reynir</a> ported it to the <a href="http://erratique.ch/software/topkg">topkg</a> packager, cleaned up the dependencies and made it possible to have a certificate for multiple domains. <a href="https://github.com/vbaluch">Viktor</a> and <a href="https://github.com/realfake">Luk</a> helped out implementing the DNS challenge. <a href="https://github.com/azet">Aaron</a> helped out adding the new internet draft.</p>
<p>While busy reviewing and merging the pull requests, and extending <a href="https://github.com/Engil/Canopy">Canopy</a> to automatically renew its certificates (<a href="https://github.com/Engil/Canopy/tree/feature/letsencrypt">WIP on this feature branch</a>). My library is still not released, but I will likely do an initial release before the end of the month, after some more tests.</p>
<h2>This was the second time I attended the hack retreat, and it's been quite different: last year I was mostly helping out people, uncovering bugs and reporting documentation. This time it was other people helping me out and uncovering bugs on my code. The atmosphere and cooperation between the participants was amazing: everybody seemed to have different skills and be pleased to explain their own area of expertise, even at the cost of interrupting their own work. (I'd have to say sorry to Mindy and Thomas for interrupting too often, but they were sooo precious!) I particularly enjoyed the self-organized sessions: some of them, like Ximin's one on monads, even occurred spontaneously!</h2>
<h2>Mindy Preston</h2>
<p>Update 2017: Morocco, Marrakesh, the medina, and Priscilla are still sublime. Thank you very much to Hannes Mehnert for organizing and to the wonderful Queens at Priscilla for creating an excellent space and inviting us to inhabit it.</p>
<p>I tried to spend some time talking with people about getting started with the project and with OCaml. There's still a thirst for good-first-bug which isn't met by &quot;please implement this protocol&quot;. People are also eager for intermediate-level contributions; people are less resistant to &quot;please clean up this mess&quot; than I would have expected. I think that figuring out how to make cross-cutting changes in Mirage is still not very accessible, and would be a welcome documentation effort; relatedly, surfacing the set of work we have to do in more self-contained packages would go a long way to filling that void and is probably easier.</p>
<p>People were excited about, and did, documentation work!! And test implementation!! I was so excited to merge all of the PRs improving READMEs, blog entries, docstrings, and all of the other important bits of non-code that we haven't done a good job of keeping up with. It was <em>amazing</em> to see test contributions to our existing repositories, too -- we have our first unit test touching ipv6 in tcpip since the ipv6 modules were added in 2014. :D Related to the previous bullet point, it would be great to point at a few repositories which particularly need testing and documentation attention -- I found doing that kind of work for mirage-tcpip very helpful when I was first getting started, and there's certainly more of it to do there and in other places as well.</p>
<p>I spent a lot less time on install problems this year than last year, and a lot more time doing things like reviewing code, seeing cats, merging PRs, exploring the medina, cutting releases, climbing mountains, and pairing with people on building and testing stuff. \\o/</p>
<p>Presentations from folks were a great addition! We got introductions to Angstrom and Base from Spiros, a tour through reversing unikernels with radare2 from Alfredo, and a solo5 walkthrough from Martin. Amir gave a great description of MirageOS, OCaml, and use cases like Nymote and Databox for some of our fellow guests and friends of the hostel.  My perception is that we had more folks from the non-Mirage OCaml community this year, and I think that was a great change; talking about jbuilder, Base, Logs, and Conduit from new perspectives was illuminating. I don't have much experience of writing OCaml outside of Mirage and it's surprisingly easy (for me, anyway) to get siloed into the tools we already use and the ways we already use them. Like last year, we had several attendees who don't write much OCaml or don't do much systems programming, and I'm really glad that was preserved -- that mix of perspectives is how we get new and interesting stuff, and also all of the people were nice :)</p>
<p>There were several projects I saw more closely for the first time and was really interested in: g2p's storage, timada's performance harness; haesbaert's awa-ssh; maker's ocaml-acme; and there were tons of other things I didn't see closely but overheard interesting bits and pieces of!</p>
<h2>Rereading the aggregated trip report from the 2016 spring hack retreat, it's really striking to me how much of Mirage 3's work started there; from this year's event, I think Mirage 4 is going to be amazing. :)</h2>
<h2>Viktor Baluch &amp; Luk Burchard:</h2>
<p>&ldquo;Let&rsquo;s make operating systems great again&rdquo; &ndash; with this in mind we started our trip to Marrakech. But first things first: we are two first year computer science students from Berlin with not a whole lot of knowledge of hypervisors, operating systems or functional programming. This at first seems like a problem&hellip; and it turned out it was :).
The plan was set, let&rsquo;s learn this amazing language called OCaml and start hacking on some code, right? But, as you could imagine, it turned out to be different yet even better experience. When we arrived, we received a warm welcome in Marrakech from very motivated people who were happy to teach us new things from their areas of expertise. We wanted to share some of our valuable knowledge as well, so we taught some people how to play Cambio, our favourite card game, and it spread like wildfire (almost everyone was playing it in the second evening). We&rsquo;re glad that we managed to set back productivity in such a fun way. ;P</p>
<p>Back to what we came to Morocco for: as any programming language, OCaml seems to provide its special blend of build system challenges. <a href="https://github.com/rgrinberg/">Rudi</a> was kind enough to help us navigate the labyrinth of distribution packages, opam, and ocamlfind with great patience and it took us only two days to get it almost right.</p>
<p>Finally having a working installation, we got started by helping <a href="https://github.com/mmaker/">Michele</a> with his <a href="https://github.com/mmaker/ocaml-acme/">ocaml-acme</a> package, a client for Let's Encrypt (and other services implementing the protocol). An easy to use and integrate client seemed like one feature that could provide a boost to unikernel adoption and it looked like a good match for us as OCaml beginners since there are many implementations in other programming languages that we could refer to. After three days we finally made our first Open Source OCaml contributions to this MirageOS-related project by implementing the dns-01 challenge.</p>
<p>Hacking away on OCaml code of course wasn&rsquo;t the only thing we did in Marrakech: we climbed the Atlas mountains to see the seven magic waterfalls (little disclaimer: there are only four). It was not a really productive day but great for building up the spirit which makes the community so unique and special. Seeing camels might also helped a little bit. ;)</p>
<p>One of the most enjoyable things that the retreat provided was the chance for participants to share knowledge through presentations which lead to very interesting conversations like after <a href="https://github.com/amirmc/">Amir&rsquo;s</a> presentation when some artists asked about sense of life and computer systems (by the way, one question is already solved and it is &rsquo;42&rsquo;). We were also very impressed by the power and expressiveness of functional languages which <a href="https://github.com/seliopou/">Sprios</a> demonstrated in his parser combinator <a href="https://github.com/inhabitedtype/angstrom/">Angstrom</a>.</p>
<p>Thank you to everyone involved for giving us the experience of an early &lsquo;enlightenment&rsquo; about functional programming as first year students and the engaging discussions with so many amazing people! We sure learned a lot and will continue working with OCaml and MirageOS whenever possible.</p>
<h2>Hope to see all of you again next time!</h2>
<h2>Aaron Zauner</h2>
<p>I flew from Egypt to Marrakech not sure what to expect, although I'm not new to functional programming, I'm a total OCaml novice and haven't worked on unikernels - but have always been interested in the topic. Hannes invited me to hang out and discuss, and that's exactly what I did. I really enjoyed spending my time with and meeting all of you. Some of you I have known &quot;from the interwebs&quot; for a while, but never met in person, so this was a great opportunity for me to finally get to see some of you in real life. I spent most of my time discussing security topics (everything from cryptography, bootstrapping problems to telco/ mobile security), operating system design and some programming language theory. I got to know the OCaml environment, a bit more about MirageOS and I read quite a few cryptography and operating system security papers.</p>
<h2>All of the people I spoke with were very knowledgeble - and I got to see what people exactly work on in MirageOS - which certainly sparked further interest in the project. I've been to Morocco a couple of times but the food we got at Queens of the Medina was by far the best food I've eaten in Morocco so far. I think the mix of nerds and artists living at the Riad was really inspiring for all of us, I was certainly interested in what they were working on, and they seemed to be interested in what all of these freaky hackers were about too. Living together for more than a week gives the opportunity to get to know people not only on a technical level but -- on a personal level, in my opinion we had a great group of people. Giving back to the local community by giving talks on what we're doing at the Hackathon was a great idea, and I enjoyed all of the talks that I've attended. I've been to a few hackathons (and even organized one or two), but this one has certainly been the most enjoyable one for me. People, food, location and the discussions (also Karaoke and learning to play Cambio!) I've had will make me remember the time I spent with you guys for a long time. I hope I'm able to join again at some point (and actually contribute to code not only discussions) in the future. Unfortunately I cannot give any feedback on possible improvements, as I think we had a very well selected group of people and perfect conditions for a Hackathon, could not think of how to organize it better - Thank you Hannes!</h2>
<h2>Thomas Leonard</h2>
<p>This was my second time at the hackathon, and it was great to see everyone and work on Mirage stuff again! I brought along a NUC which provided an additional wireless access point, running a Mirage/Xen DHCP server using haesbaert's <a href="https://github.com/mirage/charrua-core">charrua</a> library - one of the fruits of last year's efforts.</p>
<p>My goal this year was to update <a href="http://roscidus.com/blog/blog/2016/01/01/a-unikernel-firewall-for-qubesos/">qubes-mirage-firewall</a> to support Mirage 3 and the latest version of <a href="https://github.com/yomimono/mirage-nat">mirage-nat</a>, and to add support for NAT of ICMP messages (so that <code>ping</code> works and connection errors are reported). In the process, I converted mirage-nat to use the new parsers in the Mirage 3 version of the tcpip library, which cleaned up the code a lot. It turned out that the firewall stressed these parsers in new ways and we were able to <a href="https://github.com/mirage/mirage-tcpip/pull/301">make them more robust</a> as a result. Having Mirage 3 release manager and mirage-nat author yomimono on hand to help out was very useful!</p>
<p>It was great to see so many QubesOS users there this year. Helping them get the firewall installed motivated me to write some proper installation instructions for <a href="https://github.com/talex5/qubes-test-mirage">qubes-test-mirage</a>.</p>
<p>After the hackathon, I also updated mirage-nat to limit the size of the NAT table (using pqwy's <a href="https://github.com/pqwy/lru">lru</a>) and made a new release of the firewall with all the improvements.</p>
<p>ComposMin was looking for a project and I hopefully suggested some tedious upgrading and build system porting work. He accepted!! So, <a href="https://github.com/talex5/qubes-mirage-skeleton">qubes-mirage-skeleton</a> now works with Mirage 3 and <a href="https://github.com/mirage/mirage-profile">mirage-profile</a> has been ported to topkg - something I had previously attempted and failed at.</p>
<p>Rudi gave me an introduction to the new <a href="https://github.com/janestreet/jbuilder">jbuilder</a> build tool and I look forward to converting some of my projects to use it in the near future.</p>
<p>Particularly useful for me personally was the chance discovery that Ximin Luo is a Debian Developer. He signed my GPG key, allowing me to complete a Debian key rollover that I began in May 2009, and thus recover the ability to update my package again.</p>
<p>I also wanted to work on <a href="https://github.com/talex5/irmin-indexeddb">irmin-indexeddb</a> (which allows web applications to store Irmin data in the browser), but ran out of time - maybe next year...</p>
<h2>Many thanks to hannesm for organising this!</h2>
<h2>Amir Chaudhry</h2>
<p>This was my first time at the Marrakech hack retreat. I was only there for about half the time (mostly the weekend) and my goal was simply to meet people and understand what their experiences have been. Having missed the inaugural event last year, I wasn't sure what to expect in terms of format/event. What I found was a very relaxed approach with lots of underlying activity. The daily stand ups just before lunch were well managed and it was interesting to hear what people were thinking of working on, even when that included taking a break. The food was even more amazing than I'd been led to believe by tweets :)</p>
<p>Somehow, a few hours after I arrived, Hannes managed to sweet-talk me in to giving a presentation the next day about MirageOS to the artists and dance troupe that normally make use of the venue. Since we'd taken over the place for a week &mdash; displacing their normal activities &mdash; our host thought it would be helpful if someone explained &quot;what the nerds are doing here&quot;. This was an unexpected challenge as getting across the background for MirageOS involves a lot of assumed knowledge about operating system basics, software development, software <em>itself</em>, the differences between end-users and developers, roughly how the internet works, and so on. There's a surprising number of things that we all just 'know', which the average software user has no clue about. I hadn't given a talk to that kind of audience before so I spent half a day scrambling for analogies before settling on one that seemed like it might work &mdash; involving houses, broken windows, and the staff of Downton Abbey. The talk led to a bunch of interesting discussions with the artists which everyone got involved with. I think the next time I do this, I might also add an analogy around pizza (I have many ideas on this theme already). If you're interested in the slides themselves (mostly pics), there's a PDF at https://www.dropbox.com/s/w5wnlbxujf7pk5w/Marrakech.pdf?dl=0</p>
<p>I also had time to chat with Mindy about an upcoming talk on MirageOS 3.0, and Martin about future work on Solo5. The talks and demos I saw were really useful too and sharing that knowledge with others in this kind of environment was a great idea. Everyone loved the t-shirts and were especially pleased to see me as it turned out I was bringing many of the medium-sized ones. One of the best things about this trip was putting names and faces to GitHub handles, though my brain regularly got the mapping wrong. :)</p>
<h2>Overall, this was an excellent event and now that it's happened twice, I think we can call it a tradition. I'm looking forward to the next one!</h2>
<h2>Jurre van Bergen</h2>
<p>I spent most of my time reading up on functional programming and setting up an developer environment and helped with some small things here and there. I didn't feel confident to do a lot of code yet, but it was a very nice environment to ask questions in, especially as a newcomer to MirageOS and OCaml!</p>
<p>I plan to do more OCaml in my spare time and play more with MirageOS in the future. Maybe someday, we can actually merge in some MirageOS things into <a href="https://tails.boum.org/">Tails</a>. I hope to actually do some OCaml code with people next year!
Next to that, there was also some time to relax, climbing the Atlas mountains was a welcome change of scenery after reading through up on functional programming for a couple of days. Will definitely do that again some day!</p>
<h2>Next to that, shout out to Viktor and Luke for teaching us how to play Cambio, we had a lot of fun with it the entire retreat in the evenings!
I was excited to learn that so many people were actually into karaoke, I hope those who don't will join us next year ;-)</h2>
<h2>Reynir Bj&ouml;rnsson</h2>
<p>A work in progress from Reynir is his work on documentation in the toplevel:</p>
<blockquote>
<p>As mentioned on the midday talkie talkie I've made a OCaml toplevel directive for querying documentation (if available). It's available here <a href="https://github.com/reynir/ocp-index-top">https://github.com/reynir/ocp-index-top</a>.
To test it out you can install it with opam pin:
opam pin add ocp-index-top https://github.com/reynir/ocp-index-top.git</p>
</blockquote>
<p>It doesn't depend on opam-lib. opam-lib is yuuuuge and the API is unstable. Instead I shell out to opam directly similar to how ocp-browser works. This means installing the package is less likely to make a mess in your dependencies.</p>
<blockquote>
<p>There is one issue I don't know how to fix (see issue #1). When requiring <code>ocp-index-top</code> the <code>compiler-libs</code> and <code>ocp-index.lib</code> libraries are pulled into scope which is not cool and totally unnecessary.</p>
</blockquote>
<hr/>
<p>Many thanks to everyone involved!  The hackathon is already booked for next year in the same place...</p>

      

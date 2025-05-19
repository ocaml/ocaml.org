---
title: Decentralised tech on Recoil
description: Recoil's decentralized tech stack includes email, web, and chat services.
url: https://anil.recoil.org/notes/decentralised-stack
date: 2021-09-19T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
ignore: true
---

<p><a href="https://nick.recoil.org" class="contact">Nick Ludlam</a> and I have self-hosted recoil.org since around 1996, typically for
email and web.  These days, there are a number of interesting software stacks
around decentralised communication that we deploy. This note keeps track of
them.</p>
<ul>
<li><strong>Email</strong>  (active)
<ul>
<li>Currently Postfix and DKIM/SPIF relays</li>
<li>Till 2019, was OpenSMTPD and would like to return to it but waiting on
filter support.</li>
<li>Till around 2016, was qmail but finally gave up due to difficulty of
spam filtering.</li>
<li>Next step will be to try out the MirageOS email stack that dinosaure
has been leading the development of.</li>
</ul>
</li>
<li><strong>Web</strong> (active)
<ul>
<li>This website is an OCaml webserver running a custom multicore OCaml <a href="https://github.com/avsm/eeww">webserver</a></li>
<li>Next step will be to go solar powered with a custom DNS server.</li>
</ul>
</li>
<li><strong>DNS</strong> (inactive)
<ul>
<li>MirageOS DNS server.</li>
<li>Currently offline due to a hosting issue so fell back to Gandi.</li>
<li>Hopefully can secondary with @hannesm and his MirageOS infrastructure.</li>
</ul>
</li>
<li><strong>Videos</strong> (active)
<ul>
<li>Running a PeerTube instance on <a href="https://crank.recoil.org">https://crank.recoil.org</a></li>
<li>Also deployed this for the OCaml community as &lt;watch.ocaml.org&gt;, so my
personal recoil instance is "following" the OCaml one as well as having
my own videos.</li>
</ul>
</li>
<li><strong>Chat</strong> (active)
<ul>
<li>Running a Matrix Element. server with a HTTP srv for recoil.org</li>
<li>Using element.io clients to connect to it.</li>
<li>Lots of federation to other services happening from this via
republished rooms, so its a fairly busy server.</li>
<li>Next step is to deploy some of the OCaml Matrix clients to control
the notifications. Element doesnt have very good push support.</li>
<li>Decided not to bridge this to WhatsApp/Signal/etc as the maintenance
cost is quite high and it requires unencrypted passwords.</li>
<li>Need to regularly sweep the Element database to keep the size down, as detailed in this <a href="https://levans.fr/shrink-synapse-database.html">handy blog post</a>.</li>
</ul>
</li>
<li><strong>Activity</strong> (active)
<ul>
<li>Deplyed a Mastadon instance for distributed tweeting via
ActivityPub, on https://amok.recoil.org/</li>
</ul>
</li>
<li><strong>Images</strong> (inactive)
<ul>
<li>Tristan Henderson pointed me to pixelfed which seems worth a try for
image sharing over ActivityPub. Not had a chance to use it yet.</li>
</ul>
</li>
<li><strong>Spam</strong> (inactive)
<ul>
<li>Problem with the chat service is that I'm getting quite a lot of spam
requests on Matrix. Am experimenting with a Tezos node to act as a
DID introduction proxy with gas costs. Hopefully there's a way to
be introduced due to some common service (or some evidence of PoW for the
communication such as having read and quoted one of my papers or something)
and have micropayment as a last-resort.</li>
<li>Also deployed SpamAssassin recoil-wide and custom bayes filters.</li>
</ul>
</li>
</ul>
<p>In general, our operating system of choice is OpenBSD (since 1998 or so) with
Alpine Linux for the more recent things that run on a cloud or haven't been
ported yet.</p>


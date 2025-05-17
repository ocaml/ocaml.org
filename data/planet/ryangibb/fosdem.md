---
title: FOSDEM
description:
url: https://ryan.freumh.org/fosdem.html
date: 2024-02-13T00:00:00-00:00
preview_image:
authors:
- Ryan Gibb
source:
---

<article>
    <div class="container">
        
        <span>Published 13 Feb 2024.</span>
        
        
        <span style="font-style: italic;">Last update 13 Feb 2024.</span>
        
    </div>
    
        <div> Tags: <a href="https://ryan.freumh.org/conferences.html" title="All pages tagged 'conferences'." rel="tag">conferences</a>. </div>
    
    <section>
        <p><span>I attended the Free and Open source Software
Developers’ European Meeting (FOSDEM) in Brussels, Belgium last weekend.
There are hundreds of hours of talks in 35 rooms over a period of two
days, and rooms are often full to capacity, so it’s impossible to see
everything! Thankfully every room is live-streamed and recordings made
available after the fact, so you can catch up on anything you
miss.</span></p>
<p><img src="https://ryan.freumh.org/images/fosdem-schedule.png"></p>
<h2>Friday</h2>
<p><span>On the Eurostar over my travelling companion
and I were lamenting about the Nix DSL, and we heard a French accent
from behind:</span></p>
<blockquote>
<p><span>Ah, NixOS. See you at FOSDEM
then!</span></p>
</blockquote>
<h2>Saturday</h2>
<p><span>The day started with a coffee and a banana
(probably not substantial enough in hindsight), an absolutely packed
number 71 bus to the ULB Solbosch Campus, and arriving in plenty of time
to get a seat for the 09:30 CET opening ceremony. I kicked off the day
by attending:</span></p>
<ul>
<li><a href="https://fosdem.org/2024/schedule/event/fosdem-2024-3242-screen-sharing-on-raspberry-pi-5-using-vnc-in-weston-and-wayland-with-the-yocto-project-and-openembedded/">Screen
Sharing on Raspberry Pi 5 Using VNC in Weston and Wayland with the Yocto
Project and OpenEmbedded</a></li>
<li>and <a href="https://fosdem.org/2024/schedule/event/fosdem-2024-1798-improving-ipv6-only-experience-on-linux/">Improving
IPv6-only experience on Linux</a></li>
</ul>
<p><span>Having, during my January tradition, spent
some time revisiting my technical (in addition to non-technical) habits,
after getting sufficiently frustrated with thunderbird I’ve started
using the <a href="https://aerc-mail.org/">aerc</a> mail client along
with <a href="https://github.com/RyanGibb/nixos/blob/3cd20b3b874b70b53cd894a533fe44b589f8eeea/modules/personal/home/mail/default.nix">isync
(mbsync)/goimapnotify/mu</a>. So naturally I then moseyed on over to the
Modern Email <a href="https://www.ietf.org/how/bofs/">BoF</a>.</span></p>
<p><span>I was a little early and caught the end of
the NGI Zero network meetup, and met someone who works for the Dutch
Standardisation Forum on, amoung other things, a neat website and
mailserver tester at <a href="https://internet.nl/">internet.nl</a>. My
website and mailserver had a couple of flagged issues including a DMARC
policy of none (which should really quarantine or reject once it’s
working properly), and DNSSEC support due my nameserver <a href="https://github.com/RyanGibb/eon">EON</a> not (<a href="https://github.com/mirage/ocaml-dns/issues/302">yet</a>)
supporting DNSSEC. Switching to bind with a couple of configuration
changes got me scoring 100% on my apex <code>freumh.org</code>. The
<code>www</code> subdomain was a CNAME to the apex, which meant it also
served an MX record. I don’t serve any significant website on my apex
domain, so I simply dropped the subdomain. Now I’m told a free
<code>internet.nl</code> T-Shirt is on its way to my Cambridge
address!</span></p>
<p><span>I’ve been working on a <a href="https://github.com/RyanGibb/eon/tree/a442c424ea06b2c819dd48c9e69838e09675b22b/bin/acme">nameserver
to provision TLS certificates</a> recently for inclusion into my
one-stop-shop self-hosting solution <a href="https://github.com/RyanGibb/eilean-nix">Eilean</a>. By including
the DNS zonefile data in the Nix configuration we can automatically
provision the necessary records for new services, as well as manage
records for e.g.&nbsp;DKIM/DMARC/SPIF. It would be great if I could get a
score of 100% on <code>internet.nl</code> on an out-of-the box Eilean
deployment as this would simplify the experience of self-hosting these
services greatly.</span></p>
<h3>Modern Email devroom</h3>
<p><span>When the Email discussion
started I sat next to a person who develops the <a href="https://github.com/emersion/go-imap">Go IMAP</a> library used by
my mail client aerc. They also just so happen to be the lead maintainer
of <a href="https://gitlab.freedesktop.org/wlroots/wlroots/"><code>wlroots</code></a>,
a library which I was writing bindings to OCaml on the train over in
hopes of writing a performant, functional, modern <a href="https://github.com/RyanGibb/oway">display server</a>. I’ve since
been added as a maintainer to the <a href="https://github.com/swaywm/wlroots-ocaml/pull/7">dormant bindings
library</a>.</span></p>
<p><span>I then joined he JMAP
discussion section and got some insight to the chicken-and-egg problem
of Internet protocol ossification in a discussion between Dovecot
developers and salespeople, and JMAP proponents. Talking to one such
JMAP proponent developing a <a href="https://codeberg.org/iNPUTmice/lttrs-android">JMAP client for
Android</a> was very educational. It seems like JMAP is essentially an
open standard for implementing a lot of functionality that comes from
propriety client/server solutions like Gmail. For example, it supports
the use of notification services of instead of polling (and not just
maintaining an open TCP connection). I’ve heard this can be an issue
using non-Google android distributions like <a href="https://grapheneos.org/">GraphineOS</a>, but apparently there are
numerous alternatives such as <a href="https://microg.org/">microG</a>.
Another example is that it supports search on server functionality
without having to download emails. I like to keep all my mail locally on
my main machine, but the JMAP seems particularly well suited to mobile
devices where that is not the case.</span></p>
<p><span>They also mentioned the <a href="https://stalw.art/">Stallwart</a> JMAP-compatible mailserver. This
was mentioned by <a href="https://nlnet.nl/">nlnet.nl</a> in the NixOS
devroom on Sunday as well. I might try deploying it for myself and
integrating it into Eilean.</span></p>
<h3>OS Stands</h3>
<p><span>After the Modern Email devroom I had a
look around the <a href="https://fosdem.org/2024/stands/">stands</a> in
the AW building which were mainly OS related. A couple of really cool
projects were PostmarketOS and SailfishOS building Linux (not Android)
distributions for mobile devices, though apparently SailfishOS has some
closed-source components such as for Android emulation. It seems Gnome
and KDE both have mobile display environments, and Phosh is the on
PostmarketOS. <a href="https://sxmo.org/">Sxmo</a> is cool project that
encourages allows the use of e.g.&nbsp;sway. It also allows SSHing to your
phone and sending SMS messages! I can’t figure out how to send texts
from the command line with KDE, It also looks to be possible to deploy
<a href="https://gitlab.com/beeper/android-sms/">a</a> <a href="https://github.com/mautrix/gmessages">number</a> <a href="https://github.com/benkuly/matrix-sms-bridge">of</a> matrix
bridges for this.</span></p>
<h3>Firefox</h3>
<p><span>My choice of browser was vindicated with a
free ‘cookie’ stand:</span></p>
<p><img src="https://ryan.freumh.org/images/fosdem-cookies.jpg" style="width:60.0%" data-min-width="5cm"></p>
<h3>More talks</h3>
<p><span>I attended a bunch more talks after
lunch (but still far less than I wanted too):</span></p>
<ul>
<li><a href="https://fosdem.org/2024/schedule/event/fosdem-2024-3163-copyleft-and-the-gpl-finding-the-path-forward-to-defend-our-software-right-to-repair/">Copyleft
and the GPL</a></li>
<li><a href="https://fosdem.org/2024/schedule/event/fosdem-2024-2213-brewing-free-beer-with-esphome-and-home-assistant/">Brewing
Free Beer with ESPHome and Home Assistant</a>. Being both a home-brewer
(blog post incoming) and a Home Assistant user this was really cool! It
may be worth exploring something like this if I ever get really into
full-mash brewing.</li>
<li><a href="https://fosdem.org/2024/schedule/event/fosdem-2024-2972-wayland-s-input-method-is-broken-and-it-s-my-fault/">Wayland’s
input-method is broken and it’s my fault</a>. The speaker of this talk
had written the Wayland <a href="https://gitlab.freedesktop.org/wayland/wayland-protocols/-/blob/master/unstable/text-input/text-input-unstable-v3.xml">text-input-unstable-v3
proposal</a> for the Phosh mobile UI, which is by their description
horribly broken. I was intrigued about this talk as I spent a while
figuring how to get Fcitx5 pop-up menus for international text input
working on Sway and ended up using a patch set from an <a href="https://github.com/swaywm/sway/pull/7226">open PR</a>.</li>
<li><a href="https://fosdem.org/2024/schedule/event/fosdem-2024-3062-i-want-my-own-cellular-network-having-fun-with-lte-networks-and-open5gs-/">I
want my own cellular network! Having fun with LTE networks and
Open5Gs</a></li>
<li><a href="https://fosdem.org/2024/schedule/event/fosdem-2024-2906-dnsconfd-system-integrated-dns-cache/">dnsconfd:
system integrated DNS cache</a></li>
</ul>
<h2>Tailscale Meetup</h2>
<p><span>After the conference proper we
were in want of something to do so we went to a Tailscale meetup for
free drinks. To collect said drinks, one had to connect to a printer <a href="https://tailscale.com/blog/sharing-over-tailscale">shared via
Tailscale</a>. Unfortunately as I’m using a self-hosted headscale
control server I wasn’t able to have this machine shared with me.
Thankfully my companions were more than happy to print a ticket on my
behalf. Though, this reminded that my idea of a ‘federated tailscale’
would be really cool. In the bar I met some lovely people and got some
podcast recommendations (e.g.&nbsp;<a href="https://selfhosted.show/">Self
Hosted</a>).</span></p>
<h3>Sun</h3>
<p><span>After another coffee breakfast, I headed to the
ULB for the final day of conferencing. I mainly camped out in two rooms
– the Nix and NixOS devroom and the Matrix devroom.</span></p>
<h3>Nix and NixOS</h3>
<p><span>In this devroom I
attended:</span></p>
<ul>
<li>In <a href="https://fosdem.org/2024/schedule/event/fosdem-2024-2204-fortifying-the-foundations-elevating-security-in-nix-and-nixos/">Fortifying
the Foundations: Elevating Security in Nix and NixOS</a> they mentioned
they got funding for this project from the <a href="https://www.sovereigntechfund.de/">Sovereign Tech Fund</a>.</li>
<li><a href="https://fosdem.org/2024/schedule/event/fosdem-2024-3058-nix-for-genetics-powering-a-bioinformatics-pipeline/">Nix
for genetics : powering a bioinformatics pipeline</a> was a lightning
talk about using Nix to provide reproducible dependencies for their
pipelines. They don’t manage the mutable state like datasets with Nix,
though.</li>
<li><a href="https://fosdem.org/2024/schedule/event/fosdem-2024-3045-automatic-boot-assessment-with-boot-counting/">Automatic
boot assessment with boot counting</a> described a mechanism for falling
back to old NixOS generations in the case where a boot of a new
configuration fails. I experienced the exact problem this solves with my
new NAS (blog post incoming) after creating a <code>fstab</code> entry
for an invalid ZFS pool, which required asking a family member to be my
remote KVM to boot an old generation for me to fix the entry.</li>
</ul>
<p><span>During an intermission, I was hacking
on my VPS deploying DNSSEC with BIND9 for a free
<code>internet.nl</code> T-Shirt when I started to experience some
strange network issues. All requests to <code>freumh.org</code> were
being directed to
<code>http://135.181.100.27:6080/php/urlblock.php?args=&lt;hash&gt;&amp;url=http://135.181.100.27%2f</code>
on eduroam. I wasn’t able to connect to my site on the IPv6-only
<code>fosdem</code> network either, despite it working the previous day.
Switching the dual-stack IPv4 compatible network seemed to alleviate the
issues, but before I uncovered these underlying network issues this
manifested itself in my being unable to connect to my headscale
Tailscale control server, which I exclaimed to my friend next to me.
Then the <a href="https://archive.fosdem.org/2023/schedule/event/goheadscale/">lead
developer for headscale</a>, sitting <em>right</em> behind me, piped up
and said something along the lines of “I know it’s rude to look at other
people’s screens but if headscale is causing you any issues I
apologise”.</span></p>
<p><span>The talks continued with:</span></p>
<ul>
<li><a href="https://fosdem.org/2024/schedule/event/fosdem-2024-1692-running-nlnet-on-nixos/">Running
NLnet on NixOS</a> which was an unexpectedly interesting talk on <a href="https://nlnet.nl/">NLnet</a>‘s experience using NixOS to run their
systems. They observed that once you realise everything in Nix is just a
function, as suggested by the tag-line of a ’purely functional package
manager’, all becomes very conceptually simple. NLnet use borg for
backups and btrbk for snapshots, which might be worth looking into for
Eilean. They noted that Nix is great at handling the software setup, but
that it has no notion of the mutable runtime state like databases and
secrets. This is where I see a lot of people having issues with Nix,
e.g.&nbsp;with database migrations. I think a ‘Nix for data’ story would be
very useful. Perhaps it could utilize some form of snapshots associated
with NixOS generations.</li>
</ul>
<h3>Matrix</h3>
<p><span>Having self-hosted a Matrix homeserver for
(<em>checks logs</em>) 2 years this February, I was keen to attend the
Matrix devroom, where I learnt about:</span></p>
<ul>
<li><a href="https://fosdem.org/2024/schedule/event/fosdem-2024-3285-the-matrix-state-of-the-union">The
Matrix State of the Union</a> including a bit of the history of the
project, how <a href="https://thirdroom.io/">Third Room</a> is
apparently dead due to lack of funding, PseudoIDs <a href="https://github.com/matrix-org/matrix-spec-proposals/pull/4014">MSC4014</a>
&amp; Crypto IDs <a href="https://github.com/matrix-org/matrix-spec-proposals/pull/4080">MSC4080</a>
which should provide account portability (though I don’t completely
understand how yet) and which are a pre-requisite for <a href="https://matrix.org/blog/2020/06/02/introducing-p2p-matrix/">P2P
Matrix</a> which uses a very cool <a href="https://github.com/matrix-org/pinecone">overlay network</a> that
aims to provide end-to-end encrypted connectivity over any medium and
providing multi-hop peer-to-peer connectivity between devices in places
where there is no Internet connectivity. Some of this talk reminded me
of discussions I’ve had about using Matrix as a communication channel
for the Internet of Things.</li>
<li>In <a href="https://fosdem.org/2024/schedule/event/fosdem-2024-3157-interoperability-matrix/">Interoperability
&amp; Matrix</a> I learnt that the new EU Digital Markets Act (DMA)
requires an open standard for interoperable communications, how <a href="https://datatracker.ietf.org/doc/html/draft-ralston-mimi-linearized-matrix-03">Linearised
Matrix</a> is one such proposal, and about the <a href="https://datatracker.ietf.org/doc/html/draft-ralston-mimi-protocol-01">MIMI</a>
IETF working group.</li>
</ul>
<hr>
<p><span>All in all, attending FOSDEM was a great
experience where I learnt a bunch about topics I’m passionate about and
met some really cool people.</span></p>
    </section>
</article>


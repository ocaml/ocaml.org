---
title: "<presence from=\u201Djehan@tuxfamily/OX\u201D id=\u201Dhello\u201D to=\u201Dworld\u201D
  />"
description:
url: http://ox.tuxfamily.org/2011/03/15/hello-world/
date: 2011-03-15T05:11:21-00:00
preview_image:
featured:
authors:
- xmpp
---

<p>Hi all,</p>
<p>this is the first official development log for <strong>OX</strong>, alias <em>Ocaml XMPP</em>, a <a href="http://www.xmpp.org" title="XSF website: the XMPP Standards Foundation">XMPP</a> library (client only, for now at least) for the <a href="http://caml.inria.fr/ocaml/index.fr.html" title="Ocaml">Objective Caml</a> language in order to connect to and do various things with XMPP servers (also informally known as <em>Jabber</em>. XMPP is the Instant Messaging IETF standard*, used among others by <a href="http://www.google.com/talk/" title="Google Talk">Google</a>, <a href="http://www.livejournal.com/chat/" title="LJ Talk">LiveJournal</a>, <a href="http://www.facebook.com/sitetour/chat.php" title="Facebook Chat">Facebook</a> (though this service is closed on itself), the well-known <a href="http://www.bbc.co.uk/blogs/radiolabs/2009/11/pushfeeds.shtml" title="LiveText via IP">BBC</a> radio, or even in-game (and out-game!) chat like in <a href="http://eve-mail.net/" title="eve-mail">EveOnline</a>, or the Quake Live gaming platform&hellip; And so many others!).</p>
<p>According to my own repository, the first code ever written was in 11th of July of 2008! But after some code which led only to a basic example (it was simply connecting in TLS + PLAIN), I left the project on the side, using my time for other parts of my life&hellip; until this very month!</p>
<p>I have indeed now been back on the horse for about the last 2 weeks! A lot of rewriting of the bases, plus a few additional features (like SASL SCRAM for authentication, I&rsquo;ll talk about this soon!) has been done in these few weeks.</p>
<p>Don&rsquo;t try to download the code yet if you are looking for a ready-to-use library. It is still ugly and not really usable in a real (even small) project, as I am in heavy work of putting everything up to date with a solid interface. It won&rsquo;t get you anywhere right now.</p>
<p>I hope to be able to provide the version 0.1, the first official release very soon (hopefully in less than a month).<br/>
Until then, stay up to date!</p>
<p>* one would say, the IETF has actually 2 standards for Instant Messaging and Media over IP: XMPP and <a href="http://www.ietf.org/rfc/rfc3261.txt" title="Session Initiation Protocol (SIP)">SIP</a>. <a href="http://tools.ietf.org/html/draft-veikkolainen-sip-xmpp-coex-reqs-02" title="draft-veikkolainen-sip-xmpp-coex-reqs-02">Work is in progress</a> to make them interoperable.</p>


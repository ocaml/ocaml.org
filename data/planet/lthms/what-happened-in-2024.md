---
title: What Happened in 2024?
description: "We are done with 2024, and now is a good time to reflect on what has
  happened over the past 12 months. I was not planning to, but my feed convinced me
  to give it a try. Plus, it is a good opportunity to revive my \u201CRetrospective\u201D
  series."
url: https://soap.coffee/~lthms/posts/December2024.html
date: 2025-01-01T00:00:00-00:00
preview_image: https://soap.coffee/~lthms/img/thinking.png
authors:
- "Thomas Letan\u2019s Blog"
source:
---


        
        <h1>What Happened in 2024?</h1><div><span class="icon"><svg><use href="/~lthms/img/icons.svg#tag"></use></svg></span>&nbsp;<a href="https://soap.coffee/~lthms/tags/meta.html" marked="" class="tag">meta</a> <span class="icon"><svg><use href="/~lthms/img/icons.svg#tag"></use></svg></span>&nbsp;<a href="https://soap.coffee/~lthms/tags/opinions.html" marked="" class="tag">opinions</a> </div>
<p>We are done with 2024, and now is a good time to reflect on what has happened
over the past 12 months. I was not planning to, but <a href="https://www.paulox.net/2024/12/31/my-2024-in-review/" marked="">my feed convinced me to
give it a try&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>. Plus, it is a good opportunity to revive my
“<a href="https://soap.coffee/~lthms/posts/series/Retrospectives.html" marked="">Retrospective</a>” series.</p>
<h2>Free and Open Source Software</h2>
<p>I’ve been a “prolific contributor” at <code class="hljs language-bash"><span class="hljs-variable">$WORK</span></code>, but less so with my
personal projects.</p>
<ul>
<li><a href="https://github.com/lthms/spatial-shell" marked="">Spatial Shell&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a> remains my most “popular” project<label for="fn1" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-right sidenote note"><span class="footnote-p">We should reach 100 stars on GitHub in 2025 😅. </span>
</span>, but
except for a very minor 7th release in January, I have not touched it. It’s
basically a done project, and I very much enjoy using it on a daily basis. My
main regret is that, contrary to what is stated in its README, Spatial Shell
does not work <em>at all</em> with i3.</li>
<li><a href="https://github.com/lthms/ezjsonm-encoding" marked=""><code class="hljs">ezjsonm-encoding</code>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a> was initially written for Spatial Shell, but I
turned it into its own OCaml package in 2024. It is a JSON-only encoding
library heavily borrowing on <a href="https://ocaml.org/p/data-encoding/latest" marked="">Data-encoding API&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>, but with a
more flexible default behavior for object parsing. I enjoyed writing the
documentation, inspired by a tweet from <a href="https://bsky.app/profile/chshersh.com" marked="">Dmitrii Kovanikov&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#bsky"></use></svg></span></a><label for="fn2" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-left sidenote note"><span class="footnote-p">Yes, cool kids moved to Bluesky in 2024, and Dmitrii is definitely a
cool kid. </span>
</span>.
That being said, I have never bothered to benchmark this package properly, so
if performances are important, it may not be a good fit for you.</li>
<li><a href="https://github.com/lthms/jsonrpc2" marked=""><code class="hljs">jsonrpc2</code>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a> is, as of January 1st, 2025, an experiment in
providing a general-purpose framework for servers and clients communicating
with the <a href="https://www.jsonrpc.org/specification" marked="">JSON RPC 2.0&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a> protocol. I quite like the API I’m proposing there,
and maybe I’ll try to polish and publish it in 2025.</li>
<li><a href="https://github.com/lthms/bepo-tsrn.nvim" marked=""><code class="hljs">bepo-tsrn.nvim</code>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a> is another thing I have done for myself, but
published as if it was a public good. Now, instead of having to copy/paste
the same Neovim configuration file on every computer I use, I can just type
<code class="hljs">yay -S neovim-bepo-tsrn-git</code> and be done with it.</li>
<li><a href="https://github.com/lthms/celtchar" marked="">celtchar&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a> has seen its first commits since 2021, which is not nothing. As a
reminder, celtchar is a little tool I have written to generate ebooks and
static websites for the stories I write; and as I was doing the 2024 edition
of <a href="https://nanowrimo.org" marked="">NaNoWriMo&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>, I found myself in need to add a missing feature (supporting
books split in parts, not only chapters).</li>
</ul>
<p>Overall, I’ve been defaulting to OCaml for the past two years or so, and I am
starting to think it is time to widen my perspective again. I will probably
start with relearning Go<label for="fn3" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-right sidenote note"><span class="footnote-p">I don’t know why, but I have been mildly obsessed with this language
lately. </span>
</span>.</p>
<h2>Blog posts</h2>
<p>2024 was not a very productive year when it comes to this website. I have
published 5 articles, which is half the number of publications of 2023. As a
logical consequence, not a lot of folks have visited my website this year.
Funnily enough, the <a href="http://localhost:8000/~lthms/posts/SpatialShell6.html" marked="">most read article&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a> (by far) in 2024 was published in
2023<label for="fn4" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-left sidenote note"><span class="footnote-p">To be fair, it was published on December 30, 2023. </span>
</span>.</p>
<p></p><figure><img src="https://soap.coffee/~lthms/img/2024.png"><figcaption><p>Yes, 2024 was a quiet year for this website</p></figcaption></figure><p></p>
<p>That being said, I am quite happy with the content published in 2024.</p>
<ul>
<li><a href="https://soap.coffee/~lthms/posts/GitMaintenanceSshEncryptedKeys.html" marked="">Using <code class="hljs">git maintenance</code> with Encrypted SSH Keys</a> is the first article I
published in 2024. It is a direct consequence of my trip to Brussels in
February to attend to <a href="https://archive.fosdem.org/2024/" marked="">FOSDEM&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>. If you haven’t already, you should watch
<a href="https://www.youtube.com/watch?v=aolI_Rz0ZqY&amp;pp=ygUZc28geW91IHRoaW5rIHlvdSBrbm93IGdpdA==" marked="">Scott Chacon’s talk&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#youtube"></use></svg></span></a> about Git less known commands; it is the only
reason why I learned about <code class="hljs">git maintenance</code>.</li>
<li><a href="https://soap.coffee/~lthms/posts/LUKSEncryptedVPS.html" marked="">Installing a LUKS-Encrypted Arch Linux on a Vultr VPS</a> is mostly a
gift I have made to Future Me. It is a very specific how-to that I can use to
quickly set up a new server with disk encryption. Funny story, I was planning
to publish a follow-up about <a href="https://github.com/lthms/nspawn" marked="">how I use systemd-nspawn to run my web services
in containers&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a>, but no matter how many times I tried, I’ve never
quite found a good way to tell this story. As I plan to educate myself on
Kubernetes in 2025, it is not clear I will ever publish it now.</li>
<li><a href="https://soap.coffee/~lthms/posts/BepoNvim.html" marked="">Introducing <code class="hljs">bepo-tsrn.nvim</code></a> is probably the less useful article I
have published in 2024, considering I expect the userbase to <code class="hljs">bepo-tsrn.nvim</code>
to stick to 1 until the very end<label for="fn5" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-right sidenote note"><span class="footnote-p">But who knows? Maybe one of you will prove me wrong! </span>
</span>.</li>
<li><a href="https://soap.coffee/~lthms/posts/VestigialStructures.html" marked="">On Vestigial Structures</a> hardly qualifies as a blog post, and is
mostly a joke. It is also the only content on my website that was mostly
generated by ChatGPT, and it is flagged as such. I don’t like using AI to
<em>write</em>, but I do appreciate having a reviewer always at hand.</li>
<li><a href="https://soap.coffee/~lthms/posts/DreamWebsite.html" marked="">Serving This Article from RAM for Fun and No Real Benefit</a> was very
fun to write. This little experiment was stuck in my head for basically two
years, and it turned out basically exactly as I had pictured it. That being
said, I want to learn about CDNs now.</li>
</ul>
<p>Overall, I still enjoy having my own little corner of the Internet, but if there is
one thing I’d like to improve in 2025, it is its reach. I’d like you folks to
run into my website, instead of having to promote it every time I write
something. 2025, the year of SEO?</p>
<h2><code class="hljs language-bash"><span class="hljs-variable">$WORK</span></code></h2>
<p>2024 started with my decision to go back to a Software Engineering position,
after giving an honest try at being an Engineering Manager in late 2023.</p>
<p>I want to remember 2024 for two things.</p>
<p>This year, more than ever, I have tried to appreciate my work beyond my
individual contributions. I am confident in my programming skills (although I
have so much to learn), but being an accomplished engineer is much more than
contributing code. Making sure every engineer in the team can work to the best
of their current ability, fostering a work environment favoring growth and
initiative, estimating as precisely as possible the amount of time needed to
deliver the next important thing, collaborating efficiently with non-technical
teams... I am becoming increasingly interested in these areas.</p>
<p>Besides, this year was all about delivering and deploying in production. It’s
been a <a href="https://medium.com/etherlink/post-mortem-etherlink-mainnet-beta-public-endpoint-denial-of-service-cfcaf1a7bb77" marked="">wild ride&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>, and I loved it even if it was very demanding. After having
mostly contributed to R&amp;D projects, the focus on UX, backward compatibility,
etc. was very refreshing. I learned so much through the year, and had many
opportunities to make significant impacts.</p>
<p>In 2025, I want to keep learning about software engineering, and maybe start
sharing my thoughts on the subject on my website.</p>
<h2>Talks</h2>
<p>I gave only one talk in 2024, at a conference called <a href="https://ethcc.io/" marked="">EthCC&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>. It was actually a
follow-up to the talk I gave the year before. You can watch me deliver the talk
<a href="https://ethcc.io/archives/being-a-stage-2-rollup-from-day-1-etherlinks-journey" marked="">here&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>, but if you are more into written content, I have also published
a <a href="https://soap.coffee/~lthms/posts/BeingStage2Rollup.html" marked="">transcript</a> on this very website. I actually loved writing it down, and plan
to systematically publish similar content for every recorded talk I will give
in the future.</p>
<p>I also had the opportunity to participate in a <a href="https://x.com/etherlink/status/1852378990712930664" marked="">Twitter Space&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#twitter"></use></svg></span></a>.</p>
<p>This year, my public speaking opportunities were all <code class="hljs language-bash"><span class="hljs-variable">$WORK</span></code>-related. I
would like to change this in the future, because there are enough events out
there for me to start speaking about something other than work<label for="fn6" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-left sidenote note"><span class="footnote-p">It’s too late to apply to FOSDEM, but maybe I can find something to
say to an event later in the year! I think. </span>
</span>.</p>
<h2>Sport</h2>
<p>This year was a bit of a disappointment, sport-wise. I tried several times to
get back to running regularly, and failed miserably. I went to Lyon for a 10km
run without proper training, and skipped the half-marathon I signed up for. I
should update my <a href="https://soap.coffee/~lthms/running.html" marked="">Running Log</a> nonetheless. I started swimming
regularly during the Summer, only to pierce my earlobes in September 😅.</p>
<p>Let’s hope I do better in 2025! I am planning to register for the <a href="https://triathlondeauville.com/" marked="">Triathlon de
Deauville&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a> with my sister. That promises to be fun! And I
want to commit to the <a href="https://vredestein.20kmparis.com/" marked="">20km de Paris&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a> as well.</p>
<p>On the bright side, I have started to use my bike again. I love riding around
Paris, especially at night.</p>
<h2>Final Notes</h2>
<p>Overall, I’ve devoted a large part of my time to <code class="hljs language-bash"><span class="hljs-variable">$WORK</span></code> in 2024.
Hopefully, I will find a better balance over the course of 2025, which should
give me more time to explore and experiment more things.</p>
<p>Anyway, happy new year everyone! And happy Dry January!</p>
        
      

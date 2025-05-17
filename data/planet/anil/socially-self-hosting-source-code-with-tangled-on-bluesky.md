---
title: Socially self-hosting source code with Tangled on Bluesky
description: Self-host source code with Tangled on Bluesky for decentralized Git repositories.
url: https://anil.recoil.org/notes/disentangling-git-with-bluesky
date: 2025-03-08T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<p>I've been an avid user of <a href="https://github.com">GitHub</a> since its launch, and it really has revolutionised how communities come together to work on open source. In recent years though, I find myself utterly overwhelmed by its notifications and want to experiment with <a href="https://www.offlineimap.org/github/2016/03/08/github-pr-suck.html">alternative workflows</a>. This experimentation also has a more serious undertone due to the increasing need for <a href="https://www.boell.de/en/2025/01/24/trump-and-big-tech-europes-sovereignty-stake">data sovereignty</a> and so I'm starting to move my source code to self-hosted solutions that are less reliant on centralised services.</p>
<p>This has also come up persistently over the years in the <a href="https://ocaml.org">OCaml</a> community, with questions over why participation in packaging <a href="https://discuss.ocaml.org/t/publishing-without-github/3232">requires a GitHub account</a> ever since the <a href="https://anil.recoil.org/notes/opam-1-1-beta">early days</a> of opam. I've never found a good answer... until now, with the launch of an exciting <a href="https://tangled.sh">new service</a> that's built over the same protocol that <a href="https://bsky.app">Bluesky</a> uses.
As I <a href="https://anil.recoil.org/notes/atproto-for-fun-and-blogging">noted</a> a few weeks ago, the <a href="https://atproto.com/">ATProto</a> can be used for more than just microblogging. It can also be an <em>identity</em> layer, across which other applications can be built which reuse the social fabric from Bluesky accounts.</p>
<p>"<a href="https://tangled.sh">Tangled</a>" is a new service launched (just yesterday!) by <a href="https://tangled.sh/@oppili.bsky.social">@opilli</a> and <a href="https://tangled.sh/@icyphox.sh">@icyphox</a> to manage Git repositories. I'm having a lot of fun trying it out, even in its early alpha stages!  The coolest thing about Tangled is that you can self-host your own <a href="https://blog.tangled.sh/intro">knots</a>, which control where the source code repositories are actually stored.</p>
<h2>Self hosting my own Tangled knot</h2>
<p>I set up one of the first knots on the network on <code>git.recoil.org</code>, and can now directly share my source code online without depending on GitHub!  For example, this is the <a href="https://tangled.sh/@anil.recoil.org/knot-docker">knot-docker</a> container config which you can use to deploy your own version of this.</p>
<p><a href="https://tangled.sh/@anil.recoil.org/knot-docker"> </a></p><figure class="image-center"><a href="https://tangled.sh/@anil.recoil.org/knot-docker"><img src="https://anil.recoil.org/images/tangled-ss-1.webp" loading="lazy" class="content-image" alt="" srcset="/images/tangled-ss-1.1024.webp 1024w,/images/tangled-ss-1.1280.webp 1280w,/images/tangled-ss-1.1440.webp 1440w,/images/tangled-ss-1.1600.webp 1600w,/images/tangled-ss-1.1920.webp 1920w,/images/tangled-ss-1.320.webp 320w,/images/tangled-ss-1.480.webp 480w,/images/tangled-ss-1.640.webp 640w,/images/tangled-ss-1.768.webp 768w" title="" sizes="(max-width: 768px) 100vw, 33vw"><figcaption></figcaption></a></figure><a href="https://tangled.sh/@anil.recoil.org/knot-docker">
 </a><p></p>
<p>It looks pretty similar to GitHub doesn't it? The first key difference is the login on the top-right, which is the same as my <a href="https://bsky.app/profile/anil.recoil.org">@anil.recoil.org</a> account.  Once you're logged in, the other difference shows up when creating a new Git repository.</p>
<p></p><figure class="image-center"><img src="https://anil.recoil.org/images/tangled-ss-2.webp" loading="lazy" class="content-image" alt="" srcset="/images/tangled-ss-2.1024.webp 1024w,/images/tangled-ss-2.1280.webp 1280w,/images/tangled-ss-2.1440.webp 1440w,/images/tangled-ss-2.1600.webp 1600w,/images/tangled-ss-2.1920.webp 1920w,/images/tangled-ss-2.320.webp 320w,/images/tangled-ss-2.480.webp 480w,/images/tangled-ss-2.640.webp 640w,/images/tangled-ss-2.768.webp 768w" title="" sizes="(max-width: 768px) 100vw, 33vw"><figcaption></figcaption></figure>
<p></p>
<p>As you can see, you can not only select the name of the repository, but also <em>where</em> it's going to be stored. I can either put it on the central Tangled knot, or stick it on my own Recoil one.  After this, the user experience of cloning is as simple as:</p>
<pre><code>git clone https://tangled.sh/@anil.recoil.org/knot-docker
git clone git@git.recoil.org:anil.recoil.org/knot-docker
</code></pre>
<p>In the first case, the central tangled web server proxies the Git contents over HTTP, and for SSH I can just connect directly to my own server.  Inside my Knot container, we can see where the Git repositories are stored:</p>
<pre><code>/home/git # ls -1
did:plc:nhyitepp3u4u6fcfboegzcjw
knotserver.db
knotserver.db-shm
knotserver.db-wal
log
</code></pre>
<p>The <code>did:</code> directory is actually my 'decentralised identifier' from the ATProto, which we can verify by looking up the <a href="https://bsky.social/about/blog/4-28-2023-domain-handle-tutorial">DNS atproto TXT</a> record for my domain:</p>
<pre><code>$ dig txt _atproto.anil.recoil.org
;; ANSWER SECTION:
_atproto.anil.recoil.org. 10799 IN      TXT     "did=did:plc:nhyitepp3u4u6fcfboegzcjw"
</code></pre>
<p>And then if we navigate into that directory, we can see there are just normal bare git repositories stored on my server.</p>
<pre><code>/home/git/did:plc:nhyitepp3u4u6fcfboegzcjw/knot-docker # ls -la
total 24
drwxr-sr-x    4 git      git           4096 Mar  8 19:02 .
drwxr-sr-x    4 git      git           4096 Mar  8 18:23 ..
-rw-r--r--    1 git      git             21 Mar  8 18:01 HEAD
-rw-r--r--    1 git      git             36 Mar  8 18:01 config
drwxr-sr-x   17 git      git           4096 Mar  8 19:02 objects
drwxr-sr-x    4 git      git           4096 Mar  8 18:01 refs
</code></pre>
<p>This makes the core of Tangled very safe to use, even if the service disappears: I maintain the actual git repositories myself, so I can (e.g.) mirror them to GitHub via a simple cron script.</p>
<h2>Collaboration is as simple as Bluesky</h2>
<p>Tangled has only been out for about a day, so I coopted fellow Recoiler <a href="https://nick.recoil.org" class="contact">Nick Ludlam</a> to create an account. I added his <a href="https://bsky.app/profile/nick.recoil.org">handle</a> over to the Recoil knot, and that's all it took for him to be able to create repositories on our server.</p>
<p></p><figure class="image-center"><img src="https://anil.recoil.org/images/tangled-ss-5.webp" loading="lazy" class="content-image" alt="" srcset="/images/tangled-ss-5.1024.webp 1024w,/images/tangled-ss-5.1280.webp 1280w,/images/tangled-ss-5.1440.webp 1440w,/images/tangled-ss-5.1600.webp 1600w,/images/tangled-ss-5.320.webp 320w,/images/tangled-ss-5.480.webp 480w,/images/tangled-ss-5.640.webp 640w,/images/tangled-ss-5.768.webp 768w" title="" sizes="(max-width: 768px) 100vw, 33vw"><figcaption></figcaption></figure>
<p></p>
<p>I can also just add people directly to a particular repository, as you can see from the one below on his profile.</p>
<p><a href="https://tangled.sh/@nick.recoil.org"> </a></p><figure class="image-center"><a href="https://tangled.sh/@nick.recoil.org"><img src="https://anil.recoil.org/images/tangled-ss-3.webp" loading="lazy" class="content-image" alt="" srcset="/images/tangled-ss-3.1024.webp 1024w,/images/tangled-ss-3.1280.webp 1280w,/images/tangled-ss-3.1440.webp 1440w,/images/tangled-ss-3.1600.webp 1600w,/images/tangled-ss-3.1920.webp 1920w,/images/tangled-ss-3.320.webp 320w,/images/tangled-ss-3.480.webp 480w,/images/tangled-ss-3.640.webp 640w,/images/tangled-ss-3.768.webp 768w" title="" sizes="(max-width: 768px) 100vw, 33vw"><figcaption></figcaption></a></figure><a href="https://tangled.sh/@nick.recoil.org">
 </a><p></p>
<h2>The issue metadata is also distributed</h2>
<p>The real lockin to code repository management though, is the metadata around the repository; things like issues, comments and so on. Tangled makes it possible to decentralise where is this stored <a href="https://www.chiark.greenend.org.uk/~sgtatham/quasiblog/git-no-forge/">without needing a central Forge</a>, by relaying it all via the ATProto.
Let's take a look at how this works.</p>
<p>I <a href="https://tangled.sh/@anil.recoil.org/knot-docker/issues/1">created an issue</a> on knot-docker, and it looks very similar to a GitHub issue. Zicklag on <code>#tangled</code> pointed me to the <a href="https://pdsls.dev/">PDSLS</a> public ATProto browser with which you can browse the actual ATProto records. I can start from my <a href="https://pdsls.dev/at://did:plc:nhyitepp3u4u6fcfboegzcjw">DID record</a> and look for the <a href="https://pdsls.dev/at://did:plc:nhyitepp3u4u6fcfboegzcjw/sh.tangled.repo.issue">sh.tangled.repo.issue</a> collection, and find the <a href="https://pdsls.dev/at://did:plc:nhyitepp3u4u6fcfboegzcjw/sh.tangled.repo.issue/3ljvbt4zni322">issue URL from earlier</a>.  I then prodded <a href="https://nick.recoil.org" class="contact">Nick Ludlam</a> to leave a comment on the issue, and you can see his <a href="https://pdsls.dev/at://did:plc:dr3wsy7hlzgyanewhbw7fj5g/sh.tangled.repo.issue.comment/3ljvdsrlckj22">sh.tangled.repo.issue.comment</a> in the relay as well.</p>
<p><a href="https://pdsls.dev/at://did:plc:nhyitepp3u4u6fcfboegzcjw/sh.tangled.repo.issue/3ljvbt4zni322"> </a></p><figure class="image-center"><a href="https://pdsls.dev/at://did:plc:nhyitepp3u4u6fcfboegzcjw/sh.tangled.repo.issue/3ljvbt4zni322"><img src="https://anil.recoil.org/images/tangled-ss-4.webp" loading="lazy" class="content-image" alt="" srcset="/images/tangled-ss-4.1024.webp 1024w,/images/tangled-ss-4.1280.webp 1280w,/images/tangled-ss-4.1440.webp 1440w,/images/tangled-ss-4.1600.webp 1600w,/images/tangled-ss-4.320.webp 320w,/images/tangled-ss-4.480.webp 480w,/images/tangled-ss-4.640.webp 640w,/images/tangled-ss-4.768.webp 768w" title="" sizes="(max-width: 768px) 100vw, 33vw"><figcaption></figcaption></a></figure><a href="https://pdsls.dev/at://did:plc:nhyitepp3u4u6fcfboegzcjw/sh.tangled.repo.issue/3ljvbt4zni322">
 </a><p></p>
<p>Even the <a href="https://bsky.app/profile/tangled.sh/post/3ljv6wpioxc2q">repository stars</a> are on the relay; see for example <a href="https://pdsls.dev/at://did:plc:nhyitepp3u4u6fcfboegzcjw/sh.tangled.feed.star/3ljvbtbrhew22">this</a> entry for <a href="https://pdsls.dev/at://did:plc:nhyitepp3u4u6fcfboegzcjw/sh.tangled.repo/3ljv45bhfql22">knot-docker</a> that I did. The Tangled developers just added support for stars <a href="https://tangled.sh/@tangled.sh/core/commit/662bd012caec9c2bd2a15e1dcfe184d5b2c49ff9#file-lexicons/star.json">a few hours ago</a>, and that changeset is a nice way to see how to add a new lexicon entry.</p>
<p><a href="https://bsky.app/profile/wedg.dev" class="contact">Samuel Wedgwood</a> then reminded me of his project a few years ago to run <a href="https://anil.recoil.org/ideas/version-control-matrix">git pull requests over Matrix chat</a>. It would indeed be very cool if the pull request model on Tangled evolved into something more message-oriented like <a href="https://git-scm.com/docs/git-send-email">git-send-email</a>, in order to let us try out more personalised workflows than GitHub PRs.</p>
<h2>Why this fits in so well with the rest of Bluesky</h2>
<p>The ATProto developers also released their <a href="https://docs.bsky.app/blog/2025-protocol-roadmap-spring">roadmap for early 2025</a> today, and it aligns really well with some of the productions features I would need to completely shift over to a service like Tangled.</p>
<p>The first, and most vital one, is <a href="https://docs.bsky.app/blog/2025-protocol-roadmap-spring#auth-scopes">auth scopes</a> to control the permissions of an app password to only certain operations. Once this is in the protocol, then a client to manage Tangled repositories could use a differently privileged password from the main social client.</p>
<p>Secondly, <a href="https://docs.bsky.app/blog/2025-protocol-roadmap-spring#privately-shared-data-and-e2ee-dms">privately shared data</a> and <a href="https://www.ietf.org/blog/mls-secure-and-usable-end-to-end-encryption/">encrypted DMs using MLS</a> point to how private code repositories could work. <a href="https://svr-sk818-web.cl.cam.ac.uk/keshav/wiki/index.php/Main_Page" class="contact">Srinivasan Keshav</a> and I were discussing the difficulty of access-controlled replication over the Internet just yesterday, and I'm starting to believe that ATProto has the right balance of ergonomics and good design to make solving this problem much, much easier.</p>
<p>If you'd like to try this out, then the <a href="https://tangled.sh/@anil.recoil.org/knot-docker/">Knot Docker</a> repository welcomes your issues!</p>
<small class="credits">
<p>Many thanks to Zicklag and icyphox on <a href="https://web.libera.chat/#tangled">tangled IRC</a> for helping me out with debugging the Knot setup and <a href="https://tangled.sh/@tangled.sh/core/commit/477da124ad0bdeeab5b621b81999683256ab7a4b">fixing bugs in real-time</a>. 12th Mar 2025: updated with <a href="https://bsky.app/profile/wedg.dev" class="contact">Samuel Wedgwood</a> comments.</p>
</small>


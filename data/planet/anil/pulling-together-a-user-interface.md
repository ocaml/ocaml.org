---
title: Pulling together a user interface
description: Building a user interface for personal containers on App Engine with
  extjs.
url: https://anil.recoil.org/notes/uiprototype
date: 2010-04-15T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<p>We’ve been <a href="http://github.com/avsm/perscon">hacking</a> away on fleshing out the <a href="http://code.google.com/appengine">App Engine</a> node for personal containers. We’re building this node first because, crucially, deploying an App Engine VM is free to anyone with a Google account.  The service itself is limited since you can only respond to HTTP or XMPP requests and do HTTP fetches, and so its primary use is as an always-on data collection service with a webmail-style UI written using <a href="http://www.extjs.com/">extjs</a>.</p>
<p>Personal containers gather data from a wide variety of sources, and normalise them into a format which understands people (address book entries, with a set of services such as e-mail, phone, IM and online IDs), places (GPS, WOEID), media (photos, movies) and messages (Tweets, emails, Facebook messages). I’ll post more about the data model behind personal containers in a follow-up as the format settles.</p>
<p></p><figure class="image-center"><img src="https://anil.recoil.org/images/perscon-extjs.webp" loading="lazy" class="content-image" alt="" srcset="/images/perscon-extjs.1024.webp 1024w,/images/perscon-extjs.320.webp 320w,/images/perscon-extjs.480.webp 480w,/images/perscon-extjs.640.webp 640w,/images/perscon-extjs.768.webp 768w" title="" sizes="(max-width: 768px) 100vw, 33vw"><figcaption></figcaption></figure>
<p></p>
<p>The App Engine node has a number of plugins to gather data and aggregate them into a single view (see screenshot). Plugins include:</p>
<ul>
<li><a href="http://github.com/avsm/perscon/tree/master/plugins/iPhoto/">iPhoto</a> extracts location (via EXIF), people present (associated via <a href="http://gizmodo.com/5141741/what-to-know-about-iphoto-09-face-detection-and-recognition">faces</a>), and of course, the actual photograph.</li>
<li><a href="http://github.com/avsm/perscon/tree/master/plugins/Adium/">Adium</a> logs all IMs into a threaded chat view.  -   <a href="http://github.com/avsm/perscon/tree/master/plugins/iPhone/">iPhone</a> uses the backup files on a Mac to extract SMS messages, phone call records (and it could also get photographs and browsing history, although it currently doesn’t). An AppEngine tracker can also use <a href="http://www.apple.com/mobileme/features/find-my-iphone.html">FindMyIPhone</a> to poll your iPhone regularly to keep track of your location without publishing it to Google or Yahoo (and hopefully in iPhone 4.0, we can operate as a background service at last!).</li>
<li><a href="http://github.com/avsm/perscon/tree/master/appengine/twitter.py">Twitter</a> runs directly on AppEngine (authenticated via OAuth) and synchronizes with a Twitter feed.</li>
<li><a href="http://github.com/avsm/perscon/tree/master/plugins/MacOS-SyncServices/">SyncServices</a> hooks into the MacOS X <a href="http://developer.apple.com/macosx/syncservices.html">sync framework</a> and initially subscribes to Address Book updates. This seems to be the first open-source sync alternative to the expensive Mobile Me, as far as I can tell. I’m planning to expand this to also subscribe to the full set of sync information (e.g. calendars).</li>
</ul>
<p>I'm switching tacks briefly; we received an <a href="http://aws.amazon.com/education/aws-in-education-research-grants/">Amazon Research Grant</a> recently and I’m building a node that runs as a Linux server to act as a longer-term archival and search server. This is being written in OCaml and uses <a href="http://1978th.net/tokyocabinet/">Tokyo Cabinet</a> (with Jake Donham’s excellent <a href="http://github.com/jaked/otoky">bindings</a>) and so should be speedy and a useful alternative implementation of the HTTP REST interface. The plan is to automatically synchronize meta-data across all the nodes of a personal container, but store large and historical data away from expensive cloud storage such as App Engine.</p>
<p>There are lots more plugins in development, such as <a href="http://foursquare.com">Foursquare</a> and <a href="http://gowalla.com">Gowalla</a> OAuth collectors, an <a href="http://github.com/avsm/perscon/tree/master/android">Android</a> mobile application to upload location and contacts information, and Google GData synchronization. If you’re interested in one of these or something else, please do <a href="http://perscon.net/contact.html">get in touch</a> or just fork the <a href="http://github.com/avsm/perscon">project</a> and start hacking!</p>


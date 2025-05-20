---
title: Ubiquitous Interaction Devices
description:
url: https://anil.recoil.org/projects/ubiqinteraction
date: 2003-01-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
ignore: true
---

<div>
  <h1>Ubiquitous Interaction Devices</h1>
  <p></p><p>I investigated how to interface the new emerging class of smartphone devices
(circa 2002) with concepts from ubiquitous computing such as location-aware
interfaces or context-aware computing. I discovered the surprisingly positive
benefits of piggybacking on simple communications medium such as audible sound
and visual tags. Our implementations of some of these ended up with new audio
ringtone and visual smart tags that worked on the widely deployed mobile phones
of the era.</p>
<p>In 2003, the mobile phone market had grown tremendously and given the average
consumer access to cheap, small, low-powered and constantly networked devices
that they could reliably carry around. Similarly, laptop computers and PDAs
became a common accessory for businesses to equip their employees with when on
the move.  The research question then, was how to effectively interface them
with existing digital infrastructure and realise some of the concepts of
ubiquitous computing such as location-aware interfaces or context-aware
computing.</p>
<p>Ubiquitous Interaction Devices (see <a href="https://www.cl.cam.ac.uk/research/srg/netos/projects/archive/uid/">original webpages</a>)
was a project I started with <a href="https://github.com/djs55" class="contact">Dave Scott</a> and <a href="mailto:richard.sharp@gmail.com" class="contact">Richard Sharp</a> in 2003 to work on this at
the Cambridge Computer Laboratory and Intel Research Cambridge (who had just
set up a "lablet" within our building and was a great source of free coffee).</p>
<h2>Audio Networking</h2>
<p>The project kicked off when we randomly experimented with our fancy Nokia smartphones
and discovered that they didn't have anti-aliasing filters on the microphones.
This allowed us to record and decode ultrasound between the phones. The
2003 <a href="https://anil.recoil.org/papers/audio-networking">Context-Aware Computing with Sound</a> in Ubicomp describes some of the applications it
allowed.</p>
<p>In a nutshell, audio networking used ubiquitously available sound hardware
(i.e, speakers, soundcards and microphones) for low-bandwidth wireless networking.
It has a number of characteristics which differentiate it from existing wireless technologies:</p>
<ul>
<li>fine-grained control over the range of transmission by adjusting the volume.</li>
<li>walls of buildings are typically designed to attenuate sound waves, making it easy to contain transmission to a single room (unlike, for example, Wifi or Bluetooth).</li>
<li>existing devices can play or record audio to be networked easily (e.g. voice recorders).</li>
</ul>
<p>The <em>Audionotes</em> video below demonstrates an Audio Pick and Drop Interface: an Internet URL is recorded into a PDA via a standard computer speaker. The URL is later retrieved from the PDA by playing it into the computer, and also printed by carrying the PDA to a print server and playing back the recorded identifier.
A great advantage of this is that any cheap voice recorder is capable of carrying the audio information (e.g. mobile phone, PDA, dictaphone, etc).</p>
<p>One of the more interesting discoveries during this research is that most computer soundcards do not have good anti-aliasing filters fitted, resulting in them being able to send and receive inaudible sound at upto 24 Khz (assuming a 48 KHz soundcard).
We used this to create a set of inaudible location beacons that would allow laptop computers to simply listen using their microphones and discover their current location without any advanced equipment being required! The <em>location</em> video below demonstrates this.</p>
<p></p><div class="video-center"><iframe title="" width="100%" height="315px" src="https://crank.recoil.org/videos/embed/f75b6a17-1dbb-450c-8938-8b5bcbd9896a" frameborder="0" allowfullscreen="" sandbox="allow-same-origin allow-scripts allow-popups allow-forms"></iframe></div><p></p>
<p></p><div class="video-center"><iframe title="" width="100%" height="315px" src="https://crank.recoil.org/videos/embed/cda6e8e1-6f64-4f6f-aab0-8dc615836a51" frameborder="0" allowfullscreen="" sandbox="allow-same-origin allow-scripts allow-popups allow-forms"></iframe></div><p></p>
<p>We then devised a scheme of encoding data into mobile phone ringtones while still making them sound pleasant to the ear. This allows us to use the phone network for the video example above: an SMS 'capability' is transmitted to a phone, which can be played back to gain access to a building.
Since the data is just a melody, this allows for uses such as parents purchasing cinema tickets online for their children (who dont own a credit card), yet still allowing the children to gain access to the cinema by playing the ringtone capability back (via their mobile phones, common among children).</p>
<p>We observed that audio networking allows URLs to be easily sent over a telephone conversation, and retrieved over a normal high bandwidth connection by the recipient.
This gets over the real awkwardness of "locating" someone on the Internet, which is rife with restrictive firewalls and Network Address Translation which is destroying end-to-end connectivity. In contrast, it is trivial to locate someone on the phone network given their telephone number, but harder to perform high bandwidth data transfers (which the Internet excels at).  There's more detail on these usecases in <a href="https://anil.recoil.org/papers/2005-ieee-smartphones">Using smart phones to access site-specific services</a>.</p>
<p></p><div class="video-center"><iframe title="" width="100%" height="315px" src="https://crank.recoil.org/videos/embed/c7da2f1a-1ae5-4c54-aaf7-4b6fed6c2773" frameborder="0" allowfullscreen="" sandbox="allow-same-origin allow-scripts allow-popups allow-forms"></iframe></div><p></p>
<p></p><div class="video-center"><iframe title="" width="100%" height="315px" src="https://crank.recoil.org/videos/embed/f75b6a17-1dbb-450c-8938-8b5bcbd9896a" frameborder="0" allowfullscreen="" sandbox="allow-same-origin allow-scripts allow-popups allow-forms"></iframe></div><p></p>
<h2>SpotCode Interfaces</h2>
<p>Once we'd had such success with audible networking, a natural next step was to use the new fancy cameras present on smartphones. <a href="mailto:eben@phlegethon.org" class="contact">Eben Upton</a> joined our project and knocked up a real-time circular barcode detector for Symbian operating system phones in short order that we demonstrated in <a href="https://anil.recoil.org/papers/2004-ubicomp-camera">Using Camera-Phones to Enhance Human-Computer Interaction</a>.</p>
<p>The phone app we built could detect our circular barcodes in realtime, unlike the ungainly "click and wait" experiences of the time.  Since the phone computes the relative rotation angle of detected tags in real-time, an intuitive "volume control" was possible by simple locking onto a tag and physically rotating the phone. The videos demonstrates a volume control in the "SpotCode Jukebox", and how further interfaces could be "thrown" to the phone for detailed interactions.</p>
<p></p><div class="video-center"><iframe title="" width="100%" height="315px" src="https://crank.recoil.org/videos/embed/6b90fd6b-b88a-4bab-8943-371776dcda64" frameborder="0" allowfullscreen="" sandbox="allow-same-origin allow-scripts allow-popups allow-forms"></iframe></div><p></p>
<p></p><div class="video-center"><iframe title="" width="100%" height="315px" src="https://crank.recoil.org/videos/embed/67fb611f-42d0-43b2-9961-93b2b7425750" frameborder="0" allowfullscreen="" sandbox="allow-same-origin allow-scripts allow-popups allow-forms"></iframe></div><p></p>
<p>We then built some more elaborate public applications (such as a travel booking shop) in <a href="https://anil.recoil.org/papers/2004-spotcodes">Using camera-phones to interact with context-aware mobile services</a> and <a href="https://anil.recoil.org/papers/2005-ieee-smartphones">Using smart phones to access site-specific services</a>).  When <a href="https://www.cst.cam.ac.uk/people/eft20" class="contact">Eleanor Toye Scott</a> joined the project, we subsequently conducted structured user studies to see how effective the tags are in <a href="https://anil.recoil.org/papers/2006-puc-tags">Interacting with mobile services: an evaluation of camera-phones and visual tags</a>. As a side-note, the whole zooming interface was written using OCaml and OpenGL.
We spun out a startup company called High Energy Magic Ltd., and got into the <a href="https://www.nytimes.com/2004/10/07/technology/circuits/connecting-paper-and-online-worlds-by-cellphone-camera.html">New York Times</a> and <a href="https://www.wired.com/2004/06/from-the-prawn-of-time/">Wired</a> (alongside a decaying prawn sandwich).</p>
<p></p><div class="video-center"><iframe title="" width="100%" height="315px" src="https://crank.recoil.org/videos/embed/f2144cf5-16ee-4373-8a81-e5b8b2263f6b" frameborder="0" allowfullscreen="" sandbox="allow-same-origin allow-scripts allow-popups allow-forms"></iframe></div><p></p>
<p></p><div class="video-center"><iframe title="" width="100%" height="315px" src="https://crank.recoil.org/videos/embed/fa57ea22-6158-4143-b533-24bd439e0717" frameborder="0" allowfullscreen="" sandbox="allow-same-origin allow-scripts allow-popups allow-forms"></iframe></div><p></p>
<p>It also became obvious that the technology was also really robust, since it worked fine on printed (and crumpled) pieces of paper, making it ideal for public signage.  We used this to experiment with more robust device discovery in <a href="https://anil.recoil.org/papers/2005-mc2r-visualtags">Using visual tags to bypass Bluetooth device discovery</a>. This subsequently lead us to show how smartphones could be trusted side-channels in <a href="https://anil.recoil.org/papers/2008-mobisys-splittrust">Enhancing web browsing security on public terminals using mobile composition</a>, an idea that is now (as of 2020) becoming realised with trusted computing chips in modern smartphones.</p>
<p></p><div class="video-center"><iframe title="" width="100%" height="315px" src="https://crank.recoil.org/videos/embed/9ef069e9-0aee-4c51-87c3-e09625711f99" frameborder="0" allowfullscreen="" sandbox="allow-same-origin allow-scripts allow-popups allow-forms"></iframe></div><p></p>
<p></p><div class="video-center"><iframe title="" width="100%" height="315px" src="https://crank.recoil.org/videos/embed/cc75883b-379e-467b-81ca-736a13671f8e" frameborder="0" allowfullscreen="" sandbox="allow-same-origin allow-scripts allow-popups allow-forms"></iframe></div><p></p>
<h2>Towards smarter environments</h2>
<p>At the Computer Laboratory, we also happen to have one of the world's best indoor location systems (the <a href="https://en.wikipedia.org/wiki/Active_Bat">Active Bat</a>), which we inherited from AT&amp;T Research when that shut down in Cambridge.  <a href="mailto:ripduman.sohan@gmail.com" class="contact">Ripduman Sohan</a>, <a href="https://liquidx.net" class="contact">Alastair Tse</a> and <a href="mailto:kieran@recoil.org" class="contact">Kieran Mansley</a> joined forces with us to investigate how commodity hardware could interface with this smart location system to make really futuristic buildings possible.</p>
<p>A few really fun projects resulted from this:</p>
<ul>
<li>We used the BAT system to help with Bluetooth-based indoor location inference, in <a href="https://anil.recoil.org/papers/2005-ubicomp-bluetooth">A Study of Bluetooth Propagation Using Accurate Indoor Location Mapping</a>.</li>
<li>Interfaced the audio networking with the AT&amp;T "broadband phones" in <a href="https://anil.recoil.org/papers/2005-bbphone">The Broadband Phone Network: Experiences with Context-Aware Telephony</a>.</li>
<li>We constructed a real-time capture the flag game in the Computer Lab with augmented reality "windows" into the game in <a href="https://anil.recoil.org/papers/netgames04-ctf">Feedback, latency, accuracy: exploring tradeoffs in location-aware gaming</a>.</li>
<li>I worked with my Recoil-in-chief <a href="https://nick.recoil.org" class="contact">Nick Ludlam</a> on digital TV interfaces in <a href="https://anil.recoil.org/papers/2005-ubiapp-ubimedia">Ubiquitious Computing needs to catch up with Ubiquitous Media</a>.</li>
</ul>
<p>In around 2005, we sold High Energy Magic Ltd. to a <a href="https://www.youtube.com/watch?v=sN01wkRzsfk">Dutch entrepreneur</a> so that <a href="mailto:richard.sharp@gmail.com" class="contact">Richard Sharp</a>, <a href="https://github.com/djs55" class="contact">Dave Scott</a> and I could join the <a href="https://anil.recoil.org/projects/xen">Xen Hypervisor</a> startup company.   However, the ubiquitous computing ideals that drove much of our work continue to persist, and in 2018 I started thinking about this again as part of my <a href="https://anil.recoil.org/projects/osmose">Interspatial OS</a> project.  The idea of building truely ubiquitous environments (without smartphones) is resurrected again there, and you can start reading about it in <a href="https://anil.recoil.org/papers/2018-hotpost-osmose">An architecture for interspatial communication</a>.</p>
<p></p>
</div>


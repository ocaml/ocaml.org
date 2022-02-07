---
title: 7th MirageOS hack retreat
description: "Let's talk sun, mint tea and OCaml: Yes, you got it, the MirageOS biennial
  retreat at Marrakesh! For the 7th iteration of the retreat, the\u2026"
url: https://tarides.com/blog/2019-05-06-7th-mirageos-hack-retreat
date: 2019-05-06T00:00:00-00:00
preview_image: https://tarides.com/static/c18127602edbf62c47c7d5df165b2d8b/0132d/moroccan_plates.jpg
featured:
---

<p>Let's talk sun, mint tea and OCaml: Yes, you got it, the <a href="http://retreat.mirage.io">MirageOS biennial retreat</a> at Marrakesh!</p>
<p>For the 7th iteration of the retreat, the majority of the Tarides team took part in the trip to the camels country.
This is a report about what we produced and enjoyed while there.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#charles-edouard-lecat" aria-label="charles edouard lecat permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Charles-Edouard Lecat</h1>
<p>That's it, my first MirageOS retreat is coming soon, let's jump in the plane and here I come. After a nice cab trip and an uncountable number of similar streets, I'm finally at the Riad which will host me for the next 5 days.</p>
<p>It now begins the time to do what I came for: Code, Eat, Sleep and Repeat</p>
<p>I mostly worked on <a href="https://github.com/mirage/colombe">Colombe</a>, the OCaml implementation of the SMTP protocol for which I developed a simple client.
Except some delayed problems (like the integration of the MIME protocol, the TLS wrapping and some others), the client was working perfectly :)
Implementing it was actually really easy as the core of the SMTP protocol was done by @dinosaure who developed over time a really nice way of implementing this kind of API. And as I spend most of my time at Tarides working on his code, I feel really comfortable with it.</p>
<p>One of the awesome thing about this retreat was the people who came: There was so many interesting people, doing various thing, so each time someone had an interrogation, you could almost be sure that someone could help you in a way or another.</p>
<p>But sadly, as I arrived few days after everyone, and just before the week-end, the time flew away reaaaaaally fast, and I did not have the time to do some major code, but I'm already looking forward to the next retreat which, I am sure, will be even more fruitful and attract a lot of nice OCaml developers.</p>
<p>Until then, I will just dream about the awesome food I ate there ;)</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#lucas-pluvinage" aria-label="lucas pluvinage permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Lucas Pluvinage</h1>
<p>Second Mirage retreat for me, and this time I had plans: make a small web game with Mirage hosted by an ESP32 device. I figured out that there was not canonical way to make an HTTP/Websocket server with Mirage and I didn't want to stick to a particular library.</p>
<p>Instead, I took my time to develop <code>mirage-http</code>, an abstraction of HTTP that can either have <code>cohttp</code> or <code>httpaf</code> as a backend. On top of that, I've build <code>mirage-websocket</code> which is therefore an HTTP server-independant implementation of websockets (indeed this has a lot of redundancies with <code>ocaml-websocket</code> but for now it's a proof of concept). While making all this I discussed with @anmonteiro who's the Webservers/protocols expert for Mirage ! However I didn't have the time to build something on top of that, but this is still something that I would like achieve at some point.</p>
<p>I also became the &quot;dune guy&quot; as I'm <a href="https://github.com/mirage/mirage/issues/969">working on the Mirage/dune integration</a>, and helped some people with their build system struggles.</p>
<p>It was definitely a rich week, I've learnt a lot of things, enjoyed the sun, ate good food and contributed to the Mirage universe !</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#jules-aguillon" aria-label="jules aguillon permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Jules Aguillon</h1>
<p>This was my first retreat.
It was the occasion to meet OCaml developers from all over the world.
The food was great and the weather perfect.</p>
<p>I submitted some PRs to the OCaml compiler !</p>
<ul>
<li>Hint on type error on int literal <a href="https://github.com/ocaml/ocaml/pull/2301">PR #2301</a>.
It's adding an hint when using <code>int</code> literals instead of other number literals (eg. <code>3</code> instead of <code>3.</code> or <code>3L</code>):</li>
</ul>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">Line 2, characters 20-21:
2 | let _ = Int32.add a 3
                        ^
Error: This expression has type int but an expression was expected of type
          int32
        Hint: Did you mean `3l'?</code></pre></div>
<ul>
<li>Hint on type error on int operators <a href="https://github.com/ocaml/ocaml/pull/2307">PR #2307</a>. Hint the user when using numerical operators for ints (eg. <code>+</code>) on other kind of numbers (eg. <code>float</code>, <code>int64</code>, etc..). For example:</li>
</ul>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">Line 8, characters 8-9:
8 | let _ = x + 1.
            ^
Error: This expression has type float but an expression was expected of type
          int
Line 8, characters 10-11:
8 | let _ = x + 1.
              ^
  Hint: Did you mean to use `+.'?</code></pre></div>
<ul>
<li>
<p>Clean up int literal hint <a href="https://github.com/ocaml/ocaml/pull/2313">PR #2313</a>. A little cleanup of the 2 previous PRs.</p>
</li>
<li>
<p>Hint when the expected type is wrapped in a ref <a href="https://github.com/ocaml/ocaml/pull/2319">PR #2319</a>. An other PR adding an hint: When the user forgot to use the <code>!</code> operator on <code>ref</code> values:</p>
</li>
</ul>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">Line 2, characters 8-9:
2 | let b = a + 1
            ^
Error: This expression has type int ref
        but an expression was expected of type int
  Hint: This is a `ref', did you mean `!a'?</code></pre></div>
<p>The first 3 are merged now.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#gabriel-de-perthuis" aria-label="gabriel de perthuis permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Gabriel de Perthuis</h1>
<p>For this retreat my plan was to do something a little different and work on Solo5.</p>
<p><a href="https://github.com/mirage/wodan">Wodan</a>, the storage layer I'm working on,
needs two things from its backends which are not commonly implemented:</p>
<ul>
<li>support for discarding unused blocks (first implemented in mirage-block-unix), and</li>
<li>support for barriers, which are ordering constraints between writes</li>
</ul>
<p>Solo5 provides relevant mirage backends, which are themselves provided by various
virtualised implementations.  Discard was added to most of those, at least those
that were common enough to be easily tested; we just added an &quot;operation not supported&quot;
error code for the other cases.</p>
<p>The virtio implementation was interesting; recent additions to the spec allow discard
support, but few virtual machine managers actually implement that on the backend side.
I tried to integrate with the Chromium OS &quot;crosvm&quot; for that, and had a good time
figuring out how it found the bootloader entry point (turns out the cpu was happily
skipping past invalid instructions to find a slightly misaligned entry point), but
ran out of time to figure out the rest of the integration, which seemed to be more
complex that anticipated.  Because of this virtio discard support will be skipped over
for now.</p>
<p>I also visited the souk, which was an interesting experience.
Turns out I'm bad at haggling, but I brought back interesting things anyway.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#conclusion" aria-label="conclusion permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Conclusion</h1>
<p>We'd like to thank Hannes Mehnert who organized this retreat and all the attendees who contributed to make it fruitful and inspiring.
You want to take part in the next MirageOS retreat? Stay tuned <a href="http://retreat.mirage.io">here</a>.</p>

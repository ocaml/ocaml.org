---
title: Viewing web logs the old fashioned way with Goaccess
description:
url: https://anil.recoil.org/notes/goaccess-for-logs
date: 2025-04-23T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<p>Like many <a href="https://anil.recoil.org/notes/ai-ietf-aiprefs">others</a>, my website is under a constant barrage of crawling from bots. I need to figure out which one is hosing me, but I am also resisting having third-party trackers of any form. I took a look at hosting a <a href="https://plausible.io/">Plausible</a> instance as <a href="https://plausible.ci.dev/ocaml.org">OCaml does</a>, but it's yet another service to run and maintain. Then <a href="https://nick.recoil.org" class="contact">Nick Ludlam</a> pointed me to an old-fashioned server-side log analyser with builtin privacy called <a href="https://goaccess.io">Goaccess</a> he's using on his <a href="https://nick.recoil.org">site</a>, which is also perfect for my needs!</p>
<p>Setting up Goaccess is extremely simple. It's a single binary with no dependencies outside of ncurses, and just needs some server side logs.  I currently use <a href="https://caddyserver.com">Caddy</a> to front the HTTP2/3 for my custom OCaml webserver, so I just had to configure it to output JSON-format logs.</p>
<pre><code>anil.recoil.org {
        reverse_proxy http://localhost:8080
        encode zstd gzip
        log {
                format json
                output file /var/log/caddy/anil.recoil.org.log {
                        roll_size 1gb
                        roll_keep 100
                }
        }
}
</code></pre>
<p>The above causes Caddy to log lines in a JSON format like this:</p>
<pre><code class="language-json">{ "level": "info", "ts": 1745414562.426229,
  "logger": "http.log.access.log0",
  "msg": "handled request",
  "request": {
    "remote_ip": "&lt;snip&gt;", "remote_port": "56839",
    "client_ip": "&lt;snip&gt;", "proto": "HTTP/3.0",
    "method": "GET", "host": "anil.recoil.org",
    "uri": "/assets/home.svg",
    "headers": {
      "Sec-Fetch-Dest": [ "image" ],
      "Sec-Fetch-Site": [ "same-origin" ],
      "Sec-Fetch-Mode": [ "no-cors" ],
      "Priority": [ "u=5, i" ],
      "Accept-Encoding": [ "gzip, deflate, br" ],
      "Accept": [
        "image/webp,image/avif,image/jxl,image/heic,image/heic-sequence,video/*;q=0.8,image/png,image/svg+xml,image/*;q=0.8,*/*;q=0.5" ],
      "User-Agent": [
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.3.1 Safari/605.1.15"
      ],
      "Referer": [ "https://anil.recoil.org/" ],
      "Accept-Language": [ "en-GB,en;q=0.9" ]
    },
    "tls": {
      "resumed": false, "version": 772, "cipher_suite": 4865,
      "proto": "h3", "server_name": "anil.recoil.org"
    }
  }, &lt;...etc&gt;
}
</code></pre>
<p>While this is a verbose logging format, it compresses very well and has lots of information that can be analysed without the need for any JavaScript. Once the logging is setup, just running <code>goaccess &lt;logfile&gt;</code> spins up a curses configuration from which I can select the Caddy log format.</p>
<p></p><figure class="image-center"><img src="https://anil.recoil.org/images/goaccess-ss-1.webp" loading="lazy" class="content-image" alt="" srcset="/images/goaccess-ss-1.1024.webp 1024w,/images/goaccess-ss-1.1280.webp 1280w,/images/goaccess-ss-1.1440.webp 1440w,/images/goaccess-ss-1.1600.webp 1600w,/images/goaccess-ss-1.320.webp 320w,/images/goaccess-ss-1.480.webp 480w,/images/goaccess-ss-1.640.webp 640w,/images/goaccess-ss-1.768.webp 768w" title="" sizes="(max-width: 768px) 100vw, 33vw"><figcaption></figcaption></figure>
<p></p>
<p>After that, there is a simple interactive terminal dashboard that not only shows the usual analytics, but also fun things like operating system and time-of-access frequency patterns.</p>
<p></p><figure class="image-center"><img src="https://anil.recoil.org/images/goaccess-ss-2.webp" loading="lazy" class="content-image" alt="" srcset="/images/goaccess-ss-2.1024.webp 1024w,/images/goaccess-ss-2.1280.webp 1280w,/images/goaccess-ss-2.1440.webp 1440w,/images/goaccess-ss-2.1600.webp 1600w,/images/goaccess-ss-2.1920.webp 1920w,/images/goaccess-ss-2.2560.webp 2560w,/images/goaccess-ss-2.320.webp 320w,/images/goaccess-ss-2.3840.webp 3840w,/images/goaccess-ss-2.480.webp 480w,/images/goaccess-ss-2.640.webp 640w,/images/goaccess-ss-2.768.webp 768w" title="" sizes="(max-width: 768px) 100vw, 33vw"><figcaption></figcaption></figure>
<p></p>
<p>The tool can also blank out IP addresses in order to preserve privacy in the output analytics, and also spit out an <a href="https://theorangeone.net/posts/goaccess-analytics/">HTML report</a>, although I'm not using this particular functionality.  While Plausible looks like the answer for bigger sites, this simple tool is good enough for me. The very first iteration of this site in 1998 used to use <a href="https://en.wikipedia.org/wiki/Analog_(program)">Analog</a> (written by my former Xen/Docker colleague Stephen Turner), so it's nice to go back full circle to this sort of tool again!</p>


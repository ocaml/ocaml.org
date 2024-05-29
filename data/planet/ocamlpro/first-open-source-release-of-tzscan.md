---
title: First Open-Source Release of TzScan
description: In October 2017, after the Tezos ICO, OCamlPro started to work on a block
  explorer for Tezos. For us, it was the most important software that we could contribute
  to the community, after the node itself, of course. We used it internally to monitor
  the Tezos alphanet, until its official public release...
url: https://ocamlpro.com/blog/2018_11_08_first_open_source_release_of_tzscan
date: 2018-11-08T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Fabrice Le Fessant\n  "
source:
---

<p>In October 2017, after the Tezos ICO, OCamlPro started to work on a
block explorer for Tezos. For us, it was the most important software
that we could contribute to the community, after the node itself, of
course. We used it internally to monitor the Tezos alphanet, until its
official public release in February 2018, as
<a href="https://tzscan.io">TzScan</a>. One of TzScan main goals was to make the
complex DPOS consensus algorithm of Tezos easier to understand, to
follow, especially for bakers who will contribute to it. Since its
creation, we have been improving it every day, rushing for the Betanet
in June 2018, and still now, monitoring all the Tezos networks,
Mainnet, Alphanet and Zeronet.</p>
<p>So we are pleased today to announce the first release of TzScan OS, the open-source version of TzScan!</p>
<ul>
<li>
<p>The sources are available on Gitlab:
<a href="https://gitlab.com/tzscan/tzscan">https://gitlab.com/tzscan/tzscan</a></p>
</li>
<li>
<p>The code, mostly OCaml, is distributed under <a href="https://www.gnu.org/licenses/gpl-3.0.en.html">GNU GPL
v3</a>.</p>
</li>
</ul>
<p>The project contains:</p>
<p><img src="https://ocamlpro.com/blog/assets/img/TzScanOS.png" alt="TZScan architecture schema"/></p>
<ul>
<li>
<p>The blockchain crawler, used to monitor the blockchain, and fill a PostgreSQL database</p>
</li>
<li>
<p>The web interface, requesting information using a REST API</p>
</li>
<li>
<p>The API server, using the PostgreSQL database to reply to API requests</p>
</li>
</ul>
<p>It can be used in two different modes:</p>
<ul>
<li>
<p>Remote Use: if you are not running a Tezos node, you might want to
only run the web interface, using the official TzScan API server</p>
</li>
<li>
<p>Local Use: if you are running a Tezos node, you can use the crawler
and the API server to serve information on your node, to a locally
running web interface</p>
</li>
</ul>
<h2>Contribute</h2>
<p>If you are interested in contributing to TzScan OS, a first step could
be to translate TzScan in your language : check the file
<a href="https://gitlab.com/tzscan/tzscan/blob/master/static/lang-en.json">lang-en.json</a>
for a list of strings to translate, and
<a href="https://gitlab.com/tzscan/tzscan/blob/master/static/lang-fr.json">lang-fr.json</a>
for a partial translation!</p>
<h2>OCamlPro&rsquo;s services around TzScan</h2>
<p>TzScan OS can be used to monitor private/enterprise deployments of Tezos. OCamlPro is available to help and support such deployments.</p>
<h2>Acknowledgments</h2>
<p>We are thankful to the Tezos Foundation and Ryan Jesperson for their support!</p>
<p>All feedback is welcome!</p>


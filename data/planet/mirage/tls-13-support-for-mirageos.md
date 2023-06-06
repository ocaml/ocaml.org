---
title: TLS 1.3 support for MirageOS
description:
url: https://mirage.io/blog/tls-1-3-mirageos
date: 2020-05-20T00:00:00-00:00
preview_image:
featured:
authors:
- Hannes Mehnert
---


        <p>We are pleased to announce that <a href="https://en.wikipedia.org/wiki/Transport_Layer_Security#TLS_1.3">TLS 1.3</a> support for MirageOS is available. With
mirage 3.7.7 and tls 0.12 the <a href="https://tools.ietf.org/html/rfc8446">Transport Layer Security (TLS) Protocol Version 1.3</a>
is available in all MirageOS unikernels, including on our main website. If you're reading this, you've likely established a TLS 1.3 connection already :)</p>
<p>Getting there was some effort: we now embed the Coq-verified <a href="https://github.com/mirage/fiat/">fiat</a>
library (from <a href="https://github.com/mit-plv/fiat-crypto/">fiat-crypto</a>) for the P-256 elliptic curve, and the F*-verified <a href="https://github.com/mirage/hacl">hacl</a>
library (from <a href="https://project-everest.github.io/">Project Everest</a>) for the X25519 elliptic curve to establish 1.3 handshakes with ECDHE.</p>
<p>Part of our TLS 1.3 stack is support for pre-shared keys, and 0 RTT. If you're keen to try these features, please do so and report any issues you encounter <a href="https://github.com/mirleft/ocaml-tls">to our issue tracker</a>.</p>
<p>We are still lacking support for RSA-PSS certificates and EC certificates, post-handshake authentication, and the chacha20-poly1305 ciphersuite. There is also a <a href="https://github.com/mirage/hacl/issues/32">minor symbol clash</a> with the upstream F* C bindings which we are aware of. We will continue to work on these, and patches are welcome.</p>

      

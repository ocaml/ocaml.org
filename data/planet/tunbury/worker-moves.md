---
title: Worker moves
description: Following the setup of rosemary with FreeBSD 14 (with 20C/40T), I have
  paused spring and summer (which combined have 12C/24T) and rosemary is now handling
  all of the FreeBSD workload.
url: https://www.tunbury.org/2025/05/09/worker-moves/
date: 2025-05-09T12:00:00-00:00
preview_image: https://www.tunbury.org/images/ocaml-logo.png
authors:
- Mark Elvers
source:
ignore:
---

<p>Following the setup of <em>rosemary</em> with <a href="https://www.tunbury.org/freebsd-uefi/">FreeBSD 14</a> (with 20C/40T), I have paused <em>spring</em> and <em>summer</em> (which combined have 12C/24T) and <em>rosemary</em> is now handling all of the <a href="https://github.com/ocurrent/freebsd-infra/pull/14">FreeBSD workload</a>.</p>

<p><em>Oregano</em> has now taken the OpenBSD workload from <em>bremusa</em>. <em>bremusa</em> has been redeployed in the <code class="language-plaintext highlighter-rouge">linux-x86_64</code> pool. With the extra processing, I have paused the Scaleway workers <em>x86-bm-c1</em> through <em>x86-bm-c9</em>.</p>

<p>These changes, plus the <a href="https://www.tunbury.org/equinix-moves/">removal of the Equnix machines</a>, are now reflected in <a href="https://infra.ocaml.org">https://infra.ocaml.org</a>.</p>

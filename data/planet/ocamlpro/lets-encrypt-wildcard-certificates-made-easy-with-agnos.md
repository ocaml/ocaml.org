---
title: Let's Encrypt Wildcard Certificates Made Easy with Agnos
description: It is with great pleasure that we announce the first beta release of
  Agnos. A former personal project of our new recruit, Arthur, Agnos development is
  now hosted at and sponsored by OCamlPro's Rust division, Red Iron. A white lamb
  with a blue padlock and blue stars. He is clearly to be trusted with ...
url: https://ocamlpro.com/blog/2022_10_05_agnos_0.1.0-beta
date: 2022-10-05T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Arthur Carcano\n  "
source:
---

<p></p>
<p>It is with great pleasure that we announce the first beta release of <a href="https://github.com/krtab/agnos">Agnos</a>. A former personal project of our new recruit, Arthur, Agnos development is now hosted at and sponsored by OCamlPro's Rust division, <a href="https://red-iron.eu/">Red Iron</a>.</p>
<p><img src="https://ocamlpro.com/blog/assets/img/agnos-banner.png" alt="A white lamb with a blue padlock and blue stars. He is clearly to be trusted with your certificate needs. A text reads: Agnos, wildcard Let's Encrypt certificates, no DNS-provider API required."/></p>
<blockquote>
<p><strong>TL;DR:</strong>
If you are familiar with ACME providers like Let's Encrypt, DNS-01 and the challenges relating to wildcard certificates, simply know that Agnos touts itself as a single-binary, API-less, provider-agnostic dns-01 client, allowing you to easily obtain wildcard certificates without having to interface with your DNS provider. To do so, it offers a user-friendly configuration and answers Let's Encrypt DNS-01 challenges on its own, bypassing the need for API calls to edit DNS zones. You may want to jump to the last <a href="https://ocamlpro.com/blog/feed#agnos-as-the-best-of-both-worlds">section</a> of this post, or directly join us on  Agnos's <a href="https://github.com/krtab/agnos">github</a>.</p>
</blockquote>
<p>Agnos was born from the observation that even though wildcard certificates are in many cases more convenient and useful than their fully qualified counterparts, they are not often used in practice. As of today it is not uncommon to see certificates with multiple <a href="https://en.wikipedia.org/wiki/Subject_Alternative_Name">Subject Alternate Names</a>  (SAN) for multiple subdomains, which can become <a href="https://discuss.httparchive.org/t/san-certificates-how-many-alt-names-are-too-many/1867">problematic</a> and weaken infrastructure. If some situations indeed require to forego wildcard certificates, this choice is too often still a default one.</p>
<p>At OCamlPro, we believe that technical difficulties should not stand in the way of optimal decision making, and that compromises should only be made in the face of unsolvable challenges. By releasing this first beta of Agnos, we hope that your feedback we'll help us build a tool truly useful to the community and that together, we can open a path towards seamless wildcard certificate issuance &ndash; tossing away issues and pain-points previously encountered as a thing of the past.</p>
<p>This blog post describes the different ACME challenges, why DNS providers API have so far been hindering DNS-01 adoption, and how Agnos solves this issue. If you are already curious and want to run some code, let's meet on Agnos's <a href="https://github.com/krtab/agnos">github</a></p>
<h2>Let's encrypt's mechanism and ACME challenges</h2>
<p>The Automatic Certificate Management Environment (ACME) is the protocol behind automated certificate authority services like Let's Encrypt. At its core, this protocol requires the client asking for a certificate to provide evidence that they control a resource by having said resource display some authority-determined token.</p>
<p>The easiest way to do so is to serve a file on a web-server. For example serving a file containing the token at <code>my-domain.example</code> would prove that I control the web-server that the <strong>fully qualified domain name</strong> <code>my-domain.example</code> is pointing to. This, under normal circumstances proves that I somewhat control this fully qualified domain. This process is illustrated below.</p>
<p>The ACME client initiates the certificate issuance process and is challenged to serve the token via HTTP at the domain address. The ACME client and HTTP server can be and often are on the same machine. The token can be quickly provisioned, and the ACME client can ask the ACME server to validate the challenge and issue the certificate.</p>
<p><img src="https://ocamlpro.com/blog/assets/img/http-01-schema.png" alt="Schematic illustration of the HTTP-01 challenge."/></p>
<p>However, demonstrating that one controls an HTTP server pointed to by <code>my-domain.example</code> is not deemed enough by Let's Encrypt to demonstrate <strong>full</strong> control of the <code>my-domain.example</code> domain and all its subdomains. Hence, the user cannot be issued a wildcard certificate through this method.</p>
<p>To obtain a wildcard certificate, one must rely on the DNS-01 type of challenge, illustrated below. The ACME client initiates the certificate issuance process and is challenged to serve the token via a DNS TXT record. Because DNS management is often delegated to a DNS provider, the DNS server is rarely on the same machine, and the token must be provisioned via a call to the DNS provider API, if there is any. Moreover, DNS providers virtually always use multiple servers, and the new record must be propagated to all of them. The ACME client must then wait and check for the propagation to be finished before asking the ACME server to validate the challenge and issue the certificate.</p>
<p><img src="https://ocamlpro.com/blog/assets/img/dns-01-schema.png" alt="Schematic illustration of the DNS-01 challenge."/></p>
<p>The pros and cons of each of these two challenge type are summarized by Let's Encrypt's <a href="https://letsencrypt.org/docs/challenge-types/">documentation</a> as follow:</p>
<blockquote>
<h4>HTTP-01</h4>
<h5>Pros</h5>
<ul>
<li>It&rsquo;s easy to automate without extra knowledge about a domain&rsquo;s configuration.
</li>
<li>It allows hosting providers to issue certificates for domains CNAMEd to them.
</li>
<li>It works with off-the-shelf web servers.
</li>
</ul>
<h5>Cons</h5>
<ul>
<li>It doesn&rsquo;t work if your ISP blocks port 80 (this is rare, but some residential ISPs do this).
</li>
<li>Let&rsquo;s Encrypt doesn&rsquo;t let you use this challenge to issue wildcard certificates.
</li>
<li>If you have multiple web servers, you have to make sure the file is available on all of them.
</li>
</ul>
<h4>DNS-01</h4>
<h5>Pros</h5>
<ul>
<li>You can use this challenge to issue certificates containing wildcard domain names.
</li>
<li>It works well even if you have multiple web servers.
</li>
</ul>
<h5>Cons</h5>
<ul>
<li>Keeping API credentials on your web server is risky.
</li>
<li>Your DNS provider might not offer an API.
</li>
<li>Your DNS API may not provide information on propagation times.
</li>
</ul>
</blockquote>
<h2>Agnos as the best of both worlds</h2>
<p>By using NS records to delegate the DNS-01 challenge to Agnos itself, we can virtually remove all of DNS-01 cons. Indeed by serving its own DNS answers, Agnos:</p>
<ul>
<li>Nullifies the need for API and API credentials
</li>
<li>Nullifies all concerns regarding propagation times
</li>
</ul>
<p>In more details, Agnos proceeds as follows (and as illustrated below). Before any ACME transaction takes place (and only once), the ACME client user manually updates their DNS zone to delegate ACME specific subdomains to Agnos. Note that the rest of DNS functionality is still assumed by the DNS provider. To carry out the ACME transaction, the ACME client initiates the certificate issuance process and is challenged to serve the token via a DNS TXT record. Agnos does so using its own DNS functionality (leveraging <a href="https://trust-dns.org/">Trust-dns</a>). The ACME client can immediately ask the ACME server for validation. The ACME server asks the DNS provider for the TXT record and is replied to that the ACME specific subdomain is delegated to Agnos. The ACME server then asks Agnos-as-a-DNS-server for the TXT record which Agnos provides. Finally the certificate is issued and stored by Agnos on the client machine.</p>
<p><img src="https://ocamlpro.com/blog/assets/img/dns-01-agnos-schema.png" alt="Schematic illustration of the DNS-01 challenge when using Agnos."/></p>
<h2>Taking Agnos for a ride</h2>
<p>In conclusion, we hope that by switching to Agnos, or more generally to provider-agnostic DNS-01 challenge solving, individuals and organizations will benefit from the full power of DNS-01 and wildcard certificates, without having to take API-related concerns into account when choosing their DNS provider.</p>
<p>If this post has piqued your interest and you want to help us develop Agnos further by trying the beta out, let's meet on our <a href="https://github.com/krtab/agnos">github</a>. We would very much appreciate any feedback and bug reports, so we tried our best to streamline and well document the installation process to facilitate new users.
On ArchLinux for example, getting started can be as easy as:</p>
<p>Adding two records to your DNS zone using your provider web GUI:</p>
<pre><code>agnos-ns.doma.in            A       1.2.3.4
_acme-challenge.doma.in     NS      agnos-ns.doma.in
</code></pre>
<p>and running on your server</p>
<pre><code class="language-bash"># Install the agnos binary
yay -S agnos
# Allow agnos to bind the priviledge 53 port
sudo setcap 'cap_net_bind_service=+ep' /usr/bin/agnos
# Download the example configuration file
curl 'https://raw.githubusercontent.com/krtab/agnos/v.0.1.0-beta.1/config_example.toml' &gt; agnos_config.toml
# Edit it to suit your need
vim agnos_config.toml
# Launch agnos &#128640;
agnos agnos_config.toml
</code></pre>
<p>Until then, happy hacking!</p>


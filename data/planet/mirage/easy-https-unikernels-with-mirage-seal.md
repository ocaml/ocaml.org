---
title: Easy HTTPS Unikernels with mirage-seal
description:
url: https://mirage.io/blog/mirage-seal
date: 2015-07-07T00:00:00-00:00
preview_image:
featured:
authors:
- Mindy Preston
---


        <p>Building a static website is one of the better-supported user stories for MirageOS, but it currently results in an HTTP-only site, with no capability for TLS.  Although there's been a great TLS stack <a href="https://mirage.io/blog/introducing-ocaml-tls">available for a while now</a>, it was a bit fiddly to assemble the pieces of TLS, Cohttp, and the MirageOS frontend tool in order to construct an HTTPS unikernel.  With MirageOS 2.5, that's changed!  Let's celebrate by building an HTTPS-serving unikernel of our very own.</p>
<h2>Prerequisites</h2>
<h2>Get a Certificate</h2>
<p>To serve HTTPS, we'll need a certificate to present to clients (i.e., browsers) for authentication and establishing asymmetric encryption. For just testing things out, or when it's okay to cause a big scary warning message to appear for anyone browsing a site, we can just use a self-signed certificate.  Alternatively, the domain name registrar or hosting provider for a site will be happy to sell (or in some cases, give!) a certificate -- both options are explained in more detail below.</p>
<p>Whichever option you choose, you'll need to install <code>certify</code> to get started (assuming you'd like to avoid using <code>openssl</code>).  To do so, pin the package in opam:</p>
<pre><code>opam pin add certify https://github.com/yomimono/ocaml-certify.git
opam install certify
</code></pre>
<h3>Self-Signed</h3>
<p>It's not strictly necessary to get someone else to sign a certificate. We can create and sign our own certificates with the <code>selfsign</code> command-line tool.  The following invocation will create a secret key in <code>secrets/server.key</code> and a public certificate for the domain <code>totallyradhttpsunikernel.xyz</code> in <code>secrets/server.pem</code>.  The certificate will be valid for 365 days, so if you choose this option, it's a good idea set a calendar reminder to renew it if the service will be up for longer than that.  The key generated will be a 2048-bit RSA key, although it's possible to create certificates valid for different lengths -- check <code>selfsign --help</code> for more information.</p>
<pre><code>selfsign -c secrets/server.pem -k secrets/server.key -d 365 totallyradhttpsunikernel.example
</code></pre>
<p>We can now use this key and certificate with <code>mirage-seal</code>!  See &quot;Packaging Up an HTTPS Site with Mirage-Seal&quot; below.</p>
<h3>Signed by Someone Else</h3>
<p>Although there are many entities that can sign a certificate with different processes, most have the following in common:</p>
<ol>
<li>you generate a request to have a certificate made for a domain
</li>
<li>the signing entity requests that you prove your ownership over that domain
</li>
<li>once verified, the signing entity generates a certificate for you
</li>
</ol>
<h4>Generating a Certificate-Signing Request</h4>
<p>No matter whom we ask to sign a certificate, we'll need to generate a certificate signing request so the signer knows what to create.  The <code>csr</code> command-line tool can do this.  The line below will generate a CSR (saved as server.csr) signed with a 2048-bit RSA key (which will be saved as server.key), for the organization &quot;Rad Unikernel Construction, Ltd.&quot; and the common name &quot;totallyradhttpsunikernel.example&quot;.  For more information on <code>csr</code>, try <code>csr --help</code>.</p>
<pre><code>csr -c server.csr -k server.key totallyradhttpsunikernel.example &quot;Rad Unikernel Construction, Ltd.&quot;
</code></pre>
<p><code>csr</code> will generate a <code>server.csr</code> that contains the certificate signing request for submission elsewhere.</p>
<h5>Example: Gandi.net</h5>
<p>My domain is registered through the popular registrar Gandi.net, who happen to give a free TLS certificate for one year with domain registration, so I elected to have them sign a certificate for me (Gandi did not pay a promotional consideration for this mention).  Most of this process is managed through their web GUI and a fairly large chunk is automatically handled behind the scenes.  Here's how you can do it too:</p>
<p>Log in to the web interface available through the registrar's website.  You can start the certificate signing process from the &quot;services&quot; tab, which exposes an &quot;SSL&quot; subtab.  Click that (Gandi doesn't need to know that we intend only to support TLS, not SSL).  Hit the &quot;Get an SSL Certificate&quot; button.  Standard SSL is fine.  Even if you're entitled to a free certificate, it will appear that you need to pay here; however at checkout, the total amount due will be 0 in your preferred currency.  Ask for a single address and, if you want to pay nothing, a valid period of 1 year.</p>
<p>Copy the content of the certificate-signing request you generated earlier and paste it into the web form.  Gandi will also ask you to identify your TLS stack; unfortunately <code>ocaml-tls</code> isn't in the drop-down menu, so choose OTHER (and perhaps send them a nice note asking them to add the hottest TLS stack on the block to their list).  Click &quot;submit&quot; and click through the order form.</p>
<p>If you're buying a certificate for a domain you have registered through Gandi (via the registered account), the rest of the process is pretty automatic.  You should shortly receive an e-mail with a subject like &quot;Procedure for the validation of your Standard SSL certificate&quot;, which explains the process in more detail, but really all you need to do is wait a while (about 30 minutes, for me).  After the certificate has been generated, Gandi will notify you by e-mail, and you can download your certificate from the SSL management screen.  Click the magnifying glass next to the name of the domain for which you generated the cert to do so.</p>
<p>Once you've downloaded your certificate, you may also wish to append the <a href="https://en.wikipedia.org/wiki/Intermediate_certificate_authorities">intermediate certificates</a>.  Here's a help page on <a href="https://wiki.gandi.net/en/ssl/intermediate">gathering intermediate certificates</a>.  Equipped with the intermediate certificates, append them to the signed certificate downloaded for your site to provide a full certificate chain:</p>
<pre><code>cat signed_cert.pem intermediate_certs.pem &gt; server.pem
</code></pre>
<h5>Example: StartSSL.com</h5>
<p>Another free TLS certificate provider is <a href="https://www.startssl.com">StartSSL</a>.  During online registration, StartSSL will generate a TLS client certificate for you.  This is used for authentication of yourself towards their service.</p>
<p>You need to validate that you own the domain you want to request a certificate for.  This is done via the &quot;Validations Wizard&quot;, which lets you choose to validate a domain via &quot;Domain Name Validation&quot;.  There you enter your domain name, and receive an eMail with a token which you have to enter into the web interface.</p>
<p>Once done, run <code>csr</code> to create a key and a certificate signing request.  Go to the &quot;Certificates Wizard&quot;, select &quot;Web Server SSL/TLS Certificate&quot;, skip the generation of the private key (you already generated one with <code>csr</code>), copy and paste your certificate signing request (only the public key of that CSR is used, everything else is ignored), select a domain name, and immediately receive your certificate.</p>
<p>Make sure to also download their intermediate CA certificate, and append them:</p>
<pre><code>cat intermediate.pem cert.pem &gt; server.pem
</code></pre>
<h2>Packaging Up an HTTPS Site with Mirage-Seal</h2>
<p>Equipped with a private key and a certificate, let's make an HTTPS unikernel!  First, use <code>opam</code> to install <code>mirage-seal</code>.  If <code>opam</code> or other MirageOS tooling aren't set up yet, check out the <a href="https://mirage.io/docs/install">instructions for getting started</a>.</p>
<pre><code>opam install mirage-seal
</code></pre>
<p><code>mirage-seal</code> has a few required arguments.</p>
<ul>
<li><code>--data</code>: one directory containing all the content that should be served by the unikernel.  Candidates for such a directory are the top-level output directory of a static site generator (such as <code>public</code> for octopress), the <code>DocumentRoot</code> of an Apache configuration, or the <code>root</code> of an nginx configuration.
</li>
<li><code>--keys</code>: one directory containing the certificate (<code>server.pem</code>) and key (<code>server.key</code>) for the site.
</li>
</ul>
<p>There are also a number of configurable parameters for IP settings.  By default, <code>mirage-seal</code> will use DHCP to configure the network at boot.  To set static IP information, use the <code>--ip</code>, <code>--nm</code>, and <code>--gw</code> arguments.</p>
<p>You'll find more thorough documentation by looking at <code>mirage-seal --help</code> or <a href="https://github.com/mirage/mirage-seal/blob/master/README.md">mirage-seal's README file</a>.</p>
<p>To build a Xen unikernel, select the Xen mode with <code>-t xen</code>.  In full, for a unikernel that will configure its network via DHCP:</p>
<pre><code>mirage-seal --data=/home/me/coolwebsite/public --keys=/home/me/coolwebsite/secrets -t xen
</code></pre>
<p><code>mirage-seal</code> will then generate a unikernel <code>mir-seal.xen</code> and a Xen configuration file <code>seal.xl</code> in the current working directory.  To boot it and open the console (on a machine running Xen), invoke <code>xl create</code> on the configuration file with the <code>-c</code> option:</p>
<pre><code>sudo xl create seal.xl -c
</code></pre>
<p>Via the console, we can see the sealed unikernel boot and obtain an IP through DHCP.  Congratulations -- you made a static site unikernel browsable over HTTPS!</p>

      

---
title: Secure Virtual Messages in a Bottle with SCoP
description: "People love to receive mail, especially from loved ones. It\u2019s heartwarming
  to read\neach word as their thoughts touch our deepest feelings\u2026"
url: https://tarides.com/blog/2022-03-08-secure-virtual-messages-in-a-bottle-with-scop
date: 2022-03-08T00:00:00-00:00
preview_image: https://tarides.com/static/610748ca5fff5dcffb66e090e6406e2a/88e9c/message_bottle.jpg
featured:
---

<p>People love to receive mail, especially from loved ones. It&rsquo;s heartwarming to read
each word as their thoughts touch our deepest feelings. Now imagine someone else
reading those private sentiments, like a postal worker. Imagine how violated they&rsquo;d
feel if their postal carrier handed them an open letter with a knowing smile. Of course,
people trust that postal employees won&rsquo;t read their personal correspondence;
however, they regularly risk their privacy when sending emails, images, and messages.</p>
<p>Around 300 billion emails traverse the Internet every single day. They travel
through portals with questionable security, and the messages often contain
private or sensitive data. Most online communication services are composed of
multiple components with complex interactions. If anything goes wrong, it
results in critical security incidents. This leaves an unlocked door for
malicious hackers to breach private information for profit or just for fun.
Since it takes considerable technical skills and reliable infrastructure to
operate a secure email service, most Internet users must
rely on third-parties operators. In practice, there
are only a few large companies that can handle communications with the
proper security levels. Unfortunately for regular people, these companies
profit from mining their personal data. Due to this global challenge, Tarides
focused their efforts to address these issues and find solutions to protect
both personal and professional data.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#an-innovative-solution" aria-label="an innovative solution permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>An Innovative Solution</h3>
<p>Our work resulted in the project &quot;Secure-by-Design Communications Protocols&quot;
(SCoP), a secure, easily deployable solution to preserve users' privacy. In
essence, SCoP puts your messages in a secure, virtual &lsquo;bottle&rsquo; to protect it
from invasive actions. This bottle represents a secure architecture using
type-safe languages and unikernels for both email and instant messaging.
We mould <a href="https://mirage.io/">unikernels</a> (specialised applications that
run on a VM) into refined meshes linked by TLS-firm communication pipes,
as depicted in the image below.</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/6c94ba14bec3537413c603635b78c123/0f98f/Dapsi_4.001.jpg" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 56.470588235294116%; position: relative; bottom: 0; left: 0; background-image: url('data:image/jpeg;base64,/9j/2wBDABALDA4MChAODQ4SERATGCgaGBYWGDEjJR0oOjM9PDkzODdASFxOQERXRTc4UG1RV19iZ2hnPk1xeXBkeFxlZ2P/2wBDARESEhgVGC8aGi9jQjhCY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2P/wgARCAALABQDASIAAhEBAxEB/8QAGAAAAgMAAAAAAAAAAAAAAAAAAAIBAwX/xAAVAQEBAAAAAAAAAAAAAAAAAAAAAf/aAAwDAQACEAMQAAAB3FtiFGD/xAAXEAEBAQEAAAAAAAAAAAAAAAAAEQEQ/9oACAEBAAEFAmdiP//EABQRAQAAAAAAAAAAAAAAAAAAABD/2gAIAQMBAT8BP//EABQRAQAAAAAAAAAAAAAAAAAAABD/2gAIAQIBAT8BP//EABcQAAMBAAAAAAAAAAAAAAAAAAABICH/2gAIAQEABj8CHs//xAAaEAADAAMBAAAAAAAAAAAAAAAAAREhMVFB/9oACAEBAAE/IbnIrrNmnpcFr0hBHD//2gAMAwEAAgADAAAAENvf/8QAFREBAQAAAAAAAAAAAAAAAAAAABH/2gAIAQMBAT8QV//EABYRAQEBAAAAAAAAAAAAAAAAAAARIf/aAAgBAgEBPxDUf//EABwQAAICAgMAAAAAAAAAAAAAAAERACEQMUFxwf/aAAgBAQABPxDkYEC7gJArJSLXsEpt2YkY2N43/9k='); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/6c94ba14bec3537413c603635b78c123/7bf67/Dapsi_4.001.jpg" class="gatsby-resp-image-image" alt="TLS Communication Pipes" title="TLS Communication Pipes" srcset="/static/6c94ba14bec3537413c603635b78c123/651be/Dapsi_4.001.jpg 170w,
/static/6c94ba14bec3537413c603635b78c123/d30a3/Dapsi_4.001.jpg 340w,
/static/6c94ba14bec3537413c603635b78c123/7bf67/Dapsi_4.001.jpg 680w,
/static/6c94ba14bec3537413c603635b78c123/990cb/Dapsi_4.001.jpg 1020w,
/static/6c94ba14bec3537413c603635b78c123/c44b8/Dapsi_4.001.jpg 1360w,
/static/6c94ba14bec3537413c603635b78c123/0f98f/Dapsi_4.001.jpg 1920w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<p>The SCoP virtual bottle creates a trustworthy information flow where dedicated
unikernels ensure security for communication from origin to destination. We
carefully design every component of SCoP as independent libraries, using
modern development techniques to avoid the common reported threats and flaws.
The <a href="https://ocaml.org">OCaml</a>-based development enables this safe online
environment, which eliminates many exploited security pitfalls. Moreover,
our SCoP project comes with energy-efficient consumption provided by the
lightweight and low-latency design components.</p>
<p>We mostly focused on the sender&rsquo;s side, securing the message inside the SCoP
bottle. For instant messages, we created a capsule with a
<a href="https://github.com/mirage/ocaml-matrix">Matrix client library</a>,
and for emails we based our bottle on the <a href="https://github.com/mirage/ptt">SMTP protocol</a>
and <a href="https://github.com/mirage/mrmime">Mr. MIME</a>. For further protection,
we developed the bottle&rsquo;s &lsquo;cork&rsquo; with the
<a href="https://github.com/mirage/hamlet">Hamlet email corpus</a>.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#the-scop-processes" aria-label="the scop processes permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The SCoP Processes</h3>
<p>First, we generated Hamlet, a collection of emails to test our parser
implementation against existing projects, to ensure that they kept equivalence
between the encoder and decoder. After we successfully parsed and encoded one
million emails, we used Hamlet to stress-test our SMTP stack.</p>
<p>Secondly, we created an SMTP extension mechanism and support for SPF, including
an implementation for DMARC, a security framework in addition to DKIM and SPF.
We completed four components: SPF, DKIM, SMTP, and Mr. MIME, which can generate
a correctly-signed email, signatures, and the DKIM field containing the signatures.</p>
<p>In essence, we designed the SMTP sender bottle with a mesh of unikernels connected
via secured communication pipes. The SMTP Submission Server unikernel receives
the sender&rsquo;s authentication credentials against the secured database maintained
by Irmin. After it confirms the credentials, it sends the email for sealing
(via a TLS pipe) to the DKIM signer. Then the DKIM signer unikernel, responsible
for handling IP addresses, communicates via the nsupdate protocol with the Primary
DNS Server. The DKIM signer places the sender&rsquo;s and receiver&rsquo;s addresses on the email,
seals it with the DKIM signature, and sends it to the SMTP relay for distribution.
The SMTP relay unikernel communicates with the DNS resolver unikernel to locate the
receiver by the DNS name, then it coordinates this location with the Irmin database
to verify the authorization according to the SPF protocol. After all these checks
have passed, the signed and sealed email is secured in the SCoP bottle and launched
through Cyberspace.</p>
<p>Next, we developed the Matrix protocol&rsquo;s client library, and we used it to enable
notifications from the CI system, testing all the new OCaml packages. We also
designed an initial PoC for a Matrix&rsquo;s server-side daemon.</p>
<p>We made significant progress in deploying DNSSEC, a set of security extensions over
DNS. While we completed our first investigation into the DNSSEC prototype, we also
discovered several issues, so we addressed those as lessons learned.</p>
<p>Finally, we completed the <a href="https://github.com/tarides/unikernels">SCoP bottle</a> with
the email receiver, which <a href="https://github.com/mirage/spamtacus">Spamtacus</a> (the
Bayesian spam filter) guards against spam intruders. Furthermore, the
<a href="https://github.com/mirage/ocaml-matrix">OCaml-Matrix</a> server represents
our solution to take care of the instant communication in the Matrix federation.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#a-secure-by-design-smtp-stack" aria-label="a secure by design smtp stack permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>A Secure-by-Design SMTP Stack</h3>
<p>We researched state-of-the-art email spam filtering methods and identified machine
learning as the main trend. We followed this path and equipped our email architecture
with a spam-filter unikernel, which uses a Bayesian method for supervised learning
of spam and acts as a proxy for internet communication in the SMTP receiver. This
spam filter works in two states: preparation, where the unikernel detects spam,
and operation, where the unikernel integrates into the SMTP receiver unikernel
architecture to filter spam emails. Our spam-filter unikernel can also be used
independently as an individual anti-spam tool to help enforce GDPR rules and protect
the user&rsquo;s privacy by preventing spam-induced attacks, such as phishing.</p>
<p>We integrated our spam filter into a unikernel positioned at the beginning
of the SMTP receiver stack. This acts as a first line of defence in an eventual
attack targeting the receiver in order to maintain functionality. The spam-filter
unikernel can be extended to act as an antivirus by analysing the email attachment
for certain features known to characterise malware. We&rsquo;ve already set the premises
for the antivirus by using a prototype analysis of the email attachments. Moreover,
the spam-filter unikernel can contribute with a list of frequent spammers to the
firewall, which we plan to add into the SMTP receiver as the next step in our development of SCoP.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#how-the-technology-works" aria-label="how the technology works permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>How the Technology Works</h3>
<p>DKIM, SPF, and DMARC are three communication protocols meant to ensure email
security by verification of sender identity. The latest RFC standards for
DKIM, SPF, and DMARC are RFC8463, RFC7208, and RFC7489, respectively.</p>
<p>DKIM provides a signer protocol and the associated verifier protocol. DKIM
signer allows the sender to communicate which email it considers legitimate.
Our implementation of the DKIM verifier is associated with the SMTP receiver,
it follows the RFC8463 standard and supports the ED25519 signing algorithm,
i.e., the elliptic curve cryptography generated from the formally verified
specification in the fiat project from MIT.</p>
<p>SPF is an open standard that specifies a method to identify legitimate mail
sources, using DNS records, so the email recipients can consult a list of IP
addresses to verify that emails they receive are from an authorised domain.
Hence, SPF is functioning based on the blacklisting principle in order to
control and prevent sender fraud. Our implementation of the SPF verifier
follows the RFC7208 standard.</p>
<p>DMARC (Domain-based Message Authentication, Reporting, and Conformance) enables
a sender to indicate that their messages comply with SPF and DKIM, and applies
clear instructions for the recipient to follow if an email does not pass SPF or
DKIM authentications (reject, junk, etc.). As such, DMARC is used to create
domain reputation lists, which can help determine the actual email source
and mitigate spoofing attacks. Our implementation of the DMARC verifier is
integrated in the SMTP receiver and follows the RFC7489 standard.</p>
<p>Our secure-by-design SMTP stack contains the DKIM/SPF/DMARC verifier unikernel
on the receiver side. This unikernel verifies the email sender&rsquo;s DNS
characteristics via a TLS communication pipe, and in case the DNS verification
passes, the spam-labelled email goes to the SMTP relay to be dispatched to the
email client. However, in case the DNS verification doesn&rsquo;t pass, we can use
the result to construct a DNS reputation list to improve the SMTP security
via a blacklisting firewall.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#matrix-server" aria-label="matrix server permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Matrix Server</h3>
<p>The Matrix server in our OCaml Matrix implementation manages clients who are
registered to rooms that contain events. These represent client actions, such
as sending a message. Our implementation follows the Matrix specification
standard. From here, we extracted the parts describing the subset of the Matrix
components we chose to implement for our OCaml Matrix server MVP. The OCaml
implementation environment provides secure-by-design properties and avoids
various vulnerabilities, like the buffer overflow recently discovered that
produces considerable information disclosure in other Matrix implementations,
e.g., Element.</p>
<p>The Matrix clients are user applications that connect to a Matrix server via the
client-server API. We implemented an OCaml-CI client, which communicates with the
Matrix servers via the client-server API and tested the integration of the OCaml-CI
communication with both Synapse and our OCaml Matrix server. Please note that our
OCaml Matrix server supports a client authentication mechanism based on user name
identification and password, according to the Matrix specification for authentication
mechanisms.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#spam-filter" aria-label="spam filter permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Spam Filter</h3>
<p>We researched the state of the art in email spam filtering and we identified machine
learning as the main trend. We follow this trend and we equip our email architecture
with a spam filter unikernel, which uses a Bayesian method for supervised learning of
spam and acts as a proxy to the internet communication in the SMTP receiver. The spam
filter implementation works in two stages: preparation, when the unikernel is trained
to detect spam, and operation, when the unikernel is integrated into the SMTP receiver
architecture of unikernels to filter the spam emails. It is worth mentioning that the
spam filter unikernel can be used independently as an individual anti-spam tool to help
enforce the GDPR rules and protect the user's privacy by preventing spam induced attacks
such as phishing.</p>
<p>We integrate the spam filter into an unikernel positioned at the beginning of the
SMTP receiver stack as the first line of defence in an eventual attack targeting the
receiver. In this situation, the unikernel format provides isolation of the attack and
allows the SMTP receiver to maintain functionality. The spam filter unikernel can be
extended to act as an antivirus by analysing the email attachment for certain features
that are known to characterise malware. We have already set the premises for the antivirus
by a prototype analysis of the email attachments. Moreover, the spam filter unikernel could
contribute with a list of frequent spammers to the firewall, which is planned to be added
into the SMTP receiver, as the next step in future work.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#the-dapsi-initiative" aria-label="the dapsi initiative permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The DAPSI Initiative</h3>
<p>Much of the SCoP project was possible thanks to <a href="https://dapsi.ngi.eu">the DAPSI initiative</a>.
They gave Tarides the incentive to further explore an open and secure infrastructure for
communication protocols, especially emails. First, DAPSI supported our team by providing
necessary financing, but their contribution to our project&rsquo;s prosperity runs much deeper
than funding. DAPSI facilitated multiple coaching sessions that helped broaden our horizons
and established reachable goals. Notably, their business coaching enabled us to identify
solutions for our market strategy. Their technical coaching and training offered access
to data portability experts and GDPR regulations, which opened our perspective to novel
trends and procedures. Additionally, DAPSI helped raise our visibility by organising public
communications, and DAPSI&rsquo;s feedback revealed insights on how to better exploit our project&rsquo;s
potential and what corners of the cyber-ecosystem to prioritise. We are deeply grateful to
DAPSI for their support and backing, and we&rsquo;re thrilled to have passed Phase 2!</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#up-next-for-scop" aria-label="up next for scop permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Up Next for SCoP</h3>
<p>We&rsquo;re excited to further develop this project. We&rsquo;ll be experimenting with deploying
unikernels on a smaller chipset, such as IoT. We&rsquo;d also like to research secure data
porting in other domains such as journalism, law, or banking.</p>
<p>Of course we&rsquo;ll be maintaining each of the SCoP components in order to follow the latest
available standards and state-of-the-art technology, including periodical security
analyses of our code-base and mitigation for newly discovered vulnerabilities.</p>
<p>As in all of our work at Tarides, we strive to benefit the entire OCaml community and beyond.
Please find more information on SCoP through our blog posts:
<a href="https://tarides.com/blog/2021-04-30-scop-selected-for-dapsi-initiative">DAPSI Initiative</a>
and <a href="https://tarides.com/blog/2021-10-14-scop-selected-for-dapsi-phase2">DAPSI Phase 1</a>.</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/50ddca27efa367497d954f667fc921f8/a76d6/DAPSI_generic.jpg" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 3.5294117647058822%; position: relative; bottom: 0; left: 0; background-image: url('data:image/jpeg;base64,/9j/2wBDABALDA4MChAODQ4SERATGCgaGBYWGDEjJR0oOjM9PDkzODdASFxOQERXRTc4UG1RV19iZ2hnPk1xeXBkeFxlZ2P/2wBDARESEhgVGC8aGi9jQjhCY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2P/wgARCAABABQDASIAAhEBAxEB/8QAFwABAAMAAAAAAAAAAAAAAAAAAAIDBf/EABUBAQEAAAAAAAAAAAAAAAAAAAAC/9oADAMBAAIQAxAAAAHSsFSCf//EABYQAQEBAAAAAAAAAAAAAAAAAAMQM//aAAgBAQABBQIc0n//xAAVEQEBAAAAAAAAAAAAAAAAAAACEP/aAAgBAwEBPwET/8QAFhEAAwAAAAAAAAAAAAAAAAAAARAx/9oACAECAQE/ATV//8QAFxAAAwEAAAAAAAAAAAAAAAAAAAEQgf/aAAgBAQAGPwJGz//EABkQAAMAAwAAAAAAAAAAAAAAAAABQXGhsf/aAAgBAQABPyHdfScSI//aAAwDAQACAAMAAAAQCA//xAAWEQEBAQAAAAAAAAAAAAAAAAAAATH/2gAIAQMBAT8Q3Ef/xAAVEQEBAAAAAAAAAAAAAAAAAAAQMf/aAAgBAgEBPxCx/8QAGhAAAQUBAAAAAAAAAAAAAAAAAAEhMVHwsf/aAAgBAQABPxDUuQwdDgf/2Q=='); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/50ddca27efa367497d954f667fc921f8/7bf67/DAPSI_generic.jpg" class="gatsby-resp-image-image" alt="Sequence of entity logos: in association with NGI, EU, Zabala, FGS,
cap-digital, IMT Starter, Fraunhofer IAIS." title="Sequence of entity logos: in association with NGI, EU, Zabala, FGS,
cap-digital, IMT Starter, Fraunhofer IAIS." srcset="/static/50ddca27efa367497d954f667fc921f8/651be/DAPSI_generic.jpg 170w,
/static/50ddca27efa367497d954f667fc921f8/d30a3/DAPSI_generic.jpg 340w,
/static/50ddca27efa367497d954f667fc921f8/7bf67/DAPSI_generic.jpg 680w,
/static/50ddca27efa367497d954f667fc921f8/990cb/DAPSI_generic.jpg 1020w,
/static/50ddca27efa367497d954f667fc921f8/a76d6/DAPSI_generic.jpg 1139w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>

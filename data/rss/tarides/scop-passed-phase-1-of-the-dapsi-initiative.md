---
title: SCoP Passed Phase 1 of the DAPSI Initiative!
description: "In April, we announced that the DAPSI initiative accepted\nthe proposal
  for our Secure-by-Design Communication Protocols (SCoP) project\u2026"
url: https://tarides.com/blog/2021-10-14-scop-selected-for-dapsi-phase2
date: 2021-10-14T00:00:00-00:00
preview_image: https://tarides.com/static/1a54502893f8f38db2c6e37811c75b0c/7d5a2/DAPSI_scop_banner.jpg
featured:
---

<p><strong>In April, <a href="https://tarides.com/blog/2021-04-30-scop-selected-for-dapsi-initiative">we announced</a> that the <a href="https://dapsi.ngi.eu">DAPSI initiative</a> accepted
the proposal for our Secure-by-Design Communication Protocols (SCoP) project. Today, we are thrilled to announce that SCoP has passed the initiative&rsquo;s Phase 1,
and we are now on our way to Phase 2!</strong></p>
<p>SCoP is an open, secure, and resource-efficient infrastructure to engineer a modern basis for open messaging (for existing and emerging protocols)
using type-safe languages and unikernels&mdash;to ensure your private information remains secure. After all, you wouldn&rsquo;t like your postal carrier reading
your snail mail, so why should emails be any different?</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#challenges" aria-label="challenges permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Challenges</h2>
<p>To operate an email service requires many technical skills and reliable infrastructure. As a result, only a few large companies can handle emails with
the proper security levels.  Unfortunately, the core business model of these companies is to mine your personal data.</p>
<p>The number of emails exchanged every day is expected to reach 333 billion in 2022. That&rsquo;s a considerable amount of data, much of it private or sensitive,
sent across Cyberspace through portals with questionable security. The &lsquo;memory unsafe&rsquo; languages used in most communication services leave far too much room
for mistakes that have serious ramifications, like security flaws that turn into security breaches, leaving your personal or business information vulnerable to
malicious hackers.</p>
<p>Due to this global challenge, we set out to build a simple, secure, easily deployable solution to preserve users' privacy, and we&rsquo;re making great strides toward
accomplishing that goal. We base our systems on scientific foundations to last for decades and drive positive change for the world. Our robust understanding of
both theory and practice enables us to solve these security problems, so we explore ideas where research and engineering meet at the intersection of the domains
of operating systems, distributed systems, and programming languages.</p>
<p>Every component of SCoP is carefully designed as independent libraries, using modern development techniques to avoid the common reported threats and flaws.
For instance, the implementation of protocol parsers and serializers are written in a type-safe language and tested using fuzzing. Combining these techniques
will increase users' trust to migrate their personal data to these new, more secure services.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#architecture" aria-label="architecture permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Architecture</h2>
<p>The architecture of the SCoP communication service is composed of an Email Service based on a secure extension of the SMTP protocol, and a decentralised
real-time communication system based on Matrix.</p>
<p>The <a href="https://github.com/dinosaure/ptt">SMTP</a> and <a href="https://github.com/clecat/ocaml-matrix">Matrix</a> protocols implemented in SCoP follow the separation of
concerns design principle, meaning that the SMTP Sender and SMTP Receiver are designed as two distinct units. They&rsquo;re implemented as isolated micro-services
which run as unikernels. The SMTP Sender, Receiver, and Matrix are all configurable, and each configuration comes with a security risk analysis report to
understand possible privacy risks</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#progress" aria-label="progress permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Progress</h2>
<p>Not only are we on our way to Phase 2 in the <a href="https://dapsi.ngi.eu">DAPSI Initiative</a>, but we&rsquo;re also proud to report that we&rsquo;re on track with our
planned milestones!</p>
<p>Our <strong>first milestone</strong> was to generate a corpus of emails to test our parser implementation against existing projects in order to detect differences
between the descriptions specified in the RFCs. We now have 1 million emails that have been parsed/encoded without any issues! Our email corpus keeps
isomorphism between the encoder and decoder, and you can find it in this <a href="https://github.com/mirage/hamlet">GitHub Repo</a>, as we encourage implementors of other languages to use it to improve
their trust in their own implementation.</p>
<p>We set out to implement an SMTP extension mechanism and support for SPF as well as implement DMARC, a security framework, on top of DKIM and SPF for our
<strong>second milestone</strong>, and we are right on target. To date, we&rsquo;ve completed four components:</p>
<ul>
<li><a href="https://github.com/dinosaure/ocaml-spf">SPF</a></li>
<li><a href="https://github.com/dinosaure/ocaml-dkim">DKIM</a></li>
<li><a href="https://github.com/dinosaure/ptt">SMTP</a> can send and verify emails</li>
<li><a href="https://tarides.com/blog/2019-09-25-mr-mime-parse-and-generate-emails">MrMIME</a> can generate the email, then SMTP sends the email (signed by a DKIM private key). We can correctly sign an email, generate a signature, and the DKIM field containing the signature. When the email is received, we check the DKIM signature and the SPF metadata.</li>
</ul>
<p>For our <strong>third milestone</strong>, we set out to implement DNSSEC, a set of security extensions over DNS. This security layer verifies the identity of an email sender
through DKIM/SPF/DMARC, but it also needs security extensions in the DNS protocol. We completed our initial investigation of a DNSSEC implementation prototype,
and we discovered several issues, like some of the elliptic curve cryptography was missing. Those necessary cryptographic primitives are now available, so we
should complete this milestone by the end of the month.</p>
<p>Finally, our <strong>fourth milestone</strong> was to implement the Matrix protocol (client and server). We completed the protocol&rsquo;s client library, which sends a notification
from OCaml CI. Plus, we have a PoC, and Matrix&rsquo;s server-side, which received the notification, is also complete.</p>
<p>Although we still have much work ahead of us, we&rsquo;re quite pleased with the progress thus far, and so is the DAPSI Initiative! Follow our progress by <a href="https://tarides.com/feed.xml">subscribing
to this blog</a> and our <a href="https://twitter.com/tarides_">Twitter feed (@tarides_)</a> for the latest updates.</p>
<br/>
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

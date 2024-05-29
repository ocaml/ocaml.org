---
title: Your Programming Language and its Impact on the Cybersecurity of Your Application
description: "Did you know that the programming language you use can have a huge impact
  on the cybersecurity of your applications? In a 2022 meeting of\u2026"
url: https://tarides.com/blog/2023-08-17-your-programming-language-and-its-impact-on-the-cybersecurity-of-your-application
date: 2023-08-17T00:00:00-00:00
preview_image: https://tarides.com/static/70275227498eaa34249beb282f986523/2070e/memory-safe-programming-languages.jpg
authors:
- Tarides
source:
---

<p><strong>Did you know that the programming language you use can have a huge impact on the cybersecurity of your applications?</strong></p>
<p>In a 2022 meeting of the Cybersecurity Advisory Committee, the Cybersecurity and Infrastructure Security Agency&rsquo;s Senior Technical Advisor Bob Lord commented that: <a href="https://www.nextgov.com/cybersecurity/2022/12/federal-government-moving-memory-safety-cybersecurity/381275/">&ldquo;About two-thirds of the vulnerabilities that we see year after year, decade after decade&rdquo;</a> are related to memory management issues.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#memory-unsafe-languages" aria-label="memory unsafe languages permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Memory Unsafe Languages</h2>
<p>One can argue that cyber vulnerabilities are simply a fact of life in the modern online world, which is why every application needs robust cyber security protections (applications, libraries, middleware, operating systems, tools, etc.). While this argument is not technically incorrect, there are still significant differences in the intrinsic security levels of different programming languages.</p>
<p>Computing devices today have access to huge amounts of memory in order to store, process, and retrieve information. Programming languages are used to describe the operations that a device needs to perform. The computer then interprets these operations to access and manipulate memory (of course, programming languages do many other things as well).</p>
<p>Among the various language paradigms, there are some widely used ones such as C and C++ that allow the developer to directly manipulate hardware memory. However, when a programmer writes code using these languages, it could result in attackers gaining access to hardware, stealing data, denying access to the user, and performing other malicious activities. Hence, these programming languages are termed as &ldquo;memory-unsafe&rdquo; languages.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#impact-of-memory-exploits" aria-label="impact of memory exploits permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Impact of Memory Exploits</h2>
<p>Around 60-70% of cyber attacks (attacks on applications, the operating system, etc.) are due to the use of these memory-unsafe programming languages.</p>
<p>This remains true for any computing platform. Memory issues represented around <a href="https://github.com/google/sanitizers/blob/master/hwaddress-sanitizer/MTE-iSecCon-2018.pdf">65% of critical security risks in the Chrome browser and Android operating system</a>. Similarly, memory unsafety issues also represented around <a href="https://alexgaynor.net/2020/may/27/science-on-memory-unsafety-and-security/">65% of total reported issues for the Linux kernel in 2019</a>. The Chromium web browser project has also reported that <a href="https://www.chromium.org/Home/chromium-security/memory-safety/">70% of high-severity security bugs</a> were related to memory safety. In iOS 12, <a href="https://support.apple.com/en-us/HT209192">66.3% of vulnerabilities</a> were related to handling memory.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#the-solution-memory-safety" aria-label="the solution memory safety permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The Solution: Memory Safety</h2>
<p>All this begs the question: is there a solution that can eliminate risks that exist due to a programming language&rsquo;s design, or is the only solution to use several layers of cybersecurity protection (code hardening, firewalls, etc.)?</p>
<p>Many cybersecurity and technology experts recommend using a &ldquo;memory-safe&rdquo; programming language, where a number of validation checks are performed during the translation from the human-readable programming language to the format that the machine reads. Many such programming languages exist, giving the developers several choices, for example: Go, Java, Ruby, Swift, and OCaml are all memory safe.</p>
<p>Does this mean that memory-safe languages are protected from all cyber attacks? No, but 60-70% of attacks are <strong>by design</strong> not permitted by the language. That is why most memory safe languages also offer crypto libraries, formal verification, and more in order to ensure the best possible cyber protection in addition to the strong protection the language itself provides. Of course, you also need to follow industry best practices for physical security, access controls, firewalls, data protection techniques, and other defence mechansims for people-centric security.</p>
<p>If you already work using memory-safe programming languages, you are on the right track. If you don&rsquo;t, we would be glad to tell you why companies like Jane Street, Tezos, Microsoft, Tarides, and Meta use OCaml to provide not only the best possible cybersecurity but also exceptional coding flexibility.</p>
<p>Don&rsquo;t hesitate to contact us via <a href="mailto:sales@tarides.com">sales@tarides.com</a> for more information or with any questions you may have.</p>
<p><strong>References</strong></p>
<ol>
<li>
<p>Report: Future of Memory Safety. <a href="https://advocacy.consumerreports.org/research/report-future-of-memory-safety/">https://advocacy.consumerreports.org/research/report-future-of-memory-safety/</a></p>
</li>
<li>
<p>NSA releases guidance on how to protect against software memory safety issues. <a href="https://www.nsa.gov/Press-Room/News-Highlights/Article/Article/3215760/nsa-releases-guidance-on-how-to-protect-against-software-memory-safety-issues/">https://www.nsa.gov/Press-Room/News-Highlights/Article/Article/3215760/nsa-releases-guidance-on-how-to-protect-against-software-memory-safety-issues/</a></p>
</li>
<li>
<p>The Federal Government is moving on memory safety for Cybersecurity. <a href="https://www.nextgov.com/cybersecurity/2022/12/federal-government-moving-memory-safety-cybersecurity/381275/">https://www.nextgov.com/cybersecurity/2022/12/federal-government-moving-memory-safety-cybersecurity/381275/</a></p>
</li>
<li>
<p>Memory Safety Convening Report 1.1. <a href="https://advocacy.consumerreports.org/wp-content/uploads/2023/01/Memory-Safety-Convening-Report-1-1.pdf">https://advocacy.consumerreports.org/wp-content/uploads/2023/01/Memory-Safety-Convening-Report-1-1.pdf</a></p>
</li>
<li>
<p>Chromium project memory safety. <a href="https://www.chromium.org/Home/chromium-security/memory-safety/">https://www.chromium.org/Home/chromium-security/memory-safety/</a></p>
</li>
</ol>

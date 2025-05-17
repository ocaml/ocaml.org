---
title: Caledonia
description:
url: https://ryan.freumh.org/caledonia.html
date: 2025-04-21T00:00:00-00:00
preview_image:
authors:
- Ryan Gibb
source:
---

<article>
    <div class="container">
        
        <span>Published 21 Apr 2025.</span>
        
        
    </div>
    
        <div> Tags: <a href="https://ryan.freumh.org/projects.html" title="All pages tagged 'projects'." rel="tag">projects</a>. </div>
    
    <section>
        <p><span><a href="https://github.com/RyanGibb/caledonia">Caledonia</a> is a calendar
client with command-line and Emacs front-ends. It operates on a <a href="https://pimutils.org/specs/vdir/">vdir</a> directory of <a href="https://datatracker.ietf.org/doc/html/rfc5545">.ics</a> files as
managed by tools like <a href="https://github.com/pimutils/vdirsyncer">vdirsyncer</a>, which
allows it to interact with CalDAV servers. The command-line has the
<code class="verbatim">list</code>, <code class="verbatim">search</code>, <code class="verbatim">show</code>,
<code class="verbatim">add</code>, <code class="verbatim">delete</code>,
and <code class="verbatim">edit</code> subcommands, and has full
timezone support.</span></p>
<p><span>An example <code class="verbatim">list</code>
invocation is,</span></p>
<pre class="example"><code>$ caled list
personal   2025-04-04 Fri 13:00 - 14:00 (America/New_York) New York 8am meeting      054bb346-b24f-49f4-80ab-fcb6040c19a7
family     2025-04-06 Sun 21:00 - 22:00 (UTC)              Family chat @Video call   3B84B125-6EFC-4E1C-B35A-97EFCA61110E
work       2025-04-09 Wed 15:00 - 16:00 (Europe/London)    Weekly Meeting            4adcb98dfc1848601e38c2ea55edf71fab786c674d7b72d4c263053b23560a8d
personal   2025-04-10 Thu 11:00 - 12:00 (UTC)              Dentist                   ccef66cd4d1e87ae7319097f027f8322de67f758
family     2025-04-13 Sun 21:00 - 22:00 (UTC)              Family chat @Video call   3B84B125-6EFC-4E1C-B35A-97EFCA61110E
personal   2025-04-15 Tue - 2025-04-17 Thu                 John Doe in town          33cf18ec-90d3-40f8-8335-f338fbdb395b
personal   2025-04-15 Tue 21:00 - 21:30 (UTC)              Grandma call              8601c255-65fc-4bc9-baa9-465dd7b4cd7d
work       2025-04-16 Wed 15:00 - 16:00 (Europe/London)    Weekly Meeting            4adcb98dfc1848601e38c2ea55edf71fab786c674d7b72d4c263053b23560a8d
personal   2025-04-19 Sat                                  Jane Doe's birthday       7hm4laoadevr1ene8o876f2576@google.com
family     2025-04-20 Sun 21:00 - 22:00 (UTC)              Family chat @Video call   3B84B125-6EFC-4E1C-B35A-97EFCA61110E
personal   2025-04-22 Tue 21:00 - 21:30 (UTC)              Grandma call              8601c255-65fc-4bc9-baa9-465dd7b4cd7d
work       2025-04-23 Wed 15:00 - 16:00 (Europe/London)    Weekly Meeting            4adcb98dfc1848601e38c2ea55edf71fab786c674d7b72d4c263053b23560a8d
family     2025-04-27 Sun 21:00 - 22:00 (UTC)              Family chat @Video call   3B84B125-6EFC-4E1C-B35A-97EFCA61110E
personal   2025-04-29 Tue 21:00 - 21:30 (UTC)              Grandma call              8601c255-65fc-4bc9-baa9-465dd7b4cd7d
work       2025-04-30 Wed 15:00 - 16:00 (Europe/London)    Weekly Meeting            4adcb98dfc1848601e38c2ea55edf71fab786c674d7b72d4c263053b23560a8d
</code></pre>
<p><span>The Emacs client communicates with <code class="verbatim">caled server</code> using a S-expression based
protocol.</span></p>
<h2>Installation</h2>
<p><span>With <a href="https://opam.ocaml.org/">opam</a>,</span></p>
<div class="sourceCode" data-org-language="sh"><pre class="sourceCode bash"><code class="sourceCode bash"><span><a href="https://ryan.freumh.org/atom.xml#cb2-1" aria-hidden="true" tabindex="-1"></a><span class="ex">$</span> git clone https://tangled.sh/@ryan.freumh.org/caledonia</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb2-2" aria-hidden="true" tabindex="-1"></a><span class="ex">$</span> opam install ./caledonia</span></code></pre></div>
<p><span>With <a href="https://ryan.freumh.org/nix.html">Nix</a>,</span></p>
<div class="sourceCode" data-org-language="sh"><pre class="sourceCode bash"><code class="sourceCode bash"><span><a href="https://ryan.freumh.org/atom.xml#cb3-1" aria-hidden="true" tabindex="-1"></a><span class="ex">$</span> nix shell <span class="st">'git+https://tangled.sh/@ryan.freumh.org/caledonia?ref=main'</span></span></code></pre></div>
<h2>Configuration</h2>
<p><span>Caledonia looks for calendars in the
directory specified by the `CALENDAR_DIR` environment variable or in
`~/.calendars/` by default.</span></p>
<h2>Thanks</h2>
<p><span>To <a href="https://patrick.sirref.org/">Patrick</a> for suggesting the name,
and all the developers of the dependencies used, especially <a href="https://github.com/robur-coop/icalendar">icalendar</a> and <a href="https://github.com/daypack-dev/timere">timere</a>.</span></p>
<h2>Source</h2>
<ul>
<li><a href="https://tangled.sh/@ryan.freumh.org/caledonia">Tangled</a></li>
<li><a href="https://github.com/RyanGibb/caledonia">GitHub</a></li>
</ul>
    </section>
</article>


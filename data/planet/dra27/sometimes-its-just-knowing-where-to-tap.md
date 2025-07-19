---
title: "Sometimes it\u2019s just knowing where to tap"
description: '```diff @@ -44,6 +44,8 @@ # the lines involved in the conflict, which
  is arguably worse #/Changes merge=union'
url: https://www.dra27.uk/blog/platform/2025/07/18/where-to-tap.html
date: 2025-07-18T00:00:00-00:00
preview_image:
authors:
- ""
source:
ignore:
---

<div class="language-diff highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="p">@@ -44,6 +44,8 @@</span>
 # the lines involved in the conflict, which is arguably worse
 #/Changes                 merge=union

+testsuite                export-ignore
<span class="gi">+
</span> # No header for text and META files (would be too obtrusive).
 *.md                     typo.missing-header
 README*                  typo.missing-header
</code></pre></div></div>

<p>First time users of OCaml on Windows: <strong>25% speedup on switch creation</strong>. All
platforms gain a benefit, even if it’s much smaller. As both <a href="https://www.youtube.com/watch?v=qbKGw8MQ0i8">rustup</a>
and <a href="https://www.youtube.com/watch?v=gSKTfG1GXYQ">uv</a> have taught us: don’t do
stuff you don’t need to (uv) and making Windows better usually benefits Linux,
or at least doesn’t make it worse (rustup).</p>

<p>PR to follow soon: it turns out it’s worth tapping a few more times, but then a
little bit of soldering is needed…</p>

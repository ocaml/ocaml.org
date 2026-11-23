---
title: Was software just always too complex for humans?
description: Musings on whether we (as a species) royally screwed up by trying to
  run before we could walk with software in society
url: https://anil.recoil.org/notes/software-too-complex-for-humans
date: 2026-11-22T00:00:00-00:00
preview_image: https://anil.recoil.org/images/maths-vs-cs-loc.640.webp
authors:
- Anil Madhavapeddy
source:
ignore:
keywords:
- agents
- diversity
- formal
- harnesses
- human
- humans
- madhavapeddy
- society
- software
- specs
---

<p>I was <a href="https://leanprover.zulipchat.com/#narrow/channel/113488-general/topic/Discussion.3A.20Alp.C3.B6ge.20Proves.20the.20Riemann.20Hypothesis">glued to the Lean chat</a> as the legendary <a href="https://en.wikipedia.org/wiki/Riemann_hypothesis#Alp%C3%B6ge_alleged_proof">Riemann hypothesis was cracked</a> via 17 million (!) lines of AI-assisted code last week. This has since been <a href="https://leanprover-community.github.io/blog/posts/riemann-hypothesis/">certified correct</a> despite <a href="https://www.science.org/content/article/ai-may-have-solved-math-s-greatest-mystery-can-humans-understand-answer">no human (yet) understanding</a> how it works.
The future of maths, and much science, is clearly going to involve human-AI boosting.</p>
<p>However, it also struck me deeply just how broken software engineering has been for my entire life!
There's always been an imbalance between our understanding of the theory of computation and our relentless drive to deploy software throughout society. We're paying the piper now as all those decades of human-written code turn out to be full of bugs. Since software essentially drives society now, weird things happen like <a href="https://www.bbc.com/news/articles/c6eq49zyx7p4o">supermarket fridges needing James Bond to secure them</a>. This has led to people like <a href="https://x.com/wtgowers/status/2124287061620613160">Tim Gowers joining</a> the <a href="https://www.bbc.co.uk/news/articles/cmvg23q5xq31o">Pause AI march</a>.</p>
<p>How the hell did we get here? Have we just completely overestimated the human ability to write software? Or will software engineering 'catch up' once LLM harnesses get better?</p>
<p>Software was reasonably under control in pre-AI times when attackers were roughly symmetric with defenders, but all the recent <a href="https://www.bbc.co.uk/news/articles/c6z0kly2lll7o">mysteriously correlated outages</a> and disclosed issues (<a href="https://cyberscoop.com/java4shell-critical-java-flaw-openjdk/">Java</a>, <a href="https://en.wikipedia.org/wiki/PHP2Shell">PHP</a>, <a href="https://openai.com/index/a-thousand-fewer-paths-to-root/">Linux</a>) all point to an <a href="https://anil.recoil.org/notes/rumour-is-the-exploit">acceleration</a> of security pain in 2027.
I only see two ways this can go...</p>
<p><a href="https://x.com/headinthebox/status/2124248546157432852"> <img src="https://anil.recoil.org/images/maths-vs-cs-loc.webp" alt="%c" title="The difference between mathematics and computer science, via Erik Meijer"> </a></p>
<h2><a href="https://anil.recoil.org/news.xml#derive-everything-from-specifications" class="anchor" aria-hidden="true"></a>Derive everything from specifications</h2>
<p>In April this year, I <a href="https://anil.recoil.org/notes/internet-immune-system">couldn't believe</a> we'd ever formally specify every layer of hardware and software:</p>
<blockquote>
<p>I find it hard to believe that we will <strong>formally specify all layers of hardware
and software and roll them out into production</strong>...ever. <a href="https://en.wikipedia.org/wiki/A_Fire_Upon_the_Deep">A Fire Upon the Deep</a>'s
software archeologists are a profession that's <a href="https://www.indeed.com/jobs?q=Cobol&amp;fromage=14&amp;vjk=6773c80abba24067">here today</a> and not a scifi trope.
<cite>-- <a href="https://anil.recoil.org/notes/internet-immune-system">The Internet needs an antibotty immune system, stat</a>, April 2026</cite></p>
</blockquote>
<p>How a few months makes a difference. With the pace of frontier model advances, translating the vast body of existing legacy code seems entirely plausible <em>if</em> we first speedrun towards defining formal specifications for all of our services, and derive <em>all new</em> software from those as well.</p>
<p>That means rebuilding operating system stacks from the ground up and even <a href="https://architectlabs.com/blog/frostbite">reengineering instruction sets</a> to match. There are <a href="https://x.com/yminsky/status/2123949643121696822">terrible legacy interfaces</a> throughout the stack, largely because our software layers grew so that human groups could scale working on different parts. Other approaches do make it easier though. <a href="https://anil.recoil.org/projects/unikernels">Unikernels</a> with a <a href="https://anil.recoil.org/papers/2013-asplos-mirage">libOS</a> linking discipline plus <a href="https://youtu.be/abDWZ9D8kEE?list=PLyrlk8Xaylp4ZOkYWR5676Qxd22Y5f9xv">shared memory</a> interconnects are <a href="https://anil.recoil.org/notes/icfp25-post-posix">remarkably composable</a> and allow agents to specialise the whole stack at link time, with fewer interfaces making the <a href="https://anil.recoil.org/ideas/lean-io-uring-backend">specification task less daunting</a>.</p>
<p>Having good specs also conveniently takes humans out of the security response patch loop. Attackers are currently bounded only by their desire to break in somewhere, while defenders have to wait on <a href="https://anil.recoil.org/notes/rumour-is-the-exploit">maintainer triage</a>. However, fixes re-derived from a formal spec and machine-checked could work more reliably in a timely fashion. The human job remains <a href="https://anil.recoil.org/notes/ocaml-modules-agentic">writing the interfaces</a> iteratively with an AI.</p>
<h2><a href="https://anil.recoil.org/news.xml#engineer-diversity-in-deliberately" class="anchor" aria-hidden="true"></a>Engineer diversity in deliberately</h2>
<p>Historically, software has tended towards a monoculture through reuse, so <a href="https://therecord.media/cisa-issues-java4shell-alert">one bug</a> can screw over vast numbers of hosts. Agents could instead force diversity via novel <a href="https://anil.recoil.org/papers/2025-internet-ecology">'genetic' mechanisms</a> so digital services aren't all simultaneously infected. This works well with formal specifications, since any decent spec allows <a href="https://anil.recoil.org/papers/2015-sosp-sibylfs">multiple valid implementations</a>.  The Internet's entire philosophy is based around <a href="https://en.wikipedia.org/wiki/Robustness_principle">Postel's Law</a> and encouraging hosts to be liberal in what we receive and strict in what we transmit.</p>
<p>The catch, of course, is having just a handful of <a href="https://www.anthropic.com/glasswing">gated frontier models</a> generating all our software takes us out of the frying pan into an AI controlled fire.  The diversity has to extend <em>beyond</em> the code to the models and harnesses too. We seem to have done ok with <a href="https://www.rfc-editor.org/">Internet RFCs</a> not splintering too much, so perhaps formal specs can remain singular. Once that's done, it's time to go let hosts <a href="https://anil.recoil.org/notes/rewilding-the-web-report">mutate and inoculate</a> each other and generally maximise unpredictability at scale!</p>
<h2><a href="https://anil.recoil.org/news.xml#digital-society-is-going-to-have-to-change" class="anchor" aria-hidden="true"></a>Digital society is going to have to change</h2>
<p>To answer my opening question, I don't think better harnesses and models <em>alone</em> will let software engineering catch up, as they just produce mountains of slop code. We need <em>both</em> of the above; formal specifications that let hosts finally be strict about what they receive instead of liberally accepting whatever shows up, while diversity ensures that things that the specs (inevitably) don't capture doesn't break everywhere, everywhere all at once.</p>
<p>The real upheaval here will be to social coding though. Open source communities have run on social contracts of human review and trust built up over decades, and every single one I'm a member of is struggling under matters of <a href="https://anil.recoil.org/notes/opam-ai-disclosure-update">AI disclosure</a> and <a href="https://blog.tangled.org/vouching/">trust</a>.</p>
<p>At least humans aren't out of a job yet though!
Somebody still has to decide what our specs contain, as we have done for decades with RFCs. There's also plenty of new computer science research needed! We need to figure out how to <a href="https://anil.recoil.org/ideas/antibotty-testbed">debug diversity</a> when no two nodes run the same code, and on how to force simplicity on systems that agents maintain, and ultimately how we settle the blame games when things do go wrong...</p>
<p><small class="credits">(Thanks to <a href="https://dave.recoil.org">Dave Scott</a>, <a href="https://kcsrk.info">KC Sivaramakrishnan</a>, <a href="https://github.com/samoht">Thomas Gazagnaire</a> and <a href="https://toao.com">Sadiq Jaffer</a> for helpful conversations about this post, and to <a href="https://github.com/yminsky">Yaron Minsky</a> for triggering this line of thought with his eBPF observations)</small></p><h1>References</h1><ul><li>Madhavapeddy et al (2025). Steps towards an Ecology for the Internet. Association for Computing Machinery. <a href="https://doi.org/10.1145/3744169.3744180" target="_blank"><i>10.1145/3744169.3744180</i></a></li>
<li>Madhavapeddy (2026). OCaml's module language is the perfect fit for agentic programming. <a href="https://doi.org/10.59350/g6hbj-qmc76" target="_blank"><i>10.59350/g6hbj-qmc76</i></a></li>
<li>Madhavapeddy (2026). Just a rumour of a bug is enough to find a security exploit these days. <a href="https://doi.org/10.59350/tngsm-6rx23" target="_blank"><i>10.59350/tngsm-6rx23</i></a></li>
<li>Madhavapeddy (2025). It's time to go post-POSIX at ICFP/SPLASH 2025. <a href="https://doi.org/10.59350/mch1m-8a030" target="_blank"><i>10.59350/mch1m-8a030</i></a></li>
<li>Madhavapeddy (2026). Rewilding the Web: my workshop report from Edinburgh. <a href="https://doi.org/10.59350/g40yy-ks003" target="_blank"><i>10.59350/g40yy-ks003</i></a></li>
<li>Madhavapeddy (2026). The Internet needs an antibotty immune system, stat. <a href="https://doi.org/10.59350/snnnf-asc02" target="_blank"><i>10.59350/snnnf-asc02</i></a></li>
<li>Ridge et al (2015). SibylFS: formal specification and oracle-based testing for POSIX and real-world file systems. ACM. <a href="https://doi.org/10.1145/2815400.2815411" target="_blank"><i>10.1145/2815400.2815411</i></a></li>
<li>Madhavapeddy et al (2013). Unikernels: library operating systems for the cloud. ACM. <a href="https://doi.org/10.1145/2451116.2451167" target="_blank"><i>10.1145/2451116.2451167</i></a></li></ul>

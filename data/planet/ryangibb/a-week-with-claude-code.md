---
title: A Week With Claude Code
description:
url: https://ryan.freumh.org/claude-code.html
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
    
    <section>
        <p><span>I tried using <a href="https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview">Claude
Code</a> while writing <a href="https://ryan.freumh.org/caledonia.html">Caledonia</a>, and these
are the notes I took on the experience. It’s possible some of the
deficiencies are due to the model’s smaller training set of OCaml code
compared to more popular languages, but there’s <a href="https://www.youtube.com/watch?v=0ML7ZLMdcl4">work being done</a>
to improve this situation.</span></p>
<p><span>It needs a lot of hand-holding, often finding it
very difficult to get out of simple mistakes. For example, it frequently
forgot to bracket nested match statements,</span></p>
<div class="sourceCode"><pre class="sourceCode ocaml"><code class="sourceCode ocaml"><span><a href="https://ryan.freumh.org/atom.xml#cb1-1" aria-hidden="true" tabindex="-1"></a><span class="kw">match</span> expr1 <span class="kw">with</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb1-2" aria-hidden="true" tabindex="-1"></a>| Pattern1 -&gt;</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb1-3" aria-hidden="true" tabindex="-1"></a>    <span class="kw">match</span> expr2 <span class="kw">with</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb1-4" aria-hidden="true" tabindex="-1"></a>    | Pattern2a -&gt; result2a</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb1-5" aria-hidden="true" tabindex="-1"></a>    | Pattern2b -&gt; result2b</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb1-6" aria-hidden="true" tabindex="-1"></a>| Pattern2 -&gt; result2</span></code></pre></div>
<p><span>and it found it difficult to fix this as the
compiler error message only showed the line with <code class="verbatim">Pattern2</code>. An interesting note here is that tools
that are easy for humans to use, e.g. with great error messages, are
also easy for the LLM to use. But, unlike (I hope) a human, even after
adding a rule to avoid this in <code class="verbatim">CLAUDE.md</code>
it frequently ignored it.</span></p>
<p><span>It often makes code very verbose or inelegant,
especially after repeated rounds of back-and-forth with the compiler. It
rarely shortens code, whereas some of the best changes I make to
codebases have a negative impact on the lines of code (LoC) count. I
think this is how you end up with <a href="https://news.ycombinator.com/item?id=43553031">35k LoC</a> recipe
apps, and I wonder how maintainable these codes bases will
be.</span></p>
<p><span>If you give it a high level task, even after
creating an architecture plan, it often makes poor design decisions that
don’t consider future scenarios. For example, it combined all the <code class="verbatim">.ics</code> files into a single calendar which when it
comes to modifying events them will make it impossible to write edits
back. Another example of where it unnecessarily constrained interfaces
was by making query and sorting parameters variants, whereas <a href="https://github.com/RyanGibb/caledonia/commit/d97295ec46699fbe91fd4c15f9eef10b80c136f1#diff-08751a7fee23e5d1046033b7792d84a759ea253862ba382a492d0621727a097c">porting</a>
to a lambda and comparator allowed for more expressivity with the same
brevity.</span></p>
<p><span>But while programming I often find myself doing a
lot of ‘plumbing’ things through, and it excels at these more mundane
tasks. It’s also able to do more intermediate tasks, with some back and
forth about design decision. For example, once I got the list command
working it was able to get the query command working without me writing
any code – just prompting with design suggestions like pulling common
parameters into a separate module (see the verbosity point again).
Another example of a task where it excels is writing command line
argument parsing logic, with more documentation than I would have the
will to write myself.</span></p>
<p><span>It’s also awesome to get it to write tests where I
would never otherwise for a personal project, even with the above
caveats applying to them. It also gives the model something to check
against when making changes, though when encountering errors with tests
it tends to change the test to be incorrect to pass the compiler, rather
than fixing the underlying problem.</span></p>
<p><span>It’s somewhat concerning that this agent is running
without any sandboxing. There is some degree of control over what
directories it can access, and what tools it can invoke, but I’m sure a
sufficiently motivated adversary could trivially get around all of them.
While deploying <a href="https://ryan.freumh.org/enki.html">Enki</a> on <a href="https://github.com/RyanGibb/nixos/tree/master/hosts/hippo">hippo</a>
I tested out using it to change the NixOS config, and after making the
change it successfully invoked <code class="verbatim">sudo</code> to do
a <code class="verbatim">nixos-rebuild switch</code> as I had just used
sudo myself in the same shell session. Patrick’s work on <a href="https://patrick.sirref.org/shelter/index.xml">shelter</a> could
prove invaluable for this, while also giving the agent ‘rollback’
capabilities!</span></p>
<p><span>Something I’m wondering about while using these
agents is whether they’ll just be another tool to augment the
capabilities of software engineers; or if they’ll increasingly replace
the need for software engineers entirely.</span></p>
<p><span>I tend towards the former, but only time will
tell.</span></p>
<p><span>If you have any questions or comments on this feel
free to <a href="https://ryan.freumh.org/about.html#contact">get in touch</a>.</span></p>
    </section>
</article>


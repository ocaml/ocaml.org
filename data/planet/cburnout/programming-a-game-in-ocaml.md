---
title: Programming a Game in OCaml
description: Herein I'll provide an introductory taste of what it's been like making
  a game in OCaml.   I've been developing a "Tactical RPG" game, whic...
url: https://cranialburnout.blogspot.com/2013/09/programming-game-in-ocaml.html
date: 2013-09-12T01:02:00-00:00
preview_image: //2.bp.blogspot.com/-A6Z4RA27kWk/UjDl4WuVIPI/AAAAAAAAACw/ZF3IJfPd-a8/w1200-h630-p-k-no-nu/at.png
featured:
authors:
- Tony Tavener
---

<div dir="ltr" style="text-align: left;" trbidi="on">
Herein I'll provide an introductory taste of what it's been like making a game in OCaml.<br/>
<br/>
I've been developing a &quot;Tactical RPG&quot; game, which is based on the <a href="http://www.atlas-games.com/arm5/" target="_blank">Ars Magica</a> roleplaying setting and rules. Developement name is &quot;Ars Tactica&quot;. (I haven't sought out Atlas Games about legal ramifications, deals, or licensing &mdash; not until I have something worthwhile to share!)<br/>
<br/>
There isn't much to show off now, but here's a screenshot:<br/>
<br/>
<div class="separator" style="clear: both; text-align: center;">
<a href="http://2.bp.blogspot.com/-A6Z4RA27kWk/UjDl4WuVIPI/AAAAAAAAACw/ZF3IJfPd-a8/s1600/at.png" imageanchor="1" style="margin-left: 1em; margin-right: 1em;"><img src="http://2.bp.blogspot.com/-A6Z4RA27kWk/UjDl4WuVIPI/AAAAAAAAACw/ZF3IJfPd-a8/s1600/at.png" border="0"/></a></div>
<br/>
<br/>
The figures are placeholders. They're from photos of painted miniatures, found online. At this point I'm using other people's images, fonts, and game system &mdash; so what am <i>I</i> doing?<br/>
<br/>
I'm writing code, in a language which should be better known: <a href="http://ocaml.org/" target="_blank">OCaml</a>.<br/>
<br/>
OCaml is an unusual choice for games. Almost all games are written in C++; before that it was C, and before that ASM. Now we have games being made in C#, Java, Python, and more... and these are imperative languages. OCaml is an unusual choice because, at heart, it's functional.<br/>
<br/>
<br/>
<div style="text-align: left;">
<b><u>
Rising awareness</u></b></div>
<br/>
In the past couple of years I've watched the growing interest in functional programming with some elation. Game developers have been making forays into it for a bit longer. Chris Hecker tried OCaml way back around 2005. Tim Sweeney did a presentation: <a href="http://www.st.cs.uni-saarland.de/edu/seminare/2005/advanced-fp/docs/sweeny.pdf" target="_blank">The Next Mainstream Programming Language</a> (link is to a PDF of the slides). Carmack has addressed the value of functional techniques applied toward games numerous times: <a href="http://www.altdevblogaday.com/2012/04/26/functional-programming-in-c/" target="_blank">Functional Programming in C++</a> (blog post), <a href="http://youtu.be/1PhArSujR_A?t=2m07s" target="_blank">Portion of 2013 keynote</a> (youtube). Of course, there's also Naughty Dog with their scripting language being Scheme-like... since Crash Bandicoot?<br/>
<br/>
<br/>
<div style="text-align: left;">
<b><u>
How do you make a game in a functional language?</u></b></div>
<br/>
When I was first looking into OCaml (2005), it was beyond my comprehension how a (non-trivial) game could be made. What does functional game code look like!?<br/>
<br/>
Functional code favors return-values, rather than changing a variable in-place. However, typical game code looks like a whole bunch of loops, controlled by counters or other changing variables, with the loop bodies mutating data in-place, step by step. Probably easy to imagine if you think of a loop over &quot;all active game pieces&quot;, calling some <i>update</i> function on each &mdash; which might loop over sub-components, updating those in turn.<br/>
<br/>
So how do you even do a loop in functional code without some kind of mutable counter? (Well, a practical language like OCaml does support imperative loops... but I rarely use them.) Recursion works...<br/>
<br/>
<pre>  <span class="Keyword">let</span> <span class="Keyword">rec</span> loop count <span class="Keyword">=</span>
    <span class="Include">Printf</span>.printf <span class="String">&quot;Countdown: %d\n%!&quot;</span> count<span class="Keyword">;</span>
    <span class="Conditional">if</span> count <span class="Operator">&gt;</span> <span class="Float">0</span> <span class="Conditional">then</span> loop <span class="Delimiter">(</span>count<span class="Operator">-</span><span class="Float">1</span><span class="Delimiter">)</span>
    <span class="Keyword">else</span> <span class="Constant">()</span><span class="Operator">;;</span>

  loop <span class="Float">10</span>
</pre>
<br/>
This will loop with a count-down, feeding back the new count each time. If you think this is pretty terrible, I'll agree &mdash; a while or for-loop would be more straight-forward in this trivial example.<br/>
<br/>
<br/>
Here's a bit of my current main-loop, showing its overall form:<br/>
<br/>
<pre>  <span class="Keyword">let</span> <span class="Keyword">rec</span> mainloop <span class="Label">~</span><span class="Identifier">stage</span> <span class="Label">~</span><span class="Identifier">actors</span> <span class="Label">~</span><span class="Identifier">controls</span> <span class="Label">~</span><span class="Identifier">lasttime</span> <span class="Keyword">=</span>
    <span class="Keyword">let</span> t <span class="Keyword">=</span> time <span class="Constant">()</span> <span class="Keyword">in</span>
    <span class="Keyword">let</span> dt <span class="Keyword">=</span> min <span class="Delimiter">(</span>t <span class="Operator">-.</span> lasttime<span class="Delimiter">)</span> dt_max <span class="Keyword">in</span>
    <span class="Comment">(* ... *)</span>
    <span class="Keyword">let</span> controls' <span class="Keyword">=</span> <span class="Include">Control</span>.run controls surface dt <span class="Keyword">in</span>
    <span class="Comment">(* ... *)</span>
    <span class="Conditional">if</span> run_state <span class="Keyword">=</span> <span class="Constant">StateQuit</span> <span class="Conditional">then</span> <span class="Constant">()</span>
    <span class="Keyword">else</span> mainloop <span class="Label">~</span><span class="Identifier">stage</span> <span class="Label">~</span><span class="Identifier">actors</span> <span class="Label">~</span><span class="Identifier">controls</span>:controls' <span class="Label">~</span><span class="Identifier">lasttime</span>:t


  mainloop
    <span class="Label">~</span><span class="Identifier">stage</span>
    <span class="Label">~</span><span class="Identifier">actors</span>: ordered
    <span class="Label">~</span><span class="Identifier">controls</span>: <span class="Delimiter">(</span><span class="Include">Control</span>.init <span class="Type">[</span> exit_control<span class="Keyword">;</span> time_control<span class="Keyword">;</span> game_control cam_id <span class="Type">]</span><span class="Delimiter">)</span>
    <span class="Label">~</span><span class="Identifier">lasttime</span>: <span class="Float">0</span>.
</pre>
<br/>
It follows the same structure as the simple recursive countdown: initial value(s), a terminal condition, and feeding-back the changing state.<br/>
<br/>
I used labeled parameters here (eg <code>~controls</code>) to help make it clear what can change from frame-to-frame. Since almost everything can change in a game, the data hiding under <code>stage</code> (for example) might be quite extensive.<br/>
<br/>
Now it might be apparent how functional code looks: rather than updating things in-place, you create new values, (old values are discarded if unused, via garbage-collection). This might seem atrocious from a game-programming perspective: you've already allocated space &mdash; re-use it!<br/>
<br/>
Honestly, it took me a while to be able to put aside that concern and just accept the garbage collector. But over time, the continual feedback was a combination of: fewer bugs, more pleasant code with less worry, and the garbage-collector was quiet enough that I rarely notice it. Much like acquiring a taste for a suspicious food, I was hooked once the suspicion was put to rest and the taste turned out to be good.<br/>
<br/>
Note that a sufficiently smart compiler could re-use allocations, effectively generating the same code as in-place mutation &mdash; and only in cases where it has deemed this to be safe! I don't know if OCaml does this in any cases, but its garbage collector has been handling my massive per-frame allocations surprisingly well.<br/>
<br/>
Returning to looping, most loops aren't explicit like my <code>mainloop</code>. Instead they are abstracted as a <code>fold</code>, <code>map</code>, or <code>iter</code>. These abstractions are enough to cover most use-cases, but you don't see them in imperative languages because they rely on higher-order functions.<br/>
<br/>
<br/>
OCaml has imperative features. You can modify values in-place, and I'll sometimes use global references for changable state until I figure out a better fit:<br/>
<br/>
<pre>  <span class="Keyword">let</span> g_screenwid <span class="Keyword">=</span> ref <span class="Float">0</span>
  g_screenwid <span class="Keyword">:=</span> <span class="Float">800</span><span class="Keyword">;</span>
</pre>
<br/>
Arrays are mutable by default, and I use these for image and vertex data. Most of my game logic and data-structures are immutable lists, trees, zips, or queues.<br/>
<br/>
I've made another post with some of my take on:&nbsp;<a href="http://cranialburnout.blogspot.ca/2013/09/avoiding-mutable-state.html" target="_blank">What is bad about mutable state?</a><br/>
<br/>
<br/>
With most of the code striving for immutability, I get to enjoy easier composition of functions. Some of the most elegant code (I think) ends up piping data. An example from the game is part of the &quot;casting score&quot; calculation:<br/>
<br/>
<pre>    <span class="Delimiter">(</span>value,botch<span class="Delimiter">)</span> <span class="Operator">|&gt;</span> fast_cast fastcasting
                  <span class="Operator">|&gt;</span> raw_vis pawns
                  <span class="Operator">|&gt;</span> <span class="Include">Realm</span>.<span class="Delimiter">(</span>apply_aura aura <span class="Constant">Magic</span><span class="Delimiter">)</span>
                  <span class="Operator">|&gt;</span> <span class="Include">Modifier</span>.apply magus score'k
                  <span class="Operator">|&gt;</span> apply_mastery mastery
</pre>
<br/>
Here, the computed <code>(value,botch)</code> pair is further modified by circumstances, passed through other systems, finally returning the result of <code>apply_mastery mastery</code>. This is a simple case of such piping, in that the type of input and output is the same at each stage (an integer pair). Often there will be a transformative aspect, which works as long as an output type is matched to the input type in each stage.<br/>
<br/>
This post may be a bit haphazard and rambling, as I'm not clear who my audience might be... game-developers looking into functional programming, or OCaml programmers looking to make a game? I think I tried to cut a middle-ground. I expect future posts will be much more focused.<br/>
<br/></div>


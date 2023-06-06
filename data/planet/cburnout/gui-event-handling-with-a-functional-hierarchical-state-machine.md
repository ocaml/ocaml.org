---
title: GUI Event Handling with a Functional Hierarchical State Machine
description: A journey toward a state-machine without mutable state, but enough flexibility
  to express GUI behaviors. This is nothing new in it's parts...
url: https://cranialburnout.blogspot.com/2014/03/gui-event-handling-with-functional.html
date: 2014-03-04T21:01:00-00:00
preview_image: //2.bp.blogspot.com/-fQqHiEE-jtk/UxY6XetmVlI/AAAAAAAAAEE/kaRH8asimSk/w1200-h630-p-k-no-nu/ttip.png
featured:
authors:
- Tony Tavener
---

<div dir="ltr" style="text-align: left;" trbidi="on">
<br/>
A journey toward a state-machine without mutable state, but enough flexibility to express GUI behaviors. This is nothing new in it's parts, but maybe as a whole. In scouring GUI lore there is very little in a functional style.<br/>
<br/>
I had a &quot;feel&quot; for how I wanted event handling to be, but it wasn't clear. Initially I wrote some wishful thinking pseudo-code:<br/>
<br/>
<pre>  <span class="Keyword">let</span> tooltip <span class="Label">?</span><span class="Delimiter">(</span><span class="Identifier">delay</span><span class="Keyword">=</span><span class="Float">1</span>.<span class="Delimiter">)</span> <span class="Label">?</span><span class="Delimiter">(</span><span class="Identifier">show</span><span class="Keyword">=</span><span class="Float">5</span>.<span class="Delimiter">)</span> <span class="Label">?</span><span class="Delimiter">(</span><span class="Identifier">style</span><span class="Keyword">=</span>tooltip_style<span class="Delimiter">)</span> text <span class="Keyword">=</span>
    on_enter <span class="Delimiter">(</span><span class="Keyword">fun</span> id <span class="Function">-&gt;</span>
      after delay <span class="Delimiter">(</span><span class="Keyword">fun</span> id <span class="Function">-&gt;</span>
        <span class="Keyword">let</span> tip <span class="Keyword">=</span> make_tooltip style text <span class="Keyword">in</span>
        after show <span class="Delimiter">(</span><span class="Keyword">fun</span> id <span class="Function">-&gt;</span> delete tip <span class="Comment">(* and what is the active state now? *)</span><span class="Delimiter">)</span>
      <span class="Delimiter">)</span>
    <span class="Delimiter">)</span>
</pre>
<br/>
I like the style of chaining functions which are awaiting events to continue. Another variation I considered was with a <i>yield</i>-like operation, but that looked like a vertical stack of statements without clear structure.<br/>
<br/>
Anyway, the above example was really declaring a state-machine with each state able to return a replacement state.<br/>
<br/>
<br/>
<h3 style="text-align: left;">
<u>Playing with State Machines</u></h3>
<br/>
I drew some state diagrams, and they were as messy as they always seem to be -- special cases and redundant states to deal with &quot;one thing is different, even though mostly things are the same as this other state&quot;. After a lot of futzing about I realized some details: to avoid a redundant explosion of states I could leverage parent states which have child states and the parent transitioning also cleans up the children. This is because state machines often have exception-like transitions. Here is an example of the full tooltip:<br/>
<br/>
<pre>        start:(on_enter)
                  |
                  v
    (on_leave (on_use (after delay)))
        |         |        |
        v         v        v
      start      ( )  (after show)
                           |
                           v
                          ( )
</pre>
<br/>
So, at &quot;start&quot;, we are awaiting <code>on_enter</code>. Once that triggers, we replace the current state with one having a (parent (parent (child))) chain of <code>on_leave</code>, <code>on_use</code>, and <code>after delay</code>. This means the delayed show and hide of the tooltip is on its own, but can be interrupted by either <code>on_use</code> (say, clicking the button) or <code>on_leave</code>. For example, if the initial delay is passed, the tooltip is displayed and the current state is:<br/>
<br/>
<pre>    (on_leave (on_use (after show)))
        |         |        |
</pre>
<br/>
Here, <code>after show</code> has replaced <code>after delay</code>. Now if on_use occurs, it transitions (to nothing) and also removes its child state, leaving us with:<br/>
<br/>
<pre>    (on_leave)
</pre>
<br/>
<br/>
<h3 style="text-align: left;">
<u>And in Code</u></h3>
<br/>
First, a general n-ary tree, and a type <code>consumed</code> to specify whether a matching event terminates at this handler, or propagates onward.<br/>
<br/>
<pre>  <span class="Keyword">type</span> 'a tree <span class="Keyword">=</span> <span class="Constant">Child</span> <span class="Keyword">of</span> 'a <span class="Operator">|</span> <span class="Constant">Parent</span> <span class="Keyword">of</span> 'a <span class="Operator">*</span> <span class="Delimiter">(</span>'a tree<span class="Delimiter">)</span> <span class="Type">list</span>

  <span class="Keyword">type</span> consumed <span class="Keyword">=</span> <span class="Type">bool</span>
</pre>
<br/>
Then the recursive types to express these hierarchical states and transitions:<br/>
<br/>
<pre>  <span class="Keyword">type</span> state <span class="Keyword">=</span> <span class="Structure">{</span>
    handler : handler<span class="Keyword">;</span>
    cleanup : <span class="Type">unit</span> <span class="Function">-&gt;</span> state tree <span class="Type">list</span><span class="Keyword">;</span>
  <span class="Structure">}</span>
  <span class="Keyword">and</span> handler <span class="Keyword">=</span> id <span class="Function">-&gt;</span> event <span class="Function">-&gt;</span> consumed <span class="Operator">*</span> return
  <span class="Keyword">and</span> return  <span class="Keyword">=</span> <span class="Constant">Retain</span> <span class="Operator">|</span> <span class="Constant">Stop</span> <span class="Operator">|</span> <span class="Constant">Follow</span> <span class="Keyword">of</span> state tree <span class="Type">list</span>
</pre>
<br/>
It might be easier to see how it works with an example. Here is the corresponding code for the &quot;tooltip&quot; handler:<br/>
<br/>
<pre>  <span class="Keyword">let</span> tooltip <span class="Label">?</span><span class="Delimiter">(</span><span class="Identifier">delay</span><span class="Keyword">=</span><span class="Float">0.6</span><span class="Delimiter">)</span> <span class="Label">?</span><span class="Delimiter">(</span><span class="Identifier">show</span><span class="Keyword">=</span><span class="Float">5</span>.<span class="Delimiter">)</span> create_fn <span class="Keyword">=</span>
    <span class="Keyword">let</span> <span class="Keyword">open</span> <span class="Include">Event</span> <span class="Keyword">in</span>
    <span class="Keyword">let</span> <span class="Keyword">rec</span> start <span class="Constant">()</span> <span class="Keyword">=</span> <span class="Comment">(* start needs an argument to constrain recursion *)</span>
      on_enter <span class="Delimiter">(</span><span class="Keyword">fun</span> id <span class="Function">-&gt;</span> <span class="Constant">Follow</span>
        <span class="Type">[</span> <span class="Constant">Parent</span> <span class="Delimiter">(</span>on_leave <span class="Delimiter">(</span><span class="Keyword">fun</span> <span class="Constant">_</span> <span class="Function">-&gt;</span> <span class="Constant">Follow</span> <span class="Type">[</span><span class="Constant">Child</span> <span class="Delimiter">(</span>start <span class="Constant">()</span><span class="Delimiter">)</span><span class="Type">]</span><span class="Delimiter">)</span>,
          <span class="Type">[</span> <span class="Constant">Parent</span> <span class="Delimiter">(</span>on_use <span class="Delimiter">(</span><span class="Keyword">fun</span> <span class="Constant">_</span> <span class="Function">-&gt;</span> <span class="Constant">Stop</span><span class="Delimiter">)</span>,
            <span class="Type">[</span> <span class="Constant">Child</span> <span class="Delimiter">(</span>after delay id
                <span class="Delimiter">(</span><span class="Keyword">fun</span> id <span class="Function">-&gt;</span>
                  <span class="Keyword">let</span> tip <span class="Keyword">=</span> create_fn id <span class="Keyword">in</span>
                  <span class="Keyword">let</span> cleanup <span class="Constant">()</span> <span class="Keyword">=</span> delete tip<span class="Keyword">;</span> <span class="Constant">[]</span> <span class="Keyword">in</span>
                  <span class="Constant">Follow</span> <span class="Type">[</span> <span class="Constant">Child</span> <span class="Delimiter">(</span>after show id <span class="Label">~</span><span class="Identifier">cleanup</span> <span class="Delimiter">(</span><span class="Keyword">fun</span> <span class="Constant">_</span> <span class="Function">-&gt;</span> <span class="Constant">Stop</span><span class="Delimiter">))</span> <span class="Type">]</span> <span class="Delimiter">)</span>
            <span class="Delimiter">)</span><span class="Type">]</span> <span class="Delimiter">)</span><span class="Type">]</span> <span class="Delimiter">)</span><span class="Type">]</span> <span class="Delimiter">)</span>
    <span class="Keyword">in</span> start <span class="Constant">()</span>
</pre>
<br/>
A little clunkier than my wishful thinking at the start, but I prefer this because it works! Also because it's clear about some things that the first-guess didn't cover. It deals with &quot;on use&quot; (interacting with something should make the tooltip go away), and has proper cleanup. The optional <code>cleanup</code> function is called when a state exits, including due to a parent expiring.<br/>
<br/>
Note the square brackets everywhere: a bit noisy, but the returned replacement state is actually a list. An event handler is really a list of handlers which can each have children... so it's a full tree. Even the cleanup function returns such a list, empty <code><span class="Constant">[]</span></code> in this case.<br/>
<br/>
<br/>
<h3 style="text-align: left;">
<u>Composing Event Handlers</u></h3>
<br/>
With my initial wishful thinking I didn't know if I could practically declare an event handler &quot;tooltip&quot; and simply attach it where I want it... but that's exactly how it works:<br/>
<br/>
<pre>  <span class="Include">Event</span>.set button
    <span class="Type">[</span> <span class="Include">Event</span>.<span class="Constant">Child</span> <span class="Delimiter">(</span>click_to_toggle <span class="Constant">()</span><span class="Delimiter">)</span><span class="Keyword">;</span>
      <span class="Include">Event</span>.<span class="Constant">Child</span> <span class="Delimiter">(</span>hover_fade <span class="Delimiter">(</span><span class="Float">0.85</span>,<span class="Float">0.95</span>,<span class="Float">1.0</span><span class="Delimiter">))</span><span class="Keyword">;</span>
      <span class="Include">Event</span>.<span class="Constant">Child</span> <span class="Delimiter">(</span>tooltip <span class="Delimiter">(</span>label <span class="String">&quot;Toggle me on or off&quot;</span><span class="Delimiter">))</span> <span class="Type">]</span>
</pre>
<br/>
<table cellpadding="0" cellspacing="0" class="tr-caption-container" style="float: left; margin-right: 1em; text-align: left;"><tbody>
<tr><td style="text-align: center;"><a href="http://2.bp.blogspot.com/-fQqHiEE-jtk/UxY6XetmVlI/AAAAAAAAAEE/kaRH8asimSk/s1600/ttip.png" imageanchor="1" style="clear: left; margin-bottom: 1em; margin-left: auto; margin-right: auto;"><img src="http://2.bp.blogspot.com/-fQqHiEE-jtk/UxY6XetmVlI/AAAAAAAAAEE/kaRH8asimSk/s1600/ttip.png" border="0"/></a></td></tr>
<tr><td class="tr-caption" style="text-align: center;">Tooltip in action</td></tr>
</tbody></table>
This is attaching three root-level event handlers to <code>button</code>, which each work independently and go through their state transitions. Processing an event returns a new list of handlers which replace the current handler (if there was a change).<br/>
<br/>
I think what I ended up with is a fairly standard hierarchical state machine, implemented functionally (except where I bind a list of handlers with an ID, but that's part of the nature of the component database).<br/>
<br/>
<br/>
<br/>
I don't have experience with GTK, Qt, Windows-anything. I've written simple hard-coded interfaces for some games, but usually avoid even that -- linking character behavior to (abstracted) device inputs. Now I'm working on a game which needs more mousey interaction. I know I should have looked into existing systems at least to inform myself, but those libraries are huge and I never liked the first taste. Maybe I'm also fearful that if I got to know them I'd want to have all the features they have... Experienced comments are welcome!<br/>
<br/></div>


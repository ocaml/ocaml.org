---
title: A Component-based GUI with Functional Flavour
description: 'An example of the GUI in use.    There are plenty of existing GUIs --
  why write my own?   Two technical reasons:   To have a rendering ba...'
url: https://cranialburnout.blogspot.com/2014/03/a-component-based-gui-with-functional.html
date: 2014-03-04T09:30:00-00:00
preview_image: //1.bp.blogspot.com/-DqbG0LlxpXE/UxWbAtjz7wI/AAAAAAAAAD0/UWDHWQ5Z7Rs/w1200-h630-p-k-no-nu/certa.png
featured:
authors:
- Tony Tavener
---

<div dir="ltr" style="text-align: left;" trbidi="on">
<table cellpadding="0" cellspacing="0" class="tr-caption-container" style="float: right; margin-left: 1em; text-align: right;"><tbody>
<tr><td style="text-align: center;"><a href="http://1.bp.blogspot.com/-DqbG0LlxpXE/UxWbAtjz7wI/AAAAAAAAAD0/UWDHWQ5Z7Rs/s1600/certa.png" imageanchor="1" style="clear: right; margin-bottom: 1em; margin-left: auto; margin-right: auto;"><img src="http://1.bp.blogspot.com/-DqbG0LlxpXE/UxWbAtjz7wI/AAAAAAAAAD0/UWDHWQ5Z7Rs/s1600/certa.png" border="0" height="320" width="217"/></a></td></tr>
<tr><td class="tr-caption" style="text-align: center;">An example of the GUI in use.</td></tr>
</tbody></table>
<br/>
There are plenty of existing GUIs -- why write my own?<br/>
<br/>
Two technical reasons:<br/>
<ol style="text-align: left;">
<li>To have a rendering back-end which is compatible with my game.</li>
<li>Limiting dependencies to SDL and OpenGL, which are widely supported.</li>
</ol>
<br/>
For me, the most important reason, and not a technical one, is that whenever I look at GUI APIs my brain wants to jump out of my skull. Mind you, my own mess here might have the same effect if I were to encounter it afresh. Maybe let me know what your outside perspective is?<br/>
<br/>
<br/>
<h3 style="text-align: left;">
<u>
Oh, oh, Gooey -- or is it OO GUI?</u></h3>
<br/>
I once believed the standard claim that OOP is natural for GUIs -- the one thing OOP might really be suited to. My initial take on a GUI in OCaml was based on objects: defining widget classes and layering complexity with inheritance. There were some issues... composition of functionality rarely works well with objects because they're wedded to internal state, and that is frustrating. But there was another pitfall lurking in the shadows. Initially a lot of details were hard-coded: font, colors, borders, etc. The day came when I wanted to control these details... A default font for everything... maybe setting another font for some group of things, and overriding that in specific cases... well ain't <i>this</i> a mess!<br/>
<br/>
<b>Update</b>: Leo White, in the comments, has clued me in to using <a href="https://realworldocaml.org/v1/en/html/classes.html#mixins" target="_blank">OCaml objects with the mixin technique</a> -- which seems to offer similar composability and inheritance, but retaining the power of the type-system. I'll make a future post comparing the approaches. An early impression/summary: nearly identical expressiveness, while the differences are similar to the trade-offs between static and dynamic typing.<br/>
<br/>
<br/>
<h3 style="text-align: left;">
<u>
I'm Destined to Use Databases for Everything</u></h3>
<i>(to atone for disparaging remarks about DB programmers in my past)</i><br/>
<br/>
It didn't take too long before I realized that I want properties: arbitrarily aggregating and inheritable properties... a.k.a. components. (The component system I'm using is described&nbsp;<a href="http://cranialburnout.blogspot.ca/2013/09/database-radiation-hazard.html" target="_blank">here</a>.)&nbsp;Well then, what if all of my &quot;widgets&quot; were just IDs with associated components? What would it look like?<br/>
<br/>
Here's the &quot;default font&quot; I wanted...<br/>
<br/>
<pre>  <span class="Keyword">let</span> normal_font <span class="Keyword">=</span> new_id <span class="Constant">()</span>
    <span class="Operator">|&gt;</span> <span class="Include">Font</span>.s fnt
    <span class="Operator">|&gt;</span> <span class="Include">Fontgradient</span>.s <span class="Constant">`Crisp</span>
</pre>
<br/>
Now &quot;normal_font&quot; is something to inherit from: a convenient bundle of properties. If I set the Font to something else during runtime, everything which inherits and doesn't otherwise override Font will get the change.<br/>
<br/>
I'll set a bunch of global defaults called &quot;gui_base&quot;...<br/>
<br/>
<pre>  <span class="Keyword">let</span> gui_base <span class="Keyword">=</span> new_id <span class="Constant">()</span>
    <span class="Operator">|&gt;</span> <span class="Include">Anchor</span>.s <span class="Include">Vec2</span>.null
    <span class="Operator">|&gt;</span> <span class="Include">Color</span>.s <span class="Delimiter">(</span><span class="Float">0.5</span>,<span class="Float">0.5</span>,<span class="Float">0.5</span><span class="Delimiter">)</span>
    <span class="Operator">|&gt;</span> <span class="Include">Shape</span>.s rounded_rectangle
    <span class="Operator">|&gt;</span> <span class="Include">Gradient</span>.s <span class="Constant">`FramedUnderlay</span>
    <span class="Operator">|&gt;</span> <span class="Include">Underlay</span>.s <span class="Constant">Default</span>
    <span class="Operator">|&gt;</span> <span class="Include">Border</span>.s <span class="Float">6</span>.
</pre>
<br/>
So far, these properties are just data -- mostly related to rendering options.<br/>
<br/>
Next we'll use inheritance, and add an event handler. This sets up properties for a particular class of buttons:<br/>
<br/>
<pre>  <span class="Keyword">let</span> hover_button <span class="Keyword">=</span>
    new_child_of <span class="Type">[</span> gui_base <span class="Type">]</span>
    <span class="Operator">|&gt;</span> <span class="Include">Fontsize</span>.s <span class="Float">18</span>.
    <span class="Operator">|&gt;</span> <span class="Include">Fontcolor</span>.s <span class="Delimiter">(</span><span class="Float">1</span>.,<span class="Float">0.95</span>,<span class="Float">0.9</span><span class="Delimiter">)</span>
    <span class="Operator">|&gt;</span> <span class="Include">Shadow</span>.s <span class="Delimiter">(</span><span class="Constant">`Shadow</span>,black,<span class="Float">0.5</span>,<span class="Float">1.5</span>,<span class="Float">2</span>.<span class="Delimiter">)</span>
    <span class="Operator">|&gt;</span> <span class="Include">Event</span>.s <span class="Type">[</span> <span class="Include">Event</span>.<span class="Constant">Child</span> <span class="Delimiter">(</span>hover_fade <span class="Delimiter">(</span><span class="Float">0.8</span>,<span class="Float">0.7</span>,<span class="Float">0.5</span><span class="Delimiter">))</span> <span class="Type">]</span>
</pre>
<br/>
Now anything inheriting from this, and placed on-screen, will respond to pointer &quot;hover&quot; with an animated color-fade. Event handlers aren't masked, so I usually keep them near &quot;leaf&quot; nodes of inheritance. As a silly test, I made a right-click menu for color-changing in gui_base... so everything could have it's color changed. It worked, if a bit heavy handed. Still, something like that could be useful to create a configuration mode.<br/>
<br/>
You might realize by now that there are no specific <i>button</i>, <i>label</i>, or <i>textbox</i> widgets. Any GUI element is defined by its cumulative properties. In practice, there are convenient &quot;widgets&quot; which I build functions for, like this color_button:<br/>
<br/>
<pre>  <span class="Keyword">let</span> color_button color name <span class="Keyword">=</span>
    new_child_of <span class="Type">[</span> hover_button<span class="Keyword">;</span> normal_font <span class="Type">]</span>
    <span class="Operator">|&gt;</span> <span class="Include">Color</span>.s color
    <span class="Operator">|&gt;</span> <span class="Include">Text</span>.s_string name
</pre>
<br/>
I'm using components with multiple inheritance, and this function creates a button by inheriting both&nbsp;hover_button&nbsp;and normal_font, as well as adding a given color and name.<br/>
<br/>
Well this looks promising to me. Properties, via components, provide a reasonable way to build GUI elements, ample support for hierarchical styles, and there's no need for optional parameters on every creation function -- a free-form chain of components serves as the optional parameters for any/all creation. For example, I can use the &quot;color_button&quot; above, but override the font, almost like a labeled parameter:<br/>
<div class="separator" style="clear: both; text-align: center;">
<a href="http://4.bp.blogspot.com/-YUFMm_hgNqg/UxWF9do5AAI/AAAAAAAAADc/egjy6rh6sDA/s1600/launch.png" imageanchor="1" style="clear: right; float: right; margin-bottom: 1em; margin-left: 1em;"><img src="http://4.bp.blogspot.com/-YUFMm_hgNqg/UxWF9do5AAI/AAAAAAAAADc/egjy6rh6sDA/s1600/launch.png" border="0"/></a></div>
<br/>
<pre>    color_button red <span class="String">&quot;LAUNCH&quot;</span> <span class="Operator">|&gt;</span> <span class="Include">Font</span>.s dangerfont
</pre>
<br/>
Furthermore, when new components are created to implement features... there's no need to update functions with new parameters. I've often been running competing components in parallel, until one is deprecated. Purely modular bliss.<br/>
<br/>
<br/>
<h3 style="text-align: left;">
<u>
Model-View-Controller... or something else?</u></h3>
<br/>
GUIs which separate declaration, control, and behavior all over the place drive me nuts. This would be the typical implementation of a Model-View-Controller pattern which is so beloved.<br/>
<br/>
With MVC, and the numerous other GUI-pattern varieties (MVVM, MVP, etc), the principle notion is separation of concerns. Each particular pattern identifies different concerns and separations. I'm usually rather keen on separation of concerns -- modular, composable, understandable, no stepping on toes. I find with GUIs that I desire <i>tighter</i> coupling. An extreme in this regard is&nbsp;<a href="http://iki.fi/sol/imgui/" target="_blank">ImGUI</a>, which goes too far for my usual preferences -- with it, view is stateless and coupled to execution-flow.<br/>
<br/>
What I want, is to declare everything in a stream. We can break things down into sub-parts, as usual with programming. What I don't want, are code and declarations scattered in different places, files, or even languages... held together by message-spaghetti. Using the color_button again, here's a larger GUI object:<br/>
<br/>
<pre>  <span class="Keyword">let</span> framed_colors <span class="Keyword">=</span>
    <span class="Keyword">let</span> blue   <span class="Keyword">=</span> color_button <span class="Delimiter">(</span><span class="Float">0.1</span>,<span class="Float">0.1</span>,<span class="Float">1.0</span><span class="Delimiter">)</span> <span class="String">&quot;Blue&quot;</span> <span class="Keyword">in</span>
    <span class="Keyword">let</span> red    <span class="Keyword">=</span> color_button <span class="Delimiter">(</span><span class="Float">1.0</span>,<span class="Float">0.0</span>,<span class="Float">0.0</span><span class="Delimiter">)</span> <span class="String">&quot;Red&quot;</span> <span class="Keyword">in</span>
    <span class="Keyword">let</span> green  <span class="Keyword">=</span> color_button <span class="Delimiter">(</span><span class="Float">0.1</span>,<span class="Float">0.9</span>,<span class="Float">0.1</span><span class="Delimiter">)</span> <span class="String">&quot;Green&quot;</span> <span class="Keyword">in</span>
    <span class="Keyword">let</span> yellow <span class="Keyword">=</span> color_button <span class="Delimiter">(</span><span class="Float">0.9</span>,<span class="Float">0.9</span>,<span class="Float">0.0</span><span class="Delimiter">)</span> <span class="String">&quot;Yellow&quot;</span> <span class="Keyword">in</span>
    <span class="Keyword">let</span> black  <span class="Keyword">=</span> color_button <span class="Delimiter">(</span><span class="Float">0.0</span>,<span class="Float">0.0</span>,<span class="Float">0.0</span><span class="Delimiter">)</span> <span class="String">&quot;Black&quot;</span> <span class="Keyword">in</span>
    new_child_of <span class="Type">[</span> gui_base <span class="Type">]</span>
      <span class="Operator">|&gt;</span> <span class="Include">Pos</span>.s <span class="Delimiter">(</span><span class="Include">Vec2</span>.make <span class="Float">40</span>. <span class="Float">20</span>.<span class="Delimiter">)</span>
      <span class="Operator">|&gt;</span> <span class="Include">Dim</span>.s <span class="Delimiter">(</span><span class="Include">Vec2</span>.make <span class="Float">240</span>. <span class="Float">120</span>.<span class="Delimiter">)</span>
      <span class="Operator">|&gt;</span> <span class="Include">Pad</span>.<span class="Delimiter">(</span>s <span class="Delimiter">(</span>frame <span class="Delimiter">(</span><span class="Include">Layout</span>.gap <span class="Float">4</span><span class="Delimiter">)))</span>
      <span class="Operator">|&gt;</span> <span class="Include">Border</span>.s <span class="Float">12</span>.
      <span class="Operator">|&gt;</span> <span class="Include">Layout</span>.<span class="Delimiter">(</span>s
          <span class="Delimiter">(</span>vspread
            <span class="Type">[</span> hcenter <span class="Delimiter">(</span><span class="Constant">Id</span> blue<span class="Delimiter">)</span><span class="Keyword">;</span>
              hbox <span class="Type">[</span> <span class="Constant">I</span> green<span class="Keyword">;</span> <span class="Constant">G</span> <span class="Delimiter">(</span>gap <span class="Float">2</span><span class="Delimiter">)</span><span class="Keyword">;</span> <span class="Constant">I</span> yellow<span class="Keyword">;</span> <span class="Constant">G</span> <span class="Delimiter">(</span>fill <span class="Float">1</span><span class="Delimiter">)</span><span class="Keyword">;</span> <span class="Constant">I</span> black <span class="Type">]</span><span class="Keyword">;</span>
              hcenter <span class="Delimiter">(</span><span class="Constant">Id</span> red<span class="Delimiter">)</span> <span class="Type">]</span><span class="Delimiter">))</span>
      <span class="Operator">|&gt;</span> <span class="Include">Event</span>.s
          <span class="Type">[</span> <span class="Include">Event</span>.<span class="Constant">Child</span> <span class="Delimiter">(</span>drag_size <span class="Constant">RIGHT</span><span class="Delimiter">)</span><span class="Keyword">;</span>
            <span class="Include">Event</span>.<span class="Constant">Child</span> <span class="Delimiter">(</span>drag_move <span class="Constant">LEFT</span><span class="Delimiter">)</span> <span class="Type">]</span>
</pre>
<br/>
<table align="center" cellpadding="0" cellspacing="0" class="tr-caption-container" style="margin-left: auto; margin-right: auto; text-align: center;"><tbody>
<tr><td style="text-align: center;"><a href="http://2.bp.blogspot.com/-ZjN-nm0vjPY/UxWGIL_fBTI/AAAAAAAAADk/9L2D5Sq_eUw/s1600/colorbox.png" imageanchor="1" style="margin-left: auto; margin-right: auto;"><img src="http://2.bp.blogspot.com/-ZjN-nm0vjPY/UxWGIL_fBTI/AAAAAAAAADk/9L2D5Sq_eUw/s1600/colorbox.png" border="0"/></a></td></tr>
<tr><td class="tr-caption" style="text-align: center;">Layout uses a &quot;boxes and glue&quot; approach.</td></tr>
</tbody></table>
<br/>
<br/>
All in one, an object is declared with nested elements. It has a defined (yet flexible) layout, and responds to move and resize operations; the buttons have their own event handlers. The event handlers (as I'll get into in another post) are just functions. The point is that the composition of this is as for any typical code: functions. No out-of-band stuff... no layout in some other file keyed on string-names, no messages/signals/slots. There are events, but event-generation is from outside (SDL), so the only part we're concerned with is right here -- the event handlers.<br/>
<br/>
I guess what I'm trying to minimize, is spooky-action-at-a-distance. To jump ahead a bit, when I call a menu function, it returns a result based on the user's selection (pausing this execution path while awaiting user response, via coroutines), rather than changing a state variable or firing off a message. Functions returning values.<br/>
<br/>
<br/>
<h3 style="text-align: left;">
<u>
Parts of a GUI</u></h3>
<ol style="text-align: left;">
<li>Renderer</li>
<li>Description/Layout</li>
<li>Event Handling</li>
</ol>
Oh hey... View, Model, and Controller. D'oh!<br/>
<br/>
I'll go into more depth in future posts, leaving off with just a note about each...<br/>
<br/>
The renderer is a thin layer leveraging the game's renderer. It mows over the GUI scenegraph, rendering relevant components it encounters. It's entirely possible for the renderer to have alternate interpretations of the data -- and, in fact, I do this: to render for &quot;picking&quot;. Effectively I render the &quot;Event&quot; view, including pass-through or &quot;transparent&quot; events. Some details about render layers and stenciling will be their own topic.<br/>
<br/>
Declaration of elements leverages &quot;components&quot; as in the examples given above. For layout, I've always had a fondness for TeX's boxes and glue -- I ride Knuth's coat-tails in matters of typesetting. A hint of this is in the Layout component for the box of color_buttons. I'll probably cover layout or line-splitting in another post.<br/>
<br/>
Event Handling. One of my favorite parts, and a separate post:&nbsp;<a href="http://cranialburnout.blogspot.ca/2014/03/gui-event-handling-with-functional.html" target="_blank">GUI Event Handling with a Functional Hierarchical State Machine</a>.<br/>
<br/>
There's something missing still...<br/>
<br/>
&nbsp; &nbsp; &nbsp; 4. &nbsp;The UI Code<br/>
<br/>
What I mean is the flow of code which triggers GUI element creation, awaits user responses, and does things with them. This could be done as a state machine, but I prefer keeping the flow continuous (as if the user always has an immediate answer), using coroutines. This is yet another topic for another day.<br/>
<br/>
I haven't made a complex UI, so there might be a point beyond which I have to rely on messages -- really, I keep anticipating this, but it hasn't happened... yet.</div>


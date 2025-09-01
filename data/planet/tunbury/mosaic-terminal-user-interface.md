---
title: Mosaic Terminal User Interface
description: In testing various visual components, terminal resizing, keyboard handling
  and the use of hooks, I inadvertently wrote the less tool in Mosaic. Below are my
  notes on using the framework.
url: https://www.tunbury.org/2025/08/31/mless/
date: 2025-08-31T00:00:00-00:00
preview_image: https://www.tunbury.org/images/ocaml-logo.png
authors:
- Mark Elvers
source:
ignore:
---

<p>In testing various visual components, terminal resizing, keyboard handling and the use of hooks, I inadvertently wrote the <code class="language-plaintext highlighter-rouge">less</code> tool in <a href="https://github.com/tmattio/mosaic">Mosaic</a>. Below are my notes on using the framework.</p>

<p><code class="language-plaintext highlighter-rouge">use_state</code> is a React-style hook that manages local component state. It returns a tuple of (value, set, update) where:</p>

<ol>
  <li>count - the current value</li>
  <li>set_count - sets to a specific value (takes a value)</li>
  <li>update_count - transforms the current value (takes a function)</li>
</ol>

<p>Thus, you might have</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="p">(</span><span class="n">count</span><span class="o">,</span> <span class="n">set_count</span><span class="o">,</span> <span class="n">update_count</span><span class="p">)</span> <span class="o">=</span> <span class="n">use_state</span> <span class="mi">0</span><span class="p">;;</span>

<span class="n">count</span> <span class="c">(* returns the current value - zero in this case *)</span>
<span class="n">set_count</span> <span class="mi">5</span> <span class="c">(* set the value to 5 *)</span>
<span class="n">update_count</span> <span class="p">(</span><span class="k">fun</span> <span class="n">x</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">+</span> <span class="mi">1</span><span class="p">)</span> <span class="c">(* adds 1 to the current value *)</span>
</code></pre></div></div>

<p>In practice, this could be used to keep track of the selected index in a table of values:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">directory_browser</span> <span class="n">dir_info</span> <span class="n">window_height</span> <span class="n">window_width</span> <span class="n">set_mode</span> <span class="o">=</span>
  <span class="k">let</span> <span class="k">open</span> <span class="nc">Ui</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">selected_index</span><span class="o">,</span> <span class="n">set_selected_index</span><span class="o">,</span> <span class="n">_</span> <span class="o">=</span> <span class="n">use_state</span> <span class="mi">0</span> <span class="k">in</span>
  
  <span class="n">use_subscription</span>
    <span class="p">(</span><span class="nn">Sub</span><span class="p">.</span><span class="n">keyboard_filter</span> <span class="p">(</span><span class="k">fun</span> <span class="n">event</span> <span class="o">-&gt;</span>
         <span class="k">match</span> <span class="n">event</span><span class="o">.</span><span class="nn">Input</span><span class="p">.</span><span class="n">key</span> <span class="k">with</span>
         <span class="o">|</span> <span class="nn">Input</span><span class="p">.</span><span class="nc">Up</span> <span class="o">-&gt;</span> <span class="n">set_selected_index</span> <span class="p">(</span><span class="n">max</span> <span class="mi">0</span> <span class="p">(</span><span class="n">selected_index</span> <span class="o">-</span> <span class="mi">1</span><span class="p">));</span> <span class="nc">None</span>
         <span class="o">|</span> <span class="nn">Input</span><span class="p">.</span><span class="nc">Down</span> <span class="o">-&gt;</span> <span class="n">set_selected_index</span> <span class="p">(</span><span class="n">min</span> <span class="p">(</span><span class="n">num_entries</span> <span class="o">-</span> <span class="mi">1</span><span class="p">)</span> <span class="p">(</span><span class="n">selected_index</span> <span class="o">+</span> <span class="mi">1</span><span class="p">));</span> <span class="nc">None</span>
         <span class="o">|</span> <span class="nn">Input</span><span class="p">.</span><span class="nc">Enter</span> <span class="o">-&gt;</span> <span class="n">set_mode</span> <span class="p">(</span><span class="n">load_path</span> <span class="n">entry</span><span class="o">.</span><span class="n">full_path</span><span class="p">);</span> <span class="nc">Some</span> <span class="bp">()</span>
         <span class="o">|</span> <span class="n">_</span> <span class="o">-&gt;</span> <span class="nc">None</span><span class="p">));</span>
</code></pre></div></div>

<p>Any change in the value of a state causes the UI component to be re-rendered. Consider this snippet, which uses the subscription <code class="language-plaintext highlighter-rouge">Sub.window</code> to update the window size, which calls <code class="language-plaintext highlighter-rouge">set_window_height</code> and <code class="language-plaintext highlighter-rouge">set_window_width</code>.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">app</span> <span class="n">path</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">mode</span><span class="o">,</span> <span class="n">set_mode</span><span class="o">,</span> <span class="n">_</span> <span class="o">=</span> <span class="n">use_state</span> <span class="p">(</span><span class="n">load_path</span> <span class="n">path</span><span class="p">)</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">window_height</span><span class="o">,</span> <span class="n">set_window_height</span><span class="o">,</span> <span class="n">_</span> <span class="o">=</span> <span class="n">use_state</span> <span class="mi">24</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">window_width</span><span class="o">,</span> <span class="n">set_window_width</span><span class="o">,</span> <span class="n">_</span> <span class="o">=</span> <span class="n">use_state</span> <span class="mi">80</span> <span class="k">in</span>

  <span class="c">(* Handle window resize *)</span>
  <span class="n">use_subscription</span>
    <span class="p">(</span><span class="nn">Sub</span><span class="p">.</span><span class="n">window</span> <span class="p">(</span><span class="k">fun</span> <span class="n">size</span> <span class="o">-&gt;</span>
         <span class="n">set_window_height</span> <span class="n">size</span><span class="o">.</span><span class="n">height</span><span class="p">;</span>
         <span class="n">set_window_width</span> <span class="n">size</span><span class="o">.</span><span class="n">width</span><span class="p">));</span>

  <span class="c">(* Return a Ui.element using window_height and window_width *)</span>
  <span class="n">directory_browser</span> <span class="n">dir_info</span> <span class="n">window_height</span> <span class="n">window_width</span> <span class="n">set_mode</span>

<span class="k">let</span> <span class="bp">()</span> <span class="o">=</span>
  <span class="n">run</span> <span class="o">~</span><span class="n">alt_screen</span><span class="o">:</span><span class="bp">true</span> <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span> <span class="n">app</span> <span class="n">path</span><span class="p">)</span>
</code></pre></div></div>

<p>In my testing, this worked but left unattached text fragments on the screen. This forced me to add a <code class="language-plaintext highlighter-rouge">Cmd.clear_screen</code> to manually clear the screen. <code class="language-plaintext highlighter-rouge">Cmd.repaint</code> doesn’t seem strictly necessary. The working subscription was:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code>  <span class="n">use_subscription</span>
    <span class="p">(</span><span class="nn">Sub</span><span class="p">.</span><span class="n">window</span> <span class="p">(</span><span class="k">fun</span> <span class="n">size</span> <span class="o">-&gt;</span>
         <span class="n">set_window_height</span> <span class="n">size</span><span class="o">.</span><span class="n">height</span><span class="p">;</span>
         <span class="n">set_window_width</span> <span class="n">size</span><span class="o">.</span><span class="n">width</span><span class="p">;</span>
         <span class="n">dispatch_cmd</span> <span class="p">(</span><span class="nn">Cmd</span><span class="p">.</span><span class="n">batch</span> <span class="p">[</span> <span class="nn">Cmd</span><span class="p">.</span><span class="n">clear_screen</span><span class="p">;</span> <span class="nn">Cmd</span><span class="p">.</span><span class="n">repaint</span> <span class="p">])));</span>
</code></pre></div></div>

<p>It is also possible to monitor values using <code class="language-plaintext highlighter-rouge">use_effect</code>. In the example below, the scroll position is reset when the filename is changed. The effect is triggered only when the component is rendered and when the value differs from the value on the previous render.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">use_effect</span> <span class="o">~</span><span class="n">deps</span><span class="o">:</span><span class="p">(</span><span class="nn">Deps</span><span class="p">.</span><span class="n">keys</span> <span class="p">[</span><span class="nn">Deps</span><span class="p">.</span><span class="n">string</span> <span class="n">content</span><span class="o">.</span><span class="n">filename</span><span class="p">])</span> <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span>
  <span class="n">set_scroll_offset</span> <span class="mi">0</span><span class="p">;</span>
  <span class="n">set_h_scroll_offset</span> <span class="mi">0</span><span class="p">;</span>
  <span class="nc">None</span>
<span class="p">);</span>
</code></pre></div></div>

<p>The sequence is:</p>
<ol>
  <li>Component renders (first time or re-render due to state change)</li>
  <li>Framework checks if any values in ~deps changed since last render</li>
  <li>If they changed, run the effect function</li>
  <li>If the effect returns cleanup, that cleanup runs before the next effect</li>
</ol>

<p>For some widgets, I found I needed to perform manual calculations on the size to fill the space and correctly account for panel borders, header, dividers, and status. <code class="language-plaintext highlighter-rouge">window_height - 6</code>. In other cases, <code class="language-plaintext highlighter-rouge">~expand:true</code> was available.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">scroll_view</span>
  <span class="o">~</span><span class="n">height</span><span class="o">:</span><span class="p">(</span><span class="nt">`Cells</span> <span class="p">(</span><span class="n">window_height</span> <span class="o">-</span> <span class="mi">6</span><span class="p">))</span>
  <span class="o">~</span><span class="n">h_offset</span><span class="o">:</span><span class="n">h_scroll_offset</span> 
  <span class="o">~</span><span class="n">v_offset</span><span class="o">:</span><span class="n">scroll_offset</span> 
  <span class="n">file_content</span><span class="p">;</span>
</code></pre></div></div>

<p>Colours can be defined as RGB values and then composed into Syles with the <code class="language-plaintext highlighter-rouge">++</code> operator. Styles are then applied to elements such as table headers:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">module</span> <span class="nc">Colors</span> <span class="o">=</span> <span class="k">struct</span>
  <span class="k">let</span> <span class="n">primary_blue</span> <span class="o">=</span> <span class="nn">Style</span><span class="p">.</span><span class="n">rgb</span> <span class="mi">66</span> <span class="mi">165</span> <span class="mi">245</span>    <span class="c">(* Material Blue 400 *)</span>
<span class="k">end</span>

<span class="k">module</span> <span class="nc">Styles</span> <span class="o">=</span> <span class="k">struct</span>
  <span class="k">let</span> <span class="n">header</span> <span class="o">=</span> <span class="nn">Style</span><span class="p">.(</span><span class="n">fg</span> <span class="nn">Colors</span><span class="p">.</span><span class="n">primary_blue</span> <span class="o">++</span> <span class="n">bold</span><span class="p">)</span>
<span class="k">end</span>

<span class="n">table</span> <span class="o">~</span><span class="n">header_style</span><span class="o">:</span><span class="nn">Styles</span><span class="p">.</span><span class="n">header</span> <span class="o">...</span>
</code></pre></div></div>

<p>The panel serves as the primary container for our application content, providing both visual framing and structural organisation:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">panel</span> 
  <span class="o">~</span><span class="n">title</span><span class="o">:</span><span class="p">(</span><span class="nn">Printf</span><span class="p">.</span><span class="n">sprintf</span> <span class="s2">"Directory Browser - %s"</span> <span class="p">(</span><span class="nn">Filename</span><span class="p">.</span><span class="n">basename</span> <span class="n">dir_info</span><span class="o">.</span><span class="n">path</span><span class="p">))</span>
  <span class="o">~</span><span class="n">box_style</span><span class="o">:</span><span class="nc">Rounded</span> 
  <span class="o">~</span><span class="n">border_style</span><span class="o">:</span><span class="nn">Styles</span><span class="p">.</span><span class="n">accent</span> 
  <span class="o">~</span><span class="n">expand</span><span class="o">:</span><span class="bp">true</span>
  <span class="p">(</span><span class="n">vbox</span> <span class="p">[</span>
    <span class="c">(* content goes here *)</span>
  <span class="p">])</span>
</code></pre></div></div>

<p>Mosaic provides the table widget, which I found had a layout <a href="https://github.com/tmattio/mosaic/issues/2">issue</a> when the column widths exceeded the table width. It worked pretty well, but it takes about 1 second per 1000 rows on my machine, so consider pagination.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">table_columns</span> <span class="o">=</span> <span class="p">[</span>
  <span class="nn">Table</span><span class="p">.{</span> <span class="p">(</span><span class="n">default_column</span> <span class="o">~</span><span class="n">header</span><span class="o">:</span><span class="s2">"Name"</span><span class="p">)</span> <span class="k">with</span> <span class="n">style</span> <span class="o">=</span> <span class="nn">Styles</span><span class="p">.</span><span class="n">file</span> <span class="p">};</span>
  <span class="nn">Table</span><span class="p">.{</span> <span class="p">(</span><span class="n">default_column</span> <span class="o">~</span><span class="n">header</span><span class="o">:</span><span class="s2">"Type"</span><span class="p">)</span> <span class="k">with</span> <span class="n">style</span> <span class="o">=</span> <span class="nn">Styles</span><span class="p">.</span><span class="n">file</span> <span class="p">};</span>
  <span class="nn">Table</span><span class="p">.{</span> <span class="p">(</span><span class="n">default_column</span> <span class="o">~</span><span class="n">header</span><span class="o">:</span><span class="s2">"Size"</span><span class="p">)</span> <span class="k">with</span> <span class="n">style</span> <span class="o">=</span> <span class="nn">Styles</span><span class="p">.</span><span class="n">file</span><span class="p">;</span> <span class="n">justify</span> <span class="o">=</span> <span class="nt">`Right</span> <span class="p">};</span>
<span class="p">]</span> <span class="k">in</span>

<span class="n">table</span> 
  <span class="o">~</span><span class="n">columns</span><span class="o">:</span><span class="n">table_columns</span> 
  <span class="o">~</span><span class="n">rows</span><span class="o">:</span><span class="n">table_rows</span> 
  <span class="o">~</span><span class="n">box_style</span><span class="o">:</span><span class="nn">Table</span><span class="p">.</span><span class="nc">Minimal</span> 
  <span class="o">~</span><span class="n">expand</span><span class="o">:</span><span class="bp">true</span>
  <span class="o">~</span><span class="n">header_style</span><span class="o">:</span><span class="nn">Styles</span><span class="p">.</span><span class="n">header</span>
  <span class="o">~</span><span class="n">row_styles</span><span class="o">:</span><span class="n">table_row_styles</span>
  <span class="o">~</span><span class="n">width</span><span class="o">:</span><span class="p">(</span><span class="nc">Some</span> <span class="p">(</span><span class="n">window_width</span> <span class="o">-</span> <span class="mi">4</span><span class="p">))</span>
  <span class="bp">()</span>
</code></pre></div></div>

<p>The primary layout primitives are <code class="language-plaintext highlighter-rouge">vbox</code> and <code class="language-plaintext highlighter-rouge">hbox</code>:</p>

<p>Vertical Box (vbox) - for stacking components vertically.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">vbox</span> <span class="p">[</span>
  <span class="n">text</span> <span class="s2">"Header"</span><span class="p">;</span>
  <span class="n">divider</span> <span class="o">~</span><span class="n">orientation</span><span class="o">:</span><span class="nt">`Horizontal</span> <span class="bp">()</span><span class="p">;</span>
  <span class="n">content</span><span class="p">;</span>
  <span class="n">text</span> <span class="s2">"Footer"</span><span class="p">;</span>
<span class="p">]</span>
</code></pre></div></div>

<p>Horizontal Box (hbox) - for arranging components horizontally.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">hbox</span> <span class="o">~</span><span class="n">gap</span><span class="o">:</span><span class="p">(</span><span class="nt">`Cells</span> <span class="mi">2</span><span class="p">)</span> <span class="p">[</span>
  <span class="n">text</span> <span class="s2">"Left column"</span><span class="p">;</span>
  <span class="n">text</span> <span class="s2">"Right column"</span><span class="p">;</span>
<span class="p">]</span>
</code></pre></div></div>

<p>As I mentioned earlier, a subscription-based event handling system, for example, a component could subscribe to the keyboard events.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">use_subscription</span>
  <span class="p">(</span><span class="nn">Sub</span><span class="p">.</span><span class="n">keyboard_filter</span> <span class="p">(</span><span class="k">fun</span> <span class="n">event</span> <span class="o">-&gt;</span>
       <span class="k">match</span> <span class="n">event</span><span class="o">.</span><span class="nn">Input</span><span class="p">.</span><span class="n">key</span> <span class="k">with</span>
       <span class="o">|</span> <span class="nn">Input</span><span class="p">.</span><span class="nc">Char</span> <span class="n">c</span> <span class="k">when</span> <span class="nn">Uchar</span><span class="p">.</span><span class="n">to_int</span> <span class="n">c</span> <span class="o">=</span> <span class="mh">0x71</span> <span class="o">-&gt;</span> <span class="c">(* 'q' *)</span>
           <span class="n">dispatch_cmd</span> <span class="nn">Cmd</span><span class="p">.</span><span class="n">quit</span><span class="p">;</span> <span class="nc">Some</span> <span class="bp">()</span>
       <span class="o">|</span> <span class="nn">Input</span><span class="p">.</span><span class="nc">Enter</span> <span class="o">-&gt;</span> 
           <span class="c">(* handle enter *)</span>
           <span class="nc">Some</span> <span class="bp">()</span>
       <span class="o">|</span> <span class="n">_</span> <span class="o">-&gt;</span> <span class="nc">None</span><span class="p">))</span>
</code></pre></div></div>

<p>The <code class="language-plaintext highlighter-rouge">keyboard_filter</code> function allows components to selectively handle keyboard events, returning <code class="language-plaintext highlighter-rouge">Some ()</code> for events that are handled and <code class="language-plaintext highlighter-rouge">None</code> for events that should be passed to other components.</p>

<p>Mosaic provides a command system for handling side effects and application lifecycle events some of these you will have seen in earlier examples.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">dispatch_cmd</span> <span class="nn">Cmd</span><span class="p">.</span><span class="n">quit</span>                    <span class="c">(* Exit the application *)</span>
<span class="n">dispatch_cmd</span> <span class="nn">Cmd</span><span class="p">.</span><span class="n">repaint</span>                 <span class="c">(* Force a screen repaint *)</span>
<span class="n">dispatch_cmd</span> <span class="p">(</span><span class="nn">Cmd</span><span class="p">.</span><span class="n">batch</span> <span class="p">[</span>                <span class="c">(* Execute multiple commands *)</span>
  <span class="nn">Cmd</span><span class="p">.</span><span class="n">clear_screen</span><span class="p">;</span> 
  <span class="nn">Cmd</span><span class="p">.</span><span class="n">repaint</span>
<span class="p">])</span>
</code></pre></div></div>

<p>I found that using Unicode characters in strings caused alignment errors, as their length was the number of data bytes, not the visual space used on the screen.</p>

<p>The <a href="https://github.com/mtelvers/mless">mless</a> application is available on GitHub for further investigation or as a starter project.</p>

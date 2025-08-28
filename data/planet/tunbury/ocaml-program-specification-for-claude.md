---
title: OCaml Program Specification for Claude
description: I have a dataset that I would like to visualise using a static website
  hosted on GitHub Pages. The application that generates the dataset is still under
  development, which results in frequently changing data formats. Therefore, rather
  than writing a static website generator and needing to revise it continually, could
  I write a specification and have Claude create a new one each time there was a change?
url: https://www.tunbury.org/2025/08/01/program-specification/
date: 2025-08-01T00:00:00-00:00
preview_image: https://www.tunbury.org/images/ocaml-logo.png
authors:
- Mark Elvers
source:
ignore:
---

<p>I have a dataset that I would like to visualise using a static website hosted on GitHub Pages. The application that generates the dataset is still under development, which results in frequently changing data formats. Therefore, rather than writing a static website generator and needing to revise it continually, could I write a specification and have Claude create a new one each time there was a change?</p>

<p>Potentially, I could do this cumulatively by giving Claude the original specification and code and then the new specification, but my chosen approach is to see if Claude can create the application in one pass from the specification. I’ve also chosen to do this using Claude Sonnet’s web interface; obviously, the code I will request will be in OCaml.</p>

<p>I wrote a detailed 500-word specification that included the file formats involved, example directory tree layouts, and what I thought was a clear definition of the output file structure.</p>

<p>The resulting code wasn’t what I wanted: Claude had inlined huge swathes of HTML and was using <code class="language-plaintext highlighter-rouge">Printf.sprintf</code> extensively. Each file included the stylesheet as a <code class="language-plaintext highlighter-rouge">&lt;style&gt;...&lt;/style&gt;</code>. However, the biggest problem was that Claude had chosen to write the JSON parser from scratch, and this code had numerous issues and wouldn’t even build. I directed Claude to use <code class="language-plaintext highlighter-rouge">yojson</code> rather than handcraft a parser.</p>

<p>I intended but did not state in my specification that I wanted the code to generate HTML using <code class="language-plaintext highlighter-rouge">tyxml</code>. I updated my specification, requesting that the code be written using <code class="language-plaintext highlighter-rouge">tyxml</code>, <code class="language-plaintext highlighter-rouge">yojson</code>, and <code class="language-plaintext highlighter-rouge">timedesc</code> to handle the ISO date format. I also thought of some additional functionality around extracting data from a Git repo.</p>

<p>Round 2 - Possibly a step backwards as Claude struggled to find the appropriate functions in the <code class="language-plaintext highlighter-rouge">timedesc</code> library to parse and sort dates. There were also some issues extracting data using <code class="language-plaintext highlighter-rouge">git</code>. I have to take responsibility here as I gave the example command as <code class="language-plaintext highlighter-rouge">git show --date=iso-strict ce03608b4ba656c052ef5e868cf34b9e86d02aac -C /path/to/repo</code>, but <code class="language-plaintext highlighter-rouge">git</code> requires the <code class="language-plaintext highlighter-rouge">-C /path/to/repo</code> to precede the <code class="language-plaintext highlighter-rouge">show</code> command. However, the fact that my example had overwritten Claude’s <em>knowledge</em> was potentially interesting. Could I use this to seed facts I knew Claude would need?</p>

<p>Claude still wasn’t creating a separate <code class="language-plaintext highlighter-rouge">stylesheet.css</code>.</p>

<p>Round 3 - This time, I gave examples on how to use the <code class="language-plaintext highlighter-rouge">timedesc</code> library, i.e.</p>

<blockquote>
  <p>To use the <code class="language-plaintext highlighter-rouge">timedesc</code> library, we can call <code class="language-plaintext highlighter-rouge">Timedesc.of_iso8601</code> to convert the Git ISO strict output to a Timedesc object and then compare it with <code class="language-plaintext highlighter-rouge">compare (Timedesc.to_timestamp_float_s b.date) (Timedesc.to_timestamp_float_s a.date)</code>.</p>
</blockquote>

<p>Also, in addition to stating that all the styles should be shared in a common <code class="language-plaintext highlighter-rouge">stylesheet.css</code>, I gave a file tree of the expected output, including the <code class="language-plaintext highlighter-rouge">stylesheet.css</code>.</p>

<p>Claude now correctly used the <code class="language-plaintext highlighter-rouge">timedesc</code> library and tried to write a stylesheet. However, Claude had hallucinated a <code class="language-plaintext highlighter-rouge">css</code> and <code class="language-plaintext highlighter-rouge">css_rule</code> function in <code class="language-plaintext highlighter-rouge">tyxml</code> to do this, where none exists. Furthermore, adding the link to the stylesheet was causing problems as <code class="language-plaintext highlighter-rouge">link</code> had multiple definitions in scope and needed to be explicitly referenced as <code class="language-plaintext highlighter-rouge">Tyxml.Html.link</code>. Claude’s style was to open everything at the beginning of the file:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">open</span> <span class="nn">Yojson</span><span class="p">.</span><span class="nc">Safe</span>
<span class="k">open</span> <span class="nn">Yojson</span><span class="p">.</span><span class="nn">Safe</span><span class="p">.</span><span class="nc">Util</span>
<span class="k">open</span> <span class="nn">Tyxml</span><span class="p">.</span><span class="nc">Html</span>
<span class="k">open</span> <span class="nc">Printf</span> 
<span class="k">open</span> <span class="nc">Unix</span> 
</code></pre></div></div>

<p>The compiler picked <code class="language-plaintext highlighter-rouge">Unix.link</code> rather than <code class="language-plaintext highlighter-rouge">Tyxml.Html.link</code>:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>File "ci_generator.ml", line 347, characters 18-33:
347 |         link ~rel:[ `Stylesheet ] ~href:"/stylesheet.css" ();
                        ^^^^^^^^^^^^^^^
Error: The function applied to this argument has type
         ?follow:bool -&gt; string -&gt; unit
This argument cannot be applied with label ~rel
</code></pre></div></div>

<blockquote>
  <p>Stylistically, please can we only <code class="language-plaintext highlighter-rouge">open</code> things in functions where they are used: <code class="language-plaintext highlighter-rouge">let foo () = let open Tyxml.Html in ...</code>. This will avoid global opens at the top of the file and avoid any confusion where libraries have functions with the same name, e.g., <code class="language-plaintext highlighter-rouge">Unix.link</code> and <code class="language-plaintext highlighter-rouge">TyXml.Html.link</code>.</p>
</blockquote>

<p>Furthermore, I had two JSON files in my input, each with the field <code class="language-plaintext highlighter-rouge">name</code>. Claude converted these into OCaml types; however, when referencing these later as function parameters, the compiler frequently picks the wrong one. This can be <em>fixed</em> by adding a specific type to the function parameter <code class="language-plaintext highlighter-rouge">let f (t:foo) = ...</code>. I’ve cheated here and renamed the field in one of the JSON files.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">type</span> <span class="n">foo</span> <span class="o">=</span> <span class="p">{</span>
  <span class="n">name</span> <span class="o">:</span> <span class="kt">string</span><span class="p">;</span>
  <span class="n">x</span> <span class="o">:</span> <span class="kt">string</span><span class="p">;</span>
<span class="p">}</span>

<span class="k">type</span> <span class="n">bar</span> <span class="o">=</span> <span class="p">{</span>
  <span class="n">name</span> <span class="o">:</span> <span class="kt">string</span><span class="p">;</span>
  <span class="n">y</span> <span class="o">:</span> <span class="kt">string</span><span class="p">;</span>
<span class="p">}</span>
</code></pre></div></div>

<p>Claude chose to extract the data from the Git repo using <code class="language-plaintext highlighter-rouge">git show --pretty=format:'%H|%ai|%s'</code>, this  ignores the <code class="language-plaintext highlighter-rouge">--date=iso-strict</code> directive. The correct format should be <code class="language-plaintext highlighter-rouge">%aI</code>. I updated my guidance on the use of <code class="language-plaintext highlighter-rouge">git show</code>.</p>

<p>My specification now comes in just under 1000 words. From that single specification document, Claude produces a valid OCaml program on the first try, which builds the static site as per my design. <code class="language-plaintext highlighter-rouge">wc -l</code> shows me there are 662 lines of code.</p>

<p>It’s amusing to run it more than once to see the variations in styling!</p>

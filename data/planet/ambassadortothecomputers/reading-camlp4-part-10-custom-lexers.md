---
title: 'Reading Camlp4, part 10: custom lexers'
description: "As a final modification to our running JSON quotation example, I want
  to repair a problem noted in the first post \u2014that the default lexer do..."
url: http://ambassadortothecomputers.blogspot.com/2010/08/reading-camlp4-part-10-custom-lexers.html
date: 2010-08-13T19:16:00-00:00
preview_image:
featured:
authors:
- ambassadortothecomputers
---

<p>As a final modification to our running JSON quotation example, I want to repair a problem noted in the <a href="http://ambassadortothecomputers.blogspot.com/2010/08/reading-camlp4-part-8-implementing.html">first post</a>&mdash;that the default lexer does not match the <a href="http://www.ietf.org/rfc/rfc4627.txt">JSON spec</a>&mdash;and in doing so demonstrate the use of custom lexers with Camlp4 grammars. We&rsquo;ll parse UTF8-encoded Javascript using the <a href="http://www.cduce.org/download.html#side">ulex</a> library.</p> 
 
<p>To use a custom lexer, we need to pass a module matching the <code>Lexer</code> signature (in <code>camlp4/Camlp4/Sig.ml</code>) to <code>Camlp4.PreCast.MakeGram</code>. (Recall that we get back an empty grammar which we then extend with parser entries. ) Let&rsquo;s look at the signature and its subsignatures, and our implementation of each:</p> 
<b>Error</b><div class="highlight"><pre><code class="ocaml">  <span class="k">module</span> <span class="k">type</span> <span class="nc">Error</span> <span class="o">=</span> <span class="k">sig</span> 
    <span class="k">type</span> <span class="n">t</span> 
    <span class="k">exception</span> <span class="nc">E</span> <span class="k">of</span> <span class="n">t</span> 
    <span class="k">val</span> <span class="n">to_string</span> <span class="o">:</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="kt">string</span> 
    <span class="k">val</span> <span class="n">print</span> <span class="o">:</span> <span class="nn">Format</span><span class="p">.</span><span class="n">formatter</span> <span class="o">-&gt;</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="kt">unit</span> 
  <span class="k">end</span> 
</code></pre> 
</div> 
<p>First we have a module for packaging up an exception so it can be handled generically (in particular it may be registered with <code>Camlp4.ErrorHandler</code> for common printing and handling). We have simple exception needs so we give a simple implementation:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">module</span> <span class="nc">Error</span> <span class="o">=</span> 
  <span class="k">struct</span> 
    <span class="k">type</span> <span class="n">t</span> <span class="o">=</span> <span class="kt">string</span> 
    <span class="k">exception</span> <span class="nc">E</span> <span class="k">of</span> <span class="kt">string</span> 
    <span class="k">let</span> <span class="n">print</span> <span class="o">=</span> <span class="nn">Format</span><span class="p">.</span><span class="n">pp_print_string</span> 
    <span class="k">let</span> <span class="n">to_string</span> <span class="n">x</span> <span class="o">=</span> <span class="n">x</span> 
  <span class="k">end</span> 
  <span class="k">let</span> <span class="o">_</span> <span class="o">=</span> <span class="k">let</span> <span class="k">module</span> <span class="nc">M</span> <span class="o">=</span> <span class="nn">Camlp4</span><span class="p">.</span><span class="nn">ErrorHandler</span><span class="p">.</span><span class="nc">Register</span><span class="o">(</span><span class="nc">Error</span><span class="o">)</span> <span class="k">in</span> <span class="bp">()</span> 
</code></pre> 
</div><b>Token</b> 
<p>Next we have a module defining the tokens our lexer supports:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">module</span> <span class="k">type</span> <span class="nc">Token</span> <span class="o">=</span> <span class="k">sig</span> 
    <span class="k">module</span> <span class="nc">Loc</span> <span class="o">:</span> <span class="nc">Loc</span> 
  
    <span class="k">type</span> <span class="n">t</span> 
  
    <span class="k">val</span> <span class="n">to_string</span> <span class="o">:</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="kt">string</span> 
    <span class="k">val</span> <span class="n">print</span> <span class="o">:</span> <span class="nn">Format</span><span class="p">.</span><span class="n">formatter</span> <span class="o">-&gt;</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="kt">unit</span> 
    <span class="k">val</span> <span class="n">match_keyword</span> <span class="o">:</span> <span class="kt">string</span> <span class="o">-&gt;</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="kt">bool</span> 
    <span class="k">val</span> <span class="n">extract_string</span> <span class="o">:</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="kt">string</span> 
  
    <span class="k">module</span> <span class="nc">Filter</span> <span class="o">:</span> <span class="o">...</span> <span class="c">(* see below *)</span> 
    <span class="k">module</span> <span class="nc">Error</span> <span class="o">:</span> <span class="nc">Error</span> 
  <span class="k">end</span> 
</code></pre> 
</div> 
<p>The type <code>t</code> represents a token. This can be anything we like (in particular it does not need to be a variant with arms <code>KEYWORD</code>, <code>EOI</code>, etc. although that is the conventional representation), so long as we provide the specified functions to convert it to a string, print it to a formatter, determine if it matches a string keyword (recall that we can use literal strings in grammars; this function is called to see if the next token matches a literal string), and extract a string representation of it (called when you bind a variable to a token in a grammar&mdash;e.g. <code>n = NUMBER</code>). Here&rsquo;s our implementation:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">type</span> <span class="n">token</span> <span class="o">=</span> 
    <span class="o">|</span> <span class="nc">KEYWORD</span>  <span class="k">of</span> <span class="kt">string</span> 
    <span class="o">|</span> <span class="nc">NUMBER</span>   <span class="k">of</span> <span class="kt">string</span> 
    <span class="o">|</span> <span class="nc">STRING</span>   <span class="k">of</span> <span class="kt">string</span> 
    <span class="o">|</span> <span class="nc">ANTIQUOT</span> <span class="k">of</span> <span class="kt">string</span> <span class="o">*</span> <span class="kt">string</span> 
    <span class="o">|</span> <span class="nc">EOI</span> 
 
  <span class="k">module</span> <span class="nc">Token</span> <span class="o">=</span> 
  <span class="k">struct</span> 
    <span class="k">type</span> <span class="n">t</span> <span class="o">=</span> <span class="n">token</span> 
  
    <span class="k">let</span> <span class="n">to_string</span> <span class="n">t</span> <span class="o">=</span> 
      <span class="k">let</span> <span class="n">sf</span> <span class="o">=</span> <span class="nn">Printf</span><span class="p">.</span><span class="n">sprintf</span> <span class="k">in</span> 
      <span class="k">match</span> <span class="n">t</span> <span class="k">with</span> 
        <span class="o">|</span> <span class="nc">KEYWORD</span> <span class="n">s</span>       <span class="o">-&gt;</span> <span class="n">sf</span> <span class="s2">&quot;KEYWORD %S&quot;</span> <span class="n">s</span> 
        <span class="o">|</span> <span class="nc">NUMBER</span> <span class="n">s</span>        <span class="o">-&gt;</span> <span class="n">sf</span> <span class="s2">&quot;NUMBER %s&quot;</span> <span class="n">s</span> 
        <span class="o">|</span> <span class="nc">STRING</span> <span class="n">s</span>        <span class="o">-&gt;</span> <span class="n">sf</span> <span class="s2">&quot;STRING </span><span class="se">\&quot;</span><span class="s2">%s</span><span class="se">\&quot;</span><span class="s2">&quot;</span> <span class="n">s</span> 
        <span class="o">|</span> <span class="nc">ANTIQUOT</span> <span class="o">(</span><span class="n">n</span><span class="o">,</span> <span class="n">s</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="n">sf</span> <span class="s2">&quot;ANTIQUOT %s: %S&quot;</span> <span class="n">n</span> <span class="n">s</span> 
        <span class="o">|</span> <span class="nc">EOI</span>             <span class="o">-&gt;</span> <span class="n">sf</span> <span class="s2">&quot;EOI&quot;</span> 
  
    <span class="k">let</span> <span class="n">print</span> <span class="n">ppf</span> <span class="n">x</span> <span class="o">=</span> <span class="nn">Format</span><span class="p">.</span><span class="n">pp_print_string</span> <span class="n">ppf</span> <span class="o">(</span><span class="n">to_string</span> <span class="n">x</span><span class="o">)</span> 
  
    <span class="k">let</span> <span class="n">match_keyword</span> <span class="n">kwd</span> <span class="o">=</span> 
      <span class="k">function</span> 
        <span class="o">|</span> <span class="nc">KEYWORD</span> <span class="n">kwd'</span> <span class="k">when</span> <span class="n">kwd</span> <span class="o">=</span> <span class="n">kwd'</span> <span class="o">-&gt;</span> <span class="bp">true</span> 
        <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="bp">false</span> 
  
    <span class="k">let</span> <span class="n">extract_string</span> <span class="o">=</span> 
      <span class="k">function</span> 
        <span class="o">|</span> <span class="nc">KEYWORD</span> <span class="n">s</span> <span class="o">|</span> <span class="nc">NUMBER</span> <span class="n">s</span> <span class="o">|</span> <span class="nc">STRING</span> <span class="n">s</span> <span class="o">-&gt;</span> <span class="n">s</span> 
        <span class="o">|</span> <span class="n">tok</span> <span class="o">-&gt;</span> 
            <span class="n">invalid_arg</span> 
              <span class="o">(</span><span class="s2">&quot;Cannot extract a string from this token: &quot;</span> <span class="o">^</span> 
                 <span class="n">to_string</span> <span class="n">tok</span><span class="o">)</span> 
 
    <span class="k">module</span> <span class="nc">Loc</span> <span class="o">=</span> <span class="nn">Camlp4</span><span class="p">.</span><span class="nn">PreCast</span><span class="p">.</span><span class="nc">Loc</span> 
    <span class="k">module</span> <span class="nc">Error</span> <span class="o">=</span> <span class="nc">Error</span> 
    <span class="k">module</span> <span class="nc">Filter</span> <span class="o">=</span> <span class="o">...</span> <span class="c">(* see below *)</span> 
  <span class="k">end</span> 
</code></pre> 
</div> 
<p>Not much to it. <code>KEYWORD</code> covers <code>true</code>, <code>false</code>, <code>null</code>, and punctuation; <code>NUMBER</code> and <code>STRING</code> are JSON numbers and strings; as we saw <a href="http://ambassadortothecomputers.blogspot.com/2010/08/reading-camlp4-part-9-implementing.html">last time</a> antiquotations are returned in <code>ANTIQUOT</code>; finally we signal the end of the input with <code>EOI</code>.</p> 
<b>Filter</b><div class="highlight"><pre><code class="ocaml">  <span class="k">module</span> <span class="nc">Filter</span> <span class="o">:</span> <span class="k">sig</span> 
    <span class="k">type</span> <span class="n">token_filter</span> <span class="o">=</span> 
      <span class="o">(</span><span class="n">t</span> <span class="o">*</span> <span class="nn">Loc</span><span class="p">.</span><span class="n">t</span><span class="o">)</span> <span class="nn">Stream</span><span class="p">.</span><span class="n">t</span> <span class="o">-&gt;</span> <span class="o">(</span><span class="n">t</span> <span class="o">*</span> <span class="nn">Loc</span><span class="p">.</span><span class="n">t</span><span class="o">)</span> <span class="nn">Stream</span><span class="p">.</span><span class="n">t</span> 
 
    <span class="k">type</span> <span class="n">t</span> 
 
    <span class="k">val</span> <span class="n">mk</span> <span class="o">:</span> <span class="o">(</span><span class="kt">string</span> <span class="o">-&gt;</span> <span class="kt">bool</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="n">t</span> 
    <span class="k">val</span> <span class="n">define_filter</span> <span class="o">:</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="o">(</span><span class="n">token_filter</span> <span class="o">-&gt;</span> <span class="n">token_filter</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="kt">unit</span> 
    <span class="k">val</span> <span class="n">filter</span> <span class="o">:</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="n">token_filter</span> 
    <span class="k">val</span> <span class="n">keyword_added</span> <span class="o">:</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="kt">string</span> <span class="o">-&gt;</span> <span class="kt">bool</span> <span class="o">-&gt;</span> <span class="kt">unit</span> 
    <span class="k">val</span> <span class="n">keyword_removed</span> <span class="o">:</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="kt">string</span> <span class="o">-&gt;</span> <span class="kt">unit</span> 
  <span class="k">end</span><span class="o">;</span> 
</code></pre> 
</div> 
<p>The <code>Filter</code> module provides filters over token streams. We don&rsquo;t have a need for it in the JSON example, but it&rsquo;s interesting to see how it is implemented in the default lexer and used in the OCaml parser. The argument to <code>mk</code> is a function indicating whether a string should be treated as a keyword (i.e. the literal string is used in the grammar), and the default lexer uses it to filter the token stream to convert identifiers into keywords. If we wanted the JSON parser to be extensible, we would need to take this into account; instead we&rsquo;ll just stub out the functions:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">module</span> <span class="nc">Filter</span> <span class="o">=</span> 
  <span class="k">struct</span> 
    <span class="k">type</span> <span class="n">token_filter</span> <span class="o">=</span> 
      <span class="o">(</span><span class="n">t</span> <span class="o">*</span> <span class="nn">Loc</span><span class="p">.</span><span class="n">t</span><span class="o">)</span> <span class="nn">Stream</span><span class="p">.</span><span class="n">t</span> <span class="o">-&gt;</span> <span class="o">(</span><span class="n">t</span> <span class="o">*</span> <span class="nn">Loc</span><span class="p">.</span><span class="n">t</span><span class="o">)</span> <span class="nn">Stream</span><span class="p">.</span><span class="n">t</span> 
 
    <span class="k">type</span> <span class="n">t</span> <span class="o">=</span> <span class="kt">unit</span> 
 
    <span class="k">let</span> <span class="n">mk</span> <span class="o">_</span> <span class="o">=</span> <span class="bp">()</span> 
    <span class="k">let</span> <span class="n">filter</span> <span class="o">_</span> <span class="n">strm</span> <span class="o">=</span> <span class="n">strm</span> 
    <span class="k">let</span> <span class="n">define_filter</span> <span class="o">_</span> <span class="o">_</span> <span class="o">=</span> <span class="bp">()</span> 
    <span class="k">let</span> <span class="n">keyword_added</span> <span class="o">_</span> <span class="o">_</span> <span class="o">_</span> <span class="o">=</span> <span class="bp">()</span> 
    <span class="k">let</span> <span class="n">keyword_removed</span> <span class="o">_</span> <span class="o">_</span> <span class="o">=</span> <span class="bp">()</span> 
  <span class="k">end</span> 
</code></pre> 
</div><b>Lexer</b> 
<p>Finally we have <code>Lexer</code>, which packages up the other modules and provides the actual lexing function. The lexing function takes an initial location and a character stream, and returns a stream of token and location pairs:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">module</span> <span class="k">type</span> <span class="nc">Lexer</span> <span class="o">=</span> <span class="k">sig</span> 
  <span class="k">module</span> <span class="nc">Loc</span> <span class="o">:</span> <span class="nc">Loc</span> 
  <span class="k">module</span> <span class="nc">Token</span> <span class="o">:</span> <span class="nc">Token</span> <span class="k">with</span> <span class="k">module</span> <span class="nc">Loc</span> <span class="o">=</span> <span class="nc">Loc</span> 
  <span class="k">module</span> <span class="nc">Error</span> <span class="o">:</span> <span class="nc">Error</span> 
 
  <span class="k">val</span> <span class="n">mk</span> <span class="o">:</span> 
    <span class="kt">unit</span> <span class="o">-&gt;</span> 
    <span class="o">(</span><span class="nn">Loc</span><span class="p">.</span><span class="n">t</span> <span class="o">-&gt;</span> <span class="kt">char</span> <span class="nn">Stream</span><span class="p">.</span><span class="n">t</span> <span class="o">-&gt;</span> <span class="o">(</span><span class="nn">Token</span><span class="p">.</span><span class="n">t</span> <span class="o">*</span> <span class="nn">Loc</span><span class="p">.</span><span class="n">t</span><span class="o">)</span> <span class="nn">Stream</span><span class="p">.</span><span class="n">t</span><span class="o">)</span> 
<span class="k">end</span> 
</code></pre> 
</div> 
<p>I don&rsquo;t want to go through the whole lexing function; it is not very interesting. But here is the main loop:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">let</span> <span class="k">rec</span> <span class="n">token</span> <span class="n">c</span> <span class="o">=</span> <span class="n">lexer</span> 
  <span class="o">|</span> <span class="n">eof</span> <span class="o">-&gt;</span> <span class="nc">EOI</span> 
 
  <span class="o">|</span> <span class="n">newline</span> <span class="o">-&gt;</span> <span class="n">next_line</span> <span class="n">c</span><span class="o">;</span> <span class="n">token</span> <span class="n">c</span> <span class="n">c</span><span class="o">.</span><span class="n">lexbuf</span> 
  <span class="o">|</span> <span class="n">blank</span><span class="o">+</span> <span class="o">-&gt;</span> <span class="n">token</span> <span class="n">c</span> <span class="n">c</span><span class="o">.</span><span class="n">lexbuf</span> 
 
  <span class="o">|</span> <span class="sc">'-'</span><span class="o">?</span> <span class="o">[</span><span class="sc">'0'</span><span class="o">-</span><span class="sc">'9'</span><span class="o">]+</span> <span class="o">(</span><span class="sc">'.'</span> <span class="o">[</span><span class="sc">'0'</span><span class="o">-</span><span class="sc">'9'</span><span class="o">]*</span> <span class="o">)?</span> 
      <span class="o">((</span><span class="sc">'e'</span><span class="o">|</span><span class="sc">'E'</span><span class="o">)(</span><span class="sc">'+'</span><span class="o">|</span><span class="sc">'-'</span><span class="o">)?([</span><span class="sc">'0'</span><span class="o">-</span><span class="sc">'9'</span><span class="o">]+))?</span> <span class="o">-&gt;</span> 
        <span class="nc">NUMBER</span> <span class="o">(</span><span class="nn">L</span><span class="p">.</span><span class="n">utf8_lexeme</span> <span class="n">c</span><span class="o">.</span><span class="n">lexbuf</span><span class="o">)</span> 
 
  <span class="o">|</span> <span class="o">[</span> <span class="s2">&quot;{}[]:,&quot;</span> <span class="o">]</span> <span class="o">|</span> <span class="s2">&quot;null&quot;</span> <span class="o">|</span> <span class="s2">&quot;true&quot;</span> <span class="o">|</span> <span class="s2">&quot;false&quot;</span> <span class="o">-&gt;</span> 
      <span class="nc">KEYWORD</span> <span class="o">(</span><span class="nn">L</span><span class="p">.</span><span class="n">utf8_lexeme</span> <span class="n">c</span><span class="o">.</span><span class="n">lexbuf</span><span class="o">)</span> 
 
  <span class="o">|</span> <span class="sc">'&quot;'</span> <span class="o">-&gt;</span> 
      <span class="n">set_start_loc</span> <span class="n">c</span><span class="o">;</span> 
      <span class="kt">string</span> <span class="n">c</span> <span class="n">c</span><span class="o">.</span><span class="n">lexbuf</span><span class="o">;</span> 
      <span class="nc">STRING</span> <span class="o">(</span><span class="n">get_stored_string</span> <span class="n">c</span><span class="o">)</span> 
 
  <span class="o">|</span> <span class="s2">&quot;$&quot;</span> <span class="o">-&gt;</span> 
      <span class="n">set_start_loc</span> <span class="n">c</span><span class="o">;</span> 
      <span class="n">c</span><span class="o">.</span><span class="n">enc</span> <span class="o">:=</span> <span class="nn">Ulexing</span><span class="p">.</span><span class="nc">Latin1</span><span class="o">;</span> 
      <span class="k">let</span> <span class="n">aq</span> <span class="o">=</span> <span class="n">antiquot</span> <span class="n">c</span> <span class="n">lexbuf</span> <span class="k">in</span> 
      <span class="n">c</span><span class="o">.</span><span class="n">enc</span> <span class="o">:=</span> <span class="nn">Ulexing</span><span class="p">.</span><span class="nc">Utf8</span><span class="o">;</span> 
      <span class="n">aq</span> 
 
  <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="n">illegal</span> <span class="n">c</span> 
</code></pre> 
</div> 
<p>The <code>lexer</code> syntax is an extension provided by <code>ulex</code>; the effect is similar to <code>ocamllex</code>. The lexer needs to keep track of the current location and return it along with the token (<code>next_line</code> advances the current location; <code>set_start_loc</code> is for when a token spans multiple <code>ulex</code> lexemes). The lexer also needs to parse antiquotations, taking into account nested quotations within them.</p> 
 
<p>(I think it is not actually necessary to lex JSON as UTF8. The only place that non-ASCII characters can appear is in a string. To lex a string we just accumulate characters until we see a double-quote, which cannot appear as part of a multibyte character. So it would work just as well to accumulate bytes. I am no Unicode expert though. This example was extracted from the Javascript parser in <a href="http://github.com/jaked/ocamljs/tree/master/src/jslib/">jslib</a>, where I think UTF8 must be taken into account.)</p> 
<b>Hooking up the lexer</b> 
<p>There are a handful of changes we need to make to call the custom lexer:</p> 
 
<p>In <code>Jq_parser</code> we make the grammar with the custom lexer module, and open it so the token constructors are available; we also replace the <code>INT</code> and <code>FLOAT</code> cases with just <code>NUMBER</code>; for the other cases we used the same token constructor names as the default lexer so we don&rsquo;t need to change anything.</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">open</span> <span class="nc">Jq_lexer</span> 
 
  <span class="k">module</span> <span class="nc">Gram</span> <span class="o">=</span> <span class="nn">Camlp4</span><span class="p">.</span><span class="nn">PreCast</span><span class="p">.</span><span class="nc">MakeGram</span><span class="o">(</span><span class="nc">Jq_lexer</span><span class="o">)</span> 
 
  <span class="o">...</span> 
      <span class="o">|</span> <span class="n">n</span> <span class="o">=</span> <span class="nc">NUMBER</span> <span class="o">-&gt;</span> <span class="nc">Jq_number</span> <span class="o">(</span><span class="n">float_of_string</span> <span class="n">n</span><span class="o">)</span> 
</code></pre> 
</div> 
<p>In <code>Jq_quotations</code> we have <code>Camlp4.PreCast</code> open (so references to <code>Ast</code> in the <code>&lt;:expr&lt; &gt;&gt;</code> quotations resolve), so <code>EOI</code> is <code>Camlp4.PreCast.EOI</code>; we want <code>Jq_lexer.EOI</code>, so we need to write it explicitly:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="n">json_eoi</span><span class="o">:</span> <span class="o">[[</span> <span class="n">x</span> <span class="o">=</span> <span class="nn">Jq_parser</span><span class="p">.</span><span class="n">json</span><span class="o">;</span> <span class="o">`</span><span class="nn">Jq_lexer</span><span class="p">.</span><span class="nc">EOI</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">]];</span> 
</code></pre> 
</div> 
<p>(Recall that the backtick lets us match a constructor directly; for some reason we can&rsquo;t module-qualify <code>EOI</code> without it.)</p> 
 
<p>That&rsquo;s it.</p> 
 
<p>I want to finish off this series next time by covering grammar extension, with an example OCaml syntax extension.</p> 
 
<p>(You can find the complete code for this example <a href="http://github.com/jaked/ambassadortothecomputers.blogspot.com/tree/master/_code/camlp4-custom-lexers">here</a>.)</p>

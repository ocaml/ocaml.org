---
title: Format strings in OCaml
description: OCAML doesn't have string interpolation, but it does have C-style format
  strings (but type-safe)....
url: https://dev.to/yawaramin/format-strings-in-ocaml-59ci
date: 2024-02-25T02:34:10-00:00
preview_image: https://media2.dev.to/dynamic/image/width=1000,height=500,fit=cover,gravity=auto,format=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fpamv662aekj5rk1gpxod.png
authors:
- Yawar Amin
source:
ignore:
---

<p>OCAML doesn't have string interpolation, but it does have C-style format strings (but type-safe). Here's an example:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight ocaml"><code><span class="k">let</span> <span class="n">hello</span> <span class="n">name</span> <span class="o">=</span> <span class="nn">Printf</span><span class="p">.</span><span class="n">printf</span> <span class="s2">"Hello, %s!</span><span class="se">\n</span><span class="s2">"</span> <span class="n">name</span>
<span class="c">(* Can be written as: let hello = Printf.printf "Hello, %s!" *)</span>
</code></pre>

</div>



<p>This is type-safe in an almost magical way (example REPL session):<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight plaintext"><code># hello 1;;
Error: This expression has type int but an expression was expected of type
         string
</code></pre>

</div>



<p>It can however be a little tricky to wrap your head around:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight plaintext"><code># let bob = "Bob";;
val bob : string = "Bob"

# Printf.printf bob;;
Error: This expression has type string but an expression was expected of type
         ('a, out_channel, unit) format =
           ('a, out_channel, unit, unit, unit, unit) format6
</code></pre>

</div>



<p>This error is saying that the <code>printf</code> function wants a 'format string', which is distinct from a regular string:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight plaintext"><code># let bob = format_of_string "bob";;
val bob : ('_weak1, '_weak2, '_weak3, '_weak4, '_weak4, '_weak1) format6 =
  CamlinternalFormatBasics.Format
   (CamlinternalFormatBasics.String_literal ("bob",
     CamlinternalFormatBasics.End_of_format),
   "bob")

# Printf.printf bob;;
bob- : unit = ()
</code></pre>

</div>



<p>OCaml distinguishes between regular strings and format strings. The latter are complex structures which encode type information inside them. They are parsed and turned into these structures either when the compiler sees a string literal and'realizes' that a format string is expected, <em>or</em> when you (the programmer) explicitly asks for the conversion. Another example:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight plaintext"><code># let fmt = "Hello, %s!\n" ^^ "";;
val fmt :
  (string -&gt; '_weak5, '_weak6, '_weak7, '_weak8, '_weak8, '_weak5) format6 =
  CamlinternalFormatBasics.Format
   (CamlinternalFormatBasics.String_literal ("Hello, ",
     CamlinternalFormatBasics.String (CamlinternalFormatBasics.No_padding,
      CamlinternalFormatBasics.String_literal ("!\n",
       CamlinternalFormatBasics.End_of_format))),
   "Hello, %s!\n%,")

# Printf.printf fmt "Bob";;
Hello, Bob!
- : unit = ()
</code></pre>

</div>



<p>The <code>^^</code> operator is the <a href="https://v2.ocaml.org/api/Stdlib.html#VAL(%5E%5E)">format string concatenation</a> operator. Think of it as a more powerful version of the string concatenation operator, <code>^</code>. It can concatenate either format strings that have already been bound to a name, or string literals which it interprets as format strings:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight plaintext"><code># bob ^^ bob;;
- : (unit, out_channel, unit, unit, unit, unit) format6 =
CamlinternalFormatBasics.Format
 (CamlinternalFormatBasics.String_literal ("bob",
   CamlinternalFormatBasics.String_literal ("bob",
    CamlinternalFormatBasics.End_of_format)),
 "bob%,bob")

# bob ^^ "!";;
- : (unit, out_channel, unit, unit, unit, unit) format6 =
CamlinternalFormatBasics.Format
 (CamlinternalFormatBasics.String_literal ("bob",
   CamlinternalFormatBasics.Char_literal ('!',
    CamlinternalFormatBasics.End_of_format)),
 "bob%,!")
</code></pre>

</div>



<h2>
  
  
  Custom formatting functions
</h2>

<p>The really amazing thing about format strings is that you can define your own functions which use them to output formatted text. For example:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight plaintext"><code># let shout fmt = Printf.ksprintf (fun s -&gt; s ^ "!") fmt;;
val shout : ('a, unit, string, string) format4 -&gt; 'a = &lt;fun&gt;

# shout "hello";;
- : string = "hello!"

# let jim = "Jim";;
val jim : string = "Jim"

# shout "Hello, %s" jim;;
- : string = "Hello, Jim!"
</code></pre>

</div>



<p>This is really just a simple example; you actually are not restricted to outputting only strings from <code>ksprintf</code>. You can output any data structure you like. Think of <code>ksprintf</code> as '(k)ontinuation-based sprintf'; in other words, it takes a format string (<code>fmt</code>), any arguments needed by the format string (eg <code>jim</code>), builds the output string, then passes it to the continuation that you provide (<code>fun s -&gt; ...</code>), in which you can build any value you want. This value will be the final output value of the function call.</p>

<p>Again, this is just as type-safe as the basic <code>printf</code> function:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight plaintext"><code># shout "Hello, jim" jim;;
Error: This expression has type
         ('a -&gt; 'b, unit, string, string, string, 'a -&gt; 'b)
         CamlinternalFormatBasics.fmt
       but an expression was expected of type
         ('a -&gt; 'b, unit, string, string, string, string)
         CamlinternalFormatBasics.fmt
       Type 'a -&gt; 'b is not compatible with type string
</code></pre>

</div>



<p>This error message looks a bit scary, but the real clue here is in the last line: an extra <code>string</code> argument was passed in, but it was expecting <code>'a -&gt; 'b</code>. Unfortunately the type error here is not that great because of how powerful and general this function is. Because it could potentially accept any number of arguments depending on the format string, its type is expressed in a very general way. This is a drawback of format strings to watch out for. But once you are familiar with it, it's typically not a big problem. You just need to match up the conversion specifications like <code>%</code> with the actual arguments passed in after the format string.</p>

<p>You might have noticed that the function is defined with <code>let shout fmt = ...</code>. It doesn't look like it could accept 'any number of arguments'. The trick here is that in OCaml, every function accepts only a single argument and returns either a final non-function value, or a new function. In the case of functions which use format strings, it depends on the conversion specifications, so the formal definition <code>shout fmt</code> could potentially turn into a call like <code>shout "%s bought %d apples today" bob num_apples</code>. As a shortcut, you can think of the format string <code>fmt</code> as a variadic argument which can potentially turn into any number of arguments at the callsite.</p>

<h2>
  
  
  More reading
</h2>

<p>You can read more about OCaml's format strings functionality in the documentation for the <a href="https://v2.ocaml.org/api/Printf.html">Printf</a> and <a href="https://v2.ocaml.org/api/Format.html">Format</a> modules. There is also a <a href="https://ocaml.org/docs/formatting-text">gentle guide</a> to formatting text, something OCaml has fairly advanced support for because it turns out to be a pretty common requirement to print out the values of various things at runtime.</p>

<p>On that note, I have also written more about defining custom formatted printers for any value <a href="https://dev.to/yawaramin/how-to-print-anything-in-ocaml-1hkl">right here</a> on dev.to. Enjoy 🐫</p>



---
title: An introduction to fuzzing OCaml with AFL, Crowbar and Bun
description: "American Fuzzy Lop or AFL is a fuzzer: a program that tries to find
  bugs in\nother programs by sending them various auto-generated inputs\u2026"
url: https://tarides.com/blog/2019-09-04-an-introduction-to-fuzzing-ocaml-with-afl-crowbar-and-bun
date: 2019-09-04T00:00:00-00:00
preview_image: https://tarides.com/static/4eed05522f6733d728f6dc01bbe33e09/eee8e/feather.jpg
featured:
---

<p><a href="http://lcamtuf.coredump.cx/afl/">American Fuzzy Lop</a> or AFL is a <em>fuzzer</em>: a program that tries to find bugs in
other programs by sending them various auto-generated inputs. This article covers the
basics of AFL and shows an example of fuzzing a parser written in OCaml. It also introduces two
extensions: the <a href="https://github.com/stedolan/crowbar/">Crowbar</a> library which can be used to fuzz any kind of OCaml program or
function and the <a href="https://github.com/yomimono/ocaml-bun/">Bun</a> tool for integrating fuzzing into your CI.</p>
<p>All of the examples given in this article are available on GitHub at
<a href="https://github.com/NathanReb/ocaml-afl-examples">ocaml-afl-examples</a>. The <code>README</code> contains all the information you need to understand,
build and fuzz them yourself.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#what-is-afl" aria-label="what is afl permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>What is AFL?</h2>
<p>AFL actually isn't <em>just</em> a fuzzer but a set of tools. What makes it so good is that it doesn't just
blindly send random input to your program hoping for it to crash; it inspects the execution paths
of the program and uses that information to figure out which mutations to apply to the previous
inputs to trigger new execution paths. This approach allows for much more efficient and reliable
fuzzing (as it will try to maximize coverage) but requires the binaries to be instrumented so the
execution can be monitored.</p>
<p>AFL provides wrappers for the common C compilers that you can use to produce the instrumented
binaries along with the CLI fuzzing client: <code>afl-fuzz</code>.</p>
<p><code>afl-fuzz</code> is straight-forward to use. It takes an input directory containing a few initial valid
inputs to your program, an output directory and the instrumented binary. It will then repeatedly
mutate the inputs and feed them to the program, registering the ones that lead to crashes or
hangs in the output directory.</p>
<p>Because it works in such a way, it makes it very easy to fuzz a parser.</p>
<p>To fuzz a <code>parse.exe</code> binary, that takes a file as its first command-line argument and parses it,
you can invoke <code>afl-fuzz</code> in the following way:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">$ afl-fuzz -i inputs/ -o findings/ /path/to/parse.exe @@</code></pre></div>
<p>The <code>findings/</code> directory is where <code>afl-fuzz</code> will write the crashes it finds, it will create it
for you if it doesn't exist.
The <code>inputs/</code> directory contains one or more valid input files for your
program. By valid we mean &quot;that don't crash your program&quot;.
Finally the <code>@@</code> part tells <code>afl-fuzz</code> where on the command line the input file should be passed to
your program, in our case, as the first argument.</p>
<p>Note that it is possible to supply <code>afl-fuzz</code> with more detail about how to invoke your program. If
you need to pass it command-line options for instance, you can run it as:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">$ afl-fuzz -i inputs/ -o findings/ -- /path/to/parse.exe --option=value @@</code></pre></div>
<p>If you wish to fuzz a program that takes its input from standard input, you can also do that by removing the
<code>@@</code> from the <code>afl-fuzz</code> invocation.</p>
<p>Once <code>afl-fuzz</code> starts, it will draw a fancy looking table on the standard output to keep you
updated about its progress. From there, you'll mostly be interested in is the top right
corner which contains the number of crashes and hangs it has found so far:</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/893fd2c3d0dfbb1c576fd016b6963e96/f2793/afl_example_output.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 63.52941176470588%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAANCAYAAACpUE5eAAAACXBIWXMAAA7EAAAOxAGVKw4bAAACMUlEQVQ4y2WT6W7bMBCEqdsSD1ESD1Fx4jhuDDTv/35fQSZGk/bHggI4Ozs7HAkhBP+WtYIQBMsi2FaBsRViWRFLj9gEwv7f87f6HjFNiHFEaE3ddkjZolRTTikbxqmlk5Jm7GlkTTU2CCm/KvdOiLqmqWvEMI7IeWbzHp8SUilub7+wdmXfE/t+EHxkz/frVlSouuXded5i5DUELlKzDCNVUyO0MWwh4GLEhYBSitfXV5xzHMeBtbYM6aeJIW8iBHPX8mEUH+vC79Vy7ztc1xWVIqvTMTKnhEkJZUwhCyGwLEshaLqO07ahvMecn5gGSWwDaXBchgM1aERT0bUdwqwrKiVsSuh9L2pijKX6vqeqKsZp+hx4HKwpMcWEnR3ORYI7MMpQVxVdVmmXpXi3hoC2ltvbG25d2WPEGFMUjuNYMPF8xjqHmmeeguO6R/SpL5g8uGmanIa1+OdjLITP1ytjJqrrAsrg0+lEDIHgfVGux5Ena7lvjqd5/knYS4lMiXnfGbJ31yvLywuL98XDNVuiFHWORdvSNg3NMDDmjS4Xhhjp+r5Epqy8WMv5OAjOYZTi/XYjel9Wf7lcuN1uReH38ObGlH12Dqs1wzB8Pl5WqLUmHQc+v6AxvN/vxH0v0TFak+/btv1BOE0T5+fnkoR5nvE+UImvlfMquSETPjKYfdr3vYAfJNmj757mfGZ8xqT8Q2ySpv0i/LfypFx50OP7+92DOJeUkuE0IGZBVVf8AS4+KX9Wn+12AAAAAElFTkSuQmCC'); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/893fd2c3d0dfbb1c576fd016b6963e96/c5bb3/afl_example_output.png" class="gatsby-resp-image-image" alt="Example output from afl-fuzz" title="Example output from afl-fuzz" srcset="/static/893fd2c3d0dfbb1c576fd016b6963e96/04472/afl_example_output.png 170w,
/static/893fd2c3d0dfbb1c576fd016b6963e96/9f933/afl_example_output.png 340w,
/static/893fd2c3d0dfbb1c576fd016b6963e96/c5bb3/afl_example_output.png 680w,
/static/893fd2c3d0dfbb1c576fd016b6963e96/f2793/afl_example_output.png 743w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<p>You might need to change some of your CPU settings to achieve better performance while fuzzing.
<code>afl-fuzz</code>'s output will tell you if that's the case and guide you through the steps required to
make that happen.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#using-afl-to-fuzz-an-ocaml-parser" aria-label="using afl to fuzz an ocaml parser permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Using AFL to fuzz an OCaml parser</h2>
<p>First of all, if you want to fuzz an OCaml program with AFL you'll need to produce an instrumented
binary. <code>afl-fuzz</code> has an option to work with regular binaries but you'd lose a lot of what makes it
efficient. To instrument your binary you can simply install a <code>+afl</code> opam switch and build your
executable from there. AFL compiler variants are available from OCaml <code>4.05.0</code> onwards. To install such
a switch you can run:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">$ opam switch create fuzzing-switch 4.07.1+afl</code></pre></div>
<p>If your program already parses the standard input or a file given to it via the command line, you
can simply build the executable from your <code>+afl</code> switch and adapt the above examples. If it doesn't,
it's still easy to fuzz any parsing function.</p>
<p>Imagine we have a <code>simple-parser</code> library which exposes the following <code>parse_int</code> function:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">val</span> parse_int<span class="token punctuation">:</span> string <span class="token operator">-&gt;</span> <span class="token punctuation">(</span>int<span class="token punctuation">,</span> <span class="token punctuation">[</span><span class="token operator">&gt;</span> <span class="token variant variable">`Msg</span> <span class="token keyword">of</span> string<span class="token punctuation">]</span><span class="token punctuation">)</span> result
<span class="token comment">(** Parse the given string as an int or return [Error (`Msg _)].
    Does not raise, usually... *)</span></code></pre></div>
<p>We want to use AFL to make sure our function is robust and won't crash when receiving unexpected
inputs. As you can see the function returns a result and isn't supposed to raise exceptions. We want
to make sure that's true.</p>
<p>To find crashes, AFL traps the signals sent by your program. That means that it will consider
uncaught OCaml exceptions as crashes. That's good because it makes it really simple to write a
<code>fuzz_me.ml</code> executable that fits what <code>afl-fuzz</code> expects:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span>
  <span class="token keyword">let</span> file <span class="token operator">=</span> <span class="token module variable">Sys</span><span class="token punctuation">.</span>argv<span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token number">1</span><span class="token punctuation">)</span> <span class="token keyword">in</span>
  <span class="token keyword">let</span> ic <span class="token operator">=</span> open_in file <span class="token keyword">in</span>
  <span class="token keyword">let</span> length <span class="token operator">=</span> in_channel_length ic <span class="token keyword">in</span>
  <span class="token keyword">let</span> content <span class="token operator">=</span> really_input_string ic length <span class="token keyword">in</span>
  close_in ic<span class="token punctuation">;</span>
  ignore <span class="token punctuation">(</span><span class="token module variable">Simple_parser</span><span class="token punctuation">.</span>parse_int content<span class="token punctuation">)</span></code></pre></div>
<p>We have to provide example inputs to AFL so we can write a <code>valid</code> file to the <code>inputs/</code> directory
containing <code>123</code> and an <code>invalid</code> file containing <code>not an int</code>. Both should parse without crashing
and make good starting point for AFL as they should trigger different execution paths.</p>
<p>Because we want to make sure AFL does find crashes we can try to hide a bug in our function:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> parse_int s <span class="token operator">=</span>
  <span class="token keyword">match</span> <span class="token module variable">List</span><span class="token punctuation">.</span>init <span class="token punctuation">(</span><span class="token module variable">String</span><span class="token punctuation">.</span>length s<span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token module variable">String</span><span class="token punctuation">.</span>get s<span class="token punctuation">)</span> <span class="token keyword">with</span>
  <span class="token operator">|</span> <span class="token punctuation">[</span><span class="token string">'a'</span><span class="token punctuation">;</span> <span class="token string">'b'</span><span class="token punctuation">;</span> <span class="token string">'c'</span><span class="token punctuation">]</span> <span class="token operator">-&gt;</span> failwith <span class="token string">&quot;secret crash&quot;</span>
  <span class="token operator">|</span> <span class="token punctuation">_</span> <span class="token operator">-&gt;</span> <span class="token punctuation">(</span>
      <span class="token keyword">match</span> int_of_string_opt s <span class="token keyword">with</span>
      <span class="token operator">|</span> <span class="token module variable">None</span> <span class="token operator">-&gt;</span> <span class="token module variable">Error</span> <span class="token punctuation">(</span><span class="token variant variable">`Msg</span> <span class="token punctuation">(</span><span class="token module variable">Printf</span><span class="token punctuation">.</span>sprintf <span class="token string">&quot;Not an int: %S&quot;</span> s<span class="token punctuation">)</span><span class="token punctuation">)</span>
      <span class="token operator">|</span> <span class="token module variable">Some</span> i <span class="token operator">-&gt;</span> <span class="token module variable">Ok</span> i<span class="token punctuation">)</span></code></pre></div>
<p>Now we just have to build our native binary from the right switch and let <code>afl-fuzz</code> do the rest:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">$ afl-fuzz -i inputs/ -o findings/ ./fuzz_me.exe @@</code></pre></div>
<p>It should find that the <code>abc</code> input leads to a crash rather quickly. Once it does, you'll see it in
the top right corner of its output as shown in the picture from the previous section.</p>
<p>At this point you can interrupt <code>afl-fuzz</code> and have a look at the content of the <code>findings/crashes</code>:</p>
<div class="gatsby-highlight" data-language="sh"><pre class="language-sh"><code class="language-sh">$ ls findings/crashes/
id:000000,sig:06,src:000111,op:havoc,rep:16  README.txt</code></pre></div>
<p>As you can see it contains a <code>README.txt</code> which will give you some details about the <code>afl-fuzz</code>
invocation used to find the crashes and how to reproduce them in the folder and a file of the form
<code>id:...,sig:...,src:...,op:...,rep:...</code> per crash it found. Here there's just one:</p>
<div class="gatsby-highlight" data-language="sh"><pre class="language-sh"><code class="language-sh">$ cat findings/crashes/id:000000,sig:06,src:000111,op:havoc,rep:16
abc</code></pre></div>
<p>As expected it contains our special input that triggers our secret crash. We can rerun the program
with that input ourselves to make sure it does trigger it:</p>
<div class="gatsby-highlight" data-language="sh"><pre class="language-sh"><code class="language-sh">$ ./fuzz_me.exe findings/crashes/id:000000,sig:06,src:000111,op:havoc,rep:16
Fatal error: exception Failure(&quot;secret crash&quot;)</code></pre></div>
<p>No surprise here, it does trigger our uncaught exception and crashes shamefully.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#using-crowbar-and-afl-for-property-based-testing" aria-label="using crowbar and afl for property based testing permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Using Crowbar and AFL for property-based testing</h2>
<p>This works well but only being able to fuzz parsers is quite a limitation. That's where <a href="https://github.com/stedolan/crowbar/">Crowbar</a>
comes into play.</p>
<p>Crowbar is a property-based testing framework. It's much like Haskell's <a href="http://hackage.haskell.org/package/QuickCheck">QuickCheck</a>.
To test a given function, you define how its arguments are shaped, a set of properties the result
should satisfy and it will make sure they hold with any combinations of randomly generated
arguments.
Let's clarify that with an example.</p>
<p>I wrote a library called <code>Awesome_list</code> and I want to test its <code>sort</code> function:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">val</span> sort<span class="token punctuation">:</span> int list <span class="token operator">-&gt;</span> int list
<span class="token comment">(** Sorts the given list of integers. Result list is sorted in increasing
    order, most of the time... *)</span></code></pre></div>
<p>I want to make sure it really works so I'm going to use Crowbar to generate a whole lot of
lists of integers and verify that when I sort them with <code>Awesome_list.sort</code> the result is, well...
sorted.</p>
<p>We'll write our tests in a <code>fuzz_me.ml</code> file.
First we need to tell Crowbar how to generate arguments for our function. It exposes some
combinators to help you do that:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> int_list <span class="token operator">=</span> <span class="token module variable">Crowbar</span><span class="token punctuation">.</span><span class="token punctuation">(</span>list <span class="token punctuation">(</span>range <span class="token number">10</span><span class="token punctuation">)</span><span class="token punctuation">)</span></code></pre></div>
<p>Here we're telling Crowbar to generate lists of any size, containing integers ranging from 0
to 10. Crowbar also exposes more complex and custom generator combinators so don't worry,
you can use it to build more complex arguments.</p>
<p>Now we need to define our property. Once again it's pretty simple, we just want the output to be
sorted:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> is_sorted l <span class="token operator">=</span>
  <span class="token keyword">let</span> <span class="token keyword">rec</span> is_sorted <span class="token operator">=</span> <span class="token keyword">function</span>
    <span class="token operator">|</span> <span class="token punctuation">[</span><span class="token punctuation">]</span> <span class="token operator">|</span> <span class="token punctuation">[</span><span class="token punctuation">_</span><span class="token punctuation">]</span> <span class="token operator">-&gt;</span> <span class="token boolean">true</span>
    <span class="token operator">|</span> hd<span class="token punctuation">:</span><span class="token punctuation">:</span><span class="token punctuation">(</span>hd'<span class="token punctuation">:</span><span class="token punctuation">:</span><span class="token punctuation">_</span> <span class="token keyword">as</span> tl<span class="token punctuation">)</span> <span class="token operator">-&gt;</span> hd <span class="token operator">&lt;=</span> hd' <span class="token operator">&amp;&amp;</span> is_sorted tl
  <span class="token keyword">in</span>
  <span class="token module variable">Crowbar</span><span class="token punctuation">.</span>check <span class="token punctuation">(</span>is_sorted l<span class="token punctuation">)</span></code></pre></div>
<p>All that's left to do now is to register our test:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span>
  <span class="token module variable">Crowbar</span><span class="token punctuation">.</span>add_test <span class="token label function">~name</span><span class="token punctuation">:</span><span class="token string">&quot;Awesome_list.sort&quot;</span> <span class="token punctuation">[</span>int_list<span class="token punctuation">]</span>
      <span class="token punctuation">(</span><span class="token keyword">fun</span> l <span class="token operator">-&gt;</span> is_sorted <span class="token punctuation">(</span><span class="token module variable">Awesome_list</span><span class="token punctuation">.</span>sort l<span class="token punctuation">)</span><span class="token punctuation">)</span></code></pre></div>
<p>and to compile that <code>fuzz_me.ml</code> file to a binary. Crowbar will take care of the magic.</p>
<p>We can run that binary in &quot;Quickcheck&quot; mode where it will either try a certain amount of random
inputs or keep trying until one of the properties breaks depending on the command-line options
we pass it.
What we're interested in here is its less common &quot;AFL&quot; mode. Crowbar made it so our executable
can be used with <code>afl-fuzz</code> just like that:</p>
<div class="gatsby-highlight" data-language="sh"><pre class="language-sh"><code class="language-sh">$ afl-fuzz -i inputs -o findings -- ./fuzz_me.exe @@</code></pre></div>
<p>What will happen then is that our <code>fuzz_me.exe</code> binary will read the inputs provided by <code>afl-fuzz</code>
and use it to determine which test to run and how to generate the arguments to pass to our function.
If the properties are satisfied, the binary will exit normally; if they aren't, it will make sure
that <code>afl-fuzz</code> interprets that as a crash by raising an exception.</p>
<p>A nice side-effect of Crowbar's approach is that <code>afl-fuzz</code> will still be able to pick up
crashes. For instance, if we implement <code>Awesome_list.sort</code> as:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> sort <span class="token operator">=</span> <span class="token keyword">function</span>
  <span class="token operator">|</span> <span class="token punctuation">[</span><span class="token number">1</span><span class="token punctuation">;</span> <span class="token number">2</span><span class="token punctuation">;</span> <span class="token number">3</span><span class="token punctuation">]</span> <span class="token operator">-&gt;</span> failwith <span class="token string">&quot;secret crash&quot;</span>
  <span class="token operator">|</span> <span class="token punctuation">[</span><span class="token number">4</span><span class="token punctuation">;</span> <span class="token number">5</span><span class="token punctuation">;</span> <span class="token number">6</span><span class="token punctuation">]</span> <span class="token operator">-&gt;</span> <span class="token punctuation">[</span><span class="token number">6</span><span class="token punctuation">;</span> <span class="token number">5</span><span class="token punctuation">;</span> <span class="token number">4</span><span class="token punctuation">]</span>
  <span class="token operator">|</span> l <span class="token operator">-&gt;</span> <span class="token module variable">List</span><span class="token punctuation">.</span>sort <span class="token module variable">Pervasives</span><span class="token punctuation">.</span>compare l</code></pre></div>
<p>and use AFL and Crowbar to fuzz-test our function, it will find two crashes: one for the input
<code>[1; 2; 3]</code> which triggers a crash and one for <code>[4; 5; 6]</code> for which the <code>is_sorted</code>
property won't hold.</p>
<p>The content of the input files found by <code>afl-fuzz</code> itself won't be of much help as it needs to be
interpreted by Crowbar to build the arguments that were passed to the function to trigger the bug.
We can invoke the <code>fuzz_me.exe</code> binary ourselves on one of the files in <code>findings/crashes</code>
and the Crowbar binary will replay the test and give us some more helpful information about what
exactly is going on:</p>
<div class="gatsby-highlight" data-language="sh"><pre class="language-sh"><code class="language-sh">$ ./fuzz_me.exe findings/crashes/id\:000000\,sig\:06\,src\:000011\,op\:flip1\,pos\:5 
Awesome_list.sort: ....
Awesome_list.sort: FAIL

When given the input:

    [1; 2; 3]
    
the test threw an exception:

    Failure(&quot;secret crash&quot;)
    Raised at file &quot;stdlib.ml&quot;, line 33, characters 17-33
    Called from file &quot;awesome-list/fuzz/fuzz_me.ml&quot;, line 11, characters 78-99
    Called from file &quot;src/crowbar.ml&quot;, line 264, characters 16-19
    
Fatal error: exception Crowbar.TestFailure
$ ./fuzz_me.exe findings/crashes/id\:000001\,sig\:06\,src\:000027\,op\:arith16\,pos\:5\,val\:+7 
Awesome_list.sort: ....
Awesome_list.sort: FAIL

When given the input:

    [4; 5; 6]
    
the test failed:

    check false
    
Fatal error: exception Crowbar.TestFailure</code></pre></div>
<p>We can see the actual inputs as well as distinguish the one that broke the invariant from the one
that triggered a crash.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#using-bun-to-run-fuzz-testing-in-ci" aria-label="using bun to run fuzz testing in ci permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Using <code>bun</code> to run fuzz testing in CI</h2>
<p>While AFL and Crowbar provide no guarantees they can give you confidence that your implementation
is not broken. Now that you know how to use them, a natural follow-up is to want to run fuzz tests
in your CI to enforce that level of confidence.</p>
<p>Problem is, AFL isn't very CI friendly. First it has this refreshing output that isn't going to look
great on your travis builds output and it doesn't tell you much besides that it could or couldn't find
crashes or invariant infrigements</p>
<p>Hopefully, like most problems, this one has a solution:
<a href="https://github.com/yomimono/ocaml-bun/"><code>bun</code></a>.
<code>bun</code> is a CLI wrapper around <code>afl-fuzz</code>, written in OCaml, that helps you get the best out of AFL
effortlessly. It mostly does two things:</p>
<p>The first is that it will run several <code>afl-fuzz</code> processes in parallel
(one per core by default). <code>afl-fuzz</code> starts with a bunch of deterministic steps. In my experience,
using parallel processes during this phase rarely proved very useful as they tend to find the same
bugs or slight variations of those bugs. It only achieves its full potential in the second phase of
fuzzing.</p>
<p>The second thing, which is the one we're the most interested in, is that <code>bun</code> provides a useful
and CI-friendly summary of what's going on with all the fuzzing processes so far. When one of them
finds a crash, it will stop all processes and pretty-print all of the bug-triggering inputs to help
you reproduce and debug them locally. See an example <code>bun</code> output after a crash was found:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">Crashes found! Take a look; copy/paste to save for reproduction:
1432	echo JXJpaWl0IA== | base64 -d &gt; crash_0.$(date -u +%s)
1433	echo NXJhkV8QAA== | base64 -d &gt; crash_1.$(date -u +%s)
1434	echo J3Jh//9qdGFiYmkg | base64 -d &gt; crash_2.$(date -u +%s)
1435	09:35.32:[ERROR]All fuzzers finished, but some crashes were found!</code></pre></div>
<p>Using <code>bun</code> is very similar to using <code>afl-fuzz</code>. Going back to our first parser example, we can
fuzz it with <code>bun</code> like this:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">$ bun --input inputs/ --output findings/ /path/to/parse.exe</code></pre></div>
<p>You'll note that you don't need to provide the <code>@@</code> anymore. <code>bun</code> assumes that it should pass the
input as the first argument of your to-be-fuzzed binary.</p>
<p><code>bun</code> also comes with an alternative <code>no-kill</code> mode which lets all the fuzzers run indefinitely
instead of terminating them whenever a crash is discovered. It will regularly keep you updated on
the number of crashes discovered so far and when terminated will pretty-print each of them just like
it does in regular mode.</p>
<p>This mode can be convenient if you suspect your implementation may contain a lot of bugs and
you don't want to go through the whole process of fuzz testing it to only find a single bug.</p>
<p>You can use it in CI by running <code>bun --no-kill</code> via <code>timeout</code>. For instance:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">timeout --preserve-status 60m bun --no-kill --input inputs --output findings ./fuzz_me.exe</code></pre></div>
<p>will fuzz <code>fuzz_me.exe</code> for an hour no matter what happens. When <code>timeout</code> terminates <code>bun</code>, it will
provide you with a handful of bugs to fix!</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#final-words" aria-label="final words permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Final words</h2>
<p>I really want to encourage you to use those tools and fuzzing in general.
Crowbar and <code>bun</code> are fairly new so you will probably encounter bugs or find that it lacks a feature
you want but combined with AFL they make for very nice tools to effectively test
critical components of your OCaml code base or infrastructure and detect newly-introduced bugs.
They are already used accross the MirageOS ecosystem where it has been used to fuzz the TCP/IP stack
<a href="https://github.com/mirage/mirage-tcpip">mirage-tcpip</a> and the DHCP implementation <a href="https://github.com/mirage/charrua">charrua</a> thanks to
<a href="https://github.com/yomimono/somerandompacket">somerandompacket</a>.
You can consult Crowbar's <a href="https://github.com/stedolan/crowbar/issues/2">hall of fame</a> to find out about bugs uncovered by this
approach.</p>
<p>I also encourage anyone interested to join us in using this promising toolchain, report those bugs,
contribute those extra features and help the community build more robust software.</p>
<p>Finally if you wish to learn more about how to efficienly use fuzzing for testing I recommend the
excellent <a href="https://blog.regehr.org/archives/1687">Write Fuzzable Code</a> article by John Regehr.</p>

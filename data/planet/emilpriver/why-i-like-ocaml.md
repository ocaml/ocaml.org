---
title: Why I Like Ocaml
description: I like OCaml and this is why
url: https://priver.dev/blog/ocaml/why-i-like-ocaml/
date: 2024-07-21T12:10:55-00:00
preview_image: https://priver.dev/images/ocaml/ocaml-cover.png
authors:
- "Emil Priv\xE9r"
source:
---

<p>According to my <a href="https://www.linkedin.com/in/emilpriver/">Linkedin</a> profile, I have been writing code for a company for almost 6 years. During this time, I have worked on PHP and Wordpress projects, built e-commerce websites using NextJS and JavaScript, written small backends in Python with Django/Flask/Fastapi, and developed fintech systems in GO, among other things. I have come to realize that I value a good type system and prefer writing code in a more functional way rather than using object-oriented programming. For example, in GO, I prefer passing in arguments rather than creating a <code>struct</code> method. This is why I will be discussing OCaml in this article.</p>
<p>If you are not familiar with the language OCaml or need a brief overview of it, I recommend reading my post <a href="https://priver.dev/blog/ocaml/ocaml-introduction/">OCaml introduction</a> before continuing with this post. It will help you better understand the topic I am discussing.</p>
<h2>Hindley-Milner type system and type inference</h2>
<p>Almost every time I ask someone what they like about OCaml, they often say &ldquo;oh, the type system is really nice&rdquo; or &ldquo;I really like the Hindley-Milner type system.&rdquo; When I ask new OCaml developers what they like about the language, they often say &ldquo;This type system is really nice, Typescript&rsquo;s type system is actually quite garbage.&rdquo; I am not surprised that these people say this, as I agree 100%. I really enjoy the Hindley-Milner type system and I think this is also the biggest reason why I write in this language. A good type system can make a huge difference for your developer experience.</p>
<p>For those who may not be familiar with the Hindley-Milner type system, it can be described as a system where you write a piece of program with strict types, but you are not required to explicitly state the types. Instead, the type is inferred based on how the variable is used.
Let&rsquo;s look at some code to demonstrate what I mean. In GO, you would be required to define the type of the arguments:</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt">1
</span><span class="lnt">2
</span><span class="lnt">3
</span><span class="lnt">4
</span><span class="lnt">5
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-go" data-lang="go"><span class="line"><span class="cl"><span class="kn">package</span> <span class="nx">main</span>
</span></span><span class="line"><span class="cl">
</span></span><span class="line"><span class="cl"><span class="kd">func</span> <span class="nf">Hello</span><span class="p">(</span><span class="nx">name</span> <span class="kt">string</span><span class="p">)</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">  <span class="nx">fmt</span><span class="p">.</span><span class="nf">Println</span><span class="p">(</span><span class="nx">name</span><span class="p">)</span>
</span></span><span class="line"><span class="cl"><span class="p">}</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p>However, in OCaml, you don&rsquo;t need to specify the type:</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt">1
</span><span class="lnt">2
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-OCaml" data-lang="OCaml"><span class="line"><span class="cl"><span class="k">let</span> <span class="n">hello</span> <span class="n">name</span> <span class="o">=</span> 
</span></span><span class="line"><span class="cl">  <span class="n">print_endline</span> <span class="n">name</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p>Since <code>print_endline</code> expects to receive a string, the signature for <code>hello</code> will be:</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt">1
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-OCaml" data-lang="OCaml"><span class="line"><span class="cl"><span class="k">val</span> <span class="n">hello</span> <span class="o">:</span> <span class="kt">string</span> <span class="o">-&gt;</span> <span class="kt">unit</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p>But it&rsquo;s not just for arguments, it&rsquo;s also used when returning a value.</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt">1
</span><span class="lnt">2
</span><span class="lnt">3
</span><span class="lnt">4
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-OCaml" data-lang="OCaml"><span class="line"><span class="cl"><span class="k">let</span> <span class="n">hello</span> <span class="n">name</span> <span class="o">=</span> 
</span></span><span class="line"><span class="cl">  <span class="k">match</span> <span class="n">name</span> <span class="k">with</span> 
</span></span><span class="line"><span class="cl">  <span class="o">|</span> <span class="nc">Some</span> <span class="k">value</span> <span class="o">-&gt;</span> <span class="s2">&quot;We had a value&quot;</span> 
</span></span><span class="line"><span class="cl">  <span class="o">|</span> <span class="nc">None</span> <span class="o">-&gt;</span> <span class="n">1</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p>This function will not compile because we are trying to return a string as the first value and later an integer.
I also want to provide a larger example of the Hindley-Milner type system:</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt"> 1
</span><span class="lnt"> 2
</span><span class="lnt"> 3
</span><span class="lnt"> 4
</span><span class="lnt"> 5
</span><span class="lnt"> 6
</span><span class="lnt"> 7
</span><span class="lnt"> 8
</span><span class="lnt"> 9
</span><span class="lnt">10
</span><span class="lnt">11
</span><span class="lnt">12
</span><span class="lnt">13
</span><span class="lnt">14
</span><span class="lnt">15
</span><span class="lnt">16
</span><span class="lnt">17
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-OCaml" data-lang="OCaml"><span class="line"><span class="cl"><span class="k">module</span> <span class="nc">Hello</span> <span class="o">=</span> <span class="k">struct</span>
</span></span><span class="line"><span class="cl">  <span class="k">type</span> <span class="n">car</span> <span class="o">=</span> <span class="o">{</span>
</span></span><span class="line"><span class="cl">    <span class="n">car</span><span class="o">:</span> <span class="kt">string</span><span class="o">;</span>
</span></span><span class="line"><span class="cl">    <span class="n">age</span><span class="o">:</span> <span class="kt">int</span><span class="o">;</span>
</span></span><span class="line"><span class="cl">  <span class="o">}</span>
</span></span><span class="line"><span class="cl">
</span></span><span class="line"><span class="cl">  <span class="k">let</span> <span class="n">make</span> <span class="n">car_name</span> <span class="n">age</span> <span class="o">=</span> <span class="o">{</span> <span class="n">car</span> <span class="o">=</span> <span class="n">car_name</span><span class="o">;</span> <span class="n">age</span> <span class="o">}</span>
</span></span><span class="line"><span class="cl">
</span></span><span class="line"><span class="cl">  <span class="k">let</span> <span class="n">print_car_name</span> <span class="n">car</span> <span class="o">=</span> <span class="n">print_endline</span> <span class="n">car</span><span class="o">.</span><span class="n">car</span>
</span></span><span class="line"><span class="cl">
</span></span><span class="line"><span class="cl">  <span class="k">let</span> <span class="n">print_car_age</span> <span class="n">car</span> <span class="o">=</span> <span class="n">print_int</span> <span class="n">car</span><span class="o">.</span><span class="n">age</span>
</span></span><span class="line"><span class="cl"><span class="k">end</span>
</span></span><span class="line"><span class="cl">
</span></span><span class="line"><span class="cl"><span class="k">let</span> <span class="bp">()</span> <span class="o">=</span>
</span></span><span class="line"><span class="cl">  <span class="k">let</span> <span class="n">car</span> <span class="o">=</span> <span class="nn">Hello</span><span class="p">.</span><span class="n">make</span> <span class="s2">&quot;Volvo&quot;</span> <span class="n">12</span> <span class="k">in</span>
</span></span><span class="line"><span class="cl">  <span class="nn">Hello</span><span class="p">.</span><span class="n">print_car_name</span> <span class="n">car</span><span class="o">;</span>
</span></span><span class="line"><span class="cl">  <span class="nn">Hello</span><span class="p">.</span><span class="n">print_car_age</span> <span class="n">car</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p>The signature for this piece of code will be:</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt">1
</span><span class="lnt">2
</span><span class="lnt">3
</span><span class="lnt">4
</span><span class="lnt">5
</span><span class="lnt">6
</span><span class="lnt">7
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-OCaml" data-lang="OCaml"><span class="line"><span class="cl"><span class="k">module</span> <span class="nc">Hello</span> <span class="o">:</span>
</span></span><span class="line"><span class="cl">  <span class="k">sig</span>
</span></span><span class="line"><span class="cl">    <span class="k">type</span> <span class="n">car</span> <span class="o">=</span> <span class="o">{</span> <span class="n">car</span> <span class="o">:</span> <span class="kt">string</span><span class="o">;</span> <span class="n">age</span> <span class="o">:</span> <span class="kt">int</span><span class="o">;</span> <span class="o">}</span>
</span></span><span class="line"><span class="cl">    <span class="k">val</span> <span class="n">make</span> <span class="o">:</span> <span class="kt">string</span> <span class="o">-&gt;</span> <span class="kt">int</span> <span class="o">-&gt;</span> <span class="n">car</span>
</span></span><span class="line"><span class="cl">    <span class="k">val</span> <span class="n">print_car_name</span> <span class="o">:</span> <span class="n">car</span> <span class="o">-&gt;</span> <span class="kt">unit</span>
</span></span><span class="line"><span class="cl">    <span class="k">val</span> <span class="n">print_car_age</span> <span class="o">:</span> <span class="n">car</span> <span class="o">-&gt;</span> <span class="kt">unit</span>
</span></span><span class="line"><span class="cl">  <span class="k">end</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p>In this example, we create a new module where we expose 3 functions: make, print_car_age, and print_car_name. We also define a type called <code>car</code>. One thing to note in the code is that the type is only defined once, as OCaml infers the type within the functions since <code>car</code> is a type within this scope.</p>
<p><a href="https://ocaml.org/play#code=bW9kdWxlIEhlbGxvID0gc3RydWN0CiAgdHlwZSBjYXIgPSB7CiAgICBjYXI6IHN0cmluZzsKICAgIGFnZTogaW50OwogIH0KCiAgbGV0IG1ha2UgY2FyX25hbWUgYWdlID0geyBjYXIgPSBjYXJfbmFtZTsgYWdlIH0KCiAgbGV0IHByaW50X2Nhcl9uYW1lIGNhciA9IHByaW50X2VuZGxpbmUgY2FyLmNhcgoKICBsZXQgcHJpbnRfY2FyX2FnZSBjYXIgPSBwcmludF9pbnQgY2FyLmFnZQplbmQKCmxldCAoKSA9CiAgbGV0IGNhciA9IEhlbGxvLm1ha2UgIlZvbHZvIiAxMiBpbgogIEhlbGxvLnByaW50X2Nhcl9uYW1lIGNhcjsKICBIZWxsby5wcmludF9jYXJfYWdlIGNhcg==">OCaml playground for this code</a>
Something important to note before concluding this section is that you can define both the argument types and return types for your function.</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt">1
</span><span class="lnt">2
</span><span class="lnt">3
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-OCaml" data-lang="OCaml"><span class="line"><span class="cl"><span class="k">let</span> <span class="n">hello</span> <span class="o">(</span><span class="n">name</span><span class="o">:</span> <span class="kt">string</span><span class="o">)</span> <span class="o">:</span> <span class="kt">int</span> <span class="o">=</span> 
</span></span><span class="line"><span class="cl">  <span class="n">print_endline</span> <span class="n">name</span><span class="o">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">1</span>
</span></span></code></pre></td></tr></table>
</div>
</div><h2>Pattern matching &amp; Variants</h2>
<p>The next topic is pattern matching. I really enjoy pattern matching in programming languages. I have written a lot of Rust, and pattern matching is something I use when I write Rust. Rich pattern matching is beneficial as it eliminates the need for many if statements. Additionally, in OCaml, you are required to handle every case of the match statement.</p>
<p>For example, in the code below:</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt">1
</span><span class="lnt">2
</span><span class="lnt">3
</span><span class="lnt">4
</span><span class="lnt">5
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-OCaml" data-lang="OCaml"><span class="line"><span class="cl"><span class="k">let</span> <span class="n">hello</span> <span class="n">name</span> <span class="o">=</span> 
</span></span><span class="line"><span class="cl">  <span class="k">match</span> <span class="n">name</span> <span class="k">with</span> 
</span></span><span class="line"><span class="cl">  <span class="o">|</span> <span class="s2">&quot;Emil&quot;</span> <span class="o">-&gt;</span> <span class="n">print_endline</span> <span class="s2">&quot;Hello Emil&quot;</span>
</span></span><span class="line"><span class="cl">  <span class="o">|</span> <span class="s2">&quot;Sabine the OCaml queen&quot;</span> <span class="o">-&gt;</span> <span class="n">print_endline</span> <span class="s2">&quot;Raise your swords soldiers, the queen has arrived&quot;</span>
</span></span><span class="line"><span class="cl">  <span class="o">|</span> <span class="k">value</span> <span class="o">-&gt;</span> <span class="nn">Printf</span><span class="p">.</span><span class="n">printf</span> <span class="s2">&quot;Hello stranger %s&quot;</span> <span class="k">value</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p>In the code above, I am required to include the last match case because we have not handled every case. For example, what should the compiler do if the <code>name</code> is Adam? The example above is very simple. We can also match on an integer and perform different actions based on the number value. For instance, we can determine if someone is allowed to enter the party using pattern matching.</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt">1
</span><span class="lnt">2
</span><span class="lnt">3
</span><span class="lnt">4
</span><span class="lnt">5
</span><span class="lnt">6
</span><span class="lnt">7
</span><span class="lnt">8
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-OCaml" data-lang="OCaml"><span class="line"><span class="cl"><span class="k">let</span> <span class="n">allowed_to_join</span> <span class="n">age</span> <span class="o">=</span>
</span></span><span class="line"><span class="cl">  <span class="k">match</span> <span class="n">age</span> <span class="k">with</span>
</span></span><span class="line"><span class="cl">  <span class="o">|</span> <span class="n">0</span> <span class="o">-&gt;</span> <span class="n">print_endline</span> <span class="s2">&quot;Can you even walk lol&quot;</span>
</span></span><span class="line"><span class="cl">  <span class="o">|</span> <span class="k">value</span> <span class="k">when</span> <span class="k">value</span> <span class="o">&gt;</span> <span class="n">18</span> <span class="o">-&gt;</span>
</span></span><span class="line"><span class="cl">    <span class="n">print_endline</span> <span class="s2">&quot;Welcome in my friend, the beer is on Sabine&quot;</span>
</span></span><span class="line"><span class="cl">  <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="n">print_endline</span> <span class="s2">&quot;Your not allowed, go home and play minecraft&quot;</span>
</span></span><span class="line"><span class="cl">
</span></span><span class="line"><span class="cl"><span class="k">let</span> <span class="bp">()</span> <span class="o">=</span> <span class="n">allowed_to_join</span> <span class="n">2</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p><a href="https://ocaml.org/play#code=bGV0IGFsbG93ZWRfdG9fam9pbiBhZ2UgPQogIG1hdGNoIGFnZSB3aXRoCiAgfCAwIC0%2BIHByaW50X2VuZGxpbmUgIkNhbiB5b3UgZXZlbiB3YWxrIGxvbCIKICB8IHZhbHVlIHdoZW4gdmFsdWUgPiAxOCAtPgogICAgcHJpbnRfZW5kbGluZSAiV2VsY29tZSBpbiBteSBmcmllbmQsIHRoZSBiZWVyIGlzIG9uIFNhYmluZSIKICB8IF8gLT4gcHJpbnRfZW5kbGluZSAiWW91ciBub3QgYWxsb3dlZCwgZ28gaG9tZSBhbmQgcGxheSBtaW5lY3JhZnQiCgpsZXQgKCkgPSBhbGxvd2VkX3RvX2pvaW4gMg==">OCaml playground</a></p>
<p>But the reason I mention variants in this section is that variants and pattern matching go quite nicely hand in hand. A variant is like an enumeration with more features, and I will show you what I mean. We can use them as a basic enumeration, which could look like this:</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt">1
</span><span class="lnt">2
</span><span class="lnt">3
</span><span class="lnt">4
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-OCaml" data-lang="OCaml"><span class="line"><span class="cl"><span class="k">type</span> <span class="n">person</span> <span class="o">=</span>
</span></span><span class="line"><span class="cl"> <span class="o">|</span> <span class="nc">Name</span>
</span></span><span class="line"><span class="cl"> <span class="o">|</span> <span class="nc">Age</span> 
</span></span><span class="line"><span class="cl"> <span class="o">|</span> <span class="nc">FavoriteProgrammingLanguage</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p>This now means that we can do different things depending on this type:</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt">1
</span><span class="lnt">2
</span><span class="lnt">3
</span><span class="lnt">4
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-OCaml" data-lang="OCaml"><span class="line"><span class="cl"><span class="k">match</span> <span class="n">person</span> <span class="k">with</span>
</span></span><span class="line"><span class="cl"> <span class="o">|</span> <span class="nc">Name</span> <span class="o">-&gt;</span> <span class="n">print_endline</span> <span class="s2">&quot;John&quot;</span>
</span></span><span class="line"><span class="cl"> <span class="o">|</span> <span class="nc">Age</span> <span class="o">-&gt;</span> <span class="n">print_endline</span> <span class="s2">&quot;30&quot;</span>
</span></span><span class="line"><span class="cl"> <span class="o">|</span> <span class="nc">FavoriteProgrammingLanguage</span> <span class="o">-&gt;</span> <span class="n">print_endline</span> <span class="s2">&quot;OCaml&quot;</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p>But I did mention that variants are similar to enumeration with additional features, allowing for the assignment of a type to the variant.</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt">1
</span><span class="lnt">2
</span><span class="lnt">3
</span><span class="lnt">4
</span><span class="lnt">5
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-OCaml" data-lang="OCaml"><span class="line"><span class="cl"><span class="k">type</span> <span class="n">person</span> <span class="o">=</span>
</span></span><span class="line"><span class="cl"> <span class="o">|</span> <span class="nc">Name</span> <span class="k">of</span> <span class="kt">string</span>
</span></span><span class="line"><span class="cl"> <span class="o">|</span> <span class="nc">Age</span> <span class="k">of</span> <span class="kt">int</span>
</span></span><span class="line"><span class="cl"> <span class="o">|</span> <span class="nc">FavoriteProgrammingLanguage</span> <span class="k">of</span> <span class="kt">string</span>
</span></span><span class="line"><span class="cl"> <span class="o">|</span> <span class="nc">HavePets</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p>Now that we have added types to our variants and included <code>HavePets</code>, we are able to adjust our pattern matching as follows:</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt">1
</span><span class="lnt">2
</span><span class="lnt">3
</span><span class="lnt">4
</span><span class="lnt">5
</span><span class="lnt">6
</span><span class="lnt">7
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-OCaml" data-lang="OCaml"><span class="line"><span class="cl"><span class="k">let</span> <span class="bp">()</span> <span class="o">=</span>
</span></span><span class="line"><span class="cl">  <span class="k">let</span> <span class="n">person</span> <span class="o">=</span> <span class="nc">Name</span> <span class="s2">&quot;Emil&quot;</span> <span class="k">in</span>
</span></span><span class="line"><span class="cl">  <span class="k">match</span> <span class="n">person</span> <span class="k">with</span>
</span></span><span class="line"><span class="cl">   <span class="o">|</span> <span class="nc">Name</span> <span class="n">name</span> <span class="o">-&gt;</span> <span class="nn">Printf</span><span class="p">.</span><span class="n">printf</span> <span class="s2">&quot;Name: %s</span><span class="se">\n</span><span class="s2">&quot;</span> <span class="n">name</span>
</span></span><span class="line"><span class="cl">   <span class="o">|</span> <span class="nc">Age</span> <span class="n">age</span> <span class="o">-&gt;</span> <span class="nn">Printf</span><span class="p">.</span><span class="n">printf</span> <span class="s2">&quot;Age: %d</span><span class="se">\n</span><span class="s2">&quot;</span> <span class="n">age</span>
</span></span><span class="line"><span class="cl">   <span class="o">|</span> <span class="nc">FavoriteProgrammingLanguage</span> <span class="n">language</span> <span class="o">-&gt;</span> <span class="nn">Printf</span><span class="p">.</span><span class="n">printf</span> <span class="s2">&quot;Favorite Programming Language: %s</span><span class="se">\n</span><span class="s2">&quot;</span> <span class="n">language</span>
</span></span><span class="line"><span class="cl">   <span class="o">|</span> <span class="nc">HavePets</span> <span class="o">-&gt;</span> <span class="nn">Printf</span><span class="p">.</span><span class="n">printf</span> <span class="s2">&quot;Has pets</span><span class="se">\n</span><span class="s2">&quot;</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p><a href="https://ocaml.org/play#code=CnR5cGUgcGVyc29uID0KIHwgTmFtZSBvZiBzdHJpbmcKIHwgQWdlIG9mIGludAogfCBGYXZvcml0ZVByb2dyYW1taW5nTGFuZ3VhZ2Ugb2Ygc3RyaW5nCiB8IEhhdmVQZXRzCgpsZXQgKCkgPQogIGxldCBwZXJzb24gPSBOYW1lICJFbWlsIiBpbgogIG1hdGNoIHBlcnNvbiB3aXRoCiAgIHwgTmFtZSBuYW1lIC0%2BIFByaW50Zi5wcmludGYgIk5hbWU6ICVzXG4iIG5hbWUKICAgfCBBZ2UgYWdlIC0%2BIFByaW50Zi5wcmludGYgIkFnZTogJWRcbiIgYWdlCiAgIHwgRmF2b3JpdGVQcm9ncmFtbWluZ0xhbmd1YWdlIGxhbmd1YWdlIC0%2BIFByaW50Zi5wcmludGYgIkZhdm9yaXRlIFByb2dyYW1taW5nIExhbmd1YWdlOiAlc1xuIiBsYW5ndWFnZQogICB8IEhhdmVQZXRzIC0%2BIFByaW50Zi5wcmludGYgIkhhcyBwZXRzXG4iCg==">OCaml Playground</a></p>
<p>We can now assign a value to the variant and use it in pattern matching to print different values. As you can see, I am not forced to add a value to every variant. For instance, I do not need a type on <code>HavePets</code> so I simply don&rsquo;t add it.
I often use variants, such as in <a href="https://priver.dev/blog/dbcaml/dbcaml-project/">DBCaml</a>  where I use variants to retrieve responses from a database. For example, I return <code>NoRows</code> if I did not receive any rows back, but no error.</p>
<p>OCaml also comes with Exhaustiveness Checking, meaning that if we don&rsquo;t check each case in a pattern matching, we will get an error. For instance, if we forget to add <code>HavePets</code> to the pattern matching, OCaml will throw an error at compile time.</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt">1
</span><span class="lnt">2
</span><span class="lnt">3
</span><span class="lnt">4
</span><span class="lnt">5
</span><span class="lnt">6
</span><span class="lnt">7
</span><span class="lnt">8
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-bash" data-lang="bash"><span class="line"><span class="cl">File <span class="s2">&quot;bin/main.ml&quot;</span>, lines 9-12, characters 2-105:
</span></span><span class="line"><span class="cl"> <span class="m">9</span> <span class="p">|</span> ..match person with
</span></span><span class="line"><span class="cl"><span class="m">10</span> <span class="p">|</span>    <span class="p">|</span> Name name -&gt; Printf.printf <span class="s2">&quot;Name: %s\n&quot;</span> name
</span></span><span class="line"><span class="cl"><span class="m">11</span> <span class="p">|</span>    <span class="p">|</span> Age age -&gt; Printf.printf <span class="s2">&quot;Age: %d\n&quot;</span> age
</span></span><span class="line"><span class="cl"><span class="m">12</span> <span class="p">|</span>    <span class="p">|</span> FavoriteProgrammingLanguage language -&gt; Printf.printf <span class="s2">&quot;Favorite Programming Language: %s\n&quot;</span> language
</span></span><span class="line"><span class="cl">Error <span class="o">(</span>warning <span class="m">8</span> <span class="o">[</span>partial-match<span class="o">])</span>: this pattern-matching is not exhaustive.
</span></span><span class="line"><span class="cl">Here is an example of a <span class="k">case</span> that is not matched:
</span></span><span class="line"><span class="cl">HavePets
</span></span></code></pre></td></tr></table>
</div>
</div><h2>Binding operators</h2>
<p>The next topic is operators and specific binding operators. OCaml has more types of operators, but binding operators are something I use in every project.
A binding could be described as something that extends how <code>let</code> works in OCaml by adding extra logic before storing the value in memory with <code>let</code>.
I&rsquo;ll show you:</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt">1
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-ocaml" data-lang="ocaml"><span class="line"><span class="cl"><span class="k">let</span> <span class="n">hello</span> <span class="o">=</span> <span class="s2">&quot;Emil&quot;</span> <span class="k">in</span> 
</span></span></code></pre></td></tr></table>
</div>
</div><p>This code simply takes the value &ldquo;Emil&rdquo; and stores it in memory, then assigns the memory reference to the variable hello. However, we can extend this functionality with a binding operator. For instance, if we don&rsquo;t want to use a lot of match statements on the return value of a function, we can bind <code>let</code> so it checks the value and if the value is an error, it bubbles up the error.</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt"> 1
</span><span class="lnt"> 2
</span><span class="lnt"> 3
</span><span class="lnt"> 4
</span><span class="lnt"> 5
</span><span class="lnt"> 6
</span><span class="lnt"> 7
</span><span class="lnt"> 8
</span><span class="lnt"> 9
</span><span class="lnt">10
</span><span class="lnt">11
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-ocaml" data-lang="ocaml"><span class="line"><span class="cl"><span class="k">let</span> <span class="o">(</span> <span class="k">let</span><span class="o">*</span> <span class="o">)</span> <span class="n">r</span> <span class="n">f</span> <span class="o">=</span> <span class="k">match</span> <span class="n">r</span> <span class="k">with</span> <span class="nc">Ok</span> <span class="n">v</span> <span class="o">-&gt;</span> <span class="n">f</span> <span class="n">v</span> <span class="o">|</span> <span class="nc">Error</span> <span class="o">_</span> <span class="k">as</span> <span class="n">e</span> <span class="o">-&gt;</span> <span class="n">e</span>
</span></span><span class="line"><span class="cl">
</span></span><span class="line"><span class="cl"><span class="k">let</span> <span class="n">check_result</span> <span class="o">=</span>
</span></span><span class="line"><span class="cl">  <span class="k">let</span><span class="o">*</span> <span class="n">hello</span> <span class="o">=</span> <span class="nc">Ok</span> <span class="s2">&quot;Emil&quot;</span> <span class="k">in</span>
</span></span><span class="line"><span class="cl">  <span class="k">let</span><span class="o">*</span> <span class="n">second_name</span> <span class="o">=</span> <span class="nc">Ok</span> <span class="s2">&quot;Priver&quot;</span> <span class="k">in</span>
</span></span><span class="line"><span class="cl">  <span class="nc">Ok</span> <span class="o">(</span><span class="n">hello</span> <span class="o">^</span> <span class="n">second_name</span><span class="o">)</span>
</span></span><span class="line"><span class="cl">
</span></span><span class="line"><span class="cl"><span class="k">let</span> <span class="bp">()</span> <span class="o">=</span>
</span></span><span class="line"><span class="cl">  <span class="k">match</span> <span class="n">check_result</span> <span class="k">with</span>
</span></span><span class="line"><span class="cl">  <span class="o">|</span> <span class="nc">Ok</span> <span class="n">name</span> <span class="o">-&gt;</span> <span class="n">print_endline</span> <span class="n">name</span>
</span></span><span class="line"><span class="cl">  <span class="o">|</span> <span class="nc">Error</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="n">print_endline</span> <span class="s2">&quot;no name&quot;</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p>This allows me to reduce the amount of code I write while maintaining the same functionality.</p>
<h2>It&rsquo;s functional on easy mode</h2>
<p>I really like the concept of functional programming, such as immutability and avoiding side-effects as much as possible. However, I believe that a purely functional programming language could force us to write code in a way that becomes too complex. This is where I think OCaml does a good job. OCaml is clearly designed to be a functional language, but it allows for updating existing values rather than always returning new values.</p>
<blockquote>
<p>Immutability means that you cannot change an already existing value and must create a new value instead. I have written about the <a href="https://priver.dev/blog/functional-programming/concepts-of-functional-programming/">Concepts of Functional Programming</a> and recommend reading it if you want to learn more.</p>
</blockquote>
<p>One example where functional programming might make the code more complex is when creating a reader to read some bytes. If we strictly follow the rule of immutability, we would need to return new bytes instead of updating existing ones. This could lead to inefficiencies in terms of memory usage.</p>
<p>Just to give an example of how to mutate an existing value in OCaml, I have created an example. In the code below, I am updating the age by 1 as it is the user&rsquo;s birthday:</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt"> 1
</span><span class="lnt"> 2
</span><span class="lnt"> 3
</span><span class="lnt"> 4
</span><span class="lnt"> 5
</span><span class="lnt"> 6
</span><span class="lnt"> 7
</span><span class="lnt"> 8
</span><span class="lnt"> 9
</span><span class="lnt">10
</span><span class="lnt">11
</span><span class="lnt">12
</span><span class="lnt">13
</span><span class="lnt">14
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-ocaml" data-lang="ocaml"><span class="line"><span class="cl"><span class="k">type</span> <span class="n">user</span> <span class="o">=</span> <span class="o">{</span> <span class="k">mutable</span> <span class="n">age</span> <span class="o">:</span> <span class="kt">int</span><span class="o">;</span> <span class="n">name</span> <span class="o">:</span> <span class="kt">string</span> <span class="o">}</span>
</span></span><span class="line"><span class="cl">
</span></span><span class="line"><span class="cl"><span class="k">let</span> <span class="n">make_user</span> <span class="n">name</span> <span class="n">age</span> <span class="o">=</span> <span class="o">{</span> <span class="n">age</span><span class="o">;</span> <span class="n">name</span> <span class="o">}</span>
</span></span><span class="line"><span class="cl"><span class="k">let</span> <span class="n">increase_age</span> <span class="n">user</span> <span class="o">=</span> <span class="n">user</span><span class="o">.</span><span class="n">age</span> <span class="o">&lt;-</span> <span class="n">user</span><span class="o">.</span><span class="n">age</span> <span class="o">+</span> <span class="n">1</span>
</span></span><span class="line"><span class="cl">
</span></span><span class="line"><span class="cl"><span class="k">let</span> <span class="bp">()</span> <span class="o">=</span>
</span></span><span class="line"><span class="cl">  <span class="k">let</span> <span class="n">user</span> <span class="o">=</span> <span class="n">make_user</span> <span class="s2">&quot;Emil&quot;</span> <span class="n">25</span> <span class="k">in</span>
</span></span><span class="line"><span class="cl">  <span class="nn">Printf</span><span class="p">.</span><span class="n">printf</span> <span class="s2">&quot;It's %s's birthday today! Congratz!!!!&quot;</span> <span class="n">user</span><span class="o">.</span><span class="n">name</span><span class="o">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">print_newline</span> <span class="bp">()</span><span class="o">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">print_int</span> <span class="n">user</span><span class="o">.</span><span class="n">age</span><span class="o">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">print_newline</span> <span class="bp">()</span><span class="o">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">increase_age</span> <span class="n">user</span><span class="o">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">print_int</span> <span class="n">user</span><span class="o">.</span><span class="n">age</span><span class="o">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">print_newline</span> <span class="bp">()</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p>What I mean by &ldquo;it&rsquo;s functional on easy mode&rdquo; is simply that the language is designed to be a functional language, but you are not forced to strictly adhere to functional programming rules.</p>
<h2>The end</h2>
<p>It is clear to me that a good type system can greatly improve the developer experience. I particularly appreciate OCaml&rsquo;s type system, as well as its <code>option</code> and <code>result</code> types, which I use frequently. In languages like Haskell, you can extend the type system significantly, to the point where you can write an entire application using only types. However, I believe that this can lead to overly complex code. This is another aspect of OCaml that I appreciate - it has a strong type system, but there are limitations on how far you can extend it.</p>
<p>I hope you enjoyed this article. If you are interested in joining a community of people who also enjoy functional programming, I recommend joining this <a href="https://discord.gg/M5PBxbnta3">Discord server.</a></p>


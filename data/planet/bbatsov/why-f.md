---
title: Why F#?
description: "If someone had told me a few months ago I\u2019d be playing with .NET
  again after a 15+ years hiatus I probably would have laughed at this.1 Early on
  in my career I played with .NET and Java, and even though .NET had done some things
  better than Java (as it had the opportunity to learn from some early Java mistakes),
  I quickly settled on Java as it was a truly portable environment.                 I
  had some C# courses in the university and I wrote my bachelor\u2019s thesis in C#.
  It was a rewrite of Arch Linux\u2019s pacman, running on Mono. This was way back
  in 2007.\_\u21A9"
url: https://batsov.com/articles/2025/03/30/why-fsharp/
date: 2025-03-30T14:54:00-00:00
preview_image: https://batsov.com/assets/images/bozhidar_avatar.jpg
authors:
- Bozhidar Batsov
source:
---

<p>If someone had told me a few months ago I’d be playing with .NET again after a
15+ years hiatus I probably would have laughed at this.<sup role="doc-noteref"><a href="https://batsov.com/feeds/OCaml.xml#fn:1" class="footnote" rel="footnote">1</a></sup> Early on in my
career I played with .NET and Java, and even though .NET had done some things
better than Java (as it had the opportunity to learn from some early Java
mistakes), I quickly settled on Java as it was a truly portable environment.</p>

<p>I guess everyone who reads my blog knows that in the past few years I’ve been
playing on and off with OCaml and I think it’s safe to say that it has become
one of my favorite programming languages - alongside the likes of Ruby and
Clojure. My work with OCaml drew my attention recently to F#, an ML targeting
.NET, developed by Microsoft. The functional counterpart of the
(mostly) object-oriented C#. The newest ML language created…</p>

<p>F# 1.0 was officially released in May 2005 by Microsoft Research. It was
initially developed by Don Syme at Microsoft Research in Cambridge and evolved
from an earlier research project called “Caml.NET,” which aimed to bring OCaml
to the .NET platform.<sup role="doc-noteref"><a href="https://batsov.com/feeds/OCaml.xml#fn:2" class="footnote" rel="footnote">2</a></sup> F# was officially moved from Microsoft Research to
Microsoft (as part of their developer tooling division) in 2010 (timed
with the release of F# 2.0).</p>

<p>F# has been steadily evolving since those early days and the most recent release
<a href="https://learn.microsoft.com/en-us/dotnet/fsharp/whats-new/fsharp-9">F# 9.0</a> was
released in November 2024.  It seems only appropriate that F# would come to my
attention in the year of its 20th birthday!</p>

<p>There were several reasons why I wanted to try out F#:</p>

<ul>
  <li>.NET became open-source and portable a few years ago and I wanted to check the progress on that front</li>
  <li>I was curious if F# offers any advantages over OCaml</li>
  <li>I’ve heard good things about the F# tooling (e.g. Rider and Ionide)</li>
  <li>I like playing with new programming languages</li>
</ul>

<p>Below you’ll find my initial impressions for several areas.</p>

<h2>The Language</h2>

<p>As a member of the ML family of languages, the syntax won’t surprise
anyone familiar with OCaml. As there are quite few people familiar with
OCaml, though, I’ll mention that Haskell programmers will also feel right at
home with the syntax. And Lispers.</p>

<p>For everyone else - it’d be fairly easy to pick up the basics.</p>

<div class="language-fsharp highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">printfn</span> <span class="s2">"Hello, World!"</span>

<span class="k">let</span> <span class="n">greet</span> <span class="n">name</span> <span class="p">=</span>
    <span class="n">printfn</span> <span class="s2">"Hello, %s!"</span> <span class="n">name</span>

<span class="n">greet</span> <span class="s2">"World"</span>

<span class="k">type</span> <span class="nc">Shape</span> <span class="p">=</span>
    <span class="p">|</span> <span class="nc">Circle</span> <span class="k">of</span> <span class="n">radius</span><span class="p">:</span> <span class="kt">float</span>
    <span class="p">|</span> <span class="nc">Rectangle</span> <span class="k">of</span> <span class="n">width</span><span class="p">:</span> <span class="kt">float</span> <span class="p">*</span> <span class="n">height</span><span class="p">:</span> <span class="kt">float</span>

<span class="k">let</span> <span class="n">area</span> <span class="n">shape</span> <span class="p">=</span>
    <span class="k">match</span> <span class="n">shape</span> <span class="k">with</span>
    <span class="p">|</span> <span class="nc">Circle</span> <span class="n">radius</span> <span class="p">-&gt;</span> <span class="nn">System</span><span class="p">.</span><span class="nn">Math</span><span class="p">.</span><span class="nc">PI</span> <span class="p">*</span> <span class="n">radius</span> <span class="p">*</span> <span class="n">radius</span>
    <span class="p">|</span> <span class="nc">Rectangle</span> <span class="p">(</span><span class="n">width</span><span class="p">,</span> <span class="n">height</span><span class="p">)</span> <span class="p">-&gt;</span> <span class="n">width</span> <span class="p">*</span> <span class="n">height</span>

<span class="k">let</span> <span class="n">circle</span> <span class="p">=</span> <span class="nc">Circle</span> <span class="mi">5</span><span class="p">.</span><span class="mi">0</span>
<span class="k">let</span> <span class="n">rectangle</span> <span class="p">=</span> <span class="nc">Rectangle</span><span class="p">(</span><span class="mi">4</span><span class="p">.</span><span class="mi">0</span><span class="p">,</span> <span class="mi">3</span><span class="p">.</span><span class="mi">0</span><span class="p">)</span>

<span class="n">printfn</span> <span class="s2">"Circle area: %f"</span> <span class="p">(</span><span class="n">area</span> <span class="n">circle</span><span class="p">)</span>
<span class="n">printfn</span> <span class="s2">"Rectangle area: %f"</span> <span class="p">(</span><span class="n">area</span> <span class="n">rectangle</span><span class="p">)</span>
</code></pre></div></div>

<p>Nothing shocking here, right?</p>

<p>Here’s another slightly more involved example:</p>

<div class="language-fsharp highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">open</span> <span class="nc">System</span>

<span class="c1">// Sample data - simple sales records</span>
<span class="k">type</span> <span class="nc">SalesRecord</span> <span class="p">=</span> <span class="p">{</span> <span class="nc">Date</span><span class="p">:</span> <span class="nc">DateTime</span><span class="p">;</span> <span class="nc">Product</span><span class="p">:</span> <span class="kt">string</span><span class="p">;</span> <span class="nc">Amount</span><span class="p">:</span> <span class="n">decimal</span><span class="p">;</span> <span class="nc">Region</span><span class="p">:</span> <span class="kt">string</span> <span class="p">}</span>

<span class="c1">// Sample dataset</span>
<span class="k">let</span> <span class="n">sales</span> <span class="p">=</span> <span class="p">[</span>
    <span class="p">{</span> <span class="nc">Date</span> <span class="p">=</span> <span class="nc">DateTime</span><span class="p">(</span><span class="mi">2023</span><span class="p">,</span> <span class="mi">1</span><span class="p">,</span> <span class="mi">15</span><span class="o">);</span> <span class="nc">Product</span> <span class="p">=</span> <span class="s2">"Laptop"</span><span class="p">;</span> <span class="nc">Amount</span> <span class="p">=</span> <span class="mi">1200</span><span class="n">m</span><span class="p">;</span> <span class="nc">Region</span> <span class="p">=</span> <span class="s2">"North"</span> <span class="p">}</span>
    <span class="p">{</span> <span class="nc">Date</span> <span class="p">=</span> <span class="nc">DateTime</span><span class="p">(</span><span class="mi">2023</span><span class="p">,</span> <span class="mi">2</span><span class="p">,</span> <span class="mi">3</span><span class="o">);</span>  <span class="nc">Product</span> <span class="p">=</span> <span class="s2">"Phone"</span><span class="p">;</span>  <span class="nc">Amount</span> <span class="p">=</span> <span class="mi">800</span><span class="n">m</span><span class="p">;</span>  <span class="nc">Region</span> <span class="p">=</span> <span class="s2">"South"</span> <span class="p">}</span>
    <span class="p">{</span> <span class="nc">Date</span> <span class="p">=</span> <span class="nc">DateTime</span><span class="p">(</span><span class="mi">2023</span><span class="p">,</span> <span class="mi">1</span><span class="p">,</span> <span class="mi">20</span><span class="o">);</span> <span class="nc">Product</span> <span class="p">=</span> <span class="s2">"Tablet"</span><span class="p">;</span> <span class="nc">Amount</span> <span class="p">=</span> <span class="mi">400</span><span class="n">m</span><span class="p">;</span>  <span class="nc">Region</span> <span class="p">=</span> <span class="s2">"North"</span> <span class="p">}</span>
    <span class="p">{</span> <span class="nc">Date</span> <span class="p">=</span> <span class="nc">DateTime</span><span class="p">(</span><span class="mi">2023</span><span class="p">,</span> <span class="mi">2</span><span class="p">,</span> <span class="mi">18</span><span class="o">);</span> <span class="nc">Product</span> <span class="p">=</span> <span class="s2">"Laptop"</span><span class="p">;</span> <span class="nc">Amount</span> <span class="p">=</span> <span class="mi">1250</span><span class="n">m</span><span class="p">;</span> <span class="nc">Region</span> <span class="p">=</span> <span class="s2">"East"</span> <span class="p">}</span>
    <span class="p">{</span> <span class="nc">Date</span> <span class="p">=</span> <span class="nc">DateTime</span><span class="p">(</span><span class="mi">2023</span><span class="p">,</span> <span class="mi">1</span><span class="p">,</span> <span class="mi">5</span><span class="o">);</span>  <span class="nc">Product</span> <span class="p">=</span> <span class="s2">"Phone"</span><span class="p">;</span>  <span class="nc">Amount</span> <span class="p">=</span> <span class="mi">750</span><span class="n">m</span><span class="p">;</span>  <span class="nc">Region</span> <span class="p">=</span> <span class="s2">"West"</span> <span class="p">}</span>
    <span class="p">{</span> <span class="nc">Date</span> <span class="p">=</span> <span class="nc">DateTime</span><span class="p">(</span><span class="mi">2023</span><span class="p">,</span> <span class="mi">2</span><span class="p">,</span> <span class="mi">12</span><span class="o">);</span> <span class="nc">Product</span> <span class="p">=</span> <span class="s2">"Tablet"</span><span class="p">;</span> <span class="nc">Amount</span> <span class="p">=</span> <span class="mi">450</span><span class="n">m</span><span class="p">;</span>  <span class="nc">Region</span> <span class="p">=</span> <span class="s2">"North"</span> <span class="p">}</span>
    <span class="p">{</span> <span class="nc">Date</span> <span class="p">=</span> <span class="nc">DateTime</span><span class="p">(</span><span class="mi">2023</span><span class="p">,</span> <span class="mi">1</span><span class="p">,</span> <span class="mi">28</span><span class="o">);</span> <span class="nc">Product</span> <span class="p">=</span> <span class="s2">"Laptop"</span><span class="p">;</span> <span class="nc">Amount</span> <span class="p">=</span> <span class="mi">1150</span><span class="n">m</span><span class="p">;</span> <span class="nc">Region</span> <span class="p">=</span> <span class="s2">"South"</span> <span class="p">}</span>
<span class="p">]</span>

<span class="c1">// Quick analysis pipeline</span>
<span class="k">let</span> <span class="n">salesSummary</span> <span class="p">=</span>
    <span class="n">sales</span>
    <span class="p">|&gt;</span> <span class="nn">List</span><span class="p">.</span><span class="n">groupBy</span> <span class="p">(</span><span class="k">fun</span> <span class="n">s</span> <span class="p">-&gt;</span> <span class="n">s</span><span class="p">.</span><span class="nc">Product</span><span class="p">)</span>                          <span class="c1">// Group by product</span>
    <span class="p">|&gt;</span> <span class="nn">List</span><span class="p">.</span><span class="n">map</span> <span class="p">(</span><span class="k">fun</span> <span class="p">(</span><span class="n">product</span><span class="p">,</span> <span class="n">items</span><span class="p">)</span> <span class="p">-&gt;</span>                          <span class="c1">// Transform each group</span>
        <span class="k">let</span> <span class="n">totalSales</span> <span class="p">=</span> <span class="n">items</span> <span class="p">|&gt;</span> <span class="nn">List</span><span class="p">.</span><span class="n">sumBy</span> <span class="p">(</span><span class="k">fun</span> <span class="n">s</span> <span class="p">-&gt;</span> <span class="n">s</span><span class="p">.</span><span class="nc">Amount</span><span class="p">)</span>
        <span class="k">let</span> <span class="n">avgSale</span> <span class="p">=</span> <span class="n">totalSales</span> <span class="o">/</span> <span class="n">decimal</span> <span class="p">(</span><span class="nn">List</span><span class="p">.</span><span class="n">length</span> <span class="n">items</span><span class="p">)</span>
        <span class="k">let</span> <span class="n">topRegion</span> <span class="p">=</span>
            <span class="n">items</span>
            <span class="p">|&gt;</span> <span class="nn">List</span><span class="p">.</span><span class="n">groupBy</span> <span class="p">(</span><span class="k">fun</span> <span class="n">s</span> <span class="p">-&gt;</span> <span class="n">s</span><span class="p">.</span><span class="nc">Region</span><span class="p">)</span>                   <span class="c1">// Nested grouping</span>
            <span class="p">|&gt;</span> <span class="nn">List</span><span class="p">.</span><span class="n">maxBy</span> <span class="p">(</span><span class="k">fun</span> <span class="o">(_,</span> <span class="n">regionItems</span><span class="p">)</span> <span class="p">-&gt;</span>
                <span class="n">regionItems</span> <span class="p">|&gt;</span> <span class="nn">List</span><span class="p">.</span><span class="n">sumBy</span> <span class="p">(</span><span class="k">fun</span> <span class="n">s</span> <span class="p">-&gt;</span> <span class="n">s</span><span class="p">.</span><span class="nc">Amount</span><span class="o">))</span>
            <span class="p">|&gt;</span> <span class="n">fst</span>

        <span class="p">(</span><span class="n">product</span><span class="p">,</span> <span class="n">totalSales</span><span class="p">,</span> <span class="n">avgSale</span><span class="p">,</span> <span class="n">topRegion</span><span class="o">))</span>
    <span class="p">|&gt;</span> <span class="nn">List</span><span class="p">.</span><span class="n">sortByDescending</span> <span class="p">(</span><span class="k">fun</span> <span class="o">(_,</span> <span class="n">total</span><span class="p">,</span> <span class="o">_,</span> <span class="o">_)</span> <span class="p">-&gt;</span> <span class="n">total</span><span class="p">)</span>      <span class="c1">// Sort by total sales</span>

<span class="c1">// Display results</span>
<span class="n">salesSummary</span>
<span class="p">|&gt;</span> <span class="nn">List</span><span class="p">.</span><span class="n">iter</span> <span class="p">(</span><span class="k">fun</span> <span class="p">(</span><span class="n">product</span><span class="p">,</span> <span class="n">total</span><span class="p">,</span> <span class="n">avg</span><span class="p">,</span> <span class="n">region</span><span class="p">)</span> <span class="p">-&gt;</span>
    <span class="n">printfn</span> <span class="s2">"%s: $%M total, $%M avg, top region: %s"</span>
        <span class="n">product</span> <span class="n">total</span> <span class="n">avg</span> <span class="n">region</span><span class="p">)</span>
</code></pre></div></div>

<p>Why don’t you try saving the snippet above in a file called <code class="language-plaintext highlighter-rouge">Sales.fsx</code> and running it like this:</p>

<div class="language-shell highlighter-rouge"><div class="highlight"><pre class="highlight"><code>dotnet fsi Sales.fsx
</code></pre></div></div>

<p>Now you know that F# is a great choice for ad-hoc scripts! Also, running <code class="language-plaintext highlighter-rouge">dotnet fsi</code> by itself
will pop an F# REPL where you can explore the language at your leisure.</p>

<p>I’m not going to go into great details here, as much of what I wrote about OCaml
<a href="https://batsov.com/articles/2022/08/29/ocaml-at-first-glance/">here</a> applies to F# as well.
I’d also suggest this quick <a href="https://learn.microsoft.com/en-us/dotnet/fsharp/tour">tour of F#</a>
to get a better feel for its syntax.</p>

<p>One thing that made a good impression to me is the focus of the language designers on
making F# approachable to newcomers, by providing a lot of small quality of life improvements
for them. Below are few examples, that probably don’t mean much to you, but would mean something
to people familiar with OCaml:</p>

<div class="language-fsharp highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c1">// line comments</span>
<span class="c">(* the classic ML comments are around as well *)</span>

<span class="c1">// mutable values</span>
<span class="k">let</span> <span class="k">mutable</span> <span class="n">x</span> <span class="p">=</span> <span class="mi">5</span>
<span class="n">x</span> <span class="p">&lt;-</span> <span class="mi">6</span>

<span class="c1">// ranges and slices</span>
<span class="k">let</span> <span class="n">l</span> <span class="p">=</span> <span class="p">[</span><span class="mi">1</span><span class="p">..</span><span class="mi">2</span><span class="p">..</span><span class="mi">10</span><span class="p">]</span>
<span class="n">name</span><span class="p">[</span><span class="mi">5</span><span class="o">..]</span>

<span class="c1">// C# method calls look pretty natural</span>
<span class="k">let</span> <span class="n">name</span> <span class="p">=</span> <span class="s2">"FOO"</span><span class="p">.</span><span class="nc">ToLower</span><span class="bp">()</span>

<span class="c1">// operators can be overloaded for different types</span>
<span class="k">let</span> <span class="n">string1</span> <span class="p">=</span> <span class="s2">"Hello, "</span> <span class="o">+</span> <span class="s2">"world"</span>
<span class="k">let</span> <span class="n">num1</span> <span class="p">=</span> <span class="mi">1</span> <span class="o">+</span> <span class="mi">2</span>
<span class="k">let</span> <span class="n">num2</span> <span class="p">=</span> <span class="mi">1</span><span class="p">.</span><span class="mi">0</span> <span class="o">+</span> <span class="mi">2</span><span class="p">.</span><span class="mi">5</span>

<span class="c1">// universal printing</span>
<span class="n">printfn</span> <span class="s2">"%A"</span> <span class="p">[</span><span class="mi">1</span><span class="p">..</span><span class="mi">2</span><span class="p">..</span><span class="mi">100</span><span class="p">]</span>
</code></pre></div></div>

<p>I guess some of those might be controversial, depending on whether you’re a language purist or not,
but in my book anything that makes MLs more popular is a good thing.</p>

<p>Did I also mention it’s easy to work with unicode strings and regular expressions?</p>

<p>Often people say that F# is mostly a staging ground for future C# features, and perhaps that’s true.
I haven’t observed both languages long enough to have my own opinion on the subject, but I was impressed
to learn that <code class="language-plaintext highlighter-rouge">async/await</code> (of C# and later JavaScript fame) originated in… F# 2.0.</p>

<blockquote>
  <p>It all changed in 2012 when C#5 launched with the introduction of what has now
become the popularized <code class="language-plaintext highlighter-rouge">async/await</code> keyword pairing. This feature allowed you to
write code with all the benefits of hand-written asynchronous code, such as not
blocking the UI when a long-running process started, yet read like normal
synchronous code. This <code class="language-plaintext highlighter-rouge">async/await</code> pattern has now found its way into many
modern programming languages such as Python, JS, Swift, Rust, and even C++.</p>

  <p>F#’s approach to asynchronous programming is a little different from <code class="language-plaintext highlighter-rouge">async/await</code>
but achieves the same goal (in fact, <code class="language-plaintext highlighter-rouge">async/await</code> is a cut-down version of F#’s
approach, which was introduced a few years previously, in F#2).</p>

  <p>– Isaac Abraham, F# in Action</p>
</blockquote>

<p>Time will tell what will happen, but I think it’s unlikely that C# will ever be able to fully replace F#.</p>

<p>I’ve also found this <a href="https://www.reddit.com/r/fsharp/comments/xlegmc/why_doesnt_microsoft_use_f/">encouraging comment from 2022</a> that Microsoft might be willing to invest more in F#:</p>

<blockquote>
  <p>Some good news for you. After 10 years of F# being developed by 2.5 people
internally and some random community efforts, Microsoft has finally decided to
properly invest in F# and created a full-fledged team in Prague this
summer. I’m a dev in this team, just like you I was an F# fan for many years
so I am happy things got finally moving here.</p>
</blockquote>

<p>Looking at the changes in F# 8.0 and F 9.0, it seems the new full-fledged team
has done some great work!</p>

<h2>Ecosystem</h2>

<p>It’s hard to assess the ecosystem around F# after such a brief period, but overall it seems to
me that there are fairly few “native” F# libraries and frameworks out there and most people
rely heavily on the core .NET APIs and many third-party libraries and frameworks geared towards C#.
That’s a pretty common setup when it comes to hosted languages in general, so nothing surprising here as well.</p>

<p>If you’ve ever used another hosted language (e.g. Scala, Clojure, Groovy) then you probably know what
to expect.</p>

<p><a href="https://github.com/fsprojects/awesome-fsharp">Awesome F#</a> keeps track of popular F# libraries, tools and frameworks. I’ll highlight here the web development and data science libraries:</p>

<p><strong>Web Development</strong></p>

<ul>
  <li><strong>Giraffe</strong>: A lightweight library for building web applications using ASP.NET Core. It provides a functional approach to web development.</li>
  <li><strong>Suave</strong>: A simple and lightweight web server library with combinators for routing and task composition. (Giraffe was inspired by Suave)</li>
  <li><strong>Saturn</strong>: Built on top of Giraffe and ASP.NET Core, it offers an MVC-style framework inspired by Ruby on Rails and Elixir’s Phoenix.</li>
  <li><strong>Bolero</strong>: A framework for building client-side applications in F# using WebAssembly and Blazor.</li>
  <li><strong>Fable</strong>: A compiler that translates F# code into JavaScript, enabling integration with popular JavaScript ecosystems like React or Node.js.</li>
  <li><strong>Elmish</strong>: A model-view-update (MVU) architecture for building web UIs in F#, often used with Fable.</li>
  <li><strong>SAFE Stack</strong>: An end-to-end, functional-first stack for building cloud-ready web applications. It combines technologies like Saturn, Azure, Fable, and Elmish for a type-safe development experience.</li>
</ul>

<p><strong>Data Science</strong></p>

<ul>
  <li><strong>Deedle</strong>: A library for data manipulation and exploratory analysis, similar to pandas in Python.</li>
  <li><strong>DiffSharp</strong>: A library for automatic differentiation and machine learning.</li>
  <li><strong>FsLab</strong>: A collection of libraries tailored for data science, including visualization and statistical tools.</li>
</ul>

<p>I haven’t played much with any of them at this point yet, so I’ll reserve any
feedback and recommendations for some point in the future.</p>

<h2>Documentation</h2>

<p>The official documentation is pretty good, although I find it kind of weird that
some of it is hosted on <a href="https://learn.microsoft.com/en-us/dotnet/fsharp/what-is-fsharp">Microsoft’s site</a>
and the rest is on <a href="https://fsharp.org/">https://fsharp.org/</a> (the site of the F# Software Foundation).</p>

<p>I really liked the following parts of the documentation:</p>

<ul>
  <li><a href="https://learn.microsoft.com/en-us/dotnet/fsharp/style-guide/">F# Style Guide</a></li>
  <li><a href="https://github.com/fsharp/fslang-design">F# Design</a> - a repository of RFCs (every language should have one of those!)</li>
</ul>

<p><a href="https://fsharpforfunandprofit.com/">https://fsharpforfunandprofit.com/</a> is another good learning resource. (even if it seems a bit dated)</p>

<h2>Dev Tooling</h2>

<p>I’ve played with the F# plugins for several editors:</p>

<ul>
  <li>Emacs (<code class="language-plaintext highlighter-rouge">fsharp-mode</code>)</li>
  <li>Zed (third-party plugin)</li>
  <li>VS Code (<a href="https://ionide.io/">Ionide</a>)</li>
  <li>Rider (JetBrains’s .NET IDE)</li>
</ul>

<p>Overall, Rider and VS Code provide the most (and the most polished) features,
but the other options were quite usable as well.  That’s largely due to the fact
that the F# LSP server <code class="language-plaintext highlighter-rouge">fsautocomplete</code> (naming is hard!) is quite robust and
any editor with good LSP support gets a lot of functionality for free.</p>

<p>Still, I’ll mention that I found the tooling lacking in some regards:</p>

<ul>
  <li><code class="language-plaintext highlighter-rouge">fsharp-mode</code> doesn’t use TreeSitter (yet) and doesn’t seem to be very actively developed (looking at the code - it seems it was derived from <code class="language-plaintext highlighter-rouge">caml-mode</code>)</li>
  <li>Zed’s support for F# is quite spartan</li>
  <li>In VS Code shockingly the expanding and shrinking selection is broken, which is quite odd for what is supposed to be the flagship editor for F#</li>
</ul>

<p>I’m really struggling with VS Code’s keybindings and editing model, so I’ll likely stick with Emacs going forward. Or I’ll finally spend more quality time with neovim!</p>

<p>It seems that everyone is using the same code formatter (<code class="language-plaintext highlighter-rouge">Fantomas</code>), including the F# team, which is great!
The linter story in F# is not as great (seems the only popular linter <a href="https://fsprojects.github.io/FSharpLint/">FSharpLint</a> is abandonware these days), but when your
compiler is so good, you don’t really need a linter as much.</p>

<p>Oh, well… It seems that Microsoft are not really particularly invested in
supporting the tooling for F#, as pretty much all the major projects in this
space are community-driven.</p>

<p>Using AI coding agents (e.g. Copilot) with F# worked pretty well, but I didn’t
spend much time on this front.</p>

<p>In the end of the day any editor will likely do, as long as you’re using LSP.</p>

<h2>Community</h2>

<p>My initial impression of the community is that it’s fairly small, perhaps even
smaller than that of OCaml.  The F# Reddit and Discord (the one listed on
Reddit) seem like the most active places for F# conversations. There’s supposed
to be some F# Slack as well, but I couldn’t get an invite for it. (seems the
automated process for issuing those invites has been broken for a while)</p>

<p>I’m still not sure what’s the role Microsoft plays in the community, as I
haven’t seen much from them overall.</p>

<p>For a me a small community is not really a problem, as long as the community is
vibrant and active. Also - I’ve noticed I always feel more connected to smaller
communities. Moving from Java to Ruby back in the day felt like night and day as
far as community engagement and sense of belonging go.</p>

<p>I didn’t find many books and community sites/blogs dedicated to F#, but I didn’t
really expect to in the first place.</p>

<p>All in all - I don’t feel qualified to comment much on the F# community at this point.</p>

<h2>Use Cases</h2>

<p>Given the depth and breath of .NET - I guess that sky is the limit for you!</p>

<p>Seems to me that F# will be a particularly good fit for data analysis and manipulation, because
of features like <a href="https://learn.microsoft.com/en-us/dotnet/fsharp/tutorials/type-providers/">type providers</a>.</p>

<p>Probably a good fit for backend services and even full-stack apps, although I haven’t really played
with the F# first solutions in this space yet.</p>

<p>Fable and Elmish make F# a viable option for client-side programming and might offer
another easy way to sneak F# into your day-to-day work.</p>

<p><strong>Note:</strong> Historically, Fable has been used to target JavaScript but since Fable
4, you can also target other languages such as TypeScript, Rust, Python, and
more.</p>

<p>Here’s how easy it is to transpile an F# codebase into something else:</p>

<div class="language-shell highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c"># If you want to transpile to JavaScript</span>
dotnet fable

<span class="c"># If you want to transpile to TypeScript</span>
dotnet fable <span class="nt">--lang</span> typescript

<span class="c"># If you want to transpile to Python</span>
dotnet fable <span class="nt">--lang</span> python
</code></pre></div></div>

<p>Cool stuff!</p>

<h2>F# vs OCaml</h2>

<p>F# was derived from OCaml, so the two languages share a lot of DNA. Early on
F# made some efforts to support as much of OCaml’s syntax as possible, and it
even allowed the use of <code class="language-plaintext highlighter-rouge">.ml</code> and <code class="language-plaintext highlighter-rouge">.mli</code> file extensions for F# code. Over time
the languages started to diverge a bit, though.<sup role="doc-noteref"><a href="https://batsov.com/feeds/OCaml.xml#fn:3" class="footnote" rel="footnote">3</a></sup></p>

<p>If you ask most people about the pros and cons of F# over OCaml you’ll probably
get the following answers.</p>

<p><strong>F# Pros</strong></p>

<ul>
  <li>Runs on .NET
    <ul>
      <li>Tons of libraries are at disposal</li>
    </ul>
  </li>
  <li>Backed by Microsoft</li>
  <li>Arguably it’s a bit easier to learn by newcomers (especially those who have only experience with OO programming)
    <ul>
      <li>The syntax is slightly easier to pick up (I think)</li>
      <li>The compiler errors and warnings are “friendlier” (easier to understand)</li>
      <li>It’s easier to debug problems (partially related to the previous item)</li>
    </ul>
  </li>
  <li>Strong support for <a href="https://learn.microsoft.com/en-us/dotnet/fsharp/tutorials/async">async programming</a></li>
  <li>Has some cool features, absent in OCaml, like:
    <ul>
      <li>Anonymous Records</li>
      <li>Active Patterns</li>
      <li>Computational expressions</li>
      <li>Sequence comprehensions</li>
      <li>Type Providers</li>
      <li>Units of measure</li>
    </ul>
  </li>
</ul>

<p><strong>F# Cons</strong></p>

<ul>
  <li>Runs on .NET
    <ul>
      <li>The interop with .NET influenced a lot of language design decisions (e.g. allowing <code class="language-plaintext highlighter-rouge">null</code>)</li>
    </ul>
  </li>
  <li>Backed by Microsoft
    <ul>
      <li>Not everyone likes Microsoft</li>
      <li>Seems the resources allocated to F# by Microsoft are modest</li>
      <li>It’s unclear how committed Microsoft will be to F# in the long run</li>
    </ul>
  </li>
  <li>Naming conventions: I like <code class="language-plaintext highlighter-rouge">snake_case</code> way more than <code class="language-plaintext highlighter-rouge">camelCase</code> and <code class="language-plaintext highlighter-rouge">PascalCase</code></li>
  <li>Misses some cool OCaml features
    <ul>
      <li>First-class modules and functors</li>
      <li>GADTs</li>
    </ul>
  </li>
  <li>Doesn’t have a friendly camel logo</li>
  <li>The name F# sounds cool, but is a search and filename nightmare (and you’ll see FSharp quite often in the wild)</li>
</ul>

<p>Both F# and OCaml can also target JavaScript runtimes as well - via <a href="https://fable.io/">Fable</a> on
the F# side and Js_of_ocaml and Melange on the OCaml side. Fable seems like a
more mature solution at a cursory glance, but I haven’t used any of the three
enough to be able to offer an informed opinion.</p>

<p>In the end of the day both remain two fairly similar robust, yet niche,
languages, which are unlikely to become very popular in the future. I’m guessing
working professionally with F# is more likely to happen for most people, as .NET
is super popular and I can imagine it’d be fairly easy to sneak a bit of F# here
in there in established C# codebases.</p>

<p>One weird thing I’ve noticed with F# projects is that they still use XML project
manifests, where you have to list the source files manually in the order in
which they should be compiled (to account for the dependencies between them). I
am a bit shocked that the compiler can’t handle the dependencies automatically,
but I guess that’s because in F# there’s not direct mapping between source files
and modules. At any rate - I prefer the OCaml compilation process (and Dune) way
more.</p>

<p>As my interest in MLs is mostly educational I’m personally leaning towards OCaml, but if I had to build
web services with an ML language I’d probably pick F#. I also have a weird respect for every language
with its own runtime, as this means that it’s unlikely that the runtime will force some compromises
on the language.</p>

<h2>Closing thoughts</h2>

<p>All in all I liked F# way more than I expected to! In a way it reminded me of my
experience with Clojure back in the day in the sense that Clojure was the most
practical Lisp out there when it was released, mostly because of its great
interop with Java.</p>

<p>I have a feeling that if .NET was portable since day 1 probably ClojureCLR would have become
as popular as Clojure, and likely F# would have developed a bigger community and
broader usage by now. I’m fairly certain I would have never dabbled in .NET again
if it hadn’t been for .NET Core, and I doubt I’m the only one.</p>

<p>Learning OCaml is definitely not hard, but I think that people interested to learn some ML
might have an easier time with F#. And, as mentioned earlier, you’ll probably have an
easier path “production” with it.</p>

<p>I think that everyone who has experience with .NET will benefit from learning F#.
Perhaps more importantly - everyone looking to do more with an ML family language
should definitely consider F#, as it’s a great language in its own right, that gives
you access to one of the most powerful programming platforms out there.</p>

<p>Let’s not forget about <a href="https://fable.io/">Fable</a>, which makes it possible for you leverage
F# in JavaScript, Dart, Rust and Python runtimes!</p>

<p>So, why F#? Become it’s seriously <strong>fun</strong> and seriously practical!
Also if your code compiles - it will probably work the way you expect it to.</p>

<p>That’s all I have for you today. Please, share in the comments what do you love about F#!</p>

<p>In sane type systems we trust!</p>

<div class="footnotes" role="doc-endnotes">
  <ol>
    <li role="doc-endnote">
      <p>I had some C# courses in the university and I wrote my bachelor’s thesis in C#. It was a rewrite of Arch Linux’s <code class="language-plaintext highlighter-rouge">pacman</code>, running on Mono. This was way back in 2007.&nbsp;<a href="https://batsov.com/feeds/OCaml.xml#fnref:1" class="reversefootnote" role="doc-backlink">↩</a></p>
    </li>
    <li role="doc-endnote">
      <p>See <a href="https://fsharp.org/history/hopl-final/hopl-fsharp.pdf">https://fsharp.org/history/hopl-final/hopl-fsharp.pdf</a>&nbsp;<a href="https://batsov.com/feeds/OCaml.xml#fnref:2" class="reversefootnote" role="doc-backlink">↩</a></p>
    </li>
    <li role="doc-endnote">
      <p><a href="https://github.com/fsharp/fslang-suggestions/issues/985">https://github.com/fsharp/fslang-suggestions/issues/985</a>&nbsp;<a href="https://batsov.com/feeds/OCaml.xml#fnref:3" class="reversefootnote" role="doc-backlink">↩</a></p>
    </li>
  </ol>
</div>

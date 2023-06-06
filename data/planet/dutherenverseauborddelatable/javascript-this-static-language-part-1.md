---
title: JavaScript, this static language (part 1)
description: "tl;dr JavaScript is a dynamic language. However, by borrowing a few
  pages from static languages \u2013 and a few existing tools \u2013 we can considerable
  improve reliability and maintainability. \xAB Writing o\u2026"
url: https://dutherenverseauborddelatable.wordpress.com/2011/10/20/javascript-this-static-language-part-1/
date: 2011-10-20T13:31:36-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- dutherenverseauborddelatable
---

<h2 style="text-align:justify;">tl;dr</h2>
<p style="text-align:justify;">JavaScript is a dynamic language. However, by borrowing a few pages from static languages &ndash; and a few existing tools &ndash; we can considerable improve reliability and maintainability.</p>
<h2 style="text-align:justify;">&laquo; Writing one million lines of code of JavaScript is simply impossible &raquo;</h2>
<p style="text-align:right;">(source: speaker in a recent open-source conference)</p>
<p style="text-align:justify;">JavaScript is a dynamic language &ndash; a very dynamic one, in which programs can rewrite themselves, objects may lose or gain methods through side-effects on themselves on on their prototypes, and, more generally, nothing is fixed.</p>
<p style="text-align:justify;">And dynamic languages are fun. They make writing code simple and fast. They are vastly more suited to prototyping than static languages. Dynamism also makes it possible to write extremely powerful tools that can perform JIT translation from other syntaxes, add missing features to existing classes and functions and more generally fully customize the experience of the developer.</p>
<p style="text-align:justify;">Unfortunately, such dynamism comes with severe drawbacks. Safety-minded developers will tell you that, because of this dynamism, they simply cannot trust any snippet, as this snippet may behave in a manner that does not match its source code. They will conclude that you cannot write safe, or even modular, applications in JavaScript.</p>
<p style="text-align:justify;">Many engineering-minded developers will also tell you that they simply cannot work in JavaScript, and they will not have much difficulty finding examples of situations in which the use of a dynamic language in a complex project can, effectively, kill the project. If you do not believe them, consider a large codebase, and the (rather common) case of a large transversal refactoring, for instance to replace an obsolete API by a newer one. Do this in Java (or, even better, in a more modern mostly-static language such as OCaml, Haskell, F# or Scala), and you can use the compiler to automatically and immediately spot any place where the API has not been updated, and will spot a number of errors that you may have made with the refactoring. Even better, if the API was designed to be safe-by-design, the compiler will automatically spot even complex errors that you may have done during refactoring, including calling functions/methods in the wrong order, or ownership errors. Do the same in JavaScript and, while your code will be written faster, you should expect to be hunting bugs weeks or even months later.</p>
<p style="text-align:justify;">I know that the Python community has considerably suffered from such problems during version transitions. I am less familiar with the world of PHP, but I believe this is no accident that Facebook is progressively arming itself with PHP static analysis tools. I also believe that this is no accident that Google is now <a href="https://dutherenverseauborddelatable.wordpress.com/2011/10/13/first-look-at-google-dart/" title="First look at Google&nbsp;Dart" target="_blank">introducing a typed language as a candidate replacement for JavaScript</a>.</p>
<p style="text-align:justify;">That is because today is the turn of JavaScript, or if not today, surely tomorrow. I have seen applications consisting in hundreds of thousands of lines of JavaScript. And if just maintaining these applications is not difficult enough, the rapid release cycles of both&nbsp; Mozilla and Chrome, mean that external and internal APIs are now changing every six weeks. This means breakage. And, more precisely, this means that we need new tools to help us predict breakages and help developers (both add-on developers and browser contributors) react before these breakages hit their users.</p>
<p style="text-align:justify;">So let&rsquo;s do something about it. Let&rsquo;s make <em>our</em> JavaScript a strongly, statically typed language!</p>
<p style="text-align:justify;">Or let&rsquo;s do something a little smarter.</p>
<h2 style="text-align:justify;">JavaScript, with discipline</h2>
<p style="text-align:justify;">At this point, I would like to ask readers to please kindly stop preparing tar and feathers for me. I realize fully that JavaScript is a dynamic language and that turning it into a static language will certainly result in something quite disagreeable to use. Something that is verbose, has lost most of the power of JavaScript, and gained no safety guarantees.</p>
<p style="text-align:justify;">Trust me on this, there is a way to obtain the best of both worlds, without sacrificing anything. Before discussing the manner in which we can attain this, let us first set objectives that we can hope to achieve with a type-disciplined JavaScript.</p>
<h3 style="text-align:justify;">Finding errors</h3>
<p style="text-align:justify;">The main benefit of strong, static typing, is that it helps find errors.</p>
<ul>
<li style="text-align:justify;">Even the simplest analyses can find <em>all</em> syntax errors, <em>all</em> unbound variables, <em>all</em> variables bound several times and consequently almost all scoping errors, which can already save considerable time for developers. Such an analysis requires no human intervention from the developer besides, of course, fixing any error that has been thus detected. As a bonus, in most cases, the analysis can suggest fixes.</li>
<li style="text-align:justify;">Similarly trivial forms of analysis can also detect suspicious calls to break or continue, weird uses of <code>switch()</code>, suspicious calls to private fields of objects, as well as suspicious occurrences of <code>eval</code> &ndash; in my book, eval is always suspicious.</li>
<li style="text-align:justify;">Slightly more sophisticated analyses can find <em>most occurrences</em> of functions or methods invoked with the wrong number of arguments. Again, this is without human intervention. With type annotations/documentation, we can move from <em>most occurrences</em> to <em>all occurrences</em>.</li>
<li style="text-align:justify;">This same analysis, when applied to public APIs, can provide developers with more informations regarding how their code can be (mis)used.</li>
<li style="text-align:justify;">At the same level of complexity, analysis can find <em>most</em> erroneous access to fields/methods, suspicious array traversals, suspicious calls to iterators/generators, etc. Again, with type annotations/documentation, we can move from <em>most</em> to <em>all</em>.</li>
<li>Going a little further in complexity, analysis can find fragile uses of <code>this</code>, uncaught exceptions, etc.</li>
</ul>
<h3></h3>
<h3>Types as documentation</h3>
<p style="text-align:justify;">Public APIs must be documented. This is true in any language, no matter where it stands on the static/dynamic scale. In static languages, one may observe how documentation generation tools insert type information, either from annotations provided by the user (as in Java/JavaDoc) or from type information inferred by the compiler (as in OCaml/OCamlDoc). But look at the documentation of Python, Erlang or JavaScript libraries and you will find the exact same information, either clearly labelled or hidden somewhere in the prose: every single value/function/method comes with a form of type signature, whether formal or informal.</p>
<p style="text-align:justify;">In other words, type information is a critical piece of documentation. If JavaScript developers provide explicit type annotations along with their public APIs, they have simply advanced the documentation, not wasted time. Even better, if such type can be automatically inferred from the source code, this piece of documentation can be automatically written by the type-checker.</p>
<h3 style="text-align:justify;">Types as QA metric</h3>
<p style="text-align:justify;">While disciples of type-checking tend to consider typing as something boolean, the truth is more subtle: it quite possible that one piece of code does not pass type-checking while the rest of the code does. Indeed, with advanced type systems that do not support decidable type inference, this is only to be expected.</p>
<p style="text-align:justify;">The direct consequence is that type-checking can be seen as a spectrum of quality. A code can be seen as <em>failing</em> if the static checking phrase can detect evident errors, typically unbound values or out-of-scope break, continue, etc. Otherwise, every attempt to type a value that results in a type error is a hint of poor QA practice that can be reported to the developer. This yields a percentage of values that can be typed &ndash; obtain 100% and get a QA stamp of approval for this specific metric.</p>
<h2 style="text-align:justify;"></h2>
<h2>Typed JavaScript, in practice</h2>
<p style="text-align:justify;">Most of the previous paragraphs are already possible in practice, with existing tools. Indeed, I have personally experienced using JavaScript static type checking as a bug-finding tool and a QA metric. On the first day, this technique has helped me find both plenty of dead code and 750+ errors, with only a dozen false positives.</p>
<p style="text-align:justify;">For this purpose, I have used Google&rsquo;s <a href="http://www.slideshare.net/pascallouis/type-checking-javascript" target="_blank">Closure Compiler</a>. This tool detects errors, supports a simple vocabulary for documentation/annotations, fails only if very clear errors are detected (typically syntax errors) and provides as metric a percentage of well-typed code. It does not accept JavaScript 1.7 yet, unfortunately, but this can certainly be added.</p>
<p style="text-align:justify;">I also know of existing academic work to provide static type-checking for JavaScript, although I am unsure as to the maturity of such works.</p>
<p>Finally, Mozilla is currently working on a different type inference mechanism for JavaScript. While this mechanism is not primarily aimed at finding errors, my personal intuition is that it may be possible to repurpose it.</p>
<h2></h2>
<h2>What&rsquo;s next?</h2>
<p style="text-align:justify;">I hope that I have convinced you of the interest of investigating manners of introducing static, strong type-checking to JavaScript. In a second part, I will detail how and where I believe that this can be done in Mozilla.</p>


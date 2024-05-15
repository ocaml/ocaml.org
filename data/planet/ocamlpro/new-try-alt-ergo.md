---
title: New Try-Alt-Ergo
description: Have you heard about our Try-Alt-Ergo website? Created in 2014 (see our
  blogpost), the first objective was to facilitate access to our performant SMT Solver
  Alt-Ergo. Try-Alt-Ergo allows you to write and run your problems in your browser
  without any server computation. This playground website has be...
url: https://ocamlpro.com/blog/2021_03_29_new_try_alt_ergo
date: 2021-03-29T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Albin Coquereau\n  "
source:
---

<p><img src="https://ocamlpro.com/blog/assets/img/screenshot_ask_altergo.jpg" alt=""/></p>
<p>Have you heard about our <a href="https://alt-ergo.ocamlpro.com/try.html">Try-Alt-Ergo</a> website? Created in 2014 (see <a href="https://ocamlpro.com/blog/2014_07_15_try_alt_ergo_in_your_browser">our blogpost</a>), the first objective was to facilitate access to our performant SMT Solver <a href="https://alt-ergo.ocamlpro.com/">Alt-Ergo</a>. <em>Try-Alt-Ergo allows you to write and run your problems in your browser without any server computation.</em></p>
<p>This playground website has been maintained by OCamlPro for many years, and it's high time to bring it back to life with new updates. We are therefore pleased to announce the new version of the <a href="https://try-alt-ergo.ocamlpro.com/">Try-Alt-Ergo</a> website! In this article, we will first explain what has changed in the back end, and what you can use if you are interested in running your own version of Alt-Ergo on a website, or in an application! And then we will focus on the new front-end of our website, from its interface to its features through its tutorial about the program.* *</p>
<h2><a href="https://ocamlpro.com/blog/2021_03_29_new_try_alt_ergo">Try-Alt-Ergo 2014</a></h2>
<p><img src="https://ocamlpro.com/blog/assets/img/screenshot_from_2021_03_29.png" alt=""/></p>
<p><a href="https://alt-ergo.ocamlpro.com/try.html">Try-Alt-Ergo</a> was designed to be a powerful and simple tool to use. Its interface was minimalist. It offered three panels, one panel (left) with a text area containing the problem to prove. The centered panel was composed of a button to run Alt-Ergo, load examples, set options. The right panel showed these options, examples and other information. This design lacked some features that have been added to our solver through the years. Features such as models (counter-examples), unsat-core, more options and debug information was missing in this version.</p>
<p>Try-Alt-Ergo did not offer a proper editor (with syntax coloration), a way to save the file problem nor an option to limit the run of the solver with a time limit. Another issue was about the thread. When the solver was called the webpage froze, that behavior was problematic in case of the long run because there was no way to stop the solver.</p>
<h2><a href="https://ocamlpro.com/blog/2021_03_29_new_try_alt_ergo">Alt-Ergo 1.30</a></h2>
<p>The 1.30 version of Alt-Ergo was the version used in the back-end to prove problems. Since this version, a lot of improvements have been done in Alt-Ergo. To learn more about these improvements, see our <a href="https://ocamlpro.github.io/alt-ergo/About/changes.html">changelog</a> in the documentation.</p>
<p>Over the years we encountered some difficulties to update the Alt-Ergo version used in Try-Alt-Ergo. We used <a href="https://ocsigen.org/js_of_ocaml/latest/manual/overview">Js_of_ocaml</a> to compile the OCaml code of our solver to be runnable as a JavaScript code. Some libraries were not available in JavaScript and we needed to manually disable them. The lack of automatism leads to a lack of time to update the JavaScript version of Alt-Ergo in Try-Alt-Ergo.</p>
<p>In 2019 we switched our build system to <a href="https://dune.readthedocs.io/en/latest/overview.html">dune</a> which opens the possibility to ease the cross-compilation of Alt-Ergo in JavaScript.</p>
<h2><a href="https://ocamlpro.com/blog/2021_03_29_new_try_alt_ergo">New back-end</a></h2>
<p>With some simple modification, we were able to compile Alt-Ergo in JavaScript. This modification is simple enough that this process is now automated in our continuous integration. This will enable us to easily provide a JavaScript version of our Solver for each future version.</p>
<p>Two ways of using our solver in JavaScript are available:</p>
<ul>
<li><code>alt-ergo.js</code>, a JavaScript version of the Alt-Ergo CLI. It can be runned with <code>node</code>: <code>node alt-ergo.js &lt;options&gt; &lt;file&gt;</code>. Note that this code is slower than the natively compiled CLI of Alt-Ergo.In our effort to open the SMT world to more people, an npm package is the next steps of this work.
</li>
<li><code>alt-ergo-worker.js</code>, a web worker of Alt-Ergo. This web worker needs JSON file to input file problem, options into Alt-Ergo and to returns its answers:
<ul>
<li>Options are sent as a list of couple <em>name:value</em> like:<code>{&quot;debug&quot;:true,&quot;input_format&quot;:&quot;Native&quot;,&quot;steps_bound&quot;:100,&quot;sat_solver&quot;: &quot;Tableaux&quot;,&quot;file&quot;:&quot;test-file&quot;}</code>You can specify all options used in Alt-Ergo. If some options are missing, the worker uses the default value for these options. For example, if debug is not specified the worker will use its defaults <em>value :false</em>.- Input file is sent as a list of string, with the following format:<code>{ &quot;content&quot;: [ &quot;goal g: true&quot;] }</code>
</li>
<li>Alt-Ergo answers can be composed with its results, debug information, errors, warnings &hellip;<code>{ &quot;results&quot;: [ &quot;File &quot;test-file&quot;, line 1, characters 9-13: Valid (0.2070) (0 steps) (goal g) ] ,``&quot;debugs&quot;: [ &quot;[Debug][Sat_solver]&quot;, &quot;use Tableaux-like solver&quot;] }</code>like the options, a result value like <code>debugs</code> does not contains anything, <code>&quot;debugs&quot;: [...]</code> is not returned.
</li>
<li>See the Alt-Ergo <a href="https://ocamlpro.github.io/alt-ergo/Usage/index.html#js-worker">web-worker documentation</a> to learn more on how to use it.
</li>
</ul>
</li>
</ul>
<h2><a href="https://ocamlpro.com/blog/2021_03_29_new_try_alt_ergo">New Front-end</a></h2>
<p><img src="https://ocamlpro.com/blog/assets/img/screenshot_new_altergo_interface.jpg" alt=""/></p>
<p>The <a href="https://try-alt-ergo.ocamlpro.com">Try-Alt-Ergo</a> has been completely reworked and we added some features:</p>
<ul>
<li>The left panel is still composed in an editor and answers area
<ul>
<li><a href="https://ace.c9.io/">Ace editor</a> with custom syntax coloration (both native and smt-lib2) is now used to make it more pleasant to write your problems.
</li>
</ul>
</li>
<li>A top panel that contains the following buttons:
<ul>
<li><code>Ask Alt-Ergo</code> which retrieves content from the editor and options, launch the web worker and print answers in the defined areas.
</li>
<li><code>Load</code> and <code>Save</code> files.
</li>
<li><code>Documentation</code>, that sends users to the newly added <a href="https://ocamlpro.github.io/alt-ergo/Input_file_formats/Native/index.html">native syntax documentation</a> of Alt-Ergo.
</li>
<li><code>Tutorial</code>, that opens an interactive <a href="https://try-alt-ergo.ocamlpro.com/tuto/tutorial.html">tutorial</a> to introduce you to Alt-Ergo native syntax and program verification.
</li>
</ul>
</li>
</ul>
<p><img src="https://ocamlpro.com/blog/assets/img/screenshot_welcome_to_altergo_tutorial.png" alt=""/></p>
<ul>
<li>A right panel composed of tabs:
<ul>
<li><code>Start</code> and <code>About</code> that contains general information about Alt-Ergo, Try-Alt-Ergo and how to use it.
</li>
<li><code>Outputs</code> prints more information than the basic answer area under the editor. In these tabs you can find debugs (long) outputs, unsat-core or models (counter-example) generated by Alt-Ergo.
</li>
<li><code>Options</code> contains every option you can use, such as the time limit / steps limit or to set the format of the input file to prove  .
</li>
<li><code>Statistics</code> is still a basic tab that only output axioms used to prove the input problem.
</li>
<li><code>Examples</code> contains some basic examples showing the capabilities of our solver.
</li>
</ul>
</li>
</ul>
<p>We hope you will enjoy this new version of Try-Alt-Ergo, we can't wait to read your feedback!</p>
<p><em>This work was done at OCamlpro.</em></p>


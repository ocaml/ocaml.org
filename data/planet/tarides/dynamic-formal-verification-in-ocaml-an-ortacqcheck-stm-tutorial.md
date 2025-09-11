---
title: 'Dynamic Formal Verification in OCaml: An Ortac/QCheck-STM Tutorial'
description: We introduce the Ortac/QCheck-STM, a tool to automatically generate QCheck-STM
  tests based on Gospel specification, in a tutorial-like manner.
url: https://tarides.com/blog/2025-09-10-dynamic-formal-verification-in-ocaml-an-ortac-qcheck-stm-tutorial
date: 2025-09-10T00:00:00-00:00
preview_image: https://tarides.com/blog/images/ortac-qcheck-stm-tutorial-1360w.webp
authors:
- Tarides
source:
ignore:
---

<p>You may have read our <a href="https://tarides.com/blog/2024-09-03-getting-specific-announcing-the-gospel-and-ortac-projects/">recent post discussing our involvement in the Gospel Project</a>. In today's follow-up post, we will focus on <a href="https://github.com/ocaml-gospel/ortac">Ortac</a>, a tool we have been developing at Tarides as part of the Gospel Project.</p>
<h2>What is Ortac?</h2>
<p>Ortac aims to give OCaml programmers easy access to dynamic formal verification, also known as specification-driven testing. At its core, it translates computable Gospel terms into equivalent OCaml expressions. Different Ortac modes can then use these translations to generate OCaml code. This post is about the <a href="https://ocaml.org/p/ortac-qcheck-stm/latest">Ortac/QCheck-STM</a> mode that generates black-box model-based state-machine tests based on the <a href="https://ocaml.org/p/qcheck-stm/latest">QCheck-STM</a> framework.</p>
<h2>Ortac/QCheck-STM Mode</h2>
<p><a href="https://github.com/c-cube/qcheck">QCheck</a> is a property-based testing framework inspired by <a href="https://en.wikipedia.org/wiki/QuickCheck">QuickCheck</a>. As the name implies, the idea behind property-based testing is to check a property about a function, generally expressed as an equation involving the inputs and outputs of the function, against randomly generated inputs.</p>
<p>In contrast, QCheck-STM checks the behaviour of randomly generated sequences of function calls against a model. The model is implemented as a state machine (hence the STM). Testing a sequence of function calls helps users discover more bugs, especially when a mutable state is involved. In order to use QCheck-STM on a library, the users have to specify which type is the center of attention, also called System Under Test, or SUT for short. They also have to provide a functional model for the SUT, equipped with a <code>next_state</code> function computing the new model given a function call. You can read more about QCheck-STM <a href="https://tarides.com/blog/2024-04-24-under-the-hood-developing-multicore-property-based-tests-for-ocaml-5/">in a previous post on our blog</a> and <a href="https://janmidtgaard.dk/papers/Midtgaard-Nicole-Osborne:OCaml22.pdf">in a paper on parallel testing libraries for OCaml 5</a>.</p>
<p>One of the positives of using Ortac/QCheck-STM is that with just some Gospel annotations, a  Dune rule, and a configuration file, we can benefit from QCheck-STM tests. Another bonus is that in case of failure, the generated tests will provide a bug report containing the piece of Gospel specification that has been violated, a runnable scenario with the actual returned values to reproduce the failure and, if available, the expected returned value of the failing command according to the function specification.</p>
<p>Since the previous post, the Ortac tool has been improved in several ways. Version 0.4.0 brought support for keeping track of multiple Systems Under Test in the generated tests, all thanks to <a href="https://tarides.com/blog/2024-09-24-summer-of-internships-projects-from-the-ocaml-compiler-team/">Nikolaus Huber's work</a>. Then, version 0.5.0 brought support for testing higher-order functions, thanks to Jan Midtgaard. Finally, version 0.6.0 improved the computation of the expected returned value based on the specifications.</p>
<p>The reader curious about how Ortac/QCheck-STM works internally can refer to this <a href="https://link.springer.com/chapter/10.1007/978-3-031-90660-2_1">paper</a>. The rest of this post will adopt a more practical perspective, using the <a href="https://en.wikipedia.org/wiki/Priority_queue">priority queue</a> as a running example.</p>
<h2>Project Setup</h2>
<p>Let's first explore a project setup, how to write the Gospel specification of the API, and finally, how to integrate Ortac/QCheck-STM with Dune.</p>
<p>Here is the project's structure:</p>
<pre><code><span class="sh-support-function-builtin">.</span><span class="sh-source">
</span><span class="sh-source">├── dune-project
</span><span class="sh-source">├── priority-queue.opam
</span><span class="sh-source">├── src
</span><span class="sh-source">│&nbsp;&nbsp; ├── dune
</span><span class="sh-source">│&nbsp;&nbsp; ├── priority_queue.ml
</span><span class="sh-source">│&nbsp;&nbsp; └── priority_queue.mli
</span><span class="sh-source">└── </span><span class="sh-support-function-builtin">test</span><span class="sh-source">
</span><span class="sh-source">    ├── dune
</span><span class="sh-source">    ├── dune.inc
</span><span class="sh-source">    ├── priority_queue_config.ml
</span><span class="sh-source">    └── priority_queue_tests.ml
</span><span class="sh-source">
</span><span class="sh-source">3 directories, 9 files
</span></code></pre>
<p>The idea behind Ortac/QCheck-STM is to <strong>not</strong> write the tests. Compared to a more traditional project, <code>priority_queue.mli</code> contains some Gospel specifications describing the expected behaviour of the functions, and the files <code>dune.inc</code> and <code>priority_queue_tests.ml</code> are generated by Ortac.</p>
<p>The <code>priority_queue_tests.ml</code> contains the generated QCheck-STM tests for the <code>Priority_queue</code> module, based on the Gospel specifications contained in the <code>priority_queue.mli</code> file and the <code>priority_queue_config.ml</code> file provided by the user. Furthermore, <code>dune.inc</code> contains the generated Dune rules to generate <code>priority_queue_tests.ml</code> and attach the execution of these tests to the <code>runtest</code> alias.</p>
<p>Generating <code>dune.inc</code> is the job of the Ortac/Dune mode, which is called by a hand-written dune rule in the <code>dune</code> file.</p>
<p>Due to how Dune's promote mode interacts with the <code>include</code> stanza, we must create an empty <code>dune.inc</code>. Another possibility is to use a <code>dynamic_include</code> rule (see the <a href="https://dune.readthedocs.io/en/stable/howto/rule-generation.html">rule generation chapter in the Dune docs</a> for more details).</p>
<p>Generating <code>priority_queue_tests.ml</code> is the job of the Ortac/QCheck-STM mode, which is called by a generated dune rule in <code>dune.inc</code>.</p>
<p>Ortac/QCheck-STM is provided by the <a href="https://ocaml.org/p/ortac-qcheck-stm/latest"><code>ortac-qcheck-stm</code></a> package, and Ortac/Dune by the <a href="https://ocaml.org/p/ortac-dune/latest"><code>ortac-dune</code></a> one. We need to declare these two packages as dependency for our project.</p>
<h2>Writing Some Gospel Specifications</h2>
<p>Let's take a look at the interface file for our priority queue, where the Gospel specifications are stored.</p>
<p>We begin by declaring the OCaml abstract type of a priority queue alongside its logical specification:</p>
<pre><code><span class="ocaml-comment-block">(*</span><span class="ocaml-comment-block">@ open Sequence </span><span class="ocaml-comment-block">*)</span><span class="ocaml-source">
</span><span class="ocaml-source">
</span><span class="ocaml-comment-block">(*</span><span class="ocaml-comment-block">@ type 'a priority = 'a * integer </span><span class="ocaml-comment-block">*)</span><span class="ocaml-source">
</span><span class="ocaml-source">
</span><span class="ocaml-comment-block">(*</span><span class="ocaml-comment-block">@ type 'a priority_queue = 'a priority sequence </span><span class="ocaml-comment-block">*)</span><span class="ocaml-source">
</span><span class="ocaml-source">
</span><span class="ocaml-keyword-other">type</span><span class="ocaml-source"> </span><span class="ocaml-storage-type">'a</span><span class="ocaml-source"> </span><span class="ocaml-source">t</span><span class="ocaml-source">
</span><span class="ocaml-comment-block">(*</span><span class="ocaml-comment-block">@ mutable model contents : 'a priority_queue
</span><span class="ocaml-comment-block">    with t
</span><span class="ocaml-comment-block">    invariant let q = t.contents in
</span><span class="ocaml-comment-block">              forall i.
</span><span class="ocaml-comment-block">              1 &lt;= i &lt; length q
</span><span class="ocaml-comment-block">              -&gt; snd q[i-1] &gt;= snd q[i] </span><span class="ocaml-comment-block">*)</span><span class="ocaml-source">
</span></code></pre>
<p>Gospel annotations are written inside special comments opened with <code>(*@</code>. We can open modules from the logical library that Gospel provides. The Sequence Module contains the definition of a mathematical sequence and some operations. Ortac comes with an implementation of the Gospel logical library. We can also declare Gospel types using the same syntax as the OCaml one.</p>
<p>Gospel annotations immediately following an OCaml <code>type</code> or <code>val</code> are attached to it, a bit like documentation comments. So, in the example above, <code>mutable model contents ...</code> is the specification for the <code>type 'a t</code>. Gospel is a specification language based on models. Thus, in the first line of the specification, we give our OCaml type a model named <code>contents</code>. The model is also marked as <code>mutable</code>. That doesn't mean that the model itself is mutable but that the model of an <code>'a t</code> may change when that <code>'a t</code> is mutated. It is a way of specifying that the OCaml type <code>'a t</code> is mutable.</p>
<p>Now, our model <code>contents</code> has a Gospel type: <code>'a priority_queue</code>. If we unfold the definitions of the Gospel types <code>priority_queue</code> and <code>priority</code> given just before in the file, this means that we will see OCaml values of type <code>'a t</code> as mathematical sequences of pairs of an element and an integer representing this element priority. There are other models we could have reasonably chosen, but let's go with this one. Let's also note that the model we choose is not directly related to the actual implementation. The logical model should make sense for any possible implementation.</p>
<p>We also use the <code>invariant</code> mechanism from Gospel to express that we keep the elements in decreasing order of priority in the model. This is not necessary, but it makes expressing the inspection and the evolution of the logical model a lot easier.</p>
<p>Now, we need to be able to express three fundamental operations precisely in our model: inserting a new element with its associated priority, looking at the next element, and deleting the next element.</p>
<pre><code><span class="ocaml-comment-block">(*</span><span class="ocaml-comment-block">@ function insert (q : 'a priority_queue)
</span><span class="ocaml-comment-block">                    (a : 'a)
</span><span class="ocaml-comment-block">                    (i : integer)
</span><span class="ocaml-comment-block">                    : 'a priority_queue =
</span><span class="ocaml-comment-block">      let higher = filter (fun x -&gt; snd x &gt; i) q in
</span><span class="ocaml-comment-block">      let equal = filter (fun x -&gt; snd x = i) q in
</span><span class="ocaml-comment-block">      let lesser = filter (fun x -&gt; snd x &lt; i) q in
</span><span class="ocaml-comment-block">      higher ++ snoc equal (a, i) ++ lesser </span><span class="ocaml-comment-block">*)</span><span class="ocaml-source">
</span><span class="ocaml-source">
</span><span class="ocaml-comment-block">(*</span><span class="ocaml-comment-block">@ function peek (q : 'a priority_queue) : 'a option =
</span><span class="ocaml-comment-block">      if q = empty
</span><span class="ocaml-comment-block">      then None
</span><span class="ocaml-comment-block">      else Some (fst (hd q)) </span><span class="ocaml-comment-block">*)</span><span class="ocaml-source">
</span><span class="ocaml-source">
</span><span class="ocaml-comment-block">(*</span><span class="ocaml-comment-block">@ function delete (q : 'a priority_queue) : 'a priority_queue =
</span><span class="ocaml-comment-block">      if q = empty
</span><span class="ocaml-comment-block">      then q
</span><span class="ocaml-comment-block">      else tl q </span><span class="ocaml-comment-block">*)</span><span class="ocaml-source">
</span></code></pre>
<p>The <code>insert</code> function does all the specification heavy lifting and is responsible for maintaining the invariant we've declared for our logical model. Note that Ortac/QCheck-STM will include invariant verifications in the generated tests!</p>
<p>The <code>insert</code> function is also the place where we choose to store the elements of the same priority in a FIFO manner by using the function <code>snoc</code> from the Gospel logical library.</p>
<p>The way <code>insert</code> is written makes peeking and deleting straightforward. In both cases, it suffices to look at and delete the first element of the sequence.</p>
<p>As we can see, this is similar to a very naive <em>trusted</em> functional implementation of the logical model. This makes a lot of sense if we think about it! As Ortac compiles Gospel specifications into OCaml code, it consumes <em>computable</em> specifications. This process also looks like part of what we would have written if we had been using <code>QCheck-STM</code> directly. These three functions are the ones necessary to implement the functional state-machine that the QCheck-STM tests will rely on, whether hand-written or Ortac-generated. One of the benefits of using Ortac/QCheck-STM is that it will test the Gospel implementation of these functions against the model's invariants for free!</p>
<p>We could argue that using an ordered list as a model for a priority queue is inefficient. But, as we are in a testing situation, performance matters less than the correctness of the model.</p>
<p>We now have all the necessary vocabulary to talk about the behaviour we expect from a priority queue:</p>
<pre><code><span class="ocaml-keyword-other">val</span><span class="ocaml-source"> </span><span class="ocaml-source">empty</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other-ocaml punctuation-other-colon punctuation">:</span><span class="ocaml-source"> </span><span class="ocaml-support-type">unit</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">-&gt;</span><span class="ocaml-source"> </span><span class="ocaml-storage-type">'a</span><span class="ocaml-source"> </span><span class="ocaml-source">t</span><span class="ocaml-source">
</span><span class="ocaml-comment-block">(*</span><span class="ocaml-comment-block">@ q = empty ()
</span><span class="ocaml-comment-block">    ensures q.contents = Sequence.empty </span><span class="ocaml-comment-block">*)</span><span class="ocaml-source">
</span><span class="ocaml-source">
</span><span class="ocaml-keyword-other">val</span><span class="ocaml-source"> </span><span class="ocaml-source">insert</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other-ocaml punctuation-other-colon punctuation">:</span><span class="ocaml-source"> </span><span class="ocaml-storage-type">'a</span><span class="ocaml-source"> </span><span class="ocaml-source">t</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">-&gt;</span><span class="ocaml-source"> </span><span class="ocaml-storage-type">'a</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">-&gt;</span><span class="ocaml-source"> </span><span class="ocaml-support-type">int</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">-&gt;</span><span class="ocaml-source"> </span><span class="ocaml-support-type">unit</span><span class="ocaml-source">
</span><span class="ocaml-comment-block">(*</span><span class="ocaml-comment-block">@ insert q a i
</span><span class="ocaml-comment-block">    modifies q.contents
</span><span class="ocaml-comment-block">    ensures q.contents = insert (old q.contents) a i </span><span class="ocaml-comment-block">*)</span><span class="ocaml-source">
</span><span class="ocaml-source">
</span><span class="ocaml-keyword-other">val</span><span class="ocaml-source"> </span><span class="ocaml-source">peek</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other-ocaml punctuation-other-colon punctuation">:</span><span class="ocaml-source"> </span><span class="ocaml-storage-type">'a</span><span class="ocaml-source"> </span><span class="ocaml-source">t</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">-&gt;</span><span class="ocaml-source"> </span><span class="ocaml-storage-type">'a</span><span class="ocaml-source"> </span><span class="ocaml-source">option</span><span class="ocaml-source">
</span><span class="ocaml-comment-block">(*</span><span class="ocaml-comment-block">@ o = peek q
</span><span class="ocaml-comment-block">    ensures o = peek q.contents </span><span class="ocaml-comment-block">*)</span><span class="ocaml-source">
</span><span class="ocaml-source">
</span><span class="ocaml-keyword-other">val</span><span class="ocaml-source"> </span><span class="ocaml-source">extract</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other-ocaml punctuation-other-colon punctuation">:</span><span class="ocaml-source"> </span><span class="ocaml-storage-type">'a</span><span class="ocaml-source"> </span><span class="ocaml-source">t</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">-&gt;</span><span class="ocaml-source"> </span><span class="ocaml-storage-type">'a</span><span class="ocaml-source"> </span><span class="ocaml-source">option</span><span class="ocaml-source">
</span><span class="ocaml-comment-block">(*</span><span class="ocaml-comment-block">@ o = extract q
</span><span class="ocaml-comment-block">    modifies q.contents
</span><span class="ocaml-comment-block">    ensures o = peek (old q.contents)
</span><span class="ocaml-comment-block">    ensures q.contents = delete (old q.contents) </span><span class="ocaml-comment-block">*)</span><span class="ocaml-source">
</span></code></pre>
<p>Gospel function's specification takes the form of a contract. The first line of which is a header naming the arguments and the returned value. What follows is a sequence of clauses describing the expected behaviour. Note that in these clauses, the names <code>insert</code>, <code>peek</code>, and <code>delete</code> refer to the Gospel functions defined above.</p>
<p>Here, the functions' contract is pretty straightforward. It is worth noting that in order to be able to include a function in the tests, Ortac/QCheck-STM asks that whenever a new SUT is created, or an existing one is modified, the contract contains a post-condition (an <code>ensures</code> clause) describing, again, in a computable way, the value of the related model.</p>
<p>When there are other post-conditions, they are added to the tests. Besides, when a post-condition is describing, in a computable way, the output value, Ortac/QCheck-STM will use it to include information about the expected returned value in the bug report in case of test failure.</p>
<h2>Integrating Specification-Driven Tests With a Dune Workflow</h2>
<p>Now, with a bit more effort, specification-driven testing is just a <code>dune runtest</code> away!</p>
<p>The first thing Ortac/QCheck-STM needs is a minimal configuration file in order to know how to build the QCheck-STM test suite we want. The minimal configuration consists of defining the <code>sut</code> type and the <code>init_sut</code> value.</p>
<p>The <code>sut</code> type is the type we want to focus the tests on, and the <code>init_sut</code> value is how to create an initial value to start the tests.</p>
<p>The configuration file also contains some additional information. Here we shadow the QCheck generators for <code>int</code>s and <code>char</code>s so that we only deal with three levels of priorities and readable elements in the tests.</p>
<pre><code><span class="ocaml-keyword-other">type</span><span class="ocaml-source"> </span><span class="ocaml-source">sut</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-support-type">char</span><span class="ocaml-source"> </span><span class="ocaml-source">t</span><span class="ocaml-source">
</span><span class="ocaml-source">
</span><span class="ocaml-keyword">let</span><span class="ocaml-source"> </span><span class="ocaml-entity-name-function-binding">init_sut</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-source">empty</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-unit">()</span><span class="ocaml-source">
</span><span class="ocaml-source">
</span><span class="ocaml-keyword-other">module</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Gen</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other">struct</span><span class="ocaml-source">
</span><span class="ocaml-source">  </span><span class="ocaml-keyword">let</span><span class="ocaml-source"> </span><span class="ocaml-entity-name-function-binding">int</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-source">oneofl</span><span class="ocaml-source"> </span><span class="ocaml-source">[</span><span class="ocaml-constant-numeric-decimal-integer">0</span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-constant-numeric-decimal-integer">1</span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-constant-numeric-decimal-integer">2</span><span class="ocaml-source">]</span><span class="ocaml-source">
</span><span class="ocaml-source">  </span><span class="ocaml-keyword">let</span><span class="ocaml-source"> </span><span class="ocaml-entity-name-function-binding">char</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-source">char_range</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-single">'a'</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-single">'z'</span><span class="ocaml-source">
</span><span class="ocaml-keyword-other">end</span><span class="ocaml-source">
</span></code></pre>
<p>Finally, we want to be able to generate and launch the tests with a <code>dune runtest</code>. Thanks to the Ortac/Dune plugin, we only need to write one rule:</p>
<pre><code><span class="dune-meta-stanza">(</span><span class="dune-meta-class-stanza">rule</span><span class="dune-meta-stanza">
</span><span class="dune-meta-stanza"> </span><span class="dune-meta-stanza">(</span><span class="dune-meta-class-stanza">alias</span><span class="dune-meta-stanza"> </span><span class="dune-meta-atom">runtest</span><span class="dune-meta-stanza">)</span><span class="dune-meta-stanza">
</span><span class="dune-meta-stanza"> </span><span class="dune-meta-stanza-rule">(</span><span class="dune-keyword-other">mode</span><span class="dune-meta-stanza-rule"> </span><span class="dune-constant-language-rule-mode">promote</span><span class="dune-meta-stanza-rule">)</span><span class="dune-meta-stanza">
</span><span class="dune-meta-stanza"> </span><span class="dune-meta-stanza-rule">(</span><span class="dune-keyword-other">deps</span><span class="dune-meta-stanza-rule">
</span><span class="dune-meta-stanza-rule">  </span><span class="dune-entity-tag-list-parenthesis">(</span><span class="dune-constant-language-flag">:specs</span><span class="dune-meta-list"> %{</span><span class="dune-meta-atom">project_root}/src/priority_queue.mli</span><span class="dune-entity-tag-list-parenthesis">)</span><span class="dune-meta-stanza-rule">)</span><span class="dune-meta-stanza">
</span><span class="dune-meta-stanza"> </span><span class="dune-meta-stanza-rule">(</span><span class="dune-keyword-other">action</span><span class="dune-meta-stanza-rule">
</span><span class="dune-meta-stanza-rule">  </span><span class="dune-meta-stanza-rule-action">(</span><span class="dune-entity-name-function-action">with-stdout-to</span><span class="dune-meta-stanza-rule-action">
</span><span class="dune-meta-stanza-rule-action">   </span><span class="dune-meta-atom">dune.inc</span><span class="dune-meta-stanza-rule-action">
</span><span class="dune-meta-stanza-rule-action">   </span><span class="dune-meta-stanza-rule-action">(</span><span class="dune-entity-name-function-action">run</span><span class="dune-meta-stanza-rule-action"> </span><span class="dune-meta-atom">ortac</span><span class="dune-meta-stanza-rule-action"> </span><span class="dune-meta-atom">dune</span><span class="dune-meta-stanza-rule-action"> </span><span class="dune-meta-atom">qcheck-stm</span><span class="dune-meta-stanza-rule-action"> %{</span><span class="dune-meta-atom">specs</span><span class="dune-meta-stanza-rule-action">}</span><span class="dune-meta-stanza-rule-action">)</span><span class="dune-meta-stanza-rule-action">)</span><span class="dune-meta-stanza-rule">)</span><span class="dune-meta-stanza">)</span><span class="dune-source">
</span><span class="dune-source">
</span><span class="dune-meta-stanza">(</span><span class="dune-meta-class-stanza">include</span><span class="dune-meta-stanza"> </span><span class="dune-meta-atom">dune.inc</span><span class="dune-meta-stanza">)</span><span class="dune-source">
</span></code></pre>
<p>Other than that, you are all set to implement a priority queue against specification-driven generated tests!</p>
<h2>Current and Future Work</h2>
<p>As mentioned <a href="https://github.com/ocaml-gospel/ortac?tab=readme-ov-file#found-issues">in the repo</a>, Ortac/QCheck-STM has already proven itself useful by discovering and helping fix a number of issues.</p>
<p>Thanks to Charlène Gros, the Ortac/Wrapper mode has just been released. Ortac/Wrapper consumes Gospel annotations to generate runtime assertion checking. Given an annotated OCaml interface file, this plugin will generate a new module with the same signature but with an implementation instrumented with assertions taken from the Gospel specifications. Each function is <em>wrapped</em> with an assertion of its pre- and post-conditions.</p>
<p>Another project is to make Ortac/QCheck-STM also target QCheck-STM/Domains. For now, Ortac/QCheck-STM only generates QCheck-STM tests for testing the library in a sequential context. One of the strengths of QCheck-STM is that it provides a way to test mutable data structures in a parallel context using domains.</p>
<p>The whole project is under active development and should continue to evolve. We are also committed to open-source software, so if you want to take Ortac for a spin (and I encourage you to), please don't hesitate to ask questions, contribute issues, or even PRs!</p>
<h2>Until Next Time</h2>
<p>You can connect with us on <a href="https://bsky.app/profile/tarides.com">Bluesky</a>, <a href="https://mastodon.social/@tarides">Mastodon</a>, <a href="https://www.threads.net/@taridesltd">Threads</a>, and <a href="https://www.linkedin.com/company/tarides">LinkedIn</a> or sign up to our mailing list to stay updated on our latest projects. We look forward to hearing from you!</p>


---
title: BAP Knowledge Representation - Part 1
description: The Binary Analysis Platform Blog
url: http://binaryanalysisplatform.github.io/knowledge-intro-1
date: 2019-08-15T00:00:00-00:00
preview_image:
featured:
authors:
- bap
---

<p>An important part of BAP 2.0 is the new knowledge representation system, which drives all the new code. Given how important it is for understanding and using modern BAP, I decided to introduce it informally in a series of blog posts. This series is by no means a substitution for documentation or a tutorial, which will (I hope) follow. The intention is to describe the system in a friendly manner like I would describe it to my colleague in front of a whiteboard.</p>

<p>All information in BAP 2.0 is stored in the knowledge base, which is roughly a global storage of information which could be used by different components for information exchange. It is like a set of global variables but without common problems associated with the global mutable state since the knowledge system will prevent data anomalies by ensuring that all updates are consistent and firing up a fixed point computation in case of mutual dependencies between different variables.</p>

<p>This knowledge base is essentially a set of <em>objects</em>. Objects belong to <em>classes</em>. Classes denote what <em>properties</em> objects have. Classes are further subdivided into <em>sorts</em>, which we will discuss in a separate blog post.</p>

<p>Object properties could be read or written. It is also possible to associate triggers with a property. Triggers are called <em>promises</em> in our parlance. A promise is a function that will be called when a property of an object is accessed. The promises are stored procedures in our knowledge base and they act like the injection points for different plugins, e.g., a lifter is just a promise to provide the semantics property of an object of class <code class="language-plaintext highlighter-rouge">core-theory:program</code>. The promise itself can access any other properties of any other objects (which it can reach, of course), even including the property that it is providing (recursive case). Moreover, with each property, we can associate several promises (triggers). For example, we can have several lifters working at the same time. The knowledge system will take care of running and scheduling different promises and will compute the fixed point solution in linear time using stochastic fixed-point computation, and yadda, yadda. The point is that it will make it automatically and transparent to the user, and will guarantee the consistency of the result (e.g., that it doesn&rsquo;t depend on the order of evaluation of promises). It is also important to understand, that once a triggered property is computed it will be stored and never recomputed again<sup>1</sup>.</p>

<p>Now let&rsquo;s look underneath the hood of the knowledge base to see what objects and classes do we have right now. If you will run <code class="language-plaintext highlighter-rouge">bap ./exe -dknowledge</code> you will find out that most of the objects that are currently stored in the base belong to the <code class="language-plaintext highlighter-rouge">core-theory:program</code> class. Later, we will add more classes, but to implement the <code class="language-plaintext highlighter-rouge">Bap.Std</code> interface this one was enough. So let&rsquo;s take a particular object as an example. The knowledge base is printed in the following format: <code class="language-plaintext highlighter-rouge">(&lt;object&gt; (&lt;properties&gt;))</code>. If an object has a symbolic identifier associated with it, then it will be printed, otherwise, a numeric identifier (basically a pointer) will be printed. The object class is not printed, but all objects are grouped by their class, with each new class opened with the <code class="language-plaintext highlighter-rouge">(in-class &lt;class-name&gt;)</code> statement. Also, note that all symbolic identifiers are properly namespaced, using the package system which is the same as in Common Lisp. All identifiers which do not belong to the current package, denoted with the <code class="language-plaintext highlighter-rouge">(in-package &lt;pkg&gt;)</code> statement, are printed as <code class="language-plaintext highlighter-rouge">&lt;package&gt;:&lt;name&gt;</code>).</p>

<p>Now, we are ready to read the output of <code class="language-plaintext highlighter-rouge">-dknowledge</code>. In the following output, we have an object, that belongs to the <code class="language-plaintext highlighter-rouge">core-theory:program</code> class, which has a printed representation <code class="language-plaintext highlighter-rouge">core-theory:0x402fd0</code>. The printed representation looks very much like a number, and you may notice that it is indeed equal to the address of an instruction which this object denotes.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>(in-class core-theory:program)
&lt;snip&gt;
(core-theory:0x402fd0
  ((core-theory:label-addr (0x402fd0))
   (bap.std:arch (x86_64))
   (bap.std:insn ((MOV32rr EAX ESI)))
   (bap.std:mem ((402fd0 2 LittleEndian)))
   (core-theory:semantics
      ((bap.std:ir-graph
         (&quot;00004b45:
           00004b46: RAX := pad:64[low:32[RSI]]&quot;))
       (bap.std:insn-dests ((77054)))
       (bap.std:insn-ops ((EAX ESI)))
       (bap.std:insn-asm &quot;movl %esi, %eax&quot;)
       (bap.std:insn-properties
          ((:invalid false) (:jump false) (:cond false)
           (:indirect false)
           (:call false) (:return false) (:barrier false)
           (:affect-control-flow false)
           (:load false) (:store false)))
       (bap.std:bil &quot;{RAX := pad:64[low:32[RSI]]}&quot;)
       (bap.std:insn-opcode MOV32rr)))))
</code></pre></div></div>

<p>We can see, that the object is having the following properties:</p>

<ul>
  <li><code class="language-plaintext highlighter-rouge">core-theory:semantics</code> - the semantics of this instruction</li>
  <li><code class="language-plaintext highlighter-rouge">core-theory:label-addr</code> - the address</li>
  <li><code class="language-plaintext highlighter-rouge">bap.std:insn</code> &ndash; the disassembled instruction</li>
  <li><code class="language-plaintext highlighter-rouge">bap.std:mem</code> - the region of memory which this instruction occupies</li>
  <li><code class="language-plaintext highlighter-rouge">bap.std:arch</code>  - and the architecture</li>
</ul>

<p>We can immediately infer a novel feature of bap 2.0, is that architecture is now a property of a particular instruction object (basically of an address), not of the whole project. Which enables multi-architectural analysis, where in the same base we have programs from different architectures, calling each other (ARM/Thumb is a good example).</p>

<p>The <code class="language-plaintext highlighter-rouge">label-addr</code>, <code class="language-plaintext highlighter-rouge">insn</code>, and <code class="language-plaintext highlighter-rouge">mem</code> properties are pretty self-explanatory, so let&rsquo;s jump to the most interesting property called <code class="language-plaintext highlighter-rouge">semantics</code>. The <code class="language-plaintext highlighter-rouge">semantics</code> itself is also a set of properties, which is called a <em>value</em>. Later, we will discover that essentially objects are pointers to values. A value, like an object, also belongs to some class and has some properties. The <code class="language-plaintext highlighter-rouge">core-theory:semantics</code> property belongs to the <code class="language-plaintext highlighter-rouge">core-theory:effect</code> class. This class denotes general effects that are produced when an instruction is executed. In other words, the semantics of an instruction. The semantics may have many different denotations, i.e., we can use different mathematical objects and structures to represent the semantics, which we will discuss in details the later blog posts. But for now let&rsquo;s briefly look into different denotations of semantics (which all belong to the <code class="language-plaintext highlighter-rouge">bap.std</code> package, so we will omit the package name for brevity):</p>

<ul>
  <li><code class="language-plaintext highlighter-rouge">bil</code> - good old BAP 1.x BIL</li>
  <li><code class="language-plaintext highlighter-rouge">ir-graph</code> - the semigraphical BIR representation</li>
  <li><code class="language-plaintext highlighter-rouge">insn-dests</code> - the set of destinations</li>
  <li><code class="language-plaintext highlighter-rouge">insn-opcode</code> - the opcode</li>
  <li><code class="language-plaintext highlighter-rouge">insn-ops</code> - an array of operands</li>
  <li><code class="language-plaintext highlighter-rouge">insn-asm</code> - the assembly string</li>
  <li><code class="language-plaintext highlighter-rouge">insn-properties</code> - semantic properties provided by the decoder</li>
</ul>

<p>As we may see, most of those properties are good old properties of the <code class="language-plaintext highlighter-rouge">Bap.Std.Insn</code> data type in BAP 1.x, and indeed in BAP 2.x <code class="language-plaintext highlighter-rouge">Bap.Std.Insn.t</code> is represented as a <code class="language-plaintext highlighter-rouge">Knowledge.value</code> instance. The only new field is the set of destinations, which denote a set of program objects that are reachable from the given address. Which lets us explore the whole graph.</p>

<p>This brings us to the end of the first blog post about BAP 2.0 and the new knowledge system. We will discuss the knowledge system, along with an actual program interface in the upcoming blog posts. To make those posts productive I encourage everyone to join the discussion of BAP 2.0 in our <a href="https://gitter.im/BinaryAnalysisPlatform/bap">gitter channel</a>. Please, feel free to provide feedback, ask questions and drive the future posts.</p>

<hr/>
<p><sup>1)</sup> All this magic with the consistent state, fixed-point solutions, etc is possible due to one trick - a data type of any property in our knowledge base must form a domain. A domain is a set equipped with a partial order and a special element called the bottom, so a domain is a generalization of a lattice (all lattices are domains, but not all domains are lattices). The partial order associated with the data type orders elements of this type by the amount of information. The knowledge system guarantees that all updates to object values preserve knowledge, i.e., the value of a property can never become less (wrt to the associated partial order), than it was before. Going deeper into details, every time a property is updated the existing value is joined with the new value, <code class="language-plaintext highlighter-rouge">x = join old new</code>, where the <code class="language-plaintext highlighter-rouge">join</code> operation is either induced by the domain order associated with the data type, or provided by a user (which basically allows users to register their lattices). To handle cases where <code class="language-plaintext highlighter-rouge">join</code> doesn&rsquo;t exist (and it may not exist, since we&rsquo;re not requiring lattices), we extend the user datum with the <code class="language-plaintext highlighter-rouge">top</code> value which denotes conflicting information (therefore named <code class="language-plaintext highlighter-rouge">conflict</code>), thus turning each domain into dcpo (directed complete partial order - the structure that we actually need, to ensure all those magical properties, dcpo is very close to a lattice, but still a little bit more general).</p>


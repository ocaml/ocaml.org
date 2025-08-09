---
title: Defunctorising VPNKit
description:
url: https://patrick.sirref.org/vpnkit-upgrade/
date: 2025-02-28T00:00:00-00:00
preview_image:
authors:
- https://patrick.sirref.org/Patrick%20Ferris/
source:
ignore:
---


        <p><a href="https://patrick.sirref.org/vpnkit/">VPNKit</a> is a core part of the Docker for Mac/Windows stack. It is tasked with translating network activity from the host to the Linux container.</p>
        <p>This short post discusses some of the recent changes to MirageOS and how they impact <a href="https://patrick.sirref.org/vpnkit/">VPNKit</a>.</p>
        <section>
          <header>
            <h2>Dune Virtual Libraries</h2>
          </header>
          <p>Dune, for quite some time, has supported <em>virtual libraries</em>. This allows library authors to define a signature without an implementation (similar to OCaml's <code>module type S = struct ... end</code>). The package is something other dune libraries can build against, still without choosing a particular implementation of the interface. An application author can make the decision about which implementation they would like to build into their program.</p>
          <p>This feature has been quite widely used in OCaml. For example, the <a href="https://github.com/mirage/digestif">excellent <code>digestif</code> library</a> of hashing algorithms provides both C and OCaml implementations individually packaged into <code>digestif.c</code> and <code>digestif.ocaml</code> respectively. Consider developing a browser application that needs some hashing algorithm (e.g. <a href="https://github.com/patricoferris/omditor">Irmin in the browser</a>). We can explicitly use the OCaml backend for digestif which <a href="https://github.com/ocsigen/js_of_ocaml">js_of_ocaml</a> will happily compile for us.</p>
          <p>There are two distinct limitations to this approach.</p>
          <ol>
            <li>
              <p>Applications can only link <em>exactly one</em> implementation.</p>
            </li>
            <li>
              <p>Implementations cannot expose additional functionality easily (see <a href="https://github.com/ocaml/dune/issues/5997">dune5597</a>).</p>
            </li>
          </ol>
        </section>
        <section>
          <header>
            <h2>Functors in MirageOS</h2>
          </header>
          <p><a href="https://mirage.io/">MirageOS</a> is a framework for building unikernels in OCaml. It relies heavily on OCaml's functors to abstract implementation from interface. The mirage tool will then select appropriate instantiations of these functors depending on the backend that is targeted (e.g. <code>unix</code>, <code>hvt</code> etc.)</p>
          <p>Recently, <a href="https://github.com/mirage/mirage-skeleton/pull/407/">there has been a push</a> to use <a href="https://patrick.sirref.org/dune-virt-libs/">dune virtual libraries</a> instead.</p>
        </section>
        <section>
          <header>
            <h2>VPNKit's Fake Clock &amp; Time</h2>
          </header>
          <p>We need to be able to overcome the limitation that implementations cannot expose additional functionality very easily using dune virtual libraries. As it stands, we need to make Mirage's virtual libraries unwrapped (i.e. set <code>(wrapped false)</code>). This allows implementers to expose additional modules alongside the implementation of the virtual library.</p>
          <p>For VPNkit, we need this to port some of the DNS forwarding tests which use a fake clock and sleep module. Previously, they could be provided directly as functor arguments to the various DNS modules e.g.</p>
          <pre class="hilite">            <code><span class="ocaml-keyword">let</span><span class="ocaml-source"> </span><span class="ocaml-keyword">module</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">R</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-constant-language-capital-identifier">Dns_forward</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-constant-language-capital-identifier">Resolver</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-constant-language-capital-identifier">Make</span><span class="ocaml-source">( </span><span class="ocaml-constant-language-capital-identifier">Proto_client</span><span class="ocaml-source">) </span><span class="ocaml-source">( </span><span class="ocaml-constant-language-capital-identifier">Fake</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-constant-language-capital-identifier">Time</span><span class="ocaml-source">) </span><span class="ocaml-source">( </span><span class="ocaml-constant-language-capital-identifier">Fake</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-constant-language-capital-identifier">Clock</span><span class="ocaml-source">) </span><span class="ocaml-source">
</span></code>
          </pre>
          <p>In this new world of <a href="https://patrick.sirref.org/dune-virt-libs/">dune virtual libraries</a>, our <code>Resolver</code> is significantly more simple.</p>
          <pre class="hilite">            <code><span class="ocaml-keyword">let</span><span class="ocaml-source"> </span><span class="ocaml-keyword">module</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">R</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Dns_forward</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-constant-language-capital-identifier">Resolver</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-constant-language-capital-identifier">Make</span><span class="ocaml-source">( </span><span class="ocaml-constant-language-capital-identifier">Proto_client</span><span class="ocaml-source">) </span><span class="ocaml-source">
</span>
<span class="ocaml-source">
</span></code>
          </pre>
          <p>The flexibility of time and clock implementation has been pushed to a build-time decision in a dune file. This means that in order to provide the same fake clock and time we will need to create a private dune library that (a) implements the respective signatures of the virtual libraries and (b) provides the extended interface to allow the test suite to modify the internals of the implementations.</p>
          <p>The first thing I had to do was make the <code>mirage-mtime</code> and <code>mirage-sleep</code> virtual libraries unwrapped. This allowed me to make a new private dune library called <code>fake_time</code> with <em>two</em> public modules: the normal interface required by <code>mirage-mtime</code> and another module called <code>Fake_time_state</code> containing:</p>
          <pre class="hilite">            <code><span class="ocaml-keyword">let</span><span class="ocaml-source"> </span><span class="ocaml-entity-name-function-binding">timeofday</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-source">ref</span><span class="ocaml-source"> </span><span class="ocaml-constant-numeric-decimal-integer">0L</span><span class="ocaml-source">
</span>
<span class="ocaml-keyword">let</span><span class="ocaml-source"> </span><span class="ocaml-entity-name-function-binding">c</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Lwt_condition</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-source">create</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-unit">() </span><span class="ocaml-source">
</span>
<span class="ocaml-source">
</span>
<span class="ocaml-keyword">let</span><span class="ocaml-source"> </span><span class="ocaml-entity-name-function-binding">advance</span><span class="ocaml-source"> </span><span class="ocaml-source">nsecs</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-source">timeofday</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other-ocaml punctuation-other-colon punctuation">:</span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Int64</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-source">add</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">!</span><span class="ocaml-source">timeofday</span><span class="ocaml-source"> </span><span class="ocaml-source">nsecs</span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-constant-language-capital-identifier">Lwt_condition</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-source">broadcast</span><span class="ocaml-source"> </span><span class="ocaml-source">c</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-unit">() </span><span class="ocaml-source">
</span>
<span class="ocaml-source">
</span>
<span class="ocaml-keyword">let</span><span class="ocaml-source"> </span><span class="ocaml-entity-name-function-binding">reset</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-unit">() </span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-source">timeofday</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other-ocaml punctuation-other-colon punctuation">:</span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-constant-numeric-decimal-integer">0L</span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-constant-language-capital-identifier">Lwt_condition</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-source">broadcast</span><span class="ocaml-source"> </span><span class="ocaml-source">c</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-unit">() </span><span class="ocaml-source">
</span></code>
          </pre>
          <p>I did the same for <code>fake_sleep</code> which depended on the state from the <code>fake_time</code> library (something a normal library wouldn't).</p>
          <p>Once I had the implementations for the virtual libraries in place, all that remained was to tell the executable (in this case the test suite) to select these new implementations instead of the defaults.  Whereas before, all the tests could live in the same test suite, now they had to be split into those that needed the fake implementation and those that did not. This is another slight limitation of this virtual library approach. You can only link one implementation at a time to an executable (or test).  Thus, the dune rules for running the <code>dns_forward</code> test suite became:</p>
          <pre class="hilite">            <code><span class="dune-comment-line">; Uses the default  implementations provided by virtual libraries</span><span class="dune-source">
</span>
<span class="dune-meta-stanza">( </span><span class="dune-meta-class-stanza">executable</span><span class="dune-meta-stanza">
</span>
<span class="dune-meta-stanza"> </span><span class="dune-meta-stanza-library-field">( </span><span class="dune-keyword-other">name</span><span class="dune-meta-stanza-library-field"> </span><span class="dune-meta-atom">test</span><span class="dune-meta-stanza-library-field">) </span><span class="dune-meta-stanza">
</span>
<span class="dune-meta-stanza"> </span><span class="dune-meta-stanza-lib-or-exec-buildable">( </span><span class="dune-keyword-other">libraries</span><span class="dune-meta-stanza-lib-or-exec-buildable"> </span><span class="dune-meta-atom">dns_forward</span><span class="dune-meta-stanza-lib-or-exec-buildable"> </span><span class="dune-meta-atom">alcotest</span><span class="dune-meta-stanza-lib-or-exec-buildable">) </span><span class="dune-meta-stanza">) </span><span class="dune-source">
</span>
<span class="dune-source">
</span>
<span class="dune-comment-line">; Override the defaults and select the private fake libraries</span><span class="dune-source">
</span>
<span class="dune-meta-stanza">( </span><span class="dune-meta-class-stanza">executable</span><span class="dune-meta-stanza">
</span>
<span class="dune-meta-stanza">  </span><span class="dune-meta-stanza-library-field">( </span><span class="dune-keyword-other">name</span><span class="dune-meta-stanza-library-field"> </span><span class="dune-meta-atom">test_fake</span><span class="dune-meta-stanza-library-field">) </span><span class="dune-meta-stanza">
</span>
<span class="dune-meta-stanza">  </span><span class="dune-meta-stanza-lib-or-exec-buildable">( </span><span class="dune-keyword-other">libraries</span><span class="dune-meta-stanza-lib-or-exec-buildable"> </span><span class="dune-meta-atom">dns_forward</span><span class="dune-meta-stanza-lib-or-exec-buildable"> </span><span class="dune-meta-atom">alcotest</span><span class="dune-meta-stanza-lib-or-exec-buildable"> </span><span class="dune-meta-atom">fake_sleep</span><span class="dune-meta-stanza-lib-or-exec-buildable"> </span><span class="dune-meta-atom">fake_time</span><span class="dune-meta-stanza-lib-or-exec-buildable">) </span><span class="dune-meta-stanza">) </span><span class="dune-source">
</span></code>
          </pre>
          <p>With all of this machinery in place, I could now update <code>test_fake</code> to use the new modules that would provide the custom functionality for the clock and time implementations.</p>
          <pre class="hilite">            <code><span class="ocaml-comment-block">(* </span><span class="ocaml-comment-block"> The bad server should be marked offline and no-one will wait for it </span><span class="ocaml-comment-block">*) </span><span class="ocaml-source">
</span>
<span class="ocaml-constant-language-capital-identifier">Fake_time_state</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-source">reset</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-unit">() </span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source">
</span>
<span class="ocaml-comment-block">(* </span><span class="ocaml-comment-block"> avoid the timeouts winning the race with the actual result </span><span class="ocaml-comment-block">*) </span><span class="ocaml-source">
</span>
<span class="ocaml-constant-language-capital-identifier">Fake_time_state</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-source">advance</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Duration</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-source">( </span><span class="ocaml-source">of_ms</span><span class="ocaml-source"> </span><span class="ocaml-constant-numeric-decimal-integer">500</span><span class="ocaml-source">) </span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source"> 
</span></code>
          </pre>
        </section>
        <section>
          <header>
            <h2>Conclusion</h2>
          </header>
          <p>The switch to <a href="https://patrick.sirref.org/dune-virt-libs/">dune virtual libraries</a> seems to be a good one. A majority of applications only require a single clock or time implementation. However, it has become harder to inject custom implementations of various resources into your MirageOS-based applications.</p>
          <p>The <a href="https://github.com/moby/vpnkit/pull/646">pull request to upgrade VPNKit is open</a>.</p>
        </section>
      

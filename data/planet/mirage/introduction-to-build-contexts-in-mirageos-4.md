---
title: Introduction to Build Contexts in MirageOS 4
description:
url: https://mirage.io/blog/2022-03-30.cross-compilation
date: 2022-03-30T00:00:00-00:00
preview_image:
featured:
authors:
- Lucas Pluvinage
---


        <p>In this blog post, we'll discover <em>build contexts</em>, one of the central changes of MirageOS 4. It's a feature from the <a href="https://dune.build">Dune build system</a> that enables fully-customizable cross-compilation. We'll showcase its usage by cross-compiling a unikernel to deploy it on an <code>arm64</code> Linux machine using KVM. This way, a powerful machine does the heavy lifting while a more constrained device such as a <a href="https://www.raspberrypi.org/">Raspberry Pi</a> or a <a href="https://www.clockworkpi.com/devterm">DevTerm</a> deploys it.</p>
<p>We recommend having some familiarity with the MirageOS project in order to fully understand this article. See <a href="https://mirage.io/docs/">mirage.io/docs</a> for more information on that matter.</p>
<p>The unikernel we'll deploy is a caching DNS resolver: https://github.com/mirage/dns-resolver. In a network configuration, the DNS resolver <em>translates</em> domain names to IP adresses, so a personal computer knows which IP should be contacted while accessing mirage.io. <em>See the first 10 minutes of this <a href="https://www.youtube.com/watch?v=-wMU8vmfaYo">YouTube video</a> for a more precise introduction to DNS.</em></p>
<p>It's common that your ISP provides a <em>default</em> DNS resolver that's automatically set up when connecting to your network (see DHCP), but this may come with privacy issues. The <em>Internet People&trade;</em> recommend using <code>1.1.1.1</code> (Cloudflare) or <code>8.8.8.8</code> (Google), but a better solution is to self-host your resolver or use one set up by someone you trust.</p>
<h2>The MirageOS 4 Build System</h2>
<h3>Preliminary Steps</h3>
<p>Let's start by setting up MirageOS 4, fetching the project, and configuring it for <code>hvt</code>. <code>hvt</code> is a Solo5-based target that exploits KVM to perform virtualization.</p>
<pre><code class="language-bash">$ opam install &quot;mirage&gt;4&quot; &quot;dune&gt;=3.2.0&quot;
$ git clone https://github.com/mirage/dns-resolver
$ cd dns-resolver
dns-resolver $ mirage configure -t hvt
</code></pre>
<h3>What is a Configured Unikernel ?</h3>
<p>In MirageOS 4, a <em>configured unikernel</em> is obtained by running the <code>mirage configure</code> command in a folder where a <code>config.ml</code> file resides. This file describes the requirements to build the application, usually a <code>unikernel.ml</code> file.</p>
<p>The following hierarchy is obtained. It's quite complex, but today the focus is on the Dune-related part of it:</p>
<pre><code> dns-resolver/
 &#9507; config.ml
 &#9507; unikernel.ml
 &#9475;
 &#9507; Makefile
 &#9507; dune             &lt;- switch between config and build
 &#9507; dune.config      &lt;- configuration build rules
 &#9507; dune.build       &lt;- unikernel build rules
 &#9507; dune-project     &lt;- dune project definition
 &#9507; dune-workspace   &lt;- build contexts definition
 &#9507; mirage/
 &#9475;  &#9507; context
 &#9475;  &#9507; key_gen.ml
 &#9475;  &#9507; main.ml
 &#9475;  &#9507; &lt;...&gt;-&lt;target&gt;-monorepo.opam
 &#9475;  &#9495; &lt;...&gt;-&lt;target&gt;-switch.opam
 &#9495; dist/
   &#9495; dune           &lt;- rules to produce artifacts
</code></pre>
<p>To set up the switch state and fetch dependencies, use the <code>make depends</code> command. Under the hood (see the Makefile), this calls <code>opam</code> and <code>opam-monorepo</code> to gather dependencies. When the command succeeds, a <code>duniverse/</code> folder is created, which contains the unikernel's runtime dependencies.</p>
<pre><code class="language-bash">$ make depends
</code></pre>
<hr/>
<p>While obtaining dependencies, let's start to investigate the Dune-related files.</p>
<h2><code>dune</code> Files</h2>
<h3><code>./dune</code></h3>
<p><code>dune</code> files describe build rules and high-level operations so that the build system can obtain a global dependency graph and know about what's available to build. See <a href="https://dune.readthedocs.io/en/stable/dune-files.html#dune">dune-files</a> for more information.</p>
<p>In our case, we'll use this file as a <em>switch</em> between two states. This one's first:</p>
<pre><code>(include dune.config)
</code></pre>
<p>at the configuration stage (after calling <code>mirage configure</code>).</p>
<p>Then the content is replaced by <code>(include dune.build)</code> if the configuration is successful.</p>
<h3><code>./dune.config</code></h3>
<pre><code>(data_only_dirs duniverse)

(executable
 (name config)
 (flags (:standard -warn-error -A))
 (modules config)
 (libraries mirage))
</code></pre>
<p>Here, two things are happening. First, the <code>duniverse/</code> folder is declared as data-only, because we don't want it to interfere with the configuration build, as it should only depend on the global switch state.</p>
<p>Second, a <code>config</code> executable is declared. It contains the second stage of the configuration process, which is executed to generate <code>dune.build</code>, <code>dune-workspace</code>, and various other files required to build the unikernel.</p>
<h3><code>./dune-workspace</code></h3>
<p>The workspace declaration file is a single file at a Dune project's root and describes global settings for the project. See the <a href="https://dune.readthedocs.io/en/stable/dune-files.html#dune-workspace">documentation</a>.</p>
<p>First, it declares the Dune language used and the compilation profile, which is <em>release</em>.</p>
<pre><code>(lang dune 2.0)

(profile release)
</code></pre>
<p>For cross-compilation to work, two contexts are declared.</p>
<p>The host context simply imports the configuration from the Opam switch:</p>
<pre><code>(context (default))
</code></pre>
<p>We use the target context in a more flexible way, and there are many fields allowing users to customize settings such as:</p>
<ul>
<li>OCaml compilation and linking flags
</li>
<li>C compilation and linking flags
</li>
<li>Dynamic linking
</li>
<li><strong>OCaml compiler toolchain</strong>: any compiler toolchain described by a <code>findlib.conf</code> file in the switch can be used by Dune in a build context. See <a href="https://linux.die.net/man/5/findlib.conf">https://linux.die.net/man/5/findlib.conf</a> for more details on how to write such a file.
An important fact about the compiler toolchain is that Dune derives the C compilation rules from the <em>configuration</em>, as described in <code>ocamlc -config</code>.
</li>
</ul>
<pre><code>(context (default
  (name solo5)      ; name of the context
  (host default)    ; inform dune that this is cross-compilation
  (toolchain solo5) ; use the ocaml-solo5 compiler toolchain
  (merlin)          ; enable merlin for this context
  (disable_dynamically_linked_foreign_archives true)
))
</code></pre>
<h3><code>./dune.build</code></h3>
<p>When configuration is done, this file is included by <code>./dune</code>.</p>
<ol>
<li>The generated source code is imported along with the unikernel sources:
</li>
</ol>
<pre><code>(copy_files ./mirage/*)
</code></pre>
<ol start="2">
<li>An executable is declared within the cross-compilation build context, using the statically-known list of dependencies:
</li>
</ol>
<pre><code>(executable
 (enabled_if (= %{context_name} &quot;solo5&quot;))
 (name main)
 (modes (native exe))
 (libraries arp.mirage dns dns-mirage dns-resolver.mirage dns-server
   ethernet logs lwt mirage-bootvar-solo5 mirage-clock-solo5
   mirage-crypto-rng-mirage mirage-logs mirage-net-solo5 mirage-random
   mirage-runtime mirage-solo5 mirage-time tcpip.icmpv4 tcpip.ipv4
   tcpip.ipv6 tcpip.stack-direct tcpip.tcp tcpip.udp)
 (link_flags :standard -w -70 -color always -cclib &quot;-z solo5-abi=hvt&quot;)
 (modules (:standard \\ config manifest))
 (foreign_stubs (language c) (names manifest))
)
</code></pre>
<ol start="3">
<li>Solo5 requires the usage of a small chunk of C code derived from a manifest file, which is also generated:
</li>
</ol>
<pre><code>(rule
 (targets manifest.c)
 (deps manifest.json)
 (action
  (run solo5-elftool gen-manifest manifest.json manifest.c)))
</code></pre>
<ol start="4">
<li>The obtained image is renamed, and the default alias is overriden so that <code>dune build</code> works as expected:
</li>
</ol>
<pre><code>(rule
 (target resolver.hvt)
 (enabled_if (= %{context_name} &quot;solo5&quot;))
 (deps main.exe)
 (action
  (copy main.exe %{target})))

(alias
  (name default)
  (enabled_if (= %{context_name} &quot;solo5&quot;))
  (deps (alias_rec all)))
</code></pre>
<h3><code>./dist/dune</code></h3>
<p>Once the unikernel is built, this rule describes how it's promoted back into the source tree that resides inside the <code>dist/</code> folder.</p>
<pre><code>(rule
 (mode (promote (until-clean)))
 (target resolver.hvt)
 (enabled_if (= %{context_name} &quot;solo5&quot;))
 (action
  (copy ../resolver.hvt %{target})))
</code></pre>
<hr/>
<h2>Cross-Compiling to <code>x86_64/hvt</code></h2>
<p>If everything went correctly, the unikernel source tree should be populated with all the build rules and dependencies needed. It's just a matter of</p>
<pre><code>$ make build
</code></pre>
<p>or</p>
<pre><code>$ mirage build
</code></pre>
<p>or</p>
<pre><code>$ dune build --root .
</code></pre>
<p>Finally, we obtain an <code>hvt</code>-enabled executable in the <code>dist/</code> folder. To execute it, the we must first:</p>
<ul>
<li>install the HVT tender: <code>solo5-hvt</code> that is installed in the <code>solo5</code> package.
</li>
<li>prepare a TAP interface for networking: note that it requires access to the Internet to be able to query the root DNS servers.
</li>
</ul>
<p>That executable can run using <code>solo5-hvt --net:service=&lt;TAP_INTERFACE&gt; dist/resolver.hvt --ipv4=&lt;UNIKERNEL_IP&gt; --ipv4-gateway=&lt;HOST_IP&gt;</code>.</p>
<h2>Cross-Compiling to ARM64/HVT</h2>
<p>When cross-compiling to ARM64, the scheme looks like this:</p>
<p><img src="https://i.imgur.com/QqEGUPz.png" alt=""/></p>
<p>So, from the Mirage build system viewpoint, nothing changes. The only part that changes is the compiler used. We switch from a <em>host</em>-architecture <code>ocaml-solo5</code> to a <em>cross</em>-architecture version of <code>ocaml-solo5</code>.</p>
<p>To achieve that, we must pin a version of <code>ocaml-solo5</code> configured for cross-compilation and pin the cross-compiled Solo5 distribution:</p>
<pre><code>$ opam pin solo5-cross-aarch64 https://github.com/Solo5/solo5.git#v0.7.1
$ opam pin ocaml-solo5-cross-aarch64 https://github.com/mirage/ocaml-solo5.git#v0.8.0
</code></pre>
<p>Note that doing this will uninstall <code>ocaml-solo5</code>. Indeed, they both define the same <em>toolchain name</em> <code>solo5</code>.</p>
<p>KVM is now enabled by default in most Raspberry Pi kernel distributions, but for historical interest, this blog post shows how to enable KVM and cross-compile the Linux kernel: <a href="https://mirage.io/docs/arm64">https://mirage.io/docs/arm64</a></p>
<p>Then, simply run</p>
<pre><code>$ dune build / mirage build / make
</code></pre>
<p>A cross-compiled binary will appear in the <code>dist/</code> folder:</p>
<pre><code>$ file dist/resolver.hvt
dist/resolver.hvt: ELF 64-bit LSB executable, ARM aarch64, version 1 (SYSV), statically linked, interpreter /nonexistent/solo5/, for OpenBSD, with debug_info, not stripped
</code></pre>
<p>On the Raspberry Pi target, simply copy the unikernel binary, install the Solo5 tender (<code>opam install solo5</code>), and run <code>solo5-hvt unikernel.hvt</code> to execute the unikernel.</p>
<h2>Compiling to a New Target or Architecture</h2>
<h3>Case 1: An Already Known Mirage Target (Unix / HVT / etc.)</h3>
<p>In that situation, <code>mirage configure -t &lt;target&gt;</code> should already output the correct source code and dependencies for the target. This is notably under the assumption that the involved C code is portable.</p>
<p>The <code>dune-workspace</code> can then be tweaked to reference the wanted cross-compiler distribution. <a href="https://github.com/mirage/ocaml-solo5"><code>ocaml-solo5</code></a> is an example on how a cross-compiler distribution can be set up and installed inside an Opam switch.</p>
<h3>Case 2: A New Target</h3>
<p>In this situation, a more in-depth comprehension of Mirage is required.</p>
<ol>
<li>Set up a cross-compiler distribution: see previous case.
</li>
<li>Implement a base layer:
An OCaml module named <code>&lt;Target&gt;_os</code> is required to implement the base features of MirageOS, namely job scheduling and timers. See <a href="https://github.com/mirage/mirage-solo5"><code>mirage-solo5</code></a>.
</li>
<li>Implement the target signature in the Mirage tool:
<a href="https://github.com/mirage/mirage/blob/main/lib/mirage/target/s.ml"><code>Mirage_target.S</code></a> notably describes the packages required and the Dune rules needed to build for that target.
</li>
<li>To obtain feature parity with the other Mirage targets and be able to use the existing devices, device drivers should be implemented:
<ul>
<li>Networking: see <a href="https://github.com/mirage/mirage-net-solo5">mirage-net-solo5</a>
</li>
<li>Console: see <a href="https://github.com/mirage/mirage-console-solo5">mirage-console-solo5</a>
</li>
<li>Block Device: see <a href="https://github.com/mirage/mirage-block-solo5">mirage-block-solo5</a>
</li>
<li>Clock: see <a href="https://github.com/mirage/mirage-clock">mirage-clock-solo5</a>
</li>
</ul>
</li>
</ol>
<h2>Conclusion</h2>
<p>This blog post shows how the Mirage tool acts as super glue between the build system, the mirage libraries, the host system, and the <strong>application code</strong>. One of the major changes with MirageOS 4 is the switch from OCamlbuild to Dune.</p>
<p>Using Dune to build unikernels enables cross-compilation through build contexts that use various toolchains. It also enables the usage of the Merlin tool to provide IDE features when writing the application. Finally, a single-workspace containg all the unikernels' code lets developers investigate and edit code anywhere in the stack, allowing for fast iterations when debugging libraries and improving APIs.</p>

      

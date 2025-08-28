---
title: 'Opinion: Is it time to stop testing with opam &lt; 2.2'
description: On the eve of the release of opam 2.4, is it time to stop testing with
  opam < 2.2?
url: https://www.tunbury.org/2025/05/26/retire-legacy-opam/
date: 2025-05-26T00:00:00-00:00
preview_image: https://www.tunbury.org/images/opam.png
authors:
- Mark Elvers
source:
ignore:
---

<p>On the eve of the release of opam 2.4, is it time to stop testing with opam &lt; 2.2?</p>

<p>Over the weekend, we have been seeing numerous failures across the ecosystem due to the unavailability of the <a href="http://camlcity.org">camlcity.org</a>. This website hosts the source for the <code class="language-plaintext highlighter-rouge">findlib</code> package. A typical error report is shown below:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>#32 [build-opam-doc  5/14] RUN opam install odoc
#32 258.6 [ERROR] Failed to get sources of ocamlfind.1.9.6: curl error code 504
#32 258.6
#32 258.6 #=== ERROR while fetching sources for ocamlfind.1.9.6 =========================#
#32 258.6 OpamSolution.Fetch_fail("http://download.camlcity.org/download/findlib-1.9.6.tar.gz (curl: code 504 while downloading http://download.camlcity.org/download/findlib-1.9.6.tar.gz)")
#32 259.0
#32 259.0
#32 259.0 &lt;&gt;&lt;&gt; Error report &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
#32 259.0 +- The following actions failed
#32 259.0 | - fetch ocamlfind 1.9.6
#32 259.0 +-
</code></pre></div></div>

<p>The most high-profile failure has been the inability to update <a href="https://opam.ocaml.org">opam.ocaml.org</a>.  See <a href="https://github.com/ocaml/infrastructure/issues/172">issue#172</a>. This has also affected the deployment of <a href="https://ocaml.org">ocaml.org</a>.</p>

<p>Late last year, Hannes proposed adding our archive mirror to the base image builder. <a href="https://github.com/ocurrent/docker-base-images/issues/306">issue#306</a>. However, this requires opam 2.2 or later. We have long maintained that while supported <a href="https://repology.org/project/opam/versions">distributions</a> still package legacy versions, we should continue to test against these versions.</p>

<p>The testing of the legacy versions is limited to <a href="https://opam.ci.ocaml.org">opam-repo-ci</a> testing on Debian 12 on AMD64 using a test matrix of OCaml 4.14 and 5.3 with each of opam 2.0, 2.1 and 2.2. These tests often fail to find a solution within the timeout. We have tried increasing the timeout by a factor of 10 to no avail. All of opam-repo-ci’s other tests use the current development version. OCaml-CI only tests using the current release version.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>[ERROR] Sorry, resolution of the request timed out.
        Try to specify a simpler request, use a different solver, or increase the allowed time by setting OPAMSOLVERTIMEOUT to a bigger value (currently, it is set to 60.0 seconds).
</code></pre></div></div>

<p>The base image default is opam 2.0, as <code class="language-plaintext highlighter-rouge">~/.opam</code> can’t be downgraded; therefore, we can’t set a mirror archive flag in the base images.</p>

<p>A typical <code class="language-plaintext highlighter-rouge">Dockerfile</code> starts by replacing opam 2.0 with the latest version and reinitialising.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>FROM ocaml/opam:debian-12-ocaml-4.14 AS build
RUN sudo ln -sf /usr/bin/opam-2.3 /usr/bin/opam &amp;&amp; opam init --reinit -ni
...
</code></pre></div></div>

<p>To include the archive mirror, we should add a follow-up of:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>RUN opam option --global 'archive-mirrors+="https://opam.ocaml.org/cache"'
</code></pre></div></div>

<p>Dropping 2.0 and 2.1, and arguably 2.2 as well, from the base images would considerably decrease the time taken to build the base images, as opam is built from the source each week for each distribution/architecture.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>RUN git clone https://github.com/ocaml/opam /tmp/opam &amp;&amp; cd /tmp/opam &amp;&amp; cp -P -R -p . ../opam-sources &amp;&amp; git checkout 4267ade09ac42c1bd0b84a5fa61af8ccdaadef48 &amp;&amp; env MAKE='make -j' shell/bootstrap-ocaml.sh &amp;&amp; make -C src_ext cache-archives
RUN cd /tmp/opam-sources &amp;&amp; cp -P -R -p . ../opam-build-2.0 &amp;&amp; cd ../opam-build-2.0 &amp;&amp; git fetch -q &amp;&amp; git checkout adc1e1829a2bef5b240746df80341b508290fe3b &amp;&amp; ln -s ../opam/src_ext/archives src_ext/archives &amp;&amp; env PATH="/tmp/opam/bootstrap/ocaml/bin:$PATH" ./configure --enable-cold-check &amp;&amp; env PATH="/tmp/opam/bootstrap/ocaml/bin:$PATH" make lib-ext all &amp;&amp; mkdir -p /usr/bin &amp;&amp; cp /tmp/opam-build-2.0/opam /usr/bin/opam-2.0 &amp;&amp; chmod a+x /usr/bin/opam-2.0 &amp;&amp; rm -rf /tmp/opam-build-2.0
RUN cd /tmp/opam-sources &amp;&amp; cp -P -R -p . ../opam-build-2.1 &amp;&amp; cd ../opam-build-2.1 &amp;&amp; git fetch -q &amp;&amp; git checkout 263921263e1f745613e2882745114b7b08f3608b &amp;&amp; ln -s ../opam/src_ext/archives src_ext/archives &amp;&amp; env PATH="/tmp/opam/bootstrap/ocaml/bin:$PATH" ./configure --enable-cold-check --with-0install-solver &amp;&amp; env PATH="/tmp/opam/bootstrap/ocaml/bin:$PATH" make lib-ext all &amp;&amp; mkdir -p /usr/bin &amp;&amp; cp /tmp/opam-build-2.1/opam /usr/bin/opam-2.1 &amp;&amp; chmod a+x /usr/bin/opam-2.1 &amp;&amp; rm -rf /tmp/opam-build-2.1
RUN cd /tmp/opam-sources &amp;&amp; cp -P -R -p . ../opam-build-2.2 &amp;&amp; cd ../opam-build-2.2 &amp;&amp; git fetch -q &amp;&amp; git checkout 01e9a24a61e23e42d513b4b775d8c30c807439b2 &amp;&amp; ln -s ../opam/src_ext/archives src_ext/archives &amp;&amp; env PATH="/tmp/opam/bootstrap/ocaml/bin:$PATH" ./configure --enable-cold-check --with-0install-solver --with-vendored-deps &amp;&amp; env PATH="/tmp/opam/bootstrap/ocaml/bin:$PATH" make lib-ext all &amp;&amp; mkdir -p /usr/bin &amp;&amp; cp /tmp/opam-build-2.2/opam /usr/bin/opam-2.2 &amp;&amp; chmod a+x /usr/bin/opam-2.2 &amp;&amp; rm -rf /tmp/opam-build-2.2
RUN cd /tmp/opam-sources &amp;&amp; cp -P -R -p . ../opam-build-2.3 &amp;&amp; cd ../opam-build-2.3 &amp;&amp; git fetch -q &amp;&amp; git checkout 35acd0c5abc5e66cdbd5be16ba77aa6c33a4c724 &amp;&amp; ln -s ../opam/src_ext/archives src_ext/archives &amp;&amp; env PATH="/tmp/opam/bootstrap/ocaml/bin:$PATH" ./configure --enable-cold-check --with-0install-solver --with-vendored-deps &amp;&amp; env PATH="/tmp/opam/bootstrap/ocaml/bin:$PATH" make lib-ext all &amp;&amp; mkdir -p /usr/bin &amp;&amp; cp /tmp/opam-build-2.3/opam /usr/bin/opam-2.3 &amp;&amp; chmod a+x /usr/bin/opam-2.3 &amp;&amp; rm -rf /tmp/opam-build-2.3
RUN cd /tmp/opam-sources &amp;&amp; cp -P -R -p . ../opam-build-master &amp;&amp; cd ../opam-build-master &amp;&amp; git fetch -q &amp;&amp; git checkout 4267ade09ac42c1bd0b84a5fa61af8ccdaadef48 &amp;&amp; ln -s ../opam/src_ext/archives src_ext/archives &amp;&amp; env PATH="/tmp/opam/bootstrap/ocaml/bin:$PATH" ./configure --enable-cold-check --with-0install-solver --with-vendored-deps &amp;&amp; env PATH="/tmp/opam/bootstrap/ocaml/bin:$PATH" make lib-ext all &amp;&amp; mkdir -p /usr/bin &amp;&amp; cp /tmp/opam-build-master/opam /usr/bin/opam-master &amp;&amp; chmod a+x /usr/bin/opam-master &amp;&amp; rm -rf /tmp/opam-build-master
</code></pre></div></div>

<p>Furthermore, after changing the opam version, we must run <code class="language-plaintext highlighter-rouge">opam init --reinit -ni</code>, which is an <em>expensive</em> command. If the base images defaulted to the current version, we would have faster builds.</p>

<p>The final benefit, of course, would be that we could set the <code class="language-plaintext highlighter-rouge">archive-mirror</code> and reduce the number of transient failures due to network outages.</p>

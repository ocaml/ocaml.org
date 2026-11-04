---
title: Moving Onto Mirage
description: Git Your Unikernel Here!
url: https://mort.io/blog/moving-onto-mirage/
date: 2015-05-20T00:00:00-00:00
preview_image:
authors:
- Richard Mortier
source:
ignore:
keywords:
- dev_remote
- fork_user
- mirage
- mirage_backend
- mirage_net
- mirageos
- mor1
- site
- travis
- unikernel
---

<p>For a little while I’ve had <a href="http://github.com/mor1/mor1.github.io" rel="external">this site</a> running as a <a href="http://openmirage.org/" rel="external">MirageOS</a>
unikernel, shadowing the main site hosted on <a href="http://github.com/" rel="external">GitHub</a>. I’ve finally decided to
make the switch, as part of moving over to take advantage of Mirage’s DNS and
TLS libraries.</p>
<p>Following the usual pattern, as previously explained by <a href="http://amirchaudhry.com/from-jekyll-to-unikernel-in-fifty-lines/" rel="external">Amir</a>, <a href="http://www.somerandomidiot.com/blog/2014/08/19/i-am-unikernel/" rel="external">Mindy</a> and
others, the process is:</p>
<ul>
<li>Construct a static <a href="http://jekyllrb.com" rel="external">Jekyll</a> site.</li>
<li>Write a <a href="http://travis-ci.com/" rel="external">Travis</a> YAML file to cause <a href="http://travis-ci.com/" rel="external">Travis</a> to build the unikernel image
and commit it back to the deployment repository.</li>
<li>Write a Git <code>post-merge</code> hook for the deployment repository, so that the
latest unikernel is automatically booted when a merge is detected, i.e., there
is a new unikernel image.</li>
<li>Write a <code>cron</code> job that periodically polls the deployment repository, pulling
any changes.</li>
</ul>
<p>Building a <a href="http://jekyllrb.com" rel="external">Jekyll</a> site is well-documented – I did find that I had to tweak
my <a href="https://github.com/mor1/mor1.github.io/blob/master/_config.yml" rel="external"><code>_config.yml</code></a> so as to make sure my local toolchain matched the
one used by Github, ensuring consistency between versions of the site. For
convenience:</p>
<pre class="giallo z-code"><code data-lang="shellscript"><span class="giallo-l"><span class="z-1">make</span><span class="z-2"> site</span></span></code></pre><h2><a href="https://mort.io/rss.xml#bringing-up-the-network" class="zola-anchor" aria-label="Anchor link for: bringing-up-the-network">Bringing up the network</a></h2>
<p>The <a href="https://github.com/mor1/mor1.github.io/blob/master/.travis.yml" rel="external"><code>.travis.yml</code></a> file then specifies the three main targets for
the CI test build to carry out: Unix with a standard sockets backed
(<code>MIRAGE_BACKEND=unix</code>, <code>MIRAGE_NET=socket</code>) and with the Mirage network stack
(<code>MIRAGE_BACKEND=unix</code>, <code>MIRAGE_NET=direct</code>), and with the Xen backend
(<code>MIRAGE_BACKEND=xen</code>). For the latter case, we must also specify the static IP
configuration to be used (<code>MIRAGE_ADDR</code>, <code>..._GWS</code>, and <code>..._MASK</code>). The
<a href="https://github.com/mor1/mor1.github.io/blob/master/.travis.sh" rel="external"><code>.travis.sh</code></a> script then calls the standard skeleton
<a href="https://github.com/ocaml/ocaml-travisci-skeleton/blob/master/.travis-mirage.sh" rel="external"><code>.travis-mirage.sh</code></a> script after first building the site
content using Jekyll.</p>
<p>This tests the three basic combinations of network backend for a Mirage
appliance:</p>
<pre class="giallo z-code"><code data-lang="shellscript"><span class="giallo-l"><span class="z-1">$</span><span class="z-2"> make configure.socket build</span></span></code></pre>
<ul>
<li><strong>UNIX/socket</strong> requires no configuration. The network device is configured
with the loopback address, <code>127.0.0.1</code>. Appliances can be run without
requiring <code>root</code> privileges, assuming they only bind to non-privileged ports.</li>
</ul>
<pre class="giallo z-code"><code data-lang="shellscript"><span class="giallo-l"><span class="z-1">$</span><span class="z-2"> make configure.direct build</span></span></code></pre>
<ul>
<li><strong>UNIX/direct/dhcp</strong> requires no configuration if a DHCP server is running and
can respond. The appliance must be run with <code>root</code> privileges to use the new
network bridging capability of OSX 10.10, whereupon the DHCP client in the
appliance follows the usual protocol.</li>
</ul>
<pre class="giallo z-code"><code data-lang="shellscript"><span class="giallo-l"><span class="z-1">$</span><span class="z-2"> make configure.xen build</span><span class="z-8"> \</span></span>
<span class="giallo-l"><span class="z-2">  ADDR="46.43.42.137" GWS="46.43.42.129" MASK="255.255.255.128"</span></span></code></pre>
<ul>
<li><strong>Xen</strong> uses the Mirage network stack and expects static configuration of the
network device.</li>
</ul>
<h2><a href="https://mort.io/rss.xml#using-travis-ci" class="zola-anchor" aria-label="Anchor link for: using-travis-ci">Using Travis CI</a></h2>
<p>Of course, all that is for local development – for the live site, this is
actually all wrapped up using <a href="http://travis-ci.com/" rel="external">Travis CI</a>. Due to a small pull request
waiting on the <a href="https://github.com/ocaml/ocaml-travisci-skeleton" rel="external">OCaml Travis CI skeleton scripts</a> and a few
Mirage releases currently being readied, this looks a little more complex than
it needs to (the <code>FORK_USER</code> and <code>DEV_REMOTE</code> variables shouldn’t need to be
specified in the long run) but anyway:</p>
<pre class="giallo z-code"><code data-lang="yaml"><span class="giallo-l"><span class="z-1">language</span><span>:</span><span class="z-2"> c</span></span>
<span class="giallo-l"><span class="z-1">script</span><span>:</span><span class="z-2"> bash -ex .travis.sh</span></span>
<span class="giallo-l"><span class="z-1">env</span><span>:</span></span>
<span class="giallo-l"><span class="z-1">  matrix</span><span>:</span></span>
<span class="giallo-l"><span>  -</span><span class="z-2"> FORK_USER=mor1 DEV_REMOTE=git://github.com/mirage/mirage-dev</span></span>
<span class="giallo-l"><span class="z-2">    OCAML_VERSION=4.02 MIRAGE_BACKEND=unix MIRAGE_NET=socket</span></span>
<span class="giallo-l"><span>  -</span><span class="z-2"> FORK_USER=mor1 DEV_REMOTE=git://github.com/mirage/mirage-dev</span></span>
<span class="giallo-l"><span class="z-2">    OCAML_VERSION=4.02 MIRAGE_BACKEND=unix MIRAGE_NET=direct</span></span>
<span class="giallo-l"><span>  -</span><span class="z-2"> FORK_USER=mor1 DEV_REMOTE=git://github.com/mirage/mirage-dev</span></span>
<span class="giallo-l"><span class="z-2">    UPDATE_GCC_BINUTILS=1</span></span>
<span class="giallo-l"><span class="z-2">    OCAML_VERSION=4.02 MIRAGE_BACKEND=xen</span></span>
<span class="giallo-l"><span class="z-2">    MIRAGE_ADDR="46.43.42.137" MIRAGE_GWS="46.43.42.129" MIRAGE_MASK="255.255.255.128"</span></span>
<span class="giallo-l"><span class="z-2">    XENIMG=mortio MIRDIR=_mirage DEPLOY=1</span></span></code></pre>
<p>This uses the local <a href="https://github.com/mor1/mor1.github.io/blob/master/.travis.sh" rel="external"><code>.travis-sh</code></a> script to build the three versions
of the site, using the <a href="https://github.com/mirage/mirage-dev" rel="external">Mirage development OPAM repository</a> so as to
pick up the latest versions of all the various packages, and updating the Travis
<code>gcc</code> and <code>binutils</code> to ensure the stubs for a couple of packages (notably
<code>mirage-entropy-xen</code>) build.</p>
<p>Next stop: adding TLS and DNS support…</p>

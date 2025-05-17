---
title: Using Docker to bulk-build OPAM packages on Linux
description: Build OPAM packages in bulk on Linux using Docker containers.
url: https://anil.recoil.org/notes/docker-and-opam
date: 2013-11-15T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<p>Now that OCaml 4.01 has been released, there is a frenzy of commit
activity in the <a href="https://github.com/ocaml/ocaml">development trunk</a> of
OCaml as the new features for 4.02 are all integrated. These include
some enhancements to the type system such as
<a href="http://ocaml.org/meetings/ocaml/2013/slides/garrigue.pdf">injectivity</a>,
<a href="http://caml.inria.fr/mantis/view.php?id=6063">module aliases</a> and
<a href="http://ocaml.org/meetings/ocaml/2013/slides/white.pdf">extension
points</a> as a
simpler alternative to syntax extensions.</p>
<p>The best way to ensure that these all play well together is to test
against the ever-growing OPAM package database as early as possible.
While we’re working on more elaborate <a href="https://web.archive.org/web/20181114154831/https://anil.recoil.org/2013/09/30/travis-and-ocaml.html">continuous
building</a>
solutions, it’s far easier if a developer can quickly run a bulk build
on their own system. The difficulty with doing this is that you also
need to install all the external dependencies (e.g. libraries and header
files for bindings) needed by the thousands of packages in OPAM.</p>
<p>Enter a hip new lightweight container system called
<a href="http://docker.io">Docker</a>. While containers aren’t quite as secure as
<a href="http://en.wikipedia.org/wiki/Hypervisor">type-1 hypervisors</a> such as
<a href="http://xenproject.org">Xen</a>, they are brilliant for spawning lots of
lightweight tasks such as installing (and reverting) package
installations. Docker is still under heavy development, but it didn’t
take me long to follow the documentation and put together a
configuration file for creating an OCaml+OPAM image to let OCaml
developers do these bulk builds.</p>
<h2>A basic Docker and OPAM setup</h2>
<p>I started by spinning up a fresh Ubuntu Saucy VM on the <a href="https://rackspace.com">Rackspace
Cloud</a>, which has a recent enough kernel version
to work out-of-the-box with Docker. The <a href="http://docs.docker.io/en/latest/installation/ubuntulinux/#ubuntu-raring">installation
instructions</a>
worked without any problems.</p>
<p>Next, I created a
<a href="http://docs.docker.io/en/latest/use/builder/#dockerfiles-for-images">Dockerfile</a>
to represent the set of commands needed to prepare the base Ubuntu image
with an OPAM and OCaml environment. You can find the complete repository
online at
<strong><a href="https://github.com/avsm/docker-opam">https://github.com/avsm/docker-opam</a></strong>.
Let’s walk through the <code>Dockerfile</code> in chunks.</p>
<pre><code>FROM ubuntu:latest
MAINTAINER Anil Madhavapeddy &lt;anil@recoil.org&gt;
RUN apt-get -y install sudo pkg-config git build-essential m4 software-properties-common
RUN git config --global user.email "docker@example.com"
RUN git config --global user.name "Docker CI"
RUN apt-get -y install python-software-properties
RUN echo "yes" | add-apt-repository ppa:avsm/ocaml41+opam11
RUN apt-get -y update -qq
RUN apt-get -y install -qq ocaml ocaml-native-compilers camlp4-extra opam
ADD opam-installext /usr/bin/opam-installext
</code></pre>
<p>This sets up a basic OCaml and OPAM environment using the same Ubuntu
PPAs as the <a href="https://web.archive.org/web/20181114154831/https://anil.recoil.org/2013/09/30/travis-and-ocaml.html">Travis
instructions</a> I
posted a few months ago. The final command adds a helper script which
uses the new <code>depexts</code> feature in OPAM 1.1 to also install operating
system packages that are required by some libraries. I’ll explain in
more detail in a later post, but for now all you need to know is that
<code>opam installext ctypes</code> will not only install the <code>ctypes</code> OCaml
library, but also invoke <code>apt-get install libffi-dev</code> to install the
relevant development library first.</p>
<pre><code>RUN adduser --disabled-password --gecos "" opam
RUN passwd -l opam
ADD opamsudo /etc/sudoers.d/opam
USER opam
ENV HOME /home/opam
ENV OPAMVERBOSE 1
ENV OPAMYES 1
</code></pre>
<p>The next chunk of the Dockerfile configures the OPAM environment by
installing a non-root user (several OPAM packages fail with an error if
configured as root). We also set the <code>OPAMVERBOSE</code> and <code>OPAMYES</code>
variables to ensure we get the full build logs and non-interactive use,
respectively.</p>
<h2>Running the bulk tests</h2>
<p>We’re now set to build a Docker environment for the exact test that we
want to run.</p>
<pre><code>RUN opam init git://github.com/mirage/opam-repository#add-depexts-11
RUN opam install ocamlfind
ENTRYPOINT ["usr/bin/opam-installext"]
</code></pre>
<p>This last addition to the <code>Dockerfile</code> initializes our OPAM package set.
This is using my development branch which adds a <a href="https://github.com/ocaml/opam-repository/pull/1240">massive
diff</a> to populate
the OPAM metadata with external dependency information for Ubuntu and
Debian.</p>
<p>Building an image from this is a single command:</p>
<pre><code class="language-bash">$ docker build -t avsm/opam github.com/avsm/docker-opam
</code></pre>
<p>The <code>ENTRYPOINT</code> tells Docker that our wrapper script is the “root
command” to run for this container, so we can install a package in a
container by doing this:</p>
<pre><code class="language-bash">$ docker run avsm/opam ctypes
</code></pre>
<p>The complete output is logged to stdout and stderr, so we can capture
that as easily as a normal shell command. With all these pieces in
place, my local bulk build shell script is trivial:</p>
<pre><code class="language-bash">pkg=`opam list -s -a`
RUN=5
mkdir -p /log/$RUN/raw /log/$RUN/err /log/$RUN/ok
for p in $pkg; do
  docker run avsm/opam $p &gt; /log/$RUN/raw/$p 2&gt;&amp;1
  if [ $? != 0 ]; then
    ln -s /log/$RUN/raw/$p /log/$RUN/err/$p
  else
    ln -s /log/$RUN/raw/$p /log/$RUN/ok/$p
  fi
done  
</code></pre>
<p>This iterates through a local package set and serially builds
everything. Future enhancements I’m working on: parallelising these on a
multicore box, and having a <a href="http://blog.docker.io/2013/10/docker-0-6-5-links-container-naming-advanced-port-redirects-host-integration/">linked
container</a>
that hosts a local package repository so that we don’t require a lot of
external bandwidth. Stay tuned!</p>


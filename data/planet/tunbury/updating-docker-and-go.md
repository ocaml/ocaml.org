---
title: Updating Docker and Go
description: For some time, we have had issues on Ubuntu Noble when extracting tar
  files within Docker containers. See ocaml/infrastructure#121. This is only an issue
  on exotic architectures like RISCV and PPC64LE.
url: https://www.tunbury.org/2025/04/01/go-docker/
date: 2025-04-01T00:00:00-00:00
preview_image: https://www.tunbury.org/images/docker-logo.png
authors:
- Mark Elvers
source:
ignore:
---

<p>For some time, we have had issues on Ubuntu Noble when extracting
tar files within Docker containers. See
<a href="https://github.com/ocaml/infrastructure/issues/121">ocaml/infrastructure#121</a>.
This is only an issue on exotic architectures like RISCV and PPC64LE.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c"># docker run --rm -it ubuntu:noble</span>
root@cf3491db4abd:/# <span class="nb">cd
</span>root@cf3491db4abd:~# <span class="nb">mkdir </span>foo
root@cf3491db4abd:~# <span class="nb">tar</span> <span class="nt">-cf</span> bar.tar foo
root@cf3491db4abd:~# <span class="nb">rmdir </span>foo
root@cf3491db4abd:~# <span class="nb">tar</span> <span class="nt">-xf</span> bar.tar
<span class="nb">tar</span>: foo: Cannot change mode to rwxr-xr-x: Operation not permitted
<span class="nb">tar</span>: Exiting with failure status due to previous errors
</code></pre></div></div>

<p>The combination of Docker version and <code class="language-plaintext highlighter-rouge">libseccomp2</code> version prevents
the container from running the <code class="language-plaintext highlighter-rouge">fchmodat2</code> system call. There is a
bug report on Ubuntu’s bug tracker for the issue.</p>

<p>I have been working around this by building Docker from scratch.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>apt <span class="nb">install </span>golang
git clone https://github.com/moby/moby
<span class="nb">cd </span>moby
<span class="nv">AUTO_GOPATH</span><span class="o">=</span>1 ./hack/make.sh binary
<span class="nb">mv </span>bundles/binary-daemon/<span class="k">*</span> /usr/bin/
service docker restart
</code></pre></div></div>

<p>When provisioning some new RISCV machines, I have once again hit this
issue, but now the version of Go installed by <code class="language-plaintext highlighter-rouge">apt</code> on Ubuntu Noble is
too old to build Docker!</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>go: vendor.mod requires go &gt;= 1.23.0 (running go 1.22.2; GOTOOLCHAIN=local)
</code></pre></div></div>

<p>As this needs to be repeated multiple times, it makes sense
to wrap the installation steps into an Ansible Playbook.
<a href="https://gist.github.com/mtelvers/ced9d981b9137c491c95780390ce802c">golang+docker.yml</a></p>

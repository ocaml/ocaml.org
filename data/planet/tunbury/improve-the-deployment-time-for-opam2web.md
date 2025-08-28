---
title: Improve the deployment time for opam2web
description: The opam2web image for opam.ocaml.org is huge weighing in at more than
  25 GB. The bulk of this data is opam archives, which are updated and copied into
  a stock caddy image.
url: https://www.tunbury.org/2025/06/24/opam2web/
date: 2025-06-24T00:00:00-00:00
preview_image: https://www.tunbury.org/images/opam.png
authors:
- Mark Elvers
source:
ignore:
---

<p>The opam2web image for <a href="https://opam.ocaml.org">opam.ocaml.org</a> is huge weighing in at more than 25 GB. The bulk of this data is opam archives, which are updated and copied into a stock caddy image.</p>

<p>There are two archives, <code class="language-plaintext highlighter-rouge">ocaml/opam.ocaml.org-legacy</code>, which hasn’t changed for 5 years and holds the cache for opam 1.x and <code class="language-plaintext highlighter-rouge">ocaml/opam:archive</code>, which is updated weekly.</p>

<p>The current <code class="language-plaintext highlighter-rouge">Dockerfile</code> copies these files into a new layer each time opam2web builds.</p>

<div class="language-dockerfile highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">FROM</span><span class="w"> </span><span class="s">--platform=linux/amd64 ocaml/opam:archive</span><span class="w"> </span><span class="k">as</span><span class="w"> </span><span class="s">opam-archive</span>
<span class="k">FROM</span><span class="w"> </span><span class="s">ocaml/opam.ocaml.org-legacy</span><span class="w"> </span><span class="k">as</span><span class="w"> </span><span class="s">opam-legacy</span>
<span class="k">FROM</span><span class="w"> </span><span class="s">alpine:3.20</span><span class="w"> </span><span class="k">as</span><span class="w"> </span><span class="s">opam2web</span>
...
<span class="k">COPY</span><span class="s"> --from=opam-legacy . /www</span>
...
<span class="k">RUN </span><span class="nt">--mount</span><span class="o">=</span><span class="nb">type</span><span class="o">=</span><span class="nb">bind</span>,target<span class="o">=</span>/cache,from<span class="o">=</span>opam-archive rsync <span class="nt">-aH</span> /cache/cache/ /www/cache/
...
</code></pre></div></div>

<p>And later, the entire <code class="language-plaintext highlighter-rouge">/www</code> structure is copied into a <code class="language-plaintext highlighter-rouge">caddy:2.8.4</code> image.</p>

<div class="language-dockerfile highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">FROM</span><span class="s"> caddy:2.8.4</span>
<span class="k">WORKDIR</span><span class="s"> /srv</span>
<span class="k">COPY</span><span class="s"> --from=opam2web /www /usr/share/caddy</span>
<span class="k">COPY</span><span class="s"> Caddyfile /etc/caddy/Caddyfile</span>
<span class="k">ENTRYPOINT</span><span class="s"> ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]</span>
</code></pre></div></div>

<p>This method is considered “best practice” when creating Docker images, but in this case, it produces a very large image, which takes a long time to deploy.</p>

<p>For Docker to use an existing layer, we need the final <code class="language-plaintext highlighter-rouge">FROM ...</code> to be the layer we want to use as the base. In the above snippet, the <code class="language-plaintext highlighter-rouge">caddy:2.8.4</code> layer will be the base layer and will be reused.</p>

<p>The archive, <code class="language-plaintext highlighter-rouge">ocaml/opam:archive</code>, is created by this Dockerfile, which ultimately uses <code class="language-plaintext highlighter-rouge">alpine:latest</code>.</p>

<div class="language-dockerfile highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">FROM</span><span class="w"> </span><span class="s">ocaml/opam:archive</span><span class="w"> </span><span class="k">AS</span><span class="w"> </span><span class="s">opam-archive</span>
<span class="k">FROM</span><span class="w"> </span><span class="s">ocurrent/opam-staging@sha256:f921cd51dda91f61a52a2c26a8a188f8618a2838e521d3e4afa3ca1da637903e</span><span class="w"> </span><span class="k">AS</span><span class="w"> </span><span class="s">archive</span>
<span class="k">WORKDIR</span><span class="s"> /home/opam/opam-repository</span>
<span class="k">RUN </span><span class="nt">--mount</span><span class="o">=</span><span class="nb">type</span><span class="o">=</span><span class="nb">bind</span>,target<span class="o">=</span>/cache,from<span class="o">=</span>opam-archive rsync <span class="nt">-aH</span> /cache/cache/ /home/opam/opam-repository/cache/
<span class="k">RUN </span>opam admin cache <span class="nt">--link</span><span class="o">=</span>/home/opam/opam-repository/cache

<span class="k">FROM</span><span class="s"> alpine:latest</span>
<span class="k">COPY</span><span class="s"> --chown=0:0 --from=archive [ "/home/opam/opam-repository/cache", "/cache" ]</span>
</code></pre></div></div>

<p>In our opam2web build, we could use <code class="language-plaintext highlighter-rouge">FROM ocaml/opam:archive</code> and then <code class="language-plaintext highlighter-rouge">apk add caddy</code>, which would reuse the entire 15GB layer and add the few megabytes for <code class="language-plaintext highlighter-rouge">caddy</code>.</p>

<p><code class="language-plaintext highlighter-rouge">ocaml/opam.ocaml.org-legacy</code> is another 8GB. This legacy data could be integrated by adding it to <code class="language-plaintext highlighter-rouge">ocaml/opam:archive</code> in a different directory to ensure compatibility with anyone else using this image. This is <a href="https://github.com/ocurrent/docker-base-images/pull/324">PR#324</a></p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code> <span class="k">let</span> <span class="n">install_package_archive</span> <span class="n">opam_image</span> <span class="o">=</span>
   <span class="k">let</span> <span class="k">open</span> <span class="nc">Dockerfile</span> <span class="k">in</span>
<span class="o">+</span>  <span class="n">from</span> <span class="o">~</span><span class="n">alias</span><span class="o">:</span><span class="s2">"opam-legacy"</span> <span class="s2">"ocaml/opam.ocaml.org-legacy"</span> <span class="o">@@</span>
   <span class="n">from</span> <span class="o">~</span><span class="n">alias</span><span class="o">:</span><span class="s2">"opam-archive"</span> <span class="s2">"ocaml/opam:archive"</span> <span class="o">@@</span>
   <span class="n">from</span> <span class="o">~</span><span class="n">alias</span><span class="o">:</span><span class="s2">"archive"</span> <span class="n">opam_image</span> <span class="o">@@</span>
   <span class="n">workdir</span> <span class="s2">"/home/opam/opam-repository"</span> <span class="o">@@</span>
   <span class="n">run</span> <span class="o">~</span><span class="n">mounts</span><span class="o">:</span><span class="p">[</span><span class="n">mount_bind</span> <span class="o">~</span><span class="n">target</span><span class="o">:</span><span class="s2">"/cache"</span> <span class="o">~</span><span class="n">from</span><span class="o">:</span><span class="s2">"opam-archive"</span> <span class="bp">()</span><span class="p">]</span> <span class="s2">"rsync -aH /cache/cache/ /home/opam/opam-repository/cache/"</span> <span class="o">@@</span>
   <span class="n">run</span> <span class="s2">"opam admin cache --link=/home/opam/opam-repository/cache"</span> <span class="o">@@</span>
   <span class="n">from</span> <span class="s2">"alpine:latest"</span> <span class="o">@@</span>
<span class="o">+</span>  <span class="n">copy</span> <span class="o">~</span><span class="n">chown</span><span class="o">:</span><span class="s2">"0:0"</span> <span class="o">~</span><span class="n">from</span><span class="o">:</span><span class="s2">"opam-legacy"</span> <span class="o">~</span><span class="n">src</span><span class="o">:</span><span class="p">[</span><span class="s2">"/"</span><span class="p">]</span> <span class="o">~</span><span class="n">dst</span><span class="o">:</span><span class="s2">"/legacy"</span> <span class="bp">()</span> <span class="o">@@</span>
   <span class="n">copy</span> <span class="o">~</span><span class="n">chown</span><span class="o">:</span><span class="s2">"0:0"</span> <span class="o">~</span><span class="n">from</span><span class="o">:</span><span class="s2">"archive"</span> <span class="o">~</span><span class="n">src</span><span class="o">:</span><span class="p">[</span><span class="s2">"/home/opam/opam-repository/cache"</span><span class="p">]</span> <span class="o">~</span><span class="n">dst</span><span class="o">:</span><span class="s2">"/cache"</span> <span class="bp">()</span>
</code></pre></div></div>

<p>Finally, we need to update <a href="https://github.com/ocaml-opam/opam2web">opam2web</a> to use <code class="language-plaintext highlighter-rouge">ocaml/opam:archive</code> as the base layer rather than <code class="language-plaintext highlighter-rouge">caddy:2.8.4</code>, resulting in the final part of the <code class="language-plaintext highlighter-rouge">Dockerfile</code> looking like this.</p>

<div class="language-dockerfile highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">FROM</span><span class="s"> ocaml/opam:archive</span>
<span class="k">RUN </span>apk add <span class="nt">--update</span> git curl rsync libstdc++ rdfind caddy
<span class="k">COPY</span><span class="s"> --from=build-opam2web /opt/opam2web /usr/local</span>
<span class="k">COPY</span><span class="s"> --from=build-opam-doc /usr/bin/opam-dev /usr/local/bin/opam</span>
<span class="k">COPY</span><span class="s"> --from=build-opam-doc /opt/opam/doc /usr/local/share/opam2web/content/doc</span>
<span class="k">COPY</span><span class="s"> ext/key/opam-dev-team.pgp /www/opam-dev-pubkey.pgp</span>
<span class="k">ADD</span><span class="s"> bin/opam-web.sh /usr/local/bin</span>
<span class="k">ARG</span><span class="s"> DOMAIN=opam.ocaml.org</span>
<span class="k">ARG</span><span class="s"> OPAM_REPO_GIT_SHA=master</span>
<span class="k">ARG</span><span class="s"> BLOG_GIT_SHA=master</span>
<span class="k">RUN </span><span class="nb">echo</span> <span class="k">${</span><span class="nv">OPAM_REPO_GIT_SHA</span><span class="k">}</span> <span class="o">&gt;&gt;</span> /www/opam_git_sha
<span class="k">RUN </span><span class="nb">echo</span> <span class="k">${</span><span class="nv">BLOG_GIT_SHA</span><span class="k">}</span> <span class="o">&gt;&gt;</span> /www/blog_git_sha
<span class="k">RUN </span>/usr/local/bin/opam-web.sh <span class="k">${</span><span class="nv">DOMAIN</span><span class="k">}</span> <span class="k">${</span><span class="nv">OPAM_REPO_GIT_SHA</span><span class="k">}</span> <span class="k">${</span><span class="nv">BLOG_GIT_SHA</span><span class="k">}</span>
<span class="k">WORKDIR</span><span class="s"> /srv</span>
<span class="k">COPY</span><span class="s"> Caddyfile /etc/caddy/Caddyfile</span>
<span class="k">ENTRYPOINT</span><span class="s"> ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]</span>
</code></pre></div></div>

<p>I acknowledge that this final image now contains some extra unneeded packages such as <code class="language-plaintext highlighter-rouge">git</code>, <code class="language-plaintext highlighter-rouge">curl</code>, etc, but this seems a minor inconvenience.</p>

<p>The <code class="language-plaintext highlighter-rouge">Caddyfile</code> can be adjusted to make everything still appear to be in the same place:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>:80 {
	redir /install.sh https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh
	redir /install.ps1 https://raw.githubusercontent.com/ocaml/opam/master/shell/install.ps1

	@version_paths path /1.1/* /1.2.0/* /1.2.2/*
	handle @version_paths {
		root * /legacy
		file_server
	}

	handle /cache/* {
		root * /
		file_server
	}

	handle {
		root * /www
		file_server
	}
}
</code></pre></div></div>

<p>In this configuration, the Docker <em>push</em> is only 650MB rather than 25GB.</p>

<p>The changes to opam2web are in <a href="https://github.com/ocaml-opam/opam2web/pull/245">PR#245</a></p>

<p>Test with some external URLs:</p>

<ul>
  <li><a href="https://staging.opam.ocaml.org/index.tar.gz">https://staging.opam.ocaml.org/index.tar.gz</a></li>
  <li><a href="https://staging.opam.ocaml.org/archives/0install.2.18/0install-2.18.tbz">https://staging.opam.ocaml.org/archives/0install.2.18/0install-2.18.tbz</a></li>
  <li><a href="https://staging.opam.ocaml.org/cache/0install.2.18/0install-2.18.tbz">https://staging.opam.ocaml.org/cache/0install.2.18/0install-2.18.tbz</a></li>
  <li><a href="https://staging.opam.ocaml.org/1.2.2/archives/0install.2.12.3+opam.tar.gz">https://staging.opam.ocaml.org/1.2.2/archives/0install.2.12.3+opam.tar.gz</a></li>
  <li><a href="https://staging.opam.ocaml.org/1.2.0/archives/0install.2.12.1+opam.tar.gz">https://staging.opam.ocaml.org/1.2.0/archives/0install.2.12.1+opam.tar.gz</a></li>
  <li><a href="https://staging.opam.ocaml.org/1.1/archives/0install.2.10+opam.tar.gz">https://staging.opam.ocaml.org/1.1/archives/0install.2.10+opam.tar.gz</a></li>
  <li><a href="https://staging.opam.ocaml.org/opam_git_sha">https://staging.opam.ocaml.org/opam_git_sha</a></li>
  <li><a href="https://staging.opam.ocaml.org/blog_git_sha">https://staging.opam.ocaml.org/blog_git_sha</a></li>
  <li><a href="https://staging.opam.ocaml.org/opam-dev-pubkey.pgp">https://staging.opam.ocaml.org/opam-dev-pubkey.pgp</a></li>
</ul>

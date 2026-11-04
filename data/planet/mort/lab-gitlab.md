---
title: Lab GitLab
description: Installing a GitLab VM in the Computer Lab
url: https://mort.io/blog/lab-gitlab/
date: 2017-04-19T00:00:00-00:00
preview_image:
authors:
- Richard Mortier
source:
ignore:
keywords:
- cam
- daemon
- docker
- gitlab
- hello-world
- irb
- nil
- secretpassword
- srg
- sudo
---

<p>Recently had cause to do this as part of the <a href="https://www.cl.cam.ac.uk/research/srg/" rel="external">SRG’s</a> and <a href="https://ocamllabs.io/" rel="external">OCaml Labs</a>
infrastructure. Thought it might be useful to make some notes, so here they are!
Assuming your local <code>sys-admin</code> has kindly created you a suitable VM running
Ubuntu with login credentials, etc, read on…</p>
<p>Note that several commands that follow must be run as <code>root</code>, via use of <code>sudo</code>
below. Given that, think twice before just cutting and pasting them in,
obviously… And I am not held responsible for anything either way!</p>
<h2><a href="https://mort.io/rss.xml#install-docker" class="zola-anchor" aria-label="Anchor link for: install-docker">Install Docker</a></h2>
<p>On a new Ubuntu stretch/sid (testing) VM:</p>
<pre class="giallo z-code"><code data-lang="shellscript"><span class="giallo-l"><span class="z-1">$</span><span class="z-2"> lsb_release</span><span class="z-8"> -drc</span></span>
<span class="giallo-l"><span class="z-1">Description:</span><span class="z-2">	Ubuntu</span><span class="z-9"> 16.04.1</span><span class="z-2"> LTS</span></span>
<span class="giallo-l"><span class="z-1">Release:</span><span class="z-9">	16.04</span></span>
<span class="giallo-l"><span class="z-1">Codename:</span><span class="z-2">	xenial</span></span></code></pre>
<p>Next, install up-to-date <a href="https://docker.com/" rel="external">Docker</a>:</p>
<pre class="giallo z-code"><code data-lang="shellscript"><span class="giallo-l"><span class="z-1">sudo</span><span class="z-2"> apt-get install apt-transport-https ca-certificates</span></span>
<span class="giallo-l"><span class="z-1">apt-key</span><span class="z-2"> adv</span><span class="z-8"> --keyserver</span><span class="z-2"> hkp://p80.pool.sks-keyservers.net:80</span><span class="z-8"> \</span></span>
<span class="giallo-l"><span class="z-8">        --recv-keys</span><span class="z-2"> 58118E89F3A912897C070ADBF76221572C52609D</span></span>
<span class="giallo-l"><span class="z-1">sudo</span><span class="z-2"> echo "deb https://apt.dockerproject.org/repo debian-stretch main"</span><span class="z-8"> \</span></span>
<span class="giallo-l"><span class="z-5">     &gt;</span><span class="z-2"> /etc/apt/sources.list.d/docker.list</span></span>
<span class="giallo-l"><span class="z-1">sudo</span><span class="z-2"> apt-get update</span></span>
<span class="giallo-l"><span class="z-1">sudo</span><span class="z-2"> apt-get install</span><span class="z-8"> -y</span><span class="z-2"> docker-engine</span></span></code></pre>
<p>Tweak the <code>systemd</code> <a href="https://docker.com/" rel="external">Docker</a> configuration by adding a fragment to point
all <a href="https://docker.com/" rel="external">Docker</a> to the <code>/data</code> partition, lest the root partition <code>/</code> fill:</p>
<pre class="giallo z-code"><code data-lang="shellscript"><span class="giallo-l"><span class="z-1">cat</span><span class="z-5"> &gt;</span><span class="z-2"> /etc/systemd/system/docker.service.d/data-disk.conf</span><span class="z-5"> &lt;&lt;</span><span>EOF</span></span>
<span class="giallo-l"><span class="z-2">[Service]</span></span>
<span class="giallo-l"><span class="z-2">ExecStart=</span></span>
<span class="giallo-l"><span class="z-2">ExecStart=/usr/bin/dockerd -H fd:// -g /data/docker</span></span>
<span class="giallo-l"><span>EOF</span></span></code></pre>
<p>Then start the <a href="https://docker.com/" rel="external">Docker</a> daemon and run <code>hello-world</code> just to check all is
well:</p>
<pre class="giallo z-code"><code data-lang="shellscript"><span class="giallo-l"><span class="z-1">sudo</span><span class="z-2"> systemctl daemon-reload</span></span>
<span class="giallo-l"><span class="z-1">sudo</span><span class="z-2"> service docker start</span></span></code></pre>
<p>Finally, test the install by running <code>hello-world</code>:</p>
<pre class="giallo z-code"><code data-lang="shellscript"><span class="giallo-l"><span class="z-1">$</span><span class="z-2"> docker run hello-world</span></span>
<span class="giallo-l"></span>
<span class="giallo-l"><span class="z-1">Hello</span><span class="z-2"> from Docker!</span></span>
<span class="giallo-l"><span class="z-1">This</span><span class="z-2"> message shows that your installation appears to be working correctly.</span></span>
<span class="giallo-l"></span>
<span class="giallo-l"><span class="z-1">To</span><span class="z-2"> generate this message, Docker took the following steps:</span></span>
<span class="giallo-l"><span class="z-1"> 1.</span><span class="z-2"> The Docker client contacted the Docker daemon.</span></span>
<span class="giallo-l"><span class="z-1"> 2.</span><span class="z-2"> The Docker daemon pulled the "hello-world" image from the Docker Hub.</span></span>
<span class="giallo-l"><span class="z-1"> 3.</span><span class="z-2"> The Docker daemon created a new container from that image which runs the</span></span>
<span class="giallo-l"><span class="z-1">    executable</span><span class="z-2"> that produces the output you are currently reading.</span></span>
<span class="giallo-l"><span class="z-1"> 4.</span><span class="z-2"> The Docker daemon streamed that output to the Docker client, which sent it</span></span>
<span class="giallo-l"><span class="z-1">    to</span><span class="z-2"> your terminal.</span></span>
<span class="giallo-l"></span>
<span class="giallo-l"><span class="z-1">To</span><span class="z-2"> try something more ambitious, you can run an Ubuntu container with:</span></span>
<span class="giallo-l"><span class="z-1"> $</span><span class="z-2"> docker run</span><span class="z-8"> -it</span><span class="z-2"> ubuntu bash</span></span>
<span class="giallo-l"></span>
<span class="giallo-l"><span class="z-1">Share</span><span class="z-2"> images, automate workflows, and more with a free Docker Hub account:</span></span>
<span class="giallo-l"><span class="z-1"> https://hub.docker.com</span></span>
<span class="giallo-l"></span>
<span class="giallo-l"><span class="z-1">For</span><span class="z-2"> more examples and ideas, visit:</span></span>
<span class="giallo-l"><span class="z-1"> https://docs.docker.com/engine/userguide/</span></span></code></pre>
<p>If appropriate, you may also wish to add yourself to the <code>docker</code> user group:</p>
<pre class="giallo z-code"><code data-lang="shellscript"><span class="giallo-l"><span class="z-1">sudo</span><span class="z-2"> usermod</span><span class="z-8"> -aG</span><span class="z-2"> docker</span><span> $(</span><span class="z-1">whoami</span><span>)</span></span></code></pre><h2><a href="https://mort.io/rss.xml#gitlab" class="zola-anchor" aria-label="Anchor link for: gitlab">GitLab</a></h2>
<p>Assuming you have rights to run <code>docker</code>, install and run Gitlab-CE:</p>
<pre class="giallo z-code"><code data-lang="shellscript"><span class="giallo-l"><span class="z-1">S</span><span class="z-5">=</span><span class="z-2">128.232.xxx.yyy</span></span>
<span class="giallo-l"><span class="z-1">H</span><span class="z-5">=</span><span class="z-2">gitlab.srg.cl.cam.ac.uk</span></span>
<span class="giallo-l"><span class="z-1">docker</span><span class="z-2"> run</span><span class="z-8"> --detach \</span></span>
<span class="giallo-l"><span class="z-8">     --hostname</span><span class="z-1"> $H</span><span class="z-8"> \</span></span>
<span class="giallo-l"><span class="z-8">     --publish</span><span class="z-1"> $S</span><span class="z-2">:443:443</span><span class="z-8"> \</span></span>
<span class="giallo-l"><span class="z-8">     --publish</span><span class="z-1"> $S</span><span class="z-2">:80:80</span><span class="z-8"> \</span></span>
<span class="giallo-l"><span class="z-8">     --publish</span><span class="z-1"> $S</span><span class="z-2">:2222:22</span><span class="z-8"> \</span></span>
<span class="giallo-l"><span class="z-8">     --name</span><span class="z-2"> gitlab</span><span class="z-8"> \</span></span>
<span class="giallo-l"><span class="z-8">     --restart</span><span class="z-2"> always</span><span class="z-8"> \</span></span>
<span class="giallo-l"><span class="z-8">     --volume</span><span class="z-2"> /data/gitlab/config:/etc/gitlab</span><span class="z-8"> \</span></span>
<span class="giallo-l"><span class="z-8">     --volume</span><span class="z-2"> /data/gitlab/logs:/var/log/gitlab</span><span class="z-8"> \</span></span>
<span class="giallo-l"><span class="z-8">     --volume</span><span class="z-2"> /data/gitlab/data:/var/opt/gitlab</span><span class="z-8"> \</span></span>
<span class="giallo-l"><span class="z-8">     --volume</span><span class="z-2"> /data/gitlab/backups:/var/opt/gitlab/backups</span><span class="z-8"> \</span></span>
<span class="giallo-l"><span class="z-8">     --volume</span><span class="z-2"> /data/gitlab/sync:/var/opt/gitlab/sync</span><span class="z-8"> \</span></span>
<span class="giallo-l"><span class="z-8">     --env</span><span class="z-2"> HOST_UID=</span><span class="z-1">$$</span><span>(</span><span class="z-1">id</span><span class="z-8"> -u</span><span>)</span><span class="z-8"> --env</span><span class="z-2"> HOST_GID=</span><span class="z-1">$$</span><span>(</span><span class="z-1">id</span><span class="z-8"> -g</span><span>)</span><span class="z-8"> \</span></span>
<span class="giallo-l"><span class="z-2">     mor1/gitlab-ce-cron:latest</span></span></code></pre>
<p>…or use the <code>make start</code> target in the
<a href="https://github.com/mor1/dockerfiles/blob/master/gitlab-ce-cron/Makefile" rel="external">Makefile</a>
in the related <a href="https://github.com/mor1/dockerfiles/tree/master/gitlab-ce-cron" rel="external">GitHub
repo</a>.</p>
<h2><a href="https://mort.io/rss.xml#tls-certificates" class="zola-anchor" aria-label="Anchor link for: tls-certificates">TLS Certificates</a></h2>
<p>Self-certified certificates:</p>
<pre class="giallo z-code"><code data-lang="shellscript"><span class="giallo-l"><span class="z-1">openssl</span><span class="z-2"> req</span><span class="z-8"> -nodes -newkey</span><span class="z-2"> rsa:2048</span><span class="z-8"> -keyout</span><span class="z-2"> gitlab.srg.cl.cam.ac.uk.key</span><span class="z-8"> -out</span><span class="z-2"> gitlab.srg.cl.cam.ac.uk.csr</span></span>
<span class="giallo-l"><span class="z-1">cd</span><span class="z-2"> ssl</span></span>
<span class="giallo-l"><span class="z-1">chmod</span><span class="z-9"> 600</span><span class="z-1"> *</span></span>
<span class="giallo-l"><span class="z-1">openssl</span><span class="z-2"> x509</span><span class="z-8"> -req -days</span><span class="z-9"> 1460</span><span class="z-8"> -in</span><span class="z-2"> gitlab.srg.cl.cam.ac.uk.csr</span><span class="z-8"> -signkey</span><span class="z-2"> gitlab.srg.cl.cam.ac.uk.key</span><span class="z-8"> -out</span><span class="z-2"> gitlab.srg.cl.cam.ac.uk.crt</span></span></code></pre><h2><a href="https://mort.io/rss.xml#run-backups" class="zola-anchor" aria-label="Anchor link for: run-backups">Run Backups</a></h2>
<ul>
<li><code>backup</code> script to create backup tarballs and extract</li>
<li><code>sync</code> script to rsync extracted tarballs to filer</li>
</ul>
<h2><a href="https://mort.io/rss.xml#recovering-password" class="zola-anchor" aria-label="Anchor link for: recovering-password">Recovering Password</a></h2>
<p>To change the <code>root</code> password you need to use the Ruby-on-Rails console to
access the relevant object, modify it, and save it back:</p>
<pre class="giallo z-code"><code data-lang="ruby"><span class="giallo-l"><span>gitlab</span><span class="z-5">-</span><span>rails console production</span></span>
<span class="giallo-l"></span>
<span class="giallo-l"><span class="z-1">irb</span><span>(main):</span><span class="z-9">001</span><span>:</span><span class="z-9">0</span><span class="z-5">&gt;</span><span> user </span><span class="z-5">= User</span><span>.</span><span class="z-1">where</span><span>(</span><span class="z-7">id:</span><span class="z-9"> 1</span><span>).</span><span class="z-1">first</span></span>
<span class="giallo-l"><span>=&gt;</span><span class="z-3 z-i"> #&lt;User id: 1, email: "admin@example.com", created_at: "2016-11-16 22:57:21", updated_at: "2016-12-05 23:42:50", name: "Administrator", admin: true, projects_limit: 10, skype: "", linkedin: "", twitter: "", authentication_token: "secrettoken", theme_id: 2, bio: nil, username: "root", can_create_group: true, can_create_team: false, state: "active", color_scheme_id: 1, password_expires_at: nil, created_by_id: nil, last_credential_check_at: nil, avatar: nil, hide_no_ssh_key: false, website_url: "", notification_email: "admin@example.com", hide_no_password: false, password_automatically_set: false, location: nil, encrypted_otp_secret: nil, encrypted_otp_secret_iv: nil, encrypted_otp_secret_salt: nil, otp_required_for_login: false, otp_backup_codes: nil, public_email: "", dashboard: 0, project_view: 0, consumed_timestep: nil, layout: 0, hide_project_limit: false, otp_grace_period_started_at: nil, ldap_email: false, external: false, organization: nil&gt;</span></span>
<span class="giallo-l"><span class="z-1">irb</span><span>(main):</span><span class="z-9">002</span><span>:</span><span class="z-9">0</span><span class="z-5">&gt;</span><span> user.</span><span class="z-1">password</span><span class="z-5"> =</span><span class="z-2"> 'secretpassword'</span></span>
<span class="giallo-l"><span>=&gt;</span><span class="z-2"> "secretpassword"</span></span>
<span class="giallo-l"><span class="z-1">irb</span><span>(main):</span><span class="z-9">003</span><span>:</span><span class="z-9">0</span><span class="z-5">&gt;</span><span> user.</span><span class="z-1">password_confirmation</span><span class="z-5"> =</span><span class="z-2"> 'secretpassword'</span></span>
<span class="giallo-l"><span>=&gt;</span><span class="z-2"> "secretpassword"</span></span>
<span class="giallo-l"><span class="z-1">irb</span><span>(main):</span><span class="z-9">004</span><span>:</span><span class="z-9">0</span><span class="z-5">&gt;</span><span> user.</span><span class="z-1">save!</span></span>
<span class="giallo-l"><span class="z-1">Enqueued</span><span class="z-5"> ActionMailer</span><span class="z-4">::</span><span class="z-1">DeliveryJob</span><span> (</span><span class="z-1">Job</span><span class="z-7"> ID:</span><span> 5f74573d</span><span class="z-5">-</span><span>dfa2</span><span class="z-5">-</span><span class="z-9">4778</span><span class="z-5">-</span><span>b365</span><span class="z-5">-</span><span>cbebd88e454e) to </span><span class="z-1">Sidekiq</span><span>(mailers) with </span><span class="z-7">arguments:</span><span class="z-2"> "DeviseMailer"</span><span>,</span><span class="z-2"> "password_change"</span><span>,</span><span class="z-2"> "deliver_now"</span><span>,</span><span class="z-7"> gid:</span><span class="z-5">//</span><span>gitlab</span><span class="z-5">/</span><span class="z-1">User</span><span class="z-5">/</span><span class="z-9">1</span></span>
<span class="giallo-l"><span>=&gt;</span><span class="z-7"> true</span></span>
<span class="giallo-l"><span class="z-1">irb</span><span>(main):</span><span class="z-9">005</span><span>:</span><span class="z-9">0</span><span class="z-5">&gt;</span></span>
<span class="giallo-l"></span>
<span class="giallo-l"><span>gitlab</span><span class="z-5">-</span><span>ctl reconfigure</span></span></code></pre><h2><a href="https://mort.io/rss.xml#hook-up-to-github" class="zola-anchor" aria-label="Anchor link for: hook-up-to-github">Hook up to GitHub</a></h2>
<p>Per
<a href="https://docs.gitlab.com/ce/integration/omniauth.html#initial-omniauth-configuration" rel="external">https://docs.gitlab.com/ce/integration/omniauth.html#initial-omniauth-configuration</a> and
<a href="https://docs.gitlab.com/ce/integration/github.html" rel="external">https://docs.gitlab.com/ce/integration/github.html</a>:</p>
<p>Edit via <code>sudo docker exec -it gitlab /bin/bash</code>:</p>
<pre class="giallo z-code"><code data-lang="shellscript"><span class="giallo-l"><span class="z-1">root@gitlab:/#</span><span class="z-2"> vi /etc/gitlab/gitlab.rb</span></span></code></pre><pre class="giallo z-code"><code data-lang="ruby"><span class="giallo-l"><span>gitlab_rails[</span><span class="z-2">'omniauth_enabled'</span><span>]</span><span class="z-5"> =</span><span class="z-7"> true</span></span>
<span class="giallo-l"><span>gitlab_rails[</span><span class="z-2">'omniauth_allow_single_sign_on'</span><span>]</span><span class="z-5"> =</span><span> [</span><span class="z-2">'saml'</span><span>,</span><span class="z-2"> 'github'</span><span>]</span></span>
<span class="giallo-l"><span>gitlab_rails[</span><span class="z-2">'omniauth_block_auto_created_users'</span><span>]</span><span class="z-5"> =</span><span class="z-7"> true</span></span></code></pre><h2><a href="https://mort.io/rss.xml#email" class="zola-anchor" aria-label="Anchor link for: email">Email</a></h2>
<p>Use SMTP via &lt;ppsw.cam.ac.uk&gt;, for which the from address must have a valid <code>MX</code>
record <strong>and</strong> not be under &lt;cam.ac.uk&gt; per
<a href="http://help.uis.cam.ac.uk/email-telephony-and-collaboration/email/technical/sending" rel="external">http://help.uis.cam.ac.uk/email-telephony-and-collaboration/email/technical/sending</a>.</p>
<p>Configuration can be tested via the console:</p>
<pre class="giallo z-code"><code data-lang="ruby"><span class="giallo-l"><span class="z-5">Notify</span><span>.</span><span class="z-1">test_email</span><span>(</span><span class="z-2">'your@email.address, '</span><span class="z-1">Hello World</span><span class="z-2">', '</span><span class="z-1">This</span><span> is a </span><span class="z-1">test</span><span> message</span><span class="z-2">').deliver_now</span></span></code></pre>

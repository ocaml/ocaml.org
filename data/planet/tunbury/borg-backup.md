---
title: Borg Backup
description: "Our PeerTube installation at watch.ocaml.org holds hundreds of videos
  we wouldn\u2019t want to lose! It\u2019s a VM hosted at Scaleway so the chances
  of a loss are pretty small, but having a second copy would give us extra reassurance.
  I\u2019m going to use Borg Backup."
url: https://www.tunbury.org/2025/06/14/borg-backup/
date: 2025-06-14T00:00:00-00:00
preview_image: https://www.tunbury.org/images/borg-logo.png
authors:
- Mark Elvers
source:
ignore:
---

<p>Our PeerTube installation at <a href="https://watch.ocaml.org/">watch.ocaml.org</a> holds hundreds of videos we wouldn’t want to lose! It’s a VM hosted at Scaleway so the chances of a loss are pretty small, but having a second copy would give us extra reassurance. I’m going to use <a href="https://www.borgbackup.org">Borg Backup</a>.</p>

<p>Here’s the list of features (taken directly from their website):</p>

<ul>
  <li>Space-efficient storage of backups.</li>
  <li>Secure, authenticated encryption.</li>
  <li>Compression: lz4, zstd, zlib, lzma or none.</li>
  <li>Mountable backups with FUSE.</li>
  <li>Easy installation on multiple platforms: Linux, macOS, BSD, …</li>
  <li>Free software (BSD license).</li>
  <li>Backed by a large and active open source community.</li>
</ul>

<p>We have several OBuilder workers with one or more unused hard disks, which would make ideal backup targets.</p>

<p>In this case, I will format and mount <code class="language-plaintext highlighter-rouge">sdc</code> as <code class="language-plaintext highlighter-rouge">/home</code> on one of the workers.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>parted /dev/sdc mklabel gpt
parted /dev/sdc mkpart primary ext4 0% 100%
mkfs.ext4 /dev/sdc1
</code></pre></div></div>

<p>Add this to /etc/fstab and run <code class="language-plaintext highlighter-rouge">mount -a</code>.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>/dev/sdc1 /home ext4 defaults 0 2
</code></pre></div></div>

<p>Create a user <code class="language-plaintext highlighter-rouge">borg</code>.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>adduser <span class="nt">--disabled-password</span> <span class="nt">--gecos</span> <span class="s1">'@borg'</span> <span class="nt">--home</span> /home/borg borg
</code></pre></div></div>

<p>On both machines, install the application <code class="language-plaintext highlighter-rouge">borg</code>.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>apt <span class="nb">install </span>borgbackup
</code></pre></div></div>

<p>On the machine we want to backup, generate an SSH key and copy it to the <code class="language-plaintext highlighter-rouge">authorized_keys</code> file for user <code class="language-plaintext highlighter-rouge">borg</code> on the target server. Ensure that <code class="language-plaintext highlighter-rouge">chmod</code> and <code class="language-plaintext highlighter-rouge">chown</code> are correct.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>ssh-keygen <span class="nt">-t</span> ed25519 <span class="nt">-f</span> ~/.ssh/borg_backup_key
</code></pre></div></div>

<p>Add lines to the <code class="language-plaintext highlighter-rouge">.ssh/config</code> for ease of connection. We can now <code class="language-plaintext highlighter-rouge">ssh backup-server</code> without any prompts.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>Host backup-server
    HostName your.backup.server.com
    User borg
    IdentityFile ~/.ssh/borg_backup_key
    ServerAliveInterval 60
    ServerAliveCountMax 3
</code></pre></div></div>

<p>Borg supports encrypting the backup at rest on the target machine. The data is publicly available in this case, so encryption seems unnecessary.</p>

<p>On the machine to be backed up, run.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>borg init <span class="nt">--encryption</span><span class="o">=</span>none backup-server:repo
</code></pre></div></div>

<p>We can now perform a backup or two and see how the deduplication works.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c"># borg create backup-server:repo::test /var/lib/docker/volumes/postgres --compression lz4 --stats --progress</span>
<span class="nt">------------------------------------------------------------------------------</span>
Repository: ssh://backup-server/./repo
Archive name: <span class="nb">test
</span>Archive fingerprint: 627242cb5b65efa23672db317b4cdc8617a78de4d8e195cdd1e1358ed02dd937
Time <span class="o">(</span>start<span class="o">)</span>: Sat, 2025-06-14 13:32:27
Time <span class="o">(</span>end<span class="o">)</span>:   Sat, 2025-06-14 13:32:38
Duration: 11.03 seconds
Number of files: 3497
Utilization of max. archive size: 0%
<span class="nt">------------------------------------------------------------------------------</span>
                       Original size      Compressed size    Deduplicated size
This archive:              334.14 MB            136.28 MB            132.79 MB
All archives:              334.14 MB            136.28 MB            132.92 MB

                       Unique chunks         Total chunks
Chunk index:                     942                 1568
<span class="nt">------------------------------------------------------------------------------</span>
<span class="c"># borg create backup-server:repo::test2 /var/lib/docker/volumes/postgres --compression lz4 --stats --progress</span>
<span class="nt">------------------------------------------------------------------------------</span>
Repository: ssh://backup-server/./repo
Archive name: test2
Archive fingerprint: 572bf2225b3ab19afd32d44f058a49dc2b02cb70c8833fa0b2a1fb5b95526bff
Time <span class="o">(</span>start<span class="o">)</span>: Sat, 2025-06-14 13:33:05
Time <span class="o">(</span>end<span class="o">)</span>:   Sat, 2025-06-14 13:33:06
Duration: 1.43 seconds
Number of files: 3497
Utilization of max. archive size: 0%
<span class="nt">------------------------------------------------------------------------------</span>
                       Original size      Compressed size    Deduplicated size
This archive:              334.14 MB            136.28 MB              9.58 MB
All archives:              668.28 MB            272.55 MB            142.61 MB

                       Unique chunks         Total chunks
Chunk index:                     971                 3136
<span class="nt">------------------------------------------------------------------------------</span>
<span class="c"># borg list backup-server:repo</span>
<span class="nb">test                                 </span>Sat, 2025-06-14 13:32:27 <span class="o">[</span>627242cb5b65efa23672db317b4cdc8617a78de4d8e195cdd1e1358ed02dd937]
test2                                Sat, 2025-06-14 13:33:05 <span class="o">[</span>572bf2225b3ab19afd32d44f058a49dc2b02cb70c8833fa0b2a1fb5b95526bff]
</code></pre></div></div>

<p>Let’s run this every day via by placing a script <code class="language-plaintext highlighter-rouge">borgbackup</code> in <code class="language-plaintext highlighter-rouge">/etc/cron.daily</code>. The paths given are just examples…</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c">#!/bin/bash</span>

<span class="c"># Configuration</span>
<span class="nv">REPOSITORY</span><span class="o">=</span><span class="s2">"backup-server:repo"</span>

<span class="c"># What to backup</span>
<span class="nv">BACKUP_PATHS</span><span class="o">=</span><span class="s2">"
/home
"</span>

<span class="c"># What to exclude</span>
<span class="nv">EXCLUDE_ARGS</span><span class="o">=</span><span class="s2">"
--exclude '*.tmp'
--exclude '*.log'
"</span>

<span class="c"># Logging function</span>
log<span class="o">()</span> <span class="o">{</span>
    logger <span class="nt">-t</span> <span class="s2">"borg-backup"</span> <span class="s2">"</span><span class="nv">$1</span><span class="s2">"</span>
    <span class="nb">echo</span> <span class="s2">"</span><span class="si">$(</span><span class="nb">date</span> <span class="s1">'+%Y-%m-%d %H:%M:%S'</span><span class="si">)</span><span class="s2"> - </span><span class="nv">$1</span><span class="s2">"</span>
<span class="o">}</span>

log <span class="s2">"========================================"</span>
log <span class="s2">"Starting Borg backup"</span>

<span class="c"># Check if borg is installed</span>
<span class="k">if</span> <span class="o">!</span> <span class="nb">command</span> <span class="nt">-v</span> borg &amp;&gt; /dev/null<span class="p">;</span> <span class="k">then
    </span>log <span class="s2">"ERROR: borg command not found"</span>
    <span class="nb">exit </span>1
<span class="k">fi</span>

<span class="c"># Test repository access</span>
<span class="k">if</span> <span class="o">!</span> borg info <span class="s2">"</span><span class="nv">$REPOSITORY</span><span class="s2">"</span> &amp;&gt; /dev/null<span class="p">;</span> <span class="k">then
    </span>log <span class="s2">"ERROR: Cannot access repository </span><span class="nv">$REPOSITORY</span><span class="s2">"</span>
    log <span class="s2">"Make sure repository exists and SSH key is set up"</span>
    <span class="nb">exit </span>1
<span class="k">fi</span>

<span class="c"># Create backup</span>
log <span class="s2">"Creating backup archive..."</span>
<span class="k">if </span>borg create <span class="se">\</span>
    <span class="s2">"</span><span class="nv">$REPOSITORY</span><span class="s2">::backup-{now}"</span> <span class="se">\</span>
    <span class="nv">$BACKUP_PATHS</span> <span class="se">\</span>
    <span class="nv">$EXCLUDE_ARGS</span> <span class="se">\</span>
    <span class="nt">--compression</span> lz4 <span class="se">\</span>
    <span class="nt">--stats</span> 2&gt;&amp;1 | logger <span class="nt">-t</span> <span class="s2">"borg-backup"</span><span class="p">;</span> <span class="k">then
    </span>log <span class="s2">"Backup created successfully"</span>
<span class="k">else
    </span>log <span class="s2">"ERROR: Backup creation failed"</span>
    <span class="nb">exit </span>1
<span class="k">fi</span>

<span class="c"># Prune old backups</span>
log <span class="s2">"Pruning old backups..."</span>
<span class="k">if </span>borg prune <span class="s2">"</span><span class="nv">$REPOSITORY</span><span class="s2">"</span> <span class="se">\</span>
    <span class="nt">--keep-daily</span><span class="o">=</span>7 <span class="se">\</span>
    <span class="nt">--keep-weekly</span><span class="o">=</span>4 <span class="se">\</span>
    <span class="nt">--keep-monthly</span><span class="o">=</span>6 <span class="se">\</span>
    <span class="nt">--stats</span> 2&gt;&amp;1 | logger <span class="nt">-t</span> <span class="s2">"borg-backup"</span><span class="p">;</span> <span class="k">then
    </span>log <span class="s2">"Pruning completed successfully"</span>
<span class="k">else
    </span>log <span class="s2">"WARNING: Pruning failed, but backup was successful"</span>
<span class="k">fi</span>

<span class="c"># Monthly repository check (on the 1st of each month)</span>
<span class="k">if</span> <span class="o">[</span> <span class="s2">"</span><span class="si">$(</span><span class="nb">date</span> +%d<span class="si">)</span><span class="s2">"</span> <span class="o">=</span> <span class="s2">"01"</span> <span class="o">]</span><span class="p">;</span> <span class="k">then
    </span>log <span class="s2">"Running monthly repository check..."</span>
    <span class="k">if </span>borg check <span class="s2">"</span><span class="nv">$REPOSITORY</span><span class="s2">"</span> 2&gt;&amp;1 | logger <span class="nt">-t</span> <span class="s2">"borg-backup"</span><span class="p">;</span> <span class="k">then
        </span>log <span class="s2">"Repository check passed"</span>
    <span class="k">else
        </span>log <span class="s2">"WARNING: Repository check failed"</span>
    <span class="k">fi
fi

</span>log <span class="s2">"Backup completed successfully"</span>
log <span class="s2">"========================================"</span>
</code></pre></div></div>

<p>Check the logs…</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>journalctl <span class="nt">-t</span> borg-backup
</code></pre></div></div>
